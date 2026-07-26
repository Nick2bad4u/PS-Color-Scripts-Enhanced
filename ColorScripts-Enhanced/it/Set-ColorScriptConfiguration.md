---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Persistenza delle modifiche alla cache ColorScripts-Enhanced e alla configurazione di avvio.

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Questo comando non ha alias.

## DESCRIPTION

`Set-ColorScriptConfiguration` fornisce un modo persistente per personalizzare il comportamento e la posizione di archiviazione del modulo ColorScripts-Enhanced. Questo cmdlet aggiorna il file di configurazione del modulo, consentendo di controllare vari aspetti del rendering e dell'archiviazione degli script.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

Sposta la cache in `D:/Temp/ColorScriptsCache`, abilita la visualizzazione automatica all'importazione del modulo, disabilita la visualizzazione automatica del profilo e imposta `bars` come script predefinito.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

Cancella lo script predefinito e restituisce l'oggetto di configurazione risultante, consentendo di verificare che l'impostazione sia stata rimossa.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

Riposiziona la cache nella directory TEMP di Windows e visualizza la configurazione aggiornata completa in formato elenco. Utile per scenari di test temporanei.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

Disabilita il rendering automatico colorscript al caricamento del modulo. Utile se preferisci il controllo manuale sulla visualizzazione degli script.

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

Imposta un percorso cache in stile Linux/macOS utilizzando l'espansione tilde e configura 'crunch' come script predefinito per tutte le operazioni.

## PARAMETERS

### -AutoShowOnImport

Abilita o disabilita il rendering automatico di uno colorscript quando il modulo viene importato. Se abilitato (`$true`), colorscript viene visualizzato immediatamente dopo l'importazione del modulo, fornendo un feedback visivo immediato. Se disabilitati (`$false`), gli script vengono visualizzati solo se richiamati esplicitamente. Se non specificato, l'impostazione esistente rimane invariata.

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -CachePath

Specifica la directory in cui sono archiviati i payload `.cache` sottoposti a rendering e i sidecar di convalida `.cacheinfo`. L'origine colorscripts e i metadati del modulo rimangono nel modulo installato. Supporta percorsi assoluti, percorsi relativi (risolti dalla posizione corrente), variabili di ambiente (ad esempio, `$env:USERPROFILE`) ed espansione tilde (`~`).

Se la directory specificata non esiste, verrà creata automaticamente con le autorizzazioni appropriate. Fornire un string vuoto (`''`) per cancellare il percorso personalizzato e ripristinare la posizione predefinita specifica della piattaforma. Se non specificata, l'impostazione del percorso della cache esistente viene mantenuta.

**Note**: la modifica del percorso della cache non esegue automaticamente la migrazione dei file memorizzati nella cache esistenti. Potrebbe essere necessario copiare manualmente i file o consentirne la rigenerazione.

```yaml
Type: System.String
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

### -DefaultScript

Imposta o cancella il nome colorscript predefinito utilizzato dagli helper del profilo, dalle funzionalità di visualizzazione automatica e quando nessuno script è esplicitamente specificato nei comandi. Dovrebbe corrispondere al nome base di un file di script senza estensione (ad esempio, `'bars'`, non `'bars.ps1'`).

Fornire un string vuoto (`''`) per rimuovere l'impostazione predefinita memorizzata, ripristinando il comportamento predefinito a livello di modulo (tipicamente selezione casuale). Quando questo parametro viene omesso, l'impostazione dello script predefinito corrente rimane invariata.

Per poter essere utilizzato correttamente, lo script specificato deve esistere nella directory degli script del modulo.

```yaml
Type: System.String
DefaultValue: ''
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
HelpMessage: ''
```

### -h

Visualizza la guida dettagliata per questo comando senza eseguire l'operazione.

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

### -PassThru

Restituisce l'oggetto di configurazione aggiornato dopo aver apportato modifiche. Senza questa opzione, il cmdlet funziona in modalità silenziosa (nessun output). L'oggetto restituito ha la stessa struttura di `Get-ColorScriptConfiguration` e può essere ispezionato, archiviato o inviato tramite pipe ad altri cmdlet per un'ulteriore elaborazione.

Utile per la verifica, la registrazione o il concatenamento dei comandi di configurazione.

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

### -ProfileAutoShow

Controlla se i frammenti di profilo generati da `Add-ColorScriptProfile` includono un'invocazione automatica di `Show-ColorScript`. Quando `$true`, il codice del profilo visualizzerà colorscript ad ogni avvio della shell. Quando `$false`, il profilo caricherà il modulo ma non visualizzerà automaticamente gli script.

Questa impostazione influisce solo sul codice del profilo appena generato; le modifiche al profilo esistente non vengono aggiornate automaticamente. L'omissione di questo parametro lascia invariata l'impostazione corrente.

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -WhatIf

Esegue il comando in una modalità che segnala solo cosa accadrebbe senza eseguire le azioni.

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

Questo cmdlet supporta i parametri comuni:
Per ulteriori informazioni, vedere
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Questo cmdlet non accetta input dalla pipeline.

## OUTPUTS

### None (2)

Per impostazione predefinita, questo cmdlet non produce alcun output.

### System.Collections.Hashtable

Quando viene specificato `-PassThru`, restituisce la tabella hash annidata prodotta da `Get-ColorScriptConfiguration`: i valori della cache sono in `Cache` e i valori di avvio sono in `Startup`.

## NOTES

La configurazione viene mantenuta solo dopo la convalida e la conferma. `-WhatIf` non esegue scritture sul filesystem. Utilizzare `Get-ColorScriptConfiguration` per controllare i valori effettivi e i percorsi di memorizzazione dopo l'operazione.

## RELATED LINKS

- [Versione online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)

