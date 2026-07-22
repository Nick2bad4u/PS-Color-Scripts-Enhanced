---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Export-ColorScriptMetadata
---

# Export-ColorScriptMetadata

## SYNOPSIS

Exportiert umfassende Metadaten für alle Farbskripte in das JSON-Format oder gibt strukturierte Objekte an die Pipeline aus.

## SYNTAX

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-h] [-IncludeFileInfo] [-IncludeCacheInfo]
 [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Dieser Befehl hat keine Aliase.

## DESCRIPTION

Das Cmdlet `Export-ColorScriptMetadata` stellt ein umfassendes Inventar aller Farbskripte im Katalog des Moduls zusammen und generiert einen strukturierten Datensatz, der jeden Eintrag beschreibt. Diese Metadaten umfassen wesentliche Informationen wie Skriptnamen, Kategorien, Tags und optionale Anreicherungen.

Standardmäßig gibt das Cmdlet PowerShell-Objekte an die Pipeline zurück. Wenn der Parameter `-Path` angegeben wird, schreibt er die Metadaten im Format JSON in die angegebene Datei und erstellt automatisch übergeordnete Verzeichnisse, wenn diese nicht vorhanden sind.

Das Cmdlet bietet zwei optionale Anreicherungsflags:

- **IncludeFileInfo**: Fügt Dateisystem-Metadaten hinzu, einschließlich vollständiger Pfade, Dateigrößen (in Bytes) und Zeitstempel der letzten Änderung
- **IncludeCacheInfo**: Fügt Cache-bezogene Informationen hinzu, einschließlich Cache-Dateipfaden, Existenzstatus und Cache-Zeitstempeln

Dieses Cmdlet ist besonders nützlich für:

- Erstellen von Dokumentationen oder Dashboards mit allen verfügbaren Farbskripte
- Melden des Vorhandenseins und der Zeitstempel der Roh-Cache-Nutzlastdatei
- Einspeisen von Metadaten in externe Tools oder Automatisierungspipelines
- Prüfung des Farbskript-Inventar- und Dateisystemstatus
- Erstellen von Berichten zur Farbskript-Nutzung und -Organisation

Die Ausgabe ist konsistent geordnet, sodass sie beim Export nach JSON für Versionskontrolle und Diff-Operationen geeignet ist.

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

Exportiert grundlegende Metadaten für alle Farbskripte in die Pipeline ohne Datei- oder Cache-Informationen.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

Gibt Objekte zurück, die Dateisystemdetails (vollständiger Pfad, Größe und letzte Schreibzeit) für jedes Farbskript enthalten.

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

Erstellt eine JSON-Datei mit grundlegenden Metadaten und schreibt sie in das Verzeichnis `dist`, wobei der Ordner erstellt wird, falls dieser nicht vorhanden ist.

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

Erstellt eine umfassende JSON-Datei mit angereicherten Metadaten, einschließlich Dateisystem- und Cache-Informationen, und schreibt sie in das Verzeichnis `dist`.

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeCacheInfo -PassThru | Where-Object { -not $_.CacheExists }
```

Schreibt die Metadatendatei und gibt Datensätze zurück, deren Rohnutzlast `.cache` fehlt. Dies meldet nur die Dateibelegung, nicht die Cache-Berechtigung, Gültigkeit oder Aktualität.

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

Gruppiert Farbskripte nach Kategorie und zeigt die Anzahl an, was für die Analyse der Verteilung von Skripten über Kategorien nützlich ist.

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property ScriptSizeBytes -Sum).Sum
Write-Host "Gesamtgröße aller Farbskripte: $($totalSize / 1KB) KB"
```

Berechnet den gesamten Speicherplatz, der von allen Farbskript-Dateien verwendet wird.

### EXAMPLE 8

```powershell
# Statistiken erstellen und Bericht speichern
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachePayloadFiles = ($metadata | Where-Object CacheExists).Count
    TotalScriptSizeBytes = ($metadata | Measure-Object ScriptSizeBytes -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

Erstellt Inventarstatistiken und zählt rohe `.cache`-Nutzlastdateien. Das Vorhandensein der Nutzlast ist keine Prüfung der Cache-Berechtigung, Gültigkeit oder Aktualität.

### EXAMPLE 9

```powershell
# Exportieren und mit vorherigem Backup vergleichen
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "Neue Skripte: $($new.Count) | Entfernte Skripte: $($removed.Count)"
```

Vergleicht aktuelle Metadaten mit einer früheren Version, um Änderungen zu identifizieren.

### EXAMPLE 10

```powershell
# Erstellen Sie eine API-Antwort für das Web-Dashboard
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

Erzeugt API-fähiges JSON mit Versionierungs- und Zeitstempelinformationen.

### EXAMPLE 11

```powershell
# Erstellen oder validieren Sie jeden von der Richtlinie ausgewählten Cache-Eintrag und überprüfen Sie den Status.
$results = New-ColorScriptCache -All -PassThru
$results | Group-Object Status | Select-Object Name, Count
```

Verwendet die Cache-Richtlinie als Quelle der Wahrheit und meldet, ob geeignete Einträge aktualisiert wurden, bereits aktuell sind, übersprungen wurden oder fehlgeschlagen sind.

### EXAMPLE 12

```powershell
# Erstellen Sie eine HTML-Galerie aus Metadaten
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$html = @"
<html>
<head><title>ColorScripts-Enhanced Gallery</title></head>
<body>
<h1>ColorScripts-Enhanced</h1>
<ul>
"@
foreach ($script in $metadata) {
    $html += "<li><strong>$($script.Name)</strong> [$($script.Category)]</li>`n"
}
$html += "</ul></body></html>"
$html | Out-File "./gallery.html" -Encoding UTF8
```

Erstellt eine HTML-Galerieseite, die alle verfügbaren Farbskripte auflistet.

### EXAMPLE 13

```powershell
# Überwachen Sie die Skriptgrößen im Laufe der Zeit
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object ScriptSizeBytes -Average).Average) bytes avg" }
```

Verfolgt Dateigrößenänderungen für einzelne Skripte über mehrere Exporte hinweg.

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
DefaultValue: False
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

### -IncludeCacheInfo

Fügt jedem Datensatz den Rohdatenpfad `.cache`, das Dateipräsenz-Flag und den Zeitstempel des letzten Schreibvorgangs hinzu. Diese Felder melden nicht die Cache-Richtlinienberechtigung, das Vorhandensein des `.cacheinfo`-Sidecars, die Gültigkeit oder die Aktualität.

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

### -IncludeFileInfo

Enthält Dateisystemdetails (vollständiger Pfad, Größe in Bytes und Zeitpunkt des letzten Schreibvorgangs) in jedem Datensatz. Wenn Dateimetadaten nicht gelesen werden können (aufgrund von Berechtigungen oder fehlenden Dateien), werden Fehler über eine ausführliche Ausgabe protokolliert und die betroffenen Eigenschaften werden auf Nullwerte gesetzt. Dieser Schalter ist für die Überwachung von Dateigrößen und Änderungsdaten hilfreich.

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

### -PassThru

Gibt die Metadatenobjekte an die Pipeline zurück, auch wenn der Parameter `-Path` angegeben ist. Dadurch können Sie sowohl die Metadaten in einer Datei speichern als auch eine zusätzliche Verarbeitung oder Filterung der Objekte in einem einzigen Befehl durchführen. Ohne diesen Schalter wird durch die Angabe von `-Path` die Pipeline-Ausgabe unterdrückt.

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

### -Path

Gibt den Zieldateipfad für den JSON-Export an. Unterstützt relative Pfade, absolute Pfade, Umgebungsvariablen (z. B. `$env:TEMP\metadata.json`) und Tilde-Erweiterung (z. B. `~/Documents/metadata.json`). Übergeordnete Verzeichnisse werden automatisch erstellt, wenn sie nicht vorhanden sind. Wenn dieser Parameter weggelassen wird, gibt das Cmdlet Objekte direkt an die Pipeline aus, anstatt sie in eine Datei zu schreiben. Die JSON-Ausgabe ist zur besseren Lesbarkeit mit Einrückungen formatiert.

```yaml
Type: System.String
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

### -WhatIf

Führt den Befehl in einem Modus aus, der nur meldet, was passieren würde, ohne die Aktionen auszuführen.

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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Weitere Informationen finden Sie unter
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Dieses Cmdlet akzeptiert keine Pipeline-Eingaben.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Wenn `-Path` nicht angegeben ist oder `-PassThru` verwendet wird, gibt das Cmdlet benutzerdefinierte Objekte zurück. Jedes Objekt stellt einen einzelnen Farbskript mit den folgenden Basiseigenschaften dar:

- **Name**: Der Dateiname des Farbskript ohne Erweiterung
- **Category**: Die primäre Organisationskategorie
- **Categories**: Alle zugewiesenen Kategorien
- **Tags**: Eine Reihe beschreibender Tags zum Filtern und Suchen
- **Description**: Die Metadatenbeschreibung

Wenn `-IncludeFileInfo` angegeben wird, sind diese zusätzlichen Eigenschaften enthalten:

- **ScriptPath**: Der vollständige Dateisystempfad zur Skriptdatei
- **ScriptSizeBytes**: Größe in Bytes (null, wenn auf die Datei nicht zugegriffen werden kann)
- **ScriptLastWriteTimeUtc**: UTC-Zeitstempel der letzten Änderung (null, wenn nicht verfügbar)

Wenn `-IncludeCacheInfo` angegeben wird, sind diese zusätzlichen Eigenschaften enthalten:

- **CachePath**: Der vollständige Pfad zur entsprechenden Cache-Datei
- **CacheExists**: Boolescher Wert, der angibt, ob eine Cache-Datei vorhanden ist
- **CacheLastWriteTimeUtc**: UTC-Zeitstempel der Änderung der Cache-Datei (null, wenn der Cache nicht vorhanden ist)

## NOTES

## RELATED LINKS

- [Onlineversion](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)

