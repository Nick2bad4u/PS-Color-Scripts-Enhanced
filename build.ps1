<#
.SYNOPSIS
    Build script for ColorScripts-Enhanced PowerShell module.

.DESCRIPTION
    Generates a module manifest with version information and copies required files.
    Supports both automatic timestamp-based versioning and manual semantic versioning.

.PARAMETER Version
    Module version. If not specified, uses timestamp format (yyyy.MM.dd.HHmm).
    Can be semantic version like "1.0.0" or timestamp format.

.PARAMETER SkipReadme
    Skip copying README.md to the module directory.

.PARAMETER SkipHelp
    Skip building help files for the module.

.EXAMPLE
    .\build.ps1
    Builds with automatic timestamp version.

.EXAMPLE
    .\build.ps1 -Version "1.0.0"
    Builds with specific semantic version.

.EXAMPLE
    .\build.ps1 -Version "2025.10.09.1622" -Verbose
    Builds with specific timestamp version and verbose output.
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidatePattern('^\d+\.\d+(\.\d+)?(\.\d+)?$')]
    [string]$Version = (Get-Date).ToString("yyyy.MM.dd.HHmm"),

    [switch]$SkipReadme,

    [switch]$SkipHelp
)

$ErrorActionPreference = 'Stop'

# Validate paths
$modulePath = "./ColorScripts-Enhanced"
$manifestPath = Join-Path $modulePath "ColorScripts-Enhanced.psd1"
$readmePath = "./README.md"

Write-Verbose "Building module version: $Version"
Write-Verbose "Module path: $modulePath"

# Ensure module directory exists
if (-not (Test-Path $modulePath)) {
    throw "Module directory not found: $modulePath"
}

# Copy README if it exists and not skipped
if (-not $SkipReadme) {
    if (Test-Path $readmePath) {
        try {
            Copy-Item -Path $readmePath -Destination (Join-Path $modulePath "README.md") -Force
            Write-Verbose "README.md copied successfully"
        }
        catch {
            Write-Warning "Failed to copy README.md: $_"
        }
    }
    else {
        Write-Warning "README.md not found at: $readmePath"
    }
}

# Remove existing manifest
if (Test-Path $manifestPath) {
    try {
        Remove-Item -Path $manifestPath -Force
        Write-Verbose "Removed existing manifest"
    }
    catch {
        Write-Warning "Failed to remove existing manifest: $_"
    }
}

# Create manifest parameters
$manifestParams = @{
    ModuleVersion        = $Version
    Path                 = $manifestPath
    Guid                 = "f77548d7-23eb-48ce-a6e0-f64b4758d995"
    Author               = "Nick"
    CompanyName          = "Community"
    Copyright            = "(c) 2025. All rights reserved."
    RootModule           = "ColorScripts-Enhanced.psm1"
    CompatiblePSEditions = @("Desktop", "Core")
    FunctionsToExport    = @(
        "Show-ColorScript",
        "Get-ColorScriptList",
        "Build-ColorScriptCache",
        "Clear-ColorScriptCache"
    )
    AliasesToExport      = @("scs")
    Description          = "Enhanced PowerShell ColorScripts with high-performance caching system. Display beautiful ANSI art in your terminal with 6-19x faster load times."
    ProjectUri           = "https://github.com/Nick2bad4u/ps-color-scripts-enhanced"
    LicenseUri           = "https://github.com/Nick2bad4u/ps-color-scripts-enhanced/blob/main/LICENSE"
    Tags                 = @("ColorScripts", "ANSI", "Terminal", "Art", "Cache", "Performance", "PowerShell", "Startup", "Terminal Startup", "ANSI Art", "Colorful Terminal", "PowerShell Art")
    ReleaseNotes         = @"
Version ${Version}:
- Enhanced caching system with OS-wide cache in AppData
- 6-19x performance improvement
- Cache stored in centralized location
- Works from any directory
- 185+ beautiful colorscripts included
- Full comment-based help documentation
- Scripts optimized for performance and visual quality
"@
    PowerShellVersion    = "5.1"
    PassThru             = $true
}

# Create the manifest
try {
    $manifest = New-ModuleManifest @manifestParams
    Write-Host "✓ Module manifest created successfully" -ForegroundColor Green
    Write-Host "  Version: $Version" -ForegroundColor Cyan
    Write-Host "  Path: $manifestPath" -ForegroundColor Cyan

    # Test the manifest
    Test-ModuleManifest -Path $manifestPath -ErrorAction Stop | Out-Null
    Write-Host "✓ Manifest validation passed" -ForegroundColor Green
}
catch {
    Write-Error "Failed to create or validate manifest: $_"
    exit 1
}

# Build help files if not skipped
if (-not $SkipHelp) {
    Write-Verbose "Building help files..."

    # Check if PlatyPS is installed
    if (-not (Get-Module -ListAvailable -Name platyPS)) {
        Write-Host "Installing platyPS module..." -ForegroundColor Yellow
        try {
            # Save current execution policy
            $currentPolicy = Get-ExecutionPolicy -Scope Process

            # Temporarily set execution policy for installation
            Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

            # Install with SkipPublisherCheck to handle unsigned modules
            Install-Module -Name platyPS -Force -SkipPublisherCheck -Scope CurrentUser
            Write-Host "✓ platyPS installed successfully" -ForegroundColor Green

            # Restore execution policy
            Set-ExecutionPolicy -ExecutionPolicy $currentPolicy -Scope Process -Force
        }
        catch {
            Write-Warning "Failed to install platyPS: $_"
            Write-Host "Skipping help file generation" -ForegroundColor Yellow
            exit 0
        }
    }

    # Run Build-Help.ps1 if it exists
    $buildHelpPath = Join-Path $PSScriptRoot "Build-Help.ps1"
    if (Test-Path $buildHelpPath) {
        try {
            & $buildHelpPath
            Write-Host "✓ Help files built successfully" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to build help files: $_"
        }
    }
    else {
        Write-Warning "Build-Help.ps1 not found at: $buildHelpPath"
    }
}
