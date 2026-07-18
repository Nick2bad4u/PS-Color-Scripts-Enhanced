function Invoke-ColorScriptProcess {
    <#
    .SYNOPSIS
        Executes a colorscript and captures its output using an isolated process
        to preserve ANSI sequences and console rendering fidelity.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath,

        [switch]$ForCache
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)

    $result = [pscustomobject]@{
        ScriptName = $scriptName
        StdOut     = ''
        StdErr     = ''
        ExitCode   = $null
        Success    = $false
    }

    if (-not (Test-Path -LiteralPath $ScriptPath)) {
        $result.StdErr = $script:Messages.ScriptPathNotFound
        return $result
    }

    if (-not $ForCache) {
        $staticOutput = Get-StaticColorScriptOutput -ScriptPath $ScriptPath
        if ($staticOutput.Available) {
            $result.StdOut = $staticOutput.Content
            $result.ExitCode = 0
            $result.Success = $true
            return $result
        }
    }

    $executable = Get-PowerShellExecutable
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($ScriptPath)
    $process = $null

    try {
        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = $executable

        $escapedScriptPath = $ScriptPath.Replace("'", "''")
        $escapedScriptDir = if ($scriptDirectory) { $scriptDirectory.Replace("'", "''") } else { $null }
        $commandBuilder = New-Object System.Text.StringBuilder
        $null = $commandBuilder.Append("[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; ")
        if ($escapedScriptDir) {
            $null = $commandBuilder.Append("Set-Location -LiteralPath '$escapedScriptDir'; ")
        }

        # ConsoleHost spends most of the runtime parsing thousands of ANSI sequences emitted by
        # Write-Host, only to strip them because stdout is redirected. Shadow Write-Host inside the
        # isolated child process, preserve its plain-text and -NoNewline semantics, and normalize
        # ANSI once after the script completes. The script remains process-isolated.
        $null = $commandBuilder.Append(@'
$__cseOutputBuilder = [System.Text.StringBuilder]::new();
function Write-Host {
    param(
        [Parameter(Position = 0, ValueFromPipeline, ValueFromRemainingArguments)]
        [object[]]$Object,
        [object]$Separator = ' ',
        [switch]$NoNewline,
        [System.ConsoleColor]$ForegroundColor,
        [System.ConsoleColor]$BackgroundColor
    )
    process {
        $null = $ForegroundColor, $BackgroundColor;
        $__cseText = if ($null -eq $Object) { '' } else { [string]::Join([string]$Separator, $Object) };
        $null = $__cseOutputBuilder.Append($__cseText);
        if (-not $NoNewline) { $null = $__cseOutputBuilder.Append([Environment]::NewLine) };
    }
};
'@)
        $null = $commandBuilder.Append("`$__csePipelineOutput = & ([ScriptBlock]::Create([System.IO.File]::ReadAllText('$escapedScriptPath', [System.Text.Encoding]::UTF8))); ")
        $null = $commandBuilder.Append(@'
foreach ($__cseItem in $__csePipelineOutput) { $null = $__cseOutputBuilder.AppendLine([string]$__cseItem) };
$__cseAnsiPattern = ([string][char]27) + '\[[0-9;]*[A-Za-z]';
[Console]::Out.Write([System.Text.RegularExpressions.Regex]::Replace($__cseOutputBuilder.ToString(), $__cseAnsiPattern, ''));
'@)

        $commandText = $commandBuilder.ToString()
        $commandBytes = [System.Text.Encoding]::Unicode.GetBytes($commandText)
        $encodedCommand = [Convert]::ToBase64String($commandBytes)
        $startInfo.Arguments = "-NoLogo -NoProfile -NonInteractive -EncodedCommand $encodedCommand"
        $startInfo.UseShellExecute = $false
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
        $startInfo.StandardErrorEncoding = [System.Text.Encoding]::UTF8

        if ($ForCache) {
            try {
                $startInfo.EnvironmentVariables['COLOR_SCRIPTS_ENHANCED_CACHE_BUILD'] = '1'
            }
            catch {
                Write-Verbose ("Unable to set cache build environment variable: {0}" -f $_.Exception.Message)
            }
        }

        if ($scriptDirectory) {
            $startInfo.WorkingDirectory = $scriptDirectory
        }

        $process = New-Object System.Diagnostics.Process
        $process.StartInfo = $startInfo
        $null = $process.Start()

        $output = $process.StandardOutput.ReadToEnd()
        $errorOutput = $process.StandardError.ReadToEnd()
        $process.WaitForExit()

        $result.ExitCode = $process.ExitCode
        $result.StdOut = $output
        $result.StdErr = $errorOutput
        $result.Success = ($process.ExitCode -eq 0)
    }
    catch {
        $result.StdErr = $_.Exception.Message
    }
    finally {
        if ($process) {
            $process.Dispose()
        }
    }

    return $result
}
