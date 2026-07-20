function Invoke-ColorScriptInProcess {
    <#
    .SYNOPSIS
        Executes a trusted bundled dynamic colorscript in an isolated in-process runspace.

    .DESCRIPTION
        The runspace prevents functions, variables, aliases, and location changes from leaking
        into the caller while avoiding PowerShell process startup. Callers must enforce the
        bundled dynamic policy before invoking this function.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
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

    $powerShell = $null
    try {
        $powerShell = [System.Management.Automation.PowerShell]::Create()
        $scriptDirectory = [System.IO.Path]::GetDirectoryName($ScriptPath)
        $null = $powerShell.AddScript((Get-ColorScriptCaptureCommand), $false)
        $null = $powerShell.AddArgument($ScriptPath)
        $null = $powerShell.AddArgument($scriptDirectory)

        $invocationOutput = $powerShell.Invoke()
        $outputBuilder = New-Object System.Text.StringBuilder
        foreach ($item in $invocationOutput) {
            $null = $outputBuilder.Append([string]$item)
        }

        $result.StdOut = $outputBuilder.ToString()
        if ($powerShell.HadErrors -or $powerShell.Streams.Error.Count -gt 0) {
            $result.ExitCode = 1
            $result.StdErr = (@(
                    $powerShell.Streams.Error | ForEach-Object { $_.ToString() }
                ) -join [Environment]::NewLine)
            return $result
        }

        $result.ExitCode = 0
        $result.Success = $true
    }
    catch {
        $result.ExitCode = 1
        $result.StdErr = $_.Exception.Message
    }
    finally {
        if ($powerShell) {
            $powerShell.Dispose()
        }
    }

    return $result
}
