---
external help file: ColorScripts-Enhanced-help.xml
Module Name: ColorScripts-Enhanced
online version: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
schema: 2.0.0
---

# Build-ColorScriptCache

## SYNOPSIS

Builds cache files for colorscripts.

## SYNTAX

### All

```
Build-ColorScriptCache [-All] [-Force] [<CommonParameters>]
```

### Named

```
Build-ColorScriptCache [-Name] <String[]> [-Force] [<CommonParameters>]
```

## DESCRIPTION

Pre-generates cache files for faster colorscript loading. Can cache all scripts or specific ones.

This command is useful for:

- Initial setup to cache all scripts at once
- Rebuilding cache after module updates
- Pre-caching favorite scripts for maximum performance

Cache files are stored in $env:APPDATA\ColorScripts-Enhanced\cache

## EXAMPLES

### EXAMPLE 1

```powershell
Build-ColorScriptCache -All
```

Caches all available colorscripts. This may take a few minutes initially.

### EXAMPLE 2

```powershell
Build-ColorScriptCache -Name "bars","hearts","arch"
```

Caches only the specified colorscripts.

### EXAMPLE 3

```powershell
Build-ColorScriptCache -All -Force
```

Rebuilds cache for all scripts, even if valid cache already exists.

### EXAMPLE 4

```powershell
Get-ChildItem "$PSScriptRoot\Scripts" -Filter *.ps1 |
    Select-Object -First 10 |
    ForEach-Object { Build-ColorScriptCache -Name $_.BaseName }
```

Cache the first 10 scripts found.

### EXAMPLE 5

```powershell
# Cache all scripts containing "rainbow" in the name
Get-ColorScriptList | Out-String |
    Select-String "rainbow" |
    ForEach-Object {
        $name = $_.Line.Trim()
        Build-ColorScriptCache -Name $name
    }
```

## PARAMETERS

### -Name

Specific script name(s) to cache. Accepts multiple names.

```yaml
Type: String[]
Parameter Sets: Named
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue, ByPropertyName)
Accept wildcard characters: False
```

### -All

Cache all available colorscripts.

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

Force rebuild even if valid cache already exists.

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

You can pipe script names to this cmdlet.

## OUTPUTS

### None

This cmdlet displays progress information but does not produce pipeline output.

## NOTES

Author: Nick
Module: ColorScripts-Enhanced

Building cache for all 185+ scripts may take 3-5 minutes on first run.
Subsequent cache builds with -Force are faster as scripts are already validated.

Cache files are automatically validated against source script modification times.

## RELATED LINKS

[Show-ColorScript](Show-ColorScript.md)
[Clear-ColorScriptCache](Clear-ColorScriptCache.md)
[Get-ColorScriptList](Get-ColorScriptList.md)
[Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
