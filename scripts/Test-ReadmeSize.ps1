<#
.SYNOPSIS
    Check if README.md file size is within PowerShell Gallery limits.

.DESCRIPTION
    PowerShell Gallery has an 8,000 byte limit for the README content that gets
    embedded in the module package. This script checks if the README exceeds this
    limit and provides recommendations if it does.

.PARAMETER Path
    Path to the README.md file to check. Defaults to ColorScripts-Enhanced/README.md.

.PARAMETER ShowContent
    Display the actual byte count breakdown and file info.

.PARAMETER Strict
    Treat warnings as errors (exit with code 1 if over limit).

.EXAMPLE
    .\scripts\Test-ReadmeSize.ps1

.EXAMPLE
    .\scripts\Test-ReadmeSize.ps1 -Path .\README.md -ShowContent

.EXAMPLE
    .\scripts\Test-ReadmeSize.ps1 -Strict
#>
[CmdletBinding()]
param(
    [Parameter()]
    [string]$Path = '.\ColorScripts-Enhanced\README.md',

    [Parameter()]
    [switch]$ShowContent,

    [Parameter()]
    [switch]$Strict
)

$ErrorActionPreference = 'Stop'

# Resolve the path
$readmePath = Resolve-Path -Path $Path -ErrorAction Stop

# Get file info
$file = Get-Item -Path $readmePath

# PowerShell Gallery limit (bytes)
$galleryLimit = 8000

# Get file size in bytes
$fileSizeBytes = $file.Length

# Calculate percentage of limit
$percentUsed = [math]::Round(($fileSizeBytes / $galleryLimit) * 100, 2)

# Display results
Write-Host "`n=== PowerShell Gallery README Size Check ===" -ForegroundColor Cyan
Write-Host "File: $($file.FullName)" -ForegroundColor Gray
Write-Host "Size: $fileSizeBytes bytes" -ForegroundColor White
Write-Host "Limit: $galleryLimit bytes" -ForegroundColor White
Write-Host "Usage: $percentUsed%" -ForegroundColor White

if ($ShowContent) {
    Write-Host "`nFile Details:" -ForegroundColor Cyan
    Write-Host "  Created: $($file.CreationTime)" -ForegroundColor Gray
    Write-Host "  Modified: $($file.LastWriteTime)" -ForegroundColor Gray
    Write-Host "  Lines: $((Get-Content $readmePath | Measure-Object -Line).Lines)" -ForegroundColor Gray

    # Character count
    $content = Get-Content $readmePath -Raw
    Write-Host "  Characters: $($content.Length)" -ForegroundColor Gray

    # Encoding
    $encoding = [System.Text.Encoding]::Default
    $bytes = $encoding.GetBytes($content)
    Write-Host "  Encoding: $($encoding.EncodingName)" -ForegroundColor Gray
}

Write-Host ''

# Check if over limit
if ($fileSizeBytes -gt $galleryLimit) {
    $overage = $fileSizeBytes - $galleryLimit
    Write-Host "❌ FAIL: README exceeds PowerShell Gallery limit by $overage bytes!" -ForegroundColor Red
    Write-Host ''
    Write-Host 'Recommendations:' -ForegroundColor Yellow
    Write-Host '  1. Move detailed documentation to separate files in docs/' -ForegroundColor White
    Write-Host '  2. Link to GitHub for full documentation' -ForegroundColor White
    Write-Host '  3. Keep README concise with quick start info only' -ForegroundColor White
    Write-Host '  4. Consider creating a separate README for the Gallery vs GitHub' -ForegroundColor White
    Write-Host ''

    if ($Strict) {
        exit 1
    }
}
elseif ($fileSizeBytes -gt ($galleryLimit * 0.9)) {
    $remaining = $galleryLimit - $fileSizeBytes
    Write-Host "⚠️  WARNING: README is at $percentUsed% of limit ($remaining bytes remaining)" -ForegroundColor Yellow
    Write-Host 'Consider keeping it concise to avoid future issues.' -ForegroundColor Yellow
    Write-Host ''
}
else {
    $remaining = $galleryLimit - $fileSizeBytes
    Write-Host '✅ PASS: README is within PowerShell Gallery limits' -ForegroundColor Green
    Write-Host "Remaining space: $remaining bytes" -ForegroundColor Green
    Write-Host ''
}

# Return object for automation
[PSCustomObject]@{
    Path        = $file.FullName
    SizeBytes   = $fileSizeBytes
    LimitBytes  = $galleryLimit
    PercentUsed = $percentUsed
    Remaining   = $galleryLimit - $fileSizeBytes
    OverLimit   = $fileSizeBytes -gt $galleryLimit
    NearLimit   = $fileSizeBytes -gt ($galleryLimit * 0.9)
}
