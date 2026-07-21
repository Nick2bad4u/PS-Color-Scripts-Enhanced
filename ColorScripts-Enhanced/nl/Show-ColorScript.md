---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

Toont een colorscript en gebruikt selectieve caching alleen voor kostbare renderers.

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

Render mooie ANSI colorscripts in je terminal met intelligente prestatie-optimalisatie. De cmdlet biedt vier primaire operationele modi:

**Random Mode (Default):** Toont een willekeurig geselecteerde colorscript uit de beschikbare collectie. Dit is het standaardgedrag wanneer geen parameters zijn opgegeven.

**Named Mode:** Toont een specifieke colorscript op naam. Ondersteunt wildcard patronen voor flexibele matching. Wanneer meerdere scripts overeenkomen met een patroon, wordt de eerste match in alfabetische volgorde geselecteerd.

**List Mode:** Toont een geformatteerde lijst van alle beschikbare colorscripts met hun metadata, inclusief naam, categorie, tags en beschrijvingen.

**All Mode:** Cycli door alle beschikbare colorscripts in alfabetische volgorde. Bijzonder nuttig voor het tonen van de gehele collectie of het ontdekken van nieuwe scripts.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Toont een willekeurige colorscript met caching ingeschakeld. Dit is de snelste manier om visuele flair toe te voegen aan je terminal sessie.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Toont de opgegeven colorscript op exacte naam. De .ps1 extensie is niet vereist.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Toont de eerste colorscript (alfabetisch) die overeenkomt met het wildcard patroon "aurora-\*". Nuttig wanneer je een deel van de scriptnaam herinnert.

### EXAMPLE 4

```powershell
scs hearts
```

Gebruikt de module alias 'scs' voor snelle toegang tot de hearts colorscript. Aliassen bieden handige snelkoppelingen voor frequent gebruik.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Lijst alle beschikbare colorscripts met hun metadata in een geformatteerde tabel. Helpt bij het ontdekken van beschikbare scripts en hun attributen.

### EXAMPLE 6

```powershell
Show-ColorScript -Name arch -NoCache
```

Toont de arch colorscript zonder cache te gebruiken, waardoor verse uitvoering wordt geforceerd. Nuttig tijdens ontwikkeling of bij het oplossen van cache problemen.

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

Toont een willekeurige natuur-georiënteerde script en captureert het metadata object voor verdere inspectie of verwerking.

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

Render de colorscript en slaat de uitvoer op in een tekstbestand. De gerenderde ANSI codes worden behouden, waardoor het bestand later met juiste kleuren kan worden weergegeven.

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

Toont alle colorscripts in alfabetische volgorde met een korte automatische vertraging tussen elk. Perfect voor een visuele showcase van de gehele collectie.

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

Toont alle colorscripts één voor één, pauzerend na elk. Druk op spatiebalk om door te gaan naar het volgende script, of druk op 'q' om de reeks vroegtijdig te beëindigen.

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

Cycli door alle natuur-georiënteerde colorscripts met handmatige voortgang. Combineert filtering met interactieve browsing voor een curatieve ervaring.

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

Toont een willekeurige colorscript die zowel "retro" als "geometric" tags heeft. Tag filtering maakt precieze subset selectie mogelijk.

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Art,Abstract
```

Lijst alleen colorscripts gecategoriseerd als "Art" of "Abstract", helpt bij het ontdekken van scripts binnen specifieke thema's.

### EXAMPLE 14

```powershell
# Meet prestatieverbetering van caching
$uncached = Measure-Command { Show-ColorScript -Name spectrum -NoCache }
$cached = Measure-Command { Show-ColorScript -Name spectrum }
Write-Host "Uncached: $($uncached.TotalMilliseconds)ms | Cached: $($cached.TotalMilliseconds)ms | Speedup: $([math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 1))x"
```

Demonstreert de prestatieverbetering die caching biedt door uitvoeringstijd te meten.

### EXAMPLE 15

```powershell
# Stel dagelijkse rotatie van verschillende colorscripts in
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

Toont een consistente maar verschillende colorscript elke dag gebaseerd op de datum.

### EXAMPLE 16

```powershell
# Exporteer gerenderde colorscript naar bestand voor delen
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Later, toon het opgeslagen bestand
Get-Content "./aurora.ansi" -Raw | Write-Host
```

Slaat een gerenderde colorscript op in een bestand dat later kan worden weergegeven of gedeeld met anderen.

### EXAMPLE 17

```powershell
# Creëer een slideshow van geometrische colorscripts
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

Toont automatisch een reeks geometrische colorscripts met 3-seconden vertragingen tussen elk.

### EXAMPLE 18

```powershell
# Foutafhandeling voorbeeld
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Script niet gevonden: $_"
    Show-ColorScript  # Fallback naar random
}
```

Demonstreert foutafhandeling wanneer een niet-bestaand script wordt opgevraagd.

### EXAMPLE 19

```powershell
# Automatisering integratie
if ($env:CI) {
    Show-ColorScript -Name "nerd-font-test" -NoCache
} else {
    Show-ColorScript  # Willekeurige weergave voor interactief gebruik
}
```

Toont hoe verschillende colorscripts conditioneel weer te geven in CI/CD omgevingen vs. interactieve sessies.

### EXAMPLE 20

```powershell
# Geplande taak voor terminal begroeting
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

Demonstreert het uitvoeren van een specifieke colorscript als deel van geplande taak of startup automatisering.

## PARAMETERS

### -All

Doorloop alle beschikbare colorscripts in alfabetische volgorde. Wanneer alleen opgegeven, worden scripts continu weergegeven met een korte automatische vertraging. Combineer met `-WaitForInput` om handmatig de voortgang door de collectie te controleren. Deze modus is ideaal voor het presenteren van de volledige bibliotheek of het ontdekken van nieuwe favorieten.

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

Filter de beschikbare scriptcollectie op een of meer categorieën voordat selectie of weergave plaatsvindt. Categorieën zijn typisch brede thema's zoals "Nature", "Abstract", "Art", "Retro", etc. Meerdere categorieën kunnen als array worden opgegeven. Deze parameter werkt in combinatie met alle modi (Random, Named, List, All) om de werkset te beperken.

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

Toont gedetailleerde hulp voor deze opdracht zonder de bewerking uit te voeren.

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

Geef een geformatteerde lijst weer van alle beschikbare colorscripts met hun bijbehorende metadata. De uitvoer bevat scriptnaam, categorie, tags en beschrijving. Dit is nuttig voor het verkennen van beschikbare opties en het begrijpen van de organisatie van de collectie. Kan worden gecombineerd met `-Category` of `-Tag` om alleen gefilterde subsets weer te geven.

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

De naam van het colorscript om weer te geven (zonder de .ps1 extensie). Ondersteunt wildcard patronen (\* en ?) voor flexibele matching. Wanneer meerdere scripts overeenkomen met een wildcard patroon, wordt de eerste match in alfabetische volgorde geselecteerd en weergegeven. Gebruik `-PassThru` om te verifiëren welk script is gekozen bij gebruik van wildcards.

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

Schakelt ANSI-opmaak uit in informatieve berichten en gerenderde uitvoer voor platte-tekstomgevingen.

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

Omzeil het caching systeem en voer het colorscript direct uit. Dit forceert verse uitvoering en kan nuttig zijn bij het testen van scriptwijzigingen, debuggen, of wanneer cache corruptie wordt vermoed. Zonder deze switch wordt cached output gebruikt wanneer beschikbaar voor optimale prestaties.

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

Retourneer het metadata object van het geselecteerde colorscript naar de pipeline naast het weergeven van het colorscript. Het metadata object bevat eigenschappen zoals Name, Path, Category, Tags, en Description. Dit maakt programmatische toegang tot scriptinformatie mogelijk voor filtering, logging, of verdere verwerking terwijl nog steeds de visuele output wordt weergegeven.

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

Onderdrukt informatieve berichten zonder opdrachtuitvoer en fouten te verbergen.

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

Vraag expliciet een willekeurige colorscript selectie aan. Dit is het standaardgedrag wanneer geen naam is opgegeven, dus deze switch is vooral nuttig voor duidelijkheid in scripts of wanneer u expliciet wilt zijn over de selectiemodus. Kan worden gecombineerd met `-Category` of `-Tag` om te randomiseren binnen een gefilterde subset.

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

Emit de gerenderde colorscript als een string naar de PowerShell pipeline in plaats van direct naar de console host te schrijven. Dit maakt het mogelijk om de output vast te leggen in een variabele, om te leiden naar een bestand, of door te sluizen naar andere commando's. De output behoudt alle ANSI escape sequences, zodat deze met de juiste kleuren wordt weergegeven wanneer later naar een compatibele terminal wordt geschreven.

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

Filter de beschikbare scriptcollectie op metadata tags (hoofdletterongevoelig). Tags zijn meer specifieke descriptors dan categorieën, zoals "geometric", "retro", "animated", "minimal", etc. Meerdere tags kunnen als array worden opgegeven. Scripts die overeenkomen met een van de opgegeven tags worden opgenomen in de werkset voordat selectie plaatsvindt.

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

Wanneer gebruikt met `-All`, pauzeer na het weergeven van elk colorscript en wacht op gebruikersinvoer voordat u doorgaat. Druk op de spatiebalk om door te gaan naar het volgende script in de reeks. Druk op 'q' om de reeks vroegtijdig te beëindigen en terug te keren naar de prompt. Dit biedt een interactieve browse-ervaring door de gehele collectie.

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

U kunt colorscript-namen naar Show-ColorScript pipen. Dit maakt pipeline-gebaseerde workflows mogelijk waarbij scriptnamen worden gegenereerd of gefilterd door andere commando's.

## OUTPUTS

### System.Object

Wanneer `-PassThru` is opgegeven, retourneert het geselecteerde colorscript's metadata object met eigenschappen zoals Name, Path, Category, Tags, en Description.

### System.String (2)

Wanneer `-ReturnText` is opgegeven, emitteert de gerenderde colorscript als een string naar de pipeline. Deze string bevat alle ANSI escape sequences voor juiste kleurweergave wanneer weergegeven in een compatibele terminal.

### None

In standaardwerking (zonder `-PassThru` of `-ReturnText`), wordt uitvoer direct naar de console host geschreven en wordt niets naar de pipeline geretourneerd.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

