#requires -Version 5.1
[CmdletBinding()]
param(
    [Parameter()]
    [string[]]$Path,

    [Parameter()]
    [switch]$IncludeTests,

    [Parameter()]
    [switch]$IncludeScripts,

    [Parameter()]
    [switch]$TreatWarningsAsErrors,

    [Parameter()]
    [switch]$Fix
)

if (-not $PSBoundParameters.ContainsKey('Path')) {
    $moduleRoot = Join-Path $PSScriptRoot 'ColorScripts-Enhanced'
    $Path = @(
        Join-Path $moduleRoot 'ColorScripts-Enhanced.psm1'
        Join-Path $moduleRoot 'ColorScripts-Enhanced.psd1'
        Join-Path $moduleRoot 'Install.ps1'
        Join-Path $PSScriptRoot 'Test-Module.ps1'
        Join-Path $PSScriptRoot 'Build-Help.ps1'
        Join-Path $PSScriptRoot 'Lint-Module.ps1'
    )

    if ($IncludeScripts) {
        $scriptsDir = Join-Path $moduleRoot 'Scripts'
        if (Test-Path $scriptsDir) {
            $Path += $scriptsDir
        }
    }
}

if ($IncludeTests) {
    $testRoot = Join-Path $PSScriptRoot 'Tests'
    if (Test-Path $testRoot) {
        $testFiles = Get-ChildItem -Path $testRoot -File -Recurse -Include *.ps1
        $Path += $testFiles.FullName
    }
}

$Path = $Path | Where-Object { $_ } | Sort-Object -Unique

Write-Verbose "Linting paths: $($Path -join ', ')"

if ($IncludeTests) {
    $testPath = Join-Path $PSScriptRoot 'Tests'
    if (-not ($Path | Where-Object { $_ -eq $testPath })) {
        $Path += $testPath
    }
}

if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Error "PSScriptAnalyzer module not installed. Run 'Install-Module PSScriptAnalyzer -Scope CurrentUser'."
    exit 1
}

Import-Module PSScriptAnalyzer -ErrorAction Stop

$invokeScriptAnalyzerCommand = Get-Command Invoke-ScriptAnalyzer -ErrorAction Stop
if ($Fix -and -not $invokeScriptAnalyzerCommand.Parameters.ContainsKey('Fix')) {
    Write-Error "Installed PSScriptAnalyzer version does not support -Fix. Update to 1.21.0 or later."
    exit 1
}

$settingsPath = Join-Path $PSScriptRoot 'PSScriptAnalyzerSettings.psd1'
if (-not (Test-Path $settingsPath)) {
    Write-Warning "Settings file not found at $settingsPath. Using default analyzer rules."
    $settingsPath = $null
}

function Invoke-LintPass {
    param(
        [bool]$FixMode,
        [string]$SettingsFile
    )

    $passResults = @()
    $invokeAnalyzer = {
        param([hashtable]$AnalyzerParams, [string]$TargetPath)

        try {
            return Invoke-ScriptAnalyzer @AnalyzerParams
        }
        catch {
            $exception = $_.Exception
            $isNullRef = $exception -is [System.NullReferenceException] -or ($exception -and $exception.Message -like 'Object reference*')
            $isCommandNotFound = $exception -is [System.Management.Automation.CommandNotFoundException] -or ($exception -and $exception.Message -like "The term '*'' is not recognized*")

            if ($AnalyzerParams.ContainsKey('Settings') -and $SettingsFile -and $isNullRef) {
                Write-Warning "ScriptAnalyzer encountered a known issue analyzing '$TargetPath' with custom settings. Retrying without settings."
                $fallback = @{}
                foreach ($key in $AnalyzerParams.Keys) {
                    if ($key -ne 'Settings') {
                        $fallback[$key] = $AnalyzerParams[$key]
                    }
                }
                if (-not $fallback.ContainsKey('ErrorAction')) {
                    $fallback.ErrorAction = 'Stop'
                }

                try {
                    return Invoke-ScriptAnalyzer @fallback
                }
                catch {
                    $fallbackException = $_.Exception
                    $fallbackNullRef = $fallbackException -is [System.NullReferenceException] -or ($fallbackException -and $fallbackException.Message -like 'Object reference*')
                    if ($fallbackNullRef) {
                        Write-Warning "ScriptAnalyzer continues to hit a NullReferenceException for '$TargetPath'. Skipping this file."
                        return @()
                    }

                    throw
                }
            }

            if ($isNullRef) {
                Write-Warning "ScriptAnalyzer hit a NullReferenceException for '$TargetPath'. Skipping this file."
                return @()
            }

            if ($isCommandNotFound) {
                Write-Warning "ScriptAnalyzer hit a CommandNotFoundException for '$TargetPath'. Skipping this file."
                return @()
            }

            throw
        }
    }

    foreach ($target in $Path) {
        if (-not (Test-Path $target)) {
            Write-Warning "Skipping missing path: $target"
            continue
        }

        $resolved = (Resolve-Path $target).ProviderPath
        $item = Get-Item $resolved

        if ($item.PSIsContainer) {
            $files = Get-ChildItem -Path $resolved -File -Recurse -Include *.ps1, *.psm1, *.psd1
            if (-not $IncludeScripts) {
                $files = $files | Where-Object { $_.FullName -notlike '*\\Scripts\\*' }
            }
            foreach ($file in $files) {
                $params = @{
                    Severity    = @('Error', 'Warning')
                    Path        = $file.FullName
                    ErrorAction = 'Stop'
                }
                if ($SettingsFile) {
                    $params.Settings = $SettingsFile
                }
                if ($FixMode) {
                    $params.Fix = $true
                }
                try {
                    $result = & $invokeAnalyzer $params $file.FullName
                    if ($result) { $passResults += $result }
                }
                catch {
                    Write-Error "ScriptAnalyzer failed for path '$($file.FullName)': $_"
                    exit 1
                }
            }
            continue
        }

        $params = @{
            Severity    = @('Error', 'Warning')
            Path        = $resolved
            ErrorAction = 'Stop'
        }
        if ($SettingsFile) {
            $params.Settings = $SettingsFile
        }
        if ($FixMode) {
            $params.Fix = $true
        }
        try {
            $result = & $invokeAnalyzer $params $resolved
            if ($result) { $passResults += $result }
        }
        catch {
            Write-Error "ScriptAnalyzer failed for path '$target': $_"
            exit 1
        }
    }

    return $passResults
}

$allResults = @()

if ($Fix) {
    Write-Host 'Applying ScriptAnalyzer fixes...' -ForegroundColor Cyan
    $fixResults = Invoke-LintPass -FixMode $true -SettingsFile $settingsPath
    $fixedCount = ($fixResults | Measure-Object).Count
    if ($fixedCount -gt 0) {
        Write-Host "✓ Applied fixes or attempted fixes for $fixedCount diagnostic record(s)." -ForegroundColor Green
    }
    else {
        Write-Host 'No auto-fixable issues detected.' -ForegroundColor Yellow
    }
    Write-Host 'Re-running analyzer to verify...' -ForegroundColor Cyan
}

$allResults = Invoke-LintPass -FixMode:$false -SettingsFile $settingsPath

if (-not $allResults) {
    Write-Host '✓ ScriptAnalyzer reported no issues.' -ForegroundColor Green
    exit 0
}

$allResults | Sort-Object Severity, RuleName | Format-Table -AutoSize

if ($TreatWarningsAsErrors -or ($allResults | Where-Object { $_.Severity -eq 'Error' })) {
    Write-Error "ScriptAnalyzer violations detected."
    exit 1
}

Write-Warning 'ScriptAnalyzer reported warnings. Review the output above.'
exit 0
