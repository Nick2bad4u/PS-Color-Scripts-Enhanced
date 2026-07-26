---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
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

Questo comando non ha alias.

## DESCRIPTION

`Get-ColorScriptConfiguration` restituisce una copia della configurazione effettiva del modulo. Lo schema attuale contiene:

- **Impostazioni cache**: la sostituzione configurata e la directory della cache effettiva risolta
- **Comportamento all'avvio**: `AutoShowOnImport`, `ProfileAutoShow` e `DefaultScript`

La configurazione è assemblata da più fonti in ordine di precedenza:

1. Impostazioni predefinite del modulo integrato (priorità più bassa)
2. L'utente persistente esegue l'override dal file di configurazione
3. `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` per il percorso cache effettivo restituito

Il file di configurazione si trova in genere in `%APPDATA%\ColorScripts-Enhanced\config.json` su Windows o `~/.config/ColorScripts-Enhanced/config.json` su sistemi simili a Unix.

La tabella hash restituita è un'istantanea dello stato di configurazione corrente e può essere ispezionata, clonata o serializzata in modo sicuro senza influire sulla configurazione attiva.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Visualizza la configurazione corrente utilizzando la visualizzazione tabella predefinita, mostrando tutte le impostazioni della cache e di avvio.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Serializza la configurazione nel formato JSON per la registrazione, il debug o l'esportazione in altri strumenti.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.EffectivePath
```

Recupera la directory della cache risolta. `Cache.Path` rimane l'override opzionale configurato dall'utente;
`Cache.EffectivePath` mostra la directory che il modulo utilizza effettivamente dopo le impostazioni predefinite della piattaforma e
vengono applicate le sostituzioni dell'ambiente.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.AutoShowOnImport) {
    Write-Host "Gli script di avvio sono abilitati"
}
```

Controlla se gli script di avvio sono abilitati nella configurazione corrente.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Visualizza tutte le proprietà di configurazione in un formato di elenco dettagliato per un'ispezione completa.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Percorso cache: $($config.Cache.Path)"
Write-Host "Visualizzazione automatica del profilo: $($config.Startup.ProfileAutoShow)"
Write-Host "Script predefinito: $($config.Startup.DefaultScript)"
```

Estrae e visualizza proprietà di configurazione specifiche per scopi di controllo o scripting.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Percorso cache personalizzato configurato: $($config.Cache.Path)"
} else {
    Write-Host "Utilizzo del percorso cache predefinito"
}

Write-Host "Percorso cache effettivo: $($config.Cache.EffectivePath)"
```

Determina se è configurato un percorso cache personalizzato rispetto all'utilizzo delle impostazioni predefinite del modulo.

### EXAMPLE 8

```powershell
$config = Get-ColorScriptConfiguration
$config | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Esegue il backup della configurazione corrente in un file JSON per l'archiviazione o il ripristino di emergenza.

### EXAMPLE 9

```powershell
# Confronta la configurazione attuale con le impostazioni predefinite
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Esamina l'output -WhatIf per vedere cosa cambierebbe
```

Confronta la configurazione corrente con le impostazioni predefinite del modulo per identificare le impostazioni personalizzate.

### EXAMPLE 10

```powershell
# Monitorare le modifiche alla configurazione tra le sessioni
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Crea istantanee della configurazione con timestamp per tenere traccia delle modifiche nel tempo.

## PARAMETERS

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

### CommonParameters

Questo cmdlet supporta i parametri comuni:
Per ulteriori informazioni, vedere
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Questo cmdlet non accetta input dalla pipeline.

## OUTPUTS

### System.Collections.Hashtable

Restituisce una tabella hash annidata contenente la seguente struttura:

- **Cache** (Hashtable): impostazioni relative alla cache
  - **Path** (stringa): override opzionale del percorso della cache persistente
  - **EffectivePath** (Stringa): directory della cache risolta attualmente utilizzata dal modulo
- **Startup** (Hashtable): impostazioni del comportamento di avvio
  - **AutoShowOnImport** (Booleano): indica se l'importazione richiama il comportamento di visualizzazione all'avvio
  - **ProfileAutoShow** (Booleano): scelta di visualizzazione automatica predefinita per i blocchi di profili gestiti
  - **DefaultScript** (Stringa): colorscript di avvio denominato opzionale

## NOTES

**Inizializzazione del modulo**: la configurazione viene inizializzata automaticamente al caricamento del modulo ColorScripts-Enhanced. Questo cmdlet recupera lo stato di configurazione corrente in memoria.

**Nessuna modifica**: la chiamata a questo cmdlet è di sola lettura e non modifica le impostazioni persistenti o la configurazione attiva.

**Sicurezza del thread**: la tabella hash restituita è una copia della configurazione, rendendola sicura per l'accesso e la modifica simultanei senza influenzare lo stato interno del modulo.

**Performance**: il recupero della configurazione è leggero e adatto per chiamate frequenti, poiché restituisce la configurazione memorizzata nella cache anziché leggerla dal disco.

**Formato file di configurazione**: la configurazione persistente utilizza il formato JSON con codifica UTF-8. La modifica manuale è supportata ma non consigliata; utilizzare invece `Set-ColorScriptConfiguration`.

### Migliori pratiche

- Interrogare la configurazione una volta e riutilizzare il risultato
- Convalidare la configurazione prima di utilizzare i valori
- Monitorare la configurazione per la deriva nel tempo
- Conserva i backup solo laddove non possono esporre percorsi specifici della macchina o dati privati
- Documentare eventuali personalizzazioni apportate alla configurazione
- Testare prima le modifiche alla configurazione non in produzione
- Utilizzare i log di controllo della configurazione per la conformità

## RELATED LINKS

- [Versione online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

