function New-ColorScriptCache {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Returns structured pipeline records for each cache operation.')]
    [OutputType([pscustomobject])]
    [CmdletBinding(DefaultParameterSetName = 'Selection', SupportsShouldProcess = $true, ConfirmImpact = 'Medium', HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache')]
    [Alias('Update-ColorScriptCache', 'Build-ColorScriptCache')]
    param(
        [Parameter(ParameterSetName = 'Help')]
        [Alias('help')]
        [switch]$h,

        [Parameter(ParameterSetName = 'Selection', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SupportsWildcards()]
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowWildcard })]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

                $null = $commandName, $parameterName, $commandAst, $fakeBoundParameters

                try {
                    $records = ColorScripts-Enhanced\Get-ColorScriptList -AsObject -Quiet -ErrorAction Stop -WarningAction SilentlyContinue
                }
                catch {
                    return
                }

                $pattern = if ([string]::IsNullOrWhiteSpace($wordToComplete)) {
                    '*'
                }
                else {
                    $trimmed = $wordToComplete.Trim([char]0x27, [char]0x22)
                    if ([string]::IsNullOrWhiteSpace($trimmed)) { '*' }
                    elseif ($trimmed -match '[*?]') { $trimmed }
                    else { $trimmed + '*' }
                }

                $records |
                    Where-Object { $_.Name -and ($_.Name -like $pattern) } |
                        Group-Object -Property Name |
                            Sort-Object -Property Name |
                                ForEach-Object {
                                    $first = $_.Group | Select-Object -First 1
                                    $toolTip = if ($first.Description) {
                                        $first.Description
                                    }
                                    elseif ($first.Category) {
                                        "Category: $($first.Category)"
                                    }
                                    else {
                                        $first.Name
                                    }

                                    [System.Management.Automation.CompletionResult]::new(
                                        $first.Name,
                                        $first.Name,
                                        [System.Management.Automation.CompletionResultType]::ParameterValue,
                                        $toolTip
                                    )
                                }
            })]
        [string[]]$Name,

        [Parameter(ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [switch]$Force,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [switch]$PassThru,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [string[]]$Category,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [string[]]$Tag
    )

    begin {
        $helpRequested = $false
        $summary = $null
        $results = $null
        $nameSet = $null
        $collectedNames = $null
        $addName = $null

        if ($h) {
            Show-ColorScriptHelp -CommandName 'New-ColorScriptCache'
            $helpRequested = $true
        }

        if ($helpRequested) {
            return
        }

        if ($PSBoundParameters.ContainsKey('All') -and -not $All) {
            Invoke-ColorScriptError -Message $script:Messages.SpecifyNameToSelectScripts -ErrorId 'ColorScriptsEnhanced.CacheSelectionMissing' -Category ([System.Management.Automation.ErrorCategory]::InvalidOperation) -Cmdlet $PSCmdlet
        }

        Initialize-CacheDirectory

        $summary = [pscustomobject]@{
            Processed = 0
            Updated   = 0
            Skipped   = 0
            Failed    = 0
        }

        $results = New-Object 'System.Collections.Generic.List[pscustomobject]'
        $nameSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $collectedNames = [System.Collections.Generic.List[string]]::new()

        $addName = {
            param([string]$Value)

            if ([string]::IsNullOrWhiteSpace($Value)) {
                return
            }

            if ($nameSet.Add($Value)) {
                [void]$collectedNames.Add($Value)
            }
        }

        if ($PSBoundParameters.ContainsKey('Name') -and $Name) {
            foreach ($value in $Name) {
                & $addName $value
            }
        }
    }

    process {
        if ($helpRequested) {
            return
        }

        if ($MyInvocation.ExpectingInput) {
            if ($PSBoundParameters.ContainsKey('Name') -and $Name) {
                foreach ($value in $Name) {
                    & $addName $value
                }
            }
            elseif ($null -ne $_) {
                $candidate = $null

                if ($_ -is [string]) {
                    $candidate = $_
                }
                elseif ($_ -is [System.Management.Automation.PSObject]) {
                    if ($_.PSObject.Properties['Name']) {
                        $candidate = [string]$_.PSObject.Properties['Name'].Value
                    }
                    elseif ($_.PSObject.Properties['ScriptName']) {
                        $candidate = [string]$_.PSObject.Properties['ScriptName'].Value
                    }
                }

                if ($candidate) {
                    & $addName $candidate
                }
            }
        }
    }

    end {
        if ($helpRequested) {
            return
        }

        $requestedNames = $collectedNames
        $allRecords = @()

        try {
            $allRecords = @(Get-ColorScriptEntry -Category $Category -Tag $Tag)
        }
        catch {
            Write-Verbose ("Get-ColorScriptEntry failed: {0}" -f $_.Exception.Message)
            $allRecords = @()
        }

        $normalized = New-Object 'System.Collections.Generic.List[object]'
        $normalize = $null
        $normalize = {
            param($Item)

            if ($null -eq $Item) {
                return
            }

            if ($Item -is [System.Collections.IEnumerable] -and -not ($Item -is [string]) -and -not ($Item -is [System.Management.Automation.PSObject]) -and -not ($Item -is [System.Collections.IDictionary])) {
                foreach ($nested in $Item) {
                    & $normalize $nested
                }
                return
            }

            [void]$normalized.Add($Item)
        }

        foreach ($entry in $allRecords) {
            & $normalize $entry
        }

        $candidateRecords = $normalized.ToArray()

        if ($requestedNames.Count -gt 0) {
            $selection = Select-RecordsByName -Records $candidateRecords -Name $requestedNames.ToArray()
            $candidateRecords = if ($selection.Records) { $selection.Records } else { @() }

            foreach ($pattern in $selection.MissingPatterns) {
                if (-not [string]::IsNullOrWhiteSpace($pattern)) {
                    Write-Warning ($script:Messages.ScriptNotFound -f $pattern)
                }
            }
        }

        if (-not $All -and $requestedNames.Count -eq 0 -and -not $Category -and -not $Tag -and -not $candidateRecords) {
            $candidateRecords = $normalized.ToArray()
        }

        $candidateRecords = @($candidateRecords | Where-Object { $_ })

        if (-not $candidateRecords -or $candidateRecords.Count -eq 0) {
            Write-Warning $script:Messages.NoScriptsSelectedForCacheBuild
            if ($PassThru) {
                return @()
            }

            return
        }

        $total = $candidateRecords.Count
        $index = 0
        $activity = 'Building colorscript cache'

        foreach ($record in $candidateRecords) {
            $index++
            $statusPercent = [math]::Min(100, [math]::Max(0, ($index / $total) * 100))
            $recordObject = if ($record -is [System.Management.Automation.PSObject]) { $record } else { [pscustomobject]$record }
            $scriptName = [string]$recordObject.Name
            $scriptPath = [string]$recordObject.Path

            if ([string]::IsNullOrWhiteSpace($scriptName) -or [string]::IsNullOrWhiteSpace($scriptPath)) {
                continue
            }

            Write-Progress -Activity $activity -Status ("Processing {0} of {1}: {2}" -f $index, $total, $scriptName) -PercentComplete $statusPercent

            $summary.Processed++

            if (-not $Force) {
                $cacheEntry = Get-CachedOutput -ScriptPath $scriptPath
                if ($cacheEntry.Available) {
                    $summary.Skipped++
                    $skipRecord = [pscustomobject]@{
                        Name        = $scriptName
                        ScriptPath  = $scriptPath
                        CacheFile   = $cacheEntry.CacheFile
                        Status      = 'SkippedUpToDate'
                        Message     = $script:Messages.StatusSkippedUpToDate
                        CacheExists = $true
                        ExitCode    = 0
                        StdOut      = $cacheEntry.Content
                        StdErr      = ''
                    }
                    [void]$results.Add($skipRecord)
                    continue
                }
            }

            if (-not (Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $scriptName -Action 'Build colorscript cache')) {
                $summary.Skipped++

                $skippedRecord = [pscustomobject]@{
                    Name        = $scriptName
                    ScriptPath  = $scriptPath
                    CacheFile   = $null
                    Status      = 'SkippedByUser'
                    Message     = $script:Messages.StatusSkippedByUser
                    CacheExists = $false
                    ExitCode    = $null
                    StdOut      = ''
                    StdErr      = ''
                }

                [void]$results.Add($skippedRecord)
                continue
            }

            $cacheResult = Build-ScriptCache -ScriptPath $scriptPath

            if ($cacheResult.Success) {
                $summary.Updated++
                $resultStatus = 'Updated'
                $resultMessage = $script:Messages.StatusCached
                $cacheExists = $true
            }
            else {
                $summary.Failed++
                $resultStatus = 'Failed'
                $errorDetail = if ($cacheResult.StdErr) {
                    $cacheResult.StdErr
                }
                elseif ($null -ne $cacheResult.ExitCode) {
                    ($script:Messages.ScriptExitedWithCode -f $cacheResult.ExitCode)
                }
                else {
                    'Cache build failed.'
                }

                Write-Warning ("Failed to cache {0}: {1}" -f $scriptName, $errorDetail)

                $resultMessage = $errorDetail
                $cacheExists = $false
            }

            $resultRecord = [pscustomobject]@{
                Name        = if ($cacheResult.ScriptName) { $cacheResult.ScriptName } else { $scriptName }
                ScriptPath  = $scriptPath
                CacheFile   = $cacheResult.CacheFile
                Status      = $resultStatus
                Message     = $resultMessage
                CacheExists = $cacheExists
                ExitCode    = $cacheResult.ExitCode
                StdOut      = $cacheResult.StdOut
                StdErr      = $cacheResult.StdErr
            }

            [void]$results.Add($resultRecord)
        }

        Write-Progress -Activity $activity -Completed -Status 'Completed'

        if (-not $PassThru -and $summary.Processed -gt 0) {
            $formatString = $null
            if ($script:Messages -and $script:Messages.ContainsKey('CacheBuildSummaryFormat')) {
                $formatString = $script:Messages.CacheBuildSummaryFormat
            }

            if ([string]::IsNullOrWhiteSpace($formatString)) {
                $formatString = 'Cache build summary: Processed {0}, Updated {1}, Skipped {2}, Failed {3}'
            }

            $summaryMessage = $formatString -f $summary.Processed, $summary.Updated, $summary.Skipped, $summary.Failed
            $summarySegment = New-ColorScriptAnsiText -Text $summaryMessage -Color 'Cyan' -NoAnsiOutput:$false
            Write-ColorScriptInformation -Message $summarySegment -Quiet:$false -PreferConsole -Color 'Cyan'
        }

        if ($PassThru) {
            return $results.ToArray()
        }
    }
}
