---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Export-ColorScriptMetadata
---

# Export-ColorScriptMetadata

## SYNOPSIS

Exporteert uitgebreide metagegevens voor alle colorscripts naar JSON-indeling of verzendt gestructureerde objecten naar de pijplijn.

## SYNTAX

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-h] [-IncludeFileInfo] [-IncludeCacheInfo]
 [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Deze opdracht heeft geen aliassen.

## DESCRIPTION

De cmdlet `Export-ColorScriptMetadata` stelt een uitgebreide inventaris samen van alle colorscripts in de catalogus van de module en genereert een gestructureerde dataset waarin elk item wordt beschreven. Deze metagegevens bevatten essentiële informatie zoals scriptnamen, categorieën, tags en optionele verrijkingen.

Standaard retourneert de cmdlet PowerShell-objecten naar de pijplijn. Wanneer de parameter `-Path` wordt opgegeven, worden de metagegevens als JSON naar het opgegeven bestand geschreven, waarbij automatisch bovenliggende mappen worden gemaakt als deze niet bestaan.

De cmdlet biedt twee optionele verrijkingsvlaggen:

- **IncludeFileInfo**: voegt metagegevens van het bestandssysteem toe, inclusief volledige paden, bestandsgroottes (in bytes) en tijdstempels van de laatste wijziging
- **IncludeCacheInfo**: voegt cachegerelateerde informatie toe, waaronder cachebestandspaden, bestaansstatus en cachetijdstempels

Deze cmdlet is met name handig voor:

- Documentatie of dashboards maken met alle beschikbare colorscripts
- Rapporteren van de aanwezigheid van onbewerkte cache-payload-bestanden en tijdstempels
- Het invoeren van metadata naar externe tools of automatiseringspijplijnen
- Controle van de colorscript-inventaris en de status van het bestandssysteem
- Rapporten genereren over het gebruik en de organisatie van de colorscript

De uitvoer is consistent geordend, waardoor deze geschikt is voor versiebeheer en diff-bewerkingen bij export naar JSON.

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

Exporteert basismetagegevens voor alle colorscripts naar de pijplijn zonder bestands- of cache-informatie.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

Retourneert objecten met bestandssysteemdetails (volledig pad, grootte en laatste schrijftijd) voor elke colorscript.

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

Genereert een JSON-bestand met basismetagegevens en schrijft dit naar de map `dist`, waarbij de map wordt gemaakt als deze niet bestaat.

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

Genereert een uitgebreid JSON-bestand met verrijkte metagegevens, inclusief bestandssysteem- en cache-informatie, en schrijft dit naar de `dist`-directory.

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeCacheInfo -PassThru | Where-Object { -not $_.CacheExists }
```

Schrijft het metadatabestand en retourneert records waarvan de onbewerkte `.cache`-payload ontbreekt. Dit rapporteert alleen de bestandsbezetting, niet de geschiktheid, geldigheid of actualiteit van de cache.

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

Groepeert colorscripts op categorie en geeft tellingen weer, handig voor het analyseren van de distributie van scripts over categorieën.

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property ScriptSizeBytes -Sum).Sum
Write-Host "Totale grootte van alle colorscripts: $($totalSize / 1KB) KB"
```

Berekent de totale schijfruimte die door alle colorscript-bestanden wordt gebruikt.

### EXAMPLE 8

```powershell
# Genereer statistieken en sla rapporten op
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachePayloadFiles = ($metadata | Where-Object CacheExists).Count
    TotalScriptSizeBytes = ($metadata | Measure-Object ScriptSizeBytes -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

Genereert voorraadstatistieken en telt onbewerkte `.cache`-payloadbestanden. De aanwezigheid van een payload is geen controle op geschiktheid, geldigheid of actualiteit van de cache.

### EXAMPLE 9

```powershell
# Exporteer en vergelijk met vorige back-up
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "Nieuwe scripts: $($new.Count) | Verwijderde scripts: $($removed.Count)"
```

Vergelijkt huidige metadata met een eerdere versie om wijzigingen te identificeren.

### EXAMPLE 10

```powershell
# Bouw een API-reactie voor een webdashboard
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

Genereert API-ready JSON met versiebeheer en tijdstempelinformatie.

### EXAMPLE 11

```powershell
# Bouw of valideer alle door het beleid geselecteerde cache-items en bekijk de statussen.
$results = New-ColorScriptCache -All -PassThru
$results | Group-Object Status | Select-Object Name, Count
```

Gebruikt het cachebeleid als de bron van de waarheid en rapporteert of in aanmerking komende vermeldingen zijn bijgewerkt, al actueel zijn, zijn overgeslagen of zijn mislukt.

### EXAMPLE 12

```powershell
# Maak een HTML-galerij van metadata
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$html = @"
<html>
<head><title>ColorScripts-Enhanced Gallery</title></head>
<body>
<h1>ColorScripts-Enhanced</h1>
<ul>
"@
foreach ($script in $metadata) {
    $html += "<li><strong>$($script.Name)</strong> [$($script.Category)]</li>`n"
}
$html += "</ul></body></html>"
$html | Out-File "./gallery.html" -Encoding UTF8
```

Creëert een HTML-galerijpagina met alle beschikbare colorscripts.

### EXAMPLE 13

```powershell
# Controleer de scriptgroottes in de loop van de tijd
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object ScriptSizeBytes -Average).Average) bytes avg" }
```

Houdt wijzigingen in de bestandsgrootte bij voor individuele scripts over meerdere exportbewerkingen.

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
DefaultValue: False
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

### -IncludeCacheInfo

Voegt het onbewerkte `.cache`-payloadpad, de vlag voor de aanwezigheid van bestanden en de tijdstempel voor het laatst schrijven toe aan elke record. In deze velden wordt niet gerapporteerd over de geschiktheid van het cachebeleid, de aanwezigheid, geldigheid of actualiteit van het begeleidende `.cacheinfo`-metadatabestand.

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
HelpMessage: ''
```

### -IncludeFileInfo

Bevat bestandssysteemdetails (volledig pad, grootte in bytes en laatste schrijftijd) in elke record. Wanneer metagegevens van bestanden niet kunnen worden gelezen (vanwege machtigingen of ontbrekende bestanden), worden fouten geregistreerd via uitgebreide uitvoer en worden de betreffende eigenschappen ingesteld op nulwaarden. Deze schakelaar is waardevol voor het controleren van bestandsgroottes en wijzigingsdatums.

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
HelpMessage: ''
```

### -PassThru

Retourneert de metagegevensobjecten naar de pijplijn, zelfs als de parameter `-Path` is opgegeven. Hierdoor kunt u met één opdracht zowel de metagegevens in een bestand opslaan als aanvullende verwerking of filtering op de objecten uitvoeren. Zonder deze schakelaar onderdrukt het opgeven van `-Path` de pijplijnuitvoer.

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
HelpMessage: ''
```

### -Path

Specificeert het doelbestandspad voor de JSON-export. Ondersteunt relatieve paden, absolute paden, omgevingsvariabelen (bijv. `$env:TEMP\metadata.json`) en tilde-uitbreiding (bijv. `~/Documents/metadata.json`). Bovenliggende mappen worden automatisch aangemaakt als ze niet bestaan. Wanneer deze parameter wordt weggelaten, voert de cmdlet objecten rechtstreeks uit naar de pijplijn in plaats van naar een bestand te schrijven. De JSON-uitvoer is geformatteerd met inspringing voor leesbaarheid.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Voert de opdracht uit in een modus die alleen rapporteert wat er zou gebeuren zonder de acties uit te voeren.

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

### None

Deze cmdlet accepteert geen pijplijninvoer.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Als `-Path` niet is opgegeven of als `-PassThru` wordt gebruikt, retourneert de cmdlet aangepaste objecten. Elk object vertegenwoordigt een enkele colorscript met de volgende basiseigenschappen:

- **Name**: de bestandsnaam van de colorscript zonder extensie
- **Category**: de primaire organisatiecategorie
- **Categories**: alle toegewezen categorieën
- **Tags**: een reeks beschrijvende tags voor filteren en zoeken
- **Description**: De metadatabeschrijving

Wanneer `-IncludeFileInfo` is opgegeven, zijn deze aanvullende eigenschappen inbegrepen:

- **ScriptPath**: het volledige bestandssysteempad naar het scriptbestand
- **ScriptSizeBytes**: Grootte in bytes (null als bestand niet toegankelijk is)
- **ScriptLastWriteTimeUtc**: UTC-tijdstempel van de laatste wijziging (null indien niet beschikbaar)

Wanneer `-IncludeCacheInfo` is opgegeven, zijn deze aanvullende eigenschappen inbegrepen:

- **CachePath**: het volledige pad naar het bijbehorende cachebestand
- **CacheExists**: Booleaanse waarde die aangeeft of er een cachebestand bestaat
- **CacheLastWriteTimeUtc**: UTC-tijdstempel van wijziging van cachebestand (null als cache niet bestaat)

## NOTES

Geen.

## RELATED LINKS

- [Onlineversie](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)

