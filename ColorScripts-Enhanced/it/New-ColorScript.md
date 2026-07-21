---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

Crea un nuovo colorscript con metadati e struttura del template.

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

This command has no aliases.

## DESCRIPTION

Crea un nuovo file colorscript con struttura di metadati appropriata e contenuto template opzionale. Questo cmdlet fornisce un modo standardizzato per creare nuovi colorscript che si integrano perfettamente con l'ecosistema ColorScripts-Enhanced.

Il cmdlet genera:

- Un nuovo file .ps1 con struttura di base
- Metadati associati per la categorizzazione
- Contenuto template basato sullo stile selezionato
- Organizzazione file appropriata

I template disponibili includono:

- Basic: Struttura minima per script personalizzati
- Animated: Template con controlli di temporizzazione
- Interactive: Template con gestione input utente
- Geometric: Template per pattern geometrici
- Nature: Template per design ispirati alla natura

Gli script creati si integrano automaticamente con i sistemi di caching e visualizzazione del modulo.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name "MyScript"
```

Crea un nuovo colorscript con template di base.

### EXAMPLE 2

```powershell
New-ColorScript -Name "Sunset" -Category Nature -Tags "animated", "colorful" -Description "Beautiful sunset animation"
```

Crea un colorscript animato a tema natura con metadati.

### EXAMPLE 3

```powershell
New-ColorScript -Name "GeometricPattern" -Template Geometric -Path "./custom-scripts/"
```

Crea un colorscript geometrico in una directory personalizzata.

### EXAMPLE 4

```powershell
New-ColorScript -Name "InteractiveDemo" -Template Interactive -WhatIf
```

Mostra cosa verrebbe creato senza creare effettivamente i file.

### EXAMPLE 5

```powershell
# Crea più script correlati
$themes = @("Forest", "Ocean", "Mountain")
foreach ($theme in $themes) {
    New-ColorScript -Name $theme -Category Nature -Tags "landscape"
}
```

Crea più colorscript a tema natura.

## PARAMETERS

### -Category

Specifica la categoria per il nuovo colorscript. Le categorie aiutano a organizzare gli script tematicamente.

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

Richiede conferma prima di eseguire il cmdlet.

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

Overwrites an existing colorscript file at the resolved output path.

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

Includes metadata guidance for adding the new script to ScriptMetadata.psd1.

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

Visualizza la guida dettagliata del comando senza eseguire l'operazione.

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

Il nome del nuovo colorscript (senza estensione .ps1).

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

Opens the generated colorscript with the command configured by the environment when creation succeeds.

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

Specifies the target directory or .ps1 file path for the generated colorscript.

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

Specifies metadata tags to include in the generated metadata guidance.

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

Mostra cosa accadrebbe se il cmdlet viene eseguito. Il cmdlet non viene eseguito.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Questo cmdlet non accetta input dalla pipeline.

## OUTPUTS

### System.Object

Restituisce un oggetto con informazioni sul colorscript creato.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
