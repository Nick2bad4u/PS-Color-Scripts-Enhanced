---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/nl/Show-ColorScript.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Show-ColorScript

## SYNOPSIS

Toont een colorscript met automatische caching voor verbeterde prestaties.

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <String[]>] [-Tag <String[]>] [-PassThru]
 [-ReturnText] [<CommonParameters>]
```

### Named

```
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>] [-PassThru]
 [-ReturnText] [<CommonParameters>]
```

### List

```
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>] [-ReturnText]
 [<CommonParameters>]
```

### All

```
Show-ColorScript [-All] [-WaitForInput] [-NoCache] [-Category <String[]>] [-Tag <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION

Render mooie ANSI colorscripts in je terminal met intelligente prestatie-optimalisatie. De cmdlet biedt vier primaire operationele modi:

**Random Mode (Default):** Toont een willekeurig geselecteerde colorscript uit de beschikbare collectie. Dit is het standaardgedrag wanneer geen parameters zijn opgegeven.

**Named Mode:** Toont een specifieke colorscript op naam. Ondersteunt wildcard patronen voor flexibele matching. Wanneer meerdere scripts overeenkomen met een patroon, wordt de eerste match in alfabetische volgorde geselecteerd.

**List Mode:** Toont een geformatteerde lijst van alle beschikbare colorscripts met hun metadata, inclusief naam, categorie, tags en beschrijvingen.

**All Mode:** Cycli door alle beschikbare colorscripts in alfabetische volgorde. Bijzonder nuttig voor het tonen van de gehele collectie of het ontdekken van nieuwe scripts.

**Performance Features:**
Het caching systeem biedt 6-19x prestatieverbeteringen. Bij eerste uitvoering wordt een colorscript normaal uitgevoerd en wordt de uitvoer gecached. Volgende weergaven gebruiken de gecachte uitvoer voor bijna-instant rendering. De cache wordt automatisch ongeldig gemaakt wanneer bronscripts worden gewijzigd, waardoor uitvoer nauwkeurigheid wordt gegarandeerd.

**Filtering Capabilities:**
Filter scripts op categorie of tags voordat selectie plaatsvindt. Dit geldt voor alle modi, waardoor je kunt werken met subsets van de collectie (bijv. alleen natuur-georiënteerde scripts of scripts getagd als "retro").

**Output Options:**
Standaard worden colorscripts direct naar de console geschreven voor onmiddellijke visuele weergave. Gebruik `-ReturnText` om de gerenderde uitvoer naar de pipeline te emitteren voor capture, redirection of verdere verwerking. Gebruik `-PassThru` om het metadata object van het script te ontvangen voor programmatisch gebruik.

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
Type: SwitchParameter
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

Filter de beschikbare scriptcollectie op een of meer categorieën voordat selectie of weergave plaatsvindt. Categorieën zijn typisch brede thema's zoals "Nature", "Abstract", "Art", "Retro", etc. Meerdere categorieën kunnen als array worden opgegeven. Deze parameter werkt in combinatie met alle modi (Random, Named, List, All) om de werkset te beperken.

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
HelpMessage: ""
```

### -Name

De naam van het colorscript om weer te geven (zonder de .ps1 extensie). Ondersteunt wildcard patronen (\* en ?) voor flexibele matching. Wanneer meerdere scripts overeenkomen met een wildcard patroon, wordt de eerste match in alfabetische volgorde geselecteerd en weergegeven. Gebruik `-PassThru` om te verifiëren welk script is gekozen bij gebruik van wildcards.

```yaml
Type: System.String
DefaultValue: None
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
HelpMessage: ""
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
HelpMessage: ""
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
HelpMessage: ""
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
HelpMessage: ""
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
HelpMessage: ""
```

### -Tag

Filter de beschikbare scriptcollectie op metadata tags (hoofdletterongevoelig). Tags zijn meer specifieke descriptors dan categorieën, zoals "geometric", "retro", "animated", "minimal", etc. Meerdere tags kunnen als array worden opgegeven. Scripts die overeenkomen met een van de opgegeven tags worden opgenomen in de werkset voordat selectie plaatsvindt.

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

### -WaitForInput

Wanneer gebruikt met `-All`, pauzeer na het weergeven van elk colorscript en wacht op gebruikersinvoer voordat u doorgaat. Druk op de spatiebalk om door te gaan naar het volgende script in de reeks. Druk op 'q' om de reeks vroegtijdig te beëindigen en terug te keren naar de prompt. Dit biedt een interactieve browse-ervaring door de gehele collectie.

```yaml
Type: SwitchParameter
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

### CommonParameters

Deze cmdlet ondersteunt de algemene parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Voor meer informatie, zie
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

U kunt colorscript-namen naar Show-ColorScript pipen. Dit maakt pipeline-gebaseerde workflows mogelijk waarbij scriptnamen worden gegenereerd of gefilterd door andere commando's.

## OUTPUTS

### System.Object

Wanneer `-PassThru` is opgegeven, retourneert het geselecteerde colorscript's metadata object met eigenschappen zoals Name, Path, Category, Tags, en Description.

### System.String

Wanneer `-ReturnText` is opgegeven, emitteert de gerenderde colorscript als een string naar de pipeline. Deze string bevat alle ANSI escape sequences voor juiste kleurweergave wanneer weergegeven in een compatibele terminal.

### None

In standaardwerking (zonder `-PassThru` of `-ReturnText`), wordt uitvoer direct naar de console host geschreven en wordt niets naar de pipeline geretourneerd.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

**Performance:**
Het intelligente caching systeem biedt 6-19x prestatieverbeteringen ten opzichte van directe uitvoering. Cache bestanden worden opgeslagen in een module-beheerde directory en worden automatisch ongeldig gemaakt wanneer bronscripts worden gewijzigd, waardoor nauwkeurigheid wordt gegarandeerd.

**Cache Management:**

- Cache locatie: Gebruik `(Get-Module ColorScripts-Enhanced).ModuleBase` en zoek naar de cache directory
- Cache wissen: Gebruik `Clear-ColorScriptCache` om vanaf nul te herbouwen
- Cache herbouwen: Gebruik `New-ColorScriptCache` om cache voor alle scripts voor te vullen
- Cache inspecteren: Cache bestanden zijn platte tekst en kunnen direct worden bekeken

**Tips:**

- Voeg `Show-ColorScript -Random` toe aan uw PowerShell profiel voor een kleurrijke begroeting bij elke sessie start
- Gebruik de module alias `scs` voor snelle toegang: `scs -Random`
- Combineer categorie en tag filters voor precieze selectie
- Gebruik `-List` om nieuwe scripts te ontdekken en over hun thema's te leren
- De `-All -WaitForInput` combinatie is perfect voor het presenteren van de collectie aan anderen

**Compatibility:**
Colorscripts use ANSI escape sequences and display best in terminals with full color support, such as Windows Terminal, ConEmu, or modern Unix terminals.

## ADVANCED USAGE

### Filtering Strategies

**By Category and Tag Combination**

```powershell
# Toon alleen geometrische colorscripts getagd als minimaal
Show-ColorScript -Category Geometric -Tag minimal -Random

# Toon alleen aanbevolen colorscripts uit natuur categorie
Show-ColorScript -Category Nature -Tag Recommended -Random

# Toon meerdere categorieën met specifieke tag
Show-ColorScript -Category Geometric,Abstract -Tag colorful -Random
```

**Dynamic Filtering Based on Time**

```powershell
# Ochtend: heldere kleuren
if ((Get-Date).Hour -lt 12) {
    Show-ColorScript -Tag bright,colorful -Random
}
# Avond: donkerdere paletten
else {
    Show-ColorScript -Tag dark,minimal -Random
}
```

### Output Capture Patterns

**Save for Later Viewing**

```powershell
# Opslaan in variabele
$art = Show-ColorScript -Name spectrum -ReturnText
$art | Out-File "./my-art.ansi" -Encoding UTF8

# Later weergeven
Get-Content "./my-art.ansi" -Raw | Write-Host
```

**Create Themed Collections**

```powershell
# Verzamel alle geometrische scripts
$geometric = Get-ColorScriptList -Category Geometric -AsObject

# Sla elk op
$geometric | ForEach-Object {
    Show-ColorScript -Name $_.Name -ReturnText |
        Out-File "./collection/$($_.Name).ansi" -Encoding UTF8
}
```

### Performance Analysis

**Comprehensive Benchmark**

```powershell
# Functie om colorscript prestaties te benchmarken
function Measure-ColorScriptPerformance {
    param([string]$Name)

    # Warm up cache
    Show-ColorScript -Name $Name | Out-Null

    # Cached prestaties
    $cached = Measure-Command { Show-ColorScript -Name $Name }

    # Uncached prestaties
    Clear-ColorScriptCache -Name $Name -Confirm:$false
    $uncached = Measure-Command { Show-ColorScript -Name $Name -NoCache }

    [PSCustomObject]@{
        Script = $Name
        Cached = $cached.TotalMilliseconds
        Uncached = $uncached.TotalMilliseconds
        Improvement = [math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 2)
    }
}

# Test meerdere scripts
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object { Measure-ColorScriptPerformance -Name $_.Name }
```

### Terminal Customization

**Terminal-Specific Display**

```powershell
# Windows Terminal met ANSI ondersteuning
if ($env:WT_SESSION) {
    Show-ColorScript -Category Abstract -Random  # Maximum colors
}

# VS Code terminal
if ($env:TERM_PROGRAM -eq "vscode") {
    Show-ColorScript -Tag simple  # Avoid complex rendering
}

# SSH sessie (mogelijk beperkt)
if ($env:SSH_CONNECTION) {
    Show-ColorScript -NoCache -Category Simple  # Minimal overhead
}

# ConEmu terminal
if ($env:ConEmuANSI -eq "ON") {
    Show-ColorScript -Random  # Full ANSI support
}
```

### Automation Integration

**Scheduled Colorscript Rotation**

```powershell
# Creëer geplande taak wrapper
function Start-ColorScriptSession {
    param(
        [int]$MaxScripts = 5,
        [string[]]$Categories = @("Geometric", "Nature"),
        [int]$DelaySeconds = 2
    )

    Get-ColorScriptList -Category $Categories -AsObject |
        Select-Object -First $MaxScripts |
        ForEach-Object {
            Write-Host "`n=== $($_.Name) ($($_.Category)) ===" -ForegroundColor Cyan
            Show-ColorScript -Name $_.Name
            Start-Sleep -Seconds $DelaySeconds
        }
}
```

### Error Handling and Resilience

**Graceful Fallback**

```powershell
# Probeer specifiek script, fallback naar random
try {
    Show-ColorScript -Name "specific-script" -ErrorAction Stop
} catch {
    Write-Warning "Specifiek script niet gevonden, toon random"
    Show-ColorScript -Random
}
```

**Validation Before Display**

```powershell
# Verificeer script bestaat voordat weergeven
$scripts = Get-ColorScriptList -AsObject
$scriptName = "aurora-waves"

if ($scriptName -in $scripts.Name) {
    Show-ColorScript -Name $scriptName
} else {
    Write-Error "$scriptName niet gevonden"
    Get-ColorScriptList | Out-Host
}
```

### Metadata Inspection

**Inspect Before Displaying**

```powershell
# Verkrijg metadata tijdens weergeven
$metadata = Show-ColorScript -Name aurora-waves -PassThru

Write-Host "`nScript Details:`n"
$metadata | Select-Object Name, Category, Tags, Description | Format-List

# Gebruik metadata voor beslissingen
if ($metadata.Tags -contains "Animated") {
    Write-Host "Dit is een geanimeerd script"
}
```

### SCRIPT CATEGORIES

De module bevat scripts in verschillende categorieën:

- **Geometric**: mandelbrot-zoom, apollonian-circles, sierpinski-carpet
- **Nature**: galaxy-spiral, aurora-bands, crystal-drift
- **Artistic**: kaleidoscope, rainbow-waves, prismatic-rain
- **Gaming**: doom, pacman, space-invaders
- **System**: colortest, nerd-font-test, terminal-benchmark
- **Logos**: arch, debian, ubuntu, windows

### SEE ALSO

- GitHub Repository: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced
- Original inspiration: shell-color-scripts
- PowerShell Documentation: https://docs.microsoft.com/powershell/

### KEYWORDS

- ANSI
- Terminal
- Art
- ASCII
- Color
- Scripts
- Cache
- Performance

### ADVANCED USAGE

#### Building Cache for Specific Categories

Cache alle scripts in de Geometric categorie voor optimale prestaties:

```powershell
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object { New-ColorScriptCache -Name $_.Name }
```

#### Performance Measurement

Meet de prestatieverbetering van caching:

```powershell
# Uncached prestaties (koude start)
Remove-Module ColorScripts-Enhanced -ErrorAction SilentlyContinue
$uncached = Measure-Command {
    Import-Module ColorScripts-Enhanced
    Show-ColorScript -Name "mandelbrot-zoom" -NoCache
}

# Cached prestaties (warme start)
$cached = Measure-Command {
    Show-ColorScript -Name "mandelbrot-zoom"
}

Write-Host "Uncached: $($uncached.TotalMilliseconds)ms"
Write-Host "Cached: $($cached.TotalMilliseconds)ms"
Write-Host "Improvement: $([math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 1))x"
```

#### Automation: Display Different Script Daily

Stel uw profiel in om dagelijks een ander script weer te geven:

```powershell
# In uw $PROFILE bestand:
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random
```

#### Pipeline Operations with Metadata

Exporteer colorscript metadata voor gebruik in andere tools:

```powershell
# Exporteer naar JSON voor web dashboard
Export-ColorScriptMetadata -Path ./dist/colorscripts.json -IncludeFileInfo

# Gebruik in automatisering: roteer door scripts
$scripts = Get-ColorScriptList -Tag Recommended -AsObject
$scripts | ForEach-Object { Show-ColorScript -Name $_.Name; Start-Sleep -Seconds 2 }
```

#### Cache Management for CI/CD Environments

Configureer en beheer cache voor geautomatiseerde deployments:

```powershell
# Stel tijdelijke cache locatie in voor CI/CD
Set-ColorScriptConfiguration -CachePath $env:TEMP\colorscripts-cache

# Bouw cache voor voor deployment
$productionScripts = @('bars', 'arch', 'ubuntu', 'windows', 'rainbow-waves')
New-ColorScriptCache -Name $productionScripts -Force

# Verificeer cache gezondheid
$cacheDir = (Get-ColorScriptConfiguration).Cache.Path
Get-ChildItem $cacheDir -Filter "*.cache" | Measure-Object -Sum Length
```

#### Filtering and Display Workflows

Geavanceerde filtering voor aangepaste weergaven:

```powershell
# Toon alle aanbevolen scripts met details
Get-ColorScriptList -Tag Recommended -Detailed

# Toon geometrische scripts met caching uitgeschakeld voor testen
Get-ColorScriptList -Category Geometric -Name "aurora-*" -AsObject |
    ForEach-Object { Show-ColorScript -Name $_.Name -NoCache }

# Exporteer metadata gefilterd op categorie
Export-ColorScriptMetadata -IncludeFileInfo |
    Where-Object { $_.Category -eq 'Animated' } |
    ConvertTo-Json |
    Out-File "./animated-scripts.json"
```

### INTEGRATION SCENARIOS

#### Scenario 1: Terminal Welcome Screen

```powershell
# In profiel:
$hour = (Get-Date).Hour
if ($hour -ge 6 -and $hour -lt 12) {
    Show-ColorScript -Tag "bright,morning" -Random
} elseif ($hour -ge 12 -and $hour -lt 18) {
    Show-ColorScript -Category Geometric -Random
} else {
    Show-ColorScript -Tag "night,dark" -Random
}
```

#### Scenario 2: CI/CD Pipeline

```powershell
# Build fase decoratie
Show-ColorScript -Name "bars" -NoCache  # Snelle weergave zonder cache
New-ColorScriptCache -Category "Build" -Force  # Bereid voor voor volgende run

# In CI/CD context:
$env:CI = $true
if ($env:CI) {
    Show-ColorScript -NoCache  # Vermijd cache in efemere omgevingen
}
```

#### Scenario 3: Administrative Dashboards

```powershell
# Toon systeem-georiënteerde colorscripts
$os = if ($PSVersionTable.PSVersion.Major -ge 7) { "pwsh" } else { "powershell" }
Show-ColorScript -Name $os -PassThru | Out-Null

# Toon status informatie
Get-ColorScriptList -Tag "system" -AsObject |
    ForEach-Object { Write-Host "Available: $($_.Name)" }
```

#### Scenario 4: Educational Presentations

```powershell
# Interactieve colorscript showcase
Show-ColorScript -All -WaitForInput
# Gebruikers kunnen op spatie drukken om door te gaan, q om te stoppen

# Of met specifieke categorie
Show-ColorScript -All -Category Abstract -WaitForInput
```

#### Scenario 5: Multi-User Environment

```powershell
# Per-gebruiker configuratie
Set-ColorScriptConfiguration -CachePath "\\shared\cache\$env:USERNAME"
Set-ColorScriptConfiguration -DefaultScript "team-logo"

# Gedeelde scripts met gebruiker aanpassing
Get-ColorScriptList -AsObject |
    Where-Object { $_.Tags -contains "shared" } |
    ForEach-Object { Show-ColorScript -Name $_.Name }
```

### ADVANCED TOPICS

#### Topic 1: Cache Strategy Selection

Verschillende caching strategieën voor verschillende scenario's:

**Full Cache Strategy** (Optimaal voor Werkstations)

```powershell
New-ColorScriptCache              # Cache alle 450++ scripts
# Voordelen: Maximale prestaties, directe weergave
# Nadelen: Gebruikt 2-5MB schijfruimte
```

**Selective Cache Strategy** (Optimaal voor Portable/CI)

```powershell
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object { New-ColorScriptCache -Name $_.Name }
# Voordelen: Gebalanceerde prestaties en opslag
# Nadelen: Vereist meer setup
```

**No Cache Strategy** (Optimaal voor Ontwikkeling)

```powershell
Show-ColorScript -NoCache
# Voordelen: Zie script wijzigingen onmiddellijk
# Nadelen: Langzamere weergave, meer resource gebruik
```

#### Topic 2: Metadata Organization

Inzicht in en organiseren van colorscripts per metadata:

**Categories** - Brede organisatorische groeperingen:

- Geometric: Fractals, wiskundige patronen
- Nature: Landschappen, organische thema's
- Artistic: Creatief, abstracte ontwerpen
- Gaming: Game-gerelateerde thema's
- System: OS/technologie georiënteerd

**Tags** - Specifieke descriptors:

- Recommended: Gecureerd voor algemeen gebruik
- Animated: Bewegende/veranderende patronen
- Colorful: Multi-kleur paletten
- Minimal: Eenvoudig, schoon ontwerpen
- Retro: Klassiek 80s/90s esthetiek

#### Topic 3: Performance Optimization Tips

```powershell
# Tip 1: Laad vaak gebruikte scripts voor
New-ColorScriptCache -Name bars,arch,mandelbrot-zoom,aurora-waves

# Tip 2: Controleer cache veroudering
$old = Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddMonths(-1) }

# Tip 3: Gebruik categorie filtering voor snellere selectie
Show-ColorScript -Category Geometric  # Sneller dan volledige set

# Tip 4: Schakel verbose output in voor debugging
Show-ColorScript -Name aurora -Verbose
```

#### Topic 4: Cross-Platform Considerations

```powershell
# Windows Terminal specifiek
if ($env:WT_SESSION) {
    Show-ColorScript -Category Abstract -Random  # Maximum colors
}

# VS Code geïntegreerde terminal
if ($env:TERM_PROGRAM -eq "vscode") {
    Show-ColorScript -Tag simple  # Vermijd complexe rendering
}

# SSH sessie
if ($env:SSH_CONNECTION) {
    Show-ColorScript -NoCache  # Vermijd langzame netwerk cache I/O
}

# Linux/macOS terminal
if ($PSVersionTable.PSVersion.Major -ge 7) {
    Show-ColorScript -Category Nature  # Gebruik Unix-vriendelijke scripts
}
```

#### Topic 5: Scripting and Automation

```powershell
# Creëer herbruikbare functie voor dagelijkse begroeting
function Show-DailyColorScript {
    $seed = (Get-Date).DayOfYear
    Get-Random -SetSeed $seed
    Show-ColorScript -Random -Category @("Geometric", "Nature") -Random
}

# Gebruik in profiel
Show-DailyColorScript

# Creëer script rotatie functie
function Invoke-ColorScriptSlideshow {
    param(
        [int]$Interval = 3,
        [string[]]$Category,
        [int]$Count
    )

    $scripts = if ($Category) {
        Get-ColorScriptList -Category $Category -AsObject
    } else {
        Get-ColorScriptList -AsObject
    }

    $scripts | Select-Object -First $Count | ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds $Interval
    }
}

# Gebruik
Invoke-ColorScriptSlideshow -Interval 2 -Category Geometric -Count 5
```

### TROUBLESHOOTING GUIDE

#### Issue 1: Scripts Not Displaying Correctly

**Symptomen**: Vervormde karakters of ontbrekende kleuren
**Oplossingen**:

```powershell
# Stel UTF-8 encoding in
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Controleer of terminal UTF-8 ondersteunt
Write-Host "Test: ✓ ✗ ◆ ○" -ForegroundColor Green

# Gebruik nerd font test
Show-ColorScript -Name nerd-font-test

# Als nog steeds gebroken, schakel cache uit
Show-ColorScript -Name yourscript -NoCache
```

#### Issue 2: Module Import Failures

**Symptomen**: "Module niet gevonden" of import fouten
**Oplossingen**:

```powershell
# Controleer of module in PSModulePath staat
Get-Module ColorScripts-Enhanced -ListAvailable

# Toon beschikbare module paden
$env:PSModulePath -split [System.IO.Path]::PathSeparator

# Herinstalleer module
Remove-Module ColorScripts-Enhanced
Uninstall-Module ColorScripts-Enhanced
Install-Module -Name ColorScripts-Enhanced -Force
```

#### Issue 3: Cache Not Being Used

**Symptomen**: Scripts draaien langzaam elke keer
**Oplossingen**:

```powershell
# Verificeer cache bestaat
$cacheDir = (Get-ColorScriptConfiguration).Cache.Path
Get-ChildItem $cacheDir -Filter "*.cache" | Measure-Object

# Herbouw cache
Remove-Item "$cacheDir\*" -Confirm:$false
New-ColorScriptCache -Force

# Controleer voor cache pad problemen
Get-ColorScriptConfiguration | Select-Object -ExpandProperty Cache
```

#### Issue 4: Profile Not Running

**Symptomen**: Colorscript toont niet bij PowerShell opstart
**Oplossingen**:

```powershell
# Verificeer profiel bestaat
Test-Path $PROFILE

# Controleer profiel inhoud
Get-Content $PROFILE | Select-String "ColorScripts"

# Repareer profiel
Add-ColorScriptProfile -Force

# Test profiel handmatig
. $PROFILE
```

### FAQ

**Q: Hoeveel colorscripts zijn beschikbaar?**
A: 450++ ingebouwde scripts over meerdere categorieën en tags

**Q: Hoeveel schijfruimte gebruikt caching?**
A: Ongeveer 2-5MB totaal voor alle scripts, ongeveer 2-50KB per script

**Q: Kan ik colorscripts gebruiken in scripts/automtisering?**
A: Ja, gebruik `-ReturnText` om uitvoer vast te leggen of `-PassThru` voor metadata

**Q: Hoe creëer ik aangepaste colorscripts?**
A: Gebruik `New-ColorScript` om een sjabloon te scaffolden, voeg dan uw ANSI kunst toe

**Q: Wat als ik geen kleuren wil bij opstart?**
A: Gebruik `Add-ColorScriptProfile -SkipStartupScript` om te importeren zonder auto-weergave

**Q: Kan ik dit gebruiken op macOS/Linux?**
A: Ja, met PowerShell 7+ die cross-platform draait

**Q: Hoe deel ik colorscripts met collega's?**
A: Exporteer metadata met `Export-ColorScriptMetadata` of deel script bestanden

**Q: Is caching altijd ingeschakeld?**
A: Nee, gebruik `-NoCache` om caching uit te schakelen voor ontwikkeling/testen

### BEST PRACTICES

1. **Installeer van PowerShell Gallery**: Gebruik `Install-Module` voor automatische updates
2. **Voeg toe aan Profiel**: Gebruik `Add-ColorScriptProfile` voor automatische startup integratie
3. **Bouw Cache Voor**: Draai `New-ColorScriptCache` na installatie voor optimale prestaties
4. **Gebruik Betekenisvolle Namen**: Wanneer aangepaste scripts creërend, gebruik beschrijvende namen
5. **Houd Metadata Bijgewerkt**: Update ScriptMetadata.psd1 wanneer scripts toevoegend
6. **Test in Verschillende Terminals**: Verificeer scripts correct weergeven over uw omgevingen
7. **Monitor Cache Grootte**: Controleer periodiek cache directory grootte en schoon indien nodig
8. **Gebruik Categorieën/Tags**: Maak gebruik van filtering voor snellere script ontdekking
9. **Documenteer Aangepaste Scripts**: Voeg beschrijvingen en tags toe aan aangepaste colorscripts
10. **Backup Configuratie**: Exporteer configuratie voordat grote wijzigingen

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

**Performance:**
The intelligent caching system provides 6-19x performance improvements over direct execution. Cache files are stored in a module-managed directory and are automatically invalidated when source scripts are modified, ensuring accuracy.

**Cache Management:**

- Cache location: Use `(Get-Module ColorScripts-Enhanced).ModuleBase` and look for the cache directory
- Clear cache: Use `Clear-ColorScriptCache` to rebuild from scratch
- Rebuild cache: Use `New-ColorScriptCache` to pre-populate cache for all scripts
- Inspect cache: Cache files are plain text and can be viewed directly

**Advanced Tips:**

- Use `-PassThru` to get metadata while displaying for post-processing
- Combine `-ReturnText` with pipeline commands for advanced text manipulation
- Use `-NoCache` during development of custom colorscripts for immediate feedback
- Filter by multiple categories/tags for more precise selection
- Store frequently-used scripts in variables for quick access
- Use `-List` with `-Category` and `-Tag` to explore available content
- Monitor cache hits with performance measurements
- Consider terminal capabilities when selecting scripts
- Use environment variables to customize behavior per environment
- Implement error handling for automated display scenarios

**Terminal Compatibility Matrix:**

| Terminal           | ANSI Support | UTF-8     | Performance | Notes                      |
| ------------------ | ------------ | --------- | ----------- | -------------------------- |
| Windows Terminal   | ✓ Excellent  | ✓ Full    | Excellent   | Recommended                |
| ConEmu             | ✓ Good       | ✓ Full    | Good        | Legacy but reliable        |
| VS Code            | ✓ Good       | ✓ Full    | Very Good   | Slight rendering delay     |
| PowerShell ISE     | ✗ Limited    | ✗ Limited | N/A         | Not recommended            |
| SSH Terminal       | ✓ Varies     | ✓ Depends | Varies      | Network latency may affect |
| Windows 10 Console | ✗ No         | ✓ Yes     | N/A         | Not recommended            |

## RELATED LINKS

- [Get-ColorScriptList](Get-ColorScriptList.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
