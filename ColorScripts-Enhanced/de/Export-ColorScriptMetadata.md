---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Export-ColorScriptMetadata
---

# Export-ColorScriptMetadata

## SYNOPSIS

Exportiert Colorscript-Metadaten in verschiedene Formate für die externe Verwendung.

## SYNTAX

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-h] [-IncludeFileInfo] [-IncludeCacheInfo]
 [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

Exportiert umfassende Metadaten über Colorscripts in externe Dateien für Dokumentation, Berichterstellung oder Integration mit anderen Tools. Unterstützt mehrere Ausgabeformate, einschließlich JSON, CSV und XML.

Die exportierten Metadaten umfassen:

- Script-Namen und Dateipfade
- Kategorien und Tags
- Beschreibungen und Metadaten
- Dateigrößen und Änderungsdaten
- Cache-Statusinformationen

Dieses Cmdlet ist nützlich für:

- Generierung von Dokumentation
- Erstellung von Inventaren
- Integration mit CI/CD-Systemen
- Backup- und Migrationszwecke
- Analyse und Berichterstellung

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata -Path "colorscripts.json"
```

Exportiert alle Colorscript-Metadaten in eine JSON-Datei.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -Path "inventory.csv" -Format CSV
```

Exportiert Metadaten im CSV-Format für die Tabellenkalkulationsanalyse.

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path "nature-scripts.xml" -Category Nature -Format XML
```

Exportiert nur naturthematische Colorscripts in das XML-Format.

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path "geometric.json" -Tag geometric
```

Exportiert Colorscripts, die als "geometric" getaggt sind, in JSON.

### EXAMPLE 5

```powershell
# Export mit Zeitstempel
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
Export-ColorScriptMetadata -Path "backup-$timestamp.json"
```

Erstellt ein zeitgestempeltes Backup aller Metadaten.

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

Attach cache metadata including the cache location, whether a cache file exists, and its timestamp.

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

Attach file system information (full path, file size, and last write time) for each colorscript.

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

Return the in-memory objects even when writing to a file.

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

Gibt den Pfad an, unter dem die exportierte Metadatendatei gespeichert wird.

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

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 oder höher

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)

