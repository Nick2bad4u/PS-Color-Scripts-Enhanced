---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/nl/Reset-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Herstel de ColorScripts-Enhanced configuratie naar zijn standaardwaarden.

## SYNTAX

### Default (Default)

```text
Reset-ColorScriptConfiguration [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### \_\_AllParameterSets

```text
Reset-ColorScriptConfiguration [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

`Reset-ColorScriptConfiguration` wist alle persistente configuratie-overschrijvingen en herstelt de module naar zijn fabrieksinstellingen. Wanneer uitgevoerd, doet deze cmdlet:

- Verwijdert alle aangepaste configuratie-instellingen uit het configuratiebestand
- Herstelt het cachepad naar de platformspecifieke standaardlocatie
- Herstelt alle opstartvlaggen (RunOnStartup, RandomOnStartup, etc.) naar hun oorspronkelijke waarden
- Behoudt de configuratiebestandsstructuur terwijl gebruikersaanpassingen worden gewist

Deze cmdlet ondersteunt `-WhatIf` en `-Confirm` parameters omdat het een destructieve bewerking uitvoert door het configuratiebestand te overschrijven. De resetbewerking kan niet automatisch ongedaan worden gemaakt, dus gebruikers moeten overwegen hun huidige configuratie te back-uppen met `Get-ColorScriptConfiguration` voordat ze doorgaan.

Gebruik de `-PassThru` parameter om onmiddellijk de nieuw herstelde standaardinstellingen te inspecteren nadat de reset is voltooid.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Herstelt de configuratie zonder om bevestiging te vragen. Dit is nuttig in geautomatiseerde scripts of wanneer u zeker bent over het resetten naar standaardwaarden.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

Herstelt de configuratie en retourneert de resulterende hashtabel voor inspectie, zodat u de standaardwaarden kunt verifiëren.

### EXAMPLE 3

```powershell
# Backup current configuration before resetting
$backup = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
```

Gebruikt `-WhatIf` om de resetbewerking te bekijken zonder deze daadwerkelijk uit te voeren, na het back-uppen van de huidige configuratie.

### EXAMPLE 4

```powershell
Reset-ColorScriptConfiguration -Verbose
```

Herstelt de configuratie met uitgebreide uitvoer om gedetailleerde informatie over de bewerking te zien.

### EXAMPLE 5

```powershell
# Reset configuration and clear cache for complete factory reset
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "Module reset to factory defaults!"
```

Voert een complete fabrieksreset uit inclusief configuratie, cache en het opnieuw opbouwen van de cache.

### EXAMPLE 6

```powershell
# Verify reset was successful
$config = Reset-ColorScriptConfiguration -PassThru
if ($config.Cache.Path -match "AppData|\.config") {
    Write-Host "Configuration successfully reset to platform default"
} else {
    Write-Host "Configuration reset but using custom path: $($config.Cache.Path)"
}
```

Herstelt en verifieert dat de configuratie is hersteld naar standaardwaarden door het cachepad te controleren.

## PARAMETERS

### -Confirm

Vraagt om bevestiging voordat de cmdlet wordt uitgevoerd.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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
HelpMessage: ""
```

### -PassThru

Retourneert het bijgewerkte configuratieobject nadat de reset is voltooid.

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

### -WhatIf

Toont wat er zou gebeuren als de cmdlet wordt uitgevoerd zonder de resetbewerking daadwerkelijk uit te voeren.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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
HelpMessage: ""
```

### CommonParameters

Deze cmdlet ondersteunt de algemene parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Voor meer informatie, zie
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Deze cmdlet accepteert geen pipeline-invoer.

## OUTPUTS

### System.Collections.Hashtable

Geretourneerd wanneer `-PassThru` is opgegeven.

## NOTES

Het configuratiebestand wordt opgeslagen onder de directory die wordt opgelost door `Get-ColorScriptConfiguration`. Standaard is deze locatie platformspecifiek:

- **Windows**: `$env:LOCALAPPDATA\ColorScripts-Enhanced`
- **Linux/macOS**: `$HOME/.config/ColorScripts-Enhanced`

De omgevingsvariabele `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` kan de standaardlocatie overschrijven indien ingesteld voordat de module wordt geïmporteerd.

## Belangrijke overwegingen

- De resetbewerking is onmiddellijk en kan niet automatisch ongedaan worden gemaakt
- Alle aangepaste kleurenscriptpaden, cachelocaties of opstartgedragingen zullen verloren gaan
- Overweeg `Get-ColorScriptConfiguration` te gebruiken om uw huidige instellingen te exporteren voordat u reset
- De module moet schrijfrechten hebben voor de configuratiedirectory
- Andere PowerShell-sessies die de module gebruiken zullen de wijzigingen zien na hun volgende configuratieherlaad

## Standaardwaarden hersteld

- CachePath: Platformspecifieke standaard cachedirectory
- RunOnStartup: `$false`
- RandomOnStartup: `$false`
- ScriptOnStartup: Lege string
- CustomScriptPaths: Lege array

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
