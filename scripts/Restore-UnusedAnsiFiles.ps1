#Requires -Version 5.1

<#
.SYNOPSIS
    Restore unused ANSI files to the main collection based on existing colorscripts.

.DESCRIPTION
    Compares colorscript names (from ColorScripts-Enhanced/Scripts/*.ps1) with unused ANSI files
    (from assets/unused-ansi-files/*.ans) and moves matching files to assets/ansi-files/.

.EXAMPLE
    .\scripts\Restore-UnusedAnsiFiles.ps1
    Restores all matching ANSI files to the main collection.

.EXAMPLE
    .\scripts\Restore-UnusedAnsiFiles.ps1 -WhatIf
    Shows what would be moved without actually moving files.
#>

[CmdletBinding(SupportsShouldProcess)]
param()

# Get repository root
$repoRoot = (Get-Item $PSScriptRoot).Parent.FullName

# Define paths
$colorscriptsPath = Join-Path $repoRoot "ColorScripts-Enhanced\Scripts"
$unusedAnsiPath = Join-Path $repoRoot "assets\unused-ansi-files"
$ansiFilesPath = Join-Path $repoRoot "assets\ansi-files"

# Function to normalize filenames for comparison (remove underscores, hyphens, ANSI prefix)
function Normalize-FileName {
    param([string]$name)
    # Convert to lowercase
    $normalized = $name.ToLower()
    # Remove common prefixes (ANSI_, ansi-, etc)
    $normalized = $normalized -replace '^ansi[-_]', ''
    # Replace underscores with hyphens for consistency
    $normalized = $normalized -replace '_', '-'
    return $normalized
}

# Validate paths exist
if (-not (Test-Path $colorscriptsPath)) {
    Write-Error "Colorscripts path not found: $colorscriptsPath"
    exit 1
}

if (-not (Test-Path $unusedAnsiPath)) {
    Write-Error "Unused ANSI files path not found: $unusedAnsiPath"
    exit 1
}

if (-not (Test-Path $ansiFilesPath)) {
    Write-Error "ANSI files path not found: $ansiFilesPath"
    exit 1
}

# Get all colorscript names (without extension)
Write-Host "Scanning colorscripts..." -ForegroundColor Cyan
$colorscriptNames = @(Get-ChildItem -Path $colorscriptsPath -Filter "*.ps1" | ForEach-Object { Normalize-FileName $_.BaseName })
Write-Host "  Found $($colorscriptNames.Count) colorscripts" -ForegroundColor Green

# Get all unused ANSI files
Write-Host "`nScanning unused ANSI files..." -ForegroundColor Cyan
$unusedFiles = @(Get-ChildItem -Path $unusedAnsiPath -Filter "*.ans")
Write-Host "  Found $($unusedFiles.Count) unused ANSI files" -ForegroundColor Green

# Compare and move matching files
Write-Host "`nMatching and restoring files..." -ForegroundColor Cyan

# First pass: count matching files
$matchingFiles = @()
foreach ($unusedFile in $unusedFiles) {
    $normalizedUnusedName = Normalize-FileName $unusedFile.BaseName
    if ($normalizedUnusedName -in $colorscriptNames) {
        $matchingFiles += $unusedFile
    }
}

Write-Host "  Found $($matchingFiles.Count) matching file(s) to process" -ForegroundColor Cyan

$movedCount = 0
$skipCount = 0

# Second pass: process matching files
foreach ($unusedFile in $matchingFiles) {
    $destPath = Join-Path $ansiFilesPath $unusedFile.Name

    # Check if file already exists at destination
    if (Test-Path $destPath) {
        Write-Host "  ⚠ Skipping $($unusedFile.Name) - already exists in ansi-files" -ForegroundColor Yellow
        $skipCount++
        continue
    }

    # Move the file
    if ($PSCmdlet.ShouldProcess($unusedFile.FullName, "Move to ansi-files")) {
        try {
            Move-Item -Path $unusedFile.FullName -Destination $destPath -ErrorAction Stop
            Write-Host "  ✓ Moved: $($unusedFile.Name)" -ForegroundColor Green
            $movedCount++
        }
        catch {
            Write-Error "  ✗ Failed to move $($unusedFile.Name): $_"
        }
    }
}

# Summary
Write-Host "`n╔═══════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Restore Summary                 ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "  Total colorscripts:    $($colorscriptNames.Count)"
Write-Host "  Unused ANSI files:     $($unusedFiles.Count)"
Write-Host "  Matching files found:  $($matchingFiles.Count)"
Write-Host "  Files restored:        $movedCount" -ForegroundColor Green
Write-Host "  Files skipped:         $skipCount" -ForegroundColor Yellow
Write-Host ""

if ($matchingFiles.Count -eq 0) {
    Write-Host "ℹ No matching files found" -ForegroundColor Gray
}
elseif ($PSCmdlet.ShouldProcess("dummy", "Simulate") -eq $false) {
    Write-Host "✓ WhatIf mode: Would restore $movedCount file(s)" -ForegroundColor Cyan
}
elseif ($movedCount -gt 0) {
    Write-Host "✓ Restoration complete!" -ForegroundColor Green
}
elseif ($skipCount -gt 0) {
    Write-Host "⚠ No files moved (all matching files already exist)" -ForegroundColor Yellow
}
else {
    Write-Host "ℹ No files processed" -ForegroundColor Gray
}
