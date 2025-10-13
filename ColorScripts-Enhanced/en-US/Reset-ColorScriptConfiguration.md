---
external help file: ColorScripts-Enhanced-help.xml
Module Name: ColorScripts-Enhanced
online version: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
schema: 2.0.0
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Restore the ColorScripts-Enhanced configuration to its default values.

## SYNTAX

```
Reset-ColorScriptConfiguration [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

`Reset-ColorScriptConfiguration` clears all persisted configuration overrides and restores the module defaults. The configuration file is rewritten, the cache path is reset to the platform default, and startup flags return to their original values. This cmdlet supports `-WhatIf` and `-Confirm` because the operation overwrites the configuration file.

Use `-PassThru` to immediately see the newly restored settings.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Resets the configuration without prompting for confirmation.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

Resets the configuration and returns the resulting hashtable for inspection.

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru

Return the updated configuration object after the reset completes.

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
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, and -WarningAction. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

This cmdlet does not accept pipeline input.

## OUTPUTS

### System.Collections.Hashtable

Returned when `-PassThru` is specified.

## NOTES

The configuration file is stored under the directory resolved by `Get-ColorScriptConfiguration`. Environment variable `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` overrides the default location if set.

## RELATED LINKS

[Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
[Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
