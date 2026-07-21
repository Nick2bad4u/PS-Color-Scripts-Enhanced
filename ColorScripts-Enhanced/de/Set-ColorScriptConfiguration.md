---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Ändert die Konfigurationseinstellungen von ColorScripts-Enhanced.

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

Aktualisiert die Konfigurationseinstellungen von ColorScripts-Enhanced mit persistentem Speicher. Dieses Cmdlet ermöglicht die Anpassung des Modulverhaltens durch benutzerkonfigurierbare Optionen.

Konfigurierbare Einstellungen umfassen:

- Cache-Verzeichnis-Standort
- Leistungsoptimierungseinstellungen
- Standard-Anzeigeverhalten
- Modul-Betriebseinstellungen

Änderungen werden automatisch in benutzerspezifischen Konfigurationsdateien gespeichert und bleiben über PowerShell-Sitzungen hinweg erhalten. Verwenden Sie Get-ColorScriptConfiguration, um die aktuellen Einstellungen anzuzeigen.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath "C:\MyCache"
```

Legt einen benutzerdefinierten Cache-Verzeichnispfad fest.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -CachePath $env:TEMP
```

Verwendet das System-Temp-Verzeichnis für die Cache-Speicherung.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "~/.colorscript-cache"
```

Legt den Cache-Pfad mit Unix-Style-Home-Verzeichnis-Notation fest.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -WhatIf
```

Zeigt, welche Konfigurationsänderungen vorgenommen würden, ohne sie anzuwenden.

### EXAMPLE 5

```powershell
# Backup current config, modify, then restore if needed
$currentConfig = Get-ColorScriptConfiguration
Set-ColorScriptConfiguration -CachePath "D:\Cache"
# ... test new configuration ...
# Set-ColorScriptConfiguration -CachePath $currentConfig.CachePath
```

Demonstriert die Sicherung und Wiederherstellung der Konfiguration.

## PARAMETERS

### -AutoShowOnImport

Enable or disable automatic rendering of a colorscript when the module is imported.
When enabled (`$true`), a colorscript displays immediately upon module import, providing instant visual feedback.
When disabled (`$false`), scripts only display when explicitly invoked.
If not specified, the existing setting remains unchanged.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -CachePath

Gibt den Verzeichnispfad an, in dem die Cache-Dateien von ColorScripts gespeichert werden.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Fordert Sie zur Bestätigung auf, bevor das Cmdlet ausgeführt wird.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -DefaultScript

Sets or clears the default colorscript name used by profile helpers, auto-show features, and when no script is explicitly specified in commands.
This should match the base name of a script file without extension (e.g., `'bars'`, not `'bars.ps1'`).

Provide an empty string (`''`) to remove the stored default, reverting to module-level default behavior (typically random selection).
When this parameter is omitted, the current default script setting is unchanged.

The specified script must exist in the module's script directory to be used successfully.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -h

Zeigt die ausführliche Hilfe für diesen Befehl an, ohne den Vorgang auszuführen.

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

### -PassThru

Returns the updated configuration object after making changes.
Without this switch, the cmdlet operates silently (no output).
The returned object has the same structure as `Get-ColorScriptConfiguration` and can be inspected, stored, or piped to other cmdlets for further processing.

Useful for verification, logging, or chaining configuration commands.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -ProfileAutoShow

Controls whether profile snippets generated by `Add-ColorScriptProfile` include an automatic `Show-ColorScript` invocation.
When `$true`, the profile code will display a colorscript on every shell startup.
When `$false`, the profile will load the module but not auto-display scripts.

This setting only affects newly generated profile code; existing profile modifications are not automatically updated.
Omitting this parameter leaves the current setting unchanged.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Zeigt, was passieren würde, wenn das Cmdlet ausgeführt wird. Das Cmdlet wird nicht ausgeführt.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

Dieses Cmdlet akzeptiert keine Eingabe aus der Pipeline.

## OUTPUTS

### None (2)

Dieses Cmdlet gibt keine Ausgabe an die Pipeline zurück.

## NOTES

**Autor:** Nick
**Modul:** ColorScripts-Enhanced
**Erfordert:** PowerShell 5.1 oder höher

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)

