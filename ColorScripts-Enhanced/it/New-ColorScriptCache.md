---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/it/New-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScriptCache

## SYNOPSIS

Pre-costruisce la cache per l'ottimizzazione delle prestazioni dei colorscript.

## SYNTAX

```
New-ColorScriptCache [[-Name] <string[]>] [-Category <string[]>] [-Tag <string[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Pre-genera l'output memorizzato nella cache per i colorscript per garantire prestazioni ottimali al primo display. Questo cmdlet esegue i colorscript in anticipo e memorizza il loro output renderizzato per il recupero istantaneo.

Il sistema di caching fornisce miglioramenti delle prestazioni da 6 a 19 volte. Alla prima esecuzione, un colorscript viene eseguito normalmente e il suo output viene memorizzato nella cache. I display successivi utilizzano l'output memorizzato nella cache per un rendering quasi istantaneo. La cache viene invalidata automaticamente quando gli script di origine vengono modificati, garantendo l'accuratezza dell'output.

Utilizza questo cmdlet per:

- Preparare la cache per gli script utilizzati frequentemente
- Garantire prestazioni coerenti tra le sessioni
- Pre-riscaldare la cache dopo gli aggiornamenti del modulo
- Ottimizzare le prestazioni di avvio

Il cmdlet supporta il caching selettivo per nome, categoria o tag, consentendo la preparazione mirata della cache.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Pre-costruisce la cache per tutti i colorscript disponibili.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name "spectrum", "aurora-waves"
```

Memorizza nella cache colorscript specifici per nome.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Category Nature
```

Pre-costruisce la cache per tutti i colorscript a tema natura.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Tag animated
```

Memorizza nella cache tutti i colorscript taggati come "animated".

### EXAMPLE 5

```powershell
# Cache scripts for startup optimization
New-ColorScriptCache -Category Geometric -Tag minimal
```

Prepara la cache per script geometrici leggeri ideali per display di avvio rapidi.

## PARAMETERS

### -Category

Filtra gli script da memorizzare nella cache per una o più categorie.

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
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

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

### -Name

Specifica i nomi dei colorscript da memorizzare nella cache. Supporta i caratteri jolly (\* e ?).

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
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Tag

Filtra gli script da memorizzare nella cache per uno o più tag.

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
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Questo cmdlet non accetta input dalla pipeline.

## OUTPUTS

### System.Object

Restituisce i risultati della costruzione della cache con lo stato di successo/fallimento per ciascun script.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

**Performance Impact:**
Il pre-caching elimina il tempo di esecuzione al primo display, fornendo feedback visivo istantaneo. Particolarmente benefico per script complessi o animati.

**Cache Management:**
I file memorizzati nella cache sono archiviati in directory gestite dal modulo e vengono invalidati automaticamente quando gli script di origine cambiano. Utilizza Clear-ColorScriptCache per rimuovere la cache obsoleta.

**Best Practices:**

- Memorizza nella cache gli script utilizzati frequentemente per prestazioni ottimali
- Utilizza il caching selettivo per evitare elaborazioni non necessarie
- Esegui dopo gli aggiornamenti del modulo per garantire la validità della cache

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
