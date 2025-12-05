---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/de/New-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 11/14/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScriptCache

## SYNOPSIS

Erstellt Cache für die Leistungsoptimierung von ColorScripts vorab.

## SYNTAX

### Alle

```text
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Parallel] [-ThrottleLimit <Int32>] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Benannt

```text
New-ColorScriptCache [-Name <String[]>] [-Category <String[]>] [-Tag <String[]>] [-Force] [-PassThru] [-Parallel] [-ThrottleLimit <Int32>] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Generiert vorab gecachte Ausgaben für ColorScripts, um optimale Leistung bei der ersten Anzeige zu gewährleisten. Dieses Cmdlet führt ColorScripts im Voraus aus und speichert ihre gerenderten Ausgaben für sofortigen Abruf.

Das Caching-System bietet 6-19x Leistungsverbesserungen, indem die Skriptausführungszeit bei der Anzeige eliminiert wird. Gecachte Inhalte werden automatisch ungültig, wenn Quellskripte geändert werden.

Verwenden Sie dieses Cmdlet, um:

- Cache für häufig verwendete Skripte vorzubereiten
- Konsistente Leistung über Sitzungen hinweg zu gewährleisten
- Cache nach Modul-Updates vorzuwärmen
- Startleistung zu optimieren

Das Cmdlet unterstützt selektives Caching nach Name, Kategorie oder Tags, was eine gezielte Cache-Vorbereitung ermöglicht.

Standardmäßig wird eine zusammenfassende Statusmeldung ausgegeben. Nutzen Sie `-PassThru`, um detaillierte Ergebnisobjekte zu erhalten, `-Quiet`, um die Zusammenfassung zu unterdrücken, oder `-NoAnsiOutput`, um das Resümee ohne ANSI-Farbcodes für Protokolle oder Headless-Umgebungen anzuzeigen.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Erstellt Cache für alle verfügbaren ColorScripts vorab.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name "spectrum", "aurora-waves"
```

Cached bestimmte ColorScripts nach Namen.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Category Nature
```

Erstellt Cache für alle naturthematischen ColorScripts vorab.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Tag animated
```

Cached alle ColorScripts, die als "animated" getaggt sind.

### EXAMPLE 5

```powershell
# Cache scripts for startup optimization
New-ColorScriptCache -Category Geometric -Tag minimal
```

Bereitet Cache für leichte geometrische Skripte vor, die ideal für schnelle Startanzeigen sind.

## PARAMETERS

### -Category

Filtert Skripte zum Cachen nach einer oder mehreren Kategorien.

```yaml
Type: System.String[]
## PARAMETERS

### -All

Cachet alle verfügbaren Skripte in einem Durchlauf. Kann nicht zusammen mit `-Name` verwendet werden.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: All
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```text

### -Category

Filtert die zu cachenden Skripte anhand ihrer Kategorien. Mehrere Kategorien können angegeben werden.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Selection
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
 - Name: All
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```text

### -Confirm

Fordert eine Benutzerbestätigung an, bevor die Cache-Erstellung startet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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
HelpMessage: ""
```text

### -Force

Erzwingt eine Neuerstellung des Cache selbst dann, wenn bestehende Dateien aktuell sind.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Selection
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
 - Name: All
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```text

### -Name

Definiert die Skriptnamen oder Wildcard-Muster, die gecached werden sollen. Unterstützt Pipelineeingaben und Objekte mit einer `Name`-Eigenschaft.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
 - Name: Selection
   Position: 0
   IsRequired: false
   ValueFromPipeline: true
   ValueFromPipelineByPropertyName: true
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```text

### -PassThru

Gibt detaillierte Ergebnisobjekte für jedes Skript an die Pipeline zurück. Ohne diesen Schalter wird nur eine Zusammenfassung geschrieben.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Selection
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
 - Name: All
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```js

### -Parallel

Aktiviert parallele Ausführung mit mehreren Runspaces. In Hosts ohne Unterstützung fällt das Cmdlet automatisch auf sequentielle Verarbeitung zurück.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Selection
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
 - Name: All
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```text

### -Quiet

Unterdrückt die abschließende Statusmeldung nach dem Cache-Aufbau.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Selection
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
 - Name: All
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```text

### -NoAnsiOutput

Deaktiviert ANSI-Farbsequenzen in der Zusammenfassung und liefert reinen Text.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
 - NoColor
ParameterSets:
 - Name: Selection
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
 - Name: All
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```text

### -Tag

Filtert anhand von Tags. Nur Skripte mit passenden Metadaten werden gecached.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Selection
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
 - Name: All
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```text

### -ThrottleLimit

Legt die maximale Anzahl paralleler Worker fest. Gültiger Bereich: 1 bis 256. Aliase: `Threads`.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
 - Threads
ParameterSets:
 - Name: Selection
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
 - Name: All
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```text

### -WhatIf

Zeigt an, was passieren würde, ohne den Cache tatsächlich zu erstellen.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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
HelpMessage: ""
```powershell

### CommonParameters

Dieses Cmdlet unterstützt die Standardparameter: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction und -WarningVariable. Weitere Informationen finden Sie unter [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Sie können Skriptnamen als Zeichenfolgen per Pipeline übergeben.

### System.String[]

Arrays von Skriptnamen sind ebenfalls erlaubt, z. B. aus `Get-ColorScriptList`.

### System.Management.Automation.PSObject

Objekte mit einer `Name`-Eigenschaft werden automatisch ausgewertet und in die Cache-Warteschlange aufgenommen.

## OUTPUTS

### System.Object

Mit `-PassThru` gibt das Cmdlet strukturierte Objekte mit Status, ExitCode, Cachepfad und Diagnoseinformationen zurück. Ohne den Schalter wird nur eine optionale Zusammenfassung geschrieben.
Vorab-Caching eliminiert die Ausführungszeit bei der ersten Anzeige und bietet sofortiges visuelles Feedback. Besonders vorteilhaft für komplexe oder animierte Skripte.

**Cache-Verwaltung:**
Gecachte Dateien werden in modulverwalteten Verzeichnissen gespeichert und automatisch ungültig gemacht, wenn Quellskripte geändert werden. Verwenden Sie Clear-ColorScriptCache, um veralteten Cache zu entfernen.

**Bewährte Praktiken:**

- Cache häufig verwendete Skripte für optimale Leistung
- Verwenden Sie selektives Caching, um unnötige Verarbeitung zu vermeiden
- Führen Sie nach Modul-Updates aus, um die Cache-Gültigkeit zu gewährleisten

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
