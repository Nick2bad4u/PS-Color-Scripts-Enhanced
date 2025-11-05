---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/nl/Get-ColorScriptList.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptList

## SYNOPSIS

Haalt een lijst op van beschikbare colorscripts met hun metadata.

## SYNTAX

```
Get-ColorScriptList [[-Name] <string[]>] [-Category <string[]>] [-Tag <string[]>] [-AsObject]
 [<CommonParameters>]
```

## DESCRIPTION

Retourneert informatie over beschikbare colorscripts in de ColorScripts-Enhanced collectie. Standaard toont het een geformatteerde tabel met scriptnamen, categorieën en beschrijvingen. Gebruik `-AsObject` om gestructureerde objecten terug te geven voor programmatische toegang.

De cmdlet biedt uitgebreide metadata over elke colorscript, inclusief:

- Name: De scriptidentificatie (zonder .ps1 extensie)
- Category: Thematische groepering (Nature, Abstract, Geometric, etc.)
- Tags: Aanvullende descriptors voor filtering en ontdekking
- Description: Korte uitleg van de visuele inhoud van het script

Deze cmdlet is essentieel voor het verkennen van de collectie en het begrijpen van beschikbare opties voordat andere cmdlets zoals `Show-ColorScript` worden gebruikt.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Toont een geformatteerde tabel van alle beschikbare colorscripts met hun metadata.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Category Nature
```

Toont alleen colorscripts die gecategoriseerd zijn als "Nature".

### EXAMPLE 3

```powershell
Get-ColorScriptList -Tag geometric -AsObject
```

Retourneert colorscripts die getagd zijn als "geometric" als objecten voor verdere verwerking.

### EXAMPLE 4

```powershell
Get-ColorScriptList -Name "aurora*" | Format-Table Name, Category, Tags
```

Toont colorscripts die overeenkomen met het wildcardpatroon met geselecteerde eigenschappen.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject | Where-Object { $_.Tags -contains 'animated' }
```

Vindt alle geanimeerde colorscripts met behulp van objectfiltering.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Abstract,Geometric | Measure-Object
```

Telt colorscripts in Abstract of Geometric categorieën.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Tag retro | Select-Object Name, Description
```

Toont namen en beschrijvingen van retro-stijl colorscripts.

### EXAMPLE 8

```powershell
# Get random script from specific category
Get-ColorScriptList -Category Nature -AsObject | Get-Random | Select-Object -ExpandProperty Name
```

Selecteert een willekeurige natuur-geïnspireerde colorscriptnaam.

### EXAMPLE 9

```powershell
# Export script inventory to CSV
Get-ColorScriptList -AsObject | Export-Csv -Path "colorscripts.csv" -NoTypeInformation
```

Exporteert complete scriptmetadata naar een CSV-bestand.

### EXAMPLE 10

```powershell
# Find scripts by multiple criteria
Get-ColorScriptList -AsObject | Where-Object {
    $_.Category -eq 'Geometric' -and $_.Tags -contains 'colorful'
}
```

Vindt geometrische colorscripts die ook getagd zijn als kleurrijk.

## PARAMETERS

### -AsObject

Retourneert colorscriptinformatie als gestructureerde objecten in plaats van een geformatteerde tabel weer te geven. Objecten bevatten Name, Category, Tags en Description eigenschappen voor programmatische toegang.

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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Category

Filter resultaten op colorscripts die behoren tot een of meer opgegeven categorieën. Categorieën zijn brede thematische groeperingen zoals "Nature", "Abstract", "Art", "Retro", etc.

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

### -Name

Filter resultaten op colorscripts die overeenkomen met een of meer naamspatronen. Ondersteunt wildcards (\* en ?) voor flexibele matching.

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

Filter resultaten op colorscripts die getagd zijn met een of meer opgegeven tags. Tags zijn meer specifieke descriptors zoals "geometric", "retro", "animated", "minimal", etc.

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

Wanneer `-AsObject` is opgegeven, retourneert het aangepaste objecten met Name, Category, Tags en Description eigenschappen.

### None

Wanneer `-AsObject` niet is opgegeven, wordt de uitvoer direct naar de consolehost geschreven.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 of later

**Metadata Properties:**

- Name: Scriptidentificatie gebruikt door Show-ColorScript
- Category: Thematische groepering voor organisatie
- Tags: Array van beschrijvende trefwoorden voor filtering
- Description: Menselijk leesbare uitleg van inhoud

**Usage Patterns:**

- Discovery: Verken beschikbare scripts voordat selectie
- Filtering: Beperk opties met behulp van categorieën en tags
- Automation: Gebruik -AsObject voor programmatische scriptselectie
- Inventory: Exporteer metadata voor documentatie of rapportage

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
