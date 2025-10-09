#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Test all colorscripts by running them sequentially.

.DESCRIPTION
    This script runs all available colorscripts one by one, displaying their name
    and output. Useful for testing, debugging, or previewing all scripts.

.PARAMETER Delay
    Delay in milliseconds between each script (default: 1000ms).

.PARAMETER PauseAfterEach
    Pause and wait for user input after each script.

.PARAMETER SkipErrors
    Continue running even if a script fails.

.PARAMETER Filter
    Filter scripts by name pattern (supports wildcards).

.EXAMPLE
    .\Test-AllColorScripts.ps1
    Runs all colorscripts with 1 second delay between each.

.EXAMPLE
    .\Test-AllColorScripts.ps1 -PauseAfterEach
    Runs all colorscripts, waiting for Enter key after each one.

.EXAMPLE
    .\Test-AllColorScripts.ps1 -Delay 2000 -Filter "mandel*"
    Runs colorscripts matching "mandel*" with 2 second delay.

.EXAMPLE
    .\Test-AllColorScripts.ps1 -SkipErrors -Delay 500
    Runs all scripts quickly, skipping any that error out.
#>

[CmdletBinding()]
param(
    [Parameter()]
    [int]$Delay = 1000,

    [Parameter()]
    [switch]$PauseAfterEach,

    [Parameter()]
    [switch]$SkipErrors,

    [Parameter()]
    [string]$Filter = "*"
)

# Import the module if not already loaded
$modulePath = Join-Path $PSScriptRoot "ColorScripts-Enhanced.psm1"
if (Test-Path $modulePath) {
    Import-Module $modulePath -Force
}
else {
    Write-Error "ColorScripts-Enhanced module not found at: $modulePath"
    exit 1
}

# Get all colorscripts
$scriptsPath = Join-Path $PSScriptRoot "Scripts"
$scripts = Get-ChildItem -Path $scriptsPath -Filter "*.ps1" |
    Where-Object {
        $_.Name -ne 'ColorScriptCache.ps1' -and
        $_.BaseName -like $Filter
    } |
    Sort-Object Name

if ($scripts.Count -eq 0) {
    Write-Warning "No colorscripts found matching filter: $Filter"
    exit 0
}

Write-Host "`n╔════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║          ColorScripts Enhanced - Test All Scripts                 ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host "`nFound $($scripts.Count) colorscript(s) to test`n" -ForegroundColor Yellow

$currentScript = 0
$successful = 0
$failed = 0
$failedScripts = @()

foreach ($script in $scripts) {
    $currentScript++
    $scriptName = $script.BaseName

    # Display header
    Write-Host "`n" -NoNewline
    Write-Host ("─" * 70) -ForegroundColor DarkGray
    Write-Host "[$currentScript/$($scripts.Count)] " -ForegroundColor Cyan -NoNewline
    Write-Host "$scriptName" -ForegroundColor White
    Write-Host ("─" * 70) -ForegroundColor DarkGray
    Write-Host ""

    try {
        # Run the colorscript
        $originalEncoding = [Console]::OutputEncoding
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

        $startTime = Get-Date

        # Execute the script with error handling
        $ErrorActionPreference = 'Stop'
        & $script.FullName

        $duration = ((Get-Date) - $startTime).TotalMilliseconds

        [Console]::OutputEncoding = $originalEncoding

        # Success
        $successful++
        Write-Host "`n✓ Completed in $([math]::Round($duration, 0))ms" -ForegroundColor Green
    }
    catch {
        [Console]::OutputEncoding = $originalEncoding

        # Handle error
        $failed++
        $failedScripts += $scriptName
        Write-Host "`n✗ Error: $_" -ForegroundColor Red

        if (-not $SkipErrors) {
            Write-Host "`nStopping test run due to error. Use -SkipErrors to continue on errors." -ForegroundColor Yellow
            break
        }
    }

    # Handle pause/delay
    if ($PauseAfterEach) {
        Write-Host "`nPress Enter to continue to next script..." -ForegroundColor Yellow
        $null = Read-Host
    }
    elseif ($currentScript -lt $scripts.Count) {
        # Only delay if not the last script
        Start-Sleep -Milliseconds $Delay
    }
}

# Summary
Write-Host "`n"
Write-Host ("═" * 70) -ForegroundColor Cyan
Write-Host "                         TEST SUMMARY                               " -ForegroundColor Cyan
Write-Host ("═" * 70) -ForegroundColor Cyan
Write-Host "`nTotal Scripts: " -NoNewline
Write-Host $scripts.Count -ForegroundColor White
Write-Host "Successful:    " -NoNewline
Write-Host $successful -ForegroundColor Green
Write-Host "Failed:        " -NoNewline
Write-Host $failed -ForegroundColor $(if ($failed -gt 0) { "Red" } else { "Green" })

if ($failedScripts.Count -gt 0) {
    Write-Host "`nFailed Scripts:" -ForegroundColor Red
    $failedScripts | ForEach-Object {
        Write-Host "  • $_" -ForegroundColor Red
    }
}

Write-Host "`n"
