---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Build-ColorScriptCache

## SYNOPSIS

Pre-build or refresh colorscript cache files for faster rendering.

## DESCRIPTION

`Build-ColorScriptCache` executes colorscripts in a background PowerShell instance and saves the rendered output using UTF-8 encoding (without BOM). Cached content dramatically speeds up subsequent calls to `Show-ColorScript` by eliminating the need to re-execute scripts.

You can target specific scripts by name (wildcards supported) or cache the entire collection. When no parameters are specified, the cmdlet defaults to caching all available scripts. You can also filter scripts by category or tag to cache only those that match specific criteria.

By default, the cmdlet displays a concise summary of the caching operation. Use `-PassThru` to return detailed result objects for each script, which you can inspect programmatically for status, standard output, and error streams.

The cmdlet intelligently skips scripts whose cache files are already up-to-date unless you specify the `-Force` parameter to rebuild all caches regardless of their current state.

## SYNTAX

### All

```
Build-ColorScriptCache [-All] [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Named

```
Build-ColorScriptCache [-Name <String[]>] [-Category <String[]>] [-Tag <String[]>] [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## EXAMPLES

### EXAMPLE 1

```powershell
Build-ColorScriptCache
```

Warm the cache for every script that ships with the module. This is the default behavior when no parameters are specified.

### EXAMPLE 2

```powershell
Build-ColorScriptCache -Name bars, 'aurora-*'
```

Cache a mix of exact and wildcard matches. The cmdlet will process the 'bars' script and all scripts whose names start with 'aurora-'.

### EXAMPLE 3

```powershell
Build-ColorScriptCache -Name mandelbrot-zoom -Force -PassThru | Format-List
```

Force a rebuild of the 'mandelbrot-zoom' cache even if it's up-to-date, and examine the detailed result object.

### EXAMPLE 4

```powershell
Build-ColorScriptCache -Category 'Animation' -PassThru
```

Cache all scripts in the 'Animation' category and return detailed results for each operation.

### EXAMPLE 5

```powershell
Build-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

Rebuild caches for all scripts tagged with either 'geometric' or 'colorful', forcing regeneration even if caches are current.

### EXAMPLE 6

```powershell
Get-ColorScriptList | Where-Object Category -eq 'Classic' | Build-ColorScriptCache -PassThru
```

Pipeline example: retrieve all classic scripts and cache them, returning detailed results.

## PARAMETERS

### -All

Cache every available script. When omitted and no names are supplied, all scripts are cached by default. This parameter is useful when you want to be explicit about caching all scripts.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

Limit the selection to scripts that belong to the specified category (case-insensitive). Multiple values are treated as an OR filter, meaning scripts matching any of the specified categories will be cached.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Named
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Prompts you for confirmation before running the cmdlet. Useful when caching a large number of scripts or when using `-Force` to prevent accidental cache regeneration.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -Force

Rebuild cache files even when the existing cache is newer than the script source. This is useful when you want to ensure all caches are regenerated, such as after module updates or when troubleshooting rendering issues.

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

One or more colorscript names to cache. Supports wildcard patterns (e.g., 'aurora-*', '*-wave'). When this parameter is omitted and no filtering parameters are specified, the cmdlet caches every available script by default.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Named
  Position: 0
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PassThru

Return detailed result objects for each cache operation. By default, only a summary is displayed. The result objects include properties such as Name, Status, CacheFile, ExitCode, StdOut, and StdErr, allowing for programmatic inspection of the caching process.

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

### -Tag

Limit the selection to scripts containing the specified metadata tags (case-insensitive). Multiple values are treated as an OR filter, caching scripts that match any of the specified tags.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Named
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Shows what would happen if the cmdlet runs without actually performing the caching operations. Useful for previewing which scripts would be cached before committing to the operation.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

You can pipe script names to this cmdlet. Each string is treated as a potential script name and supports wildcard matching.

### System.String[]

You can pipe an array of script names or metadata records with a `Name` property to this cmdlet for batch processing.

## OUTPUTS

### System.Object

When `-PassThru` is specified, returns a custom object for each processed script containing the following properties:

- **Name**: The colorscript name
- **Status**: Success, Skipped, or Failed
- **CacheFile**: Full path to the generated cache file
- **ExitCode**: The exit code from the script execution (0 indicates success)
- **StdOut**: Standard output captured during script execution
- **StdErr**: Standard error output captured during script execution

Without `-PassThru`, displays a concise summary table to the console showing the number of scripts cached, skipped, and failed.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced

Cache files are stored in the directory exposed by the module's `CacheDir` variable (typically within the module's data directory). A successful build sets the cache file's timestamp to match the script's last write time, enabling subsequent runs to skip unchanged scripts efficiently.

The cmdlet executes each script in an isolated background PowerShell process to capture its output without affecting the current session. This ensures accurate caching of the exact console output that would be displayed when running the script directly.

**Performance Tip:** Run this cmdlet once after installing or updating the module to pre-cache all scripts for optimal performance.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
