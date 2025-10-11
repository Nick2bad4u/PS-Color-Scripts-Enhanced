---
external help file: ColorScripts-Enhanced-help.xml
Module Name: ColorScripts-Enhanced
online version: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
schema: 2.0.0
---

# Build-ColorScriptCache

## SYNOPSIS

Pre-build or refresh colorscript cache files for faster rendering.

## SYNTAX

### All

```
Build-ColorScriptCache [-All] [-Force] [<CommonParameters>]
```

### Named

```
Build-ColorScriptCache [-Name <String[]>] [-Force] [<CommonParameters>]
```

## DESCRIPTION

`Build-ColorScriptCache` executes colorscripts in a background PowerShell instance and saves the rendered output using UTF-8 (without BOM). Cached content dramatically speeds up subsequent calls to `Show-ColorScript`. You can target specific scripts by name (wildcards supported) or cache the entire collection with `-All`. Results are returned as structured objects so you can inspect status, standard output, and error streams programmatically.

## EXAMPLES

### EXAMPLE 1

```powershell
Build-ColorScriptCache -All
```

Warm the cache for every script that ships with the module.

### EXAMPLE 2

```powershell
Build-ColorScriptCache -Name bars, 'aurora-*'
```

Cache a mix of exact and wildcard matches. Each matching script generates a result record.

### EXAMPLE 3

```powershell
Build-ColorScriptCache -Name mandelbrot-zoom -Force | Format-List
```

Force a rebuild even if the cache is newer than the source script and examine the detailed result.

## PARAMETERS

### -Name

One or more script names to cache. Supports wildcards. When absent you must supply `-All`.

```yaml
Type: String[]
Parameter Sets: Named
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue, ByPropertyName)
Accept wildcard characters: True
```

### -All

Cache every available script.

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

Rebuild cache files even when the existing cache is newer than the script source.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

You can pipe script names or metadata records with a `Name` property to this cmdlet.

## OUTPUTS

### System.Object[]

Returns a record per processed script containing `Name`, `Status`, `CacheFile`, `ExitCode`, `StdOut`, and `StdErr` fields.

## NOTES

Author: Nick
Module: ColorScripts-Enhanced

Cache files are stored in the directory exposed by the module's `CacheDir` variable. A successful build sets the cache file's timestamp to the script's last write time so subsequent runs can skip unchanged scripts.

## RELATED LINKS

[Show-ColorScript](Show-ColorScript.md)
[Clear-ColorScriptCache](Clear-ColorScriptCache.md)
[Get-ColorScriptList](Get-ColorScriptList.md)
[Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
