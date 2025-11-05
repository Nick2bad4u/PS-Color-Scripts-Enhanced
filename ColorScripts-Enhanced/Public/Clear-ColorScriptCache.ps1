function Clear-ColorScriptCache {
    [OutputType([System.Object[]])]
    [CmdletBinding(DefaultParameterSetName = 'Selection', SupportsShouldProcess = $true, ConfirmImpact = 'Medium', HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache')]
    param(
        [Parameter(ParameterSetName = 'Help')]
        [Alias('help')]
        [switch]$h,

        [Parameter(ParameterSetName = 'Selection', ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Parameter(ParameterSetName = 'All', ValueFromPipelineByPropertyName = $true)]
        [SupportsWildcards()]
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowWildcard })]
        [string[]]$Name,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [string[]]$Category,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [string[]]$Tag,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [ValidateScript({ Test-ColorScriptPathValue $_ })]
        [string]$Path,

        [Parameter(ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [switch]$DryRun,

        [Parameter(ParameterSetName = 'Selection')]
        [Parameter(ParameterSetName = 'All')]
        [switch]$PassThru
    )

    begin {
        if ($h) {
            Show-ColorScriptHelp -CommandName 'Clear-ColorScriptCache'
            return
        }

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
        if ($h) {
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
        if ($h) {
            return
        }

        $requestedNames = $collectedNames.ToArray()

        if (-not $All -and -not $Category -and -not $Tag -and $requestedNames.Count -eq 0) {
            Invoke-ColorScriptError -Message $script:Messages.SpecifyAllOrNameToClearCache -ErrorId 'ColorScriptsEnhanced.CacheClearSelectionMissing' -Category ([System.Management.Automation.ErrorCategory]::InvalidOperation) -Cmdlet $PSCmdlet
        }

        $cacheRoot = $null

        if ($PSBoundParameters.ContainsKey('Path') -and $Path) {
            $resolvedPath = Resolve-CachePath -Path $Path

            if (-not $resolvedPath) {
                Write-Warning ($script:Messages.CachePathNotFound -f $Path)
                return @()
            }

            $cacheRoot = $resolvedPath
        }
        else {
            Initialize-CacheDirectory
            $cacheRoot = $script:CacheDir

            if (-not $cacheRoot) {
                Write-Warning ($script:Messages.CachePathNotFound -f '<not set>')
                return @()
            }
        }

        if (-not (Test-Path -LiteralPath $cacheRoot -PathType Container)) {
            Write-Warning ($script:Messages.CachePathNotFound -f $cacheRoot)
            return @()
        }

        $cacheInventory = @(Get-ChildItem -Path $cacheRoot -Filter '*.cache' -File -ErrorAction SilentlyContinue)
        $cacheLookup = @{}

        foreach ($file in $cacheInventory) {
            $key = $file.BaseName.ToLowerInvariant()
            if (-not $cacheLookup.ContainsKey($key)) {
                $cacheLookup[$key] = $file
            }
        }

        $metadataRecords = @()
        $needMetadata = $All -or $requestedNames.Count -gt 0 -or $Category -or $Tag

        if ($needMetadata) {
            try {
                $metadataRecords = @(Get-ColorScriptEntry -Category $Category -Tag $Tag)
            }
            catch {
                Write-Verbose ("Get-ColorScriptEntry failed: {0}" -f $_.Exception.Message)
                $metadataRecords = @()
            }

            if (($Category -or $Tag) -and -not $metadataRecords) {
                Write-Warning $script:Messages.NoScriptsMatchedSpecifiedFilters
                return @()
            }
        }

        $metadataLookup = @{}
        foreach ($record in $metadataRecords) {
            $key = ([string]$record.Name).ToLowerInvariant()
            if (-not [string]::IsNullOrWhiteSpace($key) -and -not $metadataLookup.ContainsKey($key)) {
                $metadataLookup[$key] = $record
            }
        }

        $missingEntries = [System.Collections.Generic.List[psobject]]::new()
        $selectedRecords = $metadataRecords
        $selection = $null

        if ($requestedNames.Count -gt 0) {
            $selection = Select-RecordsByName -Records $metadataRecords -Name $requestedNames
            $selectedRecords = if ($selection.Records) { $selection.Records } else { @() }

            if ($selection.MatchMap) {
                foreach ($map in $selection.MatchMap) {
                    if (-not $map.Matched) {
                        $pattern = [string]$map.Pattern

                        if ($Category -or $Tag) {
                            Write-Warning ($script:Messages.ScriptSkippedByFilter -f $pattern)
                        }
                        elseif (-not [string]::IsNullOrWhiteSpace($pattern)) {
                            [void]$missingEntries.Add([pscustomobject]@{ Name = $pattern })
                        }
                    }
                }
            }
        }

        $patternMatchMap = @{}
        if ($selection -and $selection.MatchMap) {
            foreach ($entry in $selection.MatchMap) {
                $pattern = [string]$entry.Pattern
                if (-not [string]::IsNullOrWhiteSpace($pattern) -and -not $patternMatchMap.ContainsKey($pattern)) {
                    $patternMatchMap[$pattern] = $entry
                }
            }
        }

        $targetNameSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
        $targetNames = [System.Collections.Generic.List[string]]::new()

        $addTargetName = {
            param([string]$Value)

            if ([string]::IsNullOrWhiteSpace($Value)) {
                return
            }

            if ($targetNameSet.Add($Value)) {
                [void]$targetNames.Add($Value)
            }
        }

        if ($All) {
            if ($cacheInventory.Count -eq 0) {
                Write-Warning ($script:Messages.NoCacheFilesFound -f $cacheRoot)
                return @()
            }

            $selectedFiles = $cacheInventory

            if ($requestedNames.Count -gt 0) {
                $matchedFiles = [System.Collections.Generic.List[System.IO.FileInfo]]::new()

                foreach ($pattern in $requestedNames) {
                    $patternMatches = $cacheInventory | Where-Object { $_.BaseName -like $pattern }

                    if ($patternMatches) {
                        foreach ($match in $patternMatches) {
                            [void]$matchedFiles.Add($match)
                        }
                    }
                    else {
                        [void]$missingEntries.Add([pscustomobject]@{ Name = $pattern })
                    }
                }

                $selectedFiles = if ($matchedFiles.Count -gt 0) { $matchedFiles.ToArray() } else { @() }
            }

            if ($Category -or $Tag) {
                $allowedNames = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

                foreach ($record in $metadataRecords) {
                    $recordName = [string]$record.Name

                    if (-not [string]::IsNullOrWhiteSpace($recordName)) {
                        [void]$allowedNames.Add($recordName)
                    }
                }

                $selectedFiles = @($selectedFiles | Where-Object { $allowedNames.Contains($_.BaseName) })
            }

            if (-not $selectedFiles -or $selectedFiles.Count -eq 0) {
                Write-Warning ($script:Messages.NoCacheFilesFound -f $cacheRoot)
                return @()
            }

            foreach ($file in ($selectedFiles | Sort-Object -Property BaseName -Unique)) {
                & $addTargetName $file.BaseName
            }
        }
        else {
            if ($requestedNames.Count -gt 0) {
                foreach ($value in $requestedNames) {
                    $patternEntry = if ($patternMatchMap.ContainsKey($value)) { $patternMatchMap[$value] } else { $null }

                    if ($patternEntry -and $patternEntry.Matched -and $patternEntry.Matches) {
                        foreach ($matchedName in $patternEntry.Matches) {
                            $matchKey = $matchedName.ToLowerInvariant()
                            if ($metadataLookup.ContainsKey($matchKey)) {
                                & $addTargetName ([string]$metadataLookup[$matchKey].Name)
                            }
                            else {
                                & $addTargetName $matchedName
                            }
                        }
                        continue
                    }

                    $key = $value.ToLowerInvariant()

                    if ($metadataLookup.ContainsKey($key)) {
                        & $addTargetName ([string]$metadataLookup[$key].Name)
                        continue
                    }

                    if ($Category -or $Tag) {
                        continue
                    }

                    if ($missingEntries | Where-Object { $_.Name -eq $value }) {
                        & $addTargetName $value
                        continue
                    }

                    & $addTargetName $value
                }
            }
            elseif ($Category -or $Tag) {
                foreach ($record in $metadataRecords) {
                    & $addTargetName ([string]$record.Name)
                }
            }

            if ($targetNames.Count -eq 0 -and $missingEntries.Count -gt 0) {
                foreach ($entry in $missingEntries) {
                    & $addTargetName ([string]$entry.Name)
                }
            }
        }

        if ($targetNames.Count -eq 0) {
            return @()
        }

        $results = [System.Collections.Generic.List[psobject]]::new()
        $summary = [ordered]@{
            Removed = 0
            Missing = 0
            Errors  = 0
            DryRun  = 0
            Skipped = 0
        }

        $overallAllowed = $true
        if (-not $DryRun) {
            $overallAllowed = Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $cacheRoot -Action 'Clear cache'
        }

        if (-not $overallAllowed) {
            if ($All) {
                return @()
            }

            foreach ($name in $targetNames) {
                $cachePath = Join-Path -Path $cacheRoot -ChildPath ("{0}.cache" -f $name)
                $exists = Test-Path -LiteralPath $cachePath

                if ($exists) {
                    $summary.Skipped++
                    [void]$results.Add([pscustomobject]@{
                            Name      = $name
                            CacheFile = $cachePath
                            Status    = 'SkippedByUser'
                            Message   = ''
                        })
                }
                else {
                    $summary.Missing++
                    [void]$results.Add([pscustomobject]@{
                            Name      = $name
                            CacheFile = $cachePath
                            Status    = 'Missing'
                            Message   = $script:Messages.CacheFileNotFound
                        })
                }
            }

            return $results.ToArray()
        }

        foreach ($name in $targetNames) {
            $key = $name.ToLowerInvariant()
            $cacheInfo = if ($cacheLookup.ContainsKey($key)) { $cacheLookup[$key] } else { $null }
            $cachePath = if ($cacheInfo) { $cacheInfo.FullName } else { Join-Path -Path $cacheRoot -ChildPath ("{0}.cache" -f $name) }
            $exists = $false

            if ($cacheInfo) {
                $exists = Test-Path -LiteralPath $cacheInfo.FullName

                if (-not $exists) {
                    $cacheInfo = $null
                    $cachePath = Join-Path -Path $cacheRoot -ChildPath ("{0}.cache" -f $name)
                }
            }

            if (-not $cacheInfo) {
                $exists = Test-Path -LiteralPath $cachePath
            }

            if (-not $exists) {
                $summary.Missing++
                [void]$results.Add([pscustomobject]@{
                        Name      = $name
                        CacheFile = $cachePath
                        Status    = 'Missing'
                        Message   = $script:Messages.CacheFileNotFound
                    })
                continue
            }

            if ($DryRun) {
                $summary.DryRun++
                [void]$results.Add([pscustomobject]@{
                        Name      = $name
                        CacheFile = $cachePath
                        Status    = 'DryRun'
                        Message   = $script:Messages.NoChangesApplied
                    })
                continue
            }

            if (-not (Invoke-ShouldProcess -Cmdlet $PSCmdlet -Target $cachePath -Action 'Clear colorscript cache file')) {
                $summary.Skipped++
                [void]$results.Add([pscustomobject]@{
                        Name      = $name
                        CacheFile = $cachePath
                        Status    = 'SkippedByUser'
                        Message   = ''
                    })
                continue
            }

            try {
                Remove-Item -LiteralPath $cachePath -Force -ErrorAction Stop
                $summary.Removed++
                [void]$results.Add([pscustomobject]@{
                        Name      = $name
                        CacheFile = $cachePath
                        Status    = 'Removed'
                        Message   = ''
                    })
            }
            catch {
                $summary.Errors++
                Write-Warning ("Failed to remove cache file '{0}': {1}" -f $name, $_.Exception.Message)
                [void]$results.Add([pscustomobject]@{
                        Name      = $name
                        CacheFile = $cachePath
                        Status    = 'Error'
                        Message   = $_.Exception.Message
                    })
            }
        }

        $output = $results.ToArray()

        if (-not $PassThru) {
            $summaryMessage = [string]::Format('Cache clear summary – Removed: {0}, Missing: {1}, Skipped: {2}, DryRun: {3}, Errors: {4}', $summary.Removed, $summary.Missing, $summary.Skipped, $summary.DryRun, $summary.Errors)
            Write-ColorScriptInformation -Message $summaryMessage -Quiet:$false
        }

        return $output
    }
}
