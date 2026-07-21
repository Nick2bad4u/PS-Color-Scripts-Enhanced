---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Haalt de huidige ColorScripts-Enhanced module configuratie-instellingen op.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

`Get-ColorScriptConfiguration` haalt de effectieve moduleconfiguratie op, die verschillende aspecten van ColorScripts-Enhanced gedrag controleert. Dit omvat:

- **Cache-instellingen**: Locatie waar scriptmetadata en indexen worden opgeslagen voor prestatie-optimalisatie
- **Opstartgedrag**: Vlaggen die controleren of scripts automatisch worden uitgevoerd wanneer PowerShell-sessies starten
- **Padconfiguratie**: Aangepaste scriptmappen en zoekpaden
- **Weergavevoorkeuren**: Standaard opmaak- en uitvoeropties

De configuratie wordt samengesteld uit meerdere bronnen in volgorde van prioriteit:

1. Ingebouwde module-standaardwaarden (laagste prioriteit)
2. Aanhoudende gebruikersoverschrijvingen uit het configuratiebestand
3. Sessiespecifieke wijzigingen (hoogste prioriteit)

Het configuratiebestand bevindt zich doorgaans op `%APPDATA%\ColorScripts-Enhanced\config.json` op Windows of `~/.config/ColorScripts-Enhanced/config.json` op Unix-achtige systemen.

De geretourneerde hashtable is een momentopname van de huidige configuratiestatus en kan veilig worden geïnspecteerd, gekloond of geserialiseerd zonder de actieve configuratie te beïnvloeden.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Toont de huidige configuratie met behulp van de standaard tabelweergave, met alle cache- en opstartinstellingen.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Serialiseert de configuratie naar JSON-formaat voor logging, debugging of exporteren naar andere tools.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.Location
```

Haalt de configuratie op en opent het cachelocatiepad direct vanuit de hashtable.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.Enabled) {
    Write-Host "Startup scripts are enabled"
}
```

Controleert of opstartscripts zijn ingeschakeld in de huidige configuratie.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Toont alle configuratie-eigenschappen in een gedetailleerde lijstindeling voor uitgebreide inspectie.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Cache Path: $($config.Cache.Path)"
Write-Host "Profile Auto-Show: $($config.Startup.ProfileAutoShow)"
Write-Host "Default Script: $($config.Startup.DefaultScript)"
```

Extraheert en toont specifieke configuratie-eigenschappen voor audit- of scriptingdoeleinden.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Custom cache path configured: $($config.Cache.Path)"
} else {
    Write-Host "Using default cache path"
}
```

Bepaalt of een aangepast cachepad is geconfigureerd versus het gebruik van module-standaardwaarden.

### EXAMPLE 8

```powershell
Export-ColorScriptMetadata | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Maakt een back-up van de huidige configuratie naar een JSON-bestand voor archivering of disaster recovery.

### EXAMPLE 9

```powershell
# Compare current config with defaults
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Review the -WhatIf output to see what would change
```

Vergelijkt huidige configuratie met module-standaardwaarden om aangepaste instellingen te identificeren.

### EXAMPLE 10

```powershell
# Monitor configuration changes across sessions
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Creëert tijdstempel-momentopnamen van configuratie voor het volgen van veranderingen in de tijd.

## PARAMETERS

### -h

Toont gedetailleerde hulp voor deze opdracht zonder de bewerking uit te voeren.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Deze cmdlet accepteert geen pipeline-invoer.

## OUTPUTS

### System.Collections.Hashtable

Retourneert een geneste hashtable met de volgende structuur:

- **Cache** (Hashtable): Cache-gerelateerde instellingen
  - **Location** (String): Pad naar de cachemap
  - **Enabled** (Boolean): Of caching actief is
- **Startup** (Hashtable): Opstartgedrag-instellingen
  - **Enabled** (Boolean): Of scripts worden uitgevoerd bij sessiestart
  - **ScriptName** (String): Naam van het standaard opstartscript
- **Paths** (Array): Extra scriptzoekpaden
- **Display** (Hashtable): Uitvoervormgevingsvoorkeuren

## NOTES

**Module Initialisatie**: De configuratie wordt automatisch geïnitialiseerd wanneer de ColorScripts-Enhanced module wordt geladen. Deze cmdlet haalt de huidige in-memory configuratiestatus op.

**Geen Wijzigingen**: Het aanroepen van deze cmdlet is alleen-lezen en wijzigt geen aangehouden instellingen of de actieve configuratie.

**Thread Veiligheid**: De geretourneerde hashtable is een kopie van de configuratie, waardoor het veilig is voor gelijktijdige toegang en wijziging zonder de interne status van de module te beïnvloeden.

**Prestaties**: Configuratie-opvraging is lichtgewicht en geschikt voor frequente aanroepen, aangezien het de gecachte in-memory configuratie retourneert in plaats van van schijf te lezen.

**Configuratiebestand Formaat**: De aangehouden configuratie gebruikt JSON-formaat met UTF-8 codering. Handmatig bewerken wordt ondersteund maar niet aanbevolen; gebruik `Set-ColorScriptConfiguration` in plaats daarvan.

### Beste Praktijken

- Query configuratie eenmaal en hergebruik het resultaat
- Valideer configuratie voordat u waarden gebruikt
- Monitor configuratie voor drift in de tijd
- Houd configuratieback-ups in versiebeheer
- Documenteer eventuele aanpassingen aan configuratie
- Test configuratiewijzigingen eerst in niet-productie
- Gebruik configuratie-auditlogs voor compliance

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

