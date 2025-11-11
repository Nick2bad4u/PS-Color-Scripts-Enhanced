#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Execute every colorscript using the module pipeline.

.DESCRIPTION
    Loads ColorScripts-Enhanced once, resolves the script roster through
    Get-ColorScriptList, and executes each entry via Show-ColorScript -NoCache
    to ensure consistent behavior with the module's cache subsystem.

.PARAMETER Delay
    Delay in milliseconds between sequential script executions (default: 1000).

.PARAMETER PauseAfterEach
    Pause and wait for user input after each script when running sequentially.

.PARAMETER SkipErrors
    Continue processing after failures instead of stopping at the first error.

.PARAMETER Filter
    One or more wildcard patterns (comma separated) used to select scripts.

.PARAMETER Parallel
    Execute scripts concurrently (PowerShell 7+ required).

.PARAMETER ThrottleLimit
    Maximum number of scripts to run concurrently when -Parallel is specified.

.EXAMPLE
    .\Test-AllColorScripts.ps1
    Runs every colorscript sequentially with a one-second delay.

.EXAMPLE
    .\Test-AllColorScripts.ps1 -Filter "aurora-*"
    Runs only colorscripts whose names start with "aurora-".

.EXAMPLE
    .\Test-AllColorScripts.ps1 -Parallel -ThrottleLimit 4 -SkipErrors
    Executes scripts in parallel (four at a time) while collecting all failures.
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
    [string]$Filter = '*',

    [Parameter()]
    [switch]$Parallel,

    [Parameter()]
    [int]$ThrottleLimit = [System.Environment]::ProcessorCount
)

$moduleManifest = Join-Path $PSScriptRoot 'ColorScripts-Enhanced.psd1'
if (-not (Test-Path $moduleManifest)) {
    Write-Error "ColorScripts-Enhanced manifest not found at: $moduleManifest"
    exit 1
}

Import-Module $moduleManifest -Force

$filterPatterns = @()
if (-not [string]::IsNullOrWhiteSpace($Filter)) {
    $filterPatterns = $Filter -split '\s*,\s*' | Where-Object { $_ }
}

$records = if ($filterPatterns.Count -eq 0 -or ($filterPatterns.Count -eq 1 -and $filterPatterns[0] -eq '*')) {
    Get-ColorScriptList -AsObject
}
else {
    Get-ColorScriptList -AsObject -Name $filterPatterns
}

$records = @(
    $records | Sort-Object Name | ForEach-Object {
        [pscustomobject]@{
            Name     = $_.Name
            Category = $_.Category
        }
    }
)

$recordCount = $records.Count

if ($recordCount -eq 0) {
    Write-Warning "No colorscripts found matching filter: $Filter"
    exit 0
}

function Invoke-ColorScriptRun {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Record,

        [Parameter()]
        [string]$ModuleManifestPath
    )

    if (-not (Get-Module -Name ColorScripts-Enhanced)) {
        if ($ModuleManifestPath) {
            Import-Module $ModuleManifestPath -Force
        }
        else {
            Import-Module ColorScripts-Enhanced -ErrorAction Stop
        }
    }

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $success = $true
    $errorMessage = ''

    try {
        Show-ColorScript -Name $Record.Name -NoCache -ErrorAction Stop | Out-Null
    }
    catch {
        $success = $false
        $errorMessage = $_.Exception.Message
    }
    finally {
        $stopwatch.Stop()
    }

    [pscustomobject]@{
        Name       = $Record.Name
        DurationMs = [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 2)
        Success    = $success
        Error      = $errorMessage
        Category   = $Record.Category
    }
}

$runnerDefinition = "function Invoke-ColorScriptRun {`n$((Get-Command Invoke-ColorScriptRun -CommandType Function).Definition)`n}"

Write-Host "`n+====================================================================+" -ForegroundColor Cyan
Write-Host '|          ColorScripts Enhanced - Test All Scripts                 |' -ForegroundColor Cyan
Write-Host '+====================================================================+' -ForegroundColor Cyan
Write-Host "`nFound $recordCount colorscript(s) to test`n" -ForegroundColor Yellow

$successful = 0
$failed = 0
$failedScripts = @()
$results = [System.Collections.Generic.List[object]]::new()
$initialEap = $ErrorActionPreference

if ($Parallel) {
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        throw '-Parallel requires PowerShell 7 or later.'
    }

    $parallelResults = $records | ForEach-Object -Parallel {
        if (-not (Get-Command Invoke-ColorScriptRun -ErrorAction SilentlyContinue)) {
            . ([scriptblock]::Create($using:runnerDefinition))
        }

        Invoke-ColorScriptRun -Record $PSItem -ModuleManifestPath $using:moduleManifest
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
    $index = 0
    foreach ($record in $records) {
        $index++

        Write-Host "`n" -NoNewline
        Write-Host ('-' * 70) -ForegroundColor DarkGray
        Write-Host "[$index/$recordCount] " -ForegroundColor Cyan -NoNewline
        if ($record.Category) {
            Write-Host "$($record.Name)  ($($record.Category))" -ForegroundColor White
        }
        else {
            Write-Host $record.Name -ForegroundColor White
        }
        Write-Host ('-' * 70) -ForegroundColor DarkGray
        Write-Host ''

        try {
            $ErrorActionPreference = 'Stop'
            $runResult = Invoke-ColorScriptRun -Record $record -ModuleManifestPath $moduleManifest
        }
        catch {
            $runResult = [pscustomobject]@{
                Name       = $record.Name
                DurationMs = 0
                Success    = $false
                Error      = $_.Exception.Message
                Category   = $record.Category
            }
        }
        finally {
            $ErrorActionPreference = $initialEap
        }

        $results.Add($runResult)

        if ($runResult.Success) {
            $successful++
            Write-Host "`n[OK] Completed in $([math]::Round($runResult.DurationMs, 0))ms" -ForegroundColor Green
        }
        else {
            $failed++
            $failedScripts += $runResult.Name
            Write-Host "`n[ERR] Error: $($runResult.Error)" -ForegroundColor Red

            if (-not $SkipErrors) {
                Write-Host "`nStopping test run due to error. Use -SkipErrors to continue on errors." -ForegroundColor Yellow
                break
            }
        }

        if ($PauseAfterEach) {
            Write-Host "`nPress Enter to continue to next script..." -ForegroundColor Yellow
            $null = Read-Host
        }
        elseif ($index -lt $recordCount) {
            Start-Sleep -Milliseconds $Delay
        }
    }
}

$ErrorActionPreference = $initialEap

Write-Host "`n"
Write-Host ('=' * 70) -ForegroundColor Cyan
Write-Host '                         TEST SUMMARY                               ' -ForegroundColor Cyan
Write-Host ('=' * 70) -ForegroundColor Cyan
Write-Host "`nTotal Scripts: " -NoNewline
Write-Host $recordCount -ForegroundColor White
Write-Host 'Successful:    ' -NoNewline
Write-Host $successful -ForegroundColor Green
Write-Host 'Failed:        ' -NoNewline
Write-Host $failed -ForegroundColor $(if ($failed -gt 0) { 'Red' } else { 'Green' })

if ($failedScripts.Count -gt 0) {
    Write-Host "`nFailed Scripts:" -ForegroundColor Red
    $failedScripts | ForEach-Object {
        Write-Host "  - $_" -ForegroundColor Red
    }
}

Write-Host "`n"

return $results
