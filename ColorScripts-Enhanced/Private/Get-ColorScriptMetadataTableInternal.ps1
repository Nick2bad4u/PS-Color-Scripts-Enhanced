function Get-ColorScriptMetadataTableInternal {
    $currentTimestamp = $null
    if (Test-Path $script:MetadataPath) {
        try {
            $currentTimestamp = (Get-Item -LiteralPath $script:MetadataPath).LastWriteTimeUtc
        }
        catch {
            Write-Verbose "Unable to determine metadata timestamp: $($_.Exception.Message)"
        }
    }

    if ($script:MetadataCache -and $script:MetadataLastWriteTime -and $currentTimestamp -eq $script:MetadataLastWriteTime) {
        return $script:MetadataCache
    }

    $convertToMetadataObject = {
        param($source)

        if ($source -is [pscustomobject]) {
            return $source
        }

        $categoryValue = $null
        $categoriesValue = @()
        $tagsValue = @()
        $descriptionValue = $null

        if ($source -is [hashtable]) {
            if ($source.ContainsKey('Category')) {
                $categoryValue = [string]$source['Category']
            }

            if ($source.ContainsKey('Categories')) {
                $categoriesValue = @($source['Categories']) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
            }

            if ($source.ContainsKey('Tags')) {
                $tagsValue = @($source['Tags']) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
            }

            if ($source.ContainsKey('Description')) {
                $descriptionValue = [string]$source['Description']
            }
        }

        [pscustomobject]@{
            Category    = $categoryValue
            Categories  = $categoriesValue
            Tags        = $tagsValue
            Description = $descriptionValue
        }
    }

    $binaryCachePath = $null
    if ($script:CacheInitialized -and $script:CacheDir) {
        $binaryCachePath = Join-Path -Path $script:CacheDir -ChildPath 'metadata.cache.json'

        if ($binaryCachePath -and (Test-Path -LiteralPath $binaryCachePath)) {
            try {
                $cacheFileInfo = Get-Item -LiteralPath $binaryCachePath -ErrorAction Stop
                if ($cacheFileInfo.LastWriteTimeUtc -ge $currentTimestamp) {
                    $jsonData = Get-Content -LiteralPath $binaryCachePath -Raw -ErrorAction Stop
                    $cachedHash = ConvertFrom-JsonToHashtable -InputObject $jsonData

                    $loadedStore = New-Object 'System.Collections.Generic.Dictionary[string, object]' ([System.StringComparer]::OrdinalIgnoreCase)
                    foreach ($key in $cachedHash.Keys) {
                        $loadedStore[$key] = & $convertToMetadataObject $cachedHash[$key]
                    }

                    $script:MetadataCache = $loadedStore
                    $script:MetadataLastWriteTime = $currentTimestamp
                    Write-Verbose 'Loaded metadata from JSON cache (fast path)'
                    return $script:MetadataCache
                }
            }
            catch {
                Write-Verbose "JSON metadata cache load failed, will rebuild: $($_.Exception.Message)"
            }
        }
    }

    $store = New-Object 'System.Collections.Generic.Dictionary[string, object]' ([System.StringComparer]::OrdinalIgnoreCase)

    $mergeUnique = {
        param(
            [string[]]$existing,
            [string[]]$additional
        )

        $set = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
        $list = New-Object 'System.Collections.Generic.List[string]'

        if ($existing) {
            foreach ($value in $existing) {
                if ([string]::IsNullOrWhiteSpace($value)) { continue }
                if ($set.Add($value)) { $null = $list.Add($value) }
            }
        }

        if ($additional) {
            foreach ($value in $additional) {
                if ([string]::IsNullOrWhiteSpace($value)) { continue }
                if ($set.Add($value)) { $null = $list.Add($value) }
            }
        }

        return $list.ToArray()
    }

    $data = $null

    if (Test-Path $script:MetadataPath) {
        # Import ScriptMetadata.psd1 as a pure data file. On newer
        # PowerShell versions, use -SkipLimitCheck so large, static
        # datasets (like the full Pokémon category list) are loaded
        # without being rejected by size/complexity heuristics.
        $importParams = @{ Path = $script:MetadataPath }

        try {
            $command = Get-Command -Name Import-PowerShellDataFile -ErrorAction SilentlyContinue
            if ($command -and $command.Parameters.ContainsKey('SkipLimitCheck')) {
                $importParams['SkipLimitCheck'] = $true
            }
        }
        catch {
            Write-Verbose "Unable to inspect Import-PowerShellDataFile parameters. Continuing without SkipLimitCheck. Error: $($_.Exception.Message)"
        }

        try {
            $data = Import-PowerShellDataFile @importParams
        }
        catch {
            Write-Verbose ("Import-PowerShellDataFile failed for ScriptMetadata.psd1: {0}" -f $_.Exception.Message)
            $data = $null
        }

        if ($data -is [hashtable]) {
            $internal = New-Object 'System.Collections.Generic.Dictionary[string, hashtable]' ([System.StringComparer]::OrdinalIgnoreCase)

            $ensureEntry = {
                param($map, $name)

                if (-not $map.ContainsKey($name)) {
                    $map[$name] = @{
                        Category    = $null
                        Categories  = New-Object 'System.Collections.Generic.List[string]'
                        Tags        = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
                        Description = $null
                    }
                }

                return $map[$name]
            }

            if ($data.Categories -is [hashtable]) {
                foreach ($categoryName in $data.Categories.Keys) {
                    $scriptsForCategory = $data.Categories[$categoryName]
                    foreach ($scriptName in $scriptsForCategory) {
                        $entry = & $ensureEntry $internal $scriptName
                        if (-not $entry.Categories.Contains($categoryName)) {
                            $null = $entry.Categories.Add($categoryName)
                        }
                        if (-not $entry.Tags.Contains("Category:$categoryName")) {
                            $null = $entry.Tags.Add("Category:$categoryName")
                        }
                        if (-not $entry.Category) {
                            $entry.Category = $categoryName
                        }
                    }
                }
            }

            if ($data.Difficulty -is [hashtable]) {
                foreach ($difficultyLevel in $data.Difficulty.Keys) {
                    foreach ($scriptName in $data.Difficulty[$difficultyLevel]) {
                        $entry = & $ensureEntry $internal $scriptName
                        $tag = "Difficulty:$difficultyLevel"
                        if (-not $entry.Tags.Contains($tag)) {
                            $null = $entry.Tags.Add($tag)
                        }
                    }
                }
            }

            if ($data.Complexity -is [hashtable]) {
                foreach ($complexityLevel in $data.Complexity.Keys) {
                    foreach ($scriptName in $data.Complexity[$complexityLevel]) {
                        $entry = & $ensureEntry $internal $scriptName
                        $tag = "Complexity:$complexityLevel"
                        if (-not $entry.Tags.Contains($tag)) {
                            $null = $entry.Tags.Add($tag)
                        }
                    }
                }
            }

            if ($data.Recommended -is [System.Collections.IEnumerable]) {
                foreach ($scriptName in $data.Recommended) {
                    $entry = & $ensureEntry $internal $scriptName
                    if (-not $entry.Tags.Contains('Recommended')) {
                        $null = $entry.Tags.Add('Recommended')
                    }
                }
            }

            if ($data.Tags -is [hashtable]) {
                foreach ($taggedScript in $data.Tags.Keys) {
                    $entry = & $ensureEntry $internal $taggedScript
                    $tagsForScript = $data.Tags[$taggedScript]

                    if ($tagsForScript -is [System.Collections.IEnumerable] -and $tagsForScript -isnot [string]) {
                        foreach ($tagValue in $tagsForScript) {
                            $tagText = [string]$tagValue
                            if (-not [string]::IsNullOrWhiteSpace($tagText) -and -not $entry.Tags.Contains($tagText)) {
                                $null = $entry.Tags.Add($tagText)
                            }
                        }
                    }
                    elseif ($tagsForScript) {
                        $tagText = [string]$tagsForScript
                        if (-not [string]::IsNullOrWhiteSpace($tagText) -and -not $entry.Tags.Contains($tagText)) {
                            $null = $entry.Tags.Add($tagText)
                        }
                    }
                }
            }

            if ($data.Descriptions -is [hashtable]) {
                foreach ($describedScript in $data.Descriptions.Keys) {
                    $entry = & $ensureEntry $internal $describedScript
                    $descriptionText = $data.Descriptions[$describedScript]
                    if ($null -ne $descriptionText -and -not [string]::IsNullOrWhiteSpace([string]$descriptionText)) {
                        $entry.Description = [string]$descriptionText
                    }
                }
            }

            foreach ($key in $internal.Keys) {
                $value = $internal[$key]
                $categoryValue = if ($value.Category) { $value.Category } else { 'Uncategorized' }

                $categoriesValue = @()
                if ($value.Categories -is [System.Collections.IEnumerable] -and $value.Categories -isnot [string]) {
                    $categoriesValue = @($value.Categories | ForEach-Object { [string]$_ })
                }
                elseif ($value.Categories) {
                    $categoriesValue = @([string]$value.Categories)
                }

                $tagsValue = @()
                if ($value.Tags -is [System.Collections.IEnumerable] -and $value.Tags -isnot [string]) {
                    $tagsValue = @($value.Tags | ForEach-Object { [string]$_ })
                }
                elseif ($value.Tags) {
                    $tagsValue = @([string]$value.Tags)
                }

                $store[$key] = [pscustomobject]@{
                    Category    = $categoryValue
                    Categories  = $categoriesValue
                    Tags        = $tagsValue
                    Description = $value.Description
                }
            }
        }
    }

    $autoRules = @()

    if ($data -is [hashtable] -and $data.ContainsKey('AutoCategories') -and $data.AutoCategories -is [System.Collections.IEnumerable]) {
        foreach ($rule in $data.AutoCategories) {
            $categoryName = $rule.Category
            if ([string]::IsNullOrWhiteSpace($categoryName)) {
                continue
            }

            $patterns = @()
            if ($rule.Patterns -is [System.Collections.IEnumerable]) {
                foreach ($pattern in $rule.Patterns) {
                    $patternValue = [string]$pattern
                    if (-not [string]::IsNullOrWhiteSpace($patternValue)) {
                        $patterns += $patternValue
                    }
                }
            }
            elseif ($rule.Patterns) {
                $patternValue = [string]$rule.Patterns
                if (-not [string]::IsNullOrWhiteSpace($patternValue)) {
                    $patterns += $patternValue
                }
            }

            if ($patterns.Count -eq 0) {
                continue
            }

            $tags = @()
            if ($rule.Tags -is [System.Collections.IEnumerable]) {
                foreach ($tag in $rule.Tags) {
                    $tagValue = [string]$tag
                    if (-not [string]::IsNullOrWhiteSpace($tagValue)) {
                        $tags += $tagValue
                    }
                }
            }
            elseif ($rule.Tags) {
                $tagValue = [string]$rule.Tags
                if (-not [string]::IsNullOrWhiteSpace($tagValue)) {
                    $tags += $tagValue
                }
            }

            $autoRules += [pscustomobject]@{
                Category = [string]$categoryName
                Patterns = $patterns
                Tags     = $tags
            }
        }
    }

    if ($autoRules.Count -eq 0) {
        $autoRules = $script:DefaultAutoCategoryRules
    }

    $resolveAutoCategory = {
        param([string]$Name)

        $matchedCategories = New-Object 'System.Collections.Generic.List[string]'
        $matchedTags = New-Object 'System.Collections.Generic.List[string]'

        foreach ($rule in $autoRules) {
            $patterns = @()
            if ($rule.Patterns -is [System.Collections.IEnumerable]) {
                $patterns = $rule.Patterns
            }
            elseif ($rule.Patterns) {
                $patterns = @($rule.Patterns)
            }

            foreach ($pattern in $patterns) {
                $patternValue = [string]$pattern
                if ([string]::IsNullOrWhiteSpace($patternValue)) { continue }
                if ([System.Text.RegularExpressions.Regex]::IsMatch($Name, $patternValue, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
                    if (-not $matchedCategories.Contains($rule.Category)) {
                        $null = $matchedCategories.Add([string]$rule.Category)
                    }

                    if ($rule.Tags -is [System.Collections.IEnumerable]) {
                        foreach ($tag in $rule.Tags) {
                            $tagValue = [string]$tag
                            if (-not [string]::IsNullOrWhiteSpace($tagValue) -and -not $matchedTags.Contains($tagValue)) {
                                $null = $matchedTags.Add($tagValue)
                            }
                        }
                    }
                    elseif ($rule.Tags) {
                        $tagValue = [string]$rule.Tags
                        if (-not [string]::IsNullOrWhiteSpace($tagValue) -and -not $matchedTags.Contains($tagValue)) {
                            $null = $matchedTags.Add($tagValue)
                        }
                    }

                    break
                }
            }
        }

        if ($matchedCategories.Count -eq 0) {
            $null = $matchedCategories.Add('Abstract')
        }

        [pscustomobject]@{
            Categories = [string[]]$matchedCategories.ToArray()
            Tags       = [string[]]$matchedTags.ToArray()
        }
    }

    $scripts = Get-ColorScriptInventory -Raw

    foreach ($scriptFile in $scripts) {
        $name = $scriptFile.BaseName
        $entryExists = $store.ContainsKey($name)
        $existingEntry = if ($entryExists) {
            $store[$name]
        }
        else {
            [pscustomobject]@{
                Category    = 'Uncategorized'
                Categories  = @()
                Tags        = @()
                Description = $null
            }
        }

        $needsAuto = -not $entryExists -or [string]::IsNullOrWhiteSpace($existingEntry.Category) -or $existingEntry.Category -eq 'Uncategorized'

        if ($needsAuto) {
            $autoInfo = & $resolveAutoCategory $name
            $autoCategories = if ($autoInfo.Categories) { [string[]]$autoInfo.Categories } else { @('Abstract') }
            $autoTags = if ($autoInfo.Tags) { [string[]]$autoInfo.Tags } else { @() }

            $baseCategories = @()
            if ($existingEntry.Category -and $existingEntry.Category -ne 'Uncategorized') {
                $baseCategories += [string]$existingEntry.Category
            }
            if ($existingEntry.Categories) {
                foreach ($cat in [string[]]$existingEntry.Categories) {
                    if (-not [string]::IsNullOrWhiteSpace($cat) -and $cat -ne 'Uncategorized') {
                        $baseCategories += $cat
                    }
                }
            }

            $categories = [string[]](& $mergeUnique $baseCategories $autoCategories)
            if (-not $categories -or $categories.Length -eq 0) {
                $categories = @('Abstract')
            }

            $newCategory = if ($existingEntry.Category -and $existingEntry.Category -ne 'Uncategorized') { [string]$existingEntry.Category } else { $categories[0] }

            $existingTags = @()
            if ($existingEntry.Tags) {
                $existingTags = [string[]]$existingEntry.Tags
            }

            $autoTagList = @()
            if ($autoTags) { $autoTagList += $autoTags }
            $autoTagList += ($categories | ForEach-Object { "Category:$($_)" })
            $autoTagList += 'AutoCategorized'

            $tags = [string[]](& $mergeUnique $existingTags $autoTagList)

            $store[$name] = [pscustomobject]@{
                Category    = $newCategory
                Categories  = $categories
                Tags        = $tags
                Description = $existingEntry.Description
            }
        }
    }

    foreach ($key in @($store.Keys)) {
        $entry = $store[$key]

        $baseCategories = @()
        if ($entry.Category -and $entry.Category -ne 'Uncategorized') {
            $baseCategories += [string]$entry.Category
        }
        if ($entry.Categories) {
            foreach ($cat in [string[]]$entry.Categories) {
                if (-not [string]::IsNullOrWhiteSpace($cat)) {
                    $baseCategories += $cat
                }
            }
        }

        if (-not $baseCategories -or $baseCategories.Count -eq 0) {
            $baseCategories = @('Abstract')
        }

        $categories = [string[]](& $mergeUnique @() $baseCategories)
        if (-not $categories -or $categories.Length -eq 0) {
            $categories = @('Abstract')
        }

        $existingTags = @()
        if ($entry.Tags) {
            $existingTags = [string[]]$entry.Tags
        }

        $categoryTags = $categories | ForEach-Object { "Category:$($_)" }
        $tags = [string[]](& $mergeUnique $existingTags $categoryTags)

        $store[$key] = [pscustomobject]@{
            Category    = $categories[0]
            Categories  = $categories
            Tags        = $tags
            Description = $entry.Description
        }
    }

    $script:MetadataCache = $store
    $script:MetadataLastWriteTime = $currentTimestamp

    if ($binaryCachePath) {
        try {
            $jsonData = $store | ConvertTo-Json -Depth 10 -Compress
            Set-Content -Path $binaryCachePath -Value $jsonData -Encoding UTF8 -ErrorAction Stop
            Write-Verbose 'Saved metadata to JSON cache for faster future loads'
        }
        catch {
            Write-Verbose "Failed to save JSON metadata cache: $($_.Exception.Message)"
        }
    }

    return $script:MetadataCache
}
