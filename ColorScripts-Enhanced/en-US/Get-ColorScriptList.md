---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptList

## SYNOPSIS

Lists available colorscripts and optionally returns rich metadata.

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

`Get-ColorScriptList` surfaces the colorscripts packaged with the module. By default it renders a concise table, while `-AsObject` emits the underlying records for automation scenarios. You can filter the list by name (including wildcards), category, or tag metadata, and the optional `-Detailed` switch adds the tags and description columns to the formatted table.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Display all scripts in a compact table.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

Show only scripts in the _Patterns_ category and include tag metadata in the table output.

### EXAMPLE 3

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

Return structured objects for every script whose name matches the wildcard pattern.

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

Retrieve scripts tagged as recommended for profile usage.

## PARAMETERS

### -AsObject

Return metadata records instead of writing a formatted table to the host.
return raw record objects instead of rendering a formatted table.

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

Limit results to scripts whose metadata includes the specified categories (case-insensitive).
Filter the list to scripts belonging to one or more categories (case-insensitive).

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

Include tag and description columns when rendering the formatted table view.
Include tag and description columns when emitting the formatted table view.

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

Filter by one or more script names. Wildcards are supported and unmatched patterns generate warnings.
Filter the colorscript list by one or more names.
Wildcards are supported and unmatched patterns generate warnings.

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

Limit results to scripts tagged with the supplied metadata tags (case-insensitive).
Filter the list to scripts containing one or more metadata tags (case-insensitive).

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

Returns colorscript metadata records when `-AsObject` is used. Without `-AsObject` the cmdlet writes a formatted table to the host and still returns the records for further processing.

## NOTES

Author: Nick
Module: ColorScripts-Enhanced

Returned records expose `Name`, `Category`, `Categories`, `Tags`, `Description`, and original metadata via the `Metadata` property. Use the names directly with `Show-ColorScript`.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Build-ColorScriptCache](Build-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
