---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Herstel de ColorScripts-Enhanced-configuratie naar de standaardwaarden.

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Deze opdracht heeft geen aliassen.

## DESCRIPTION

`Reset-ColorScriptConfiguration` vervangt de blijvende configuratie door de ingebouwde standaardinstellingen en reset de cachestatus van de module in het geheugen. Wanneer uitgevoerd, doet deze cmdlet het volgende:

- Wist de geconfigureerde overschrijving van het cachepad, zodat de effectieve platformstandaard wordt gebruikt
- Herstelt `AutoShowOnImport`, `ProfileAutoShow` en `DefaultScript`
- Schrijft de standaardconfiguratie naar `config.json`
- Wist de cache/configuratiestatus in het geheugen, zodat volgende bewerkingen de resetwaarden gebruiken

Deze cmdlet ondersteunt de parameters `-WhatIf` en `-Confirm` omdat deze een destructieve bewerking uitvoert door het configuratiebestand te overschrijven. De resetbewerking kan niet automatisch ongedaan worden gemaakt, dus gebruikers moeten overwegen een back-up van hun huidige configuratie te maken met `Get-ColorScriptConfiguration` voordat ze doorgaan.

Gebruik de parameter `-PassThru` om onmiddellijk de nieuw herstelde standaardinstellingen te inspecteren nadat de reset is voltooid.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Reset de configuratie zonder om bevestiging te vragen. Dit is handig bij geautomatiseerde scripts of als u zeker weet dat u de standaardinstellingen wilt herstellen.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

Reset de configuratie en retourneert de resulterende hashtabel voor inspectie, zodat u de standaardwaarden kunt verifiëren.

### EXAMPLE 3

```powershell
# Maak een back-up van de huidige configuratie voordat u deze reset
$backup = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
```

Gebruikt `-WhatIf` om een voorbeeld van de resetbewerking te bekijken zonder deze daadwerkelijk uit te voeren, nadat een back-up is gemaakt van de huidige configuratie.

### EXAMPLE 4

```powershell
Reset-ColorScriptConfiguration -Verbose
```

Reset de configuratie met uitgebreide uitvoer om gedetailleerde informatie over de bewerking te bekijken.

### EXAMPLE 5

```powershell
# Reset de configuratie en wis de cache voor een volledige fabrieksreset
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "Module teruggezet naar de fabrieksinstellingen."
```

Voert een volledige fabrieksreset uit, inclusief configuratie, cache en het opnieuw opbouwen van de cache.

### EXAMPLE 6

```powershell
# Controleer of het resetten is gelukt
$config = Reset-ColorScriptConfiguration -PassThru
if ($null -eq $config.Cache.Path -and $config.Cache.EffectivePath) {
    Write-Host "Configuratie teruggezet naar de platformstandaard"
} else {
    Write-Host "Configuratie teruggezet, maar er wordt een aangepast pad gebruikt: $($config.Cache.Path)"
}
```

Reset en verifieert dat de persistente cache-overschrijving leeg is en dat er een effectief platformpad beschikbaar is.

## PARAMETERS

### -Confirm

Vraagt u om bevestiging voordat u de cmdlet uitvoert.

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

### -PassThru

Retourneer het bijgewerkte configuratieobject nadat het opnieuw instellen is voltooid.

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

### -WhatIf

Laat zien wat er zou gebeuren als de cmdlet wordt uitgevoerd zonder de resetbewerking daadwerkelijk uit te voeren.

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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Zie voor meer informatie
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Deze cmdlet accepteert geen pijplijninvoer.

## OUTPUTS

### System.Collections.Hashtable

Wordt geretourneerd wanneer `-PassThru` is opgegeven.

## NOTES

Het configuratiebestand wordt opgeslagen in de map die is opgelost door `Get-ColorScriptConfiguration`. Standaard is deze locatie platformspecifiek:

- **Windows**: `$env:APPDATA\ColorScripts-Enhanced`
- **Linux/macOS**: `$HOME/.config/ColorScripts-Enhanced`

De omgevingsvariabele `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` kan de standaardlocatie overschrijven als deze is ingesteld vóór het importeren van de module.

## RELATED LINKS

- [Onlineversie](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)

