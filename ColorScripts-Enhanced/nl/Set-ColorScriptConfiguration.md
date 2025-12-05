---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/nl/Set-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Wijzigt de configuratie-instellingen van ColorScripts-Enhanced.

## SYNTAX

```text
Set-ColorScriptConfiguration [-CachePath <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Bijwerkt de configuratie-instellingen van ColorScripts-Enhanced met persistente opslag. Deze cmdlet maakt het mogelijk om het gedrag van de module aan te passen via door de gebruiker configureerbare opties.

Configureerbare instellingen omvatten:

- Cache directory locatie
- Prestatie-optimalisatievoorkeuren
- Standaard weergavegedrag
- Module operationele instellingen

Wijzigingen worden automatisch opgeslagen in gebruikersspecifieke configuratiebestanden en blijven bestaan over PowerShell sessies heen. Gebruik Get-ColorScriptConfiguration om huidige instellingen te bekijken.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath "C:\MyCache"
```

Stelt een aangepast cache directory pad in.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -CachePath $env:TEMP
```

Gebruikt de systeem temp directory voor cache opslag.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "~/.colorscript-cache"
```

Stelt cache pad in met Unix-stijl home directory notatie.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -WhatIf
```

Toont welke configuratiewijzigingen zouden worden gemaakt zonder ze toe te passen.

### EXAMPLE 5

```powershell
# Backup current config, modify, then restore if needed
$currentConfig = Get-ColorScriptConfiguration
Set-ColorScriptConfiguration -CachePath "D:\Cache"
# ... test new configuration ...
# Set-ColorScriptConfiguration -CachePath $currentConfig.CachePath
```

Demonstreert configuratie backup en herstel.

## PARAMETERS

### -CachePath

Specificeert het directory pad waar colorscript cache bestanden worden opgeslagen.

```yaml
Type: System.String
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

### -WhatIf

Toont wat er zou gebeuren als de cmdlet wordt uitgevoerd. De cmdlet wordt niet uitgevoerd.

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

### None (2)

Deze cmdlet retourneert geen uitvoer naar de pipeline.

## NOTES

**Auteur:** Nick
**Module:** ColorScripts-Enhanced
**Vereist:** PowerShell 5.1 of later

## Configuratie Persistentie
Instellingen worden automatisch opgeslagen in gebruikersspecifieke configuratiebestanden en blijven bestaan over PowerShell sessies heen.

## Pad Resolutie
Cache paden ondersteunen omgevingsvariabelen, relatieve paden, en standaard PowerShell pad notatie.

## Validatie
Configuratiewijzigingen worden gevalideerd voordat toepassing om ongeldige instellingen te voorkomen.

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)

### VERSION HISTORY

#### Version 2025.10.09

- Verbeterd cachesysteem met OS-brede cache
- 6-19x prestatieverbetering
- Gecentraliseerde cachelocatie in AppData
- 450++ colorscripts inbegrepen
- Volledige commentaar-gebaseerde helpdocumentatie
- Module manifest verbeteringen
- Geavanceerd configuratiebeheer
- Metadata exportmogelijkheden
- Profiel integratie helpers

### COPYRIGHT

Copyright (c) 2025. Alle rechten voorbehouden.

### LICENSE

Gelicentieerd onder MIT-licentie. Zie LICENSE-bestand voor details.
