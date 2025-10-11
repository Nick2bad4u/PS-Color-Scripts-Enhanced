---
external help file: ColorScripts-Enhanced-help.xml
Module Name: ColorScripts-Enhanced
online version: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
schema: 2.0.0
---

# Clear-ColorScriptCache

## SYNOPSIS

Remove cached colorscript output files.

## SYNTAX

### All

```
Clear-ColorScriptCache [-All] [-Path <String>] [-DryRun] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Named

```
Clear-ColorScriptCache [-Name <String[]>] [-Path <String>] [-DryRun] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

`Clear-ColorScriptCache` deletes cached output either selectively (`-Name`) or wholesale (`-All`). Wildcard patterns are supported and unmatched names report a `Missing` status in the results. Use `-DryRun` to preview the actions without touching the filesystem, or `-Path` to target an alternate cache directory (useful for CI or custom cache roots).

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

Remove every cache file without prompting.

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

Preview which aurora-themed caches would be removed.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name bars -Path $env:TEMP -Confirm:$false
```

Clean a custom cache directory (for example when using `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`).

## PARAMETERS

### -Name

Script names (wildcards supported) whose caches should be cleared. Mutually exclusive with `-All`.

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

Remove every cache file in the target directory.

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

### -Path

Custom cache directory to operate on. Defaults to the module's cache path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DryRun

Emit the actions that would be taken without deleting any files.

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

You can pipe script names or objects with a `Name` property to this cmdlet.

## OUTPUTS

### System.Object[]

Returns status records for each processed cache file, including the `Status`, `CacheFile`, and message text.

## NOTES

Author: Nick
Module: ColorScripts-Enhanced

Cache files are regenerated automatically the next time `Show-ColorScript` runs. The default cache path is exposed via the module's `CacheDir` variable.

## RELATED LINKS

[Show-ColorScript](Show-ColorScript.md)
[Build-ColorScriptCache](Build-ColorScriptCache.md)
[Get-ColorScriptList](Get-ColorScriptList.md)
[Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
