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
        [string[]]$Tag,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [switch]$Parallel,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [Alias('Threads')]
        [ValidateRange(1, 256)]
        [int]$ThrottleLimit,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [switch]$Quiet,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [Alias('NoColor')]
        [switch]$NoAnsiOutput,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [switch]$IncludePokemon
    )

    begin {
        $helpRequested = $false
        $summary = $null
        $results = $null
        $nameSet = $null
        $collectedNames = $null
        $addName = $null
        $quietRequested = $Quiet.IsPresent
        $noAnsiRequested = $NoAnsiOutput.IsPresent
        $preferConsoleOutput = -not $noAnsiRequested
        $pokemonNameSet = $null
        $filterPokemon = -not $IncludePokemon

        # If the user explicitly specified categories that include Pokemon, treat that as an
        # implicit opt-in to Pokémon scripts so users can request them directly with
        # -Category Pokemon or -Category ShinyPokemon without -IncludePokemon.
        if ($PSBoundParameters.ContainsKey('Category') -and $Category -and $Category.Count -gt 0 -and $filterPokemon) {
            $normalizedCategories = $Category | Where-Object { $_ } | ForEach-Object { ([string]$_).Trim().ToLowerInvariant().Replace(' ', '') }
            $pokemonIdentifiers = @('pokemon', 'shinypokemon', 'pokemonshiny')
            if ($normalizedCategories | Where-Object { $pokemonIdentifiers -contains $_ }) {
                $filterPokemon = $false
            }
        }

        # If specific script names are requested and any are Pokémon scripts, include them even when
        # Pokémon are normally filtered out by default.
        if ($filterPokemon -and $PSBoundParameters.ContainsKey('Name') -and $Name) {
            $pokemonNames = Get-PokemonScriptNameSet
            if ($pokemonNames -and $pokemonNames.Count -gt 0) {
                foreach ($requested in @($Name | Where-Object { $_ })) {
                    if ($pokemonNames.Contains([string]$requested)) {
                        $filterPokemon = $false
                        break
                    }
                }
            }
        }

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

        if ($filterPokemon) {
            $pokemonNameSet = Get-PokemonScriptNameSet
            if (-not ($pokemonNameSet -and $pokemonNameSet.Count -gt 0)) {
                Write-Verbose 'Unable to build Pokemon exclusion list from metadata.'
                $pokemonNameSet = $null
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

        if ($filterPokemon -and $pokemonNameSet -and $pokemonNameSet.Count -gt 0) {
            $candidateRecords = $candidateRecords | Where-Object {
                $name = $_.Name
                if (-not $name) { return $true }
                -not $pokemonNameSet.Contains([string]$name)
            }
        }

        if (-not $candidateRecords -or $candidateRecords.Count -eq 0) {
            Write-Warning $script:Messages.NoScriptsSelectedForCacheBuild
            if ($PassThru) {
                return @()
            }

            return
        }

        $total = $candidateRecords.Count
        $activity = 'Building colorscript cache'
        $preparationProgressId = 1
        $executionProgressId = 2
        $resultOrder = 0
        $workQueue = New-Object 'System.Collections.Generic.List[pscustomobject]'

        $parallelRequested = $Parallel.IsPresent -or $PSBoundParameters.ContainsKey('ThrottleLimit')
        $effectiveThrottle = if ($PSBoundParameters.ContainsKey('ThrottleLimit')) {
            $ThrottleLimit
        }
        else {
            [System.Math]::Max(1, [Environment]::ProcessorCount)
        }

        if ($effectiveThrottle -gt 256) {
            $effectiveThrottle = 256
        }

        $useParallel = $parallelRequested -and ($effectiveThrottle -gt 1)

        if ($useParallel -and ($PSVersionTable.PSVersion.Major -lt 7)) {
            $parallelNotSupportedMessage = if ($script:Messages -and $script:Messages.ContainsKey('ParallelCacheNotSupported')) {
                $script:Messages.ParallelCacheNotSupported
            }
            else {
                'Parallel cache building requires PowerShell 7 or later. Falling back to sequential execution.'
            }

            Write-Warning $parallelNotSupportedMessage
            $useParallel = $false
        }

        if (-not $useParallel) {
            $index = 0

            foreach ($record in $candidateRecords) {
                $index++
                $statusPercent = [math]::Min(100, [math]::Max(0, ($index / $total) * 100))
                $recordObject = if ($record -is [System.Management.Automation.PSObject]) { $record } else { [pscustomobject]$record }
                $scriptName = [string]$recordObject.Name
                $scriptPath = [string]$recordObject.Path

                if ([string]::IsNullOrWhiteSpace($scriptName) -or [string]::IsNullOrWhiteSpace($scriptPath)) {
                    continue
                }

                Write-Progress -Id $executionProgressId -Activity $activity -Status ("Processing {0} of {1}: {2}" -f $index, $total, $scriptName) -PercentComplete $statusPercent

                $summary.Processed++

                if (-not $Force) {
                    $cacheEntry = Get-CachedOutput -ScriptPath $scriptPath
                    if ($cacheEntry.Available) {
                        $summary.Skipped++
                        $resultOrder++
                        $skipRecord = [pscustomobject]@{
                            Order      = $resultOrder
                            Record     = [pscustomobject]@{
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
                        }
                        [void]$results.Add($skipRecord)
                        continue
                    }
                }

                if (-not (Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $scriptName -Action 'Build colorscript cache')) {
                    $summary.Skipped++
                    $resultOrder++

                    $skippedRecord = [pscustomobject]@{
                        Order  = $resultOrder
                        Record = [pscustomobject]@{
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
                    }

                    [void]$results.Add($skippedRecord)
                    continue
                }

                $operation = Invoke-ColorScriptCacheOperation -ScriptName $scriptName -ScriptPath $scriptPath

                if ($operation.Warning) {
                    Write-Warning $operation.Warning
                }

                $summary.Updated += $operation.Updated
                $summary.Failed += $operation.Failed

                $resultOrder++
                [void]$results.Add([pscustomobject]@{
                        Order  = $resultOrder
                        Record = $operation.Result
                    })
            }

            Write-Progress -Id $executionProgressId -Activity $activity -Completed -Status 'Completed'
        }
        else {
            $prepareIndex = 0

            Write-Progress -Id $preparationProgressId -Activity $activity -Status ("Preparing 0 of {0}" -f $total) -PercentComplete 0

            foreach ($record in $candidateRecords) {
                $prepareIndex++
                $statusPercent = [math]::Min(100, [math]::Max(0, ($prepareIndex / $total) * 100))
                $recordObject = if ($record -is [System.Management.Automation.PSObject]) { $record } else { [pscustomobject]$record }
                $scriptName = [string]$recordObject.Name
                $scriptPath = [string]$recordObject.Path

                if ([string]::IsNullOrWhiteSpace($scriptName) -or [string]::IsNullOrWhiteSpace($scriptPath)) {
                    continue
                }

                Write-Progress -Id $preparationProgressId -Activity $activity -Status ("Preparing {0} of {1}: {2}" -f $prepareIndex, $total, $scriptName) -PercentComplete $statusPercent

                $summary.Processed++

                if (-not $Force) {
                    $cacheEntry = Get-CachedOutput -ScriptPath $scriptPath
                    if ($cacheEntry.Available) {
                        $summary.Skipped++
                        $resultOrder++
                        [void]$results.Add([pscustomobject]@{
                                Order  = $resultOrder
                                Record = [pscustomobject]@{
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
                            })
                        continue
                    }
                }

                if (-not (Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $scriptName -Action 'Build colorscript cache')) {
                    $summary.Skipped++
                    $resultOrder++
                    [void]$results.Add([pscustomobject]@{
                            Order  = $resultOrder
                            Record = [pscustomobject]@{
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
                        })
                    continue
                }

                $resultOrder++
                [void]$workQueue.Add([pscustomobject]@{
                        Order = $resultOrder
                        Name  = $scriptName
                        Path  = $scriptPath
                    })
            }

            $pendingCount = $workQueue.Count

            Write-Progress -Id $preparationProgressId -Activity $activity -Completed -Status 'Preparation complete'

            if ($pendingCount -gt 0) {
                Write-Progress -Id $executionProgressId -Activity $activity -Status ("Building 0 of {0}" -f $pendingCount) -PercentComplete 0

                $updateParallelProgress = {
                    param(
                        [int]$Completed,
                        [int]$Total,
                        [string]$ActivityName,
                        [int]$ProgressId,
                        [int]$ActiveCount,
                        [string]$CurrentName
                    )

                    $status = "Building {0} of {1}" -f $Completed, $Total

                    if ($ActiveCount -gt 0) {
                        $status += " (active {0})" -f $ActiveCount
                    }

                    if (-not [string]::IsNullOrWhiteSpace($CurrentName)) {
                        $status += ": {0}" -f $CurrentName
                    }

                    $percent = if ($Total -le 0) { 0 } else { [math]::Min(100, [math]::Max(0, ($Completed / $Total) * 100)) }
                    Write-Progress -Id $ProgressId -Activity $ActivityName -Status $status -PercentComplete $percent
                }
                $moduleManifest = Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
                $initialState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
                $null = $initialState.ImportPSModule(@($moduleManifest))

                # Create a runspace pool robustly across PS versions/hosts.
                # Prefer using the current host when available; otherwise fall back to overloads without host
                # and explicitly set min/max runspaces if needed.
                $runspacePool = $null
                try {
                    if ($Host -is [System.Management.Automation.Host.PSHost]) {
                        $runspacePool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool(1, $effectiveThrottle, $initialState, $Host)
                    }
                }
                catch {
                    $runspacePool = $null
                }

                if (-not $runspacePool) {
                    try {
                        $runspacePool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool(1, $effectiveThrottle, $initialState)
                    }
                    catch {
                        try {
                            $runspacePool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool($initialState)
                            $null = $runspacePool.SetMinRunspaces(1)
                            $null = $runspacePool.SetMaxRunspaces($effectiveThrottle)
                        }
                        catch {
                            $runspacePool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool()
                            $null = $runspacePool.SetMinRunspaces(1)
                            $null = $runspacePool.SetMaxRunspaces($effectiveThrottle)
                        }
                    }
                }

                $runspacePool.Open()

                $jobList = New-Object 'System.Collections.Generic.List[pscustomobject]'

                $workerScriptBlock = {
                    param($scriptName, $scriptPath)
                    $moduleInfo = Get-Module -Name 'ColorScripts-Enhanced'
                    if (-not $moduleInfo) {
                        Import-Module -Name $using:moduleManifest -Force -ErrorAction Stop
                        $moduleInfo = Get-Module -Name 'ColorScripts-Enhanced' -ErrorAction Stop
                    }

                    $moduleInfo.Invoke({ param($name, $path) Invoke-ColorScriptCacheOperation -ScriptName $name -ScriptPath $path }, $scriptName, $scriptPath)
                }

                try {
                    foreach ($item in $workQueue) {
                        $psInstance = [System.Management.Automation.PowerShell]::Create()
                        $psInstance.RunspacePool = $runspacePool
                        $null = $psInstance.AddCommand('Microsoft.PowerShell.Core\Invoke-Command')
                        $null = $psInstance.AddParameter('ScriptBlock', $workerScriptBlock)
                        $null = $psInstance.AddParameter('ArgumentList', @($item.Name, $item.Path))

                        $asyncResult = $psInstance.BeginInvoke()

                        [void]$jobList.Add([pscustomobject]@{
                                PowerShell = $psInstance
                                Async      = $asyncResult
                                Item       = $item
                            })
                    }

                    $completed = 0

                    while ($completed -lt $pendingCount) {
                        $processedThisCycle = $false

                        foreach ($job in $jobList.ToArray()) {
                            if (-not $job.Async.IsCompleted) {
                                continue
                            }

                            $processedThisCycle = $true

                            try {
                                $outputCollection = $job.PowerShell.EndInvoke($job.Async)
                                $operation = if ($outputCollection -and $outputCollection.Count -gt 0) { $outputCollection[0] } else { $null }

                                if ($operation) {
                                    if ($operation.Warning) {
                                        Write-Warning $operation.Warning
                                    }

                                    $summary.Updated += $operation.Updated
                                    $summary.Failed += $operation.Failed

                                    [void]$results.Add([pscustomobject]@{
                                            Order  = $job.Item.Order
                                            Record = $operation.Result
                                        })
                                }
                                else {
                                    $summary.Failed++
                                    $failureMessage = 'Cache build failed.'
                                    Write-Warning ("Failed to cache {0}: {1}" -f $job.Item.Name, $failureMessage)
                                    [void]$results.Add([pscustomobject]@{
                                            Order  = $job.Item.Order
                                            Record = [pscustomobject]@{
                                                Name        = $job.Item.Name
                                                ScriptPath  = $job.Item.Path
                                                CacheFile   = $null
                                                Status      = 'Failed'
                                                Message     = $failureMessage
                                                CacheExists = $false
                                                ExitCode    = $null
                                                StdOut      = ''
                                                StdErr      = ''
                                            }
                                        })
                                }
                            }
                            catch {
                                $summary.Failed++
                                $errorMessage = $_.Exception.Message
                                Write-Warning ("Failed to cache {0}: {1}" -f $job.Item.Name, $errorMessage)
                                [void]$results.Add([pscustomobject]@{
                                        Order  = $job.Item.Order
                                        Record = [pscustomobject]@{
                                            Name        = $job.Item.Name
                                            ScriptPath  = $job.Item.Path
                                            CacheFile   = $null
                                            Status      = 'Failed'
                                            Message     = $errorMessage
                                            CacheExists = $false
                                            ExitCode    = $null
                                            StdOut      = ''
                                            StdErr      = $errorMessage
                                        }
                                    })
                            }
                            finally {
                                $completed++
                                $job.PowerShell.Dispose()
                                [void]$jobList.Remove($job)
                                $activeCount = $jobList.Count
                                & $updateParallelProgress $completed $pendingCount $activity $executionProgressId $activeCount $job.Item.Name
                            }
                        }

                        if (-not $processedThisCycle) {
                            $activeCount = $jobList.Count
                            & $updateParallelProgress $completed $pendingCount $activity $executionProgressId $activeCount $null
                            Start-Sleep -Milliseconds 30
                        }
                    }
                }
                finally {
                    if ($runspacePool) {
                        $runspacePool.Close()
                        $runspacePool.Dispose()
                    }
                }
            }

            Write-Progress -Id $executionProgressId -Activity $activity -Completed -Status 'Completed'
        }

        $finalRecords = @()
        if ($results.Count -gt 0) {
            $finalRecords = ($results | Sort-Object Order | ForEach-Object { $_.Record })
        }

        $summary.Processed = $finalRecords.Count
        $summary.Updated = ($finalRecords | Where-Object { $_.Status -eq 'Updated' }).Count
        $summary.Failed = ($finalRecords | Where-Object { $_.Status -eq 'Failed' }).Count
        $summary.Skipped = ($finalRecords | Where-Object { $_.Status -like 'Skipped*' }).Count

        if (-not $PassThru -and $summary.Processed -gt 0) {
            $formatString = $null
            if ($script:Messages -and $script:Messages.ContainsKey('CacheBuildSummaryFormat')) {
                $formatString = $script:Messages.CacheBuildSummaryFormat
            }

            if ([string]::IsNullOrWhiteSpace($formatString)) {
                $formatString = 'Cache build summary: Processed {0}, Updated {1}, Skipped {2}, Failed {3}'
            }

            $summaryMessage = $formatString -f $summary.Processed, $summary.Updated, $summary.Skipped, $summary.Failed
            $summarySegment = New-ColorScriptAnsiText -Text $summaryMessage -Color 'Cyan' -NoAnsiOutput:$noAnsiRequested
            Write-ColorScriptInformation -Message $summarySegment -Quiet:$quietRequested -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput -Color 'Cyan'
        }

        if ($PassThru) {
            return $finalRecords
        }
    }
}
