# Generate External Help XML from Markdown
# This script converts markdown help files to MAML XML format
# Note: Requires platyPS module (optional - install manually if needed)

#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter()]
    [string]$ModulePath = "$PSScriptRoot\ColorScripts-Enhanced",

    [Parameter()]
    [string]$OutputPath = "$PSScriptRoot\ColorScripts-Enhanced\en-US",

    [Parameter()]
    [switch]$SkipXmlGeneration
)

Write-Host "`nColorScripts-Enhanced Help Builder" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Check if platyPS is available
$hasPlatyPS = Get-Module -ListAvailable -Name platyPS

if (-not $hasPlatyPS) {
    Write-Host "`nplatyPS module is not installed." -ForegroundColor Yellow
    Write-Host "`nThe module already has comment-based help that works without platyPS." -ForegroundColor Green
    Write-Host "External XML help is optional and only needed for advanced scenarios.`n" -ForegroundColor Gray

    Write-Host "To install platyPS (optional):" -ForegroundColor Yellow
    Write-Host "  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass" -ForegroundColor Gray
    Write-Host "  Install-Module -Name platyPS -Scope CurrentUser -Force -SkipPublisherCheck`n" -ForegroundColor Gray

    Write-Host "Skipping XML generation. Comment-based help is already available.`n" -ForegroundColor Green
    $SkipXmlGeneration = $true
}

if (-not $SkipXmlGeneration -and $hasPlatyPS) {
    Write-Host "`nImporting platyPS module..." -ForegroundColor Yellow
    try {
        Import-Module platyPS -Force -ErrorAction Stop
    }
    catch {
        Write-Host "Failed to import platyPS: $_" -ForegroundColor Red
        Write-Host "Continuing without XML generation...`n" -ForegroundColor Yellow
        $SkipXmlGeneration = $true
    }
}

# Ensure output directory exists
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

if (-not $SkipXmlGeneration) {
    # Generate MAML from markdown files
    Write-Host "`nConverting markdown to MAML XML..." -ForegroundColor Yellow

    try {
        $mamlParams = @{
            Path       = $OutputPath
            OutputPath = $OutputPath
            Force      = $true
        }

        New-ExternalHelp @mamlParams

        Write-Host "✓ External help XML generated successfully" -ForegroundColor Green
        Write-Host "  Location: $OutputPath\ColorScripts-Enhanced-help.xml`n" -ForegroundColor Gray
    }
    catch {
        Write-Host "✗ Failed to generate help XML: $_" -ForegroundColor Red
        Write-Host "  Continuing with comment-based help only...`n" -ForegroundColor Yellow
    }
}

# Validate the help
Write-Host "Validating help content..." -ForegroundColor Yellow

try {
    Import-Module $ModulePath -Force -ErrorAction Stop

    $commands = @('Show-ColorScript', 'Get-ColorScriptList', 'Build-ColorScriptCache', 'Clear-ColorScriptCache', 'Add-ColorScriptProfile')

    Write-Host ""
    foreach ($cmd in $commands) {
        $help = Get-Help $cmd -ErrorAction Stop
        if ($help.Synopsis) {
            Write-Host "  ✓ Help validated for $cmd" -ForegroundColor Green
        }
        else {
            Write-Host "  ✗ Help missing synopsis for $cmd" -ForegroundColor Red
        }
    }

    # Test about topic
    Write-Host ""
    $aboutHelp = Get-Help about_ColorScripts-Enhanced -ErrorAction SilentlyContinue
    if ($aboutHelp) {
        Write-Host "  ✓ about_ColorScripts-Enhanced help topic found" -ForegroundColor Green
    }
    else {
        Write-Host "  ⚠ about_ColorScripts-Enhanced help topic not found" -ForegroundColor Yellow
    }

    Write-Host "`n==================================" -ForegroundColor Cyan
    Write-Host "✓ Help validation complete!`n" -ForegroundColor Green

    if ($SkipXmlGeneration) {
        Write-Host "Note: Using comment-based help (XML generation skipped)" -ForegroundColor Gray
        Write-Host "All help commands will work normally with Get-Help.`n" -ForegroundColor Gray
    }
}
catch {
    Write-Host "`n✗ Help validation failed: $_" -ForegroundColor Red
    Write-Host "Module may not be properly loaded.`n" -ForegroundColor Yellow
    exit 1
}
