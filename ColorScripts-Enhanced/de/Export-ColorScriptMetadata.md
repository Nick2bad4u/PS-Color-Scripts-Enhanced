---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/de/Export-ColorScriptMetadata.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Export-ColorScriptMetadata

## SYNOPSIS

Exportiert Colorscript-Metadaten in verschiedene Formate für die externe Verwendung.

## SYNTAX

```
Export-ColorScriptMetadata [-Path] <string> [[-Format] <string>] [-Category <string[]>] [-Tag <string[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

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

### -Category

Filtert exportierte Scripts nach einer oder mehreren Kategorien vor dem Export.

```yaml
Type: System.String[]
DefaultValue: None
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

### -Confirm

Fordert Sie zur Bestätigung auf, bevor das Cmdlet ausgeführt wird.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: false
SupportsWildcards: false
Aliases: cf
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

### -Format

Gibt das Ausgabeformat an. Gültige Werte sind JSON, CSV und XML.

```yaml
Type: System.String
DefaultValue: JSON
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
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

Filtert exportierte Scripts nach einem oder mehreren Tags vor dem Export.

```yaml
Type: System.String[]
DefaultValue: None
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
DefaultValue: false
SupportsWildcards: false
Aliases: wi
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

Dieses Cmdlet unterstützt die allgemeinen Parameter: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Weitere Informationen finden Sie unter
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Dieses Cmdlet akzeptiert keine Eingabe aus der Pipeline.

## OUTPUTS

### None

Dieses Cmdlet gibt keine Ausgabe an die Pipeline zurück.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 oder höher

**Ausgabeformate:**
- JSON: Strukturierte Daten für programmatischen Zugriff
- CSV: Tabellenkalkulationskompatibles Format
- XML: Hierarchische Datenstruktur

**Anwendungsfälle:**
- Dokumentationsgenerierung
- Inventarverwaltung
- CI/CD-Integration
- Backup und Wiederherstellung
- Analytik und Berichterstellung

## RELATED LINKS

- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
