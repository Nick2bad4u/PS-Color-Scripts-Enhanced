---
external help file: ColorScripts-Enhanced-help.xml
Module Name: ColorScripts-Enhanced
online version: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
schema: 2.0.0
---

# Build-ColorScriptCache

## SYNOPSIS

Pre-build or refresh colorscript cache files for faster rendering.

## DESCRIPTION

`Build-ColorScriptCache` executes colorscripts in a background PowerShell instance and saves the rendered output using UTF-8 (without BOM). Cached content dramatically speeds up subsequent calls to `Show-ColorScript`. You can target specific scripts by name (wildcards supported) or allow the cmdlet to cache the entire collection (the default behavior, equivalent to specifying `-All`).

By default, the cmdlet displays a concise summary of the caching operation. Use `-PassThru` to return detailed result objects for each script, which you can inspect programmatically for status, standard output, and error streams.

## SYNTAX

### All

```
Build-ColorScriptCache [-All] [-Force] [-PassThru] [<CommonParameters>]
```

### Named

```
Build-ColorScriptCache [-Name <String[]>] [-Force] [-PassThru] [<CommonParameters>]
```

## EXAMPLES

### EXAMPLE 1

```powershell
Build-ColorScriptCache
```

Warm the cache for every script that ships with the module. This is equivalent to explicitly providing `-All`.

### EXAMPLE 2

```powershell
Build-ColorScriptCache -Name bars, 'aurora-*'
```

Cache a mix of exact and wildcard matches. Each matching script generates a result record.

### EXAMPLE 3

```powershell
Build-ColorScriptCache -Name mandelbrot-zoom -Force -PassThru | Format-List
```

Force a rebuild even if the cache is newer than the source script and examine the detailed result objects.

### EXAMPLE 4

```powershell
Build-ColorScriptCache -All
```

Cache all scripts and display a concise summary (default behavior without `-PassThru`).

## PARAMETERS

### -Name

One or more script names to cache. Supports wildcards. When this parameter is omitted, the cmdlet caches every available script by default (unless `-All` is explicitly set to `$false`).

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

Cache every available script. This switch is optional because the cmdlet already defaults to caching everything when no names are supplied.

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

### -PassThru

Return detailed result objects for each cache operation. By default, the cmdlet displays a concise summary instead of returning objects.

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

When `-PassThru` is specified, returns a record per processed script containing `Name`, `Status`, `CacheFile`, `ExitCode`, `StdOut`, and `StdErr` fields. Without `-PassThru`, displays a concise summary to the console.

## NOTES

Author: Nick
Module: ColorScripts-Enhanced

Cache files are stored in the directory exposed by the module's `CacheDir` variable. A successful build sets the cache file's timestamp to the script's last write time so subsequent runs can skip unchanged scripts.

## RELATED LINKS

[Show-ColorScript](Show-ColorScript.md)
[Clear-ColorScriptCache](Clear-ColorScriptCache.md)
[Get-ColorScriptList](Get-ColorScriptList.md)
[Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
