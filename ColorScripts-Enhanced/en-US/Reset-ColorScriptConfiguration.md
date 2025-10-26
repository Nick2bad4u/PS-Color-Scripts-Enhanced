---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Restore the ColorScripts-Enhanced configuration to its default values.

## SYNTAX

### Default (Default)

```
Reset-ColorScriptConfiguration [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

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
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -PassThru

Return the updated configuration object after the reset completes.

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

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### None

This cmdlet does not accept pipeline input.

## OUTPUTS

### System.Collections.Hashtable

Returned when `-PassThru` is specified.

## NOTES

The configuration file is stored under the directory resolved by `Get-ColorScriptConfiguration`. Environment variable `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` overrides the default location if set.

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
