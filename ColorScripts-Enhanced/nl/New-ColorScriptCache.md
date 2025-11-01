---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/nl/New-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScriptCache

## SYNOPSIS

Vooraf bouwt cache op voor optimalisatie van colorscript prestaties.

## SYNTAX

```
New-ColorScriptCache [[-Name] <string[]>] [-Category <string[]>] [-Tag <string[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Vooraf genereert gecachte uitvoer voor colorscripts om optimale prestaties bij eerste weergave te garanderen. Deze cmdlet voert colorscripts vooraf uit en slaat hun gerenderde uitvoer op voor directe ophalen.

Het cachingsysteem biedt 6-19x prestatieverbeteringen. Bij eerste uitvoering draait een colorscript normaal en wordt de uitvoer gecached. Volgende weergaven gebruiken de gecachte uitvoer voor vrijwel directe rendering. De cache wordt automatisch ongeldig gemaakt wanneer bronscripts worden gewijzigd, waardoor uitvoer nauwkeurigheid wordt gegarandeerd.

Gebruik deze cmdlet om:
- Cache voor te bereiden voor veelgebruikte scripts
- Consistente prestaties over sessies te garanderen
- Cache voor te verwarmen na module-updates
- Opstartprestaties te optimaliseren

De cmdlet ondersteunt selectieve caching op naam, categorie of tags, waardoor gerichte cachevoorbereiding mogelijk is.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Vooraf bouwt cache op voor alle beschikbare colorscripts.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name "spectrum", "aurora-waves"
```

Cachet specifieke colorscripts op naam.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Category Nature
```

Vooraf bouwt cache op voor alle natuur-georiënteerde colorscripts.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Tag animated
```

Cachet alle colorscripts getagd als "animated".

### EXAMPLE 5

```powershell
# Cache scripts for startup optimization
New-ColorScriptCache -Category Geometric -Tag minimal
```

Bereidt cache voor voor lichtgewicht geometrische scripts ideaal voor snelle opstartweergaven.

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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

Specificeer colorscript namen om te cachen. Ondersteunt wildcards (* en ?).

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

**Prestatie Impact:**
Vooraf cachen elimineert uitvoeringstijd bij eerste weergave, waardoor directe visuele feedback wordt geboden. Bijzonder nuttig voor complexe of geanimeerde scripts.

**Cache Beheer:**
Gecachte bestanden worden opgeslagen in module-beheerde directories en automatisch ongeldig gemaakt wanneer bronscripts veranderen. Gebruik Clear-ColorScriptCache om verouderde cache te verwijderen.

**Beste Praktijken:**
- Cache veelgebruikte scripts voor optimale prestaties
- Gebruik selectieve caching om onnodige verwerking te vermijden
- Draai na module-updates om cache geldigheid te garanderen

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
