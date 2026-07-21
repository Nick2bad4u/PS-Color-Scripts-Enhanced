---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

Recupera un elenco di colorscript disponibili con i relativi metadati.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

Restituisce informazioni sui colorscript disponibili nella raccolta ColorScripts-Enhanced. Per impostazione predefinita, visualizza una tabella formattata che mostra i nomi degli script, le categorie e le descrizioni. Utilizza `-AsObject` per restituire oggetti strutturati per l'accesso programmatico.

Il cmdlet fornisce metadati completi su ciascun colorscript, inclusi:

- Name: L'identificatore dello script (senza estensione .ps1)
- Category: Raggruppamento tematico (Nature, Abstract, Geometric, ecc.)
- Tags: Descrittori aggiuntivi per il filtraggio e la scoperta
- Description: Breve spiegazione del contenuto visivo dello script

Questo cmdlet è essenziale per esplorare la raccolta e comprendere le opzioni disponibili prima di utilizzare altri cmdlet come `Show-ColorScript`.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Visualizza una tabella formattata di tutti i colorscript disponibili con i relativi metadati.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Category Nature
```

Elenca solo i colorscript categorizzati come "Nature".

### EXAMPLE 3

```powershell
Get-ColorScriptList -Tag geometric -AsObject
```

Restituisce i colorscript taggati come "geometric" come oggetti per ulteriore elaborazione.

### EXAMPLE 4

```powershell
Get-ColorScriptList -Name "aurora*" | Format-Table Name, Category, Tags
```

Elenca i colorscript che corrispondono al pattern wildcard con proprietà selezionate.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject | Where-Object { $_.Tags -contains 'animated' }
```

Trova tutti i colorscript animati utilizzando il filtraggio degli oggetti.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Abstract,Geometric | Measure-Object
```

Conta i colorscript nelle categorie Abstract o Geometric.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Tag retro | Select-Object Name, Description
```

Mostra nomi e descrizioni dei colorscript in stile retro.

### EXAMPLE 8

```powershell
# Get random script from specific category
Get-ColorScriptList -Category Nature -AsObject | Get-Random | Select-Object -ExpandProperty Name
```

Seleziona un nome di colorscript a tema natura casuale.

### EXAMPLE 9

```powershell
# Export script inventory to CSV
Get-ColorScriptList -AsObject | Export-Csv -Path "colorscripts.csv" -NoTypeInformation
```

Esporta i metadati completi degli script in un file CSV.

### EXAMPLE 10

```powershell
# Find scripts by multiple criteria
Get-ColorScriptList -AsObject | Where-Object {
    $_.Category -eq 'Geometric' -and $_.Tags -contains 'colorful'
}
```

Trova i colorscript geometrici che sono anche taggati come colorati.

## PARAMETERS

### -AsObject

Restituisce le informazioni sui colorscript come oggetti strutturati invece di visualizzare una tabella formattata. Gli oggetti includono le proprietà Name, Category, Tags e Description per l'accesso programmatico.

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

### -Category

Filtra i risultati per i colorscript appartenenti a una o più categorie specificate. Le categorie sono raggruppamenti tematici ampi come "Nature", "Abstract", "Art", "Retro", ecc.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Detailed

Displays an expanded formatted view that includes descriptions and additional metadata.

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

### -h

Visualizza la guida dettagliata del comando senza eseguire l'operazione.

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

### -Name

Filtra i risultati per i colorscript che corrispondono a uno o più pattern di nome. Supporta i caratteri jolly (\* e ?) per una corrispondenza flessibile.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
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

### -NoAnsiOutput

Disabilita la formattazione ANSI nei messaggi informativi e nell'output renderizzato per gli ambienti di solo testo.

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

### -Quiet

Nasconde i messaggi informativi senza sopprimere l'output del comando o gli errori.

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

### -Tag

Filtra i risultati per i colorscript taggati con uno o più tag specificati. I tag sono descrittori più specifici come "geometric", "retro", "animated", "minimal", ecc.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
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

Questo cmdlet non accetta input dalla pipeline.

## OUTPUTS

### System.Object

Quando `-AsObject` è specificato, restituisce oggetti personalizzati con le proprietà Name, Category, Tags e Description.

### None (2)

Quando `-AsObject` non è specificato, l'output viene scritto direttamente nell'host della console.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
