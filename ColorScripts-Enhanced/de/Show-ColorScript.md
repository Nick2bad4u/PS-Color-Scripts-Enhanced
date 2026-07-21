---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

Zeigt ein Farbskript an und verwendet selektives Caching nur für aufwendige Renderer.

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Help

```
Show-ColorScript [-h] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Named

```
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### List

```
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### All

```
Show-ColorScript [-All] [-WaitForInput] [-NoClear] [-NoCache] [-Category <string[]>]
 [-Tag <string[]>] [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

## ALIASES

- `scs`

## DESCRIPTION

Rendert schöne ANSI-Farbskripte in Ihrem Terminal mit intelligenter Leistungsoptimierung. Das Cmdlet bietet vier primäre Betriebsmodi:

**Random Mode (Default):** Zeigt ein zufällig ausgewähltes Farbskript aus der verfügbaren Sammlung an. Dies ist das Standardverhalten, wenn keine Parameter angegeben werden.

**Named Mode:** Zeigt ein bestimmtes Farbskript nach Namen an. Unterstützt Platzhaltermuster für flexible Übereinstimmung. Wenn mehrere Skripte einem Muster entsprechen, wird die erste Übereinstimmung in alphabetischer Reihenfolge ausgewählt.

**List Mode:** Zeigt eine formatierte Liste aller verfügbaren Farbskripte mit ihren Metadaten an, einschließlich Name, Kategorie, Tags und Beschreibungen.

**All Mode:** Durchläuft alle verfügbaren Farbskripte in alphabetischer Reihenfolge. Besonders nützlich, um die gesamte Sammlung zu präsentieren oder neue Skripte zu entdecken.

## EXAMPLES

#### Beispiel 1: Zufälliges Farbskript beim Start

```powershell
# In Ihrer $PROFILE-Datei:
Import-Module ColorScripts-Enhanced
Show-ColorScript
```

#### Beispiel 2: Tägliches anderes Farbskript

```powershell
# Verwenden Sie das Datum als Seed für konsistentes tägliches Skript
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript
```

#### Beispiel 3: Cache für bevorzugte Skripte erstellen

```powershell
New-ColorScriptCache -Name Galaxy,rose-curves,wave-interference
```

#### Beispiel 4: Cache-Neuerstellung erzwingen

```powershell
New-ColorScriptCache -Force
```

## PARAMETERS

### -All

Durchläuft alle verfügbaren Farbskripte in alphabetischer Reihenfolge. Wenn allein angegeben, werden Skripte kontinuierlich mit einer kurzen automatischen Verzögerung angezeigt. Kombinieren Sie mit `-WaitForInput`, um die Fortsetzung durch die Sammlung manuell zu steuern. Dieser Modus ist ideal, um die gesamte Bibliothek zu präsentieren oder neue Favoriten zu entdecken.

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
HelpMessage: ''
```

### -Category

Filtert die verfügbare Skriptsammlung nach einer oder mehreren Kategorien, bevor eine Auswahl oder Anzeige erfolgt. Kategorien sind typischerweise breite Themen wie "Nature", "Abstract", "Art", "Retro" usw. Mehrere Kategorien können als Array angegeben werden. Dieser Parameter funktioniert in Verbindung mit allen Modi (Random, Named, List, All), um den Arbeitsbereich einzugrenzen.

```yaml
Type: System.String[]
DefaultValue: ''
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

### -ExcludeCategory

Exclude scripts from one or more categories.
Use this to filter out large collections like Pokemon scripts.

```yaml
Type: System.String[]
DefaultValue: ''
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

### -h

Zeigt die ausführliche Hilfe für diesen Befehl an, ohne den Vorgang auszuführen.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- help
ParameterSets:
- Name: Help
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IncludePokemon

Opt-in flag to include Pokemon colorscripts in the random selection.
When omitted, Pokemon scripts are filtered out automatically.

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

### -List

Zeigt eine formatierte Liste aller verfügbaren Farbskripte mit ihren zugehörigen Metadaten an. Die Ausgabe enthält Skriptname, Kategorie, Tags und Beschreibung. Dies ist nützlich, um verfügbare Optionen zu erkunden und die Organisation der Sammlung zu verstehen. Kann mit `-Category` oder `-Tag` kombiniert werden, um nur gefilterte Teilmengen aufzulisten.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: List
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

Der Name des anzuzeigenden Farbskripts (ohne die .ps1-Erweiterung). Unterstützt Platzhaltermuster (\* und ?) für flexible Übereinstimmung. Wenn mehrere Skripte einem Platzhaltermuster entsprechen, wird die erste Übereinstimmung in alphabetischer Reihenfolge ausgewählt und angezeigt. Verwenden Sie `-PassThru`, um zu überprüfen, welches Skript bei Verwendung von Platzhaltern ausgewählt wurde.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Named
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAnsiOutput

Deaktiviert ANSI-Formatierung in Informationsmeldungen und gerenderter Ausgabe für reine Textumgebungen.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- NoColor
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

### -NoCache

Umgeht das Caching-System und führt das Farbskript direkt aus. Dies erzwingt eine frische Ausführung und kann nützlich sein, wenn Skriptänderungen getestet, Fehler behoben oder Cache-Korruption vermutet wird. Ohne diesen Schalter wird zwischengespeicherte Ausgabe verwendet, wenn verfügbar, für optimale Leistung.

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

### -NoClear

When cycling through scripts with -All, skip clearing the host between displays so prior output remains visible.

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
HelpMessage: ''
```

### -PassThru

Gibt das Metadatenobjekt des ausgewählten Farbskripts zusätzlich zur Anzeige des Farbskripts an die Pipeline zurück. Das Metadatenobjekt enthält Eigenschaften wie Name, Pfad, Kategorie, Tags und Beschreibung. Dies ermöglicht programmatischen Zugriff auf Skriptinformationen für Filterung, Protokollierung oder weitere Verarbeitung, während die visuelle Ausgabe weiterhin gerendert wird.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Named
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Quiet

Unterdrückt Informationsmeldungen, ohne Befehlsausgaben und Fehler zu unterdrücken.

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

### -Random

Fordert explizit eine zufällige Farbskriptauswahl an. Dies ist das Standardverhalten, wenn kein Name angegeben wird, daher ist dieser Schalter hauptsächlich nützlich für Klarheit in Skripten oder wenn Sie explizit über den Auswahlmodus sein möchten. Kann mit `-Category` oder `-Tag` kombiniert werden, um innerhalb einer gefilterten Teilmenge zu randomisieren.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ReturnText

Gibt das gerenderte Farbskript als Zeichenfolge an die PowerShell-Pipeline aus, anstatt direkt in den Konsolenhost zu schreiben. Dies ermöglicht das Erfassen der Ausgabe in einer Variablen, die Umleitung in eine Datei oder die Weiterleitung an andere Befehle. Die Ausgabe behält alle ANSI-Escape-Sequenzen bei, sodass sie bei späterer Ausgabe in einem kompatiblen Terminal mit richtigen Farben angezeigt wird.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- AsString
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

### -Tag

Filtert die verfügbare Skriptsammlung nach Metadaten-Tags (Groß-/Kleinschreibung wird nicht beachtet). Tags sind spezifischere Deskriptoren als Kategorien, wie "geometric", "retro", "animated", "minimal" usw. Mehrere Tags können als Array angegeben werden. Skripte, die einem der angegebenen Tags entsprechen, werden in den Arbeitsbereich aufgenommen, bevor die Auswahl erfolgt.

```yaml
Type: System.String[]
DefaultValue: ''
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

### -ValidateCache

Forces cache validation before rendering.
Use when you need to rebuild cached colorscript output manually.

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

### -WaitForInput

Bei Verwendung mit `-All` wird nach der Anzeige jedes Farbskripts angehalten und auf Benutzereingabe gewartet, bevor fortgefahren wird. Drücken Sie die Leertaste, um zum nächsten Skript in der Sequenz zu gelangen. Drücken Sie 'q', um die Sequenz frühzeitig zu beenden und zur Eingabeaufforderung zurückzukehren. Dies bietet eine interaktive Browsing-Erfahrung durch die gesamte Sammlung.

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
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Sie können Farbskriptnamen an Show-ColorScript weiterleiten. Dies ermöglicht pipelinebasierte Workflows, bei denen Skriptnamen von anderen Befehlen generiert oder gefiltert werden.

## OUTPUTS

### System.Object

Wenn `-PassThru` angegeben ist, wird das Metadatenobjekt des ausgewählten Farbskripts zurückgegeben, das Eigenschaften wie Name, Pfad, Kategorie, Tags und Beschreibung enthält.

### System.String (2)

Wenn `-ReturnText` angegeben ist, wird das gerenderte Farbskript als Zeichenfolge an die Pipeline ausgegeben. Diese Zeichenfolge enthält alle ANSI-Escape-Sequenzen für korrekte Farbdarstellung bei Anzeige in einem kompatiblen Terminal.

### None

Bei Standardbetrieb (ohne `-PassThru` oder `-ReturnText`) wird die Ausgabe direkt in den Konsolenhost geschrieben und nichts an die Pipeline zurückgegeben.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## RELATED LINKS

- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)
