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

.PARAMETER Files
    Paths to the markdown files that should be updated. Paths are resolved relative to the repository root when
    they are not already absolute. Non-existent files are ignored with a verbose notice.

.EXAMPLE
    pwsh -NoProfile -File ./Update-DocumentationCounts.ps1

.EXAMPLE
    pwsh -NoProfile -File ./Update-DocumentationCounts.ps1 -ScriptCount 255 -Verbose

.NOTES
    The script updates the following markers:
        <!-- COLOR_SCRIPT_COUNT_PLUS -->   -> {count}+ (text with trailing plus)
        <!-- COLOR_SCRIPT_COUNT_MINUS_IMAGES --> -> {max(count - ImagesShown, 0)}
        <!-- COLOR_CACHE_TOTAL -->         -> {count}+ (cache file total)
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
    [string[]]$Files = @(
        'README.md',
        'ColorScripts-Enhanced/README.md',
        'ColorScripts-Enhanced/README-Gallery.md',
        'docs/MODULE_SUMMARY.md',
        'docs/MEGALINTER-SETUP.md',
        'docs/Development.md',
        'docs/QUICK_REFERENCE.md'
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

    Write-Verbose "Invoking Get-ColorScriptCount.ps1"
    $ScriptCount = & $counterScript
}

if ($ScriptCount -lt 0) {
    throw "ScriptCount must be non-negative"
}

$plusValue = "${ScriptCount}+"
$minusValue = [math]::Max($ScriptCount - $ImagesShown, 0).ToString()
$cacheValue = "${ScriptCount}+"
$exactValue = $ScriptCount.ToString()

$replacements = @{
    'COLOR_SCRIPT_COUNT_PLUS'         = $plusValue
    'COLOR_SCRIPT_COUNT_MINUS_IMAGES' = $minusValue
    'COLOR_CACHE_TOTAL'               = $cacheValue
    'COLOR_SCRIPT_COUNT'              = $exactValue
}

foreach ($file in $Files) {
    $resolvedPath = if ([System.IO.Path]::IsPathRooted($file)) {
        $file
    }
    else {
        Join-Path -Path $repoRoot -ChildPath $file
    }

    if (-not (Test-Path -Path $resolvedPath)) {
        Write-Verbose "Skipping missing file: $resolvedPath"
        continue
    }

    $content = Get-Content -Path $resolvedPath -Raw -ErrorAction Stop
    $updated = $content

    foreach ($marker in $replacements.Keys) {
        $value = $replacements[$marker]
        $pattern = "<!--\s*$marker\s*-->.*?<!--\s*/$marker\s*-->"
        $replacement = "<!-- $marker -->$value<!-- /$marker -->"
        $updated = [regex]::Replace($updated, $pattern, $replacement, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    }

    if ($updated -ne $content) {
        Write-Verbose "Updated marker values in: $resolvedPath"
        Set-Content -Path $resolvedPath -Value $updated -Encoding UTF8
    }
    else {
        Write-Verbose "No marker changes detected in: $resolvedPath"
    }
}
