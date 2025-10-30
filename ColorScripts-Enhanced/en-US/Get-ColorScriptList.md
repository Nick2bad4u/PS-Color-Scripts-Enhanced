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

### __AllParameterSets

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
HelpMessage: ''
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
HelpMessage: ''
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
HelpMessage: ''
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
HelpMessage: ''
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

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
- [Module Repository](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
