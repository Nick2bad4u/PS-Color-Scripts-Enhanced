---
external help file: ColorScripts-Enhanced-help.xml
Module Name: ColorScripts-Enhanced
online version: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
schema: 2.0.0
---

# Show-ColorScript

## SYNOPSIS

Displays a colorscript with automatic caching.

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [<CommonParameters>]
```

### Named

```
Show-ColorScript [-Name] <String> [-NoCache] [<CommonParameters>]
```

### List

```
Show-ColorScript [-List] [<CommonParameters>]
```

## DESCRIPTION

Shows a beautiful ANSI colorscript in your terminal. If no name is specified, displays a random script. Uses intelligent caching for 6-19x faster performance.

The first time a colorscript is displayed, it executes normally and the output is cached. Subsequent displays use the cached output for near-instant rendering. Cache is automatically invalidated when the source script is modified.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Displays a random colorscript with caching enabled.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Displays the specified colorscript.

### EXAMPLE 3

```powershell
scs hearts
```

Uses the alias to display the hearts colorscript.

### EXAMPLE 4

```powershell
Show-ColorScript -List
```

Lists all available colorscripts.

### EXAMPLE 5

```powershell
Show-ColorScript -Name arch -NoCache
```

Displays the arch colorscript without using cache.

### EXAMPLE 6

```powershell
Get-ColorScriptList | ForEach-Object { Show-ColorScript -Name $_.BaseName }
```

Display all colorscripts sequentially.

## PARAMETERS

### -Name

The name of the colorscript to display (without .ps1 extension).

```yaml
Type: String
Parameter Sets: Named
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue, ByPropertyName)
Accept wildcard characters: False
```

### -List

Lists all available colorscripts instead of displaying one.

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Random

Explicitly request a random colorscript (default behavior).

```yaml
Type: SwitchParameter
Parameter Sets: Random
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoCache

Bypass cache and execute script directly. Useful for testing or when cache is corrupted.

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

### System.String

You can pipe script names to Show-ColorScript.

## OUTPUTS

### None

This cmdlet displays output directly to the console.

## NOTES

Author: Nick
Module: ColorScripts-Enhanced
Requires: PowerShell 5.1 or later

The caching system provides 6-19x performance improvements for colorscripts.
Cache location: $env:APPDATA\ColorScripts-Enhanced\cache

## RELATED LINKS

[Get-ColorScriptList](Get-ColorScriptList.md)
[Build-ColorScriptCache](Build-ColorScriptCache.md)
[Clear-ColorScriptCache](Clear-ColorScriptCache.md)
[Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
