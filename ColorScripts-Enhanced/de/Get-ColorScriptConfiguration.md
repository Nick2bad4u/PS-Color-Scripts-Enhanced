---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/de/Get-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Ruft die aktuellen Konfigurationseinstellungen des ColorScripts-Enhanced-Moduls ab.

## SYNTAX

```powershell
Get-ColorScriptConfiguration [<CommonParameters>]
```

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

### CommonParameters

Dieses Cmdlet unterstützt die gemeinsamen Parameter: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Weitere Informationen finden Sie unter
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

## ADVANCED USAGE PATTERNS

### Konfigurationsanalyse und Auditing

## Vollständiges Konfigurationsaudit

```powershell
# Umfassende Konfigurationsüberprüfung
$config = Get-ColorScriptConfiguration

[PSCustomObject]@{
    CachePath = $config.Cache.Path
    CacheEnabled = $config.Cache.Enabled
    CacheSize = (Get-ChildItem $config.Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    StartupEnabled = $config.Startup.ProfileAutoShow
    DefaultScript = $config.DefaultScript
} | Format-List
```

## Vergleich mit Standards

```powershell
# Identifizieren von Anpassungen von Standards
$current = Get-ColorScriptConfiguration | ConvertTo-Json

# Export für Vergleich
$current | Out-File "./current-config.json"

# Überprüfen auf Anpassungen
if ($current -ne (Get-Content "./default-config.json")) {
    Write-Host "✓ Benutzerdefinierte Konfiguration erkannt"
}
```

### Umgebungsspezifische Konfiguration

## Umgebungserkennung

```powershell
# Umgebung erkennen und entsprechende Konfiguration melden
$config = Get-ColorScriptConfiguration

$environment = switch ($true) {
    ($env:CI) { "CI/CD" }
    ($env:SSH_CONNECTION) { "SSH Session" }
    ($env:WT_SESSION) { "Windows Terminal" }
    ($env:TERM_PROGRAM) { "$env:TERM_PROGRAM" }
    default { "Local" }
}

Write-Host "Environment: $environment"
Write-Host "Cache: $($config.Cache.Path)"
Write-Host "Startup: $($config.Startup.ProfileAutoShow)"
```

## Multi-Umgebungsverwaltung

```powershell
# Konfiguration über Umgebungen hinweg verfolgen
@(
    [PSCustomObject]@{ Environment = "Local"; Config = Get-ColorScriptConfiguration }
    [PSCustomObject]@{ Environment = "CI"; Config = Invoke-Command -ComputerName ci-server { Get-ColorScriptConfiguration } }
) | ForEach-Object {
    Write-Host "=== $($_.Environment) ==="
    $_.Config | Select-Object -ExpandProperty Cache | Format-Table
}
```

### Konfigurationsvalidierung

## Gesundheitsprüfung

```powershell
# Konfigurationsintegrität validieren
$config = Get-ColorScriptConfiguration

$checks = @{
    CachePathExists = Test-Path $config.Cache.Path
    CachePathWritable = Test-Path $config.Cache.Path -PathType Container
    CacheFilesPresent = (Get-ChildItem $config.Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue).Count -gt 0
}

$checks | ConvertTo-Json | Write-Host
```

## Konfigurationskonsistenz

```powershell
# Überprüfen, ob Konfigurationseinstellungen konsistent sind
$config = Get-ColorScriptConfiguration

$validSettings = @{
    CacheEnabled = $config.Cache.Enabled -is [bool]
    PathIsString = $config.Cache.Path -is [string]
    CachePathNotEmpty = -not [string]::IsNullOrEmpty($config.Cache.Path)
}

if ($validSettings.Values -notcontains $false) {
    Write-Host "✓ Konfiguration ist gültig"
}
```

### Konfigurationssicherung und Wiederherstellung

## Aktuelle Konfiguration sichern

```powershell
# Konfigurationssicherung erstellen
$config = Get-ColorScriptConfiguration
$backup = @{
    Timestamp = Get-Date
    Configuration = $config
    ModuleVersion = (Get-Module ColorScripts-Enhanced | Select-Object -ExpandProperty Version)
}

$backup | ConvertTo-Json | Out-File "./config-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
```

## Konfigurationsmigration

```powershell
# Konfiguration für Migration auf neues System exportieren
$config = Get-ColorScriptConfiguration

$exportConfig = @{
    CachePath = $config.Cache.Path
    Startup = $config.Startup
    Customizations = @{
        # Fügen Sie hier benutzerdefinierte Einstellungen hinzu
    }
}

$exportConfig | ConvertTo-Json | Out-File "./export-config.json" -Encoding UTF8
```

### Konfigurationsberichterstellung

## Konfigurationsbericht

```powershell
# Umfassenden Konfigurationsbericht generieren
$config = Get-ColorScriptConfiguration

$report = @"
# ColorScripts-Enhanced Konfigurationsbericht
Generiert: $(Get-Date)

## Cache-Einstellungen
- Pfad: $($config.Cache.Path)
- Aktiviert: $($config.Cache.Enabled)
- Größe: $([math]::Round((Get-ChildItem $($config.Cache.Path) -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB
- Dateien: $(Get-ChildItem $($config.Cache.Path) -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object | Select-Object -ExpandProperty Count)

## Starteinstellungen
- Profil Auto-Show: $($config.Startup.ProfileAutoShow)
- Standardskript: $($config.DefaultScript)

## Umgebung
- Modulversion: $(Get-Module ColorScripts-Enhanced | Select-Object -ExpandProperty Version)
- PowerShell-Version: $($PSVersionTable.PSVersion)
- OS: $(if ($PSVersionTable.Platform) { $PSVersionTable.Platform } else { "Windows" })
"@

$report | Out-File "./config-report.md" -Encoding UTF8
```

### Überwachung und Drift-Erkennung

## Konfigurationsdrift-Erkennung

```powershell
# Überwachen auf unerwartete Konfigurationsänderungen
$configFile = "$env:APPDATA\ColorScripts-Enhanced\config.json"
$current = Get-ColorScriptConfiguration
$lastKnown = Get-Content $configFile -ErrorAction SilentlyContinue | ConvertFrom-Json

if ($current.Cache.Path -ne $lastKnown.Cache.Path) {
    Write-Warning "Cache path has changed: $($lastKnown.Cache.Path) -> $($current.Cache.Path)"
}
```

## Geplante Konfigurationsaudit

```powershell
# Periodisches Audit-Log erstellen
$config = Get-ColorScriptConfiguration
$snapshot = @{
    Timestamp = Get-Date -Format 'o'
    CachePath = $config.Cache.Path
    CacheSize = (Get-ChildItem $config.Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    ScriptCount = (Get-ColorScriptList -AsObject).Count
}

$snapshot | ConvertTo-Json | Out-File "./audit-log-$(Get-Date -Format 'yyyyMMdd').json" -Append -Encoding UTF8
```

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

- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
