function Import-DynamicColorScriptNameSet {
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.HashSet[string]])]
    param(
        [Parameter(Mandatory)]
        [string]$PolicyPath
    )

    $nameSet = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
    try {
        $policy = Import-PowerShellDataFile -LiteralPath $PolicyPath -ErrorAction Stop
        if ($policy -is [hashtable] -and
            $policy.DynamicScripts -isnot [string] -and
            $policy.DynamicScripts -is [System.Collections.IEnumerable]) {
            foreach ($scriptName in $policy.DynamicScripts) {
                $name = [string]$scriptName
                if (-not [string]::IsNullOrWhiteSpace($name)) {
                    $null = $nameSet.Add($name)
                }
            }
        }
    }
    catch {
        # An invalid or missing policy must never authorize in-process script execution.
        Write-Verbose ("Unable to load dynamic render policy '{0}': {1}" -f $PolicyPath, $_.Exception.Message)
    }

    Write-Output -NoEnumerate -InputObject $nameSet
}

function Get-ColorScriptDynamicNameSet {
    <#
    .SYNOPSIS
        Loads the explicit allowlist of bundled scripts that intentionally produce live output.
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.HashSet[string]])]
    param()

    $policyPath = Join-Path -Path $script:ModuleRoot -ChildPath 'DynamicRenderPolicy.psd1'
    $policyLastWriteTime = $null
    try {
        $policyLastWriteTime = (Get-Item -LiteralPath $policyPath -ErrorAction Stop).LastWriteTimeUtc
    }
    catch {
        Write-Verbose ("Unable to read dynamic render policy '{0}': {1}" -f $policyPath, $_.Exception.Message)
    }

    if ($script:DynamicColorScriptNameSet -and
        $script:DynamicRenderPolicyLastWriteTime -and
        $policyLastWriteTime -eq $script:DynamicRenderPolicyLastWriteTime) {
        Write-Output -NoEnumerate -InputObject $script:DynamicColorScriptNameSet
        return
    }

    $nameSet = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
    if ($policyLastWriteTime) {
        $nameSet = Import-DynamicColorScriptNameSet -PolicyPath $policyPath
    }

    $script:DynamicColorScriptNameSet = $nameSet
    $script:DynamicRenderPolicyLastWriteTime = $policyLastWriteTime
    Write-Output -NoEnumerate -InputObject $script:DynamicColorScriptNameSet
}

function Test-ColorScriptIsTrustedDynamic {
    <#
    .SYNOPSIS
        Verifies that a path is an allowlisted, non-link file in the bundled Scripts directory.
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )

    if ([string]::IsNullOrWhiteSpace($ScriptPath) -or
        [string]::IsNullOrWhiteSpace($script:ScriptsPath)) {
        return $false
    }

    $scriptName = [System.IO.Path]::GetFileNameWithoutExtension($ScriptPath)
    if ([string]::IsNullOrWhiteSpace($scriptName) -or
        -not (Get-ColorScriptDynamicNameSet).Contains($scriptName)) {
        return $false
    }

    return Test-ColorScriptIsBundledPath -ScriptPath $ScriptPath -ScriptName $scriptName
}
