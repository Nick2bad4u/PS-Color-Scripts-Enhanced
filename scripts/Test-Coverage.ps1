# Run Pester tests with code coverage
# Generates coverage reports in multiple formats

#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter()]
    [switch]$ShowReport,

    [Parameter()]
    [int]$MinimumCoverage = 94,

    [Parameter()]
    [switch]$CI,

    [Parameter()]
    [ValidateSet('None', 'Default', 'Minimal', 'Passed', 'Failed', 'Pending', 'Skipped', 'Inconclusive', 'Describe', 'Context', 'Summary', 'Header', 'Fails', 'All', 'Detailed')]
    [string[]]$Show
)

$ErrorActionPreference = 'Stop'

# Ensure Pester v5+ is available
$availablePesterModule = Get-Module -ListAvailable -Name Pester | Where-Object { $_.Version -ge '5.0.0' } | Select-Object -First 1
if (-not $availablePesterModule) {
    Write-Host "Installing Pester v5..." -ForegroundColor Yellow
    Install-Module -Name Pester -MinimumVersion 5.0.0 -Force -SkipPublisherCheck -Scope CurrentUser
    Import-Module Pester -MinimumVersion 5.0.0 -Force
}
else {
    Import-Module Pester -MinimumVersion 5.0.0 -Force
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$testsPath = Join-Path $repoRoot 'Tests'
$modulePath = Join-Path $repoRoot 'ColorScripts-Enhanced'
$coverageOutputPath = Join-Path $repoRoot 'coverage.xml'
$coverageReportPath = Join-Path $repoRoot 'coverage-report'

Write-Host "`n=== ColorScripts-Enhanced Code Coverage ===" -ForegroundColor Cyan
Write-Host "Module Path: $modulePath" -ForegroundColor Gray
Write-Host "Tests Path: $testsPath" -ForegroundColor Gray
Write-Host "Coverage Output: $coverageOutputPath`n" -ForegroundColor Gray

# Configure Pester
$config = New-PesterConfiguration

# Test discovery
$config.Run.Path = $testsPath
$config.Run.Exit = $CI.IsPresent

# Code coverage settings
$config.CodeCoverage.Enabled = $true
$config.CodeCoverage.Path = @(
    (Join-Path $modulePath 'ColorScripts-Enhanced.psm1')
)
$config.CodeCoverage.OutputPath = $coverageOutputPath
$config.CodeCoverage.OutputFormat = 'JaCoCo'
$config.CodeCoverage.CoveragePercentTarget = $MinimumCoverage

# Output settings
if ($Show) {
    $config.Output.Verbosity = 'Normal'
    $config.Should.ErrorAction = 'Continue'
    # Map Show values to Pester v5 verbosity levels
    if ($Show -contains 'None') {
        $config.Output.Verbosity = 'None'
    }
    elseif ($Show -contains 'Minimal' -or $Show -contains 'Summary') {
        $config.Output.Verbosity = 'Minimal'
    }
    elseif ($Show -contains 'Default') {
        $config.Output.Verbosity = 'Normal'
    }
    elseif ($Show -contains 'Detailed' -or $Show -contains 'All') {
        $config.Output.Verbosity = 'Detailed'
    }
}
else {
    $config.Output.Verbosity = 'Detailed'
}

# Additional output control for CI
if ($CI) {
    $config.Output.Verbosity = 'Minimal'
}

# TestResult settings - use JUnit format via Export-JUnitReport
$config.TestResult.Enabled = $true
$config.TestResult.OutputPath = Join-Path $repoRoot 'testResults.junit.xml'
$config.TestResult.OutputFormat = 'JUnitXml'

# Run tests with coverage
Write-Host "Running Pester tests with code coverage analysis..." -ForegroundColor Cyan
$result = Invoke-Pester -Configuration $config

# Display coverage summary
if ($result.CodeCoverage) {
    $coverage = $result.CodeCoverage
    $commandsExecuted = $coverage.CommandsExecuted.Count
    $commandsAnalyzed = $coverage.CommandsAnalyzed.Count

    if ($commandsAnalyzed -gt 0) {
        $percentage = [math]::Round(($commandsExecuted / $commandsAnalyzed) * 100, 2)

        Write-Host "`n=== Code Coverage Summary ===" -ForegroundColor Cyan
        Write-Host "Commands Covered: $commandsExecuted / $commandsAnalyzed" -ForegroundColor White

        $color = if ($percentage -ge 80) { 'Green' } elseif ($percentage -ge 60) { 'Yellow' } else { 'Red' }
        Write-Host "Coverage: $percentage%" -ForegroundColor $color

        if ($coverage.MissedCommands -and $coverage.MissedCommands.Count -gt 0) {
            Write-Host "`nTop 10 Missed Commands:" -ForegroundColor Yellow
            $coverage.MissedCommands | Select-Object -First 10 | Format-Table File, Line, Command -AutoSize
        }

        # Check minimum coverage threshold
        if ($percentage -lt $MinimumCoverage) {
            Write-Warning "Coverage ($percentage%) is below minimum threshold ($MinimumCoverage%)"
            if ($CI) {
                exit 1
            }
        }
        else {
            Write-Host "`n✓ Coverage meets minimum threshold ($MinimumCoverage%)" -ForegroundColor Green
        }
    }
}

# Generate HTML report if requested
if ($ShowReport -and (Test-Path $coverageOutputPath)) {
    Write-Host "`nGenerating HTML coverage report..." -ForegroundColor Cyan

    # Check if reportgenerator is available
    $reportGenerator = Get-Command reportgenerator -ErrorAction SilentlyContinue

    if (-not $reportGenerator) {
        Write-Host "Installing ReportGenerator..." -ForegroundColor Yellow
        $installResult = dotnet tool install -g dotnet-reportgenerator-globaltool 2>&1
        $reportGenerator = Get-Command reportgenerator -ErrorAction SilentlyContinue
        if (-not $reportGenerator) {
            Write-Error "Failed to install ReportGenerator. Ensure .NET SDK is installed and you have network connectivity.`nDetails: $installResult"
            return
        }
    }

    if ($reportGenerator) {
        & reportgenerator `
            -reports:$coverageOutputPath `
            -targetdir:$coverageReportPath `
            -reporttypes:Html

        $indexPath = Join-Path $coverageReportPath 'index.html'
        if (Test-Path $indexPath) {
            Write-Host "✓ HTML report generated: $indexPath" -ForegroundColor Green

            # Open in browser
            if (-not $CI) {
                Start-Process $indexPath
            }
        }
    }
    else {
        Write-Warning "ReportGenerator not available. Install .NET SDK and run: dotnet tool install -g dotnet-reportgenerator-globaltool"
    }
}

# Display test results summary
Write-Host "`n=== Test Results Summary ===" -ForegroundColor Cyan
Write-Host "Total Tests: $($result.TotalCount)" -ForegroundColor White
Write-Host "Passed: $($result.PassedCount)" -ForegroundColor Green
Write-Host "Failed: $($result.FailedCount)" -ForegroundColor $(if ($result.FailedCount -gt 0) { 'Red' } else { 'Green' })
Write-Host "Skipped: $($result.SkippedCount)" -ForegroundColor Yellow

if ($result.FailedCount -gt 0) {
    Write-Host "`nFailed Tests:" -ForegroundColor Red
    $result.Failed | ForEach-Object {
        Write-Host "  - $($_.ExpandedPath)" -ForegroundColor Red
    }
}

# Exit with appropriate code
if ($CI) {
    exit $result.FailedCount
}
