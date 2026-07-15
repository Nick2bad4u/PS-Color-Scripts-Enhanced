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

$cliffConfig = Join-Path -Path $repoRoot -ChildPath 'node_modules/gitcliff-config-nick2bad4u/cliff.toml'
if (-not (Test-Path -LiteralPath $cliffConfig)) {
    throw "Unable to locate cliff configuration at '$cliffConfig'."
}

$latestNotes = & $gitCliff.Source `
    --config $cliffConfig `
    --github-repo 'Nick2bad4u/PS-Color-Scripts-Enhanced' `
    --latest
if ($LASTEXITCODE -ne 0) {
    throw "git-cliff failed to generate release notes for the latest tag (exit code $LASTEXITCODE)."
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
    throw 'CHANGELOG.md is not aligned with the latest git-cliff output. Run npm run release:notes:latest and commit the result.'
}

Write-Host "✓ CHANGELOG.md validated for version $moduleVersion" -ForegroundColor Green
