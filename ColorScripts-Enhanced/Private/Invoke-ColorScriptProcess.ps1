function Invoke-ColorScriptProcess {
    <#
    .SYNOPSIS
        Executes a colorscript and captures its output.
        For cache building, uses fast in-process execution.
        For display, can use isolated process if needed.
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

    # Fast in-process execution for cache building
    if ($ForCache) {
        try {
            $oldLocation = Get-Location -PSProvider FileSystem
            $scriptDirectory = [System.IO.Path]::GetDirectoryName($ScriptPath)
            if ($scriptDirectory) {
                Set-Location -LiteralPath $scriptDirectory -ErrorAction SilentlyContinue
            }

            $scriptContent = & $script:FileReadAllTextDelegate $ScriptPath $script:Utf8NoBomEncoding
            $scriptBlock = [ScriptBlock]::Create($scriptContent)

            $output = & $scriptBlock *>&1 | Out-String

            $result.StdOut = $output
            $result.ExitCode = 0
            $result.Success = $true
        }
        catch {
            $result.StdErr = $_.Exception.Message
            $result.ExitCode = 1
            $result.Success = $false
        }
        finally {
            if ($oldLocation) {
                Set-Location -LiteralPath $oldLocation -ErrorAction SilentlyContinue
            }
        }

        return $result
    }

    # Original isolated process execution for display
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
        $null = $commandBuilder.Append("& ([ScriptBlock]::Create([System.IO.File]::ReadAllText('$escapedScriptPath', [System.Text.Encoding]::UTF8)))")

        $encodedCommand = $commandBuilder.ToString()
        $startInfo.Arguments = "-NoProfile -NonInteractive -Command `"$encodedCommand`""
        $startInfo.UseShellExecute = $false
        $startInfo.RedirectStandardOutput = $true
        $startInfo.RedirectStandardError = $true
        $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
        $startInfo.StandardErrorEncoding = [System.Text.Encoding]::UTF8

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
