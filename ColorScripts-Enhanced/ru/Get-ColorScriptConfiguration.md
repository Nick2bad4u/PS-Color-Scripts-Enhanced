---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: ru
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Retrieves the current ColorScripts-Enhanced module configuration settings.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

`Get-ColorScriptConfiguration` retrieves the effective module configuration, which controls various aspects of ColorScripts-Enhanced behavior. This includes:

- **Cache Settings**: Location where script metadata and indexes are stored for performance optimization
- **Startup Behavior**: Flags that control whether scripts run automatically when PowerShell sessions start
- **Path Configuration**: Custom script directories and search paths
- **Display Preferences**: Default formatting and output options

The configuration is assembled from multiple sources in order of precedence:

1. Built-in module defaults (lowest priority)
2. Persisted user overrides from the configuration file
3. Session-specific modifications (highest priority)

The configuration file is typically located at `%APPDATA%\ColorScripts-Enhanced\config.json` on Windows or `~/.config/ColorScripts-Enhanced/config.json` on Unix-like systems.

The returned hashtable is a snapshot of the current configuration state and can be safely inspected, cloned, or serialized without affecting the active configuration.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Displays the current configuration using the default table view, showing all cache and startup settings.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Serializes the configuration to JSON format for logging, debugging, or exporting to other tools.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.Location
```

Retrieves the configuration and accesses the cache location path directly from the hashtable.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.Enabled) {
    Write-Host "Startup scripts are enabled"
}
```

Checks whether startup scripts are enabled in the current configuration.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Displays all configuration properties in a detailed list format for comprehensive inspection.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Cache Path: $($config.Cache.Path)"
Write-Host "Profile Auto-Show: $($config.Startup.ProfileAutoShow)"
Write-Host "Default Script: $($config.Startup.DefaultScript)"
```

Extracts and displays specific configuration properties for auditing or scripting purposes.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Custom cache path configured: $($config.Cache.Path)"
} else {
    Write-Host "Using default cache path"
}
```

Determines whether a custom cache path is configured vs using module defaults.

### EXAMPLE 8

```powershell
Export-ColorScriptMetadata | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Backs up the current configuration to a JSON file for archival or disaster recovery.

### EXAMPLE 9

```powershell
# Compare current config with defaults
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Review the -WhatIf output to see what would change
```

Compares current configuration with module defaults to identify custom settings.

### EXAMPLE 10

```powershell
# Monitor configuration changes across sessions
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Creates timestamped snapshots of configuration for tracking changes over time.

## PARAMETERS

### -h

Показывает подробную справку по команде, не выполняя операцию.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- help
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

Returns a nested hashtable containing the following structure:

- **Cache** (Hashtable): Cache-related settings
  - **Location** (String): Path to the cache directory
  - **Enabled** (Boolean): Whether caching is active
- **Startup** (Hashtable): Startup behavior settings
  - **Enabled** (Boolean): Whether scripts run on session start
  - **ScriptName** (String): Name of the default startup script
- **Paths** (Array): Additional script search paths
- **Display** (Hashtable): Output formatting preferences

## NOTES

**Module Initialization**: The configuration is initialized automatically when the ColorScripts-Enhanced module loads. This cmdlet retrieves the current in-memory configuration state.

**No Modifications**: Calling this cmdlet is read-only and does not modify any persisted settings or the active configuration.

**Thread Safety**: The returned hashtable is a copy of the configuration, making it safe for concurrent access and modification without affecting the module's internal state.

**Performance**: Configuration retrieval is lightweight and suitable for frequent calls, as it returns the cached in-memory configuration rather than reading from disk.

**Configuration File Format**: The persisted configuration uses JSON format with UTF-8 encoding. Manual editing is supported but not recommended; use `Set-ColorScriptConfiguration` instead.

### Best Practices

- Query configuration once and reuse the result
- Validate configuration before using values
- Monitor configuration for drift over time
- Keep configuration backups in version control
- Document any customizations made to configuration
- Test configuration changes in non-production first
- Use configuration audit logs for compliance

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

