---
external help file: ColorScripts-Enhanced-help.xml
Module Name: ColorScripts-Enhanced
online version: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
schema: 2.0.0
---

# Get-ColorScriptList

## SYNOPSIS

Lists available colorscripts and optionally returns rich metadata.

## SYNTAX

```
Get-ColorScriptList [-AsObject] [-Detailed] [-Name <String[]>] [-Category <String[]>] [-Tag <String[]>] [<CommonParameters>]
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

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Detailed

Include tag and description columns when rendering the formatted table view.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name

Filter by one or more script names. Wildcards are supported and unmatched patterns generate warnings.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: True
```

### -Category

Limit results to scripts whose metadata includes the specified categories (case-insensitive).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag

Limit results to scripts tagged with the supplied metadata tags (case-insensitive).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

This cmdlet does not accept pipeline input.

## OUTPUTS

### System.Object[]

Returns colorscript metadata records when `-AsObject` is used. Without `-AsObject` the cmdlet writes a formatted table to the host and still returns the records for further processing.

## NOTES

Author: Nick
Module: ColorScripts-Enhanced

Returned records expose `Name`, `Category`, `Categories`, `Tags`, `Description`, and original metadata via the `Metadata` property. Use the names directly with `Show-ColorScript`.

## RELATED LINKS

[Show-ColorScript](Show-ColorScript.md)
[Build-ColorScriptCache](Build-ColorScriptCache.md)
[Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
