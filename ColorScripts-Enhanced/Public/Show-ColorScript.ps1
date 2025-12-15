function Show-ColorScript {
    <#
    .SYNOPSIS
        Displays a colorscript with automatic caching.

    .LINK
        https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript

    .DESCRIPTION
        Shows a beautiful ANSI colorscript in your terminal. If no name is specified,
        displays a random script. Uses intelligent caching for 6-19x faster performance.
        Name values accept wildcards; when multiple scripts match the provided pattern, the first
        alphabetical match is displayed and can be inspected with -PassThru.

        Use -All to cycle through all colorscripts in alphabetical order.
        Combine with -WaitForInput to pause between each script (press spacebar to continue).

    .PARAMETER Name
        The name of the colorscript to display (without .ps1 extension). Supports wildcards for partial matches.

    .PARAMETER List
        Lists all available colorscripts.

    .PARAMETER Random
        Display a random colorscript (default behavior).

    .PARAMETER All
        Cycle through all available colorscripts in alphabetical order.

    .PARAMETER WaitForInput
        When used with -All, pause after each colorscript and wait for spacebar to continue.
        Press 'q' to quit early.

    .PARAMETER NoCache
        Bypass cache and execute script directly.
    .PARAMETER NoClear
        When cycling through scripts with -All, skip clearing the host between displays so prior output remains visible.
    .PARAMETER Category
        Filter the available script set by one or more categories before selection occurs.
    .PARAMETER Tag
        Filter the available script set by tag metadata (case-insensitive).
    .PARAMETER ExcludeCategory
        Exclude scripts from one or more categories. Use this to filter out large collections like Pokemon scripts.
    .PARAMETER IncludePokemon
        Opt-in flag to include Pokemon colorscripts in the random selection.
        When omitted, Pokemon scripts are filtered out automatically.
    .PARAMETER PassThru
        Return the selected script metadata in addition to rendering output.
    .PARAMETER ReturnText
        Emit the rendered colorscript as pipeline output instead of writing directly to the console.
    .PARAMETER Quiet
        Suppress informational messaging emitted to the information stream while still rendering script output.
    .PARAMETER NoAnsiOutput
        Disable ANSI color codes in informational messages and rendered script text for plain-text environments.

    .PARAMETER ValidateCache
        Forces cache validation before rendering. Use when you need to rebuild cached colorscript output manually.

    .EXAMPLE
        Show-ColorScript
        Displays a random colorscript.

    .EXAMPLE
        Show-ColorScript -Name "mandelbrot-zoom"
        Displays the mandelbrot-zoom colorscript.

    .EXAMPLE
        Show-ColorScript -Name "aurora-*"
        Displays the first colorscript (alphabetically) whose name matches the wildcard.

    .EXAMPLE
        Show-ColorScript -List
        Lists all available colorscripts.

    .EXAMPLE
        scs hearts
        Uses the alias to display the hearts colorscript.

    .EXAMPLE
        Show-ColorScript -All
        Displays all colorscripts in alphabetical order continuously.

    .EXAMPLE
        Show-ColorScript -All -WaitForInput
        Displays all colorscripts one at a time, waiting for spacebar press between each.

    .EXAMPLE
        Show-ColorScript -All -Category Nature -WaitForInput
        Cycles through all nature-themed colorscripts with manual progression.

    .EXAMPLE
        Show-ColorScript -IncludePokemon
        Displays a random colorscript including Pokemon scripts.

    .EXAMPLE
        Show-ColorScript -ExcludeCategory Pokemon,Gaming
        Displays a random colorscript. By default Pokémon scripts are excluded; use -IncludePokemon to include them.
    #>
    [OutputType([pscustomobject], ParameterSetName = 'List')]
    [OutputType([pscustomobject], ParameterSetName = 'Named')]
    [OutputType([pscustomobject], ParameterSetName = 'Random')]
    [OutputType([string], ParameterSetName = 'Named')]
    [OutputType([string], ParameterSetName = 'Random')]
    [CmdletBinding(DefaultParameterSetName = 'Random', HelpUri = 'https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript')]
    [Alias('scs')]
    param(
        [Parameter(ParameterSetName = 'Help')]
        [Alias('help')]
        [switch]$h,

        [Parameter(ParameterSetName = 'Named', Position = 0)]
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
        [string]$Name,

        [Parameter(ParameterSetName = 'List')]
        [switch]$List,

        [Parameter(ParameterSetName = 'Random')]
        [switch]$Random,

        [Parameter(ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(ParameterSetName = 'All')]
        [switch]$WaitForInput,

        [Parameter(ParameterSetName = 'All')]
        [switch]$NoClear,

        [Parameter()]
        [switch]$NoCache,

        [Parameter()]
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

                $values = foreach ($record in $records) {
                    if ($record.Category) { [string]$record.Category }
                    if ($record.Categories) {
                        foreach ($entry in @($record.Categories)) {
                            if ($entry) { [string]$entry }
                        }
                    }
                }

                $values |
                    Where-Object { $_ -and ($_ -like $pattern) } |
                        Group-Object |
                            Sort-Object -Property Name |
                                ForEach-Object {
                                    [System.Management.Automation.CompletionResult]::new(
                                        $_.Name,
                                        $_.Name,
                                        [System.Management.Automation.CompletionResultType]::ParameterValue,
                                        '{0} script(s)' -f $_.Count
                                    )
                                }
            })]
        [string[]]$Category,

        [Parameter()]
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

                $values = foreach ($record in $records) {
                    foreach ($tag in @($record.Tags)) {
                        if ($tag) { [string]$tag }
                    }
                }

                foreach ($group in ($values | Where-Object { $_ -and ($_ -like $pattern) } | Group-Object | Sort-Object -Property Name)) {
                    [System.Management.Automation.CompletionResult]::new(
                        $group.Name,
                        $group.Name,
                        [System.Management.Automation.CompletionResultType]::ParameterValue,
                        '{0} reference(s)' -f $group.Count
                    )
                }
            })]
        [string[]]$Tag,

        [Parameter()]
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

                $values = foreach ($record in $records) {
                    if ($record.Category) { [string]$record.Category }
                    if ($record.Categories) {
                        foreach ($entry in @($record.Categories)) {
                            if ($entry) { [string]$entry }
                        }
                    }
                }

                $values |
                    Where-Object { $_ -and ($_ -like $pattern) } |
                        Group-Object |
                            Sort-Object -Property Name |
                                ForEach-Object {
                                    [System.Management.Automation.CompletionResult]::new(
                                        $_.Name,
                                        $_.Name,
                                        [System.Management.Automation.CompletionResultType]::ParameterValue,
                                        '{0} script(s)' -f $_.Count
                                    )
                                }
            })]
        [string[]]$ExcludeCategory,

        [Parameter()]
        [switch]$IncludePokemon,

        [Parameter(ParameterSetName = 'Named')]
        [Parameter(ParameterSetName = 'Random')]
        [switch]$PassThru,

        [Parameter()]
        [Alias('AsString')]
        [switch]$ReturnText,

        [Parameter()]
        [switch]$Quiet,

        [Parameter()]
        [Alias('NoColor')]
        [switch]$NoAnsiOutput,

        [Parameter()]
        [switch]$ValidateCache
    )

    if ($h) {
        Show-ColorScriptHelp -CommandName 'Show-ColorScript'
        return
    }

    if ($ValidateCache) {
        Set-CacheValidationOverride -Value $true
    }

    $quietRequested = [bool]$Quiet
    $noAnsiRequested = [bool]$NoAnsiOutput
    $preferConsoleOutput = -not $noAnsiRequested

    $filterPokemon = -not $IncludePokemon

    # If Category explicitly includes Pokémon identifiers, do not filter them
    if ($filterPokemon -and $PSBoundParameters.ContainsKey('Category') -and $Category -and $Category.Count -gt 0) {
        $normalizedCategories = $Category | Where-Object { $_ } | ForEach-Object { ([string]$_).Trim().ToLowerInvariant().Replace(' ', '') }
        $pokemonIdentifiers = @('pokemon', 'shinypokemon', 'pokemonshiny')
        if ($normalizedCategories | Where-Object { $pokemonIdentifiers -contains $_ }) {
            $filterPokemon = $false
            $pokemonNameSet = $null
        }
    }

    $pokemonNameSet = $null
    # If a specific name is provided, never filter Pokémon out—explicit names must win.
    if ($PSBoundParameters.ContainsKey('Name') -and $Name) {
        $filterPokemon = $false
        $pokemonNameSet = $null
    }
    elseif ($filterPokemon) {
        $pokemonNameSet = Get-PokemonScriptNameSet
        if (-not ($pokemonNameSet -and $pokemonNameSet.Count -gt 0)) {
            $pokemonNameSet = $null
        }
    }

    if (-not $filterPokemon) {
        $pokemonNameSet = $null
    }

    # Normalize excluded categories
    $effectiveExcludeCategories = @()
    if ($ExcludeCategory) {
        $effectiveExcludeCategories += $ExcludeCategory
    }

    $excludeCategorySet = @()
    if ($effectiveExcludeCategories.Count -gt 0) {
        $excludeCategorySet = $effectiveExcludeCategories |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
                ForEach-Object { $_.ToLowerInvariant() }
    }

    if ($List) {
        $listParams = @{ AsObject = $true }
        if ($Category) { $listParams.Category = $Category }
        if ($Tag) { $listParams.Tag = $Tag }
        if ($quietRequested) { $listParams.Quiet = $true }
        if ($noAnsiRequested) { $listParams.NoAnsiOutput = $true }

        $listRecords = ColorScripts-Enhanced\Get-ColorScriptList @listParams

        if ($excludeCategorySet.Count -gt 0) {
            $listRecords = $listRecords | Where-Object {
                $recordCategories = @($_.Category) + $_.Categories
                $recordCategories = $recordCategories |
                    Where-Object { $_ } |
                        ForEach-Object { $_.ToLowerInvariant() }
                        -not ($recordCategories | Where-Object { $excludeCategorySet -contains $_ })
                    }
                }

                if ($pokemonNameSet -and $pokemonNameSet.Count -gt 0) {
                    $listRecords = $listRecords | Where-Object { $pokemonNameSet -notcontains $_.Name }
                }

                if (-not $listRecords -or $listRecords.Count -eq 0) {
                    Write-Warning $script:Messages.NoColorscriptsFoundMatchingCriteria
                    return
                }

                $table = $listRecords | Sort-Object Name | Select-Object Name, Category
                if (-not $quietRequested) {
                    $tableOutput = $table | Format-Table -AutoSize | Out-String
                    if ($noAnsiRequested) {
                        $tableOutput = Remove-ColorScriptAnsiSequence -Text $tableOutput
                    }
                    Write-ColorScriptInformation -Message $tableOutput -Quiet:$false -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput
                }

                return $listRecords
            }

            if ($All) {
                $needsMetadata = (
                    ($Category -and $Category.Count -gt 0) -or
                    ($Tag -and $Tag.Count -gt 0) -or
                    ($excludeCategorySet.Count -gt 0)
                )

                $allScripts = if ($needsMetadata) {
                    Get-ColorScriptEntry -Category $Category -Tag $Tag
                }
                else {
                    Get-ColorScriptInventory
                }

                if ($excludeCategorySet.Count -gt 0 -and $needsMetadata) {
                    $allScripts = $allScripts | Where-Object {
                        $recordCategories = @($_.Category) + $_.Categories
                        $recordCategories = $recordCategories |
                            Where-Object { $_ } |
                                ForEach-Object { $_.ToLowerInvariant() }
                                -not ($recordCategories | Where-Object { $excludeCategorySet -contains $_ })
                            }
                        }

                        if ($pokemonNameSet -and $pokemonNameSet.Count -gt 0) {
                            $allScripts = $allScripts | Where-Object { $pokemonNameSet -notcontains $_.Name }
                        }

                        if (-not $allScripts -or $allScripts.Count -eq 0) {
                            Write-Warning $script:Messages.NoColorscriptsFoundMatchingCriteria
                            return
                        }

                        $sortedScripts = $allScripts | Sort-Object Name
                        $totalCount = $sortedScripts.Count
                        $currentIndex = 0

                        $displayingMessage = New-ColorScriptAnsiText -Text ($script:Messages.DisplayingColorscripts -f $totalCount) -Color 'Cyan' -NoAnsiOutput:$noAnsiRequested
                        Write-ColorScriptInformation -Message $displayingMessage -Quiet:$quietRequested -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput -Color 'Cyan'

                        $modeMessage = if ($WaitForInput) { $script:Messages.PressSpacebarToContinue } else { $script:Messages.DisplayingContinuously }
                        $modeQuiet = if ($WaitForInput) { $false } else { $quietRequested }
                        $modeSegment = New-ColorScriptAnsiText -Text $modeMessage -Color 'Yellow' -NoAnsiOutput:$noAnsiRequested
                        Write-ColorScriptInformation -Message $modeSegment -Quiet:$modeQuiet -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput -Color 'Yellow'

                        foreach ($script in $sortedScripts) {
                            $currentIndex++

                            if (-not $NoClear) {
                                Clear-Host
                            }
                            $progressSegment = New-ColorScriptAnsiText -Text ($script:Messages.CurrentIndexOfTotal -f $currentIndex, $totalCount) -Color 'Green' -NoAnsiOutput:$noAnsiRequested
                            $scriptNameSegment = New-ColorScriptAnsiText -Text $script.Name -Color 'Cyan' -NoAnsiOutput:$noAnsiRequested
                            Write-ColorScriptInformation -Message ("$progressSegment $scriptNameSegment") -Quiet:$quietRequested -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput

                            $dividerSegment = New-ColorScriptAnsiText -Text ('=' * 60) -Color 'DarkGray' -NoAnsiOutput:$noAnsiRequested
                            Write-ColorScriptInformation -Message $dividerSegment -Quiet:$quietRequested -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput -Color 'DarkGray'
                            Write-ColorScriptInformation -Message '' -Quiet:$quietRequested -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput

                            $renderedOutput = $null
                            if (-not $NoCache) {
                                Initialize-CacheDirectory
                                $cacheState = Get-CachedOutput -ScriptPath $script.Path
                                if ($cacheState.Available) {
                                    $renderedOutput = $cacheState.Content
                                }
                                else {
                                    $cacheResult = Build-ScriptCache -ScriptPath $script.Path
                                    $renderedOutput = $cacheResult.StdOut

                                    if ($cacheResult -and $cacheResult.Success -and $script:CacheDir) {
                                        try {
                                            $metadataFileName = 'cache-metadata-v{0}.json' -f $script:CacheFormatVersion
                                            Write-CacheMetadataFile -CacheDirectory $script:CacheDir -MetadataFileName $metadataFileName
                                        }
                                        catch {
                                            Write-Verbose ("Cache metadata update failed: {0}" -f $_.Exception.Message)
                                        }
                                    }
                                }
                            }
                            else {
                                $executionResult = Invoke-ColorScriptProcess -ScriptPath $script.Path
                                $renderedOutput = $executionResult.StdOut
                            }

                            if ($renderedOutput) {
                                Invoke-WithUtf8Encoding -ScriptBlock {
                                    param($text, $noAnsiOutput)
                                    Write-RenderedText -Text $text -NoAnsiOutput:$noAnsiOutput
                                } -Arguments @($renderedOutput, $noAnsiRequested)
                            }

                            if ($WaitForInput -and $currentIndex -lt $totalCount) {
                                Write-ColorScriptInformation -Message '' -Quiet:$quietRequested -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput
                                $promptMessage = New-ColorScriptAnsiText -Text $script:Messages.PressSpacebarForNext -Color 'Yellow' -NoAnsiOutput:$noAnsiRequested
                                Write-ColorScriptInformation -Message $promptMessage -Quiet:$false -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput -Color 'Yellow'

                                $continueLoop = $true
                                while ($continueLoop) {
                                    $key = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
                                    if ($key.VirtualKeyCode -eq 32) {
                                        $continueLoop = $false
                                    }
                                    elseif ($key.Character -eq 'q' -or $key.Character -eq 'Q') {
                                        $quitMessage = New-ColorScriptAnsiText -Text $script:Messages.Quitting -Color 'Yellow' -NoAnsiOutput:$noAnsiRequested
                                        Write-ColorScriptInformation -Message $quitMessage -Quiet:$false -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput -Color 'Yellow'
                                        return
                                    }
                                }
                                Write-ColorScriptInformation -Message '' -Quiet:$quietRequested -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput
                            }
                            elseif (-not $WaitForInput -and $currentIndex -lt $totalCount) {
                                Start-Sleep -Milliseconds 100
                            }
                        }

                        Write-ColorScriptInformation -Message '' -Quiet:$quietRequested -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput
                        $completeMessage = New-ColorScriptAnsiText -Text ($script:Messages.FinishedDisplayingAll -f $totalCount) -Color 'Green' -NoAnsiOutput:$noAnsiRequested
                        Write-ColorScriptInformation -Message $completeMessage -Quiet:$quietRequested -NoAnsiOutput:$noAnsiRequested -PreferConsole:$preferConsoleOutput -Color 'Green'
                        return
                    }

                    $needsMetadata = (
                        ($Category -and $Category.Count -gt 0) -or
                        ($Tag -and $Tag.Count -gt 0) -or
                        $PassThru.IsPresent -or
                        ($excludeCategorySet.Count -gt 0) -or
                        ($PSBoundParameters.ContainsKey('Name') -and $Name)
                    )

                    $records = if ($needsMetadata) {
                        Get-ColorScriptEntry -Category $Category -Tag $Tag
                    }
                    else {
                        Get-ColorScriptInventory
                    }

                    if (-not $records -or $records.Count -eq 0) {
                        Write-Warning ($script:Messages.NoColorscriptsFoundInScriptsPath -f $script:ScriptsPath)
                        return
                    }

                    # Apply Pokémon exclusion when needed
                    if ($pokemonNameSet -and $pokemonNameSet.Count -gt 0) {
                        $records = $records | Where-Object { $pokemonNameSet -notcontains $_.Name }
                    }

                    if (-not $records -or $records.Count -eq 0) {
                        Write-Warning $script:Messages.NoColorscriptsFoundMatchingCriteria
                        return
                    }

                    if ($Name) {
                        $selectionResult = Select-RecordsByName -Records $records -Name $Name
                        foreach ($pattern in $selectionResult.MissingPatterns) {
                            Write-Warning ($script:Messages.ColorscriptNotFoundWithFilters -f $pattern)
                        }

                        $records = $selectionResult.Records
                        if (-not $records -or $records.Count -eq 0) {
                            return
                        }
                    }

                    if ($excludeCategorySet.Count -gt 0 -and $needsMetadata) {
                        $records = $records | Where-Object {
                            $recordCategories = @($_.Category) + $_.Categories
                            $recordCategories = $recordCategories |
                                Where-Object { $_ } |
                                    ForEach-Object { $_.ToLowerInvariant() }
                                    -not ($recordCategories | Where-Object { $excludeCategorySet -contains $_ })
                                }

                                if (-not $records -or $records.Count -eq 0) {
                                    Write-Warning $script:Messages.NoColorscriptsFoundMatchingCriteria
                                    return
                                }
                            }

                            if ($pokemonNameSet -and $pokemonNameSet.Count -gt 0) {
                                $records = $records | Where-Object { $pokemonNameSet -notcontains $_.Name }

                                if (-not $records -or $records.Count -eq 0) {
                                    Write-Warning $script:Messages.NoColorscriptsFoundMatchingCriteria
                                    return
                                }
                            }

                            $useRandom = $Random -or $PSCmdlet.ParameterSetName -eq 'Random'

                            $selection = $null

                            if ($Name) {
                                $orderedMatches = $records | Sort-Object Name
                                if ($orderedMatches.Count -gt 1) {
                                    $matchedNames = $orderedMatches | Select-Object -ExpandProperty Name
                                    Write-Verbose ($script:Messages.MultipleColorscriptsMatched -f ($matchedNames -join ', '), $orderedMatches[0].Name)
                                }
                                $selection = $orderedMatches | Select-Object -First 1
                            }
                            elseif ($useRandom) {
                                $rng = [System.Random]::new()
                                $index = $rng.Next($records.Count)
                                $selection = $records[$index]
                            }
                            else {
                                $selection = $records | Select-Object -First 1
                            }

                            $renderedOutput = $null

                            if (-not $NoCache) {
                                Initialize-CacheDirectory

                                $cacheState = Get-CachedOutput -ScriptPath $selection.Path
                                if ($cacheState.Available) {
                                    $renderedOutput = $cacheState.Content
                                }
                                else {
                                    $cacheResult = Build-ScriptCache -ScriptPath $selection.Path
                                    if (-not $cacheResult.Success) {
                                        if ($cacheResult.StdErr) {
                                            Write-Warning ($script:Messages.CacheBuildFailedForScript -f $selection.Name, $cacheResult.StdErr.Trim())
                                        }

                                        if ([string]::IsNullOrEmpty($cacheResult.StdOut)) {
                                            Invoke-ColorScriptError -Message $script:Messages.FailedToBuildCacheForScript -ErrorId 'ColorScriptsEnhanced.CacheBuildFailed' -Category ([System.Management.Automation.ErrorCategory]::InvalidOperation) -TargetObject $selection.Name -Cmdlet $PSCmdlet
                                        }

                                        $renderedOutput = $cacheResult.StdOut
                                    }
                                    else {
                                        $renderedOutput = $cacheResult.StdOut

                                        if ($script:CacheDir) {
                                            try {
                                                $metadataFileName = 'cache-metadata-v{0}.json' -f $script:CacheFormatVersion
                                                Write-CacheMetadataFile -CacheDirectory $script:CacheDir -MetadataFileName $metadataFileName
                                            }
                                            catch {
                                                Write-Verbose ("Cache metadata update failed: {0}" -f $_.Exception.Message)
                                            }
                                        }
                                    }
                                }
                            }
                            else {
                                $executionResult = Invoke-ColorScriptProcess -ScriptPath $selection.Path
                                if (-not $executionResult.Success) {
                                    $errorMessage = if ($executionResult.StdErr) { $executionResult.StdErr.Trim() } else { "Script exited with code $($executionResult.ExitCode)." }
                                    Invoke-ColorScriptError -Message ($script:Messages.FailedToExecuteColorscript -f $selection.Name, $errorMessage) -ErrorId 'ColorScriptsEnhanced.ScriptExecutionFailed' -Category ([System.Management.Automation.ErrorCategory]::InvalidOperation) -TargetObject $selection.Name -Cmdlet $PSCmdlet
                                }

                                $renderedOutput = $executionResult.StdOut
                            }

                            if ($null -eq $renderedOutput) {
                                $renderedOutput = ''
                            }

                            $boundParameters = $PSCmdlet.MyInvocation.BoundParameters
                            $pipelineLength = $PSCmdlet.MyInvocation.PipelineLength
                            $shouldEmitText = Test-ColorScriptTextEmission -ReturnText:$ReturnText.IsPresent -PassThru:$PassThru.IsPresent -PipelineLength $pipelineLength -BoundParameters $boundParameters

                            Invoke-WithUtf8Encoding -ScriptBlock {
                                param($text, $emitText, $noAnsiOutput)

                                if ($emitText) {
                                    Write-Output $text
                                    return
                                }

                                Write-RenderedText -Text $text -NoAnsiOutput:$noAnsiOutput
                            } -Arguments @($renderedOutput, $shouldEmitText, $noAnsiRequested)

                            if ($PassThru) {
                                return $selection
                            }
                        }
