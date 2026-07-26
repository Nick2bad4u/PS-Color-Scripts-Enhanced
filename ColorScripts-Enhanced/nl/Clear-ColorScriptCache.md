---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Clear-ColorScriptCache
---

# Clear-ColorScriptCache

## SYNOPSIS

Verwijder in de cache opgeslagen colorscript-uitvoerbestanden.

## SYNTAX

### Selection (Default)

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

### Help

```
Clear-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-All] [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

## ALIASES

Deze opdracht heeft geen aliassen.

## DESCRIPTION

De cmdlet `Clear-ColorScriptCache` verwijdert in de cache opgeslagen uitvoerbestanden die zijn gegenereerd door de ColorScripts-Enhanced-module. Elke invoer bestaat uit een weergegeven `<name>.cache`-payload en een begeleidend `<name>.cacheinfo`-validatiemetadatabestand in de effectieve cachemap.

U kunt cache-items selectief verwijderen met behulp van de parameter `-Name` met jokertekenpatronen, of u kunt alle items in één keer verwijderen met de parameter `-All`. `-All` verwijdert ook verweesde begeleidende metadatabestanden waarvan de lading is verwijderd. De cmdlet ondersteunt filteren op `-Category` en `-Tag` om specifieke subsets van in de cache opgeslagen scripts te targeten.

Niet-overeenkomende scriptnamen rapporteren de status `Missing` in de resultaten. Gebruik `-DryRun` om verwijderingsacties te bekijken zonder het bestandssysteem te wijzigen, en `-Path` om een ​​alternatieve cachemap te targeten (handig voor aangepaste cacheconfiguraties of CI/CD-omgevingen).

Geschikte cache-items worden opnieuw gegenereerd wanneer de overeenkomstige, door het beleid geselecteerde renderer wordt weergegeven of `New-ColorScriptCache` wordt aangeroepen. Deterministische gebundelde scripts worden in-process weergegeven en creëren geen cache-items.

Voor automatiseringsscenario's combineert u `-PassThru` om gestructureerde resultaten vast te leggen, `-Quiet` om het samenvattingsbericht te onderdrukken, of `-NoAnsiOutput` om samenvattingen in platte tekst uit te zenden zonder ANSI-kleurcodes.

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

Verwijdert elk cachebestand in de standaard cachemap zonder om bevestiging te vragen. Dit is handig voor het volledig vernieuwen van de cache na module-updates of bij het oplossen van weergaveproblemen.

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

Bekijk een voorbeeld van de cachebestanden met aurora-thema die zouden worden verwijderd zonder ze daadwerkelijk te verwijderen. De uitvoer toont de cachebestanden die overeenkomen met het patroon, zodat u de selectie kunt verifiëren voordat u tot verwijdering overgaat.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name Galaxy -Path $env:TEMP -Confirm:$false
```

Wist het cachebestand voor de in aanmerking komende 'Galaxy'-renderer uit een aangepaste map onder TEMP. Dit is handig bij het testen van `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` of een andere geïsoleerde cachelocatie.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Category Mathematical -WhatIf
```

Laat zien wat er zou gebeuren als cachebestanden voor scripts in de categorie `Mathematical` zouden worden verwijderd. De parameter `-WhatIf` voorkomt verwijdering.

### EXAMPLE 5

```powershell
Get-ColorScriptList -Tag retro | Clear-ColorScriptCache -DryRun
```

Gebruikt pijplijninvoer om een voorbeeld te bekijken van de verwijdering van cachebestanden voor alle scripts die zijn getagd als 'retro'. Combineert filteren op tag met een proefvoorbeeld voordat de verwijdering wordt doorgevoerd.

### EXAMPLE 6

```powershell
Clear-ColorScriptCache -Name 'test-*', 'demo-*' -Confirm:$false
```

Verwijdert cachebestanden voor alle scripts waarvan de naam begint met 'test-' of 'demo-' zonder bevestiging. Er kunnen meerdere jokertekenpatronen als array worden opgegeven.

### EXAMPLE 7

```powershell
# Wis bestaande cachebestanden en bouw door het beleid geselecteerde vermeldingen opnieuw op
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -PassThru | Measure-Object
Write-Host "Cache opnieuw opgebouwd"
```

Wist alle cachepayloads, bouwt de door het dynamische cachebeleid geselecteerde vermeldingen opnieuw op en toont vervolgens statistieken voor die opnieuw opgebouwde vermeldingen.

### EXAMPLE 8

```powershell
# Wis oude cachegegevens die ouder zijn dan 30 dagen
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$thirtyDaysAgo = (Get-Date).AddDays(-30)
Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $thirtyDaysAgo } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
Write-Host "Oude cachebestanden opgeschoond"
```

Verwijdert cachebestanden die al meer dan 30 dagen niet zijn bijgewerkt.

### EXAMPLE 9

```powershell
# Cachebeheerrapport
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$beforeCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Clear-ColorScriptCache -Category Geometric -Confirm:$false
$afterCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Write-Host "$($beforeCount - $afterCount) geometrische cachebestanden gewist"
```

Toont statistieken over bewerkingen voor het opruimen van de cache.

### EXAMPLE 10

```powershell
# Probleemoplossing - specifiek script wissen en opnieuw opbouwen
$scriptName = "Galaxy"
Clear-ColorScriptCache -Name $scriptName -Confirm:$false
New-ColorScriptCache -Name $scriptName -Force
Show-ColorScript -Name $scriptName
```

Wist de cache voor één renderer die volgens het beleid in aanmerking komt, bouwt deze opnieuw op en geeft de renderer vervolgens ter verificatie weer.

### EXAMPLE 11

```powershell
# Filter op meerdere categorieën
Clear-ColorScriptCache -Category Geometric,Abstract -DryRun -PassThru |
    Select-Object CacheFile |
    Measure-Object
```

Toont hoeveel cachebestanden zouden worden verwijderd als er op meerdere categorieën zou worden gefilterd.

## PARAMETERS

### -All

Selecteer elk cache-item in de doelmap. `-Category` en `-Tag` kunnen de parameterset met alle selecties verder beperken; `-Name` behoort in plaats daarvan tot de selectieparameterset.

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

Filter de doelscripts op categorie voordat u cache-items evalueert. Alleen cachebestanden voor scripts die overeenkomen met de opgegeven categorieën komen in aanmerking voor verwijdering. Accepteert een reeks categorienamen en kan worden gecombineerd met `-Tag` voor nauwkeuriger filteren.

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

Vraagt u om bevestiging voordat u de cmdlet uitvoert. Standaard is dit ingeschakeld om het per ongeluk verwijderen van cachebestanden te voorkomen. Gebruik `-Confirm:$false` om de bevestigingsvraag te omzeilen.

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

### -DryRun

Bekijk een voorbeeld van verwijderingsacties zonder bestanden te verwijderen. De cmdlet geeft weer welke cachebestanden worden verwijderd, maar wijzigt het bestandssysteem niet. Dit is handig om uw selectiecriteria te verifiëren voordat u tot verwijdering overgaat.

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

### -Name

Namen of jokertekenpatronen die cachebestanden identificeren die moeten worden verwijderd. Accepteert pijplijninvoer en eigenschapsbinding van objecten met de eigenschap `Name`. Jokertekens (`*`, `?`) worden ondersteund voor patroonafstemming. Wederzijds exclusief met `-All`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
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

Schakel ANSI-kleurreeksen uit in de samenvattingsuitvoer. Dit is handig voor consoles of logprocessors die de ANSI-stijl niet interpreteren, zodat de samenvattingstekst leesbaar blijft in platte tekst.

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

### -PassThru

Retourneer gedetailleerde resultaatobjecten voor elke verwerkte cache-invoer. Zonder deze schakeloptie schrijft de cmdlet alleen een samenvattend bericht. Elke pass-through-record bevat de scriptnaam, het cachebestandspad, de status en eventuele bijbehorende fouttekst voor verdere inspectie of rapportage.

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

### -Path

Alternatieve cachemap om tegen te werken. Standaard ingesteld op het standaard cachepad van de module, indien niet opgegeven. Gebruik deze parameter bij het werken met aangepaste cachelocaties die zijn ingesteld via de omgevingsvariabele `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`, of bij het beheren van cachebestanden in alternatieve mappen voor test- of CI/CD-doeleinden.

```yaml
Type: System.String
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

Onderdruk het samenvattende bericht dat wordt verzonden nadat het verwijderen van de cache is voltooid. Gebruik deze schakelaar bij uitvoering in stille automatiseringscontexten waar alleen gestructureerde uitvoer (zoals `-PassThru`-records, waarschuwingen of fouten) mag worden geproduceerd.

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

Filter de doelscripts op metagegevenstag voordat u cachegegevens evalueert. Alleen cachebestanden voor scripts met overeenkomende tags komen in aanmerking voor verwijdering. Accepteert een reeks tagnamen en kan worden gecombineerd met `-Category` voor meer gedetailleerde controle over welke cachebestanden worden getarget.

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

### -WhatIf

Laat zien wat er zou gebeuren als de cmdlet wordt uitgevoerd zonder de bewerking daadwerkelijk uit te voeren. De cmdlet geeft de acties weer die deze zou uitvoeren, maar wijzigt het bestandssysteem niet. Dit is een standaard gemeenschappelijke PowerShell-parameter die op dezelfde manier werkt als `-DryRun`, maar de ingebouwde conventies van PowerShell volgt.

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

U kunt scriptnamen naar deze cmdlet doorsturen. Elke naam wordt geëvalueerd voor het verwijderen van cachebestanden op basis van de opgegeven parameters.

### System.String[]

U kunt een array met scriptnamen naar deze cmdlet doorsturen. Dit is vooral handig in combinatie met `Get-ColorScriptList` om scripts op verschillende criteria te filteren voordat de caches worden gewist.

### System.Management.Automation.PSObject

U kunt objecten met de eigenschap `Name` naar deze cmdlet doorsluizen. De cmdlet extraheert de eigenschapswaarde `Name` en gebruikt deze om cachebestanden te identificeren die moeten worden verwijderd.

## OUTPUTS

### System.Object

Met `-PassThru` retourneert de cmdlet een statusrecord voor elk verwerkt cachebestand. Elk uitvoerobject bevat de volgende eigenschappen:

- **Status**: het resultaat van de bewerking (`Removed`, `Missing`, `DryRun`, `SkippedByUser` of `Error`)
- **CacheFile**: het volledige pad naar het cachebestand dat is verwerkt
- **Message**: beschrijvende tekst waarin het resultaat van de operatie wordt uitgelegd
- **Name**: de naam van het script dat aan het cachebestand is gekoppeld

## NOTES

**Auteur**: Nick
**Module**: ColorScripts-Enhanced

Cachebestanden worden opgeslagen met de extensie `.cache` in de cachemap van de module. Elk cachebestand komt overeen met een enkele colorscript en bevat de vooraf gegenereerde ANSI-uitvoer.

Geschikte cache-items worden opnieuw gegenereerd wanneer de overeenkomstige, door het beleid geselecteerde renderer wordt weergegeven of `New-ColorScriptCache` wordt aangeroepen. Deterministische gebundelde scripts worden in-process weergegeven en creëren geen cache-items.

Vraag `(Get-ColorScriptConfiguration).Cache.EffectivePath` naar het standaard effectieve pad. Het kan worden overschreven met een blijvende configuratie of `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`; `-Path` richt zich op een andere map voor één aanroep.

Wanneer u `-DryRun` of `-WhatIf` gebruikt, valideert de cmdlet nog steeds dat de cachemap bestaat en rapporteert eventuele problemen, maar voert geen verwijderingen uit.

Voor filteren op `-Category` of `-Tag` moeten de scripts bijbehorende metagegevens hebben. Scripts zonder metagegevens komen niet overeen met deze filters.

### Beste praktijken

- Gebruik altijd `-DryRun` of `-WhatIf` vóór destructieve operaties
- Gebruik `-Confirm:$false` alleen als u zeker bent van de werking
- Archiefcache vóór grote opschoonbewerkingen voor herstel
- Controleer regelmatig de schijfruimte voor cachegroei
- Maak indien mogelijk gebruik van selectieve reiniging in plaats van volledige reiniging
- Houd kritieke scripts bij die niet mogen worden gewist
- Plan automatische opschoningen tijdens onderhoudsvensters
- Test eerst de opschoonbewerkingen in niet-productieomgevingen

### Problemen oplossen (2)

- **"Geen cachebestanden gevonden"**: inspecteer `(Get-ColorScriptConfiguration).Cache.EffectivePath` en gebruik `Export-ColorScriptMetadata -IncludeCacheInfo` om de cachestatus te verifiëren
- **"Toestemming geweigerd"**: Controleer schrijftoegang tot de cachemap
- **"Cache wordt niet opnieuw gegenereerd"**: scripts kunnen weergaveproblemen hebben; testen met `-NoCache`

## RELATED LINKS

- [Onlineversie](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache)

