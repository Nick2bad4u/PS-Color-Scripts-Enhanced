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

.PARAMETER Parallel
    Execute scripts in parallel (requires PowerShell 7+). Output is summarized after completion.

.PARAMETER ThrottleLimit
    Maximum number of scripts to execute concurrently when using -Parallel. Defaults to processor count.

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
    [string]$Filter = "*",

    [Parameter()]
    [switch]$Parallel,

    [Parameter()]
    [int]$ThrottleLimit = [System.Environment]::ProcessorCount
)

# Ensure consistent UTF-8 output when a console handle exists.
function Invoke-TestWithUtf8Encoding {
    param(
        [scriptblock]$ScriptBlock
    )

    $originalEncoding = $null
    $encodingChanged = $false

    if (-not [Console]::IsOutputRedirected) {
        try {
            $originalEncoding = [Console]::OutputEncoding
            if ($originalEncoding.WebName -ne 'utf-8') {
                [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
                $encodingChanged = $true
            }
        }
        catch [System.IO.IOException] {
            Write-Verbose 'Console handle unavailable; skipping OutputEncoding change in Test-AllColorScripts.'
            $encodingChanged = $false
        }
    }

    try {
        & $ScriptBlock
    }
    finally {
        if ($encodingChanged -and $originalEncoding) {
            try {
                [Console]::OutputEncoding = $originalEncoding
            }
            catch [System.IO.IOException] {
                Write-Verbose 'Console handle unavailable; unable to restore OutputEncoding in Test-AllColorScripts.'
            }
        }
    }
}

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
$results = [System.Collections.Generic.List[object]]::new()
$initialEap = $ErrorActionPreference

function New-ScriptTestResult {
    param(
        [string]$Name,
        [double]$DurationMs,
        [bool]$Success,
        [string]$ErrorMessage
    )

    [pscustomobject]@{
        Name        = $Name
        DurationMs  = [math]::Round($DurationMs, 2)
        Success     = $Success
        Error       = $ErrorMessage
    }
}

if ($Parallel) {
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        throw "-Parallel requires PowerShell 7 or later."
    }

    $parallelResults = $scripts | ForEach-Object -Parallel {
        $scriptName = $_.BaseName
        $startTime = Get-Date
        $success = $true
        $errorMessage = ''

        try {
            $originalEncoding = $null
            $encodingChanged = $false

            if (-not [Console]::IsOutputRedirected) {
                try {
                    $originalEncoding = [Console]::OutputEncoding
                    if ($originalEncoding.WebName -ne 'utf-8') {
                        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
                        $encodingChanged = $true
                    }
                }
                catch [System.IO.IOException] {
                    $encodingChanged = $false
                    $originalEncoding = $null
                }
            }

            try {
                & $_.FullName
            }
            finally {
                if ($encodingChanged -and $originalEncoding) {
                    try {
                        [Console]::OutputEncoding = $originalEncoding
                    }
                    catch [System.IO.IOException] {
                        Write-Verbose 'Console handle unavailable; unable to restore OutputEncoding in parallel execution.'
                    }
                }
            }
        }
        catch {
            $success = $false
            $errorMessage = $_.Exception.Message
        }

        $duration = ((Get-Date) - $startTime).TotalMilliseconds
        [pscustomobject]@{
            Name       = $scriptName
            DurationMs = [math]::Round($duration, 2)
            Success    = $success
            Error      = $errorMessage
        }
    } -ThrottleLimit $ThrottleLimit

    foreach ($item in $parallelResults) {
        $results.Add($item)
        if ($item.Success) {
            $successful++
        }
        else {
            $failed++
            $failedScripts += $item.Name
        }
    }
}
else {
    foreach ($script in $scripts) {
        $currentScript++
        $scriptName = $script.BaseName

        Write-Host "`n" -NoNewline
        Write-Host ("─" * 70) -ForegroundColor DarkGray
        Write-Host "[$currentScript/$($scripts.Count)] " -ForegroundColor Cyan -NoNewline
        Write-Host "$scriptName" -ForegroundColor White
        Write-Host ("─" * 70) -ForegroundColor DarkGray
        Write-Host ""

        $startTime = Get-Date
        $success = $true
        $errorMessage = ''

        try {
            $ErrorActionPreference = 'Stop'
            Invoke-TestWithUtf8Encoding { & $script.FullName }
        }
        catch {
            $success = $false
            $errorMessage = $_.Exception.Message
        }
        finally {
            $ErrorActionPreference = $initialEap
        }

        $duration = ((Get-Date) - $startTime).TotalMilliseconds

        if ($success) {
            $successful++
            Write-Host "`n✓ Completed in $([math]::Round($duration, 0))ms" -ForegroundColor Green
        }
        else {
            $failed++
            $failedScripts += $scriptName
            Write-Host "`n✗ Error: $errorMessage" -ForegroundColor Red

            if (-not $SkipErrors) {
                Write-Host "`nStopping test run due to error. Use -SkipErrors to continue on errors." -ForegroundColor Yellow
                $results.Add((New-ScriptTestResult -Name $scriptName -DurationMs $duration -Success $success -ErrorMessage $errorMessage))
                break
            }
        }

        $results.Add((New-ScriptTestResult -Name $scriptName -DurationMs $duration -Success $success -ErrorMessage $errorMessage))

        if ($PauseAfterEach) {
            Write-Host "`nPress Enter to continue to next script..." -ForegroundColor Yellow
            $null = Read-Host
        }
        elseif ($currentScript -lt $scripts.Count) {
            Start-Sleep -Milliseconds $Delay
        }
    }
}

$ErrorActionPreference = $initialEap

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

return $results
