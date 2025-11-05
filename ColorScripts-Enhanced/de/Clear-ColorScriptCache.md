---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/de/Clear-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Clear-ColorScriptCache

## SYNOPSIS

Löscht zwischengespeicherte ColorScript-Ausgabedateien.

## SYNTAX

```
Clear-ColorScriptCache [[-Name] <string[]>] [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Entfernt zwischengespeicherte Ausgabedateien für ColorScripts, um eine frische Ausführung bei der nächsten Anzeige zu erzwingen. Dieses Cmdlet bietet gezieltes Cache-Management für einzelne Skripte oder Massenoperationen.

Das Cache-System speichert gerenderte ANSI-Ausgaben, um nahezu sofortige Anzeigeleistung zu bieten. Im Laufe der Zeit können zwischengespeicherte Dateien veraltet werden, wenn Quellskripte modifiziert werden, oder Sie möchten den Cache aus Troubleshooting-Gründen löschen.

Verwenden Sie dieses Cmdlet, wenn:

- Quell-ColorScripts modifiziert wurden
- Cache-Korruption vermutet wird
- Sie frische Ausführung sicherstellen möchten
- Speicherplatz freigegeben werden soll

Das Cmdlet unterstützt sowohl gezieltes Löschen (spezifische Skripte) als auch Massenoperationen (alle zwischengespeicherten Dateien).

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -Name "spectrum"
```

Löscht den Cache für das spezifische ColorScript namens "spectrum".

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -All
```

Löscht alle zwischengespeicherten ColorScript-Dateien.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name "aurora*", "geometric*"
```

Löscht den Cache für ColorScripts, die den angegebenen Wildcard-Mustern entsprechen.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Name aurora-waves -WhatIf
```

Zeigt, welche Cache-Dateien gelöscht würden, ohne sie tatsächlich zu entfernen.

### EXAMPLE 5

```powershell
# Clear cache for all scripts in a category
Get-ColorScriptList -Category Nature -AsObject | ForEach-Object {
    Clear-ColorScriptCache -Name $_.Name
}
```

Löscht den Cache für alle naturthematischen ColorScripts.

## PARAMETERS

### -All

Löscht alle zwischengespeicherten ColorScript-Dateien. Kann nicht mit dem Parameter -Name verwendet werden.

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

Gibt die Namen der ColorScripts an, die aus dem Cache gelöscht werden sollen. Unterstützt Wildcards (\* und ?) für Mustervergleich.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
 - Name: Name
   Position: 0
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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Dieses Cmdlet akzeptiert keine Eingaben aus der Pipeline.

## OUTPUTS

### None

Dieses Cmdlet gibt keine Ausgaben an die Pipeline zurück.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 oder höher

**Cache-Speicherort:**
Cache-Dateien werden in einem modulverwalteten Verzeichnis gespeichert. Verwenden Sie `(Get-Module ColorScripts-Enhanced).ModuleBase`, um das Modulverzeichnis zu finden, und suchen Sie dann nach dem Cache-Unterverzeichnis.

**Wann Cache löschen:**

- Nach der Modifizierung von Quell-ColorScript-Dateien
- Bei der Fehlerbehebung von Anzeigeproblemen
- Um frische Ausführung von Skripten sicherzustellen
- Vor Leistungsbenchmarking

**Leistungsimpact:**
Das Löschen des Caches führt dazu, dass Skripte bei der nächsten Anzeige normal ausgeführt werden, was länger dauern kann als die zwischengespeicherte Ausführung. Der Cache wird bei nachfolgenden Anzeigen automatisch neu aufgebaut.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
