---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Recupera le impostazioni di configurazione correnti del modulo ColorScripts-Enhanced.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

`Get-ColorScriptConfiguration` recupera la configurazione effettiva del modulo, che controlla vari aspetti del comportamento di ColorScripts-Enhanced. Questo include:

- **Impostazioni Cache**: Posizione in cui sono memorizzati i metadati degli script e gli indici per l'ottimizzazione delle prestazioni
- **Comportamento di Avvio**: Flag che controllano se gli script vengono eseguiti automaticamente all'avvio delle sessioni PowerShell
- **Configurazione Percorsi**: Directory di script personalizzate e percorsi di ricerca
- **Preferenze di Visualizzazione**: Opzioni di formattazione e output predefinite

La configurazione è assemblata da più fonti in ordine di precedenza:

1. Valori predefiniti incorporati del modulo (priorità più bassa)
2. Override utente persistiti dal file di configurazione
3. Modifiche specifiche della sessione (priorità più alta)

Il file di configurazione si trova tipicamente in `%APPDATA%\ColorScripts-Enhanced\config.json` su Windows o `~/.config/ColorScripts-Enhanced/config.json` su sistemi simili a Unix.

L'hashtable restituita è uno snapshot dello stato di configurazione corrente e può essere ispezionata, clonata o serializzata in sicurezza senza influenzare la configurazione attiva.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Visualizza la configurazione corrente utilizzando la vista tabella predefinita, mostrando tutte le impostazioni di cache e avvio.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Serializza la configurazione in formato JSON per logging, debugging o esportazione ad altri strumenti.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.Location
```

Recupera la configurazione e accede direttamente al percorso della posizione della cache dall'hashtable.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.Enabled) {
    Write-Host "Startup scripts are enabled"
}
```

Verifica se gli script di avvio sono abilitati nella configurazione corrente.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Visualizza tutte le proprietà di configurazione in un formato lista dettagliato per ispezione completa.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Cache Path: $($config.Cache.Path)"
Write-Host "Profile Auto-Show: $($config.Startup.ProfileAutoShow)"
Write-Host "Default Script: $($config.Startup.DefaultScript)"
```

Estrae e visualizza proprietà di configurazione specifiche per audit o scopi di scripting.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Custom cache path configured: $($config.Cache.Path)"
} else {
    Write-Host "Using default cache path"
}
```

Determina se è configurato un percorso cache personalizzato rispetto all'uso dei valori predefiniti del modulo.

### EXAMPLE 8

```powershell
Export-ColorScriptMetadata | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Esegue il backup della configurazione corrente in un file JSON per archivio o disaster recovery.

### EXAMPLE 9

```powershell
# Compare current config with defaults
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Review the -WhatIf output to see what would change
```

Confronta la configurazione corrente con i valori predefiniti del modulo per identificare impostazioni personalizzate.

### EXAMPLE 10

```powershell
# Monitor configuration changes across sessions
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Crea snapshot con timestamp della configurazione per tracciare le modifiche nel tempo.

## PARAMETERS

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Questo cmdlet non accetta input dalla pipeline.

## OUTPUTS

### System.Collections.Hashtable

Restituisce un hashtable nidificato contenente la seguente struttura:

- **Cache** (Hashtable): Impostazioni relative alla cache
  - **Location** (String): Percorso alla directory della cache
  - **Enabled** (Boolean): Se la cache è attiva
- **Startup** (Hashtable): Impostazioni del comportamento di avvio
  - **Enabled** (Boolean): Se gli script vengono eseguiti all'avvio della sessione
  - **ScriptName** (String): Nome dello script di avvio predefinito
- **Paths** (Array): Percorsi di ricerca script aggiuntivi
- **Display** (Hashtable): Preferenze di formattazione dell'output

## NOTES

**Inizializzazione Modulo**: La configurazione viene inizializzata automaticamente quando il modulo ColorScripts-Enhanced viene caricato. Questo cmdlet recupera lo stato di configurazione in memoria corrente.

**Nessuna Modifica**: Chiamare questo cmdlet è di sola lettura e non modifica alcuna impostazione persistita o la configurazione attiva.

**Sicurezza Thread**: L'hashtable restituita è una copia della configurazione, rendendola sicura per accesso concorrente e modifica senza influenzare lo stato interno del modulo.

**Prestazioni**: Il recupero della configurazione è leggero e adatto per chiamate frequenti, poiché restituisce la configurazione in memoria cache piuttosto che leggere dal disco.

**Formato File Configurazione**: La configurazione persistita utilizza il formato JSON con codifica UTF-8. La modifica manuale è supportata ma non raccomandata; utilizzare invece `Set-ColorScriptConfiguration`.

### Migliori Pratiche

- Interroga la configurazione una volta e riutilizza il risultato
- Valida la configurazione prima di utilizzare i valori
- Monitora la configurazione per deriva nel tempo
- Mantieni backup della configurazione nel controllo versione
- Documenta eventuali personalizzazioni apportate alla configurazione
- Testa le modifiche alla configurazione prima in non-produzione
- Utilizza log di audit della configurazione per conformità

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

