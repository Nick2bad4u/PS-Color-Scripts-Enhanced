<#
.SYNOPSIS
    Run PSScriptAnalyzer against the module and optional repository tooling.

.DESCRIPTION
    Analyzes every PowerShell source file that implements the module, including
    Public and Private functions. Repository maintenance scripts and Pester tests
    can be opted in separately. The bundled ANSI-art scripts are data assets and
    are intentionally excluded from the default implementation lint pass.
#>

#Requires -Version 5.1

[CmdletBinding()]
param(
    [Parameter()]
    [string[]]$Path,

    [Parameter()]
    [string]$SettingsPath,

    [Parameter()]
    [switch]$IncludeTests,

    [Parameter()]
    [switch]$IncludeScripts,

    [Parameter()]
    [switch]$TreatWarningsAsErrors,

    [Parameter()]
    [switch]$Fix,

    [Parameter()]
    [ValidateRange(1, 16)]
    [int]$AnalyzerThrottleLimit = 4,

    [Parameter()]
    [ValidateRange(30, 600)]
    [int]$AnalyzerTimeoutSeconds = 120
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Path $PSScriptRoot -Parent
$moduleRoot = Join-Path -Path $repoRoot -ChildPath 'ColorScripts-Enhanced'
$testRoot = Join-Path -Path $repoRoot -ChildPath 'Tests'

if (-not $PSBoundParameters.ContainsKey('SettingsPath')) {
    $SettingsPath = Join-Path -Path $repoRoot -ChildPath 'PSScriptAnalyzerSettings.psd1'
}
if (-not (Test-Path -LiteralPath $SettingsPath -PathType Leaf)) {
    throw "PSScriptAnalyzer settings file not found: $SettingsPath"
}

$analyzerModule = Get-Module -ListAvailable -Name PSScriptAnalyzer |
    Sort-Object -Property Version -Descending |
        Select-Object -First 1
if (-not $analyzerModule) {
    throw "PSScriptAnalyzer is required. Install it with 'Install-Module PSScriptAnalyzer -Scope CurrentUser'."
}
Import-Module -Name $analyzerModule.Path -Force -ErrorAction Stop

if ($IncludeTests) {
    $requiredPesterVersion = [version]'6.0.1'
    $pesterModule = Get-Module -ListAvailable -Name Pester |
        Where-Object Version -EQ $requiredPesterVersion |
            Select-Object -First 1
    if (-not $pesterModule) {
        throw "Pester $requiredPesterVersion is required to analyze tests. Install it with 'Install-Module Pester -RequiredVersion $requiredPesterVersion -Scope CurrentUser'."
    }
    Import-Module -Name $pesterModule.Path -Force -ErrorAction Stop
}

$invokeAnalyzerCommand = Get-Command -Name Invoke-ScriptAnalyzer -ErrorAction Stop
if ($Fix -and -not $invokeAnalyzerCommand.Parameters.ContainsKey('Fix')) {
    throw 'The installed PSScriptAnalyzer version does not support -Fix.'
}

$analyzerSettings = Import-PowerShellDataFile -LiteralPath $SettingsPath
$disabledRules = @(
    $analyzerSettings.Rules.Keys |
        Where-Object {
            $ruleSettings = $analyzerSettings.Rules[$_]
            $ruleSettings -is [System.Collections.IDictionary] -and $ruleSettings.Contains('Enable') -and -not [bool]$ruleSettings.Enable
        }
)
$configuredExcludedRules = @($analyzerSettings.ExcludeRules) + $disabledRules
$analyzerRuleNames = @(
    Get-ScriptAnalyzerRule |
        Where-Object RuleName -NotIn $configuredExcludedRules |
            Select-Object -ExpandProperty RuleName -Unique |
                Sort-Object
)
if ($analyzerRuleNames.Count -eq 0) {
    throw "PSScriptAnalyzer did not expose any enabled rules for settings file '$SettingsPath'."
}

# PSScriptAnalyzer 1.25 can throw an internal NullReferenceException when every
# built-in rule is invoked in one pass on PowerShell 7.6. Splitting the exact
# enabled rule set into two disjoint passes preserves coverage while avoiding
# that analyzer defect. Each pass also runs in a fresh process below so a
# failed analyzer state cannot contaminate subsequent files.
$ruleGroupBoundary = [int][Math]::Ceiling($analyzerRuleNames.Count / 2)
$analyzerRuleGroups = @(
    [string]::Join(',', @($analyzerRuleNames[0..($ruleGroupBoundary - 1)]))
    [string]::Join(',', @($analyzerRuleNames[$ruleGroupBoundary..($analyzerRuleNames.Count - 1)]))
) | Where-Object { $_ }

function Add-PowerShellFile {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.Generic.HashSet[string]]$Destination,

        [Parameter(Mandatory)]
        [string[]]$InputPath
    )

    foreach ($candidate in $InputPath) {
        if (-not (Test-Path -LiteralPath $candidate)) {
            throw "Lint target not found: $candidate"
        }

        $item = Get-Item -LiteralPath $candidate -ErrorAction Stop
        if ($item.PSIsContainer) {
            foreach ($file in Get-ChildItem -LiteralPath $item.FullName -Recurse -File) {
                if ($file.Extension -in @('.ps1', '.psm1', '.psd1')) {
                    [void]$Destination.Add($file.FullName)
                }
            }
        }
        elseif ($item.Extension -in @('.ps1', '.psm1', '.psd1')) {
            [void]$Destination.Add($item.FullName)
        }
    }
}

function Start-AnalyzerJobForFile {
    param(
        [Parameter(Mandatory)]
        [string]$LiteralPath,

        [Parameter(Mandatory)]
        [bool]$FixMode,

        [Parameter(Mandatory)]
        [string]$IncludedRules
    )

    $analyzerJobScript = {
        param(
            [string]$AnalyzerModulePath,
            [string]$AnalyzerSettingsPath,
            [string]$FilePath,
            [bool]$ApplyFixes,
            [string]$RulesToInclude
        )

        $ErrorActionPreference = 'Stop'
        try {
            Import-Module -Name $AnalyzerModulePath -Force -ErrorAction Stop
            $parameters = @{
                Path        = $FilePath
                Settings    = $AnalyzerSettingsPath
                Severity    = @('Error', 'Warning')
                IncludeRule = @($RulesToInclude -split ',')
                ErrorAction = 'Stop'
            }
            if ($ApplyFixes) {
                $parameters.Fix = $true
            }

            $diagnostics = @(
                Invoke-ScriptAnalyzer @parameters |
                    ForEach-Object {
                        [pscustomobject]@{
                            ScriptPath = [string]$_.ScriptPath
                            Line       = [int]$_.Line
                            Column     = [int]$_.Column
                            Severity   = [string]$_.Severity
                            RuleName   = [string]$_.RuleName
                            Message    = [string]$_.Message
                        }
                    }
            )

            @{
                Success      = $true
                FilePath     = $FilePath
                Diagnostics  = $diagnostics
                ErrorType    = $null
                ErrorMessage = $null
            } | ConvertTo-Json -Depth 5 -Compress
        }
        catch {
            @{
                Success      = $false
                FilePath     = $FilePath
                Diagnostics  = @()
                ErrorType    = $_.Exception.GetType().FullName
                ErrorMessage = $_.Exception.Message
            } | ConvertTo-Json -Depth 5 -Compress
        }
    }

    Start-Job -ScriptBlock $analyzerJobScript -ArgumentList @(
        $analyzerModule.Path,
        $SettingsPath,
        $LiteralPath,
        $FixMode,
        $IncludedRules)
}

function New-AnalyzerWorkQueue {
    param(
        [Parameter(Mandatory)]
        [string[]]$LiteralPath
    )

    $pending = New-Object 'System.Collections.Generic.Queue[object]'
    foreach ($filePath in $LiteralPath) {
        $excludedRules = if ($IncludeTests -and $filePath.StartsWith($testRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
            # Pester 6 DSL discovery and signature-compatible mock callbacks
            # produce false positives under these two analyzer rules.
            @('PSUseCorrectCasing', 'PSReviewUnusedParameter')
        }
        else {
            @()
        }

        foreach ($ruleGroup in $analyzerRuleGroups) {
            $includedRules = @(
                $ruleGroup -split ',' |
                    Where-Object { $_ -and $_ -notin $excludedRules }
            )
            if ($includedRules.Count -eq 0) {
                continue
            }

            $pending.Enqueue([pscustomobject]@{
                    FilePath      = $filePath
                    IncludedRules = [string]::Join(',', $includedRules)
                    Attempt       = 1
                    Retried       = $false
                })
        }
    }

    Write-Output -NoEnumerate $pending
}

function Start-PendingAnalyzerJob {
    param(
        [Parameter(Mandatory)]
        [System.Collections.Generic.Queue[object]]$Pending,

        [Parameter(Mandatory)]
        [hashtable]$Active,

        [Parameter(Mandatory)]
        [int]$ThrottleLimit,

        [Parameter(Mandatory)]
        [bool]$FixMode
    )

    while ($Pending.Count -gt 0 -and $Active.Count -lt $ThrottleLimit) {
        $retryInProgress = @($Active.Values | Where-Object Attempt -GT 1).Count -gt 0
        $nextAttemptIsRetry = $Pending.Peek().Attempt -gt 1
        if ($retryInProgress -or ($nextAttemptIsRetry -and $Active.Count -gt 0)) {
            return
        }

        $workItem = $Pending.Dequeue()
        $job = Start-AnalyzerJobForFile -LiteralPath $workItem.FilePath -FixMode $FixMode -IncludedRules $workItem.IncludedRules
        $Active[$job.Id] = [pscustomobject]@{
            Job           = $job
            FilePath      = $workItem.FilePath
            IncludedRules = $workItem.IncludedRules
            Attempt       = $workItem.Attempt
            Retried       = $workItem.Retried
            StartedAt     = [datetime]::UtcNow
        }
    }
}

function Receive-AnalyzerJobResponse {
    param(
        [Parameter(Mandatory)]
        [object]$Context,

        [Parameter(Mandatory)]
        [bool]$TimedOut
    )

    $job = $Context.Job
    if ($TimedOut) {
        Stop-Job -Job $job -ErrorAction SilentlyContinue
        return [pscustomobject]@{
            Response       = $null
            FailureMessage = "analysis timed out after $AnalyzerTimeoutSeconds seconds"
        }
    }

    $jobOutput = @(Receive-Job -Job $job -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue)
    $jsonResponse = $jobOutput |
        Where-Object { $_ -is [string] -and $_.TrimStart().StartsWith('{') } |
            Select-Object -Last 1

    if ($jsonResponse) {
        try {
            return [pscustomobject]@{
                Response       = $jsonResponse | ConvertFrom-Json -ErrorAction Stop
                FailureMessage = $null
            }
        }
        catch {
            return [pscustomobject]@{
                Response       = $null
                FailureMessage = "returned invalid analyzer response: $($_.Exception.Message)"
            }
        }
    }

    $failureMessage = if ($job.State -eq 'Failed' -and $job.ChildJobs[0].JobStateInfo.Reason) {
        $job.ChildJobs[0].JobStateInfo.Reason.Message
    }
    else {
        'returned no analyzer response'
    }
    return [pscustomobject]@{
        Response       = $null
        FailureMessage = $failureMessage
    }
}

function Add-AnalyzerRetryWorkItem {
    param(
        [Parameter(Mandatory)]
        [System.Collections.Generic.Queue[object]]$Pending,

        [Parameter(Mandatory)]
        [object]$Context,

        [Parameter(Mandatory)]
        [string]$FailureMessage
    )

    $failedRules = @($Context.IncludedRules -split ',' | Where-Object { $_ })
    if ($failedRules.Count -gt 1) {
        $splitBoundary = [int][Math]::Ceiling($failedRules.Count / 2)
        $splitGroups = @(
            [string]::Join(',', @($failedRules[0..($splitBoundary - 1)]))
            [string]::Join(',', @($failedRules[$splitBoundary..($failedRules.Count - 1)]))
        ) | Where-Object { $_ }

        Write-Warning "PSScriptAnalyzer failed for '$($Context.FilePath)' with $($failedRules.Count) rules ($FailureMessage); splitting that rule set into smaller isolated passes."
        foreach ($splitGroup in $splitGroups) {
            $Pending.Enqueue([pscustomobject]@{
                    FilePath      = $Context.FilePath
                    IncludedRules = $splitGroup
                    Attempt       = $Context.Attempt + 1
                    Retried       = $false
                })
        }
        return
    }

    if (-not $Context.Retried) {
        Write-Warning "PSScriptAnalyzer failed for '$($Context.FilePath)' with rule '$($failedRules[0])' ($FailureMessage); retrying that rule once in a fresh process."
        $Pending.Enqueue([pscustomobject]@{
                FilePath      = $Context.FilePath
                IncludedRules = $Context.IncludedRules
                Attempt       = $Context.Attempt + 1
                Retried       = $true
            })
        return
    }

    throw "PSScriptAnalyzer could not analyze '$($Context.FilePath)' with rule '$($failedRules[0])' after two isolated attempts: $FailureMessage"
}

function Complete-AnalyzerJob {
    param(
        [Parameter(Mandatory)]
        [int]$JobId,

        [Parameter(Mandatory)]
        [hashtable]$Active,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Queue[object]]$Pending,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.Generic.List[object]]$Diagnostic
    )

    $context = $Active[$JobId]
    $job = $context.Job
    $timedOut = $job.State -eq 'Running' -and ([datetime]::UtcNow - $context.StartedAt).TotalSeconds -ge $AnalyzerTimeoutSeconds
    if ($job.State -eq 'Running' -and -not $timedOut) {
        return
    }

    $result = Receive-AnalyzerJobResponse -Context $context -TimedOut $timedOut
    Remove-Job -Job $job -Force -ErrorAction SilentlyContinue
    $Active.Remove($JobId)

    $failureMessage = $result.FailureMessage
    if ($result.Response -and -not $result.Response.Success) {
        $failureMessage = '{0}: {1}' -f $result.Response.ErrorType, $result.Response.ErrorMessage
    }

    if ($failureMessage) {
        Add-AnalyzerRetryWorkItem -Pending $Pending -Context $context -FailureMessage $failureMessage
        return
    }

    foreach ($item in @($result.Response.Diagnostics)) {
        [void]$Diagnostic.Add($item)
    }
}

function Invoke-AnalyzerBatch {
    param(
        [Parameter(Mandatory)]
        [string[]]$LiteralPath,

        [Parameter(Mandatory)]
        [bool]$FixMode
    )

    $pending = New-AnalyzerWorkQueue -LiteralPath $LiteralPath
    $active = @{}
    $diagnostics = New-Object 'System.Collections.Generic.List[object]'
    $throttleLimit = if ($FixMode) { 1 } else { $AnalyzerThrottleLimit }
    try {
        while ($pending.Count -gt 0 -or $active.Count -gt 0) {
            Start-PendingAnalyzerJob -Pending $pending -Active $active -ThrottleLimit $throttleLimit -FixMode $FixMode

            if ($active.Count -eq 0) {
                continue
            }

            $null = Wait-Job -Job @($active.Values.Job) -Any -Timeout 1
            foreach ($jobId in @($active.Keys)) {
                Complete-AnalyzerJob -JobId $jobId -Active $active -Pending $pending -Diagnostic $diagnostics
            }
        }
    }
    finally {
        foreach ($context in @($active.Values)) {
            Stop-Job -Job $context.Job -ErrorAction SilentlyContinue
            Remove-Job -Job $context.Job -Force -ErrorAction SilentlyContinue
        }
    }

    return $diagnostics.ToArray()
}

$fileSet = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
if ($PSBoundParameters.ContainsKey('Path')) {
    Add-PowerShellFile -Destination $fileSet -InputPath $Path
}
else {
    $moduleTargets = @(
        Get-ChildItem -LiteralPath $moduleRoot -File |
            Where-Object { $_.Extension -in @('.ps1', '.psm1', '.psd1') } |
                Select-Object -ExpandProperty FullName
        Join-Path -Path $moduleRoot -ChildPath 'Public'
        Join-Path -Path $moduleRoot -ChildPath 'Private'
    )
    Add-PowerShellFile -Destination $fileSet -InputPath $moduleTargets
}

if ($IncludeScripts) {
    Add-PowerShellFile -Destination $fileSet -InputPath @($PSScriptRoot)
}
if ($IncludeTests -and -not $PSBoundParameters.ContainsKey('Path')) {
    Add-PowerShellFile -Destination $fileSet -InputPath @($testRoot)
}

$files = @($fileSet | Sort-Object)
Write-Host "Analyzing $($files.Count) PowerShell file(s)..." -ForegroundColor Cyan

if ($Fix) {
    $null = Invoke-AnalyzerBatch -LiteralPath $files -FixMode $true
}

$results = [System.Collections.Generic.List[object]]::new()
foreach ($diagnostic in Invoke-AnalyzerBatch -LiteralPath $files -FixMode $false) {
    [void]$results.Add($diagnostic)
}

if ($results.Count -eq 0) {
    Write-Host 'PSScriptAnalyzer reported no issues.' -ForegroundColor Green
    return
}

$results | Sort-Object -Property ScriptPath, Line, Column, RuleName | Format-Table -AutoSize
$hasErrors = @($results | Where-Object Severity -EQ 'Error').Count -gt 0
$hasWarnings = @($results | Where-Object Severity -EQ 'Warning').Count -gt 0
if ($hasErrors -or ($TreatWarningsAsErrors -and $hasWarnings)) {
    throw "PSScriptAnalyzer reported $($results.Count) error/warning diagnostic(s)."
}

if ($hasWarnings) {
    Write-Warning "PSScriptAnalyzer reported $(@($results | Where-Object Severity -EQ 'Warning').Count) warning diagnostic(s)."
}
else {
    Write-Host "PSScriptAnalyzer reported only $($results.Count) informational diagnostic(s)." -ForegroundColor Green
}
