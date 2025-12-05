---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/it/New-ColorScript.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScript

## SYNOPSIS

Crea un nuovo colorscript con metadati e struttura del template.

## SYNTAX

```text
New-ColorScript [-Name] <string> [[-Category] <string>] [[-Tags] <string[]>] [[-Description] <string>]
 [-Path <string>] [-Template <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

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
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Confirm

Richiede conferma prima di eseguire il cmdlet.

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
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Description

Fornisce una descrizione per il colorscript che spiega il suo contenuto visivo.

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
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Name

Il nome del nuovo colorscript (senza estensione .ps1).

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
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Path

Specifica la directory dove verrà creato il colorscript.

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
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Tags

Specifica i tag per il colorscript. I tag forniscono opzioni aggiuntive di categorizzazione e filtraggio.

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
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Template

Specifica il template da usare per il nuovo colorscript. Template disponibili: Basic, Animated, Interactive, Geometric, Nature.

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
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -WhatIf

Mostra cosa accadrebbe se il cmdlet viene eseguito. Il cmdlet non viene eseguito.

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
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### CommonParameters

Questo cmdlet supporta i parametri comuni: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, e -WarningVariable. Per ulteriori informazioni, vedere
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

## Templates

- Basic: Struttura minima per script personalizzati
- Animated: Template con controlli di temporizzazione
- Interactive: Template con gestione input utente
- Geometric: Template per pattern geometrici
- Nature: Template per design ispirati alla natura

## File Structure
Gli script creati seguono l'organizzazione standard del modulo e si integrano automaticamente con i sistemi di caching e visualizzazione.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
