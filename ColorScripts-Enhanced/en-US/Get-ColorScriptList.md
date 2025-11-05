---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/en-US/Get-ColorScriptList.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptList

## SYNOPSIS

Lists available colorscripts with optional filtering and rich metadata output.

## SYNTAX

### Default (Default)

```
Get-ColorScriptList [-AsObject] [-Detailed] [-Name <String[]>] [-Category <String[]>]
 [-Tag <String[]>] [<CommonParameters>]
```

### \_\_AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-AsObject]
 [-Detailed] [<CommonParameters>]
```

## DESCRIPTION

The `Get-ColorScriptList` cmdlet retrieves and displays all colorscripts packaged with the ColorScripts-Enhanced module. It provides flexible filtering options and multiple output formats to suit different use cases.

By default, the cmdlet displays a concise formatted table showing script names and categories. The `-Detailed` switch expands this view to include tags and descriptions, providing more context at a glance.

For automation and programmatic scenarios, the `-AsObject` parameter returns the raw metadata records as PowerShell objects, enabling further processing through the pipeline. These records include comprehensive information such as name, category, categories, tags, description, and the original metadata property.

Filtering capabilities allow you to narrow down the list by:

- **Name**: Supports wildcard patterns (e.g., `aurora-*`) for flexible matching
- **Category**: Filter by one or more category names (case-insensitive)
- **Tag**: Filter by metadata tags such as "Recommended" or "Animated" (case-insensitive)

The cmdlet validates filter patterns and generates warnings for any unmatched name patterns, helping you identify potential typos or missing scripts.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Displays all available colorscripts in a compact table format showing the name and category of each script.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed
```

Shows all colorscripts with additional columns including tags and descriptions for a comprehensive overview.

### EXAMPLE 3

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

Displays only scripts in the "Patterns" category with full metadata including tags and descriptions.

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

Returns structured objects for every script whose name matches the wildcard pattern, then selects only the Name and Tags properties for display.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

Retrieves all scripts tagged as "Recommended" and sorts them alphabetically by name. Useful for finding curated scripts suitable for profile integration.

### EXAMPLE 6

```powershell
Get-ColorScriptList -AsObject -Category Geometric,Abstract | Where-Object { $_.Tags -contains 'Colorful' }
```

Combines category and tag filtering to find scripts that are both in the Geometric or Abstract categories and tagged as Colorful.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Name blocks,pipes,matrix -AsObject | ForEach-Object { Show-ColorScript -Name $_.Name }
```

Retrieves specific named scripts and executes each one in sequence, demonstrating pipeline integration with `Show-ColorScript`.

### EXAMPLE 8

```powershell
# Count scripts by category for inventory purposes
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending
```

Provides a summary of how many colorscripts exist in each category.

### EXAMPLE 9

```powershell
# Find scripts with specific keywords in description
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

Searches for scripts based on their description content using pattern matching.

### EXAMPLE 10

```powershell
# Export to CSV for external tool processing
Get-ColorScriptList -AsObject -Detailed |
    Select-Object Name, Category, Tags, Description |
    Export-Csv -Path "./colorscripts-inventory.csv" -NoTypeInformation
```

Exports the complete colorscript inventory to CSV format for use in spreadsheet applications.

### EXAMPLE 11

```powershell
# Check for scripts without specific category
$allScripts = Get-ColorScriptList -AsObject
$uncategorized = $allScripts | Where-Object { -not $_.Category }
Write-Host "Uncategorized scripts: $($uncategorized.Count)"
$uncategorized | Select-Object Name
```

Identifies scripts that are missing category metadata.

### EXAMPLE 12

```powershell
# Build cache for filtered scripts
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object {
        New-ColorScriptCache -Name $_.Name -PassThru
    } |
    Format-Table Name, Status
```

Caches only the recommended scripts and shows the results of the caching operation.

### EXAMPLE 13

```powershell
# Create a formatted report of all geometric scripts
Get-ColorScriptList -Category Geometric -Detailed |
    Out-String |
    Tee-Object -FilePath "./geometric-report.txt"
```

Generates and saves a detailed report of geometric category colorscripts to a file.

### EXAMPLE 14

```powershell
# Find the first script matching a pattern for quick display
$script = Get-ColorScriptList -Name "aurora-*" -AsObject | Select-Object -First 1
if ($script) {
    Show-ColorScript -Name $script.Name -PassThru
}
```

Quickly displays the first matching script based on a wildcard pattern.

### EXAMPLE 15

```powershell
# Verify all referenced scripts exist before running automation
$requiredScripts = @("bars", "arch", "mandelbrot-zoom")
$available = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$missing = $requiredScripts | Where-Object { $_ -notin $available }
if ($missing) {
    Write-Warning "Missing scripts: $($missing -join ', ')"
} else {
    Write-Host "All required scripts are available"
}
```

Validates that all required scripts exist before automation runs.

## PARAMETERS

### -AsObject

Returns raw metadata record objects instead of rendering a formatted table to the host. This enables pipeline processing and programmatic manipulation of the colorscript metadata.

When this switch is specified, you can use standard PowerShell cmdlets like `Where-Object`, `Select-Object`, `Sort-Object`, and `ForEach-Object` to further process the results.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: (All)
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Category

Filters the list to include only scripts belonging to one or more specified categories. Category matching is case-insensitive.

Common categories include: Patterns, Geometric, Abstract, Nature, Animated, Text, Retro, and more. You can specify multiple categories to broaden your search.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: (All)
   Position: 1
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Detailed

Includes additional columns (tags and description) when rendering the formatted table view. This provides more comprehensive information about each script at a glance.

Without this switch, only the name and primary category are displayed in the table output.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: (All)
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Name

Filters the colorscript list by one or more script names. Supports wildcard characters (`*` and `?`) for flexible pattern matching.

If a specified pattern does not match any scripts, a warning is generated to help identify potential issues. Name matching is case-insensitive.

You can specify exact names or use patterns like `aurora-*` to match multiple related scripts.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
 - Name: (All)
   Position: 0
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Tag

Filters the list to include only scripts containing one or more specified metadata tags. Tag matching is case-insensitive.

Common tags include: Recommended, Animated, Colorful, Minimal, Retro, Complex, Simple, and more. Tags help categorize scripts by visual style, complexity, or use case.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: (All)
   Position: 2
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

This cmdlet does not accept pipeline input.

## OUTPUTS

### System.Object

When `-AsObject` is specified, returns colorscript metadata record objects with the following properties:

- **Name**: The script identifier used with `Show-ColorScript`
- **Category**: The primary category of the script
- **Categories**: An array of all categories the script belongs to
- **Tags**: An array of metadata tags describing the script
- **Description**: A human-readable description of the script's visual output
- **Metadata**: The original metadata object containing all raw script information

Without `-AsObject`, the cmdlet writes a formatted table to the host while still returning the record objects for potential pipeline processing.

## ADVANCED USAGE PATTERNS

### Dynamic Filtering

**Multi-Criteria Filtering**

```powershell
# Find animated scripts that are colorful
Get-ColorScriptList -AsObject |
    Where-Object {
        $_.Tags -contains 'Animated' -and
        $_.Tags -contains 'Colorful'
    }

# Find scripts in Nature category but exclude simple ones
Get-ColorScriptList -Category Nature -AsObject |
    Where-Object { $_.Tags -notcontains 'Simple' }
```

**Fuzzy Matching**

```powershell
# Find scripts similar to a name pattern
$search = "wave"
Get-ColorScriptList -AsObject |
    Where-Object { $_.Name -like "*$search*" } |
    Select-Object Name, Category
```

### Data Analysis

**Category Distribution**

```powershell
# Analyze how scripts are distributed across categories
$analysis = Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object @{N='Category'; E={$_.Name}}, @{N='Count'; E={$_.Count}}, @{N='Percentage'; E={[math]::Round($_.Count / (Get-ColorScriptList -AsObject).Count * 100)}}

$analysis | Sort-Object Count -Descending | Format-Table
```

**Tag Frequency Analysis**

```powershell
# Determine most common tags
Get-ColorScriptList -AsObject |
    ForEach-Object { $_.Tags } |
    Group-Object |
    Sort-Object Count -Descending |
    Format-Table Name, Count
```

### Integration Workflows

**Playlist Creation**

```powershell
# Create a "favorite" playlist
$playlist = Get-ColorScriptList -AsObject |
    Where-Object { $_.Tags -contains 'Recommended' } |
    Select-Object -ExpandProperty Name

# Display playlist
$playlist | ForEach-Object {
    Write-Host "Showing: $_"
    Show-ColorScript -Name $_
    Start-Sleep -Seconds 2
}
```

**Metadata Export for Web**

```powershell
# Export detailed metadata
$web = Get-ColorScriptList -AsObject |
    Select-Object Name, Category, Tags, Description |
    ConvertTo-Json

$web | Out-File "./scripts.json" -Encoding UTF8
```

**Validation and Health Check**

```powershell
# Health check on all scripts
$health = Get-ColorScriptList -AsObject |
    ForEach-Object {
        $cached = Test-Path "$env:APPDATA\ColorScripts-Enhanced\cache\$($_.Name).cache"
        [PSCustomObject]@{
            Name = $_.Name
            Category = $_.Category
            Cached = $cached
            TagCount = $_.Tags.Count
        }
    }

$uncached = @($health | Where-Object { -not $_.Cached })
Write-Host "Scripts without cache: $($uncached.Count)"
$uncached | Format-Table Name, Category
```

## PERFORMANCE CONSIDERATIONS

### Query Optimization

**Filter Early**

```powershell
# Faster: Filter by category first
Get-ColorScriptList -Category Geometric -AsObject |
    Where-Object { $_.Name -like "*spiral*" }

# Slower: Get all then filter
Get-ColorScriptList -AsObject |
    Where-Object { $_.Category -eq "Geometric" -and $_.Name -like "*spiral*" }
```

**Use Appropriate Output Format**

```powershell
# For exploration: Detailed display
Get-ColorScriptList -Detailed

# For automation: Object format
Get-ColorScriptList -AsObject

# For piping: AsObject to pipeline
Get-ColorScriptList -AsObject | ForEach-Object { ... }
```

## NOTES

**Author**: Nick
**Module**: ColorScripts-Enhanced
**Version**: 1.0

The returned metadata records provide comprehensive information for both display and automation purposes. The `Name` property can be used directly with the `Show-ColorScript` cmdlet to execute specific scripts.

All filtering operations (Name, Category, Tag) are case-insensitive and can be combined to create powerful queries. When using wildcards in the `-Name` parameter, unmatched patterns generate warnings to help with troubleshooting.

For best results when integrating colorscripts into your PowerShell profile, use the `-Tag Recommended` filter to identify curated scripts suitable for startup display.

### Best Practices

- Always use `-AsObject` when you need to filter or manipulate results programmatically
- Use `-Detailed` when exploring interactively to see tags and descriptions
- Combine multiple filters for precise queries
- Export metadata periodically to track changes over time
- Use result objects for automation rather than parsing text output
- Consider performance when running queries repeatedly (cache results if possible)
- Leverage Group-Object for analysis and reporting
- Use Where-Object for complex filtering logic

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
- [Module Repository](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
