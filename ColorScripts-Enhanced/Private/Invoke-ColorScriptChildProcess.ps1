function Invoke-ColorScriptChildProcess {
    <#
    .SYNOPSIS
        Executes an untrusted or custom colorscript in a separate PowerShell process.

    .DESCRIPTION
        A process boundary remains the safe fallback for scripts outside the bundled dynamic
        policy. Bundled static scripts never reach this function, and explicitly trusted dynamic
        scripts use an isolated in-process runspace instead.
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

    if (-not (Test-Path -LiteralPath $ScriptPath -PathType Leaf)) {
        $result.StdErr = $script:Messages.ScriptPathNotFound
        return $result
    }

    $executable = Get-PowerShellExecutable
    $scriptDirectory = [System.IO.Path]::GetDirectoryName($ScriptPath)
    $process = $null

    try {
        $escapedScriptPath = $ScriptPath.Replace("'", "''")
        $escapedScriptDirectory = if ($scriptDirectory) {
            $scriptDirectory.Replace("'", "''")
        }
        else {
            ''
        }

        $commandBuilder = New-Object System.Text.StringBuilder
        $null = $commandBuilder.AppendLine('[Console]::OutputEncoding = [System.Text.Encoding]::UTF8')
        $null = $commandBuilder.AppendLine('& {')
        $null = $commandBuilder.AppendLine((Get-ColorScriptCaptureCommand))
        $null = $commandBuilder.Append("} -__cseScriptPath '$escapedScriptPath' ")
        $null = $commandBuilder.Append("-__cseScriptDirectory '$escapedScriptDirectory' ")
        $null = $commandBuilder.Append('| ForEach-Object { [Console]::Out.Write([string]$_) }')

        $commandBytes = [System.Text.Encoding]::Unicode.GetBytes($commandBuilder.ToString())
        $encodedCommand = [Convert]::ToBase64String($commandBytes)

        $startInfo = New-Object System.Diagnostics.ProcessStartInfo
        $startInfo.FileName = $executable
        $startInfo.Arguments = "-NoLogo -NoProfile -NonInteractive -EncodedCommand $encodedCommand"
        $startInfo.UseShellExecute = $false
        $startInfo.CreateNoWindow = $true
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
