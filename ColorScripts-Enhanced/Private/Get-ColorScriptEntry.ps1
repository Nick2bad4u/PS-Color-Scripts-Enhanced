function New-DefaultColorScriptMetadataEntry {
    return [pscustomobject]@{
        Category    = 'Abstract'
        Categories  = @('Abstract')
        Tags        = @('Category:Abstract', 'AutoCategorized')
        Description = $null
    }
}

function ConvertTo-ColorScriptEntryRecord {
    param(
        [Parameter(Mandatory)]
        [object]$Script,

        [AllowNull()]
        [object]$Metadata
    )

    $entry = if ($Metadata) { $Metadata } else { New-DefaultColorScriptMetadataEntry }
    $categoryValue = if ($entry.PSObject.Properties.Name -contains 'Category' -and $entry.Category) {
        [string]$entry.Category
    }
    else {
        'Abstract'
    }

    $categoriesValue = if ($entry.PSObject.Properties.Name -contains 'Categories') {
        [string[]]$entry.Categories
    }
    else {
        @()
    }
    if (-not $categoriesValue -or $categoriesValue.Count -eq 0) {
        $categoriesValue = @($categoryValue)
    }

    $tagsValue = if ($entry.PSObject.Properties.Name -contains 'Tags') {
        [string[]]$entry.Tags
    }
    else {
        @()
    }
    if (-not $tagsValue -or $tagsValue.Count -eq 0) {
        $tagsValue = @("Category:$categoryValue")
    }

    $descriptionValue = if ($entry.PSObject.Properties.Name -contains 'Description') {
        [string]$entry.Description
    }
    else {
        $null
    }

    return [pscustomobject]@{
        Name        = $Script.BaseName
        Path        = $Script.FullName
        Category    = $categoryValue
        Categories  = $categoriesValue
        Tags        = $tagsValue
        Description = $descriptionValue
        Metadata    = $entry
    }
}

function New-ColorScriptFilterSet {
    param(
        [Parameter(Mandatory)]
        [string[]]$Value
    )

    $set = New-Object 'System.Collections.Generic.HashSet[string]' ([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($item in $Value) {
        if (-not [string]::IsNullOrWhiteSpace($item)) {
            [void]$set.Add($item)
        }
    }

    Write-Output -InputObject $set -NoEnumerate
}

function Test-ColorScriptFilterSetMatch {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]]$Value,

        [Parameter(Mandatory)]
        [System.Collections.Generic.HashSet[string]]$FilterSet
    )

    foreach ($item in $Value) {
        if ($item -and $FilterSet.Contains($item)) {
            return $true
        }
    }

    return $false
}

function Select-ColorScriptEntryByCategory {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]]$Record,

        [Parameter(Mandatory)]
        [string[]]$Category
    )

    $categorySet = New-ColorScriptFilterSet -Value $Category
    return @($Record | Where-Object {
            $recordCategories = @($_.Category) + @($_.Categories)
            Test-ColorScriptFilterSetMatch -Value $recordCategories -FilterSet $categorySet
        })
}

function Select-ColorScriptEntryByTag {
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]]$Record,

        [Parameter(Mandatory)]
        [string[]]$Tag
    )

    $tagSet = New-ColorScriptFilterSet -Value $Tag
    return @($Record | Where-Object {
            Test-ColorScriptFilterSetMatch -Value @($_.Tags) -FilterSet $tagSet
        })
}

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
    [object[]]$records = @(foreach ($script in $scripts) {
            $entry = if ($metadata.ContainsKey($script.BaseName)) {
                $metadata[$script.BaseName]
            }
            else {
                $null
            }
            ConvertTo-ColorScriptEntryRecord -Script $script -Metadata $entry
        })

    if ($Name) {
        $selection = Select-RecordsByName -Records $records -Name $Name
        $records = @($selection.Records)
    }

    if ($Category) {
        $records = @(Select-ColorScriptEntryByCategory -Record $records -Category $Category)
    }

    if ($Tag) {
        $records = @(Select-ColorScriptEntryByTag -Record $records -Tag $Tag)
    }

    return [pscustomobject[]]$records
}
