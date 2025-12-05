<#
.SYNOPSIS
    Update file paths in documentation after repository reorganization.

.DESCRIPTION
    This script updates all references to files that were moved during the
    repository reorganization (scripts to scripts/, examples to docs/examples/, etc.)
#>

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot

# Define path mappings (old → new)
$pathMappings = @{
    '\.\/Build-Help\.ps1'                         = './scripts/Build-Help.ps1'
    '\.\/build\.ps1'                              = './scripts/build.ps1'
    '\.\/Convert-AnsiToColorScript-Advanced\.ps1' = './scripts/Convert-AnsiToColorScript-Advanced.ps1'
    '\.\/Convert-AnsiToColorScript\.js'           = './scripts/Convert-AnsiToColorScript.js'
    '\.\/Convert-AnsiToColorScript\.ps1'          = './scripts/Convert-AnsiToColorScript.ps1'
    '\.\/Get-ColorScriptCount\.ps1'               = './scripts/Get-ColorScriptCount.ps1'
    '\.\/Lint-Module\.ps1'                        = './scripts/Lint-Module.ps1'
    '\.\/Test-Module\.ps1'                        = './scripts/Test-Module.ps1'
    '\.\/Update-DocumentationCounts\.ps1'         = './scripts/Update-DocumentationCounts.ps1'
    'node Convert-AnsiToColorScript\.js'          = 'node scripts/Convert-AnsiToColorScript.js'
    'node \.\/Convert-AnsiToColorScript\.js'      = 'node ./scripts/Convert-AnsiToColorScript.js'
    '& \.\\Build-Help\.ps1'                       = '& .\scripts\Build-Help.ps1'
    '& \.\\build\.ps1'                            = '& .\scripts\build.ps1'
    '& \.\\Lint-Module\.ps1'                      = '& .\scripts\Lint-Module.ps1'
    '& \.\\Test-Module\.ps1'                      = '& .\scripts\Test-Module.ps1'
    '& \.\\Get-ColorScriptCount\.ps1'             = '& .\scripts\Get-ColorScriptCount.ps1'
    'examples\/ansi-conversion'                   = 'docs/examples/ansi-conversion'
    'ansi-files\/'                                = 'assets/ansi-files/'
    '\.\/ansi-files\/'                            = './assets/ansi-files/'
}

# Files to update
$filesToUpdate = @(
    'README.md'
    'ColorScripts-Enhanced\README.md'
    'CONTRIBUTING.md'
    'docs\DEVELOPMENT.md'
    'docs\PUBLISHING.md'
    'docs\QUICK_REFERENCE.md'
    'docs\ANSI-CONVERSION-GUIDE.md'
    'docs\MODULE_SUMMARY.md'
    'docs\ROADMAP.md'
    'docs\RELEASE_CHECKLIST.md'
    'docs\POWERSHELL-VERSIONS.md'
    'docs\examples\ansi-conversion\README.md'
    'docs\examples\ansi-conversion\Split-SampleAnsi.ps1'
)

$updatedCount = 0

foreach ($file in $filesToUpdate) {
    $fullPath = Join-Path $repoRoot $file

    if (-not (Test-Path $fullPath)) {
        Write-Warning "File not found: $fullPath"
        continue
    }

    Write-Host "Processing: $file" -ForegroundColor Cyan

    $content = Get-Content $fullPath -Raw
    $originalContent = $content

    foreach ($pattern in $pathMappings.Keys) {
        $replacement = $pathMappings[$pattern]
        $content = $content -replace $pattern, $replacement
    }

    if ($content -ne $originalContent) {
        Set-Content -Path $fullPath -Value $content -NoNewline -Encoding UTF8
        Write-Host '  ✓ Updated' -ForegroundColor Green
        $updatedCount++
    }
    else {
        Write-Host '  - No changes' -ForegroundColor Gray
    }
}

Write-Host "`nUpdated $updatedCount file(s)" -ForegroundColor Cyan
