---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

Toont een colorscript met selectieve caching voor dure renderers.

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

Geeft prachtige ANSI colorscripts weer in uw terminal met intelligente prestatie-optimalisatie. De cmdlet biedt vier primaire werkingsmodi:

**Willekeurige modus (standaard):** Geeft een willekeurig geselecteerde colorscript uit de beschikbare collectie weer. Dit is het standaardgedrag als er geen parameters zijn opgegeven.

**Benoemde modus:** Geeft een specifieke colorscript op naam weer. Ondersteunt jokertekenpatronen voor flexibele matching. Wanneer meerdere scripts overeenkomen met een patroon, wordt de eerste overeenkomst in alfabetische volgorde geselecteerd.

**Lijstmodus:** Geeft een compacte tabel weer met colorscript-namen en primaire categorieën. Gebruik `Get-ColorScriptList -AsObject` voor volledige metadatarecords.

**Allesmodus:** Bladert door alle beschikbare colorscripts in alfabetische volgorde. Vooral handig voor het presenteren van de hele collectie of het ontdekken van nieuwe scripts.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Geeft een willekeurige colorscript weer. Deterministische gebundelde scripts worden in-process weergegeven; in aanmerking komende computationele renderers kunnen gevalideerde uitvoer in de cache hergebruiken.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Geeft de opgegeven colorscript op exacte naam weer. De .ps1-extensie is niet vereist.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Geeft de eerste colorscript weer (alfabetisch) die overeenkomt met het jokertekenpatroon "aurora-\*". Handig als u een deel van de naam van een script onthoudt.

### EXAMPLE 4

```powershell
scs hearts
```

Gebruikt de alias van de module 'scs' voor snelle toegang tot de harten colorscript. Aliassen bieden handige snelkoppelingen voor veelvuldig gebruik.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Geeft een overzicht van de beschikbare colorscripts op naam en primaire categorie. Handig voor snelle ontdekking.

### EXAMPLE 6

```powershell
Show-ColorScript -Name Galaxy -NoCache
```

Geeft de in aanmerking komende Galaxy-renderer weer zonder de cache-uitvoer te lezen, waardoor een nieuwe geïsoleerde render wordt geforceerd. Handig bij het testen van wijzigingen in de renderer of het onderzoeken van cachecorruptie.

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

Toont een willekeurig script met een natuurthema en legt het metadata-object vast voor verdere inspectie of verwerking.

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

Rendert de colorscript en slaat de uitvoer op in een tekstbestand. De weergegeven ANSI-codes blijven behouden, zodat het bestand later met de juiste kleur kan worden weergegeven.

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

Toont alle colorscripts in alfabetische volgorde met een korte automatische vertraging ertussen. Perfect voor een visuele showcase van de gehele collectie.

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

Geeft alle colorscripts één voor één weer, met een pauze na elke sessie. Druk op de spatiebalk om naar het volgende script te gaan, of druk op 'q' om de reeks voortijdig te beëindigen.

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

Bladert door alle colorscripts met natuurthema met handmatige voortgang. Combineert filteren met interactief browsen voor een samengestelde ervaring.

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

Geeft een willekeurige colorscript weer met de tag "retro" of "geometric". Meerdere tagwaarden gebruiken elke match-semantiek.

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Artistic,Abstract
```

Geeft alleen colorscripts weer, gecategoriseerd als "Art" of "Abstract", zodat u scripts binnen specifieke thema's kunt ontdekken.

### EXAMPLE 14

```powershell
# Inspecteer de geschiktheid voor de cache en de buildstatus voor een door het beleid geselecteerde renderer.
New-ColorScriptCache -Name Galaxy -Force -PassThru |
    Select-Object Name, Status, CacheFile
Show-ColorScript -Name Galaxy
```

Bouwt en inspecteert een cache-item voor een in aanmerking komende renderer zonder een machine-onafhankelijke prestatievermenigvuldiger te claimen.

### EXAMPLE 15

```powershell
# Dagelijkse rotatie van verschillende colorscripts instellen
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

Geeft elke dag een consistente maar verschillende colorscript weer op basis van de datum.

### EXAMPLE 16

```powershell
# Exporteer de gerenderde colorscript naar een bestand om te delen
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Geef later het opgeslagen bestand weer
Get-Content "./aurora.ansi" -Raw | Write-Host
```

Slaat een gerenderde colorscript op in een bestand dat later kan worden weergegeven of met anderen kan worden gedeeld.

### EXAMPLE 17

```powershell
# Maak een diavoorstelling van de geometrische colorscripts
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

Geeft automatisch een reeks geometrische colorscripts weer met een vertraging van 3 seconden ertussen.

### EXAMPLE 18

```powershell
# Voorbeeld van foutafhandeling
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Script niet gevonden: $_"
    Show-ColorScript  # Terugval op willekeurig
}
```

Demonstreert foutafhandeling bij het aanvragen van een script dat niet bestaat.

### EXAMPLE 19

```powershell
# Bouw automatiseringsintegratie
if ($env:CI) {
    Show-ColorScript -Name "Galaxy" -NoCache
} else {
    Show-ColorScript  # Willekeurige weergave voor interactief gebruik
}
```

Laat zien hoe u verschillende colorscripts voorwaardelijk kunt weergeven in CI/CD-omgevingen versus interactieve sessies.

### EXAMPLE 20

```powershell
# Geplande taak voor terminalbegroeting
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

Demonstreert het gebruik van een specifieke colorscript als onderdeel van geplande taak- of opstartautomatisering.

### EXAMPLE 21

```powershell
Show-ColorScript -IncludePokemon
```

Toont de verouderde compatibiliteitsschakelaar. Deze is één release stil en zonder effect omdat Pokémon- en shiny-Pokémon-scripts al normaal aan de selectie deelnemen.

### EXAMPLE 22

```powershell
Show-ColorScript -Random -ExcludeCategory Pokemon,ShinyPokemon
```

Geeft een willekeurige colorscript weer, maar sluit beide Pokémon-categorieën uit. Combineer met `-Category` of `-Tag` om de selectie verder te verfijnen.

### EXAMPLE 23

```powershell
Show-ColorScript -Random -ShowInfo
```

Geeft een willekeurig colorscript weer en schrijft vervolgens de scriptnaam en het volledige pad naar de informatiestroom. Gebruik `-Quiet` om de identificatieregel te onderdrukken.

## PARAMETERS

### -All

Blader in alfabetische volgorde door alle beschikbare colorscripts. Wanneer alleen opgegeven, worden scripts continu weergegeven met een korte automatische vertraging. Combineer met `-WaitForInput` om de voortgang door de collectie handmatig te controleren. Deze modus is ideaal om de volledige bibliotheek te laten zien of nieuwe favorieten te ontdekken.

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

Filter de beschikbare scriptverzameling op een of meer categorieën voordat er enige selectie of weergave plaatsvindt. Categories zijn doorgaans brede thema's zoals "Nature", "Abstract", "Art", "Retro", enz. Er kunnen meerdere categorieën worden gespecificeerd als een array. Deze parameter werkt in combinatie met alle modi (Random, Named, List, All) om de werkset te verkleinen.

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

Sluit scripts uit een of meer categorieën uit voordat selectie plaatsvindt. Gebruik bijvoorbeeld `-ExcludeCategory Pokemon,ShinyPokemon` om alle Pokémon-scripts te vermijden, of geef een andere combinatie van categorieën op. Werkt in alle modi (willekeurig, benoemd, lijst, alles) en combineert met `-Category`- en `-Tag`-filters.

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

Geeft gedetailleerde hulp weer voor deze opdracht zonder de bewerking uit te voeren.

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

Verouderde compatibiliteitsschakelaar. Deze wordt één release stilzwijgend zonder effect geaccepteerd omdat Pokémon- en shiny-Pokémon-colorscripts al normaal aan de selectie deelnemen. Gebruik `-ExcludeCategory Pokemon,ShinyPokemon` om ze uit te sluiten.

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

Geef een opgemaakte lijst weer van alle beschikbare colorscripts met de bijbehorende metadata. De uitvoer bevat de scriptnaam, categorie, tags en beschrijving. Dit is handig om de beschikbare opties te verkennen en de organisatie van de collectie te begrijpen. Kan worden gecombineerd met `-Category` of `-Tag` om alleen gefilterde subsets weer te geven.

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

De naam van de colorscript die moet worden weergegeven (zonder de .ps1-extensie). Ondersteunt jokertekenpatronen (\* en ?) voor flexibele matching. Wanneer meerdere scripts overeenkomen met een jokertekenpatroon, wordt de eerste overeenkomst in alfabetische volgorde geselecteerd en weergegeven. Gebruik `-PassThru` om te verifiëren welk script is gekozen bij het gebruik van jokertekens.

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

Schakelt de ANSI-stijl uit in informatieve berichten en weergegeven uitvoer voor omgevingen met platte tekst.

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

Omzeilt gevalideerde cache-lezingen voor door beleid geselecteerde renderers en forceert een nieuwe geïsoleerde render. Dit is handig bij het testen van wijzigingen in de renderer of bij het onderzoeken van cachecorruptie. Deterministische gebundelde scripts en niet-geregistreerde of aangepaste scripts omzeilen de cache al; gebundelde deterministische inhoud wordt nog steeds in-process weergegeven.

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

Bij gebruik met `-All` kunt u de automatische `Clear-Host`-aanroep tussen colorscripts overslaan, zodat elk weergegeven script zichtbaar blijft boven het volgende. Dit is met name handig als u scripts naast elkaar wilt vergelijken of de hele showcase wilt vastleggen in sessietranscripties.

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

Retourneer het geselecteerde metadata-object van de colorscript naar de pijplijn, naast het weergeven van de colorscript. Het metagegevensobject bevat eigenschappen zoals Name, Path, Category, Tags en Description. Dit maakt programmatische toegang tot scriptinformatie mogelijk voor filtering, logboekregistratie of verdere verwerking, terwijl de visuele uitvoer nog steeds wordt weergegeven.

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

Onderdrukt informatieve berichten met behoud van opdrachtuitvoer en fouten.

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

Vraag expliciet een willekeurige colorscript-selectie aan. Dit is het standaardgedrag als er geen naam is opgegeven, dus deze schakelaar is vooral handig voor duidelijkheid in scripts of als u expliciet wilt zijn over de selectiemodus. Kan worden gecombineerd met `-Category` of `-Tag` om te randomiseren binnen een gefilterde subset.

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

Zend de gerenderde colorscript uit als een string naar de PowerShell-pijplijn in plaats van rechtstreeks naar de consolehost te schrijven. Hierdoor kan de uitvoer worden vastgelegd in een variabele, worden omgeleid naar een bestand of worden doorgesluisd naar andere opdrachten. De uitvoer behoudt alle ANSI-escape-reeksen, zodat deze met de juiste kleuren wordt weergegeven wanneer deze later naar een compatibele terminal wordt geschreven.

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

Schrijft na het renderen van elk geselecteerd colorscript één beknopte regel naar de informatiestroom met de scriptnaam en het volledige pad. `-Quiet` onderdrukt deze regel. `-ReturnText` bevat deze niet en `-PassThru` blijft gestructureerde metagegevens retourneren.

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

Filter de beschikbare scriptverzameling op metagegevenstags (niet hoofdlettergevoelig). Tags zijn specifiekere descriptors dan categorieën, zoals "geometric", "retro", "animated", "minimal", enz. Er kunnen meerdere tags worden opgegeven als een array. Scripts die overeenkomen met een van de opgegeven tags worden in de werkset opgenomen voordat selectie plaatsvindt.

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

Vernieuwt de cache-metagegevensmarkering op moduleniveau voordat deze wordt weergegeven, ook wanneer de cachemap al was geïnitialiseerd in de huidige modulesessie. Het herstelt de uitvoercache-items niet opnieuw en vervangt de normale validatie per item niet. Als u `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE` instelt op `1`, `true` of `yes`, wordt dezelfde vernieuwing gevraagd tijdens de cache-initialisatie.

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

Wanneer u de `-All` gebruikt, pauzeert u na het weergeven van elke colorscript en wacht u op gebruikersinvoer voordat u verdergaat. Druk op de spatiebalk om naar het volgende script in de reeks te gaan. Druk op 'q' om de reeks voortijdig te beëindigen en terug te keren naar de prompt. Dit zorgt voor een interactieve browse-ervaring door de gehele collectie.

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

Deze cmdlet ondersteunt de algemene parameters:
Zie voor meer informatie
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Deze cmdlet accepteert geen pijplijninvoer. Leid voorraadrecords door naar `ForEach-Object` en roep `Show-ColorScript -Name $_.Name` aan bij het samenstellen van een pijplijn.

## OUTPUTS

### System.Object

Wanneer `-PassThru` is opgegeven, wordt het metagegevensobject van de geselecteerde colorscript geretourneerd met eigenschappen zoals Naam, Path, Categorie, Tags en Beschrijving.

### System.String (2)

Wanneer `-ReturnText` is opgegeven, wordt de weergegeven colorscript als een string naar de pijplijn verzonden. Deze string bevat alle ANSI-escape-reeksen voor een juiste kleurweergave wanneer deze wordt weergegeven in een compatibele terminal.

### None

Bij standaardwerking (zonder `-PassThru` of `-ReturnText`) wordt de uitvoer rechtstreeks naar de consolehost geschreven en wordt er niets teruggestuurd naar de pijplijn.

## NOTES

**Auteur:** Nick
**Module:** ColorScripts-Enhanced
**Vereist:** PowerShell 5.1 of hoger

## RELATED LINKS

- [Onlineversie](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

