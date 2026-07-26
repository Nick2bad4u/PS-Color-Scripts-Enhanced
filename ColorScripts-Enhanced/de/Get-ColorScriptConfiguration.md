---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Ruft die aktuellen Konfigurationseinstellungen des ColorScripts-Enhanced-Moduls ab.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

Dieser Befehl hat keine Aliase.

## DESCRIPTION

`Get-ColorScriptConfiguration` gibt eine Kopie der effektiven Modulkonfiguration zurück. Das aktuelle Schema enthält:

- **Cache-Einstellungen**: Das konfigurierte außer Kraft gesetzte und aufgelöste effektive Cache-Verzeichnis
- **Startverhalten**: `AutoShowOnImport`, `ProfileAutoShow` und `DefaultScript`

Die Konfiguration wird aus mehreren Quellen in der Reihenfolge ihrer Priorität zusammengestellt:

1. Standardeinstellungen des integrierten Moduls (niedrigste Priorität)
2. Persistente Benutzerüberschreibungen aus der Konfigurationsdatei
3. `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` für den zurückgegebenen effektiven Cache-Pfad

Die Konfigurationsdatei befindet sich normalerweise unter `%APPDATA%\ColorScripts-Enhanced\config.json` unter Windows oder unter `~/.config/ColorScripts-Enhanced/config.json` auf Unix-ähnlichen Systemen.

Die zurückgegebene Hashtabelle ist eine Momentaufnahme des aktuellen Konfigurationsstatus und kann sicher überprüft, geklont oder serialisiert werden, ohne die aktive Konfiguration zu beeinträchtigen.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Zeigt die aktuelle Konfiguration in der Standardtabellenansicht an und zeigt alle Cache- und Starteinstellungen an.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Serialisiert die Konfiguration zum Protokollieren, Debuggen oder Exportieren in andere Tools in das JSON-Format.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.EffectivePath
```

Ruft das aufgelöste Cache-Verzeichnis ab. `Cache.Path` bleibt die optionale, vom Benutzer konfigurierte Überschreibung;
`Cache.EffectivePath` zeigt das Verzeichnis an, das das Modul nach den Plattformstandards und tatsächlich verwendet
Umgebungsüberschreibungen werden angewendet.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.AutoShowOnImport) {
    Write-Host "Startskripte sind aktiviert"
}
```

Überprüft, ob Startskripte in der aktuellen Konfiguration aktiviert sind.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Zeigt alle Konfigurationseigenschaften in einem detaillierten Listenformat für eine umfassende Überprüfung an.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Cachepfad: $($config.Cache.Path)"
Write-Host "Automatische Profilanzeige: $($config.Startup.ProfileAutoShow)"
Write-Host "Standardskript: $($config.Startup.DefaultScript)"
```

Extrahiert und zeigt bestimmte Konfigurationseigenschaften für Überwachungs- oder Skripterstellungszwecke an.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Benutzerdefinierter Cachepfad konfiguriert: $($config.Cache.Path)"
} else {
    Write-Host "Der Standard-Cachepfad wird verwendet"
}

Write-Host "Effektiver Cachepfad: $($config.Cache.EffectivePath)"
```

Bestimmt, ob ein benutzerdefinierter Cache-Pfad konfiguriert ist oder Modulstandards verwendet.

### EXAMPLE 8

```powershell
$config = Get-ColorScriptConfiguration
$config | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Sichert die aktuelle Konfiguration zur Archivierung oder Notfallwiederherstellung in einer JSON-Datei.

### EXAMPLE 9

```powershell
# Vergleichen Sie die aktuelle Konfiguration mit den Standardeinstellungen
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Überprüfen Sie die -WhatIf-Ausgabe, um zu sehen, was sich ändern würde
```

Vergleicht die aktuelle Konfiguration mit den Modulstandards, um benutzerdefinierte Einstellungen zu identifizieren.

### EXAMPLE 10

```powershell
# Überwachen Sie Konfigurationsänderungen sitzungsübergreifend
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Erstellt zeitgestempelte Snapshots der Konfiguration, um Änderungen im Laufe der Zeit zu verfolgen.

## PARAMETERS

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

### CommonParameters

Dieses Cmdlet unterstützt die allgemeinen Parameter:
Weitere Informationen finden Sie unter
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Dieses Cmdlet akzeptiert keine Pipeline-Eingaben.

## OUTPUTS

### System.Collections.Hashtable

Gibt eine verschachtelte Hashtabelle zurück, die die folgende Struktur enthält:

- **Cache** (Hashtable): Cache-bezogene Einstellungen
  – **Path** (String): Optionale Überschreibung des persistenten Cache-Pfads
  - **EffectivePath** (String): Aufgelöstes Cache-Verzeichnis, das derzeit vom Modul verwendet wird
- **Startup** (Hashtable): Einstellungen für das Startverhalten
  - **AutoShowOnImport** (Boolean): Ob der Import das Startanzeigeverhalten aufruft
  - **ProfileAutoShow** (Boolean): Standardauswahl für die automatische Anzeige für verwaltete Profilblöcke
- **DefaultScript** (String): Optionaler benannter Startup Farbskript

## NOTES

**Modulinitialisierung**: Die Konfiguration wird automatisch initialisiert, wenn das ColorScripts-Enhanced-Modul geladen wird. Dieses Cmdlet ruft den aktuellen In-Memory-Konfigurationsstatus ab.

**Keine Änderungen**: Der Aufruf dieses Cmdlets ist schreibgeschützt und ändert keine beibehaltenen Einstellungen oder die aktive Konfiguration.

**Thread-Sicherheit**: Die zurückgegebene Hashtabelle ist eine Kopie der Konfiguration und macht sie für gleichzeitigen Zugriff und Änderungen sicher, ohne den internen Status des Moduls zu beeinträchtigen.

**Performance**: Der Konfigurationsabruf ist leichtgewichtig und eignet sich für häufige Aufrufe, da er die zwischengespeicherte Konfiguration im Arbeitsspeicher zurückgibt und nicht von der Festplatte liest.

**Konfigurationsdateiformat**: Die persistente Konfiguration verwendet das JSON-Format mit der UTF-8-Kodierung. Manuelle Bearbeitung wird unterstützt, aber nicht empfohlen; Verwenden Sie stattdessen `Set-ColorScriptConfiguration`.

### Bewährte Verfahren

- Konfiguration einmal abfragen und das Ergebnis wiederverwenden
– Überprüfen Sie die Konfiguration, bevor Sie Werte verwenden
- Überwachen Sie die Konfiguration auf Abweichungen im Laufe der Zeit
- Bewahren Sie Backups nur dort auf, wo sie keine maschinenspezifischen Pfade oder privaten Daten offenlegen können
- Dokumentieren Sie alle an der Konfiguration vorgenommenen Anpassungen
- Testen Sie Konfigurationsänderungen zunächst außerhalb der Produktion
- Verwenden Sie Konfigurations-Audit-Protokolle zur Einhaltung der Compliance

## RELATED LINKS

- [Onlineversion](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

