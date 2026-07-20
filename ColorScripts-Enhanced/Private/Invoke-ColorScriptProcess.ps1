function Invoke-ColorScriptProcess {
    <#
    .SYNOPSIS
        Captures colorscript output through the cheapest safe execution route.

    .DESCRIPTION
        Statically extractable scripts are returned without execution. Explicitly allowlisted
        bundled dynamic scripts run in an isolated in-process runspace. Unknown or custom scripts
        retain a child-process boundary because a runspace is not a security boundary.
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath,

        [switch]$ForCache
    )

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    if (-not (Test-Path -LiteralPath $ScriptPath -PathType Leaf)) {
        return [pscustomobject]@{
            ScriptName = $scriptName
            StdOut     = ''
            StdErr     = $script:Messages.ScriptPathNotFound
            ExitCode   = $null
            Success    = $false
        }
    }

    if (-not $ForCache) {
        $staticOutput = Get-StaticColorScriptOutput -ScriptPath $ScriptPath
        if ($staticOutput.Available) {
            return [pscustomobject]@{
                ScriptName = $scriptName
                StdOut     = $staticOutput.Content
                StdErr     = ''
                ExitCode   = 0
                Success    = $true
            }
        }
    }

    if (Test-ColorScriptIsTrustedDynamic -ScriptPath $ScriptPath) {
        return Invoke-ColorScriptInProcess -ScriptPath $ScriptPath
    }

    return Invoke-ColorScriptChildProcess -ScriptPath $ScriptPath -ForCache:$ForCache
}
