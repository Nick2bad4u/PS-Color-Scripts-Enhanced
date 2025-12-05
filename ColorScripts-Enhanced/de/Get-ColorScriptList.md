---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/de/Get-ColorScriptList.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptList

## SYNOPSIS

Ruft eine Liste der verfügbaren Farbskripte mit ihren Metadaten ab.

## SYNTAX

```powershell
Get-ColorScriptList [[-Name] <string[]>] [-Category <string[]>] [-Tag <string[]>] [-AsObject]
 [<CommonParameters>]
```

## DESCRIPTION

Gibt Informationen über verfügbare Farbskripte in der ColorScripts-Enhanced-Sammlung zurück. Standardmäßig wird eine formatierte Tabelle angezeigt, die Skriptnamen, Kategorien und Beschreibungen zeigt. Verwenden Sie `-AsObject`, um strukturierte Objekte für den programmatischen Zugriff zurückzugeben.

Das Cmdlet bietet umfassende Metadaten zu jedem Farbskript, einschließlich:

- Name: Der Skriptbezeichner (ohne .ps1-Erweiterung)
- Category: Thematische Gruppierung (Nature, Abstract, Geometric, etc.)
- Tags: Zusätzliche Deskriptoren für Filterung und Entdeckung
- Description: Kurze Erklärung des visuellen Inhalts des Skripts

Dieses Cmdlet ist unerlässlich, um die Sammlung zu erkunden und die verfügbaren Optionen zu verstehen, bevor andere Cmdlets wie `Show-ColorScript` verwendet werden.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Zeigt eine formatierte Tabelle aller verfügbaren Farbskripte mit ihren Metadaten an.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Category Nature
```

Listet nur Farbskripte auf, die als "Nature" kategorisiert sind.

### EXAMPLE 3

```powershell
Get-ColorScriptList -Tag geometric -AsObject
```

Gibt Farbskripte, die als "geometric" getaggt sind, als Objekte für weitere Verarbeitung zurück.

### EXAMPLE 4

```powershell
Get-ColorScriptList -Name "aurora*" | Format-Table Name, Category, Tags
```

Listet Farbskripte auf, die dem Platzhaltermuster entsprechen, mit ausgewählten Eigenschaften.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject | Where-Object { $_.Tags -contains 'animated' }
```

Findet alle animierten Farbskripte mithilfe der Objektfilterung.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Abstract,Geometric | Measure-Object
```

Zählt Farbskripte in den Kategorien Abstract oder Geometric.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Tag retro | Select-Object Name, Description
```

Zeigt Namen und Beschreibungen von retro-stilisierten Farbskripten an.

### EXAMPLE 8

```powershell
# Zufälliges Skript aus einer bestimmten Kategorie abrufen
Get-ColorScriptList -Category Nature -AsObject | Get-Random | Select-Object -ExpandProperty Name
```

Wählt einen zufälligen naturthematischen Farbskriptnamen aus.

### EXAMPLE 9

```powershell
# Skriptinventar in CSV exportieren
Get-ColorScriptList -AsObject | Export-Csv -Path "colorscripts.csv" -NoTypeInformation
```

Exportiert vollständige Skriptmetadaten in eine CSV-Datei.

### EXAMPLE 10

```powershell
# Skripte nach mehreren Kriterien finden
Get-ColorScriptList -AsObject | Where-Object {
    $_.Category -eq 'Geometric' -and $_.Tags -contains 'colorful'
}
```

Findet geometrische Farbskripte, die auch als bunt getaggt sind.

## PARAMETERS

### -AsObject

Gibt Farbskriptinformationen als strukturierte Objekte zurück, anstatt eine formatierte Tabelle anzuzeigen. Objekte enthalten Name-, Category-, Tags- und Description-Eigenschaften für den programmatischen Zugriff.

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
HelpMessage: ""
```

### -Category

Filtert Ergebnisse auf Farbskripte, die zu einer oder mehreren angegebenen Kategorien gehören. Kategorien sind breite thematische Gruppierungen wie "Nature", "Abstract", "Art", "Retro" usw.

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
HelpMessage: ""
```

### -Name

Filtert Ergebnisse auf Farbskripte, die einem oder mehreren Namensmustern entsprechen. Unterstützt Platzhalter (\* und ?) für flexible Übereinstimmung.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
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
HelpMessage: ""
```

### -Tag

Filtert Ergebnisse auf Farbskripte, die mit einem oder mehreren angegebenen Tags versehen sind. Tags sind spezifischere Deskriptoren wie "geometric", "retro", "animated", "minimal" usw.

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
HelpMessage: ""
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

### System.Object

Wenn `-AsObject` angegeben ist, werden benutzerdefinierte Objekte mit Name-, Category-, Tags- und Description-Eigenschaften zurückgegeben.

### None (2)

Wenn `-AsObject` nicht angegeben ist, wird die Ausgabe direkt an die Konsole geschrieben.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 oder höher

## Metadateneigenschaften

- Name: Skriptbezeichner, der von Show-ColorScript verwendet wird
- Category: Thematische Gruppierung für Organisation
- Tags: Array von beschreibenden Schlüsselwörtern für Filterung
- Description: Menschlich lesbare Erklärung des Inhalts

## Verwendungsmuster

- Entdeckung: Verfügbare Skripte vor der Auswahl erkunden
- Filterung: Optionen mithilfe von Kategorien und Tags einschränken
- Automatisierung: -AsObject für programmatische Skriptauswahl verwenden
- Inventar: Metadaten für Dokumentation oder Berichterstellung exportieren

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
