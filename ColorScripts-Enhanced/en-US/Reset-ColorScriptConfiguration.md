---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/en-US/Reset-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Restore the ColorScripts-Enhanced configuration to its default values.

## SYNTAX

### Default (Default)

```text
Reset-ColorScriptConfiguration [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### \_\_AllParameterSets

```text
Reset-ColorScriptConfiguration [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

`Reset-ColorScriptConfiguration` clears all persisted configuration overrides and restores the module to its factory defaults. When executed, this cmdlet:

- Removes all custom configuration settings from the configuration file
- Resets the cache path to the platform-specific default location
- Restores all startup flags (RunOnStartup, RandomOnStartup, etc.) to their original values
- Preserves the configuration file structure while clearing user customizations

This cmdlet supports `-WhatIf` and `-Confirm` parameters because it performs a destructive operation by overwriting the configuration file. The reset operation cannot be undone automatically, so users should consider backing up their current configuration using `Get-ColorScriptConfiguration` before proceeding.

Use the `-PassThru` parameter to immediately inspect the newly restored default settings after the reset completes.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Resets the configuration without prompting for confirmation. This is useful in automated scripts or when you're certain about resetting to defaults.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

Resets the configuration and returns the resulting hashtable for inspection, allowing you to verify the default values.

### EXAMPLE 3

```powershell
# Backup current configuration before resetting
$backup = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
```

Uses `-WhatIf` to preview the reset operation without actually executing it, after backing up the current configuration.

### EXAMPLE 4

```powershell
Reset-ColorScriptConfiguration -Verbose
```

Resets the configuration with verbose output to see detailed information about the operation.

### EXAMPLE 5

```powershell
# Reset configuration and clear cache for complete factory reset
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "Module reset to factory defaults!"
```

Performs a complete factory reset including configuration, cache, and rebuilding the cache.

### EXAMPLE 6

```powershell
# Verify reset was successful
$config = Reset-ColorScriptConfiguration -PassThru
if ($config.Cache.Path -match "AppData|\.config") {
    Write-Host "Configuration successfully reset to platform default"
} else {
    Write-Host "Configuration reset but using custom path: $($config.Cache.Path)"
}
```

Resets and verifies that the configuration was restored to defaults by checking the cache path.

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
HelpMessage: ""
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
HelpMessage: ""
```

### -WhatIf

Shows what would happen if the cmdlet runs without actually executing the reset operation.

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
HelpMessage: ""
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

The configuration file is stored under the directory resolved by `Get-ColorScriptConfiguration`. By default, this location is platform-specific:

- **Windows**: `$env:LOCALAPPDATA\ColorScripts-Enhanced`
- **Linux/macOS**: `$HOME/.config/ColorScripts-Enhanced`

The environment variable `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` can override the default location if set before module import.

## Important Considerations

- The reset operation is immediate and cannot be automatically undone
- Any custom color script paths, cache locations, or startup behaviors will be lost
- Consider using `Get-ColorScriptConfiguration` to export your current settings before resetting
- The module must have write permissions to the configuration directory
- Other PowerShell sessions using the module will see the changes after their next configuration reload

## Default Values Restored

- CachePath: Platform-specific default cache directory
- RunOnStartup: `$false`
- RandomOnStartup: `$false`
- ScriptOnStartup: Empty string
- CustomScriptPaths: Empty array

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
