---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

Geeft een overzicht van de beschikbare colorscripts met optionele filtering en rijke metadata-uitvoer.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

Deze opdracht heeft geen aliassen.

## DESCRIPTION

De cmdlet `Get-ColorScriptList` haalt alle colorscripts op en geeft deze weer die zijn meegeleverd met de ColorScripts-Enhanced-module. Het biedt flexibele filteropties en meerdere uitvoerformaten voor verschillende gebruikssituaties.

Standaard geeft de cmdlet een beknopte opgemaakte tabel weer met scriptnamen en categorieën. De `-Detailed`-switch breidt deze weergave uit met tags en beschrijvingen, waardoor in één oogopslag meer context wordt geboden.

De cmdlet retourneert altijd meta gegevens records naar de succes pijp lijn. Zonder `-AsObject` schrijft het ook een geformatteerde hostweergave; `-AsObject` onderdrukt die hostformattering voor schone automatisering. Records omvatten naam, pad, categorie, categorieën, tags, beschrijving en de oorspronkelijke metagegevenseigenschap.

Met filtermogelijkheden kunt u de lijst verfijnen door:

- **Name**: ondersteunt jokertekenpatronen (bijv. `aurora-*`) voor flexibele matching
- **Category**: filteren op een of meer categorienamen (niet hoofdlettergevoelig)
- **Tag**: filteren op metadatatags zoals "Recommended" of "Animated" (niet hoofdlettergevoelig)

De cmdlet valideert filterpatronen en genereert waarschuwingen voor niet-overeenkomende naampatronen, zodat u mogelijke typefouten of ontbrekende scripts kunt identificeren.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Toont alle beschikbare colorscripts in een compact tabelformaat met de naam en categorie van elk script.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed
```

Toont alle colorscripts met extra kolommen inclusief tags en beschrijvingen voor een uitgebreid overzicht.

### EXAMPLE 3

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

Toont alleen scripts in de categorie "Patterns" met volledige metagegevens, inclusief tags en beschrijvingen.

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

Retourneert gestructureerde objecten voor elk script waarvan de naam overeenkomt met het jokertekenpatroon, en selecteert vervolgens alleen de eigenschappen Name en Tags voor weergave.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

Haalt alle scripts op die zijn getagd als "Recommended" en sorteert ze alfabetisch op naam. Handig voor het vinden van samengestelde scripts die geschikt zijn voor profielintegratie.

### EXAMPLE 6

```powershell
Get-ColorScriptList -AsObject -Category Geometric,Abstract | Where-Object { $_.Tags -contains 'Colorful' }
```

Combineert categorie- en tagfiltering om scripts te vinden die zich in de categorieën Geometrisch of Abstract bevinden en zijn getagd als Kleurrijk.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Name blocks,pipes,matrix -AsObject | ForEach-Object { Show-ColorScript -Name $_.Name }
```

Haalt specifieke benoemde scripts op en voert ze allemaal op volgorde uit, wat de pijplijnintegratie met `Show-ColorScript` demonstreert.

### EXAMPLE 8

```powershell
# Tel scripts per categorie voor inventarisatiedoeleinden
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending
```

Geeft een overzicht van het aantal colorscripts's in elke categorie.

### EXAMPLE 9

```powershell
# Zoek scripts met specifieke trefwoorden in de beschrijving
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

Zoekt naar scripts op basis van hun beschrijvingsinhoud met behulp van patroonvergelijking.

### EXAMPLE 10

```powershell
# Exporteren naar CSV voor externe toolverwerking
Get-ColorScriptList -AsObject -Detailed |
    Select-Object Name, Category, Tags, Description |
    Export-Csv -Path "./colorscripts-inventory.csv" -NoTypeInformation
```

Exporteert de volledige colorscript-inventaris naar CSV-formaat voor gebruik in spreadsheettoepassingen.

### EXAMPLE 11

```powershell
# Controleer op scripts zonder specifieke categorie
$allScripts = Get-ColorScriptList -AsObject
$uncategorized = $allScripts | Where-Object { -not $_.Category }
Write-Host "Scripts zonder categorie: $($uncategorized.Count)"
$uncategorized | Select-Object Name
```

Identificeert scripts waarbij categoriemetagegevens ontbreken.

### EXAMPLE 12

```powershell
# Bouw cache voor gefilterde scripts
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object {
        New-ColorScriptCache -Name $_.Name -PassThru
    } |
    Format-Table Name, Status
```

Evalueert scripts met de tag `Recommended`; er worden alleen renderers gebouwd die in aanmerking komen voor cachebeleid en andere records rapporteren `SkippedNotRequired`.

### EXAMPLE 13

```powershell
# Maak een opgemaakt rapport van alle geometrische scripts
Get-ColorScriptList -Category Geometric -Detailed |
    Out-String |
    Tee-Object -FilePath "./geometric-report.txt"
```

Genereert een gedetailleerd rapport van de geometrische categorie colorscripts en slaat dit op in een bestand.

### EXAMPLE 14

```powershell
# Zoek het eerste script dat overeenkomt met een patroon voor snelle weergave
$script = Get-ColorScriptList -Name "aurora-*" -AsObject | Select-Object -First 1
if ($script) {
    Show-ColorScript -Name $script.Name -PassThru
}
```

Geeft snel het eerste overeenkomende script weer op basis van een jokertekenpatroon.

### EXAMPLE 15

```powershell
# Controleer of alle scripts waarnaar wordt verwezen bestaan voordat u de automatisering uitvoert
$requiredScripts = @("bars", "arch", "mandelbrot-zoom")
$available = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$missing = $requiredScripts | Where-Object { $_ -notin $available }
if ($missing) {
    Write-Warning "Ontbrekende scripts: $($missing -join ', ')"
} else {
    Write-Host "Alle vereiste scripts zijn beschikbaar"
}
```

Valideert dat alle vereiste scripts bestaan voordat de automatisering wordt uitgevoerd.

## PARAMETERS

### -AsObject

Retourneert onbewerkte metagegevensrecordobjecten in plaats van een opgemaakte tabel naar de host te renderen. Dit maakt pijplijnverwerking en programmatische manipulatie van de colorscript-metagegevens mogelijk.

Wanneer deze schakeloptie is opgegeven, kunt u standaard PowerShell-cmdlets zoals `Where-Object`, `Select-Object`, `Sort-Object` en `ForEach-Object` gebruiken om de resultaten verder te verwerken.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -Category

Filtert de lijst zodat deze alleen scripts bevat die tot een of meer opgegeven categorieën behoren. De Category-overeenkomst is hoofdlettergevoelig.

Veel voorkomende categorieën zijn: Patronen, Geometrisch, Abstract, Natuur, Animatie, Tekst, Retro en meer. U kunt meerdere categorieën opgeven om uw zoekopdracht te verbreden.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Detailed

Bevat extra kolommen (tags en beschrijving) bij het weergeven van de opgemaakte tabelweergave. Dit biedt in één oogopslag uitgebreidere informatie over elk script.

Zonder deze schakelaar worden alleen de naam en de primaire categorie weergegeven in de tabeluitvoer.

```yaml
Type: System.Management.Automation.SwitchParameter
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
DefaultValue: ''
SupportsWildcards: false
Aliases:
- help
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

### -Name

Filtert de colorscript-lijst op een of meer scriptnamen. Ondersteunt jokertekens (`*` en `?`) voor flexibele patroonafstemming.

Als een opgegeven patroon met geen enkel script overeenkomt, wordt er een waarschuwing gegenereerd om mogelijke problemen te helpen identificeren. De Name-overeenkomst is hoofdlettergevoelig.

U kunt exacte namen opgeven of patronen zoals `aurora-*` gebruiken om meerdere gerelateerde scripts te matchen.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: (All)
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

### -Quiet

Onderdrukt informatieve berichten met behoud van opdrachtuitvoer en fouten.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### -Tag

Filtert de lijst zodat deze alleen scripts bevat die een of meer opgegeven metagegevenstags bevatten. Het matchen van tags is niet hoofdlettergevoelig.

Veel voorkomende tags zijn: Aanbevolen, Geanimeerd, Kleurrijk, Minimaal, Retro, Complex, Eenvoudig en meer. Tags helpt scripts te categoriseren op visuele stijl, complexiteit of gebruiksscenario.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Zie voor meer informatie
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Deze cmdlet accepteert geen pijplijninvoer.

## OUTPUTS

### System.Object

Retourneert colorscript-metagegevensrecordobjecten met de volgende eigenschappen:

- **Name**: de script-ID die wordt gebruikt met `Show-ColorScript`
- **Path**: het volledige bronpad
- **Category**: de primaire categorie van het script
- **Categories**: Een array van alle categorieën waartoe het script behoort
- **Tags**: een reeks metagegevenstags die het script beschrijven
- **Description**: een voor mensen leesbare beschrijving van de visuele uitvoer van het script
- **Metadata**: het originele metadata-object dat alle onbewerkte scriptinformatie bevat

Zonder `-AsObject` schrijft de cmdlet een opgemaakte tabel naar de host, terwijl de recordobjecten nog steeds worden geretourneerd voor mogelijke pijplijnverwerking.

## NOTES

**Auteur**: Nick
**Module**: ColorScripts-Enhanced

De geretourneerde metadatarecords bieden uitgebreide informatie voor zowel weergave- als automatiseringsdoeleinden. De eigenschap `Name` kan rechtstreeks met de cmdlet `Show-ColorScript` worden gebruikt om specifieke scripts uit te voeren.

Alle filterbewerkingen (Name, Category, Tag) zijn hoofdlettergevoelig en kunnen worden gecombineerd om krachtige query's te maken. Wanneer u jokertekens gebruikt in de parameter `-Name`, genereren ongeëvenaarde patronen waarschuwingen om te helpen bij het oplossen van problemen.

Voor de beste resultaten bij het integreren van colorscripts in uw PowerShell-profiel gebruikt u het `-Tag Recommended`-filter om samengestelde scripts te identificeren die geschikt zijn voor opstartweergave.

### Beste praktijken

- Gebruik altijd `-AsObject` wanneer u resultaten programmatisch moet filteren of manipuleren
- Gebruik `-Detailed` bij interactief verkennen om tags en beschrijvingen te bekijken
- Combineer meerdere filters voor nauwkeurige zoekopdrachten
- Exporteer periodiek metadata om veranderingen in de loop van de tijd bij te houden
- Gebruik resultaatobjecten voor automatisering in plaats van tekstuitvoer te ontleden
- Houd rekening met de prestaties bij het herhaaldelijk uitvoeren van query's (cacheresultaten indien mogelijk)
- Gebruik Group-Object voor analyse en rapportage
- Gebruik Where-Object voor complexe filterlogica

## RELATED LINKS

- [Onlineversie](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)

