function Add-UniqueColorScriptName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][AllowEmptyString()][string]$Value,
        [Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.HashSet[string]]$Set,
        [Parameter(Mandatory)][AllowEmptyCollection()][System.Collections.Generic.List[string]]$List
    )

    if (-not [string]::IsNullOrWhiteSpace($Value) -and $Set.Add($Value)) {
        [void]$List.Add($Value)
    }
}

function Get-ColorScriptPipelineName {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter()][AllowNull()][object]$InputObject
    )

    if ($InputObject -is [string]) {
        return $InputObject
    }
    if ($InputObject -isnot [System.Management.Automation.PSObject]) {
        return $null
    }
    if ($InputObject.PSObject.Properties['Name']) {
        return [string]$InputObject.PSObject.Properties['Name'].Value
    }
    if ($InputObject.PSObject.Properties['ScriptName']) {
        return [string]$InputObject.PSObject.Properties['ScriptName'].Value
    }
    return $null
}

function Resolve-ColorScriptCacheClearRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)][bool]$PathSpecified,
        [Parameter()][AllowNull()][AllowEmptyString()][string]$Path
    )

    if ($PathSpecified -and $Path) {
        $cacheRoot = Resolve-CachePath -Path $Path
        if (-not $cacheRoot) {
            Write-Warning ($script:Messages.CachePathNotFound -f $Path)
            return $null
        }
    }
    else {
        Initialize-CacheDirectory
        $cacheRoot = $script:CacheDir
        if (-not $cacheRoot) {
            Write-Warning ($script:Messages.CachePathNotFound -f '<not set>')
            return $null
        }
    }

    if (-not (Test-Path -LiteralPath $cacheRoot -PathType Container)) {
        Write-Warning ($script:Messages.CachePathNotFound -f $cacheRoot)
        return $null
    }
    return $cacheRoot
}

function Get-ColorScriptCacheInventory {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$CacheRoot
    )

    $cacheFile = @(Get-ChildItem -LiteralPath $CacheRoot -Filter '*.cache' -File -ErrorAction SilentlyContinue)
    $metadataFile = @(Get-ChildItem -LiteralPath $CacheRoot -Filter ('*{0}' -f $script:CacheEntryMetadataExtension) -File -ErrorAction SilentlyContinue)
    $entryFile = @($cacheFile + $metadataFile | Sort-Object -Property BaseName -Unique)
    $cacheLookup = @{}
    foreach ($file in $cacheFile) {
        $key = $file.BaseName.ToLowerInvariant()
        if (-not $cacheLookup.ContainsKey($key)) {
            $cacheLookup[$key] = $file
        }
    }

    return [pscustomobject]@{
        CacheFile   = $cacheFile
        MetadataFile = $metadataFile
        EntryFile   = $entryFile
        CacheLookup = $cacheLookup
    }
}

function Get-ColorScriptCacheClearMetadataRecord {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][object]$Inventory,
        [string[]]$Category,
        [string[]]$Tag
    )

    if (-not $Category -and -not $Tag) {
        $records = @($Inventory.EntryFile | ForEach-Object { [pscustomobject]@{ Name = $_.BaseName } })
        return [pscustomobject]@{ Success = $true; Record = $records }
    }

    try {
        $records = @(Get-ColorScriptEntry -Category $Category -Tag $Tag)
    }
    catch {
        Write-Verbose ("Get-ColorScriptEntry failed: {0}" -f $_.Exception.Message)
        $records = @()
    }
    if (-not $records) {
        Write-Warning $script:Messages.NoScriptsMatchedSpecifiedFilters
        return [pscustomobject]@{ Success = $false; Record = @() }
    }
    return [pscustomobject]@{ Success = $true; Record = $records }
}

function ConvertTo-ColorScriptNameRecordLookup {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Record
    )

    $lookup = @{}
    foreach ($currentRecord in $Record) {
        $key = ([string]$currentRecord.Name).ToLowerInvariant()
        if (-not [string]::IsNullOrWhiteSpace($key) -and -not $lookup.ContainsKey($key)) {
            $lookup[$key] = $currentRecord
        }
    }
    return $lookup
}

function Get-ColorScriptCacheClearSelection {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Record,
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$RequestedName,
        [Parameter(Mandatory)][bool]$FilterApplied
    )

    $missingEntry = [System.Collections.Generic.List[psobject]]::new()
    if ($RequestedName.Count -eq 0) {
        return [pscustomobject]@{ Selection = $null; MissingEntry = $missingEntry }
    }

    $selection = Select-RecordsByName -Records $Record -Name $RequestedName
    foreach ($map in @($selection.MatchMap)) {
        if ($map.Matched) {
            continue
        }
        $pattern = [string]$map.Pattern
        if ($FilterApplied) {
            Write-Warning ($script:Messages.ScriptSkippedByFilter -f $pattern)
        }
        elseif (-not [string]::IsNullOrWhiteSpace($pattern)) {
            [void]$missingEntry.Add([pscustomobject]@{ Name = $pattern })
        }
    }

    return [pscustomobject]@{ Selection = $selection; MissingEntry = $missingEntry }
}

function ConvertTo-ColorScriptPatternMatchLookup {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter()][AllowNull()][object]$Selection
    )

    $lookup = @{}
    foreach ($entry in @($Selection.MatchMap)) {
        $pattern = [string]$entry.Pattern
        if (-not [string]::IsNullOrWhiteSpace($pattern) -and -not $lookup.ContainsKey($pattern)) {
            $lookup[$pattern] = $entry
        }
    }
    return $lookup
}

function Get-AllColorScriptCacheTargetName {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)][object]$Inventory,
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$MetadataRecord,
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$RequestedName,
        [Parameter(Mandatory)][bool]$FilterApplied,
        [Parameter(Mandatory)][string]$CacheRoot
    )

    if ($Inventory.EntryFile.Count -eq 0) {
        Write-Warning ($script:Messages.NoCacheFilesFound -f $CacheRoot)
        return @()
    }

    $selectedFile = @($Inventory.EntryFile)
    if ($RequestedName.Count -gt 0) {
        $matchedFile = [System.Collections.Generic.List[System.IO.FileInfo]]::new()
        foreach ($pattern in $RequestedName) {
            foreach ($match in @($Inventory.EntryFile | Where-Object { $_.BaseName -like $pattern })) {
                [void]$matchedFile.Add($match)
            }
        }
        $selectedFile = $matchedFile.ToArray()
    }

    if ($FilterApplied) {
        $allowedName = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($record in $MetadataRecord) {
            if (-not [string]::IsNullOrWhiteSpace([string]$record.Name)) {
                [void]$allowedName.Add([string]$record.Name)
            }
        }
        $selectedFile = @($selectedFile | Where-Object { $allowedName.Contains($_.BaseName) })
    }

    if ($selectedFile.Count -eq 0) {
        Write-Warning ($script:Messages.NoCacheFilesFound -f $CacheRoot)
        return @()
    }
    return [string[]]@($selectedFile | Sort-Object -Property BaseName -Unique | ForEach-Object { $_.BaseName })
}

function Get-SelectedColorScriptCacheTargetName {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$MetadataRecord,
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$RequestedName,
        [Parameter(Mandatory)][object]$SelectionContext,
        [Parameter(Mandatory)][bool]$FilterApplied
    )

    $targetSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $targetName = [System.Collections.Generic.List[string]]::new()
    $metadataLookup = ConvertTo-ColorScriptNameRecordLookup -Record $MetadataRecord
    $patternLookup = ConvertTo-ColorScriptPatternMatchLookup -Selection $SelectionContext.Selection
    foreach ($value in $RequestedName) {
        $patternEntry = if ($patternLookup.ContainsKey($value)) { $patternLookup[$value] } else { $null }
        if ($patternEntry -and $patternEntry.Matched -and $patternEntry.Matches) {
            foreach ($matchedName in $patternEntry.Matches) {
                $key = $matchedName.ToLowerInvariant()
                $canonicalName = if ($metadataLookup.ContainsKey($key)) { [string]$metadataLookup[$key].Name } else { $matchedName }
                Add-UniqueColorScriptName -Value $canonicalName -Set $targetSet -List $targetName
            }
            continue
        }

        $key = $value.ToLowerInvariant()
        if ($metadataLookup.ContainsKey($key)) {
            Add-UniqueColorScriptName -Value ([string]$metadataLookup[$key].Name) -Set $targetSet -List $targetName
        }
        elseif (-not $FilterApplied) {
            Add-UniqueColorScriptName -Value $value -Set $targetSet -List $targetName
        }
    }

    if ($RequestedName.Count -eq 0 -and $FilterApplied) {
        foreach ($record in $MetadataRecord) {
            Add-UniqueColorScriptName -Value ([string]$record.Name) -Set $targetSet -List $targetName
        }
    }
    if ($targetName.Count -eq 0 -and $SelectionContext.MissingEntry.Count -gt 0) {
        foreach ($entry in $SelectionContext.MissingEntry) {
            Add-UniqueColorScriptName -Value ([string]$entry.Name) -Set $targetSet -List $targetName
        }
    }
    return $targetName.ToArray()
}

function Get-ColorScriptCacheEntryState {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$CacheRoot,
        [Parameter(Mandatory)][AllowEmptyCollection()][hashtable]$CacheLookup
    )

    $key = $Name.ToLowerInvariant()
    $cacheInfo = if ($CacheLookup.ContainsKey($key)) { $CacheLookup[$key] } else { $null }
    $cachePath = if ($cacheInfo) { $cacheInfo.FullName } else { Join-Path -Path $CacheRoot -ChildPath ("{0}.cache" -f $Name) }
    $cacheExists = $cacheInfo -and (Test-Path -LiteralPath $cacheInfo.FullName)
    if (-not $cacheExists) {
        $cachePath = Join-Path -Path $CacheRoot -ChildPath ("{0}.cache" -f $Name)
        $cacheExists = Test-Path -LiteralPath $cachePath
    }
    $metadataPath = Get-CacheEntryMetadataPath -ScriptName $Name -CacheRoot $CacheRoot
    $metadataExists = $metadataPath -and (Test-Path -LiteralPath $metadataPath -PathType Leaf)

    return [pscustomobject]@{
        CachePath      = $cachePath
        CacheExists    = [bool]$cacheExists
        MetadataPath   = $metadataPath
        MetadataExists = [bool]$metadataExists
        Exists         = [bool]($cacheExists -or $metadataExists)
    }
}

function ConvertTo-ColorScriptCacheClearResult {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$CacheFile,
        [Parameter(Mandatory)][string]$Status,
        [Parameter()][AllowNull()][AllowEmptyString()][string]$Message = ''
    )

    return [pscustomobject]@{ Name = $Name; CacheFile = $CacheFile; Status = $Status; Message = $Message }
}

function Invoke-ColorScriptCacheEntryFileRemoval {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object]$State
    )

    if ($State.CacheExists) {
        Remove-Item -LiteralPath $State.CachePath -Force -ErrorAction Stop
    }
    if (-not $State.MetadataExists) {
        return
    }
    if (-not $State.CacheExists) {
        # A metadata-only sidecar is the primary target, so its deletion must surface failure.
        Remove-Item -LiteralPath $State.MetadataPath -Force -ErrorAction Stop
        return
    }
    try {
        Remove-Item -LiteralPath $State.MetadataPath -Force -ErrorAction Stop
    }
    catch {
        Write-Verbose ("Failed to remove metadata '{0}': {1}" -f $State.MetadataPath, $_.Exception.Message)
    }
}

function Invoke-ColorScriptCacheClearTarget {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][string]$CacheRoot,
        [Parameter(Mandatory)][AllowEmptyCollection()][hashtable]$CacheLookup,
        [switch]$DryRun,
        [Parameter(Mandatory)][System.Management.Automation.PSCmdlet]$Cmdlet
    )

    $state = Get-ColorScriptCacheEntryState -Name $Name -CacheRoot $CacheRoot -CacheLookup $CacheLookup
    if (-not $state.Exists) {
        return ConvertTo-ColorScriptCacheClearResult -Name $Name -CacheFile $state.CachePath -Status 'Missing' -Message $script:Messages.CacheFileNotFound
    }
    if ($DryRun) {
        return ConvertTo-ColorScriptCacheClearResult -Name $Name -CacheFile $state.CachePath -Status 'DryRun' -Message $script:Messages.NoChangesApplied
    }

    $removalTarget = if ($state.CacheExists) { $state.CachePath } else { $state.MetadataPath }
    if (-not (Invoke-ShouldProcess -Cmdlet $Cmdlet -Target $removalTarget -Action 'Clear colorscript cache entry')) {
        return ConvertTo-ColorScriptCacheClearResult -Name $Name -CacheFile $state.CachePath -Status 'SkippedByUser'
    }

    try {
        Invoke-ColorScriptCacheEntryFileRemoval -State $state
        Remove-CachedOutputMemoryEntry -CacheFile $state.CachePath
        return ConvertTo-ColorScriptCacheClearResult -Name $Name -CacheFile $state.CachePath -Status 'Removed'
    }
    catch {
        Write-Warning ("Failed to remove cache file '{0}': {1}" -f $Name, $_.Exception.Message)
        return ConvertTo-ColorScriptCacheClearResult -Name $Name -CacheFile $state.CachePath -Status 'Error' -Message $_.Exception.Message
    }
}

function Add-ColorScriptCacheClearSummaryStatus {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][System.Collections.IDictionary]$Summary,
        [Parameter(Mandatory)][string]$Status
    )

    switch ($Status) {
        'Removed' { $Summary.Removed++ }
        'Missing' { $Summary.Missing++ }
        'Error' { $Summary.Errors++ }
        'DryRun' { $Summary.DryRun++ }
        'SkippedByUser' { $Summary.Skipped++ }
    }
}

function Write-ColorScriptCacheClearSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][System.Collections.IDictionary]$Summary,
        [switch]$Quiet,
        [switch]$NoAnsiOutput
    )

    $formatString = if ($script:Messages -and $script:Messages.ContainsKey('CacheClearSummaryFormat')) {
        $script:Messages.CacheClearSummaryFormat
    }
    else {
        $null
    }
    if ([string]::IsNullOrWhiteSpace($formatString)) {
        $formatString = 'Cache clear summary: Removed {0}, Missing {1}, Skipped {2}, DryRun {3}, Errors {4}'
    }
    $message = $formatString -f $Summary.Removed, $Summary.Missing, $Summary.Skipped, $Summary.DryRun, $Summary.Errors
    $segment = New-ColorScriptAnsiText -Text $message -Color 'Cyan' -NoAnsiOutput:$NoAnsiOutput
    Write-ColorScriptInformation -Message $segment -Quiet:$Quiet -NoAnsiOutput:$NoAnsiOutput -PreferConsole:(-not $NoAnsiOutput) -Color 'Cyan'
}

function Invoke-ColorScriptCacheClearOperation {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory)][AllowEmptyCollection()][string[]]$RequestedName,
        [string[]]$Category,
        [string[]]$Tag,
        [Parameter(Mandatory)][bool]$PathSpecified,
        [Parameter()][AllowNull()][AllowEmptyString()][string]$Path,
        [switch]$All,
        [switch]$DryRun,
        [switch]$PassThru,
        [switch]$Quiet,
        [switch]$NoAnsiOutput,
        [Parameter(Mandatory)][System.Management.Automation.PSCmdlet]$Cmdlet
    )

    $filterApplied = [bool]($Category -or $Tag)
    if (-not $All -and -not $filterApplied -and $RequestedName.Count -eq 0) {
        Invoke-ColorScriptError -Message $script:Messages.SpecifyAllOrNameToClearCache -ErrorId 'ColorScriptsEnhanced.CacheClearSelectionMissing' -Category ([System.Management.Automation.ErrorCategory]::InvalidOperation) -Cmdlet $Cmdlet
    }

    $cacheRoot = Resolve-ColorScriptCacheClearRoot -PathSpecified $PathSpecified -Path $Path
    if (-not $cacheRoot) {
        return @()
    }
    $inventory = Get-ColorScriptCacheInventory -CacheRoot $cacheRoot
    $metadata = Get-ColorScriptCacheClearMetadataRecord -Inventory $inventory -Category $Category -Tag $Tag
    if (-not $metadata.Success) {
        return @()
    }
    $selection = Get-ColorScriptCacheClearSelection -Record $metadata.Record -RequestedName $RequestedName -FilterApplied $filterApplied
    $targetName = if ($All) {
        Get-AllColorScriptCacheTargetName -Inventory $inventory -MetadataRecord $metadata.Record -RequestedName $RequestedName -FilterApplied $filterApplied -CacheRoot $cacheRoot
    }
    else {
        Get-SelectedColorScriptCacheTargetName -MetadataRecord $metadata.Record -RequestedName $RequestedName -SelectionContext $selection -FilterApplied $filterApplied
    }
    if (-not $targetName -or $targetName.Count -eq 0) {
        return @()
    }

    $summary = [ordered]@{ Removed = 0; Missing = 0; Errors = 0; DryRun = 0; Skipped = 0 }
    $result = foreach ($name in $targetName) {
        $entryResult = Invoke-ColorScriptCacheClearTarget -Name $name -CacheRoot $cacheRoot -CacheLookup $inventory.CacheLookup -DryRun:$DryRun -Cmdlet $Cmdlet
        Add-ColorScriptCacheClearSummaryStatus -Summary $summary -Status $entryResult.Status
        $entryResult
    }
    if ($PassThru) {
        return [System.Object[]]@($result)
    }
    Write-ColorScriptCacheClearSummary -Summary $summary -Quiet:$Quiet -NoAnsiOutput:$NoAnsiOutput
}

function Clear-ColorScriptCache {
    [OutputType([System.Object[]])]
    [CmdletBinding(DefaultParameterSetName = 'Selection', SupportsShouldProcess = $true, ConfirmImpact = 'Medium', HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache')]
    param(
        [Parameter(ParameterSetName = 'Help')][Alias('help')][switch]$h,
        [Parameter(ParameterSetName = 'Selection', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'All', ValueFromPipelineByPropertyName = $true)]
        [SupportsWildcards()][ValidateScript({ Test-ColorScriptNameValue $_ -AllowWildcard })][string[]]$Name,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][string[]]$Category,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][string[]]$Tag,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')]
        [ValidateScript({ Test-ColorScriptPathValue $_ })][string]$Path,
        [Parameter(ParameterSetName = 'All')][switch]$All,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][switch]$DryRun,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][switch]$PassThru,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][switch]$Quiet,
        [Parameter(ParameterSetName = 'Selection')][Parameter(ParameterSetName = 'All')][Alias('NoColor')][switch]$NoAnsiOutput
    )

    begin {
        if ($h) {
            Show-ColorScriptHelp -CommandName 'Clear-ColorScriptCache'
            return
        }
        $nameSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $collectedName = [System.Collections.Generic.List[string]]::new()
        if ($Name) {
            foreach ($value in $Name) {
                Add-UniqueColorScriptName -Value $value -Set $nameSet -List $collectedName
            }
        }
    }
    process {
        if ($h -or -not $MyInvocation.ExpectingInput) {
            return
        }
        if ($PSBoundParameters.ContainsKey('Name') -and $Name) {
            foreach ($value in $Name) {
                Add-UniqueColorScriptName -Value $value -Set $nameSet -List $collectedName
            }
            return
        }
        $pipelineName = Get-ColorScriptPipelineName -InputObject $_
        if ($pipelineName) {
            Add-UniqueColorScriptName -Value $pipelineName -Set $nameSet -List $collectedName
        }
    }
    end {
        if ($h) {
            return
        }
        return Invoke-ColorScriptCacheClearOperation -RequestedName $collectedName.ToArray() -Category $Category -Tag $Tag -PathSpecified $PSBoundParameters.ContainsKey('Path') -Path $Path -All:$All -DryRun:$DryRun -PassThru:$PassThru -Quiet:$Quiet -NoAnsiOutput:$NoAnsiOutput -Cmdlet $PSCmdlet
    }
}
