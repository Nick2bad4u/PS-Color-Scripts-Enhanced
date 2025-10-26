---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Return the current ColorScripts-Enhanced configuration values.

## SYNTAX

### Default (Default)

```
Get-ColorScriptConfiguration [<CommonParameters>]
```

### __AllParameterSets

```
Get-ColorScriptConfiguration [<CommonParameters>]
```

## DESCRIPTION

`Get-ColorScriptConfiguration` retrieves the effective module configuration, including the cache location and startup behaviour flags. The configuration is assembled from built-in defaults and any persisted overrides stored in the configuration file (typically `%APPDATA%\ColorScripts-Enhanced\config.json`).

The returned hashtable is safe to inspect or clone for advanced scripting scenarios.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Displays the current configuration using the default table view.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Serialises the configuration to JSON for logging or exporting.

## PARAMETERS

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

You cannot pipe objects to this cmdlet.

## OUTPUTS

### System.Collections.Hashtable

Returns a nested hashtable that represents the cache and startup configuration.

## NOTES

The configuration is initialised automatically when the module loads. Calling this cmdlet does not modify any persisted settings.

## RELATED LINKS

- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Show-ColorScript](Show-ColorScript.md)
