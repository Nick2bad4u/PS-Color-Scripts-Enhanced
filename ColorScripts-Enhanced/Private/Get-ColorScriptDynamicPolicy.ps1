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
        try {
            $policy = Import-PowerShellDataFile -Path $policyPath -ErrorAction Stop
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
            Write-Verbose ("Unable to load dynamic render policy '{0}': {1}" -f $policyPath, $_.Exception.Message)
        }
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

    try {
        $actualItem = Get-Item -LiteralPath $ScriptPath -Force -ErrorAction Stop
        $expectedPath = Join-Path -Path $script:ScriptsPath -ChildPath ($scriptName + '.ps1')
        $expectedItem = Get-Item -LiteralPath $expectedPath -Force -ErrorAction Stop

        if ($actualItem.PSIsContainer -or $expectedItem.PSIsContainer) {
            return $false
        }

        $reparsePoint = [System.IO.FileAttributes]::ReparsePoint
        if (($actualItem.Attributes -band $reparsePoint) -ne 0 -or
            ($expectedItem.Attributes -band $reparsePoint) -ne 0) {
            return $false
        }

        $actualPath = (Resolve-Path -LiteralPath $actualItem.FullName -ErrorAction Stop).ProviderPath
        $expectedResolvedPath = (Resolve-Path -LiteralPath $expectedItem.FullName -ErrorAction Stop).ProviderPath
        $comparison = if ([System.IO.Path]::DirectorySeparatorChar -eq '\') {
            [System.StringComparison]::OrdinalIgnoreCase
        }
        else {
            [System.StringComparison]::Ordinal
        }

        return [string]::Equals($actualPath, $expectedResolvedPath, $comparison)
    }
    catch {
        Write-Verbose ("Unable to validate dynamic colorscript path '{0}': {1}" -f $ScriptPath, $_.Exception.Message)
        return $false
    }
}
