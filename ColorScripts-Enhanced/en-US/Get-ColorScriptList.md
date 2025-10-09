---
external help file: ColorScripts-Enhanced-help.xml
Module Name: ColorScripts-Enhanced
online version: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
schema: 2.0.0
---

# Get-ColorScriptList

## SYNOPSIS
Lists all available colorscripts.

## SYNTAX

```
Get-ColorScriptList [<CommonParameters>]
```

## DESCRIPTION
Returns a formatted list of all colorscripts available in the module. Scripts are displayed in a multi-column format for easy viewing.

This command helps you discover available colorscripts and see what names to use with Show-ColorScript.

## EXAMPLES

### EXAMPLE 1
```powershell
Get-ColorScriptList
```
Lists all available colorscripts in a formatted two-column display.

### EXAMPLE 2
```powershell
Get-ColorScriptList | Out-String | Select-String "mandel"
```
Find colorscripts with "mandel" in the name.

### EXAMPLE 3
```powershell
$scripts = Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter *.cache
$scripts.Count
```
Count how many scripts are currently cached.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
This cmdlet does not accept pipeline input.

## OUTPUTS

### None
This cmdlet displays formatted output directly to the console.

## NOTES
Author: Nick
Module: ColorScripts-Enhanced

The list shows script names without the .ps1 extension. Use these names with Show-ColorScript -Name parameter.

## RELATED LINKS

[Show-ColorScript](Show-ColorScript.md)
[Build-ColorScriptCache](Build-ColorScriptCache.md)
[Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
