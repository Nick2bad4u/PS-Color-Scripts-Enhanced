---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Stellen Sie die ColorScripts-Enhanced-Konfiguration auf ihre Standardwerte zurück.

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Dieser Befehl hat keine Aliase.

## DESCRIPTION

`Reset-ColorScriptConfiguration` ersetzt die persistente Konfiguration durch die integrierten Standardeinstellungen und setzt den In-Memory-Cache-Status des Moduls zurück. Bei der Ausführung dieses Cmdlets:

– Löscht die konfigurierte Cache-Pfad-Überschreibung, sodass der effektive Plattformstandard verwendet wird
- Stellt `AutoShowOnImport`, `ProfileAutoShow` und `DefaultScript` wieder her
– Schreibt die Standardkonfiguration nach `config.json`
– Löscht den In-Memory-Cache/Konfigurationsstatus, sodass nachfolgende Vorgänge die zurückgesetzten Werte verwenden

Dieses Cmdlet unterstützt die Parameter `-WhatIf` und `-Confirm`, da es einen destruktiven Vorgang ausführt, indem es die Konfigurationsdatei überschreibt. Der Rücksetzvorgang kann nicht automatisch rückgängig gemacht werden, daher sollten Benutzer in Erwägung ziehen, ihre aktuelle Konfiguration mit `Get-ColorScriptConfiguration` zu sichern, bevor sie fortfahren.

Verwenden Sie den Parameter `-PassThru`, um die neu wiederhergestellten Standardeinstellungen sofort nach Abschluss des Zurücksetzens zu überprüfen.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Setzt die Konfiguration zurück, ohne zur Bestätigung aufzufordern. Dies ist bei automatisierten Skripten nützlich oder wenn Sie sicher sind, dass die Standardeinstellungen wiederhergestellt werden sollen.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

Setzt die Konfiguration zurück und gibt die resultierende Hashtabelle zur Überprüfung zurück, sodass Sie die Standardwerte überprüfen können.

### EXAMPLE 3

```powershell
# Sichern Sie die aktuelle Konfiguration vor dem Zurücksetzen
$backup = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
```

Verwendet `-WhatIf`, um eine Vorschau des Rücksetzvorgangs anzuzeigen, ohne ihn tatsächlich auszuführen, nachdem die aktuelle Konfiguration gesichert wurde.

### EXAMPLE 4

```powershell
Reset-ColorScriptConfiguration -Verbose
```

Setzt die Konfiguration mit ausführlicher Ausgabe zurück, um detaillierte Informationen zum Vorgang anzuzeigen.

### EXAMPLE 5

```powershell
# Setzen Sie die Konfiguration zurück und leeren Sie den Cache, um einen vollständigen Werksreset durchzuführen
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "Das Modul wurde auf die Werkseinstellungen zurückgesetzt!"
```

Führt einen vollständigen Werksreset durch, einschließlich Konfiguration, Cache und Neuaufbau des Caches.

### EXAMPLE 6

```powershell
# Überprüfen Sie, ob das Zurücksetzen erfolgreich war
$config = Reset-ColorScriptConfiguration -PassThru
if ($null -eq $config.Cache.Path -and $config.Cache.EffectivePath) {
    Write-Host "Die Konfiguration wurde auf den Plattformstandard zurückgesetzt"
} else {
    Write-Host "Konfiguration zurückgesetzt; benutzerdefinierter Pfad wird verwendet: $($config.Cache.Path)"
}
```

Setzt zurück und überprüft, ob die persistente Cache-Überschreibung leer ist und ein wirksamer Plattformpfad verfügbar ist.

## PARAMETERS

### -Confirm

Fordert Sie zur Bestätigung auf, bevor Sie das Cmdlet ausführen.

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

Zeigt detaillierte Hilfe für diesen Befehl an, ohne den Vorgang auszuführen.

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

Geben Sie das aktualisierte Konfigurationsobjekt zurück, nachdem das Zurücksetzen abgeschlossen ist.

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

Zeigt, was passieren würde, wenn das Cmdlet ausgeführt wird, ohne dass der Rücksetzvorgang tatsächlich ausgeführt wird.

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

Dieses Cmdlet unterstützt die allgemeinen Parameter:
Weitere Informationen finden Sie unter
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Dieses Cmdlet akzeptiert keine Pipeline-Eingaben.

## OUTPUTS

### System.Collections.Hashtable

Wird zurückgegeben, wenn `-PassThru` angegeben wird.

## NOTES

Die Konfigurationsdatei wird in dem durch `Get-ColorScriptConfiguration` aufgelösten Verzeichnis gespeichert. Standardmäßig ist dieser Speicherort plattformspezifisch:

- **Windows**: `$env:APPDATA\ColorScripts-Enhanced`
- **Linux/macOS**: `$HOME/.config/ColorScripts-Enhanced`

Die Umgebungsvariable `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` kann den Standardspeicherort überschreiben, wenn sie vor dem Modulimport festgelegt wird.

## RELATED LINKS

- [Onlineversion](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)

