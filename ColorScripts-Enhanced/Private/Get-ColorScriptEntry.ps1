function Get-ColorScriptEntry {
    param(
        [SupportsWildcards()]
        [ValidateScript({ Test-ColorScriptNameValue $_ -AllowWildcard })]
        [string[]]$Name,
        [string[]]$Category,
        [string[]]$Tag
    )

    $metadata = Get-ColorScriptMetadataTable
    $scripts = Get-ColorScriptInventory -Raw

    $records = foreach ($script in $scripts) {
        $entry = if ($metadata.ContainsKey($script.BaseName)) { $metadata[$script.BaseName] } else { $null }

        if (-not $entry) {
            $entry = [pscustomobject]@{
                Category    = 'Abstract'
                Categories  = @('Abstract')
                Tags        = @('Category:Abstract', 'AutoCategorized')
                Description = $null
            }
        }

        $categoryValue = if ($entry.PSObject.Properties.Name -contains 'Category' -and $entry.Category) { [string]$entry.Category } else { 'Abstract' }
        $categoriesValue = if ($entry.PSObject.Properties.Name -contains 'Categories') { [string[]]$entry.Categories } else { @() }
        if (-not $categoriesValue -or $categoriesValue.Count -eq 0) {
            $categoriesValue = @($categoryValue)
        }

        $tagsValue = if ($entry.PSObject.Properties.Name -contains 'Tags') { [string[]]$entry.Tags } else { @() }
        if (-not $tagsValue -or $tagsValue.Count -eq 0) {
            $tagsValue = @("Category:$categoryValue")
        }
        $descriptionValue = if ($entry.PSObject.Properties.Name -contains 'Description') { [string]$entry.Description } else { $null }

        [pscustomobject]@{
            Name        = $script.BaseName
            Path        = $script.FullName
            Category    = $categoryValue
            Categories  = $categoriesValue
            Tags        = $tagsValue
            Description = $descriptionValue
            Metadata    = $entry
        }
    }

    if ($Name) {
        $selection = Select-RecordsByName -Records $records -Name $Name
        $records = $selection.Records
    }

    if ($Category) {
        $categorySet = $Category | ForEach-Object { $_.ToLowerInvariant() }
        $records = $records | Where-Object {
            $recordCategories = @($_.Category) + $_.Categories
            $recordCategories = $recordCategories | Where-Object { $_ } | ForEach-Object { $_.ToLowerInvariant() }
            $match = $false
            foreach ($categoryValue in $recordCategories) {
                if ($categorySet -contains $categoryValue) {
                    $match = $true
                    break
                }
            }
            $match
        }
    }

    if ($Tag) {
        $tagSet = $Tag | ForEach-Object { $_.ToLowerInvariant() }
        $records = $records | Where-Object {
            $recordTags = $_.Tags | ForEach-Object { $_.ToLowerInvariant() }
            $match = $false
            foreach ($tagValue in $recordTags) {
                if ($tagSet -contains $tagValue) {
                    $match = $true
                    break
                }
            }
            $match
        }
    }

    return [pscustomobject[]]$records
}
