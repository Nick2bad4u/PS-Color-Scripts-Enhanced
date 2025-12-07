# ============================================================================
# PS-Color-Scripts-Enhanced - Modern Coverage Analysis
# ============================================================================
# Powered by Pester 5.7+ with advanced coverage tracking and beautiful output
# Supports: JaCoCo format, HTML reports, GitHub Actions, Azure DevOps
# Updated: January 2025
# ============================================================================

#Requires -Version 5.1

[CmdletBinding(DefaultParameterSetName = 'Standard')]
param(
    # === Core Options ===
    [Parameter(ParameterSetName = 'Standard')]
    [Parameter(ParameterSetName = 'Advanced')]
    [switch]$ShowReport,

    [Parameter(ParameterSetName = 'Standard')]
    [Parameter(ParameterSetName = 'Advanced')]
    [ValidateRange(0, 100)]
    [int]$MinimumCoverage = 75,

    [Parameter(ParameterSetName = 'Standard')]
    [Parameter(ParameterSetName = 'Advanced')]
    [switch]$CI,

    # === Output Control ===
    [Parameter(ParameterSetName = 'Standard')]
    [ValidateSet('None', 'Minimal', 'Normal', 'Detailed', 'Diagnostic')]
    [string]$Verbosity = 'Normal',

    # === Advanced Filtering ===
    [Parameter(ParameterSetName = 'Advanced')]
    [string[]]$Tag,

    [Parameter(ParameterSetName = 'Advanced')]
    [string[]]$ExcludeTag,

    [Parameter(ParameterSetName = 'Advanced')]
    [string]$TestPath,

    # === Coverage Options ===
    [Parameter(ParameterSetName = 'Standard')]
    [Parameter(ParameterSetName = 'Advanced')]
    [switch]$UseBreakpoints,

    [Parameter(ParameterSetName = 'Standard')]
    [Parameter(ParameterSetName = 'Advanced')]
    [switch]$SkipCoverage,

    # === Output Formats ===
    [Parameter(ParameterSetName = 'Standard')]
    [Parameter(ParameterSetName = 'Advanced')]
    [ValidateSet('JaCoCo', 'CoverageGutters')]
    [string]$CoverageFormat = 'JaCoCo',

    # === Debug & Development ===
    [Parameter(ParameterSetName = 'Advanced')]
    [switch]$PassThru,

    [Parameter(ParameterSetName = 'Advanced')]
    [switch]$ShowNavigationMarkers
)


# ============================================================================
# INITIALIZATION & SETUP
# ============================================================================

$originalEAP = $ErrorActionPreference
$ErrorActionPreference = 'Stop'
$startTime = Get-Date

# Colors for output (CI-friendly)
$script:Colors = @{
    Header    = 'Cyan'
    Success   = 'Green'
    Warning   = 'Yellow'
    Error     = 'Red'
    Info      = 'Gray'
    Highlight = 'Magenta'
    Dim       = 'DarkGray'
}

# Helper function for beautiful output
function Write-ColorLine {
    param(
        [string]$Message,
        [string]$Color = 'White',
        [switch]$NoNewline
    )
    if ($CI) {
        Write-Host $Message -NoNewline:$NoNewline
    }
    else {
        Write-Host $Message -ForegroundColor $Color -NoNewline:$NoNewline
    }
}

function Write-SectionHeader {
    param([string]$Title)
    Write-ColorLine "`n╔══════════════════════════════════════════════════════════════════════╗" -Color $script:Colors.Header
    Write-ColorLine ('║  {0,-66}  ║' -f $Title) -Color $script:Colors.Header
    Write-ColorLine '╚══════════════════════════════════════════════════════════════════════╝' -Color $script:Colors.Header
}

function Write-InfoLine {
    param([string]$Label, [string]$Value, [string]$ValueColor = 'White')
    Write-ColorLine "  $Label`: " -Color $script:Colors.Info -NoNewline
    Write-ColorLine $Value -Color $ValueColor
}

# ============================================================================
# PESTER MODULE VALIDATION
# ============================================================================

Write-SectionHeader 'Pester 5.7+ Detection & Installation'

$pesterModule = Get-Module -ListAvailable -Name Pester |
    Where-Object { $_.Version -ge '5.7.0' } |
        Sort-Object Version -Descending |
            Select-Object -First 1

if (-not $pesterModule) {
    Write-ColorLine '  ⚠ Pester 5.7+ not found. Installing latest version...' -Color $script:Colors.Warning
    try {
        Install-Module -Name Pester -MinimumVersion 5.7.0 -Force -SkipPublisherCheck -Scope CurrentUser -AllowClobber
        $pesterModule = Get-Module -ListAvailable -Name Pester |
            Where-Object { $_.Version -ge '5.7.0' } |
                Select-Object -First 1
        Write-ColorLine "  ✓ Installed Pester $($pesterModule.Version)" -Color $script:Colors.Success
    }
    catch {
        Write-ColorLine "  ✗ Failed to install Pester: $_" -Color $script:Colors.Error
        exit 1
    }
}
else {
    Write-ColorLine "  ✓ Found Pester $($pesterModule.Version)" -Color $script:Colors.Success
}

Import-Module Pester -MinimumVersion 5.7.0 -Force -PassThru | Out-Null

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

$repoRoot = Split-Path -Parent $PSScriptRoot
$testsPath = if ($TestPath) { $TestPath } else { Join-Path $repoRoot 'Tests' }
$modulePath = Join-Path $repoRoot 'ColorScripts-Enhanced'
$coverageOutputPath = Join-Path $repoRoot 'coverage.xml'
$coverageReportPath = Join-Path $repoRoot 'coverage-report'
$testResultPath = Join-Path $repoRoot 'testResults.junit.xml'

Write-SectionHeader 'Configuration'
Write-InfoLine 'Repository Root' $repoRoot -ValueColor $script:Colors.Info
Write-InfoLine 'Tests Path' $testsPath -ValueColor $script:Colors.Info
Write-InfoLine 'Module Path' $modulePath -ValueColor $script:Colors.Info
Write-InfoLine 'Coverage Output' $coverageOutputPath -ValueColor $script:Colors.Info
Write-InfoLine 'Test Results' $testResultPath -ValueColor $script:Colors.Info
Write-InfoLine 'CI Mode' $(if ($CI) { 'Enabled' } else { 'Disabled' }) -ValueColor $(if ($CI) { $script:Colors.Highlight } else { $script:Colors.Dim })
Write-InfoLine 'Coverage Target' "$MinimumCoverage%" -ValueColor $script:Colors.Highlight

# ============================================================================
# COVERAGE TARGET DISCOVERY
# ============================================================================

Write-SectionHeader 'Coverage Target Discovery'

$coverageTargets = @()

# Primary module file
$moduleRootFile = Join-Path $modulePath 'ColorScripts-Enhanced.psm1'
if (Test-Path $moduleRootFile) {
    $coverageTargets += $moduleRootFile
    Write-ColorLine '  ✓ Module root: ' -Color $script:Colors.Success -NoNewline
    Write-ColorLine (Split-Path -Leaf $moduleRootFile) -Color $script:Colors.Dim
}

# Install script
$installScriptPath = Join-Path $modulePath 'Install.ps1'
if (Test-Path $installScriptPath) {
    $coverageTargets += $installScriptPath
    Write-ColorLine '  ✓ Install script: ' -Color $script:Colors.Success -NoNewline
    Write-ColorLine (Split-Path -Leaf $installScriptPath) -Color $script:Colors.Dim
}

# Public & Private functions
foreach ($relativeFolder in @('Public', 'Private')) {
    $folderPath = Join-Path $modulePath $relativeFolder
    if (Test-Path $folderPath) {
        $files = Get-ChildItem -Path $folderPath -Filter '*.ps1' -Recurse -File
        $coverageTargets += $files.FullName
        Write-ColorLine "  ✓ $relativeFolder functions: " -Color $script:Colors.Success -NoNewline
        Write-ColorLine "$($files.Count) files" -Color $script:Colors.Highlight
    }
}

$coverageTargets = $coverageTargets | Sort-Object -Unique | Where-Object { $_ }

if (-not $coverageTargets) {
    Write-ColorLine '  ✗ No coverage targets found!' -Color $script:Colors.Error
    exit 1
}

Write-InfoLine 'Total Coverage Targets' "$($coverageTargets.Count) files" -ValueColor $script:Colors.Success


# ============================================================================
# PESTER CONFIGURATION (Pester 5.7.1 Modern Settings)
# ============================================================================

Write-SectionHeader 'Pester Configuration (v5.7.1 Modern Features)'

$config = New-PesterConfiguration

# === Run Configuration ===
$config.Run.Path = $testsPath
$config.Run.Exit = $CI.IsPresent
$config.Run.PassThru = $true
$config.Run.SkipRun = $false
$config.Run.TestExtension = '.Tests.ps1'

if ($Tag) {
    $config.Filter.Tag = $Tag
    Write-InfoLine 'Filter Tags' ($Tag -join ', ') -ValueColor $script:Colors.Highlight
}
if ($ExcludeTag) {
    $config.Filter.ExcludeTag = $ExcludeTag
    Write-InfoLine 'Exclude Tags' ($ExcludeTag -join ', ') -ValueColor $script:Colors.Warning
}

# === Code Coverage Configuration (Modern 2025 Settings) ===
if (-not $SkipCoverage) {
    $config.CodeCoverage.Enabled = $true
    $config.CodeCoverage.Path = $coverageTargets
    $config.CodeCoverage.OutputPath = $coverageOutputPath
    $config.CodeCoverage.OutputFormat = $CoverageFormat
    $config.CodeCoverage.OutputEncoding = 'UTF8'
    $config.CodeCoverage.CoveragePercentTarget = $MinimumCoverage

    # Modern coverage options (Pester 5.3+)
    $config.CodeCoverage.RecursePaths = $false  # Avoid double-counting in nested modules
    $config.CodeCoverage.UseBreakpoints = if ($UseBreakpoints) { $true } else { $false }
    $config.CodeCoverage.SingleHitBreakpoints = $true  # Faster coverage collection

    Write-ColorLine '  ✓ Coverage enabled with modern settings:' -Color $script:Colors.Success
    Write-InfoLine '    Format' $CoverageFormat -ValueColor $script:Colors.Info
    Write-InfoLine '    Breakpoints' $(if ($UseBreakpoints) { 'Enabled (slower but more accurate)' } else { 'Disabled (faster)' }) -ValueColor $(if ($UseBreakpoints) { $script:Colors.Warning } else { $script:Colors.Success })
    Write-InfoLine '    Recursion' 'Disabled (avoid double-counting)' -ValueColor $script:Colors.Info
    Write-InfoLine '    Single-Hit Mode' 'Enabled (performance)' -ValueColor $script:Colors.Success
}
else {
    $config.CodeCoverage.Enabled = $false
    Write-ColorLine '  ⚠ Coverage collection disabled' -Color $script:Colors.Warning
}

# === Output Configuration (Pester 5.7) ===
$config.Output.Verbosity = $Verbosity
$config.Output.StackTraceVerbosity = 'Filtered'  # Clean stack traces
$config.Output.CIFormat = 'Auto'  # Auto-detect GitHub Actions / Azure DevOps
$config.Output.CILogLevel = 'Error'  # Only errors in CI logs
$config.Output.RenderMode = if ($CI) { 'Plaintext' } else { 'Auto' }  # ANSI colors when supported

# === Should Configuration ===
$config.Should.ErrorAction = 'Continue'  # Continue on assertion failures

# === TestResult Configuration (JUnit for CI) ===
$config.TestResult.Enabled = $true
$config.TestResult.OutputPath = $testResultPath
$config.TestResult.OutputFormat = 'JUnitXml'
$config.TestResult.OutputEncoding = 'UTF8'

# === Debug Configuration (Advanced) ===
if ($ShowNavigationMarkers) {
    $config.Debug.ShowNavigationMarkers = $true
    Write-InfoLine 'Navigation Markers' 'Enabled' -ValueColor $script:Colors.Highlight
}
$config.Debug.ReturnRawResultObject = $PassThru.IsPresent
$config.Debug.WriteDebugMessages = $false

Write-ColorLine '  ✓ Configuration complete' -Color $script:Colors.Success

# Suppress verbose output during test execution
if ($CI) {
    $VerbosePreference = 'SilentlyContinue'
    $WarningPreference = 'SilentlyContinue'
    $InformationPreference = 'SilentlyContinue'
}

# ============================================================================
# TEST EXECUTION
# ============================================================================

Write-SectionHeader 'Executing Pester Tests'

try {
    $result = Invoke-Pester -Configuration $config
}
catch {
    Write-ColorLine "  ✗ Test execution failed: $_" -Color $script:Colors.Error
    $ErrorActionPreference = $originalEAP
    exit 1
}

$duration = (Get-Date) - $startTime
$durationText = '{0:mm}m {0:ss}s' -f $duration


# ============================================================================
# RESULTS ANALYSIS & REPORTING
# ============================================================================

# Verify outputs were generated
$coverageFileExists = Test-Path $coverageOutputPath
$testResultFileExists = Test-Path $testResultPath

if (-not $SkipCoverage -and -not $coverageFileExists) {
    Write-ColorLine "  ✗ Coverage file was not generated: $coverageOutputPath" -Color $script:Colors.Error
    if ($CI) { exit 1 }
}

if (-not $testResultFileExists) {
    Write-ColorLine "  ⚠ Test result file was not generated: $testResultPath" -Color $script:Colors.Warning
}

# ============================================================================
# TEST RESULTS SUMMARY
# ============================================================================

Write-SectionHeader 'Test Results Summary'

$passedColor = if ($result.PassedCount -eq $result.TotalCount) { $script:Colors.Success } else { $script:Colors.Info }
$failedColor = if ($result.FailedCount -gt 0) { $script:Colors.Error } else { $script:Colors.Dim }

Write-ColorLine '  Total Tests:     ' -Color $script:Colors.Info -NoNewline
Write-ColorLine $result.TotalCount.ToString().PadLeft(6) -Color $script:Colors.Highlight

Write-ColorLine '  ✓ Passed:        ' -Color $passedColor -NoNewline
Write-ColorLine $result.PassedCount.ToString().PadLeft(6) -Color $passedColor

Write-ColorLine '  ✗ Failed:        ' -Color $failedColor -NoNewline
Write-ColorLine $result.FailedCount.ToString().PadLeft(6) -Color $failedColor

if ($result.SkippedCount -gt 0) {
    Write-ColorLine '  ⊘ Skipped:       ' -Color $script:Colors.Warning -NoNewline
    Write-ColorLine $result.SkippedCount.ToString().PadLeft(6) -Color $script:Colors.Warning
}

if ($result.NotRunCount -gt 0) {
    Write-ColorLine '  - Not Run:       ' -Color $script:Colors.Dim -NoNewline
    Write-ColorLine $result.NotRunCount.ToString().PadLeft(6) -Color $script:Colors.Dim
}

Write-ColorLine '  ⏱ Duration:      ' -Color $script:Colors.Info -NoNewline
Write-ColorLine $durationText.PadLeft(6) -Color $script:Colors.Highlight

# Show failed tests details
if ($result.FailedCount -gt 0) {
    Write-SectionHeader 'Failed Tests Details'
    foreach ($failed in $result.Failed) {
        Write-ColorLine "  ✗ $($failed.ExpandedName)" -Color $script:Colors.Error
        if ($failed.ErrorRecord) {
            Write-ColorLine "    Error: $($failed.ErrorRecord.Exception.Message)" -Color $script:Colors.Dim
            if ($failed.ErrorRecord.ScriptStackTrace -and $Verbosity -eq 'Detailed') {
                Write-ColorLine "    Stack: $($failed.ErrorRecord.ScriptStackTrace)" -Color $script:Colors.Dim
            }
        }
    }
}

# ============================================================================
# CODE COVERAGE ANALYSIS (Modern Pester 5.3+ Properties)
# ============================================================================

if (-not $SkipCoverage -and $result.CodeCoverage) {
    Write-SectionHeader 'Code Coverage Analysis'

    $coverage = $result.CodeCoverage

    # Pester 5.7+ uses different property structure
    $commandsExecuted = 0
    $commandsAnalyzed = 0

    # Try direct properties first (Pester 5.7+)
    if ($null -ne $coverage.CommandsExecutedCount -and $null -ne $coverage.CommandsAnalyzedCount) {
        $commandsExecuted = $coverage.CommandsExecutedCount
        $commandsAnalyzed = $coverage.CommandsAnalyzedCount
    }
    elseif ($null -ne $coverage.NumberOfCommandsExecuted -and $null -ne $coverage.NumberOfCommandsAnalyzed) {
        $commandsExecuted = $coverage.NumberOfCommandsExecuted
        $commandsAnalyzed = $coverage.NumberOfCommandsAnalyzed
    }
    elseif ($coverage.CoverageReport) {
        # Modern Pester 5.3+
        $commandsExecuted = $coverage.CoverageReport.CommandsExecutedCount
        $commandsAnalyzed = $coverage.CoverageReport.CommandsAnalyzedCount
    }
    elseif ($coverage.CommandsExecuted -and $coverage.CommandsAnalyzed) {
        # Older Pester versions
        $commandsExecuted = $coverage.CommandsExecuted.Count
        $commandsAnalyzed = $coverage.CommandsAnalyzed.Count
    }

    $commandsMissed = $commandsAnalyzed - $commandsExecuted

    if ($commandsAnalyzed -gt 0) {
        $percentage = [math]::Round(($commandsExecuted / $commandsAnalyzed) * 100, 2)

        # Coverage color coding
        $coverageColor = if ($percentage -ge $MinimumCoverage) {
            $script:Colors.Success
        }
        elseif ($percentage -ge 75) {
            $script:Colors.Warning
        }
        else {
            $script:Colors.Error
        }

        # Main coverage stats
        Write-ColorLine '  Coverage:        ' -Color $script:Colors.Info -NoNewline
        Write-ColorLine "$percentage%" -Color $coverageColor -NoNewline
        Write-ColorLine " ($commandsExecuted / $commandsAnalyzed commands)" -Color $script:Colors.Dim

        Write-ColorLine '  Target:          ' -Color $script:Colors.Info -NoNewline
        Write-ColorLine "$MinimumCoverage%" -Color $script:Colors.Highlight

        Write-ColorLine '  Missed Commands: ' -Color $script:Colors.Info -NoNewline
        Write-ColorLine $commandsMissed.ToString() -Color $(if ($commandsMissed -gt 0) { $script:Colors.Warning } else { $script:Colors.Success })

        # Per-file coverage breakdown (Modern Pester 5.3+)
        if ($coverage.CoverageReport -and $coverage.CoverageReport.AnalyzedFiles -and -not $CI) {
            Write-ColorLine "`n  📊 Per-File Coverage (Bottom 20):" -Color $script:Colors.Highlight
            Write-ColorLine ('  {0,-50} {1,10} {2,10} {3,12}' -f 'File', 'Coverage', 'Hit/Total', 'Status') -Color $script:Colors.Dim
            Write-ColorLine ('  ' + ('-' * 84)) -Color $script:Colors.Dim

            $coverage.CoverageReport.AnalyzedFiles |
                ForEach-Object {
                    $fileCoverage = if ($_.CommandsAnalyzedCount -gt 0) {
                        [math]::Round(($_.CommandsExecutedCount / $_.CommandsAnalyzedCount) * 100, 2)
                    }
                    else { 0 }

                    $fileName = Split-Path -Leaf $_.File
                    if ($fileName.Length -gt 45) {
                        $fileName = $fileName.Substring(0, 42) + '...'
                    }

                    $statusIcon = if ($fileCoverage -ge 90) { '✓' }
                    elseif ($fileCoverage -ge 70) { '⚠' }
                    else { '✗' }

                    $statusColor = if ($fileCoverage -ge 90) { $script:Colors.Success }
                    elseif ($fileCoverage -ge 70) { $script:Colors.Warning }
                    else { $script:Colors.Error }

                    [pscustomobject]@{
                        File         = $fileName
                        Coverage     = $fileCoverage
                        CoverageText = '{0,6}%' -f $fileCoverage
                        Executed     = $_.CommandsExecutedCount
                        Total        = $_.CommandsAnalyzedCount
                        HitRatio     = '{0,3}/{1,-3}' -f $_.CommandsExecutedCount, $_.CommandsAnalyzedCount
                        StatusIcon   = $statusIcon
                        StatusColor  = $statusColor
                    }
                } |
                    Sort-Object Coverage |
                        Select-Object -First 20 |
                            ForEach-Object {
                                Write-ColorLine ('  {0,-50}' -f $_.File) -Color $script:Colors.Info -NoNewline
                                Write-ColorLine (' {0,10}' -f $_.CoverageText) -Color $_.StatusColor -NoNewline
                                Write-ColorLine (' {0,10}' -f $_.HitRatio) -Color $script:Colors.Dim -NoNewline
                                Write-ColorLine (' {0,7} {1,3}' -f '', $_.StatusIcon) -Color $_.StatusColor
                            }
        }

        # Show top missed commands for quick reference
        if ($coverage.MissedCommands -and $coverage.MissedCommands.Count -gt 0 -and -not $CI) {
            $topMissed = $coverage.MissedCommands | Select-Object -First 15
            Write-ColorLine "`n  ⚠ Top 15 Missed Commands:" -Color $script:Colors.Warning
            Write-ColorLine ('  {0,-35} {1,6} {2,-40}' -f 'File', 'Line', 'Command') -Color $script:Colors.Dim
            Write-ColorLine ('  ' + ('-' * 84)) -Color $script:Colors.Dim

            foreach ($missed in $topMissed) {
                $fileName = Split-Path -Leaf $missed.File
                if ($fileName.Length -gt 30) {
                    $fileName = $fileName.Substring(0, 27) + '...'
                }
                $command = $missed.Command
                if ($command.Length -gt 38) {
                    $command = $command.Substring(0, 35) + '...'
                }
                Write-ColorLine ('  {0,-35} {1,6} {2,-40}' -f $fileName, $missed.Line, $command) -Color $script:Colors.Dim
            }
        }

        # Coverage threshold check
        if ($percentage -lt $MinimumCoverage) {
            $deficit = $MinimumCoverage - $percentage
            Write-ColorLine "`n  ✗ Coverage BELOW target by $deficit%" -Color $script:Colors.Error
            if ($CI) {
                $ErrorActionPreference = $originalEAP
                exit 1
            }
        }
        else {
            Write-ColorLine "`n  ✓ Coverage meets target ($MinimumCoverage%)" -Color $script:Colors.Success
        }
    }
    else {
        Write-ColorLine '  ⚠ No commands analyzed for coverage' -Color $script:Colors.Warning
    }
}


# ============================================================================
# HTML REPORT GENERATION (Optional)
# ============================================================================

if ($ShowReport -and $coverageFileExists) {
    Write-SectionHeader 'HTML Coverage Report Generation'

    # Check for ReportGenerator (.NET Global Tool)
    $reportGenerator = Get-Command reportgenerator -ErrorAction SilentlyContinue

    if (-not $reportGenerator) {
        Write-ColorLine '  ⚠ ReportGenerator not found. Installing...' -Color $script:Colors.Warning
        try {
            $dotnetExists = Get-Command dotnet -ErrorAction SilentlyContinue
            if (-not $dotnetExists) {
                Write-ColorLine '  ✗ .NET SDK not found. Install from: https://dotnet.microsoft.com/download' -Color $script:Colors.Error
            }
            else {
                $installOutput = dotnet tool install -g dotnet-reportgenerator-globaltool 2>&1
                $reportGenerator = Get-Command reportgenerator -ErrorAction SilentlyContinue
                if ($reportGenerator) {
                    Write-ColorLine '  ✓ ReportGenerator installed successfully' -Color $script:Colors.Success
                }
                else {
                    Write-ColorLine "  ✗ ReportGenerator installation failed: $installOutput" -Color $script:Colors.Error
                }
            }
        }
        catch {
            Write-ColorLine "  ✗ Error installing ReportGenerator: $_" -Color $script:Colors.Error
        }
    }

    if ($reportGenerator) {
        Write-ColorLine '  ⚙ Generating HTML report...' -Color $script:Colors.Info
        try {
            & reportgenerator `
                "-reports:$coverageOutputPath" `
                "-targetdir:$coverageReportPath" `
                '-reporttypes:Html;Badges;TextSummary' `
                '-verbosity:Warning' 2>&1 | Out-Null

            $indexPath = Join-Path $coverageReportPath 'index.html'
            if (Test-Path $indexPath) {
                Write-ColorLine '  ✓ HTML report generated: ' -Color $script:Colors.Success -NoNewline
                Write-ColorLine $indexPath -Color $script:Colors.Highlight

                # Open in browser if not in CI
                if (-not $CI) {
                    Write-ColorLine '  🌐 Opening report in browser...' -Color $script:Colors.Info
                    Start-Process $indexPath
                }
            }
            else {
                Write-ColorLine '  ⚠ Report generation completed but index.html not found' -Color $script:Colors.Warning
            }
        }
        catch {
            Write-ColorLine "  ✗ Report generation failed: $_" -Color $script:Colors.Error
        }
    }
}

# ============================================================================
# FINAL SUMMARY
# ============================================================================

Write-SectionHeader 'Final Summary'

$overallStatus = if ($result.FailedCount -eq 0 -and
    (-not $coverage -or $percentage -ge $MinimumCoverage)) {
    '✓ SUCCESS'
}
else {
    '✗ FAILURE'
}

$statusColor = if ($overallStatus -match 'SUCCESS') {
    $script:Colors.Success
}
else {
    $script:Colors.Error
}

Write-ColorLine '  Status: ' -Color $script:Colors.Info -NoNewline
Write-ColorLine $overallStatus -Color $statusColor

Write-ColorLine '  Tests: ' -Color $script:Colors.Info -NoNewline
$testStatus = "$($result.PassedCount)/$($result.TotalCount) passed"
$testColor = if ($result.FailedCount -eq 0) { $script:Colors.Success } else { $script:Colors.Error }
Write-ColorLine $testStatus -Color $testColor

if (-not $SkipCoverage) {
    Write-ColorLine '  Coverage: ' -Color $script:Colors.Info -NoNewline
    $coverageStatus = "$percentage% (target: $MinimumCoverage%)"
    $covColor = if ($percentage -ge $MinimumCoverage) { $script:Colors.Success } else { $script:Colors.Error }
    Write-ColorLine $coverageStatus -Color $covColor
}

Write-ColorLine '  Duration: ' -Color $script:Colors.Info -NoNewline
Write-ColorLine $durationText -Color $script:Colors.Highlight

if ($coverageFileExists) {
    Write-ColorLine '  Coverage File: ' -Color $script:Colors.Info -NoNewline
    Write-ColorLine $coverageOutputPath -Color $script:Colors.Dim
}

if ($testResultFileExists) {
    Write-ColorLine '  JUnit Results: ' -Color $script:Colors.Info -NoNewline
    Write-ColorLine $testResultPath -Color $script:Colors.Dim
}

# ============================================================================
# CLEANUP & EXIT
# ============================================================================

$ErrorActionPreference = $originalEAP

if ($PassThru) {
    return $result
}

if ($CI) {
    # Exit with proper code for CI
    $exitCode = if ($result.FailedCount -gt 0) { 1 }
    elseif (-not $SkipCoverage -and $percentage -lt $MinimumCoverage) { 1 }
    else { 0 }

    Write-ColorLine "`n  Exit Code: $exitCode" -Color $(if ($exitCode -eq 0) { $script:Colors.Success } else { $script:Colors.Error })
    exit $exitCode
}

Write-ColorLine "`n" -Color $script:Colors.Info
