---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: en-US
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

Lists available colorscripts with optional filtering and rich metadata output.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

This command has no aliases.

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
DefaultValue: ''
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
HelpMessage: ''
```

### -Category

Filters the list to include only scripts belonging to one or more specified categories. Category matching is case-insensitive.

Common categories include: Patterns, Geometric, Abstract, Nature, Animated, Text, Retro, and more. You can specify multiple categories to broaden your search.

```yaml
Type: System.String[]
DefaultValue: ''
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
HelpMessage: ''
```

### -Detailed

Includes additional columns (tags and description) when rendering the formatted table view. This provides more comprehensive information about each script at a glance.

Without this switch, only the name and primary category are displayed in the table output.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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
HelpMessage: ''
```

### -h

Displays detailed help for this command without performing the operation.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- help
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

Filters the colorscript list by one or more script names. Supports wildcard characters (`*` and `?`) for flexible pattern matching.

If a specified pattern does not match any scripts, a warning is generated to help identify potential issues. Name matching is case-insensitive.

You can specify exact names or use patterns like `aurora-*` to match multiple related scripts.

```yaml
Type: System.String[]
DefaultValue: ''
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
HelpMessage: ''
```

### -NoAnsiOutput

Disables ANSI styling in informational messages and rendered output for plain-text environments.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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
HelpMessage: ''
```

### -Quiet

Suppresses informational messages while preserving command output and errors.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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
HelpMessage: ''
```

### -Tag

Filters the list to include only scripts containing one or more specified metadata tags. Tag matching is case-insensitive.

Common tags include: Recommended, Animated, Colorful, Minimal, Retro, Complex, Simple, and more. Tags help categorize scripts by visual style, complexity, or use case.

```yaml
Type: System.String[]
DefaultValue: ''
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
HelpMessage: ''
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

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
