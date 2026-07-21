---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Setzt die ColorScripts-Enhanced-Konfiguration auf Standardwerte zurück.

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

Stellt die ColorScripts-Enhanced-Konfigurationssettings auf ihre Standardwerte wieder her. Dieses Cmdlet entfernt alle Benutzeranpassungen und bringt das Modul in seinen ursprünglichen Konfigurationszustand zurück.

Zurücksetzungen umfassen:

- Cache-Pfad-Einstellungen
- Leistungspräferenzen
- Anzeigeoptionen
- Modulverhalten-Einstellungen

Dieses Cmdlet ist nützlich, wenn:

- Die Konfiguration beschädigt wird
- Sie mit Standardeinstellungen neu beginnen möchten
- Probleme im Zusammenhang mit der Konfiguration behoben werden
- Das Modul für saubere Tests vorbereitet wird

Die Zurücksetzungsoperation erfordert standardmäßig eine Bestätigung, um versehentlichen Datenverlust zu verhindern.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration
```

Setzt alle Konfigurationseinstellungen mit Bestätigungsaufforderung auf Standardwerte zurück.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Setzt die Konfiguration ohne Bestätigungsaufforderung zurück.

### EXAMPLE 3

```powershell
Reset-ColorScriptConfiguration -WhatIf
```

Zeigt, welche Konfigurationsänderungen vorgenommen würden, ohne sie anzuwenden.

### EXAMPLE 4

```powershell
# Zurücksetzen und überprüfen
Reset-ColorScriptConfiguration
Get-ColorScriptConfiguration
```

Setzt die Konfiguration zurück und zeigt die neuen Standardeinstellungen an.

## PARAMETERS

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

Return the updated configuration object after the reset completes.

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

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
