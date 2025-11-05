---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/de/New-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScriptCache

## SYNOPSIS

Erstellt Cache für die Leistungsoptimierung von ColorScripts vorab.

## SYNTAX

```
New-ColorScriptCache [[-Name] <string[]>] [-Category <string[]>] [-Tag <string[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
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
HelpMessage: ""
```

### -Name

Gibt ColorScript-Namen zum Cachen an. Unterstützt Wildcards (\* und ?).

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

Filtert Skripte zum Cachen nach einem oder mehreren Tags.

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
HelpMessage: ""
```

### CommonParameters

Dieses Cmdlet unterstützt die allgemeinen Parameter: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Weitere Informationen finden Sie unter
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Dieses Cmdlet akzeptiert keine Eingaben aus der Pipeline.

## OUTPUTS

### System.Object

Gibt Cache-Buildergebnisse mit Erfolg/Fehlerstatus für jedes Skript zurück.

## NOTES

**Autor:** Nick
**Modul:** ColorScripts-Enhanced
**Erfordert:** PowerShell 5.1 oder höher

**Leistungsbeeinflussung:**
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
