---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/de/Clear-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 11/14/2025
PlatyPS schema version: 2024-05-01
---

# Clear-ColorScriptCache

## SYNOPSIS

Löscht zwischengespeicherte ColorScript-Ausgabedateien.

## SYNTAX

### Alle

```
Clear-ColorScriptCache [-All] [-Path <String>] [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```
## PARAMETERS

### -All

Löscht alle zwischengespeicherten ColorScript-Dateien im Zielverzeichnis. Dieser Schalter kann nicht zusammen mit `-Name`, `-Category` oder `-Tag` verwendet werden.

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

### -Category

Filtert die zu bereinigenden Skripte nach Kategorie. Nur Cache-Dateien von Skripten, die den angegebenen Kategorien entsprechen, werden berücksichtigt. Kann mit `-Tag` kombiniert werden.

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
```

### -Confirm

Fordert Sie zur Bestätigung auf, bevor das Cmdlet ausgeführt wird. Verwenden Sie `-Confirm:$false`, um die Abfrage zu unterdrücken.

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
```

### -DryRun

Zeigt an, welche Cache-Dateien gelöscht würden, ohne Änderungen vorzunehmen. Ideal, um Filterkriterien vor dem echten Löschen zu überprüfen.

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
```

### -Name

Gibt die Namen der ColorScripts (oder Wildcard-Muster) an, deren Cache entfernt werden soll. Akzeptiert Pipelineeingaben und Objekte mit einer `Name`-Eigenschaft.

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
 - Name: All
   Position: 0
   IsRequired: false
   ValueFromPipeline: true
   ValueFromPipelineByPropertyName: true
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -NoAnsiOutput

Deaktiviert ANSI-Farbcodes in der Zusammenfassung. Praktisch für Konsolen oder Logsysteme, die keine Farben darstellen können.

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
```

### -PassThru

Gibt detaillierte Ergebnisobjekte für jede verarbeitete Cache-Datei zurück. Ohne diesen Schalter wird nur eine farbige Zusammenfassung ausgegeben.

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
```

### -Path

Legt ein alternatives Cache-Verzeichnis fest. Standardmäßig verwendet das Cmdlet den vom Modul verwalteten Cachepfad. Nützlich für benutzerdefinierte Speicherorte oder CI/CD-Umgebungen.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Selection
   Position: 1
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
 - Name: All
   Position: 1
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Quiet

Unterdrückt die Zusammenfassungsmeldung nach Abschluss der Bereinigung. Warnungen und Fehler werden weiterhin ausgegeben.

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
```

### -Tag

Filtert Skripte anhand ihrer Metadaten-Tags, bevor der Cache bereinigt wird. Mehrere Werte (ODER-Filter) sind möglich.

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
```

### -WhatIf

Zeigt an, welche Aktionen ausgeführt würden, ohne Änderungen zu übernehmen. Nutzt das integrierte PowerShell-ShouldProcess-Verhalten.

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
```

### CommonParameters

Dieses Cmdlet unterstützt die Standardparameter: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction und -WarningVariable. Weitere Informationen finden Sie unter [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Sie können Skriptnamen als Zeichenfolgen per Pipeline übergeben. Jeder Name wird auf zugehörige Cache-Dateien abgebildet.

### System.String[]

Arrays von Namen können ebenfalls übergeben werden, zum Beispiel aus `Get-ColorScriptList`.

### System.Management.Automation.PSObject

Objekte mit einer `Name`- oder `ScriptName`-Eigenschaft werden unterstützt. Der Wert wird extrahiert und für die Cache-Bereinigung verwendet.

## OUTPUTS

### System.Object

Bei Verwendung von `-PassThru` gibt das Cmdlet für jede verarbeitete Cache-Datei ein Objekt mit Status, Skriptnamen, Cachepfad und Meldung zurück. Ohne `-PassThru` wird lediglich eine (optionale) Zusammenfassung geschrieben.
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
