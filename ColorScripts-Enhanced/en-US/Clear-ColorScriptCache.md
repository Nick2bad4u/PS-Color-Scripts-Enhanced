---
external help file: ColorScripts-Enhanced-help.xml
Module Name: ColorScripts-Enhanced
online version: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
schema: 2.0.0
---

# Clear-ColorScriptCache

## SYNOPSIS
Clears the colorscript cache.

## SYNTAX

### All
```
Clear-ColorScriptCache [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Named
```
Clear-ColorScriptCache [-Name] <String[]> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Removes cached colorscript output files. Use this if you want to force regeneration of all caches or if cache becomes corrupted.

This command supports -WhatIf and -Confirm for safe cache deletion.

## EXAMPLES

### EXAMPLE 1
```powershell
Clear-ColorScriptCache -All
```
Removes all cache files with confirmation prompt.

### EXAMPLE 2
```powershell
Clear-ColorScriptCache -Name "mandelbrot-zoom"
```
Removes cache for a specific script.

### EXAMPLE 3
```powershell
Clear-ColorScriptCache -All -Confirm:$false
```
Removes all cache files without confirmation.

### EXAMPLE 4
```powershell
Clear-ColorScriptCache -Name hearts,bars,arch
```
Clears cache for multiple specific scripts.

### EXAMPLE 5
```powershell
Clear-ColorScriptCache -All -WhatIf
```
Shows what would be deleted without actually deleting.

## PARAMETERS

### -Name
Clear cache for specific script(s) only. Accepts multiple script names.

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
Clear all cache files.

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

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: True
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
This cmdlet displays status messages but does not produce pipeline output.

## NOTES
Author: Nick
Module: ColorScripts-Enhanced

Cache will be automatically regenerated on next Show-ColorScript execution.
Cache location: $env:APPDATA\ColorScripts-Enhanced\cache

## RELATED LINKS

[Show-ColorScript](Show-ColorScript.md)
[Build-ColorScriptCache](Build-ColorScriptCache.md)
[Get-ColorScriptList](Get-ColorScriptList.md)
[Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
