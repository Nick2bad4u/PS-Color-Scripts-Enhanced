# ColorScripts-Enhanced Installation Script
# Installs the module to your PowerShell modules directory

[CmdletBinding()]
param(
    [Parameter()]
    [switch]$CurrentUser,

    [Parameter()]
    [switch]$AllUsers,

    [Parameter()]
    [switch]$AddToProfile,

    [Parameter()]
    [switch]$BuildCache
)

$ErrorActionPreference = 'Stop'

# Determine installation path
if ($AllUsers) {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Error "AllUsers installation requires Administrator privileges. Run PowerShell as Administrator or use -CurrentUser instead."
        exit 1
    }
    $modulePath = "$env:ProgramFiles\PowerShell\Modules"
}
else {
    # Default to current user
    $modulePath = "$HOME\Documents\PowerShell\Modules"
    if (-not (Test-Path "$HOME\Documents\PowerShell")) {
        $modulePath = "$HOME\Documents\WindowsPowerShell\Modules"
    }
}

$destinationPath = Join-Path $modulePath "ColorScripts-Enhanced"
$sourcePath = $PSScriptRoot

Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  ColorScripts-Enhanced Module Installation             ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "Installation Details:" -ForegroundColor Yellow
Write-Host "  Source: $sourcePath"
Write-Host "  Destination: $destinationPath"
Write-Host "  Scope: $(if($AllUsers){'All Users'}else{'Current User'})`n"

# Create module directory if it doesn't exist
if (-not (Test-Path $modulePath)) {
    New-Item -ItemType Directory -Path $modulePath -Force | Out-Null
    Write-Host "✓ Created module directory" -ForegroundColor Green
}

# Copy module files
try {
    if (Test-Path $destinationPath) {
        Write-Host "Module already exists. Removing old version..." -ForegroundColor Yellow
        Remove-Item $destinationPath -Recurse -Force
    }

    Write-Host "Copying module files..." -ForegroundColor Cyan
    Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force
    Write-Host "✓ Module files copied successfully" -ForegroundColor Green
}
catch {
    Write-Error "Failed to copy module files: $_"
    exit 1
}

# Import the module
try {
    Write-Host "`nImporting module..." -ForegroundColor Cyan
    Import-Module ColorScripts-Enhanced -Force
    Write-Host "✓ Module imported successfully" -ForegroundColor Green
}
catch {
    Write-Error "Failed to import module: $_"
    exit 1
}

# Add to profile if requested
if ($AddToProfile) {
    $profilePath = $PROFILE.CurrentUserAllHosts

    if (-not (Test-Path $profilePath)) {
        Write-Host "`nCreating PowerShell profile..." -ForegroundColor Cyan
        New-Item -Path $profilePath -ItemType File -Force | Out-Null
    }

    $importLine = "Import-Module ColorScripts-Enhanced"
    $content = Get-Content $profilePath -ErrorAction SilentlyContinue

    if ($content -notcontains $importLine) {
        Write-Host "Adding module to PowerShell profile..." -ForegroundColor Cyan
        Add-Content -Path $profilePath -Value "`n# ColorScripts-Enhanced Module"
        Add-Content -Path $profilePath -Value $importLine
        Write-Host "✓ Added to profile: $profilePath" -ForegroundColor Green
    }
    else {
        Write-Host "Module already in profile" -ForegroundColor Yellow
    }
}

# Build cache if requested
if ($BuildCache) {
    Write-Host "`nBuilding cache for all colorscripts..." -ForegroundColor Cyan
    Write-Host "(This may take a few minutes)`n" -ForegroundColor Yellow
    Build-ColorScriptCache -All
}

# Display completion message
Write-Host "`n╔════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Installation Complete! ✓                              ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "Quick Start:" -ForegroundColor Yellow
Write-Host "  Show-ColorScript          # Display random colorscript"
Write-Host "  scs mandelbrot-zoom       # Display specific script"
Write-Host "  Get-ColorScriptList       # List all scripts"
Write-Host "  Build-ColorScriptCache -All   # Build cache for performance`n"

if (-not $BuildCache) {
    Write-Host "💡 Tip: Run 'Build-ColorScriptCache -All' to enable high-speed caching!" -ForegroundColor Cyan
}

Write-Host "`nModule installed successfully! Enjoy your colorful terminal! 🌈`n" -ForegroundColor Green
