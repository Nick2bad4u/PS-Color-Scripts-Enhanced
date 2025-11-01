---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/it/Clear-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Clear-ColorScriptCache

## SYNOPSIS

Cancella i file di output dei colorscript memorizzati nella cache.

## SYNTAX

```
Clear-ColorScriptCache [[-Name] <string[]>] [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Rimuove i file di output memorizzati nella cache per i colorscript per forzare una nuova esecuzione al prossimo display. Questo cmdlet fornisce una gestione mirata della cache per script individuali o operazioni in blocco.

Il sistema di cache memorizza l'output ANSI renderizzato per fornire prestazioni di display quasi istantanee. Nel tempo, i file memorizzati nella cache potrebbero diventare obsoleti se gli script sorgente vengono modificati, oppure potresti voler cancellare la cache per scopi di risoluzione problemi.

Utilizza questo cmdlet quando:
- Gli script sorgente dei colorscript sono stati modificati
- È sospettata una corruzione della cache
- Vuoi garantire una nuova esecuzione
- È desiderato liberare spazio su disco

Il cmdlet supporta sia la cancellazione mirata (script specifici) che operazioni in blocco (tutti i file memorizzati nella cache).

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -Name "spectrum"
```

Cancella la cache per il colorscript specifico denominato "spectrum".

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -All
```

Cancella tutti i file dei colorscript memorizzati nella cache.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name "aurora*", "geometric*"
```

Cancella la cache per i colorscript che corrispondono ai pattern di wildcard specificati.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Name aurora-waves -WhatIf
```

Mostra quali file di cache verrebbero cancellati senza rimuoverli effettivamente.

### EXAMPLE 5

```powershell
# Clear cache for all scripts in a category
Get-ColorScriptList -Category Nature -AsObject | ForEach-Object {
    Clear-ColorScriptCache -Name $_.Name
}
```

Cancella la cache per tutti i colorscript a tema natura.

## PARAMETERS

### -All

Cancella tutti i file dei colorscript memorizzati nella cache. Non può essere utilizzato con il parametro -Name.

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
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
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
HelpMessage: ''
```

### -Name

Specifica i nomi dei colorscript da cancellare dalla cache. Supporta wildcard (* e ?) per la corrispondenza di pattern.

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
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
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
HelpMessage: ''
```

### CommonParameters

Questo cmdlet supporta i parametri comuni: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Per ulteriori informazioni, vedere
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Questo cmdlet non accetta input dalla pipeline.

## OUTPUTS

### None

Questo cmdlet non restituisce output alla pipeline.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 o successivo

**Posizione Cache:**
I file di cache sono memorizzati in una directory gestita dal modulo. Utilizza `(Get-Module ColorScripts-Enhanced).ModuleBase` per localizzare la directory del modulo, quindi cerca la sottodirectory cache.

**Quando Cancellare la Cache:**
- Dopo aver modificato i file degli script sorgente dei colorscript
- Durante la risoluzione di problemi di display
- Per garantire una nuova esecuzione degli script
- Prima del benchmarking delle prestazioni

**Impatto sulle Prestazioni:**
La cancellazione della cache causerà l'esecuzione normale degli script al prossimo display, che potrebbe richiedere più tempo rispetto all'esecuzione memorizzata nella cache. La cache verrà ricostruita automaticamente ai display successivi.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
