---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Haalt de huidige configuratie-instellingen van de ColorScripts-Enhanced-module op.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

Deze opdracht heeft geen aliassen.

## DESCRIPTION

`Get-ColorScriptConfiguration` retourneert een kopie van de effectieve moduleconfiguratie. Het huidige schema bevat:

- **Cache-instellingen**: de geconfigureerde overschrijving en opgeloste effectieve cachemap
- **Opstartgedrag**: `AutoShowOnImport`, `ProfileAutoShow` en `DefaultScript`

De configuratie is samengesteld uit meerdere bronnen in volgorde van prioriteit:

1. Standaardinstellingen ingebouwde module (laagste prioriteit)
2. Aanhoudende gebruikersoverschrijvingen uit het configuratiebestand
3. `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` voor het geretourneerde effectieve cachepad

Het configuratiebestand bevindt zich doorgaans op `%APPDATA%\ColorScripts-Enhanced\config.json` op Windows of `~/.config/ColorScripts-Enhanced/config.json` op Unix-achtige systemen.

De geretourneerde hashtabel is een momentopname van de huidige configuratiestatus en kan veilig worden geïnspecteerd, gekloond of geserialiseerd zonder de actieve configuratie te beïnvloeden.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Toont de huidige configuratie met behulp van de standaardtabelweergave, met alle cache- en opstartinstellingen.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Serialiseert de configuratie naar JSON-indeling voor logboekregistratie, foutopsporing of export naar andere tools.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.EffectivePath
```

Haalt de opgeloste cachemap op. `Cache.Path` blijft de optionele, door de gebruiker geconfigureerde override;
`Cache.EffectivePath` toont de map die de module daadwerkelijk gebruikt na de standaardinstellingen van het platform en
omgevingsoverschrijvingen worden toegepast.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.AutoShowOnImport) {
    Write-Host "Opstartscripts zijn ingeschakeld"
}
```

Controleert of opstartscripts zijn ingeschakeld in de huidige configuratie.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Toont alle configuratie-eigenschappen in een gedetailleerd lijstformaat voor uitgebreide inspectie.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Cachepad: $($config.Cache.Path)"
Write-Host "Automatische profielweergave: $($config.Startup.ProfileAutoShow)"
Write-Host "Standaardscript: $($config.Startup.DefaultScript)"
```

Extraheert en toont specifieke configuratie-eigenschappen voor audit- of scriptdoeleinden.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Aangepast cachepad geconfigureerd: $($config.Cache.Path)"
} else {
    Write-Host "Standaardcachepad wordt gebruikt"
}

Write-Host "Effectief cachepad: $($config.Cache.EffectivePath)"
```

Bepaalt of een aangepast cachepad is geconfigureerd versus het gebruik van modulestandaarden.

### EXAMPLE 8

```powershell
$config = Get-ColorScriptConfiguration
$config | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Maakt een back-up van de huidige configuratie naar een JSON-bestand voor archivering of noodherstel.

### EXAMPLE 9

```powershell
# Vergelijk de huidige configuratie met de standaardwaarden
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Bekijk de -WhatIf-uitvoer om te zien wat er zou veranderen
```

Vergelijkt de huidige configuratie met de standaardinstellingen van de module om aangepaste instellingen te identificeren.

### EXAMPLE 10

```powershell
# Controleer configuratiewijzigingen tussen sessies
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Creëert momentopnamen van de configuratie met tijdstempel om wijzigingen in de loop van de tijd bij te houden.

## PARAMETERS

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

### CommonParameters

Deze cmdlet ondersteunt de algemene parameters:
Zie voor meer informatie
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Deze cmdlet accepteert geen pijplijninvoer.

## OUTPUTS

### System.Collections.Hashtable

Retourneert een geneste hashtabel met de volgende structuur:

- **Cache** (hashtabel): cachegerelateerde instellingen
  - **Path** (String): Optionele overschrijving van het persistente cachepad
  - **EffectivePath** (String): Vastgestelde cachemap die momenteel door de module wordt gebruikt
- **Startup** (hashtabel): instellingen voor opstartgedrag
  - **AutoShowOnImport** (Boolean): Of import het opstartweergavegedrag aanroept
  - **ProfileAutoShow** (Boolean): Standaard keuze voor automatische weergave voor beheerde profielblokken
  - **DefaultScript** (String): Optioneel benoemde startup colorscript

## NOTES

**Module-initialisatie**: de configuratie wordt automatisch geïnitialiseerd wanneer de ColorScripts-Enhanced-module wordt geladen. Met deze cmdlet wordt de huidige configuratiestatus in het geheugen opgehaald.

**Geen wijzigingen**: het aanroepen van deze cmdlet is alleen-lezen en wijzigt geen blijvende instellingen of de actieve configuratie.

**Thread Safety**: De geretourneerde hashtabel is een kopie van de configuratie, waardoor deze veilig is voor gelijktijdige toegang en wijziging zonder de interne status van de module te beïnvloeden.

**Performance**: Het ophalen van configuraties is lichtgewicht en geschikt voor frequente oproepen, omdat het de in de cache opgeslagen configuratie in het geheugen retourneert in plaats van vanaf schijf te lezen.

**Configuratiebestandsindeling**: de blijvende configuratie gebruikt de JSON-indeling met UTF-8-codering. Handmatig bewerken wordt ondersteund, maar wordt niet aanbevolen; gebruik in plaats daarvan `Set-ColorScriptConfiguration`.

### Beste praktijken

- Configuratie één keer opvragen en het resultaat opnieuw gebruiken
- Valideer de configuratie voordat u waarden gebruikt
- Controleer de configuratie op drift in de loop van de tijd
- Bewaar back-ups alleen waar ze geen machinespecifieke paden of privégegevens kunnen vrijgeven
- Documenteer eventuele aanpassingen aan de configuratie
- Test configuratiewijzigingen eerst in niet-productieomgeving
- Gebruik configuratie-auditlogboeken voor compliance

## RELATED LINKS

- [Onlineversie](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

