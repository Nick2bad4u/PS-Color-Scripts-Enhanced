function Invoke-ColorScriptChildProcess {
    <#
    .SYNOPSIS
        Executes an unknown or custom colorscript in a separate PowerShell process.

    .DESCRIPTION
        A process boundary prevents colorscript functions, variables, aliases, and location
        changes from leaking into the caller. It is not a security sandbox: the child process has
        the same operating-system permissions as the current user.
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

        # Drain both redirected streams concurrently. Reading one stream to completion before the
        # other can deadlock when a renderer fills the second process pipe.
        $supportsAsyncRead = (
            $process.StandardOutput.PSObject.Methods['ReadToEndAsync'] -and
            $process.StandardError.PSObject.Methods['ReadToEndAsync'])
        if ($supportsAsyncRead) {
            $outputTask = $process.StandardOutput.ReadToEndAsync()
            $errorTask = $process.StandardError.ReadToEndAsync()
        }

        $process.WaitForExit()

        if ($supportsAsyncRead) {
            $output = $outputTask.GetAwaiter().GetResult()
            $errorOutput = $errorTask.GetAwaiter().GetResult()
        }
        else {
            # Test doubles and older custom stream implementations may expose only ReadToEnd.
            $output = $process.StandardOutput.ReadToEnd()
            $errorOutput = $process.StandardError.ReadToEnd()
        }

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
