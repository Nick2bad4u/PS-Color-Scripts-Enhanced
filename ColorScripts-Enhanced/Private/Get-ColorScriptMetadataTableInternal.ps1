function Get-ColorScriptMetadataTimestamp {
    [CmdletBinding()]
    [OutputType([datetime])]
    param()

    if (-not (Test-Path -LiteralPath $script:MetadataPath)) {
        return $null
    }

    try {
        return (Get-Item -LiteralPath $script:MetadataPath).LastWriteTimeUtc
    }
    catch {
        Write-Verbose "Unable to determine metadata timestamp: $($_.Exception.Message)"
        return $null
    }
}

function Get-ColorScriptInventoryTimestamp {
    [CmdletBinding()]
    [OutputType([datetime])]
    param()

    try {
        $timestamp = & $script:DirectoryGetLastWriteTimeUtcDelegate $script:ScriptsPath
        if ($timestamp -eq [datetime]::MinValue) {
            return $null
        }
        return $timestamp
    }
    catch {
        Write-Verbose ("Unable to determine colorscript inventory timestamp: {0}" -f $_.Exception.Message)
        return $null
    }
}

function Test-ColorScriptMetadataMemoryCache {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter()][AllowNull()][object]$MetadataTimestamp,
        [Parameter()][AllowNull()][object]$InventoryTimestamp
    )

    return $script:MetadataCache -and
        $script:MetadataLastWriteTime -and
        $MetadataTimestamp -eq $script:MetadataLastWriteTime -and
        $InventoryTimestamp -eq $script:MetadataInventoryLastWriteTime
}

function ConvertTo-StringValueCollection {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter()][AllowNull()][object]$Value
    )

    $values = if ($Value -is [System.Collections.IEnumerable] -and $Value -isnot [string]) {
        @($Value)
    }
    elseif ($null -ne $Value) {
        @($Value)
    }
    else {
        @()
    }

    return [string[]]@($values | ForEach-Object { [string]$_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
}

function ConvertTo-ColorScriptMetadataRecord {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter()][AllowNull()][object]$Source
    )

    if ($Source -is [pscustomobject]) {
        return $Source
    }

    $category = $null
    $categoryCollection = @()
    $tagCollection = @()
    $description = $null
    if ($Source -is [hashtable]) {
        if ($Source.ContainsKey('Category')) {
            $category = [string]$Source['Category']
        }
        if ($Source.ContainsKey('Categories')) {
            $categoryCollection = ConvertTo-StringValueCollection -Value $Source['Categories']
        }
        if ($Source.ContainsKey('Tags')) {
            $tagCollection = ConvertTo-StringValueCollection -Value $Source['Tags']
        }
        if ($Source.ContainsKey('Description')) {
            $description = [string]$Source['Description']
        }
    }

    return [pscustomobject]@{
        Category    = $category
        Categories  = $categoryCollection
        Tags        = $tagCollection
        Description = $description
    }
}

function Get-ColorScriptMetadataCachePath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if (-not $script:CacheInitialized -or -not $script:CacheDir) {
        return $null
    }

    return Join-Path -Path $script:CacheDir -ChildPath 'metadata.cache.json'
}

function Import-ColorScriptMetadataJsonCache {
    [CmdletBinding()]
    [OutputType([object])]
    param(
        [Parameter(Mandatory)][string]$CachePath,
        [Parameter()][AllowNull()][object]$MetadataTimestamp,
        [Parameter()][AllowNull()][object]$InventoryTimestamp
    )

    if (-not (Test-Path -LiteralPath $CachePath)) {
        return $null
    }

    try {
        $cacheFileInfo = Get-Item -LiteralPath $CachePath -ErrorAction Stop
        $metadataIsCurrent = -not $MetadataTimestamp -or $cacheFileInfo.LastWriteTimeUtc -ge $MetadataTimestamp
        $inventoryIsCurrent = -not $InventoryTimestamp -or $cacheFileInfo.LastWriteTimeUtc -ge $InventoryTimestamp
        if (-not $metadataIsCurrent -or -not $inventoryIsCurrent) {
            return $null
        }

        $jsonData = Get-Content -LiteralPath $CachePath -Raw -Encoding UTF8 -ErrorAction Stop
        $cachedHash = ConvertFrom-JsonToHashtable -InputObject $jsonData
        $store = New-Object 'System.Collections.Generic.Dictionary[string, object]' ([System.StringComparer]::OrdinalIgnoreCase)
        foreach ($key in $cachedHash.Keys) {
            $store[$key] = ConvertTo-ColorScriptMetadataRecord -Source $cachedHash[$key]
        }

        Write-Verbose 'Loaded metadata from JSON cache (fast path)'
        return $store
    }
    catch {
        Write-Verbose "JSON metadata cache load failed, will rebuild: $($_.Exception.Message)"
        return $null
    }
}

function Merge-UniqueStringValue {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [string[]]$Existing,
        [string[]]$Additional
    )

    $set = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
    $list = New-Object 'System.Collections.Generic.List[string]'
    foreach ($value in @($Existing) + @($Additional)) {
        if (-not [string]::IsNullOrWhiteSpace($value) -and $set.Add($value)) {
            $null = $list.Add($value)
        }
    }

    return $list.ToArray()
}

function Import-ColorScriptMetadataData {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    if (-not (Test-Path -LiteralPath $script:MetadataPath)) {
        return $null
    }

    $importParams = @{ LiteralPath = $script:MetadataPath }
    $supportsSkipLimitCheck = $false
    try {
        $command = Get-Command -Name Import-PowerShellDataFile -ErrorAction SilentlyContinue
        if ($command -and $command.Parameters.ContainsKey('SkipLimitCheck')) {
            $importParams['SkipLimitCheck'] = $true
            $supportsSkipLimitCheck = $true
        }
    }
    catch {
        Write-Verbose "Unable to inspect Import-PowerShellDataFile parameters. Continuing without SkipLimitCheck. Error: $($_.Exception.Message)"
    }

    try {
        if ($supportsSkipLimitCheck) {
            return Import-PowerShellDataFile @importParams
        }

        # Windows PowerShell 5.1 cannot bypass the data-file limit for this package-owned asset.
        # Evaluating only this fixed module path retains Desktop compatibility without accepting
        # a user-supplied script path.
        $metadataSource = [System.IO.File]::ReadAllText($script:MetadataPath)
        return & ([scriptblock]::Create($metadataSource))
    }
    catch {
        Write-Verbose ("Import-PowerShellDataFile failed for ScriptMetadata.psd1: {0}" -f $_.Exception.Message)
        return $null
    }
}

function Get-ColorScriptMetadataInternalEntry {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, hashtable]]$Map,
        [Parameter(Mandatory)][string]$Name
    )

    if (-not $Map.ContainsKey($Name)) {
        $Map[$Name] = @{
            Category    = $null
            Categories  = New-Object 'System.Collections.Generic.List[string]'
            Tags        = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
            Description = $null
        }
    }

    return $Map[$Name]
}

function Merge-ColorScriptCategoryRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][hashtable]$Data,
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, hashtable]]$Map
    )

    if ($Data.Categories -isnot [hashtable]) {
        return
    }

    foreach ($categoryName in $Data.Categories.Keys) {
        foreach ($scriptName in @($Data.Categories[$categoryName])) {
            $entry = Get-ColorScriptMetadataInternalEntry -Map $Map -Name $scriptName
            if (-not $entry.Categories.Contains($categoryName)) {
                $null = $entry.Categories.Add($categoryName)
            }
            $null = $entry.Tags.Add("Category:$categoryName")
            if (-not $entry.Category) {
                $entry.Category = $categoryName
            }
        }
    }
}

function Merge-ColorScriptLevelRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][hashtable]$Data,
        [Parameter(Mandatory)][string]$PropertyName,
        [Parameter(Mandatory)][string]$TagPrefix,
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, hashtable]]$Map
    )

    $levelMap = $Data[$PropertyName]
    if ($levelMap -isnot [hashtable]) {
        return
    }

    foreach ($level in $levelMap.Keys) {
        foreach ($scriptName in @($levelMap[$level])) {
            $entry = Get-ColorScriptMetadataInternalEntry -Map $Map -Name $scriptName
            $null = $entry.Tags.Add("${TagPrefix}:$level")
        }
    }
}

function Merge-ColorScriptRecommendedRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][hashtable]$Data,
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, hashtable]]$Map
    )

    if ($Data.Recommended -isnot [System.Collections.IEnumerable]) {
        return
    }

    foreach ($scriptName in @($Data.Recommended)) {
        $entry = Get-ColorScriptMetadataInternalEntry -Map $Map -Name $scriptName
        $null = $entry.Tags.Add('Recommended')
    }
}

function Merge-ColorScriptTagRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][hashtable]$Data,
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, hashtable]]$Map
    )

    if ($Data.Tags -isnot [hashtable]) {
        return
    }

    foreach ($scriptName in $Data.Tags.Keys) {
        $entry = Get-ColorScriptMetadataInternalEntry -Map $Map -Name $scriptName
        foreach ($tag in @(ConvertTo-StringValueCollection -Value $Data.Tags[$scriptName])) {
            $null = $entry.Tags.Add($tag)
        }
    }
}

function Merge-ColorScriptDescriptionRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][hashtable]$Data,
        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, hashtable]]$Map
    )

    if ($Data.Descriptions -isnot [hashtable]) {
        return
    }

    foreach ($scriptName in $Data.Descriptions.Keys) {
        $description = $Data.Descriptions[$scriptName]
        if ($null -eq $description -or [string]::IsNullOrWhiteSpace([string]$description)) {
            continue
        }
        $entry = Get-ColorScriptMetadataInternalEntry -Map $Map -Name $scriptName
        $entry.Description = [string]$description
    }
}

function ConvertTo-ColorScriptMetadataStore {
    [CmdletBinding()]
    [OutputType([object])]
    param(
        [Parameter()][AllowNull()][object]$Data
    )

    $store = New-Object 'System.Collections.Generic.Dictionary[string, object]' ([System.StringComparer]::OrdinalIgnoreCase)
    if ($Data -isnot [hashtable]) {
        return $store
    }

    $internal = New-Object 'System.Collections.Generic.Dictionary[string, hashtable]' ([System.StringComparer]::OrdinalIgnoreCase)
    Merge-ColorScriptCategoryRecord -Data $Data -Map $internal
    Merge-ColorScriptLevelRecord -Data $Data -PropertyName 'Difficulty' -TagPrefix 'Difficulty' -Map $internal
    Merge-ColorScriptLevelRecord -Data $Data -PropertyName 'Complexity' -TagPrefix 'Complexity' -Map $internal
    Merge-ColorScriptRecommendedRecord -Data $Data -Map $internal
    Merge-ColorScriptTagRecord -Data $Data -Map $internal
    Merge-ColorScriptDescriptionRecord -Data $Data -Map $internal

    foreach ($key in $internal.Keys) {
        $value = $internal[$key]
        $category = if ($value.Category) { $value.Category } else { 'Uncategorized' }
        $store[$key] = [pscustomobject]@{
            Category    = $category
            Categories  = ConvertTo-StringValueCollection -Value $value.Categories
            Tags        = ConvertTo-StringValueCollection -Value $value.Tags
            Description = $value.Description
        }
    }

    return $store
}

function ConvertTo-AutoCategoryRule {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][object]$Rule
    )

    $category = [string]$Rule.Category
    if ([string]::IsNullOrWhiteSpace($category)) {
        return $null
    }

    $patterns = ConvertTo-StringValueCollection -Value $Rule.Patterns
    if ($patterns.Count -eq 0) {
        return $null
    }

    return [pscustomobject]@{
        Category = $category
        Patterns = $patterns
        Tags     = ConvertTo-StringValueCollection -Value $Rule.Tags
    }
}

function Get-AutoCategoryRuleCollection {
    [CmdletBinding()]
    [OutputType([object[]])]
    param(
        [Parameter()][AllowNull()][object]$Data
    )

    $rules = New-Object 'System.Collections.Generic.List[object]'
    if ($Data -is [hashtable] -and
        $Data.ContainsKey('AutoCategories') -and
        $Data.AutoCategories -is [System.Collections.IEnumerable]) {
        foreach ($sourceRule in $Data.AutoCategories) {
            $rule = ConvertTo-AutoCategoryRule -Rule $sourceRule
            if ($rule) {
                $null = $rules.Add($rule)
            }
        }
    }

    if ($rules.Count -eq 0) {
        return @($script:DefaultAutoCategoryRules)
    }

    return $rules.ToArray()
}

function Test-AutoCategoryRuleMatch {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][object]$Rule
    )

    foreach ($pattern in @(ConvertTo-StringValueCollection -Value $Rule.Patterns)) {
        if ([System.Text.RegularExpressions.Regex]::IsMatch($Name, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
            return $true
        }
    }

    return $false
}

function Resolve-ColorScriptAutoCategory {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Rule
    )

    $categoryCollection = New-Object 'System.Collections.Generic.List[string]'
    $tagCollection = New-Object 'System.Collections.Generic.List[string]'
    foreach ($currentRule in $Rule) {
        if (-not (Test-AutoCategoryRuleMatch -Name $Name -Rule $currentRule)) {
            continue
        }

        if (-not $categoryCollection.Contains($currentRule.Category)) {
            $null = $categoryCollection.Add([string]$currentRule.Category)
        }
        foreach ($tag in @(ConvertTo-StringValueCollection -Value $currentRule.Tags)) {
            if (-not $tagCollection.Contains($tag)) {
                $null = $tagCollection.Add($tag)
            }
        }
    }

    if ($categoryCollection.Count -eq 0) {
        $null = $categoryCollection.Add('Abstract')
    }

    return [pscustomobject]@{
        Categories = [string[]]$categoryCollection.ToArray()
        Tags       = [string[]]$tagCollection.ToArray()
    }
}

function Get-EmptyColorScriptMetadataRecord {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    return [pscustomobject]@{
        Category    = 'Uncategorized'
        Categories  = @()
        Tags        = @()
        Description = $null
    }
}

function ConvertTo-AutoCategorizedMetadataRecord {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][object]$ExistingEntry,
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Rule
    )

    $autoInfo = Resolve-ColorScriptAutoCategory -Name $Name -Rule $Rule
    $baseCategories = New-Object 'System.Collections.Generic.List[string]'
    if ($ExistingEntry.Category -and $ExistingEntry.Category -ne 'Uncategorized') {
        $null = $baseCategories.Add([string]$ExistingEntry.Category)
    }
    foreach ($category in @(ConvertTo-StringValueCollection -Value $ExistingEntry.Categories)) {
        if ($category -ne 'Uncategorized') {
            $null = $baseCategories.Add($category)
        }
    }

    $categories = [string[]](Merge-UniqueStringValue -Existing $baseCategories.ToArray() -Additional $autoInfo.Categories)
    if ($categories.Count -eq 0) {
        $categories = @('Abstract')
    }

    $category = if ($ExistingEntry.Category -and $ExistingEntry.Category -ne 'Uncategorized') {
        [string]$ExistingEntry.Category
    }
    else {
        $categories[0]
    }
    $autoTagCollection = @($autoInfo.Tags) + @($categories | ForEach-Object { "Category:$($_)" }) + @('AutoCategorized')
    $tags = [string[]](Merge-UniqueStringValue -Existing (ConvertTo-StringValueCollection -Value $ExistingEntry.Tags) -Additional $autoTagCollection)

    return [pscustomobject]@{
        Category    = $category
        Categories  = $categories
        Tags        = $tags
        Description = $ExistingEntry.Description
    }
}

function Merge-InventoryAutoCategoryRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object]$Store,
        [Parameter(Mandatory)][AllowEmptyCollection()][object[]]$Rule
    )

    foreach ($scriptFile in @(Get-ColorScriptInventory -Raw)) {
        $name = $scriptFile.BaseName
        $entryExists = $Store.ContainsKey($name)
        $existingEntry = if ($entryExists) { $Store[$name] } else { Get-EmptyColorScriptMetadataRecord }
        $needsAutoCategory = -not $entryExists -or
            [string]::IsNullOrWhiteSpace($existingEntry.Category) -or
            $existingEntry.Category -eq 'Uncategorized'
        if ($needsAutoCategory) {
            $Store[$name] = ConvertTo-AutoCategorizedMetadataRecord -Name $name -ExistingEntry $existingEntry -Rule $Rule
        }
    }
}

function ConvertTo-NormalizedColorScriptMetadataRecord {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)][object]$Entry
    )

    $baseCategories = New-Object 'System.Collections.Generic.List[string]'
    if ($Entry.Category -and $Entry.Category -ne 'Uncategorized') {
        $null = $baseCategories.Add([string]$Entry.Category)
    }
    foreach ($category in @(ConvertTo-StringValueCollection -Value $Entry.Categories)) {
        $null = $baseCategories.Add($category)
    }
    if ($baseCategories.Count -eq 0) {
        $null = $baseCategories.Add('Abstract')
    }

    $categories = [string[]](Merge-UniqueStringValue -Existing @() -Additional $baseCategories.ToArray())
    if ($categories.Count -eq 0) {
        $categories = @('Abstract')
    }
    $categoryTags = @($categories | ForEach-Object { "Category:$($_)" })
    $tags = [string[]](Merge-UniqueStringValue -Existing (ConvertTo-StringValueCollection -Value $Entry.Tags) -Additional $categoryTags)

    return [pscustomobject]@{
        Category    = $categories[0]
        Categories  = $categories
        Tags        = $tags
        Description = $Entry.Description
    }
}

function Convert-ColorScriptMetadataStore {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][object]$Store
    )

    foreach ($key in @($Store.Keys)) {
        $Store[$key] = ConvertTo-NormalizedColorScriptMetadataRecord -Entry $Store[$key]
    }
}

function Use-ColorScriptMetadataStore {
    [CmdletBinding()]
    [OutputType([object])]
    param(
        [Parameter(Mandatory)][object]$Store,
        [Parameter()][AllowNull()][object]$MetadataTimestamp,
        [Parameter()][AllowNull()][object]$InventoryTimestamp
    )

    $script:MetadataCache = $Store
    $script:MetadataLastWriteTime = $MetadataTimestamp
    $script:MetadataInventoryLastWriteTime = $InventoryTimestamp
    return $script:MetadataCache
}

function Write-ColorScriptMetadataJsonCache {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$CachePath,
        [Parameter(Mandatory)][object]$Store
    )

    try {
        $jsonData = $Store | ConvertTo-Json -Depth 10 -Compress
        Invoke-FileWriteAllText -Path $CachePath -Content $jsonData -Encoding $script:Utf8NoBomEncoding
        Write-Verbose 'Saved metadata to JSON cache for faster future loads'
    }
    catch {
        Write-Verbose "Failed to save JSON metadata cache: $($_.Exception.Message)"
    }
}

function Get-ColorScriptMetadataTableInternal {
    $metadataTimestamp = Get-ColorScriptMetadataTimestamp
    $inventoryTimestamp = Get-ColorScriptInventoryTimestamp
    if (Test-ColorScriptMetadataMemoryCache -MetadataTimestamp $metadataTimestamp -InventoryTimestamp $inventoryTimestamp) {
        return $script:MetadataCache
    }

    $binaryCachePath = Get-ColorScriptMetadataCachePath
    if ($binaryCachePath) {
        $cachedStore = Import-ColorScriptMetadataJsonCache -CachePath $binaryCachePath -MetadataTimestamp $metadataTimestamp -InventoryTimestamp $inventoryTimestamp
        if ($cachedStore) {
            return Use-ColorScriptMetadataStore -Store $cachedStore -MetadataTimestamp $metadataTimestamp -InventoryTimestamp $inventoryTimestamp
        }
    }

    $data = Import-ColorScriptMetadataData
    $store = ConvertTo-ColorScriptMetadataStore -Data $data
    $autoCategoryRule = @(Get-AutoCategoryRuleCollection -Data $data)
    Merge-InventoryAutoCategoryRecord -Store $store -Rule $autoCategoryRule
    Convert-ColorScriptMetadataStore -Store $store
    $result = Use-ColorScriptMetadataStore -Store $store -MetadataTimestamp $metadataTimestamp -InventoryTimestamp $inventoryTimestamp

    if ($binaryCachePath) {
        Write-ColorScriptMetadataJsonCache -CachePath $binaryCachePath -Store $store
    }

    return $result
}
