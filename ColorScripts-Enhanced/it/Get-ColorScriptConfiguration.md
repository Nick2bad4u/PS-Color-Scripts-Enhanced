---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/it/Get-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Recupera le impostazioni di configurazione correnti del modulo ColorScripts-Enhanced.

## SYNTAX

```
Get-ColorScriptConfiguration [<CommonParameters>]
```

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

### CommonParameters

Questo cmdlet supporta i parametri comuni: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, e -WarningVariable. Per ulteriori informazioni, vedere
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

## PATTERN DI UTILIZZO AVANZATO

### Analisi e Audit della Configurazione

**Audit Completo della Configurazione**

```powershell
# Revisione completa della configurazione
$config = Get-ColorScriptConfiguration

[PSCustomObject]@{
    CachePath = $config.Cache.Path
    CacheEnabled = $config.Cache.Enabled
    CacheSize = (Get-ChildItem $config.Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    StartupEnabled = $config.Startup.ProfileAutoShow
    DefaultScript = $config.DefaultScript
} | Format-List
```

**Confronto con i Valori Predefiniti**

```powershell
# Identifica personalizzazioni dai valori predefiniti
$current = Get-ColorScriptConfiguration | ConvertTo-Json

# Esporta per confronto
$current | Out-File "./current-config.json"

# Verifica personalizzazioni
if ($current -ne (Get-Content "./default-config.json")) {
    Write-Host "✓ Configurazione personalizzata rilevata"
}
```

### Configurazione Specifica dell'Ambiente

**Rilevamento Ambiente**

```powershell
# Rileva ambiente e riporta configurazione appropriata
$config = Get-ColorScriptConfiguration

$environment = switch ($true) {
    ($env:CI) { "CI/CD" }
    ($env:SSH_CONNECTION) { "Sessione SSH" }
    ($env:WT_SESSION) { "Windows Terminal" }
    ($env:TERM_PROGRAM) { "$env:TERM_PROGRAM" }
    default { "Locale" }
}

Write-Host "Ambiente: $environment"
Write-Host "Cache: $($config.Cache.Path)"
Write-Host "Avvio: $($config.Startup.ProfileAutoShow)"
```

**Gestione Multi-Ambiente**

```powershell
# Traccia configurazione attraverso ambienti
@(
    [PSCustomObject]@{ Environment = "Locale"; Config = Get-ColorScriptConfiguration }
    [PSCustomObject]@{ Environment = "CI"; Config = Invoke-Command -ComputerName ci-server { Get-ColorScriptConfiguration } }
) | ForEach-Object {
    Write-Host "=== $($_.Environment) ==="
    $_.Config | Select-Object -ExpandProperty Cache | Format-Table
}
```

### Validazione della Configurazione

**Controllo Integrità**

```powershell
# Valida integrità della configurazione
$config = Get-ColorScriptConfiguration

$checks = @{
    CachePathExists = Test-Path $config.Cache.Path
    CachePathWritable = Test-Path $config.Cache.Path -PathType Container
    CacheFilesPresent = (Get-ChildItem $config.Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue).Count -gt 0
}

$checks | ConvertTo-Json | Write-Host
```

**Coerenza della Configurazione**

```powershell
# Verifica che le impostazioni di configurazione siano coerenti
$config = Get-ColorScriptConfiguration

$validSettings = @{
    CacheEnabled = $config.Cache.Enabled -is [bool]
    PathIsString = $config.Cache.Path -is [string]
    CachePathNotEmpty = -not [string]::IsNullOrEmpty($config.Cache.Path)
}

if ($validSettings.Values -notcontains $false) {
    Write-Host "✓ La configurazione è valida"
}
```

### Backup e Ripristino della Configurazione

**Backup Configurazione Corrente**

```powershell
# Crea backup della configurazione
$config = Get-ColorScriptConfiguration
$backup = @{
    Timestamp = Get-Date
    Configuration = $config
    ModuleVersion = (Get-Module ColorScripts-Enhanced | Select-Object -ExpandProperty Version)
}

$backup | ConvertTo-Json | Out-File "./config-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
```

**Migrazione Configurazione**

```powershell
# Esporta configurazione per migrazione a nuovo sistema
$config = Get-ColorScriptConfiguration

$exportConfig = @{
    CachePath = $config.Cache.Path
    Startup = $config.Startup
    Customizations = @{
        # Aggiungi eventuali impostazioni personalizzate
    }
}

$exportConfig | ConvertTo-Json | Out-File "./export-config.json" -Encoding UTF8
```

### Reporting della Configurazione

**Report Configurazione**

```powershell
# Genera report completo della configurazione
$config = Get-ColorScriptConfiguration

$report = @"
# Report Configurazione ColorScripts-Enhanced
Generato: $(Get-Date)

## Impostazioni Cache
- Percorso: $($config.Cache.Path)
- Abilitato: $($config.Cache.Enabled)
- Dimensione: $([math]::Round((Get-ChildItem $($config.Cache.Path) -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB
- File: $(Get-ChildItem $($config.Cache.Path) -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object | Select-Object -ExpandProperty Count)

## Impostazioni Avvio
- Auto-Mostra Profilo: $($config.Startup.ProfileAutoShow)
- Script Predefinito: $($config.DefaultScript)

## Ambiente
- Versione Modulo: $(Get-Module ColorScripts-Enhanced | Select-Object -ExpandProperty Version)
- Versione PowerShell: $($PSVersionTable.PSVersion)
- OS: $(if ($PSVersionTable.Platform) { $PSVersionTable.Platform } else { "Windows" })
"@

$report | Out-File "./config-report.md" -Encoding UTF8
```

### Monitoraggio e Rilevamento Deriva

**Rilevamento Deriva Configurazione**

```powershell
# Monitora modifiche di configurazione inaspettate
$configFile = "$env:APPDATA\ColorScripts-Enhanced\config.json"
$current = Get-ColorScriptConfiguration
$lastKnown = Get-Content $configFile -ErrorAction SilentlyContinue | ConvertFrom-Json

if ($current.Cache.Path -ne $lastKnown.Cache.Path) {
    Write-Warning "Il percorso cache è cambiato: $($lastKnown.Cache.Path) -> $($current.Cache.Path)"
}
```

**Audit Configurazione Programmato**

```powershell
# Crea log audit periodico
$config = Get-ColorScriptConfiguration
$snapshot = @{
    Timestamp = Get-Date -Format 'o'
    CachePath = $config.Cache.Path
    CacheSize = (Get-ChildItem $config.Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    ScriptCount = (Get-ColorScriptList -AsObject).Count
}

$snapshot | ConvertTo-Json | Out-File "./audit-log-$(Get-Date -Format 'yyyyMMdd').json" -Append -Encoding UTF8
```

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

- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
