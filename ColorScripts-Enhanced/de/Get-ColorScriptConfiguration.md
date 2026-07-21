---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
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

This command has no aliases.

## DESCRIPTION

`Get-ColorScriptConfiguration` ruft die effektive Modulkonfiguration ab, die verschiedene Aspekte des ColorScripts-Enhanced-Verhaltens steuert. Dies umfasst:

- **Cache-Einstellungen**: Ort, an dem Skriptmetadaten und Indizes für Leistungsoptimierung gespeichert werden
- **Startverhalten**: Flags, die steuern, ob Skripte automatisch beim Start von PowerShell-Sitzungen ausgeführt werden
- **Pfadkonfiguration**: Benutzerdefinierte Skriptverzeichnisse und Suchpfade
- **Anzeigepräferenzen**: Standardformatierungs- und Ausgabeoptionen

Die Konfiguration wird aus mehreren Quellen in der Reihenfolge der Priorität zusammengestellt:

1. Eingebaute Modulstandards (niedrigste Priorität)
2. Persistierte Benutzerüberschreibungen aus der Konfigurationsdatei
3. Sitzungsspezifische Änderungen (höchste Priorität)

Die Konfigurationsdatei befindet sich typischerweise unter `%APPDATA%\ColorScripts-Enhanced\config.json` unter Windows oder `~/.config/ColorScripts-Enhanced/config.json` unter Unix-ähnlichen Systemen.

Die zurückgegebene Hashtabelle ist eine Momentaufnahme des aktuellen Konfigurationszustands und kann sicher inspiziert, geklont oder serialisiert werden, ohne die aktive Konfiguration zu beeinflussen.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Zeigt die aktuelle Konfiguration mit der standardmäßigen Tabellenansicht an, die alle Cache- und Starteinstellungen zeigt.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Serialisiert die Konfiguration in das JSON-Format für Protokollierung, Debugging oder Export in andere Tools.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.Location
```

Ruft die Konfiguration ab und greift direkt auf den Cache-Speicherortpfad aus der Hashtabelle zu.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.Enabled) {
    Write-Host "Startup scripts are enabled"
}
```

Überprüft, ob Starts-Skripte in der aktuellen Konfiguration aktiviert sind.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Zeigt alle Konfigurationseigenschaften in einem detaillierten Listenformat für umfassende Inspektion an.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Cache Path: $($config.Cache.Path)"
Write-Host "Profile Auto-Show: $($config.Startup.ProfileAutoShow)"
Write-Host "Default Script: $($config.Startup.DefaultScript)"
```

Extrahiert und zeigt spezifische Konfigurationseigenschaften für Auditing oder Scripting-Zwecke an.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Custom cache path configured: $($config.Cache.Path)"
} else {
    Write-Host "Using default cache path"
}
```

Bestimmt, ob ein benutzerdefinierter Cache-Pfad konfiguriert ist, im Vergleich zur Verwendung von Modulstandards.

### EXAMPLE 8

```powershell
Export-ColorScriptMetadata | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Sichert die aktuelle Konfiguration in einer JSON-Datei für Archivierung oder Disaster Recovery.

### EXAMPLE 9

```powershell
# Compare current config with defaults
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Review the -WhatIf output to see what would change
```

Vergleicht die aktuelle Konfiguration mit Modulstandards, um benutzerdefinierte Einstellungen zu identifizieren.

### EXAMPLE 10

```powershell
# Monitor configuration changes across sessions
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Erstellt zeitgestempelte Momentaufnahmen der Konfiguration zur Verfolgung von Änderungen im Laufe der Zeit.

## PARAMETERS

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Dieses Cmdlet akzeptiert keine Pipeline-Eingabe.

## OUTPUTS

### System.Collections.Hashtable

Gibt eine verschachtelte Hashtabelle zurück, die die folgende Struktur enthält:

- **Cache** (Hashtable): Cache-bezogene Einstellungen
  - **Location** (String): Pfad zum Cache-Verzeichnis
  - **Enabled** (Boolean): Ob Caching aktiv ist
- **Startup** (Hashtable): Starteinstellungen
  - **Enabled** (Boolean): Ob Skripte beim Sitzungsstart ausgeführt werden
  - **ScriptName** (String): Name des standardmäßigen Starts-Skripts
- **Paths** (Array): Zusätzliche Skriptsuchpfade
- **Display** (Hashtable): Ausgabeformatierungspräferenzen

## NOTES

**Modulinitialisierung**: Die Konfiguration wird automatisch initialisiert, wenn das ColorScripts-Enhanced-Modul geladen wird. Dieses Cmdlet ruft den aktuellen In-Memory-Konfigurationszustand ab.

**Keine Änderungen**: Das Aufrufen dieses Cmdlets ist schreibgeschützt und ändert keine persistierten Einstellungen oder die aktive Konfiguration.

**Thread-Sicherheit**: Die zurückgegebene Hashtabelle ist eine Kopie der Konfiguration, wodurch sie sicher für gleichzeitigen Zugriff und Änderung ist, ohne den internen Zustand des Moduls zu beeinflussen.

**Leistung**: Die Konfigurationsabfrage ist leichtgewichtig und für häufige Aufrufe geeignet, da sie die zwischengespeicherte In-Memory-Konfiguration zurückgibt, anstatt von der Festplatte zu lesen.

**Konfigurationsdateiformat**: Die persistierte Konfiguration verwendet das JSON-Format mit UTF-8-Kodierung. Manuelle Bearbeitung wird unterstützt, aber nicht empfohlen; verwenden Sie stattdessen `Set-ColorScriptConfiguration`.

### Best Practices

- Konfiguration einmal abfragen und das Ergebnis wiederverwenden
- Konfiguration vor der Verwendung von Werten validieren
- Konfiguration auf Drift im Laufe der Zeit überwachen
- Konfigurationssicherungen in Versionskontrolle halten
- Jegliche an der Konfiguration vorgenommenen Anpassungen dokumentieren
- Konfigurationsänderungen zuerst in Nicht-Produktionsumgebungen testen
- Konfigurationsaudit-Logs für Compliance verwenden

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
