---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

Vooraf bouwt cache op voor optimalisatie van colorscript prestaties.

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

Genereert vooraf gecachte uitvoer voor rekenintensieve colorscripts. Alleen renderers in `CachePolicy.psd1` worden uitgevoerd en opgeslagen. Statische of niet-vermelde scripts worden overgeslagen met status `SkippedNotRequired`; hun verouderde cachebestanden worden verwijderd.

Het cachingsysteem bewaart alleen uitvoer voor renderers die in `CachePolicy.psd1` zijn geselecteerd. De cache wordt automatisch ongeldig wanneer bronscripts wijzigen. `-Force` bouwt alleen geschikte cache-items opnieuw en negeert het beleid nooit. Er wordt geen vaste prestatiefactor gegarandeerd.


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
New-ColorScriptCache -Name "Galaxy", "rose-curves"
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

### -All

Processes every renderer selected by CachePolicy.psd1 without enumerating the full static script inventory.

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

Filter scripts om te cachen op een of meer categorieën.

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

Vraagt om bevestiging voordat de cmdlet wordt uitgevoerd.

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

Forceert een rebuild van geschikte cache-items, zelfs wanneer bestaande bestanden actueel zijn, zonder `CachePolicy.psd1` te negeren.

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

Toont gedetailleerde hulp voor deze opdracht zonder de bewerking uit te voeren.

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

Voegt alle Pokémon-scripts (normale en shiny varianten) toe aan de cacheopbouw. Standaard worden Pokémon-scripts overgeslagen; gebruik `-IncludePokemon` om ze op te nemen. Opmerking: deze parameter vervangt de oudere `-ExcludePokemon` — de semantiek is tijdens een refactor omgekeerd (nu opt-in).

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

Specificeer colorscript namen om te cachen. Ondersteunt wildcards (\* en ?).

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

Schakelt ANSI-kleuren in de samenvatting uit en geeft vlakke tekst.

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

Builds eligible cache entries concurrently. Unsupported hosts fall back to sequential execution.

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

Retourneert gedetailleerde resultaatobjecten voor elk script. Zonder deze schakelaar wordt alleen een samenvatting weergegeven.

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

Onderdrukt het samenvattende bericht na afloop.

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

Filter scripts om te cachen op een of meer tags.

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

Sets the maximum number of concurrent cache workers. Threads is an alias for this parameter.

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

Toont wat er zou gebeuren als de cmdlet draait. De cmdlet wordt niet uitgevoerd.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
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

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
