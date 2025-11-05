---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/nl/Clear-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Clear-ColorScriptCache

## SYNOPSIS

Wisht de cache van colorscript uitvoerbestanden.

## SYNTAX

```
Clear-ColorScriptCache [[-Name] <string[]>] [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Verwijdert gecachte uitvoerbestanden voor colorscripts om verse uitvoering bij volgende weergave te forceren. Deze cmdlet biedt gerichte cachebeheer voor individuele scripts of bulkbewerkingen.

Het cachesysteem slaat gerenderde ANSI-uitvoer op om bijna-instant weergaveprestaties te bieden. Na verloop van tijd kunnen gecachte bestanden verouderd raken als bronscripts worden gewijzigd, of u wilt misschien cache wissen voor probleemoplossing doeleinden.

Gebruik deze cmdlet wanneer:

- Bron colorscripts zijn gewijzigd
- Cachecorruptie wordt vermoed
- U wilt verse uitvoering garanderen
- Vrijmaken van schijfruimte gewenst is

De cmdlet ondersteunt zowel gerichte wissen (specifieke scripts) als bulkbewerkingen (alle gecachte bestanden).

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -Name "spectrum"
```

Wisht de cache voor de specifieke colorscript genaamd "spectrum".

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -All
```

Wisht alle gecachte colorscript bestanden.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name "aurora*", "geometric*"
```

Wisht cache voor colorscripts die overeenkomen met de opgegeven wildcardpatronen.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Name aurora-waves -WhatIf
```

Toont welke cachebestanden zouden worden gewist zonder ze daadwerkelijk te verwijderen.

### EXAMPLE 5

```powershell
# Clear cache for all scripts in a category
Get-ColorScriptList -Category Nature -AsObject | ForEach-Object {
    Clear-ColorScriptCache -Name $_.Name
}
```

Wisht cache voor alle natuur-georiënteerde colorscripts.

## PARAMETERS

### -All

Wisht alle gecachte colorscript bestanden. Kan niet gebruikt worden met -Name parameter.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

Specificeert de namen van colorscripts om uit de cache te wissen. Ondersteunt wildcards (\* en ?) voor patroonmatching.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Name
  Position: 0
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

### None

Deze cmdlet retourneert geen uitvoer naar de pipeline.

## NOTES

**Auteur:** Nick
**Module:** ColorScripts-Enhanced
**Vereist:** PowerShell 5.1 of later

**Cache Locatie:**
Cachebestanden worden opgeslagen in een module-beheerde directory. Gebruik `(Get-Module ColorScripts-Enhanced).ModuleBase` om de module directory te lokaliseren, zoek dan naar de cache subdirectory.

**Wanneer Cache Wissen:**

- Na het wijzigen van bron colorscript bestanden
- Bij het oplossen van weergaveproblemen
- Om verse uitvoering van scripts te garanderen
- Voor prestatiebenchmarking

**Prestatie Impact:**
Het wissen van cache zal ervoor zorgen dat scripts normaal worden uitgevoerd bij volgende weergave, wat langer kan duren dan gecachte uitvoering. Cache zal automatisch worden herbouwd bij volgende weergaven.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Online Documentatie](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
