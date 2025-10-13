<#
.SYNOPSIS
    Validate CHANGELOG.md against the module manifest and git-cliff output.

.DESCRIPTION
    Ensures that CHANGELOG.md contains an entry for the current module version and that the
    latest git-cliff output is already present. This script is intended to run in CI before
    publishing to the PowerShell Gallery so release notes stay in sync.

.EXAMPLE
    pwsh -NoProfile -File ./scripts/Validate-Changelog.ps1
#>
[CmdletBinding()]
param()

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Resolve-Path -LiteralPath (Join-Path -Path $scriptRoot -ChildPath '..')
$manifestPath = Join-Path -Path $repoRoot -ChildPath 'ColorScripts-Enhanced/ColorScripts-Enhanced.psd1'
$changelogPath = Join-Path -Path $repoRoot -ChildPath 'CHANGELOG.md'

if (-not (Test-Path -LiteralPath $manifestPath)) {
    throw "Module manifest not found at '$manifestPath'."
}

if (-not (Test-Path -LiteralPath $changelogPath)) {
    throw "CHANGELOG.md not found at '$changelogPath'."
}

$manifest = Import-PowerShellDataFile -Path $manifestPath
$moduleVersion = [string]$manifest.ModuleVersion
if ([string]::IsNullOrWhiteSpace($moduleVersion)) {
    throw 'ModuleVersion is not defined in the manifest.'
}

$gitCliff = Get-Command git-cliff -ErrorAction SilentlyContinue
if (-not $gitCliff) {
    throw "git-cliff CLI is required. Install via 'cargo install git-cliff' or download from https://github.com/orhun/git-cliff/releases."
}

$generateNotesScript = Join-Path -Path $scriptRoot -ChildPath 'Generate-ReleaseNotes.ps1'
if (-not (Test-Path -LiteralPath $generateNotesScript)) {
    throw "Generate-ReleaseNotes.ps1 was not found at '$generateNotesScript'."
}

$latestNotes = & $generateNotesScript -Latest -PassThru
if ($LASTEXITCODE -ne 0) {
    throw 'git-cliff failed to generate latest release notes.'
}

$latestNotes = ($latestNotes | Out-String).Trim()
if (-not $latestNotes) {
    throw 'git-cliff returned empty release notes for the latest tag.'
}

$changelogContent = Get-Content -LiteralPath $changelogPath -Raw
$versionHeadingPattern = "^##\s+\[$([regex]::Escape($moduleVersion))\]"
if (-not [System.Text.RegularExpressions.Regex]::IsMatch($changelogContent, $versionHeadingPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)) {
    throw "CHANGELOG.md does not contain an entry for version $moduleVersion."
}

if ($changelogContent.IndexOf($latestNotes, [System.StringComparison]::OrdinalIgnoreCase) -lt 0) {
    throw 'CHANGELOG.md is not aligned with the latest git-cliff output. Run npm run release:notes and commit the result.'
}

Write-Host "✓ CHANGELOG.md validated for version $moduleVersion" -ForegroundColor Green
