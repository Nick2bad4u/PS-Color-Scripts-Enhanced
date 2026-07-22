---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Ripristinare la configurazione ColorScripts-Enhanced ai valori predefiniti.

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Questo comando non ha alias.

## DESCRIPTION

`Reset-ColorScriptConfiguration` sostituisce la configurazione persistente con le impostazioni predefinite integrate e ripristina lo stato della cache in memoria del modulo. Una volta eseguito, questo cmdlet:

- Cancella l'override del percorso cache configurato in modo che venga utilizzata l'effettiva impostazione predefinita della piattaforma
- Ripristina `AutoShowOnImport`, `ProfileAutoShow` e `DefaultScript`
- Scrive la configurazione predefinita su `config.json`
- Cancella lo stato di configurazione/cache in memoria in modo che le operazioni successive utilizzino i valori di ripristino

Questo cmdlet supporta i parametri `-WhatIf` e `-Confirm` perché esegue un'operazione distruttiva sovrascrivendo il file di configurazione. L'operazione di ripristino non può essere annullata automaticamente, quindi gli utenti dovrebbero prendere in considerazione la possibilità di eseguire il backup della configurazione corrente utilizzando `Get-ColorScriptConfiguration` prima di procedere.

Utilizzare il parametro `-PassThru` per controllare immediatamente le impostazioni predefinite appena ripristinate al termine del ripristino.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Reimposta la configurazione senza richiedere conferma. Ciò è utile negli script automatizzati o quando sei sicuro di ripristinare le impostazioni predefinite.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

Reimposta la configurazione e restituisce la tabella hash risultante per l'ispezione, consentendo di verificare i valori predefiniti.

### EXAMPLE 3

```powershell
# Eseguire il backup della configurazione corrente prima del ripristino
$backup = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
```

Utilizza `-WhatIf` per visualizzare in anteprima l'operazione di ripristino senza eseguirla effettivamente, dopo aver eseguito il backup della configurazione corrente.

### EXAMPLE 4

```powershell
Reset-ColorScriptConfiguration -Verbose
```

Reimposta la configurazione con output dettagliato per visualizzare informazioni dettagliate sull'operazione.

### EXAMPLE 5

```powershell
# Ripristina la configurazione e cancella la cache per un ripristino completo delle impostazioni di fabbrica
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "Modulo ripristinato ai valori predefiniti di fabbrica."
```

Esegue un ripristino completo delle impostazioni di fabbrica, inclusa la configurazione, la cache e la ricostruzione della cache.

### EXAMPLE 6

```powershell
# Verificare che il ripristino abbia avuto esito positivo
$config = Reset-ColorScriptConfiguration -PassThru
if ($null -eq $config.Cache.Path -and $config.Cache.EffectivePath) {
    Write-Host "Configurazione ripristinata correttamente al valore predefinito della piattaforma"
} else {
    Write-Host "Configurazione ripristinata, ma è in uso un percorso personalizzato: $($config.Cache.Path)"
}
```

Reimposta e verifica che l'override della cache persistente sia vuoto e che sia disponibile un percorso della piattaforma efficace.

## PARAMETERS

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

Restituisce l'oggetto di configurazione aggiornato al termine del ripristino.

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

### -WhatIf

Mostra cosa accadrebbe se il cmdlet venisse eseguito senza eseguire effettivamente l'operazione di reimpostazione.

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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Per ulteriori informazioni, vedere
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Questo cmdlet non accetta input dalla pipeline.

## OUTPUTS

### System.Collections.Hashtable

Restituito quando viene specificato `-PassThru`.

## NOTES

Il file di configurazione è archiviato nella directory risolta da `Get-ColorScriptConfiguration`. Per impostazione predefinita, questa posizione è specifica della piattaforma:

- **Windows**: `$env:APPDATA\ColorScripts-Enhanced`
- **Linux/macOS**: `$HOME/.config/ColorScripts-Enhanced`

La variabile di ambiente `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` può sovrascrivere la posizione predefinita se impostata prima dell'importazione del modulo.

## RELATED LINKS

- [Versione online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)

