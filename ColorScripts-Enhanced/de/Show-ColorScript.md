---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

Zeigt einen Farbskript mit selektivem Caching für teure Renderer an.

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-ShowInfo] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
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
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-ShowInfo] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
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
 [-Tag <string[]>] [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-ShowInfo]
 [-Quiet] [-NoAnsiOutput] [-ValidateCache]
```

## ALIASES

- `scs`

## DESCRIPTION

Zeigt ansprechende ANSI-Farbskripte mit intelligenter Leistungsoptimierung im Terminal an. Das Cmdlet bietet vier primäre Betriebsmodi:

**Zufallsmodus (Standard):** Zeigt ein zufällig ausgewähltes Farbskript aus der verfügbaren Sammlung an. Dies ist das Standardverhalten, wenn keine Parameter angegeben werden.

**Benannter Modus:** Zeigt einen bestimmten Farbskript nach Namen an. Unterstützt Platzhaltermuster für flexiblen Abgleich. Wenn mehrere Skripte mit einem Muster übereinstimmen, wird die erste Übereinstimmung in alphabetischer Reihenfolge ausgewählt.

**Listenmodus:** Zeigt eine kompakte Tabelle mit Farbskriptnamen und Hauptkategorien an. Verwenden Sie `Get-ColorScriptList -AsObject` für vollständige Metadatensätze.

**Modus „Alle“:** Durchläuft alle verfügbaren Farbskripte in alphabetischer Reihenfolge. Besonders nützlich, um die gesamte Sammlung zu präsentieren oder neue Skripte zu entdecken.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Zeigt einen zufälligen Farbskript an. Deterministische gebündelte Skripte werden im Prozess gerendert; Berechtigte Computerrenderer können validierte zwischengespeicherte Ausgaben wiederverwenden.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Zeigt den angegebenen Farbskript mit dem genauen Namen an. Die Erweiterung .ps1 ist nicht erforderlich.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Zeigt den ersten Farbskript (alphabetisch) an, der dem Platzhaltermuster "aurora-\*" entspricht. Nützlich, wenn Sie sich einen Teil des Skriptnamens merken.

### EXAMPLE 4

```powershell
scs hearts
```

Verwendet den Alias 'scs' des Moduls für den schnellen Zugriff auf die Herzen Farbskript. Aliase bieten praktische Verknüpfungen für die häufige Verwendung.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Listet die verfügbaren Farbskripte nach Name und Hauptkategorie auf. Hilfreich für die schnelle Entdeckung.

### EXAMPLE 6

```powershell
Show-ColorScript -Name Galaxy -NoCache
```

Zeigt den geeigneten Galaxy-Renderer an, ohne die zwischengespeicherte Ausgabe zu lesen, wodurch ein neues isoliertes Rendering erzwungen wird. Nützlich beim Testen von Renderer-Änderungen oder beim Untersuchen von Cache-Beschädigungen.

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

Zeigt ein zufälliges Skript zum Thema Natur an und erfasst sein Metadatenobjekt zur weiteren Überprüfung oder Verarbeitung.

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

Rendert den Farbskript und speichert die Ausgabe in einer Textdatei. Die gerenderten ANSI-Codes bleiben erhalten, sodass die Datei später mit der richtigen Farbe angezeigt werden kann.

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

Zeigt alle Farbskripte in alphabetischer Reihenfolge mit einer kurzen automatischen Verzögerung dazwischen an. Perfekt für eine visuelle Präsentation der gesamten Kollektion.

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

Zeigt alle Farbskripte einzeln an und pausiert nach jedem. Drücken Sie die Leertaste, um zum nächsten Skript zu gelangen, oder drücken Sie 'q', um die Sequenz vorzeitig zu beenden.

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

Durchläuft alle Farbskripte zum Thema Natur mit manuellem Fortschritt. Kombiniert Filterung mit interaktivem Browsen für ein kuratiertes Erlebnis.

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

Zeigt einen zufälligen Farbskript an, der entweder das Tag "retro" oder "geometric" hat. Mehrere Tag-Werte verwenden die Any-Match-Semantik.

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Artistic,Abstract
```

Listet nur Farbskripte auf, das als "Art" oder "Abstract" kategorisiert ist, und hilft Ihnen, Skripte in bestimmten Themen zu finden.

### EXAMPLE 14

```powershell
# Überprüfen Sie die Cache-Berechtigung und den Build-Status für einen durch eine Richtlinie ausgewählten Renderer.
New-ColorScriptCache -Name Galaxy -Force -PassThru |
    Select-Object Name, Status, CacheFile
Show-ColorScript -Name Galaxy
```

Erstellt und überprüft einen Cache-Eintrag für einen geeigneten Renderer, ohne einen maschinenunabhängigen Leistungsmultiplikator zu beanspruchen.

### EXAMPLE 15

```powershell
# Richten Sie die tägliche Rotation verschiedener Farbskripte ein
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

Zeigt jeden Tag basierend auf dem Datum einen konsistenten, aber unterschiedlichen Farbskript an.

### EXAMPLE 16

```powershell
# Exportieren Sie gerendertes Farbskript in eine Datei zur Weitergabe
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Später die gespeicherte Datei anzeigen
Get-Content "./aurora.ansi" -Raw | Write-Host
```

Speichert ein gerendertes Farbskript in einer Datei, die später angezeigt oder mit anderen geteilt werden kann.

### EXAMPLE 17

```powershell
# Erstellen Sie eine Diashow mit geometrischem Farbskripte
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

Zeigt automatisch eine Folge geometrischer Farbskripte mit jeweils 3 Sekunden Verzögerung an.

### EXAMPLE 18

```powershell
# Beispiel für die Fehlerbehandlung
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Skript nicht gefunden: $_"
    Show-ColorScript  # Ersatzweise eine zufällige Auswahl anzeigen
}
```

Demonstriert die Fehlerbehandlung beim Anfordern eines Skripts, das nicht vorhanden ist.

### EXAMPLE 19

```powershell
# Automatisierungsintegration erstellen
if ($env:CI) {
    Show-ColorScript -Name "Galaxy" -NoCache
} else {
    Show-ColorScript  # Zufallsanzeige zur interaktiven Verwendung
}
```

Zeigt, wie verschiedene Farbskripte in CI/CD-Umgebungen im Vergleich zu interaktiven Sitzungen bedingt angezeigt werden.

### EXAMPLE 20

```powershell
# Geplante Aufgabe für die Terminalbegrüßung
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

Demonstriert die Ausführung eines bestimmten Farbskript als Teil einer geplanten Aufgabe oder Startautomatisierung.

### EXAMPLE 21

```powershell
Show-ColorScript -IncludePokemon
```

Veranschaulicht den veralteten Kompatibilitätsschalter. Er bleibt für eine Version ein stiller Schalter ohne Wirkung, da Pokémon- und Shiny-Pokémon-Skripte bereits an der normalen Auswahl teilnehmen.

### EXAMPLE 22

```powershell
Show-ColorScript -Random -ExcludeCategory Pokemon,ShinyPokemon
```

Zeigt einen zufälligen Farbskript an und schließt dabei beide Pokémon-Kategorien aus. Kombinieren Sie es mit `-Category` oder `-Tag`, um die Auswahl weiter zu verfeinern.

### EXAMPLE 23

```powershell
Show-ColorScript -Random -ShowInfo
```

Zeigt einen zufälligen Farbskript an und schreibt anschließend dessen Skriptnamen und vollständigen Pfad in den Informationsdatenstrom. Verwenden Sie `-Quiet`, um die Identifikationszeile zu unterdrücken.

## PARAMETERS

### -All

Durchlaufen Sie alle verfügbaren Farbskripte in alphabetischer Reihenfolge. Bei alleiniger Angabe werden Skripte kontinuierlich mit einer kurzen automatischen Verzögerung angezeigt. Kombinieren Sie es mit `-WaitForInput`, um den Fortschritt in der Sammlung manuell zu steuern. Dieser Modus ist ideal, um die gesamte Bibliothek zu präsentieren oder neue Favoriten zu entdecken.

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

Filtern Sie die verfügbare Skriptsammlung nach einer oder mehreren Kategorien, bevor eine Auswahl oder Anzeige erfolgt. Bei Kategorien handelt es sich in der Regel um umfassende Themen wie "Nature", "Abstract", "Art", "Retro" usw. Mehrere Kategorien können als Array angegeben werden. Dieser Parameter funktioniert in Verbindung mit allen Modi (Zufällig, Benannt, Liste, Alle), um den Arbeitssatz einzugrenzen.

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

Schließen Sie Skripte aus einer oder mehreren Kategorien aus, bevor die Auswahl erfolgt. Verwenden Sie beispielsweise `-ExcludeCategory Pokemon,ShinyPokemon`, um alle Pokémon-Skripte zu vermeiden, oder geben Sie eine beliebige andere Kategorienkombination an. Funktioniert in allen Modi (Zufällig, Benannt, Liste, Alle) und kombiniert mit den Filtern `-Category` und `-Tag`.

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

Zeigt detaillierte Hilfe für diesen Befehl an, ohne den Vorgang auszuführen.

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

Veralteter Kompatibilitätsschalter. Er wird für eine Version stillschweigend ohne Wirkung akzeptiert, da Pokémon- und Shiny-Pokémon-Farbskripte bereits an der normalen Auswahl teilnehmen. Verwenden Sie `-ExcludeCategory Pokemon,ShinyPokemon`, um sie auszuschließen.

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

Zeigt eine formatierte Liste aller verfügbaren Farbskripte mit den zugehörigen Metadaten an. Die Ausgabe umfasst Skriptnamen, Kategorie, Tags und Beschreibung. Dies ist nützlich, um die verfügbaren Optionen zu erkunden und die Organisation der Sammlung zu verstehen. Kann mit `-Category` oder `-Tag` kombiniert werden, um nur gefilterte Teilmengen aufzulisten.

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

Der Name des anzuzeigenden Farbskript (ohne die Erweiterung .ps1). Unterstützt Platzhaltermuster (\* und ?) für flexiblen Abgleich. Wenn mehrere Skripte mit einem Platzhaltermuster übereinstimmen, wird die erste Übereinstimmung in alphabetischer Reihenfolge ausgewählt und angezeigt. Verwenden Sie `-PassThru`, um zu überprüfen, welches Skript bei der Verwendung von Platzhaltern ausgewählt wurde.

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

Deaktiviert das ANSI-Format in Informationsmeldungen und gerenderten Ausgaben für Nur-Text-Umgebungen.

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

Umgeht validierte Cache-Lesevorgänge für durch Richtlinien ausgewählte Renderer und erzwingt ein neues isoliertes Rendering. Dies ist nützlich, wenn Sie Renderer-Änderungen testen oder Cache-Beschädigungen untersuchen. Deterministische gebündelte Skripte und nicht aufgeführte oder benutzerdefinierte Skripte umgehen den Cache bereits; Gebündelter deterministischer Inhalt wird weiterhin im Prozess gerendert.

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

Überspringen Sie bei Verwendung mit `-All` den automatischen `Clear-Host`-Aufruf zwischen Farbskripte, sodass jedes gerenderte Skript über dem nächsten sichtbar bleibt. Dies ist besonders nützlich, wenn Sie Skripte nebeneinander vergleichen oder die gesamte Präsentation in Sitzungsprotokollen festhalten möchten.

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

Geben Sie zusätzlich zur Anzeige des Farbskript das Metadatenobjekt des ausgewählten Farbskript an die Pipeline zurück. Das Metadatenobjekt enthält Eigenschaften wie Name, Path, Category, Tags und Description. Dies ermöglicht den programmgesteuerten Zugriff auf Skriptinformationen zum Filtern, Protokollieren oder zur weiteren Verarbeitung, während gleichzeitig die visuelle Ausgabe gerendert wird.

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

Unterdrückt Informationsmeldungen und behält gleichzeitig Befehlsausgaben und Fehler bei.

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

Fordern Sie ausdrücklich eine zufällige Farbskript-Auswahl an. Dies ist das Standardverhalten, wenn kein Name angegeben wird. Daher ist dieser Schalter vor allem aus Gründen der Klarheit in Skripten nützlich oder wenn Sie den Auswahlmodus explizit angeben möchten. Kann mit `-Category` oder `-Tag` kombiniert werden, um eine Randomisierung innerhalb einer gefilterten Teilmenge zu ermöglichen.

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

Geben Sie das gerenderte Farbskript als string an die PowerShell-Pipeline aus, anstatt direkt auf den Konsolenhost zu schreiben. Dadurch kann die Ausgabe in einer Variablen erfasst, in eine Datei umgeleitet oder an andere Befehle weitergeleitet werden. Die Ausgabe behält alle ANSI-Escape-Sequenzen bei, sodass sie beim späteren Schreiben auf ein kompatibles Terminal mit den richtigen Farben angezeigt wird.

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

### -ShowInfo

Schreibt nach dem Rendern jedes ausgewählten Farbskripts eine kompakte Zeile in den Informationsdatenstrom, die den Skriptnamen und den vollständigen Pfad enthält. `-Quiet` unterdrückt diese Zeile. `-ReturnText` enthält sie nicht, und `-PassThru` gibt weiterhin strukturierte Metadaten zurück.

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

### -Tag

Filtern Sie die verfügbare Skriptsammlung nach Metadaten-Tags (ohne Berücksichtigung der Groß- und Kleinschreibung). Tags sind spezifischere Deskriptoren als Kategorien, wie z. B. "geometric", "retro", "animated", "minimal" usw. Mehrere Tags können als Array angegeben werden. Skripte, die mit einem der angegebenen Tags übereinstimmen, werden vor der Auswahl in den Arbeitssatz aufgenommen.

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

Aktualisiert die Cache-Metadatenmarkierung auf Modulebene vor dem Rendern, auch wenn das Cache-Verzeichnis bereits in der aktuellen Modulsitzung initialisiert wurde. Es werden keine Ausgabe-Cache-Einträge neu erstellt und die normale Validierung pro Eintrag wird nicht ersetzt. Wenn `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE` auf `1`, `true` oder `yes` gesetzt wird, wird während der Cache-Initialisierung dieselbe Aktualisierung angefordert.

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

Halten Sie bei Verwendung mit `-All` nach der Anzeige jedes Farbskript inne und warten Sie auf Benutzereingaben, bevor Sie fortfahren. Drücken Sie die Leertaste, um zum nächsten Skript in der Sequenz zu gelangen. Drücken Sie 'q', um die Sequenz vorzeitig zu beenden und zur Eingabeaufforderung zurückzukehren. Dies ermöglicht ein interaktives Durchsuchen der gesamten Sammlung.

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

Dieses Cmdlet unterstützt die allgemeinen Parameter:
Weitere Informationen finden Sie unter
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Dieses Cmdlet akzeptiert keine Pipeline-Eingaben. Leiten Sie Bestandsdatensätze an `ForEach-Object` weiter und rufen Sie `Show-ColorScript -Name $_.Name` auf, wenn Sie eine Pipeline erstellen.

## OUTPUTS

### System.Object

Wenn `-PassThru` angegeben ist, wird das Metadatenobjekt des ausgewählten Farbskript zurückgegeben, das Eigenschaften wie Name, Path, Category, Tags und Description enthält.

### System.String (2)

Wenn `-ReturnText` angegeben ist, wird das gerenderte Farbskript als string an die Pipeline ausgegeben. Dieses string enthält alle ANSI-Escape-Sequenzen für eine korrekte Farbwiedergabe bei der Anzeige in einem kompatiblen Terminal.

### None

Im Standardbetrieb (ohne `-PassThru` oder `-ReturnText`) wird die Ausgabe direkt auf den Konsolenhost geschrieben und nichts wird an die Pipeline zurückgegeben.

## NOTES

**Autor:** Nick
**Modul:** ColorScripts-Enhanced
**Erfordert:** PowerShell 5.1 oder höher

## RELATED LINKS

- [Onlineversion](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

