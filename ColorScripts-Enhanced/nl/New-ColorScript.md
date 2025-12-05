---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/nl/New-ColorScript.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScript

## SYNOPSIS

Creëert een nieuw colorscript met metadata en sjabloonstructuur.

## SYNTAX

```text
New-ColorScript [-Name] <string> [[-Category] <string>] [[-Tags] <string[]>] [[-Description] <string>]
 [-Path <string>] [-Template <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Creëert een nieuw colorscript bestand met juiste metadatastructuur en optionele sjablooninhoud. Deze cmdlet biedt een gestandaardiseerde manier om nieuwe colorscripts te maken die naadloos integreren met het ColorScripts-Enhanced ecosysteem.

De cmdlet genereert:

- Een nieuw .ps1 bestand met basisstructuur
- Geassocieerde metadata voor categorisering
- Sjablooninhoud gebaseerd op geselecteerde stijl
- Juiste bestandsorganisatie

Beschikbare sjablonen omvatten:

- Basic: Minimale structuur voor aangepaste scripts
- Animated: Sjabloon met timing controles
- Interactive: Sjabloon met gebruikersinvoer afhandeling
- Geometric: Sjabloon voor geometrische patronen
- Nature: Sjabloon voor natuur-geïnspireerde ontwerpen

Gemaakte scripts integreren automatisch met de caching- en weergavesystemen van de module.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name "MyScript"
```

Creëert een nieuw colorscript met basissjabloon.

### EXAMPLE 2

```powershell
New-ColorScript -Name "Sunset" -Category Nature -Tags "animated", "colorful" -Description "Beautiful sunset animation"
```

Creëert een natuur-georiënteerd geanimeerd colorscript met metadata.

### EXAMPLE 3

```powershell
New-ColorScript -Name "GeometricPattern" -Template Geometric -Path "./custom-scripts/"
```

Creëert een geometrisch colorscript in een aangepaste directory.

### EXAMPLE 4

```powershell
New-ColorScript -Name "InteractiveDemo" -Template Interactive -WhatIf
```

Toont wat zou worden gemaakt zonder daadwerkelijk bestanden te maken.

### EXAMPLE 5

```powershell
# Create multiple related scripts
$themes = @("Forest", "Ocean", "Mountain")
foreach ($theme in $themes) {
    New-ColorScript -Name $theme -Category Nature -Tags "landscape"
}
```

Creëert meerdere natuur-georiënteerde colorscripts.

## PARAMETERS

### -Category

Specificeert de categorie voor het nieuwe colorscript. Categorieën helpen scripts thematisch te organiseren.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
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

### -Description

Biedt een beschrijving voor het colorscript die de visuele inhoud uitlegt.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
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

De naam van het nieuwe colorscript (zonder .ps1 extensie).

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Path

Specificeert de directory waar het colorscript wordt gemaakt.

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

### -Tags

Specificeert tags voor het colorscript. Tags bieden extra categorisering en filteropties.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Template

Specificeert de sjabloon om te gebruiken voor het nieuwe colorscript. Beschikbare sjablonen: Basic, Animated, Interactive, Geometric, Nature.

```yaml
Type: System.String
DefaultValue: Basic
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

### System.Object

Retourneert een object met informatie over het gemaakte colorscript.

## NOTES

**Auteur:** Nick
**Module:** ColorScripts-Enhanced
**Vereist:** PowerShell 5.1 of later

## Sjablonen

- Basic: Minimale structuur voor aangepaste scripts
- Animated: Sjabloon met timing controles
- Interactive: Sjabloon met gebruikersinvoer afhandeling
- Geometric: Sjabloon voor geometrische patronen
- Nature: Sjabloon voor natuur-geïnspireerde ontwerpen

## Bestandsstructuur
Gemaakte scripts volgen de standaardorganisatie van de module en integreren automatisch met caching- en weergavesystemen.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
