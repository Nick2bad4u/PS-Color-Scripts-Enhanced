function Add-UniqueCacheBuildName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.HashSet[string]]$NameSet,
        [Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[string]]$NameList,
        [Parameter()][AllowNull()][AllowEmptyString()][string]$Value
    )

    if (-not [string]::IsNullOrWhiteSpace($Value) -and $NameSet.Add($Value)) {
        [void]$NameList.Add($Value)
    }
}

function Get-CacheBuildPipelineName {
    [CmdletBinding()]
    [OutputType([string])]
    param([Parameter()][AllowNull()][object]$InputObject)

    if ($InputObject -is [string]) { return $InputObject }
    if ($null -eq $InputObject -or $InputObject -isnot [System.Management.Automation.PSObject]) { return $null }
    if ($InputObject.PSObject.Properties['Name']) { return [string]$InputObject.PSObject.Properties['Name'].Value }
    if ($InputObject.PSObject.Properties['ScriptName']) { return [string]$InputObject.PSObject.Properties['ScriptName'].Value }
    return $null
}

function Add-FlattenedCacheBuildRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[object]]$RecordList,
        [Parameter()][AllowNull()][object]$InputObject
    )

    if ($null -eq $InputObject) { return }
    $isNestedCollection = $InputObject -is [System.Collections.IEnumerable] -and
    $InputObject -isnot [string] -and
    $InputObject -isnot [System.Management.Automation.PSObject] -and
    $InputObject -isnot [System.Collections.IDictionary]
    if ($isNestedCollection) {
        foreach ($nestedRecord in $InputObject) {
            Add-FlattenedCacheBuildRecord -RecordList $RecordList -InputObject $nestedRecord
        }
        return
    }
    [void]$RecordList.Add($InputObject)
}

function Resolve-ExactCacheBuildRecord {
    [CmdletBinding()]
    [OutputType([object[]])]
    param([Parameter(Mandatory)][AllowEmptyCollection()][string[]]$Name)

    if ($Name.Count -eq 0) { return @() }
    $records = [System.Collections.Generic.List[object]]::new()
    foreach ($requestedName in $Name) {
        if ([System.Management.Automation.WildcardPattern]::ContainsWildcardCharacters($requestedName)) { return @() }
        $record = Get-ColorScriptExactNameRecord -Name $requestedName
        if (-not $record) { return @() }
        [void]$records.Add($record)
    }
    return $records.ToArray()
}

function Get-CacheBuildSourceRecord {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$RequestedName,
        [Parameter(Mandatory)][bool]$MetadataFilterRequested,
        [Parameter()][AllowEmptyCollection()][string[]]$Category,
        [Parameter()][AllowEmptyCollection()][string[]]$Tag
    )

    $exactRecords = @()
    if ($RequestedName.Count -gt 0 -and -not $MetadataFilterRequested) {
        $exactRecords = @(Resolve-ExactCacheBuildRecord -Name $RequestedName)
    }
    try {
        if ($exactRecords.Count -eq $RequestedName.Count -and $exactRecords.Count -gt 0) { return $exactRecords }
        if ($RequestedName.Count -eq 0 -and -not $MetadataFilterRequested) { return @(Get-ColorScriptCachePolicyRecord) }
        if ($MetadataFilterRequested) { return @(Get-ColorScriptEntry -Category $Category -Tag $Tag) }
        return @(Get-ColorScriptInventory)
    }
    catch {
        Write-Verbose ("Get-ColorScriptEntry failed: {0}" -f $_.Exception.Message)
        return @()
    }
}

function Get-CacheBuildCandidateRecord {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$RequestedName,
        [Parameter()][AllowEmptyCollection()][string[]]$Category,
        [Parameter()][AllowEmptyCollection()][string[]]$Tag,
        [Parameter(Mandatory)][bool]$AllRequested
    )

    $metadataFilterRequested = ($Category -and $Category.Count -gt 0) -or ($Tag -and $Tag.Count -gt 0)
    $sourceRecords = @(Get-CacheBuildSourceRecord -RequestedName $RequestedName -MetadataFilterRequested $metadataFilterRequested -Category $Category -Tag $Tag)
    $normalizedRecords = [System.Collections.Generic.List[object]]::new()
    foreach ($record in $sourceRecords) { Add-FlattenedCacheBuildRecord -RecordList $normalizedRecords -InputObject $record }

    $candidateRecords = $normalizedRecords.ToArray()
    if ($RequestedName.Count -gt 0) {
        $selection = Select-RecordsByName -Records $candidateRecords -Name $RequestedName
        $candidateRecords = @($selection.Records)
        foreach ($pattern in $selection.MissingPatterns) {
            if (-not [string]::IsNullOrWhiteSpace($pattern)) { Write-Warning ($script:Messages.ScriptNotFound -f $pattern) }
        }
    }
    if (-not $AllRequested -and $RequestedName.Count -eq 0 -and -not $metadataFilterRequested -and -not $candidateRecords) {
        $candidateRecords = $normalizedRecords.ToArray()
    }
    return @($candidateRecords | Where-Object { $null -ne $_ })
}

function Get-CacheBuildParallelPreference {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][bool]$ParallelRequested,
        [Parameter(Mandatory)][bool]$ThrottleLimitSpecified,
        [Parameter(Mandatory)][ValidateRange(0, 256)][int]$ThrottleLimit
    )

    $effectiveThrottle = if ($ThrottleLimitSpecified) { $ThrottleLimit } else { [System.Math]::Max(1, [Environment]::ProcessorCount) }
    $useParallel = ($ParallelRequested -or $ThrottleLimitSpecified) -and $effectiveThrottle -gt 1
    if ($useParallel -and $PSVersionTable.PSVersion.Major -lt 7) {
        $message = if ($script:Messages -and $script:Messages.ContainsKey('ParallelCacheNotSupported')) {
            $script:Messages.ParallelCacheNotSupported
        }
        else { 'Parallel cache building requires PowerShell 7 or later. Falling back to sequential execution.' }
        Write-Warning $message
        $useParallel = $false
    }
    return [pscustomobject]@{ UseParallel = $useParallel; ThrottleLimit = $effectiveThrottle }
}

function ConvertTo-OrderedCacheBuildRecord {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][int]$Order,
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$ScriptPath,
        [Parameter()][AllowNull()][string]$CacheFile,
        [Parameter(Mandatory)][string]$Status,
        [Parameter(Mandatory)][AllowEmptyString()][string]$Message,
        [Parameter(Mandatory)][bool]$CacheExists,
        [Parameter()][AllowNull()][object]$ExitCode,
        [Parameter()][AllowEmptyString()][string]$StdOut = '',
        [Parameter()][AllowEmptyString()][string]$StdErr = ''
    )

    return [pscustomobject]@{
        Order  = $Order
        Record = [pscustomobject]@{
            Name        = $Name
            ScriptPath  = $ScriptPath
            CacheFile   = $CacheFile
            Status      = $Status
            Message     = $Message
            CacheExists = $CacheExists
            ExitCode    = $ExitCode
            StdOut      = $StdOut
            StdErr      = $StdErr
        }
    }
}

function Get-CacheBuildRecordIdentity {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param([Parameter()][AllowNull()][object]$Record)

    if ($null -eq $Record) { return $null }
    $recordObject = if ($Record -is [System.Management.Automation.PSObject]) { $Record } else { [pscustomobject]$Record }
    $scriptName = [string]$recordObject.Name
    $scriptPath = [string]$recordObject.Path
    if ([string]::IsNullOrWhiteSpace($scriptName) -or [string]::IsNullOrWhiteSpace($scriptPath)) { return $null }
    return [pscustomobject]@{ Name = $scriptName; Path = $scriptPath }
}

function Resolve-CacheBuildCandidate {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][pscustomobject]$Identity,
        [Parameter(Mandatory)][int]$Order,
        [Parameter(Mandatory)][bool]$ImplicitPolicySelection,
        [Parameter(Mandatory)][bool]$Force,
        [Parameter(Mandatory)][bool]$IncludeOutput,
        [Parameter(Mandatory)][System.Management.Automation.PSCmdlet]$Cmdlet
    )

    if (-not $ImplicitPolicySelection -and -not (Test-ColorScriptRequiresCache -ScriptPath $Identity.Path)) {
        $cleanup = Remove-ColorScriptCacheEntry -ScriptName $Identity.Name
        $message = if ($script:Messages -and $script:Messages.ContainsKey('StatusSkippedNotRequired')) { $script:Messages.StatusSkippedNotRequired } else { 'Skipped (caching not required)' }
        $record = ConvertTo-OrderedCacheBuildRecord -Order $Order -Name $Identity.Name -ScriptPath $Identity.Path -CacheFile $(if ($cleanup.CacheExists) { $cleanup.CacheFile } else { $null }) -Status 'SkippedNotRequired' -Message $message -CacheExists $cleanup.CacheExists -ExitCode $null
        return [pscustomobject]@{ BuildRequired = $false; Result = $record }
    }
    if (-not $Force) {
        $cacheEntry = Get-CachedOutput -ScriptPath $Identity.Path -MetadataOnly:(-not $IncludeOutput)
        if ($cacheEntry.Available) {
            $record = ConvertTo-OrderedCacheBuildRecord -Order $Order -Name $Identity.Name -ScriptPath $Identity.Path -CacheFile $cacheEntry.CacheFile -Status 'SkippedUpToDate' -Message $script:Messages.StatusSkippedUpToDate -CacheExists $true -ExitCode 0 -StdOut $cacheEntry.Content
            return [pscustomobject]@{ BuildRequired = $false; Result = $record }
        }
    }
    if (-not (Invoke-ShouldProcess -Cmdlet $Cmdlet -Target $Identity.Name -Action 'Build colorscript cache')) {
        $record = ConvertTo-OrderedCacheBuildRecord -Order $Order -Name $Identity.Name -ScriptPath $Identity.Path -Status 'SkippedByUser' -Message $script:Messages.StatusSkippedByUser -CacheExists $false -ExitCode $null
        return [pscustomobject]@{ BuildRequired = $false; Result = $record }
    }
    return [pscustomobject]@{ BuildRequired = $true; Result = $null; WorkItem = [pscustomobject]@{ Order = $Order; Name = $Identity.Name; Path = $Identity.Path } }
}

function Write-CacheBuildItemProgress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Verb,
        [Parameter(Mandatory)][int]$Index,
        [Parameter(Mandatory)][int]$Total,
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][int]$ProgressId,
        [Parameter(Mandatory)][bool]$Quiet
    )

    if ($Quiet) { return }
    $percent = [math]::Min(100, [math]::Max(0, ($Index / $Total) * 100))
    Write-Progress -Id $ProgressId -Activity 'Building colorscript cache' -Status ("{0} {1} of {2}: {3}" -f $Verb, $Index, $Total, $Name) -PercentComplete $percent
}

function Invoke-SequentialCacheBuild {
    [CmdletBinding()]
    [OutputType([pscustomobject[]])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$CandidateRecord,
        [Parameter(Mandatory)][bool]$ImplicitPolicySelection,
        [Parameter(Mandatory)][bool]$Force,
        [Parameter(Mandatory)][bool]$IncludeOutput,
        [Parameter(Mandatory)][bool]$Quiet,
        [Parameter(Mandatory)][System.Management.Automation.PSCmdlet]$Cmdlet
    )

    $results = [System.Collections.Generic.List[pscustomobject]]::new()
    $index = 0
    $order = 0
    foreach ($candidate in $CandidateRecord) {
        $index++
        $identity = Get-CacheBuildRecordIdentity -Record $candidate
        if (-not $identity) { continue }
        Write-CacheBuildItemProgress -Verb 'Processing' -Index $index -Total $CandidateRecord.Count -Name $identity.Name -ProgressId 2 -Quiet $Quiet
        $order++
        $resolution = Resolve-CacheBuildCandidate -Identity $identity -Order $order -ImplicitPolicySelection $ImplicitPolicySelection -Force $Force -IncludeOutput $IncludeOutput -Cmdlet $Cmdlet
        if (-not $resolution.BuildRequired) {
            [void]$results.Add($resolution.Result)
            continue
        }
        $operation = Invoke-ColorScriptCacheOperation -ScriptName $identity.Name -ScriptPath $identity.Path -Force:$Force
        if ($operation.Warning) { Write-Warning $operation.Warning }
        [void]$results.Add([pscustomobject]@{ Order = $order; Record = $operation.Result })
    }
    if (-not $Quiet) { Write-Progress -Id 2 -Activity 'Building colorscript cache' -Completed -Status 'Completed' }
    return $results.ToArray()
}

function Get-ParallelCacheBuildPlan {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$CandidateRecord,
        [Parameter(Mandatory)][bool]$ImplicitPolicySelection,
        [Parameter(Mandatory)][bool]$Force,
        [Parameter(Mandatory)][bool]$IncludeOutput,
        [Parameter(Mandatory)][bool]$Quiet,
        [Parameter(Mandatory)][System.Management.Automation.PSCmdlet]$Cmdlet
    )

    $results = [System.Collections.Generic.List[pscustomobject]]::new()
    $workQueue = [System.Collections.Generic.List[pscustomobject]]::new()
    $index = 0
    $order = 0
    if (-not $Quiet) { Write-Progress -Id 1 -Activity 'Building colorscript cache' -Status ("Preparing 0 of {0}" -f $CandidateRecord.Count) -PercentComplete 0 }
    foreach ($candidate in $CandidateRecord) {
        $index++
        $identity = Get-CacheBuildRecordIdentity -Record $candidate
        if (-not $identity) { continue }
        Write-CacheBuildItemProgress -Verb 'Preparing' -Index $index -Total $CandidateRecord.Count -Name $identity.Name -ProgressId 1 -Quiet $Quiet
        $order++
        $resolution = Resolve-CacheBuildCandidate -Identity $identity -Order $order -ImplicitPolicySelection $ImplicitPolicySelection -Force $Force -IncludeOutput $IncludeOutput -Cmdlet $Cmdlet
        if ($resolution.BuildRequired) { [void]$workQueue.Add($resolution.WorkItem) } else { [void]$results.Add($resolution.Result) }
    }
    if (-not $Quiet) { Write-Progress -Id 1 -Activity 'Building colorscript cache' -Completed -Status 'Preparation complete' }
    return [pscustomobject]@{ Results = $results; WorkQueue = $workQueue }
}

function Initialize-CacheBuildRunspacePool {
    [CmdletBinding()]
    [OutputType([System.Management.Automation.Runspaces.RunspacePool])]
    param(
        [Parameter(Mandatory)][ValidateRange(1, 256)][int]$ThrottleLimit,
        [Parameter(Mandatory)][string]$ModuleManifest
    )

    $initialState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
    $null = $initialState.ImportPSModule(@($ModuleManifest))
    $runspacePool = $null
    try {
        if ($Host -is [System.Management.Automation.Host.PSHost]) {
            $runspacePool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool(1, $ThrottleLimit, $initialState, $Host)
        }
    }
    catch { $runspacePool = $null }
    if (-not $runspacePool) {
        try { $runspacePool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool(1, $ThrottleLimit, $initialState) }
        catch {
            $runspacePool = [System.Management.Automation.Runspaces.RunspaceFactory]::CreateRunspacePool($initialState)
            $null = $runspacePool.SetMinRunspaces(1)
            $null = $runspacePool.SetMaxRunspaces($ThrottleLimit)
        }
    }
    $runspacePool.Open()
    return $runspacePool
}

function Get-CacheBuildWorkerScriptBlock {
    [CmdletBinding()]
    [OutputType([scriptblock])]
    param()

    return {
        param($scriptName, $scriptPath, $forceRebuild, $moduleManifest)
        $moduleInfo = Get-Module -Name 'ColorScripts-Enhanced'
        if (-not $moduleInfo) {
            Import-Module -Name $moduleManifest -Force -ErrorAction Stop
            $moduleInfo = Get-Module -Name 'ColorScripts-Enhanced' -ErrorAction Stop
        }
        $moduleInfo.Invoke({ param($name, $path, $force) Invoke-ColorScriptCacheOperation -ScriptName $name -ScriptPath $path -Force:$force }, $scriptName, $scriptPath, $forceRebuild)
    }
}

function Start-CacheBuildWorkerBatch {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[pscustomobject]]$WorkQueue,
        [Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[pscustomobject]]$JobList,
        [Parameter(Mandatory)][int]$NextWorkIndex,
        [Parameter(Mandatory)][ValidateRange(1, 256)][int]$ThrottleLimit,
        [Parameter(Mandatory)][System.Management.Automation.Runspaces.RunspacePool]$RunspacePool,
        [Parameter(Mandatory)][scriptblock]$WorkerScriptBlock,
        [Parameter(Mandatory)][bool]$Force,
        [Parameter(Mandatory)][string]$ModuleManifest
    )

    $failures = [System.Collections.Generic.List[pscustomobject]]::new()
    while ($NextWorkIndex -lt $WorkQueue.Count -and $JobList.Count -lt $ThrottleLimit) {
        $item = $WorkQueue[$NextWorkIndex]
        $NextWorkIndex++
        $powerShell = [System.Management.Automation.PowerShell]::Create()
        try {
            $powerShell.RunspacePool = $RunspacePool
            $null = $powerShell.AddCommand('Microsoft.PowerShell.Core\Invoke-Command')
            $null = $powerShell.AddParameter('ScriptBlock', $WorkerScriptBlock)
            $null = $powerShell.AddParameter('ArgumentList', @($item.Name, $item.Path, $Force, $ModuleManifest))
            $asyncResult = $powerShell.BeginInvoke()
            [void]$JobList.Add([pscustomobject]@{ PowerShell = $powerShell; Async = $asyncResult; Item = $item })
        }
        catch {
            $powerShell.Dispose()
            $message = $_.Exception.Message
            Write-Warning ("Failed to queue cache worker for {0}: {1}" -f $item.Name, $message)
            [void]$failures.Add((ConvertTo-OrderedCacheBuildRecord -Order $item.Order -Name $item.Name -ScriptPath $item.Path -Status 'Failed' -Message $message -CacheExists $false -ExitCode $null -StdErr $message))
        }
    }
    return [pscustomobject]@{ NextWorkIndex = $NextWorkIndex; Failures = $failures.ToArray() }
}

function Receive-CacheBuildWorkerBatch {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param([Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[pscustomobject]]$JobList)

    $results = [System.Collections.Generic.List[pscustomobject]]::new()
    $completedJobs = [System.Collections.Generic.List[pscustomobject]]::new()
    foreach ($job in $JobList.ToArray()) {
        if (-not $job.Async.IsCompleted) { continue }
        try {
            $outputCollection = $job.PowerShell.EndInvoke($job.Async)
            $operation = if ($outputCollection -and $outputCollection.Count -gt 0) { $outputCollection[0] } else { $null }
            if ($operation) {
                if ($operation.Warning) { Write-Warning $operation.Warning }
                [void]$results.Add([pscustomobject]@{ Order = $job.Item.Order; Record = $operation.Result })
            }
            else {
                $message = 'Cache build failed.'
                Write-Warning ("Failed to cache {0}: {1}" -f $job.Item.Name, $message)
                [void]$results.Add((ConvertTo-OrderedCacheBuildRecord -Order $job.Item.Order -Name $job.Item.Name -ScriptPath $job.Item.Path -Status 'Failed' -Message $message -CacheExists $false -ExitCode $null))
            }
        }
        catch {
            $message = $_.Exception.Message
            Write-Warning ("Failed to cache {0}: {1}" -f $job.Item.Name, $message)
            [void]$results.Add((ConvertTo-OrderedCacheBuildRecord -Order $job.Item.Order -Name $job.Item.Name -ScriptPath $job.Item.Path -Status 'Failed' -Message $message -CacheExists $false -ExitCode $null -StdErr $message))
        }
        finally {
            $job.PowerShell.Dispose()
            [void]$completedJobs.Add($job)
        }
    }
    foreach ($job in $completedJobs) { [void]$JobList.Remove($job) }
    return [pscustomobject]@{ Results = $results.ToArray(); CompletedCount = $completedJobs.Count }
}

function Write-ParallelCacheBuildProgress {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][int]$Completed,
        [Parameter(Mandatory)][int]$Total,
        [Parameter(Mandatory)][int]$ActiveCount,
        [Parameter(Mandatory)][bool]$Quiet
    )

    if ($Quiet) { return }
    $status = "Building {0} of {1}" -f $Completed, $Total
    if ($ActiveCount -gt 0) { $status += " (active {0})" -f $ActiveCount }
    $percent = if ($Total -le 0) { 0 } else { [math]::Min(100, [math]::Max(0, ($Completed / $Total) * 100)) }
    Write-Progress -Id 2 -Activity 'Building colorscript cache' -Status $status -PercentComplete $percent
}

function Invoke-ParallelCacheBuildWork {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[pscustomobject]]$WorkQueue,
        [Parameter(Mandatory)][ValidateRange(1, 256)][int]$ThrottleLimit,
        [Parameter(Mandatory)][bool]$Force,
        [Parameter(Mandatory)][bool]$Quiet
    )

    if ($WorkQueue.Count -eq 0) { return @() }
    Write-ParallelCacheBuildProgress -Completed 0 -Total $WorkQueue.Count -ActiveCount 0 -Quiet $Quiet
    $moduleManifest = Join-Path -Path $script:ModuleRoot -ChildPath 'ColorScripts-Enhanced.psd1'
    $runspacePool = Initialize-CacheBuildRunspacePool -ThrottleLimit $ThrottleLimit -ModuleManifest $moduleManifest
    $workerScriptBlock = Get-CacheBuildWorkerScriptBlock
    $jobList = [System.Collections.Generic.List[pscustomobject]]::new()
    $results = [System.Collections.Generic.List[pscustomobject]]::new()
    $nextWorkIndex = 0
    $completed = 0
    try {
        while ($completed -lt $WorkQueue.Count) {
            $start = Start-CacheBuildWorkerBatch -WorkQueue $WorkQueue -JobList $jobList -NextWorkIndex $nextWorkIndex -ThrottleLimit $ThrottleLimit -RunspacePool $runspacePool -WorkerScriptBlock $workerScriptBlock -Force $Force -ModuleManifest $moduleManifest
            $nextWorkIndex = $start.NextWorkIndex
            foreach ($failure in $start.Failures) { [void]$results.Add($failure) }
            $completed += $start.Failures.Count
            $received = Receive-CacheBuildWorkerBatch -JobList $jobList
            foreach ($result in $received.Results) { [void]$results.Add($result) }
            $completed += $received.CompletedCount
            Write-ParallelCacheBuildProgress -Completed $completed -Total $WorkQueue.Count -ActiveCount $jobList.Count -Quiet $Quiet
            if ($received.CompletedCount -eq 0 -and $start.Failures.Count -eq 0) { Start-Sleep -Milliseconds 30 }
        }
    }
    finally {
        $runspacePool.Close()
        $runspacePool.Dispose()
    }
    if (-not $Quiet) { Write-Progress -Id 2 -Activity 'Building colorscript cache' -Completed -Status 'Completed' }
    return $results.ToArray()
}

function Get-CacheBuildSummary {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param([Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Record)

    return [pscustomobject]@{
        Processed = $Record.Count
        Updated = @($Record | Where-Object Status -EQ 'Updated').Count
        Failed = @($Record | Where-Object Status -EQ 'Failed').Count
        Skipped = @($Record | Where-Object Status -Like 'Skipped*').Count
    }
}

function Write-CacheBuildActivityMarker {
    [CmdletBinding()]
    param([Parameter(Mandatory)][pscustomobject]$Summary)

    if ($Summary.Updated -le 0 -or -not $script:CacheDir) { return }
    try {
        $metadataFileName = 'cache-metadata-v{0}.json' -f $script:CacheFormatVersion
        Write-CacheMetadataFile -CacheDirectory $script:CacheDir -MetadataFileName $metadataFileName
    }
    catch { Write-Verbose ("Cache metadata update failed: {0}" -f $_.Exception.Message) }
}

function Write-CacheBuildSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][pscustomobject]$Summary,
        [Parameter(Mandatory)][bool]$Quiet,
        [Parameter(Mandatory)][bool]$NoAnsiOutput
    )

    $formatString = if ($script:Messages -and $script:Messages.ContainsKey('CacheBuildSummaryFormat')) { $script:Messages.CacheBuildSummaryFormat } else { 'Cache build summary: Processed {0}, Updated {1}, Skipped {2}, Failed {3}' }
    if ([string]::IsNullOrWhiteSpace($formatString)) { $formatString = 'Cache build summary: Processed {0}, Updated {1}, Skipped {2}, Failed {3}' }
    $directoryFormat = if ($script:Messages -and $script:Messages.ContainsKey('CacheDirectoryFormat')) { $script:Messages.CacheDirectoryFormat } else { 'Cache directory: {0}' }
    $message = ($formatString -f $Summary.Processed, $Summary.Updated, $Summary.Skipped, $Summary.Failed) + [Environment]::NewLine + ($directoryFormat -f $script:CacheDir)
    $segment = New-ColorScriptAnsiText -Text $message -Color 'Cyan' -NoAnsiOutput:$NoAnsiOutput
    Write-ColorScriptInformation -Message $segment -Quiet:$Quiet -NoAnsiOutput:$NoAnsiOutput -PreferConsole:(-not $NoAnsiOutput) -Color 'Cyan'
}

function Invoke-ColorScriptCacheBuildRequest {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$RequestedName,
        [Parameter()][AllowEmptyCollection()][string[]]$Category,
        [Parameter()][AllowEmptyCollection()][string[]]$Tag,
        [Parameter(Mandatory)][bool]$AllRequested,
        [Parameter(Mandatory)][bool]$Force,
        [Parameter(Mandatory)][bool]$PassThru,
        [Parameter(Mandatory)][bool]$ParallelRequested,
        [Parameter(Mandatory)][bool]$ThrottleLimitSpecified,
        [Parameter(Mandatory)][ValidateRange(0, 256)][int]$ThrottleLimit,
        [Parameter(Mandatory)][bool]$Quiet,
        [Parameter(Mandatory)][bool]$NoAnsiOutput,
        [Parameter(Mandatory)][System.Management.Automation.PSCmdlet]$Cmdlet
    )

    $candidateRecords = @(Get-CacheBuildCandidateRecord -RequestedName $RequestedName -Category $Category -Tag $Tag -AllRequested $AllRequested)
    if ($candidateRecords.Count -eq 0) {
        Write-Warning $script:Messages.NoScriptsSelectedForCacheBuild
        return @()
    }
    $metadataFilterRequested = ($Category -and $Category.Count -gt 0) -or ($Tag -and $Tag.Count -gt 0)
    $implicitPolicySelection = $RequestedName.Count -eq 0 -and -not $metadataFilterRequested
    $parallelPreference = Get-CacheBuildParallelPreference -ParallelRequested $ParallelRequested -ThrottleLimitSpecified $ThrottleLimitSpecified -ThrottleLimit $ThrottleLimit
    $orderedResults = if ($parallelPreference.UseParallel) {
        $plan = Get-ParallelCacheBuildPlan -CandidateRecord $candidateRecords -ImplicitPolicySelection $implicitPolicySelection -Force $Force -IncludeOutput $PassThru -Quiet $Quiet -Cmdlet $Cmdlet
        @($plan.Results) + @(Invoke-ParallelCacheBuildWork -WorkQueue $plan.WorkQueue -ThrottleLimit $parallelPreference.ThrottleLimit -Force $Force -Quiet $Quiet)
    }
    else {
        @(Invoke-SequentialCacheBuild -CandidateRecord $candidateRecords -ImplicitPolicySelection $implicitPolicySelection -Force $Force -IncludeOutput $PassThru -Quiet $Quiet -Cmdlet $Cmdlet)
    }
    $finalRecords = @($orderedResults | Sort-Object Order | ForEach-Object { $_.Record })
    $summary = Get-CacheBuildSummary -Record $finalRecords
    Write-CacheBuildActivityMarker -Summary $summary
    if (-not $PassThru -and $summary.Processed -gt 0) { Write-CacheBuildSummary -Summary $summary -Quiet $Quiet -NoAnsiOutput $NoAnsiOutput }
    if ($PassThru) { return $finalRecords }
    return @()
}

function New-ColorScriptCache {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification = 'Returns structured pipeline records for each cache operation.')]
    [OutputType([pscustomobject])]
    [CmdletBinding(DefaultParameterSetName = 'Selection', SupportsShouldProcess = $true, ConfirmImpact = 'Medium', HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache')]
    [Alias('Update-ColorScriptCache', 'Build-ColorScriptCache')]
    param(
        [Parameter(ParameterSetName = 'Help')][Alias('help')][switch]$h,
        [Parameter(ParameterSetName = 'Selection', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [SupportsWildcards()][ValidateScript({ Test-ColorScriptNameValue $_ -AllowWildcard })]
        [ArgumentCompleter({ param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters) $null = $commandName, $parameterName, $commandAst, $fakeBoundParameters; Get-ColorScriptNameCompletion -WordToComplete $wordToComplete })]
        [string[]]$Name,
        [Parameter(ParameterSetName = 'All')][switch]$All,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][switch]$Force,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][switch]$PassThru,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][string[]]$Category,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][string[]]$Tag,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][switch]$Parallel,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][Alias('Threads')][ValidateRange(1, 256)][int]$ThrottleLimit,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][switch]$Quiet,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][Alias('NoColor')][switch]$NoAnsiOutput,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][switch]$IncludePokemon
    )

    begin {
        $helpRequested = $h.IsPresent
        $nameSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $collectedNames = [System.Collections.Generic.List[string]]::new()
        $null = $IncludePokemon
        if ($helpRequested) {
            Show-ColorScriptHelp -CommandName 'New-ColorScriptCache'
            return
        }
        if ($PSBoundParameters.ContainsKey('All') -and -not $All) {
            Invoke-ColorScriptError -Message $script:Messages.SpecifyNameToSelectScripts -ErrorId 'ColorScriptsEnhanced.CacheSelectionMissing' -Category ([System.Management.Automation.ErrorCategory]::InvalidOperation) -Cmdlet $PSCmdlet
        }
        Initialize-CacheDirectory -ReadOnly:$WhatIfPreference
        foreach ($value in @($Name)) { Add-UniqueCacheBuildName -NameSet $nameSet -NameList $collectedNames -Value $value }
    }

    process {
        if ($helpRequested -or -not $MyInvocation.ExpectingInput) { return }
        if ($PSBoundParameters.ContainsKey('Name') -and $Name) {
            foreach ($value in $Name) { Add-UniqueCacheBuildName -NameSet $nameSet -NameList $collectedNames -Value $value }
            return
        }
        Add-UniqueCacheBuildName -NameSet $nameSet -NameList $collectedNames -Value (Get-CacheBuildPipelineName -InputObject $_)
    }

    end {
        if ($helpRequested) { return }
        Invoke-ColorScriptCacheBuildRequest -RequestedName $collectedNames.ToArray() -Category $Category -Tag $Tag -AllRequested $All.IsPresent -Force $Force.IsPresent -PassThru $PassThru.IsPresent -ParallelRequested $Parallel.IsPresent -ThrottleLimitSpecified $PSBoundParameters.ContainsKey('ThrottleLimit') -ThrottleLimit $ThrottleLimit -Quiet $Quiet.IsPresent -NoAnsiOutput $NoAnsiOutput.IsPresent -Cmdlet $PSCmdlet
    }
}
