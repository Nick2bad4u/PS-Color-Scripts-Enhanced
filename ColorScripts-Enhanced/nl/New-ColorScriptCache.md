---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/nl/New-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 11/14/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScriptCache

## SYNOPSIS

Vooraf bouwt cache op voor optimalisatie van colorscript prestaties.

## SYNTAX

### Alles

```text
New-ColorScriptCache [-All] [-IncludePokemon] [-Force] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Geselecteerd

```text
New-ColorScriptCache [-Name <String[]>] [-Category <String[]>] [-Tag <String[]>] [-IncludePokemon] [-Force] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Genereert vooraf gecachte uitvoer voor rekenintensieve colorscripts. Alleen renderers in `CachePolicy.psd1` worden uitgevoerd en opgeslagen. Statische of niet-vermelde scripts worden overgeslagen met status `SkippedNotRequired`; hun verouderde cachebestanden worden verwijderd.

Het cachingsysteem biedt 6-19x prestatieverbeteringen voor geselecteerde renderers. De cache wordt automatisch ongeldig wanneer bronscripts wijzigen. `-Force` bouwt alleen geschikte cache-items opnieuw en negeert het beleid nooit.


### -Quiet

Onderdrukt het samenvattende bericht na afloop.

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

### -NoAnsiOutput

Schakelt ANSI-kleuren in de samenvatting uit en geeft vlakke tekst.

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
HelpMessage: ""
```
### -IncludePokemon

Voegt alle Pokémon-scripts (normale en shiny varianten) toe aan de cacheopbouw. Standaard worden Pokémon-scripts overgeslagen; gebruik `-IncludePokemon` om ze op te nemen. Opmerking: deze parameter vervangt de oudere `-ExcludePokemon` — de semantiek is tijdens een refactor omgekeerd (nu opt-in).

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
Gebruik deze cmdlet om:

- Cache voor te bereiden voor veelgebruikte scripts
- Consistente prestaties over sessies te garanderen
- Cache voor te verwarmen na module-updates
- Opstartprestaties te optimaliseren

De cmdlet ondersteunt selectieve caching op naam, categorie of tags, waardoor gerichte cachevoorbereiding mogelijk is.

Standaard verschijnt een korte samenvatting. Gebruik `-PassThru` voor gedetailleerde objecten, `-Quiet` om de samenvatting te verbergen of `-NoAnsiOutput` voor tekst zonder ANSI-kleurcodes.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Evalueert alle beschikbare colorscripts en bouwt alleen cache op voor renderers die door `CachePolicy.psd1` zijn geselecteerd.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name "spectrum", "aurora-waves"
```

Cachet specifieke colorscripts op naam.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Category Nature
```

Evalueert alle natuur-georiënteerde colorscripts en cachet alleen geschikte renderers.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Tag animated
```

Evalueert alle colorscripts met de tag "animated" en cachet alleen geschikte renderers.

### EXAMPLE 5

```powershell
# Cache scripts for startup optimization
New-ColorScriptCache -Category Geometric -Tag minimal
```

Bereidt cache voor lichtgewicht geometrische scripts ideaal voor snelle opstartweergaven.

## PARAMETERS

### -Category

Filter scripts om te cachen op een of meer categorieën.

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
HelpMessage: ''
```

### -Confirm

Vraagt om bevestiging voordat de cmdlet wordt uitgevoerd.

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
HelpMessage: ''
```

### -Force

Forceert een rebuild van geschikte cache-items, zelfs wanneer bestaande bestanden actueel zijn, zonder `CachePolicy.psd1` te negeren.

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

Retourneert gedetailleerde resultaatobjecten voor elk script. Zonder deze schakelaar wordt alleen een samenvatting weergegeven.

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

### -Name

Specificeer colorscript namen om te cachen. Ondersteunt wildcards (\* en ?).

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
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

Filter scripts om te cachen op een of meer tags.

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
HelpMessage: ''
```

### -WhatIf

Toont wat er zou gebeuren als de cmdlet draait. De cmdlet wordt niet uitgevoerd.

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
HelpMessage: ''
```

### CommonParameters

Deze cmdlet ondersteunt de algemene parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Voor meer informatie, zie
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Deze cmdlet accepteert geen invoer van de pipeline.

## OUTPUTS

### System.Object

Retourneert cache bouwresultaten met succes/mislukking status voor elk script.

## NOTES

**Auteur:** Nick
**Module:** ColorScripts-Enhanced
**Vereist:** PowerShell 5.1 of later

## Prestatie Impact
Vooraf cachen elimineert uitvoeringstijd bij eerste weergave, waardoor directe visuele feedback wordt geboden. Bijzonder nuttig voor complexe of geanimeerde scripts.

## Cache Beheer
Gecachte bestanden worden opgeslagen in module-beheerde directories en automatisch ongeldig gemaakt wanneer bronscripts veranderen. Gebruik Clear-ColorScriptCache om verouderde cache te verwijderen.

## Beste Praktijken

- Cache veelgebruikte scripts voor optimale prestaties
- Gebruik selectieve caching om onnodige verwerking te vermijden
- Draai na module-updates om cache geldigheid te garanderen

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
