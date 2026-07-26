---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

Creëer een nieuw colorscript-bestand en zend optioneel metadatabegeleiding uit.

## SYNTAX

### Scaffold

```
New-ColorScript -Name <string> -OutputPath <string> [-h] [-Force] [-GenerateMetadataSnippet]
 [-Category <string[]>] [-Tag <string[]>] [-OpenInEditor] [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScript [-h] [-Name <string>] [-WhatIf] [-Confirm]
```

## ALIASES

Deze opdracht heeft geen aliassen.

## DESCRIPTION

De cmdlet `New-ColorScript` maakt een minimale colorscript-scaffold met daarin een string-array en een lus die elke regel schrijft. Het bestand is gecodeerd als UTF-8 zonder bytevolgordemarkering (BOM). Optionele richtlijnen voor metagegevens kunnen als commentaar in het gegenereerde bestand worden opgenomen en in het resultaatobject worden geretourneerd.

Zowel `-Name` als `-OutputPath` zijn verplicht bij het steigeren. `-OutputPath` identificeert een map; de opdracht maakt de map aan wanneer dat nodig is en schrijft daarin `<Name>.ps1`.

Scriptnamen moeten de naamgevingsconventies van PowerShell volgen: ze moeten beginnen met een alfanumeriek teken en mogen onderstrepingstekens of koppeltekens bevatten. De `.ps1`-extensie wordt automatisch toegevoegd als deze niet is opgegeven. Bestaande bestanden zijn beschermd tegen onbedoelde overschrijvingen, tenzij de schakeloptie `-Force` expliciet is opgegeven.

In combinatie met `-GenerateMetadataSnippet` retourneert de cmdlet richtlijnen die de vermelding beschrijven die moet worden toegevoegd aan `ScriptMetadata.psd1`. De opgegeven categorie- en tagwaarden worden ook geretourneerd als arrays op het resultaatobject.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -OutputPath ./ColorScripts-Enhanced/Scripts -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

Creëert `my-spectrum.ps1` in de gevraagde map en retourneert een object met het bestandspad en de metagegevens.

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

Genereert de steiger onder een aangepaste map (`~/Dev/colorscripts`), waarbij de map wordt gemaakt als deze niet bestaat. Als er al een bestand met de naam `holiday-banner.ps1` op die locatie bestaat, wordt dit overschreven vanwege de `-Force`-switch.

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -OutputPath ./ColorScripts-Enhanced/Scripts -Category 'Artistic' -Tag '80s','Neon' -GenerateMetadataSnippet
$result.MetadataGuidance | Set-Clipboard
```

Creëert een nieuwe colorscript en kopieert de metagegevens naar het klembord, zodat u deze eenvoudig in `ScriptMetadata.psd1` kunt plakken.

### EXAMPLE 4

```powershell
New-ColorScript -Name 'test-pattern' -OutputPath '.\temp' -WhatIf
```

Laat zien wat er zou gebeuren bij het maken van een testpatroonscript in de map `.\temp` zonder het bestand daadwerkelijk te maken. Handig voor het valideren van paden en namen vóór uitvoering.

### EXAMPLE 5

```powershell
# Maak meerdere colorscripts voor een project
$scriptNames = @("company-logo", "team-banner", "status-display")
foreach ($name in $scriptNames) {
    New-ColorScript -Name $name -Category "Corporate" -Tag "Custom" -OutputPath ".\src" | Out-Null
}
Write-Host "$($scriptNames.Count) colorscript-sjablonen gemaakt"
```

Creëert meerdere colorscript-sjablonen in batch voor een project.

### EXAMPLE 6

```powershell
# Maak en open onmiddellijk in de editor
New-ColorScript -Name "my-art" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -GenerateMetadataSnippet -OpenInEditor
```

Creëert een colorscript en vraagt de geregistreerde handler van het platform om deze te openen.

### EXAMPLE 7

```powershell
# Creëer met volledige workflowautomatisering
$newScript = New-ColorScript -Name "interactive-demo" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Custom" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "Gemaakt: $($newScript.Name)"
Write-Host "Pad: $($newScript.Path)"
Write-Host "Metadata-aanwijzingen naar het klembord gekopieerd"
$newScript.MetadataGuidance | Set-Clipboard
```

Creëert een colorscript met metadatabegeleiding die automatisch naar het klembord wordt gekopieerd.

### EXAMPLE 8

```powershell
# Controleer de naamconventies van scripts
$validName = "123-start"
$invalidNames = @("-invalid", "_underscore-only", "contains space")
foreach ($name in $invalidNames) {
    try {
        New-ColorScript -Name $name -OutputPath ./temp -WhatIf -ErrorAction Stop
    } catch {
        Write-Warning "Ongeldige naam '$name': $_"
    }
}
```

Demonstreert naamgevingsconventievalidatie voor colorscripts.

### EXAMPLE 9

```powershell
# Creëer op een draagbare locatie voor distributie
$portableDir = Join-Path $PSScriptRoot "colorscripts"
$scaffold = New-ColorScript -Name "portable-art" -OutputPath $portableDir -GenerateMetadataSnippet
Write-Host "Draagbare colorscript gemaakt in: $($scaffold.Path)"
```

Creëert colorscripts op een draagbare locatie relatief aan het huidige script.

### EXAMPLE 10

```powershell
# Creëer met categorie- en tagvalidatie
$categories = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Category -Unique
if ("Retro" -in $categories) {
    New-ColorScript -Name "retro-party" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -Tag "Fun","Social"
} else {
    Write-Warning "Categorie Retro niet gevonden"
}
```

Valideert dat een categorie bestaat voordat een nieuwe colorscript wordt gemaakt.

## PARAMETERS

### -Category

Specificeert een of meer categorieën die met de steiger worden geretourneerd en zijn opgenomen in richtlijnen voor metagegevens. Waarden moeten overeenkomen met de categorieën die al in `ScriptMetadata.psd1` worden gebruikt.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

### -Force

Overschrijft het doelbestand als dit al bestaat. Zonder deze schakeloptie wordt de cmdlet beëindigd met een fout als er op de doellocatie een bestand met dezelfde naam wordt gevonden. Wees voorzichtig bij het gebruik om gegevensverlies te voorkomen.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Overwrite
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GenerateMetadataSnippet

Bevat een begeleidingsfragment in de uitvoer dat laat zien hoe u het nieuwe script in `ScriptMetadata.psd1` registreert. Het fragment gebruikt de waarden uit de parameters `-Category` en `-Tag`, indien opgegeven. Dit is met name handig voor het behouden van consistente metagegevens voor alle colorscripts in de module.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

Specificeert de naam van de nieuwe colorscript. De naam moet beginnen met een alfanumeriek teken en mag onderstrepingstekens of koppeltekens bevatten. De `.ps1`-extensie wordt automatisch toegevoegd als deze niet is opgenomen. Deze naam wordt gebruikt als de bestandsnaam en moet een beschrijving zijn van de inhoud of het thema van het script.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Help
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OpenInEditor

Opent de gegenereerde colorscript met de opdracht die door de omgeving is geconfigureerd wanneer het maken is gelukt.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputPath

Geeft de verplichte doelmap op. De opdracht maakt <Name>.ps1 in deze map.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Destination
- Path
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

Specificeert een of meer metadatatags voor de colorscript. Tags biedt aanvullende classificatie buiten de primaire categorie en is handig voor filteren en zoeken. Veelgebruikte tags zijn themadescriptors zoals 'Minimal', 'Colorful', 'Animated', technologiereferenties zoals 'Matrix', 'ASCII', of contextuele markeringen zoals 'Holiday', 'Season'. Er kunnen meerdere tags worden opgegeven als een door komma's gescheiden array.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

Laat zien wat er zou gebeuren als de cmdlet wordt uitgevoerd zonder daadwerkelijk enige actie uit te voeren. Toont het bestandspad dat zou worden aangemaakt en eventuele validatiecontroles die zouden worden uitgevoerd. De cmdlet maakt geen bestanden of mappen wanneer deze schakeloptie is opgegeven.

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

U kunt geen objecten naar deze cmdlet doorsluizen.

## OUTPUTS

### System.Management.Automation.PSCustomObject

De cmdlet retourneert een aangepast object met de volgende eigenschappen:

- **Name**: de naam colorscript zonder de extensie `.ps1`
- **Path**: het volledige pad naar het gegenereerde bestand
- **Categories**: de array met categoriewaarden die is opgegeven (indien aanwezig)
- **Tags**: de reeks tagwaarden die zijn opgegeven (indien aanwezig)
- **MetadataGuidance**: de tekst van het metadatafragment (alleen als -GenerateMetadataSnippet wordt gebruikt)

## NOTES

**Codering**: De scaffold is geschreven met UTF-8-codering zonder een byte-ordermarkering (BOM), waardoor compatibiliteit tussen verschillende platforms en editors wordt gegarandeerd.

**Sjabloonstructuur**: De gegenereerde sjabloon omvat:

- Een steigercommentaar
- Een tijdelijke aanduiding voor de string-array voor de art
- Een lus die elke regel schrijft met `Write-Host`

**Metadata-integratie**: hoewel de cmdlet richtlijnen voor metagegevens kan genereren, moet u het fragment handmatig toevoegen aan `ScriptMetadata.psd1` om het script volledig te integreren in het detectie- en categorisatiesysteem van de module.

**Ontwikkelingsworkflow**:

1. Gebruik `New-ColorScript` om de steiger te maken
2. Bewerk het gegenereerde .ps1-bestand om uw ANSI-kunst toe te voegen
3. Als er metadatarichtlijnen zijn gegenereerd, kopieer deze dan naar `ScriptMetadata.psd1`
4. Test uw script met `Show-ColorScript -Name <your-script-name>`

**Beste praktijken**:

- Kies beschrijvende namen met koppeltekens die duidelijk het thema van het script aangeven
- Gebruik consistente categoriewaarden die aansluiten bij bestaande scripts
- Pas meerdere tags toe om de vindbaarheid te verbeteren
- Testscripts in verschillende terminalomgevingen om compatibiliteit te garanderen

## RELATED LINKS

- [Onlineversie](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)

