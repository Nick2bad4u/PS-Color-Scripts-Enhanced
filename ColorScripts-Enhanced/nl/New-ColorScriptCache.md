---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

Bouw colorscript-cachebestanden vooraf op of vernieuw ze voor snellere weergave.

## SYNTAX

### Selection (Default)

```
New-ColorScriptCache [-Name <string[]>] [-Force] [-PassThru] [-Category <string[]>]
 [-Tag <string[]>] [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon]
 [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Category <string[]>] [-Tag <string[]>]
 [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon] [-WhatIf] [-Confirm]
```

## ALIASES

- `Build-ColorScriptCache`
- `Update-ColorScriptCache`

## DESCRIPTION

`New-ColorScriptCache` rendert door het beleid geselecteerde computationele colorscripts en slaat de uitvoer ervan op als UTF-8 zonder BOM. Geschikte gebundelde renderers gebruiken het geïsoleerde uitvoeringspad van de module; parallelle werkers zijn beschikbaar op PowerShell 7+. Deterministische gebundelde scripts worden in-process weergegeven en creëren nooit cachebestanden. De aliassen zijn `Update-ColorScriptCache` en `Build-ColorScriptCache`.

U kunt scripts targeten op naam (jokertekens ondersteund), categorie of tag. Als er geen parameters zijn opgegeven, worden de namen in `CachePolicy.psd1` rechtstreeks door de cmdlet omgezet in plaats van dat de volledige verzameling wordt opgesomd. Exacte gebundelde namen gebruiken ook een directe bestandszoekopdracht. Wildcard-, categorie- en tagverzoeken worden alleen opgesomd als hun overeenkomende semantiek dit vereist. Expliciete niet-vermelde scripts worden geretourneerd met de status `SkippedNotRequired` wanneer `-PassThru` wordt gebruikt, en alle verouderde cachebestanden voor die scripts worden verwijderd.

Standaard geeft de cmdlet de voortgang weer, plus een beknopte samenvatting van de cachingbewerking en de effectieve cachemap. Gebruik `-PassThru` om gedetailleerde resultaatobjecten voor elk script te retourneren, die u programmatisch kunt inspecteren op status, standaarduitvoer en foutstromen. Combineer `-Quiet` om de voortgang en de samenvatting volledig te onderdrukken, of `-NoAnsiOutput` om samenvattingen in platte tekst uit te zenden zonder ANSI-kleurcodes voor omgevingen die deze niet ondersteunen.

De cmdlet slaat op intelligente wijze scripts over waarvan de cachebestanden al up-to-date zijn, tenzij u de parameter `-Force` opgeeft. Herhaalde cacheopbouwbewerkingen valideren het kleine begeleidende metadatabestand `<name>.cacheinfo` zonder de weergegeven `<name>.cache`-lading te laden. `-Force` herbouwt in aanmerking komende cachegegevens, maar overschrijft nooit het cachebeleid.

Beide bestanden bevinden zich in `(Get-ColorScriptConfiguration).Cache.EffectivePath`. Het `.cache`-bestand bevat gerenderde terminaluitvoer; `.cacheinfo` bevat alleen validatiemetagegevens. Een begeleidend metadatabestand zonder lading is geen bruikbaar cache-item en wordt bij de volgende cacheopbouw gerepareerd. `Clear-ColorScriptCache -All` verwijdert volledige vermeldingen en verweesde begeleidende metadatabestanden.

Voor snellere reconstructies op multi-coresystemen gebruikt u de `-Parallel`-switch samen met de parameter `-ThrottleLimit` (of `-Threads`) om het aantal werknemers te controleren. De cmdlet keert automatisch terug naar sequentiële uitvoering wanneer er geen parallelle runspaces kunnen worden gemaakt op de huidige host.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Alleen de door het beleid geselecteerde computationele renderers oplossen en opwarmen zonder elk script op te sommen dat bij de module wordt geleverd. Dit is het standaardgedrag als er geen parameters zijn opgegeven.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name Galaxy, 'rose-*'
```

Cache een mix van exacte overeenkomsten en jokertekens. Er worden alleen wedstrijden uit `CachePolicy.psd1` gebouwd; andere wedstrijden rapporteren `SkippedNotRequired` met `-PassThru`.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name Galaxy -Force -PassThru | Format-List
```

Forceer een herbouw van de in aanmerking komende 'Galaxy'-cache, zelfs als deze up-to-date is, en onderzoek het gedetailleerde resultaatobject.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Mathematical' -PassThru
```

Evalueer scripts in de categorie `Mathematical`, cache geschikte renderers en retourneer gedetailleerde resultaten voor elke overeenkomst.

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

Herbouw in aanmerking komende caches voor scripts die zijn getagd met 'geometric' of 'colorful', waardoor regeneratie wordt afgedwongen, zelfs als de caches actueel zijn.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Mathematical -AsObject | New-ColorScriptCache -PassThru
```

Pijplijnvoorbeeld: evalueer scripts in de categorie `Mathematical`, cache alle door beleid geselecteerde renderers en retourneer een resultaat voor elke overeenkomst.

### EXAMPLE 7

```powershell
# Controleer cachestatistieken na het bouwen
$cachePath = (Get-ColorScriptConfiguration).Cache.EffectivePath
$before = @(Get-ChildItem $cachePath -Filter "*.cache" -ErrorAction SilentlyContinue).Count
New-ColorScriptCache
$after = @(Get-ChildItem $cachePath -Filter "*.cache").Count
Write-Host "Scripts in cache: $before -> $after"
```

Meet de cachegroei door door beleid geselecteerde cachebestanden voor en na de bewerking te tellen.

### EXAMPLE 8

```powershell
# Bouw cache voor veelgebruikte computationele renderers
$frequentScripts = @('Galaxy', 'rose-curves', 'wave-interference')
New-ColorScriptCache -Name $frequentScripts -PassThru | Format-Table Name, Status, ExitCode
```

Bouwt caches voor de vermelde scripts die in aanmerking komen onder `CachePolicy.psd1`; niet-vermelde namen worden overgeslagen.

### EXAMPLE 9

```powershell
# Gebruik de ingebouwde beleidsgerichte voortgangsweergave
New-ColorScriptCache -All
```

Toont de ingebouwde voortgang voor door beleid geselecteerde renderers zonder alle beschikbare scripts handmatig te herhalen.

### EXAMPLE 10

```powershell
# Optioneel kunt u ontbrekende of verouderde beleidsvermeldingen uit een PowerShell-profiel primen.
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Quiet
```

Controleert door het beleid geselecteerde vermeldingen wanneer het profiel wordt geladen en bouwt alleen ontbrekende of verouderde vermeldingen op. Sla deze profielstap over als opstartcachewerk niet gewenst is.

### EXAMPLE 11

```powershell
# Bouw elk door beleid geselecteerd item opnieuw op voor implementatie
New-ColorScriptCache -All -Force -PassThru |
    Select-Object Name, Status |
    Export-Csv "./cache-deployment.csv"
```

Bouwt elk door beleid geselecteerd cache-item opnieuw op en exporteert de statussen naar een implementatiemanifest.

### EXAMPLE 12

```powershell
# Zoek fouten bij het bouwen van de cache
New-ColorScriptCache -Name "Galaxy" -Force -PassThru |
    Where-Object Status -eq 'Failed' |
    Select-Object Name, StdErr
```

Identificeert caching-fouten zonder het overslaan van beleid als fouten te behandelen.

### EXAMPLE 13

```powershell
# Tel door het beleid geselecteerde vermeldingen die door deze uitvoering zijn bijgewerkt
New-ColorScriptCache -All -PassThru |
    Where-Object Status -eq 'Updated' |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

Controleert elk door het beleid geselecteerd item en laat zien hoeveel cachepayloads er tijdens deze run zijn bijgewerkt.

### EXAMPLE 14

```powershell
New-ColorScriptCache -All -Parallel -Threads 8
```

Bouw alle door het beleid geselecteerde caches met behulp van acht werkthreads. De cmdlet valt automatisch terug naar sequentiële uitvoering wanneer parallelle taken niet beschikbaar zijn op de huidige host.

## PARAMETERS

### -All

Los elke cachebeleidsinvoer rechtstreeks op. Alleen door beleid geselecteerde scripts worden verwerkt; de volledige colorscript-inventaris wordt niet opgesomd.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

Filtert geëvalueerde scripts op metadatacategorie (niet hoofdlettergevoelig). Meerdere waarden worden behandeld als een OF-filter. Alleen door `CachePolicy.psd1` toegestane overeenkomsten worden in de cache opgeslagen; andere wedstrijden rapporteren `SkippedNotRequired` met `-PassThru`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Vraagt u om bevestiging voordat u de cmdlet uitvoert. Handig bij het cachen van een groot aantal scripts of bij gebruik van `-Force` om onbedoelde cacheregeneratie te voorkomen.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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
HelpMessage: ''
```

### -Force

Herbouw in aanmerking komende cache-items, zelfs als hun `.cacheinfo`-validatiemetagegevens aangeven dat ze actueel zijn. Dit heeft geen voorrang op `CachePolicy.psd1`.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Verouderde compatibiliteitsschakelaar. Deze wordt één release stilzwijgend zonder effect geaccepteerd omdat Pokémon-scripts dezelfde regels in `CachePolicy.psd1` volgen als alle andere scripts.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Een of meer colorscript-namen die moeten worden geëvalueerd voor caching. Ondersteunt jokertekenpatronen (bijvoorbeeld `aurora-*` en `*-wave`). Overeenkomende scripts worden alleen in de cache opgeslagen als ze worden vermeld in `CachePolicy.psd1`. Wanneer deze parameter en alle filters worden weggelaten, worden alleen beleidsitems omgezet en geëvalueerd.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAnsiOutput

Schakel ANSI-kleurreeksen uit in informatieve uitvoer. Dit is handig in omgevingen waarin ANSI-escape-codes niet worden weergegeven (zoals sommige CI/CD-logboeken), terwijl de gekleurde uitvoer desgewenst toch behouden blijft.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- NoColor
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Parallel

Schakel het bouwen van caches met meerdere threads in. Indien opgegeven, voert de cmdlet cachetaken uit in een runspace-pool, voor een snellere voltooiing op geschikte systemen. Gebruik in combinatie met `-ThrottleLimit` (of de alias `-Threads`) om het aantal gelijktijdige werknemers te beheren. Als multi-threading niet kan worden geïnitialiseerd, valt de cmdlet automatisch terug naar sequentiële uitvoering.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Retourneer gedetailleerde resultaatobjecten voor elke cachebewerking. Standaard wordt alleen een samenvatting weergegeven. De resultaatobjecten bevatten eigenschappen zoals Name, Status, CacheFile, ExitCode, StdOut en StdErr, waardoor programmatische inspectie van het cachingproces mogelijk is.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Onderdruk de voortgang per script en de uitvoer van informatieve samenvattingen. Gebruik deze schakelaar wanneer u alleen gestructureerde uitvoer wilt (via `-PassThru`) of wanneer automatiseringsscenario's informatieve berichten moeten dempen terwijl er nog steeds waarschuwingen en fouten naar boven komen.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Filtert geëvalueerde scripts op metadatatag (niet hoofdlettergevoelig). Meerdere waarden worden behandeld als een OF-filter. Alleen door `CachePolicy.psd1` toegestane overeenkomsten worden in de cache opgeslagen; andere wedstrijden rapporteren `SkippedNotRequired` met `-PassThru`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ThrottleLimit

Specificeert het maximale aantal gelijktijdige cachewerknemers wanneer `-Parallel` wordt aangevraagd. Accepteert waarden van 1 tot 256. De standaardwaarde (indien weggelaten) is het aantal logische processors op de huidige machine. Voor het gemak wordt de alias `-Threads` verstrekt. Waarden kleiner dan of gelijk aan één keren automatisch terug naar sequentiële uitvoering.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Threads
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Laat zien wat er zou gebeuren als de cmdlet wordt uitgevoerd zonder de cachebewerkingen daadwerkelijk uit te voeren. Handig om een ​​voorbeeld te bekijken van welke scripts in de cache worden opgeslagen voordat u de bewerking uitvoert.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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
HelpMessage: ''
```

### CommonParameters

Deze cmdlet ondersteunt de algemene parameters:
Zie voor meer informatie
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

U kunt scriptnamen naar deze cmdlet doorsturen. Elke string wordt behandeld als een potentiële scriptnaam en ondersteunt jokertekens.

### System.String[]

U kunt een array met scriptnamen of metagegevensrecords met de eigenschap `Name` naar deze cmdlet doorsturen voor batchverwerking.

## OUTPUTS

### System.Object

Wanneer `-PassThru` is opgegeven, wordt voor elk verwerkt script een aangepast object geretourneerd met de volgende eigenschappen:

- **Name**: de colorscript-naam
- **ScriptPath**: volledig pad naar de bron colorscript
- **CacheFile**: volledig pad naar het gegenereerde cachebestand
- **Status**: `Updated`, `SkippedUpToDate`, `SkippedNotRequired`, `SkippedByUser` of `Failed`
- **Message**: gelokaliseerd statusdetail
- **CacheExists**: of er na de bewerking een uitvoercache bestaat
- **ExitCode**: de afsluitcode van de scriptuitvoering (0 geeft succes aan)
- **StdOut**: standaarduitvoer vastgelegd tijdens scriptuitvoering
- **StdErr**: standaardfoutuitvoer vastgelegd tijdens scriptuitvoering

Schrijft zonder `-PassThru` een beknopte informatieve samenvatting met verwerkte, bijgewerkte, overgeslagen en mislukte tellingen plus de effectieve cachemap.

## NOTES

**Auteur:** Nick
**Module:** ColorScripts-Enhanced

**Aliassen:** `Update-ColorScriptCache` en `Build-ColorScriptCache`.

Cachebestanden worden opgeslagen onder `(Get-ColorScriptConfiguration).Cache.EffectivePath`. Bron- en beleidshandtekeningen in begeleidende metadata worden gebruikt om te bepalen of een item actueel blijft.

De cmdlet slaat alleen renderers op in de cache die uitvoering vereisen en die zijn toegestaan door het cachebeleid. Expliciete statische of niet-vermelde scripts worden gerapporteerd als `SkippedNotRequired` en verouderde vermeldingen worden verwijderd.

## RELATED LINKS

- [Onlineversie](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)

