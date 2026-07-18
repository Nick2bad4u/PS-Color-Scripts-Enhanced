function Get-ColorScriptCacheableNameSet {
    <#
    .SYNOPSIS
        Loads the curated set of colorscripts whose rendered output should be cached.
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.HashSet[string]])]
    param()

    $policyPath = Join-Path -Path $script:ModuleRoot -ChildPath 'CachePolicy.psd1'
    $policyLastWriteTime = $null

    try {
        $policyLastWriteTime = (Get-Item -LiteralPath $policyPath -ErrorAction Stop).LastWriteTimeUtc
    }
    catch {
        Write-Verbose ("Unable to read cache policy '{0}': {1}" -f $policyPath, $_.Exception.Message)
    }

    if ($script:CacheableScriptNameSet -and
        $script:CachePolicyLastWriteTime -and
        $policyLastWriteTime -eq $script:CachePolicyLastWriteTime) {
        return , $script:CacheableScriptNameSet
    }

    $nameSet = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)

    if ($policyLastWriteTime) {
        try {
            $policy = Import-PowerShellDataFile -Path $policyPath -ErrorAction Stop
            if ($policy -is [hashtable] -and $policy.CacheableScripts -is [System.Collections.IEnumerable]) {
                foreach ($scriptName in $policy.CacheableScripts) {
                    $name = [string]$scriptName
                    if (-not [string]::IsNullOrWhiteSpace($name)) {
                        $null = $nameSet.Add($name)
                    }
                }
            }
        }
        catch {
            # A missing or invalid policy must never broaden caching. Direct execution is the safe fallback.
            Write-Verbose ("Unable to load cache policy '{0}': {1}" -f $policyPath, $_.Exception.Message)
        }
    }

    $script:CacheableScriptNameSet = $nameSet
    $script:CachePolicyLastWriteTime = $policyLastWriteTime

    return , $script:CacheableScriptNameSet
}

function Test-ColorScriptRequiresCache {
    <#
    .SYNOPSIS
        Determines whether a colorscript is included in the curated output-cache policy.

    .DESCRIPTION
        The policy intentionally opts in computational renderers whose loops, math, and helper
        functions make repeated execution expensive. Static output scripts and unknown custom
        scripts execute directly and do not create cache entries.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    if ([string]::IsNullOrWhiteSpace($ScriptPath)) {
        return $false
    }

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    if ([string]::IsNullOrWhiteSpace($scriptName)) {
        return $false
    }

    $cacheableNames = Get-ColorScriptCacheableNameSet
    return $cacheableNames.Contains($scriptName)
}
