<#
.SYNOPSIS
    Normalize readme and documentation script-count markers.

.DESCRIPTION
    Replaces custom HTML comment markers (e.g. <!-- COLOR_SCRIPT_COUNT_PLUS -->245+<!-- /COLOR_SCRIPT_COUNT_PLUS -->)
    with the current colorscript counts so the README files stay current when the module is built or published.
    The script can be invoked standalone or from build automation. It defaults to updating the repository README,
    the module README, and a handful of supporting docs that expose the counts.

.PARAMETER ScriptCount
    Optional explicit colorscript count. When omitted the script executes Get-ColorScriptCount.ps1 to determine
    the current number of script files in ColorScripts-Enhanced/Scripts.

.PARAMETER ImagesShown
    How many colorscripts are already displayed in static screenshots in the README. The remaining count is used
    for the "+ N more colorscripts" teaser text. Defaults to 3 (matching the number of screenshots in the demo section).

.PARAMETER CacheCount
    Optional explicit count of policy-selected cacheable renderers. When omitted, the script reads
    CachePolicy.psd1 and counts the unique names in CacheableScripts and CacheablePokemonScripts.

.PARAMETER DynamicCount
    Optional explicit count of intentionally dynamic renderers. When omitted, the script reads
    DynamicRenderPolicy.psd1 and counts the unique names in DynamicScripts.

.PARAMETER ModuleVersion
    Optional explicit module version. When omitted, the script reads ModuleVersion from the checked-in
    ColorScripts-Enhanced.psd1 manifest.

.PARAMETER Files
    Paths to the markdown files that should be updated. Paths are resolved relative to the repository root when
    they are not already absolute. Non-existent files are ignored with a verbose notice.

.EXAMPLE
    pwsh -NoProfile -File ./scripts/Update-DocumentationCounts.ps1

.EXAMPLE
    pwsh -NoProfile -File ./scripts/Update-DocumentationCounts.ps1 -ScriptCount 255 -Verbose

.NOTES
    The script updates the following markers:
        <!-- COLOR_SCRIPT_COUNT_PLUS -->   -> {count}+ (text with trailing plus)
        <!-- COLOR_SCRIPT_COUNT_MINUS_IMAGES --> -> {max(count - ImagesShown, 0)}
        <!-- COLOR_CACHE_TOTAL -->         -> {cache count} (policy-selected cacheable renderers)
        <!-- COLOR_DYNAMIC_TOTAL -->       -> {dynamic count} (intentionally variable renderers)
        <!-- COLOR_MODULE_VERSION -->      -> {module manifest version}
        <!-- COLOR_SCRIPT_COUNT -->        -> {count} (exact numeric)
    Additional markers can be added by extending the $replacements dictionary.
#>
[CmdletBinding()]
param(
    [Parameter()]
    [int]$ScriptCount,

    [Parameter()]
    [ValidateRange(0, 100)]
    [int]$ImagesShown = 3,

    [Parameter()]
    [ValidateRange(0, [int]::MaxValue)]
    [int]$CacheCount,

    [Parameter()]
    [ValidateRange(0, [int]::MaxValue)]
    [int]$DynamicCount,

    [Parameter()]
    [string]$ModuleVersion,

    [Parameter()]
    [string[]]$Files = @(
        'README.md',
        'ColorScripts-Enhanced/README.md',
        'ColorScripts-Enhanced/README-Gallery.md',
        'docs/MODULE_SUMMARY.md',
        'docs/MEGALINTER-SETUP.md',
        'docs/DEVELOPMENT.md',
        'docs/NPM_SCRIPTS.md',
        'docs/QUICK_REFERENCE.md',
        'docs/DOCUMENTATION_INDEX.md',
        'docs/PUBLISHING.md',
        'docs/ROADMAP.md',
        'ColorScripts-Enhanced/docs/MODULE_SUMMARY.md',
        'ColorScripts-Enhanced/docs/MEGALINTER-SETUP.md',
        'ColorScripts-Enhanced/docs/DEVELOPMENT.md',
        'ColorScripts-Enhanced/docs/NPM_SCRIPTS.md',
        'ColorScripts-Enhanced/docs/QUICK_REFERENCE.md',
        'ColorScripts-Enhanced/docs/DOCUMENTATION_INDEX.md',
        'ColorScripts-Enhanced/docs/PUBLISHING.md',
        'ColorScripts-Enhanced/docs/ROADMAP.md'
    )
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
$repoRoot = Split-Path -Path $scriptRoot -Parent

if (-not $PSBoundParameters.ContainsKey('ScriptCount')) {
    $counterScript = Join-Path -Path $scriptRoot -ChildPath 'Get-ColorScriptCount.ps1'
    if (-not (Test-Path -LiteralPath $counterScript)) {
        throw "Cannot locate Get-ColorScriptCount.ps1 at $counterScript"
    }

    Write-Verbose 'Invoking Get-ColorScriptCount.ps1'
    $ScriptCount = & $counterScript
}

if ($ScriptCount -lt 0) {
    throw 'ScriptCount must be non-negative'
}

if (-not $PSBoundParameters.ContainsKey('CacheCount')) {
    $cachePolicyPath = Join-Path -Path $repoRoot -ChildPath 'ColorScripts-Enhanced/CachePolicy.psd1'
    if (-not (Test-Path -LiteralPath $cachePolicyPath -PathType Leaf)) {
        throw "Cannot locate CachePolicy.psd1 at $cachePolicyPath"
    }

    $cachePolicy = Import-PowerShellDataFile -LiteralPath $cachePolicyPath -ErrorAction Stop
    $policyNames = @($cachePolicy.CacheableScripts) + @($cachePolicy.CacheablePokemonScripts)
    $cacheNames = @($policyNames | Where-Object {
            $_ -is [string] -and -not [string]::IsNullOrWhiteSpace($_)
        })
    $cacheNames = @($cacheNames | Sort-Object -Unique)
    $CacheCount = $cacheNames.Count
}

if (-not $PSBoundParameters.ContainsKey('DynamicCount')) {
    $dynamicPolicyPath = Join-Path -Path $repoRoot -ChildPath 'ColorScripts-Enhanced/DynamicRenderPolicy.psd1'
    if (-not (Test-Path -LiteralPath $dynamicPolicyPath -PathType Leaf)) {
        throw "Cannot locate DynamicRenderPolicy.psd1 at $dynamicPolicyPath"
    }

    $dynamicPolicy = Import-PowerShellDataFile -LiteralPath $dynamicPolicyPath -ErrorAction Stop
    $dynamicNames = @($dynamicPolicy.DynamicScripts | Where-Object {
            $_ -is [string] -and -not [string]::IsNullOrWhiteSpace($_)
        } | Sort-Object -Unique)
    $DynamicCount = $dynamicNames.Count
}

if (-not $PSBoundParameters.ContainsKey('ModuleVersion')) {
    $manifestPath = Join-Path -Path $repoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'
    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
        throw "Cannot locate the module manifest at $manifestPath"
    }

    $manifest = Import-PowerShellDataFile -LiteralPath $manifestPath -ErrorAction Stop
    $ModuleVersion = [string]$manifest.ModuleVersion
}

if ([string]::IsNullOrWhiteSpace($ModuleVersion)) {
    throw 'ModuleVersion must not be empty'
}

$plusValue = "${ScriptCount}+"
$minusValue = [math]::Max($ScriptCount - $ImagesShown, 0).ToString()
$cacheValue = $CacheCount.ToString()
$dynamicValue = $DynamicCount.ToString()
$exactValue = $ScriptCount.ToString()

$replacements = @{
    'COLOR_SCRIPT_COUNT_PLUS'         = $plusValue
    'COLOR_SCRIPT_COUNT_MINUS_IMAGES' = $minusValue
    'COLOR_CACHE_TOTAL'               = $cacheValue
    'COLOR_DYNAMIC_TOTAL'             = $dynamicValue
    'COLOR_MODULE_VERSION'            = "``$ModuleVersion``"
    'COLOR_SCRIPT_COUNT'              = $exactValue
}

foreach ($file in $Files) {
    $resolvedPath = if ([System.IO.Path]::IsPathRooted($file)) {
        $file
    }
    else {
        Join-Path -Path $repoRoot -ChildPath $file
    }

    if (-not (Test-Path -LiteralPath $resolvedPath -PathType Leaf)) {
        Write-Verbose "Skipping missing file: $resolvedPath"
        continue
    }

    $content = Get-Content -LiteralPath $resolvedPath -Raw -ErrorAction Stop
    $updated = $content

    foreach ($marker in $replacements.Keys) {
        $value = $replacements[$marker]
        $pattern = "<!--\s*$marker\s*-->.*?<!--\s*/$marker\s*-->"
        $replacement = "<!-- $marker -->$value<!-- /$marker -->"
        $updated = [regex]::Replace($updated, $pattern, $replacement, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    }

    if ($updated -ne $content) {
        Write-Verbose "Updated marker values in: $resolvedPath"
        [System.IO.File]::WriteAllText($resolvedPath, $updated, (New-Object System.Text.UTF8Encoding($false)))
    }
    else {
        Write-Verbose "No marker changes detected in: $resolvedPath"
    }
}
