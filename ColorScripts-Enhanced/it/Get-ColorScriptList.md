---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/it/Get-ColorScriptList.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptList

## SYNOPSIS

Recupera un elenco di colorscript disponibili con i relativi metadati.

## SYNTAX

```powershell
Get-ColorScriptList [[-Name] <string[]>] [-Category <string[]>] [-Tag <string[]>] [-AsObject]
 [<CommonParameters>]
```

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
DefaultValue: False
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

### -Category

Filtra i risultati per i colorscript appartenenti a una o più categorie specificate. Le categorie sono raggruppamenti tematici ampi come "Nature", "Abstract", "Art", "Retro", ecc.

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

### -Name

Filtra i risultati per i colorscript che corrispondono a uno o più pattern di nome. Supporta i caratteri jolly (\* e ?) per una corrispondenza flessibile.

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

Filtra i risultati per i colorscript taggati con uno o più tag specificati. I tag sono descrittori più specifici come "geometric", "retro", "animated", "minimal", ecc.

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

## Metadata Properties

- Name: Identificatore dello script utilizzato da Show-ColorScript
- Category: Raggruppamento tematico per l'organizzazione
- Tags: Array di parole chiave descrittive per il filtraggio
- Description: Spiegazione leggibile dall'uomo del contenuto

## Usage Patterns

- Discovery: Esplora gli script disponibili prima della selezione
- Filtering: Riduci le opzioni utilizzando categorie e tag
- Automation: Utilizza -AsObject per la selezione programmatica degli script
- Inventory: Esporta i metadati per documentazione o reporting

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)

### SCRIPT CATEGORIES

Il modulo include script in varie categorie:

- **Geometric**: mandelbrot-zoom, apollonian-circles, sierpinski-carpet
- **Nature**: galaxy-spiral, aurora-bands, crystal-drift
- **Artistic**: kaleidoscope, rainbow-waves, prismatic-rain
- **Gaming**: doom, pacman, space-invaders
- **System**: colortest, nerd-font-test, terminal-benchmark
- **Logos**: arch, debian, ubuntu, windows

### SEE ALSO

- GitHub Repository: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced
- Original inspiration: shell-color-scripts
- PowerShell Documentation: https://docs.microsoft.com/powershell/

### KEYWORDS

- ANSI
- Terminal
- Art
- ASCII
- Color
- Scripts
- Cache
- Performance

### ADVANCED USAGE

#### Building Cache for Specific Categories

Memorizza nella cache tutti gli script nella categoria Geometric per prestazioni ottimali:

```powershell
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object { New-ColorScriptCache -Name $_.Name }
```

#### Performance Measurement

Misura il miglioramento delle prestazioni dalla memorizzazione nella cache:

```powershell
# Prestazioni senza cache (avvio a freddo)
Remove-Module ColorScripts-Enhanced -ErrorAction SilentlyContinue
$uncached = Measure-Command {
    Import-Module ColorScripts-Enhanced
    Show-ColorScript -Name "mandelbrot-zoom" -NoCache
}

# Prestazioni con cache (avvio a caldo)
$cached = Measure-Command {
    Show-ColorScript -Name "mandelbrot-zoom"
}

Write-Host "Senza cache: $($uncached.TotalMilliseconds)ms"
Write-Host "Con cache: $($cached.TotalMilliseconds)ms"
Write-Host "Miglioramento: $([math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 1))x"
```

#### Automation: Display Different Script Daily

Configura il tuo profilo per mostrare uno script diverso ogni giorno:

```powershell
# Nel tuo file $PROFILE:
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random
```

#### Pipeline Operations with Metadata

Esporta i metadati dei colorscript per l'uso in altri strumenti:

```powershell
# Esporta in JSON per dashboard web
Export-ColorScriptMetadata -Path ./dist/colorscripts.json -IncludeFileInfo

# Usa nell'automazione: cicla attraverso gli script
$scripts = Get-ColorScriptList -Tag Recommended -AsObject
$scripts | ForEach-Object { Show-ColorScript -Name $_.Name; Start-Sleep -Seconds 2 }
```

#### Cache Management for CI/CD Environments

Configura e gestisci la cache per distribuzioni automatizzate:

```powershell
# Imposta posizione cache temporanea per CI/CD
Set-ColorScriptConfiguration -CachePath $env:TEMP\colorscripts-cache

# Pre-costruisci cache per la distribuzione
$productionScripts = @('bars', 'arch', 'ubuntu', 'windows', 'rainbow-waves')
New-ColorScriptCache -Name $productionScripts -Force

# Verifica integrità cache
$cacheDir = (Get-ColorScriptConfiguration).Cache.Path
Get-ChildItem $cacheDir -Filter "*.cache" | Measure-Object -Sum Length
```

#### Filtering and Display Workflows

Filtraggio avanzato per display personalizzati:

```powershell
# Mostra tutti gli script raccomandati con dettagli
Get-ColorScriptList -Tag Recommended -Detailed

# Mostra script geometrici con cache disabilitata per test
Get-ColorScriptList -Category Geometric -Name "aurora-*" -AsObject |
    ForEach-Object { Show-ColorScript -Name $_.Name -NoCache }

# Esporta metadati filtrati per categoria
Export-ColorScriptMetadata -IncludeFileInfo |
    Where-Object { $_.Category -eq 'Animated' } |
    ConvertTo-Json |
    Out-File "./animated-scripts.json"
```

### INTEGRATION SCENARIOS

#### Scenario 1: Terminal Welcome Screen

```powershell
# Nel profilo:
$hour = (Get-Date).Hour
if ($hour -ge 6 -and $hour -lt 12) {
    Show-ColorScript -Tag "bright,morning" -Random
} elseif ($hour -ge 12 -and $hour -lt 18) {
    Show-ColorScript -Category Geometric -Random
} else {
    Show-ColorScript -Tag "night,dark" -Random
}
```

#### Scenario 2: CI/CD Pipeline

```powershell
# Decorazione fase di build
Show-ColorScript -Name "bars" -NoCache  # Display veloce senza cache
New-ColorScriptCache -Category "Build" -Force  # Prepara per la prossima esecuzione

# Nel contesto CI/CD:
$env:CI = $true
if ($env:CI) {
    Show-ColorScript -NoCache  # Evita cache in ambienti effimeri
}
```

#### Scenario 3: Administrative Dashboards

```powershell
# Mostra colorscript a tema sistema
$os = if ($PSVersionTable.PSVersion.Major -ge 7) { "pwsh" } else { "powershell" }
Show-ColorScript -Name $os -PassThru | Out-Null

# Mostra informazioni di stato
Get-ColorScriptList -Tag "system" -AsObject |
    ForEach-Object { Write-Host "Disponibile: $($_.Name)" }
```

#### Scenario 4: Educational Presentations

```powershell
# Mostra colorscript interattiva
Show-ColorScript -All -WaitForInput
# Gli utenti possono premere spazio per avanzare, q per uscire

# O con categoria specifica
Show-ColorScript -All -Category Abstract -WaitForInput
```

#### Scenario 5: Multi-User Environment

```powershell
# Configurazione per utente
Set-ColorScriptConfiguration -CachePath "\\shared\cache\$env:USERNAME"
Set-ColorScriptConfiguration -DefaultScript "team-logo"

# Script condivisi con personalizzazione utente
Get-ColorScriptList -AsObject |
    Where-Object { $_.Tags -contains "shared" } |
    ForEach-Object { Show-ColorScript -Name $_.Name }
```

### ADVANCED TOPICS

#### Topic 1: Cache Strategy Selection

Strategie di caching diverse per scenari diversi:

**Full Cache Strategy** (Ottimale per Workstation)

```powershell
New-ColorScriptCache              # Memorizza nella cache tutti i 450++ script
# Pro: Prestazioni massime, display istantaneo
# Contro: Utilizza 2-5MB di spazio su disco
```

**Selective Cache Strategy** (Ottimale per Portatile/CI)

```powershell
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object { New-ColorScriptCache -Name $_.Name }
# Pro: Prestazioni e archiviazione bilanciate
# Contro: Richiede più configurazione
```

**No Cache Strategy** (Ottimale per Sviluppo)

```powershell
Show-ColorScript -NoCache
# Pro: Vedi le modifiche agli script immediatamente
# Contro: Display più lento, maggiore utilizzo di risorse
```

#### Topic 2: Metadata Organization

Comprensione e organizzazione dei colorscript per metadati:

**Categories** - Raggruppamenti organizzativi ampi:

- Geometric: Frattali, pattern matematici
- Nature: Paesaggi, temi organici
- Artistic: Disegni creativi, astratti
- Gaming: Temi relativi ai giochi
- System: Temi OS/tecnologia

**Tags** - Descrittori specifici:

- Recommended: Curati per uso generale
- Animated: Pattern in movimento/cambio
- Colorful: Palette multicolori
- Minimal: Disegni semplici, puliti
- Retro: Estetica classica anni 80/90

#### Topic 3: Performance Optimization Tips

```powershell
# Suggerimento 1: Pre-carica script frequentemente utilizzati
New-ColorScriptCache -Name bars,arch,mandelbrot-zoom,aurora-waves

# Suggerimento 2: Monitora obsolescenza cache
$old = Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddMonths(-1) }

# Suggerimento 3: Usa filtraggio categoria per selezione più veloce
Show-ColorScript -Category Geometric  # Più veloce del set completo

# Suggerimento 4: Abilita output verboso per debug
Show-ColorScript -Name aurora -Verbose
```

#### Topic 4: Cross-Platform Considerations

```powershell
# Specifico per Windows Terminal
if ($env:WT_SESSION) {
    Show-ColorScript -Category Abstract -Random  # Colori massimi
}

# Terminal integrato VS Code
if ($env:TERM_PROGRAM -eq "vscode") {
    Show-ColorScript -Tag simple  # Evita rendering complesso
}

# Sessione SSH
if ($env:SSH_CONNECTION) {
    Show-ColorScript -NoCache  # Evita I/O cache lento di rete
}

# Terminal Linux/macOS
if ($PSVersionTable.PSVersion.Major -ge 7) {
    Show-ColorScript -Category Nature  # Usa script Unix-friendly
}
```

#### Topic 5: Scripting and Automation

```powershell
# Crea funzione riutilizzabile per saluto giornaliero
function Show-DailyColorScript {
    $seed = (Get-Date).DayOfYear
    Get-Random -SetSeed $seed
    Show-ColorScript -Random -Category @("Geometric", "Nature") -Random
}

# Usa nel profilo
Show-DailyColorScript

# Crea funzione rotazione script
function Invoke-ColorScriptSlideshow {
    param(
        [int]$Interval = 3,
        [string[]]$Category,
        [int]$Count
    )

    $scripts = if ($Category) {
        Get-ColorScriptList -Category $Category -AsObject
    } else {
        Get-ColorScriptList -AsObject
    }

    $scripts | Select-Object -First $Count | ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds $Interval
    }
}

# Uso
Invoke-ColorScriptSlideshow -Interval 2 -Category Geometric -Count 5
```

### TROUBLESHOOTING GUIDE

#### Issue 1: Scripts Not Displaying Correctly

**Sintomi**: Caratteri confusi o colori mancanti
**Soluzioni**:

```powershell
# Imposta codifica UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Verifica che il terminal supporti UTF-8
Write-Host "Test: ✓ ✗ ◆ ○" -ForegroundColor Green

# Usa test font nerd
Show-ColorScript -Name nerd-font-test

# Se ancora rotto, disabilita cache
Show-ColorScript -Name yourscript -NoCache
```

#### Issue 2: Module Import Failures

**Sintomi**: "Modulo non trovato" o errori di importazione
**Soluzioni**:

```powershell
# Verifica se il modulo esiste
Get-Module -ListAvailable | Where-Object Name -like "*Color*"

# Verifica PSModulePath
$env:PSModulePath -split [System.IO.Path]::PathSeparator

# Reinstalla modulo
Remove-Module ColorScripts-Enhanced
Uninstall-Module ColorScripts-Enhanced
Install-Module -Name ColorScripts-Enhanced -Force
```

#### Issue 3: Cache Not Being Used

**Sintomi**: Gli script vengono eseguiti lentamente ogni volta
**Soluzioni**:

```powershell
# Verifica che la cache esista
$cacheDir = (Get-ColorScriptConfiguration).Cache.Path
Get-ChildItem $cacheDir -Filter "*.cache" | Measure-Object

# Ricostruisci cache
Remove-Item "$cacheDir\*" -Confirm:$false
New-ColorScriptCache -Force

# Verifica problemi percorso cache
Get-ColorScriptConfiguration | Select-Object -ExpandProperty Cache
```

#### Issue 4: Profile Not Running

**Sintomi**: Colorscript non si mostra all'avvio di PowerShell
**Soluzioni**:

```powershell
# Verifica che il profilo esista
Test-Path $PROFILE

# Verifica contenuto profilo
Get-Content $PROFILE | Select-String "ColorScripts"

# Ripara profilo
Add-ColorScriptProfile -Force

# Test profilo manualmente
. $PROFILE
```

### FAQ

## Q: Quanti colorscript sono disponibili
A: 450++ script integrati in molteplici categorie e tag

## Q: Quanto spazio su disco utilizza la cache
A: Circa 2-5MB totali per tutti gli script, circa 2-50KB per script

## Q: Posso usare i colorscript negli script/automazione
A: Sì, usa `-ReturnText` per catturare l'output o `-PassThru` per metadati

## Q: Come creo colorscript personalizzati
A: Usa `New-ColorScript` per scaffoldare un template, poi aggiungi la tua arte ANSI

## Q: Cosa faccio se non voglio colori all'avvio
A: Usa `Add-ColorScriptProfile -SkipStartupScript` per importare senza auto-display

## Q: Posso usarlo su macOS/Linux
A: Sì, con PowerShell 7+ che funziona cross-platform

## Q: Come condivido i colorscript con colleghi
A: Esporta metadati con `Export-ColorScriptMetadata` o condividi file script

## Q: La cache è sempre abilitata
A: No, usa `-NoCache` per disabilitare la cache per sviluppo/test

### BEST PRACTICES

1. **Installa da PowerShell Gallery**: Usa `Install-Module` per aggiornamenti automatici
2. **Aggiungi al profilo**: Usa `Add-ColorScriptProfile` per integrazione automatica all'avvio
3. **Pre-costruisci cache**: Esegui `New-ColorScriptCache` dopo l'installazione per prestazioni ottimali
4. **Usa nomi significativi**: Quando crei script personalizzati, usa nomi descrittivi
5. **Mantieni metadati aggiornati**: Aggiorna ScriptMetadata.psd1 quando aggiungi script
6. **Testa in terminal diversi**: Verifica che gli script si visualizzino correttamente nei tuoi ambienti
7. **Monitora dimensione cache**: Controlla periodicamente la dimensione della directory cache e pulisci se necessario
8. **Usa categorie/tag**: Sfrutta il filtraggio per una scoperta più veloce degli script
9. **Documenta script personalizzati**: Aggiungi descrizioni e tag ai colorscript personalizzati
10. **Backup configurazione**: Esporta la configurazione prima di modifiche importanti

### ENVIRONMENT VARIABLES

Il modulo rispetta le seguenti variabili d'ambiente:

- **COLORSCRIPTS_CACHE**: Sostituisce la posizione predefinita della cache
- **PSModulePath**: Influenza dove il modulo viene scoperto

### PERFORMANCE TUNING

#### Metriche Prestazionali Tipiche

| Complessità Script    | Senza Cache | Con Cache | Miglioramento  |
| --------------------- | ----------- | --------- | -------------- |
| Semplice (50-100ms)   | ~50ms       | ~8ms      | 6x più veloce  |
| Medio (100-200ms)     | ~150ms      | ~12ms     | 12x più veloce |
| Complesso (200-300ms) | ~300ms      | ~16ms     | 19x più veloce |

#### Informazioni sulla Dimensione della Cache

- Dimensione media del file di cache: 2-50KB per script
- Dimensione totale della cache per tutti gli script: ~2-5MB
- Posizione della cache: Utilizza percorsi appropriati al sistema operativo per un impatto minimo

### TROUBLESHOOTING ADVANCED ISSUES

#### Errore Modulo Non Trovato

```powershell
# Verifica se il modulo è in PSModulePath
Get-Module ColorScripts-Enhanced -ListAvailable

# Elenca i percorsi dei moduli disponibili
$env:PSModulePath -split [System.IO.Path]::PathSeparator

# Importa da percorso esplicito se necessario
Import-Module "C:\Path\To\ColorScripts-Enhanced\ColorScripts-Enhanced.psd1"
```

#### Corruzione della Cache

Cancella e ricostruisci completamente:

```powershell
# Rimuovi il modulo dalla sessione
Remove-Module ColorScripts-Enhanced -Force

# Cancella tutti i file di cache
Clear-ColorScriptCache -All -Confirm:$false

# Reimporta e ricostruisci la cache
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Force
```

#### Degradazione delle Prestazioni

Se le prestazioni peggiorano nel tempo:

```powershell
# Verifica la dimensione della directory della cache
$cacheDir = (Get-ColorScriptConfiguration).Cache.Path
$size = (Get-ChildItem $cacheDir -Filter "*.cache" |
    Measure-Object -Sum Length).Sum
Write-Host "Dimensione cache: $([math]::Round($size / 1MB, 2)) MB"

# Cancella la cache vecchia e ricostruisci
Clear-ColorScriptCache -All
New-ColorScriptCache
```

### PLATFORM-SPECIFIC NOTES

#### Windows PowerShell 5.1

- Limitato solo a Windows
- Usa `powershell.exe` per eseguire gli script
- Alcune funzionalità avanzate potrebbero non essere disponibili
- Si consiglia di aggiornare a PowerShell 7+

#### PowerShell 7+ (Cross-Platform)

- Supporto completo su Windows, macOS e Linux
- Usa il comando `pwsh`
- Tutte le funzionalità completamente operative
- Consigliato per nuove distribuzioni

### DETAILED COMMAND REFERENCE

#### Panoramica dei Comandi Principali

Il modulo fornisce 10 comandi principali per gestire e visualizzare i colorscript:

## Comandi di Visualizzazione

- `Show-ColorScript` - Visualizza colorscript con molteplici modalità (casuale, denominato, elenco, tutti)
- `Get-ColorScriptList` - Elenca i colorscript disponibili con metadati dettagliati

## Gestione della Cache

- `New-ColorScriptCache` - Costruisce file di cache per le prestazioni
- `Clear-ColorScriptCache` - Rimuove file di cache con opzioni di filtraggio
- `Build-ColorScriptCache` - Alias per New-ColorScriptCache

## Configurazione

- `Get-ColorScriptConfiguration` - Recupera le impostazioni di configurazione attuali
- `Set-ColorScriptConfiguration` - Rende persistenti le modifiche alla configurazione
- `Reset-ColorScriptConfiguration` - Ripristina le impostazioni di fabbrica

## Integrazione del Profilo

- `Add-ColorScriptProfile` - Integra il modulo nel profilo PowerShell

## Sviluppo

- `New-ColorScript` - Scaffold un nuovo template di colorscript
- `Export-ColorScriptMetadata` - Esporta metadati per l'automazione

#### Pattern di Utilizzo dei Comandi

## Pattern 1: Visualizzazione Rapida

```powershell
Show-ColorScript                    # Colorscript casuale
scs                                 # Utilizzo alias del modulo
Show-ColorScript -Name aurora       # Script specifico
```

## Pattern 2: Scoperta e Elenco

```powershell
Get-ColorScriptList                 # Tutti gli script
Get-ColorScriptList -Detailed       # Con tag e descrizioni
Get-ColorScriptList -Category Nature # Filtra per categoria
Get-ColorScriptList -Tag Animated   # Filtra per tag
```

## Pattern 3: Ottimizzazione delle Prestazioni

```powershell
New-ColorScriptCache                # Costruisce tutte le cache
New-ColorScriptCache -Name bars     # Costruisce cache specifica
New-ColorScriptCache -Category Geometric  # Costruisce categoria
```

## Pattern 4: Manutenzione della Cache

```powershell
Clear-ColorScriptCache -All         # Rimuove tutte le cache
Clear-ColorScriptCache -Name "test-*"  # Cancella pattern
Clear-ColorScriptCache -Category Demo   # Cancella per categoria
```

### DETAILED WORKFLOW EXAMPLES

#### Workflow 1: Configurazione e Setup Iniziale

```powershell
# Passo 1: Installa il modulo
Install-Module -Name ColorScripts-Enhanced -Scope CurrentUser

# Passo 2: Aggiungi al profilo per avvio automatico
Add-ColorScriptProfile

# Passo 3: Pre-costruisci cache per prestazioni ottimali
New-ColorScriptCache

# Passo 4: Verifica setup
Get-ColorScriptConfiguration
```

#### Workflow 2: Uso Giornaliero con Rotazione

```powershell
# Nel file $PROFILE, aggiungi:
Import-Module ColorScripts-Enhanced

# Visualizza script diverso ogni giorno basato sulla data
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random

# Alternativa: Mostra categoria specifica
Show-ColorScript -Category Geometric -Random
```

#### Workflow 3: Integrazione Automazione

```powershell
# Esporta metadati per strumenti esterni
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$metadata | ConvertTo-Json | Out-File "./colorscripts.json"

# Usa nell'automazione: cicla attraverso gli script
$scripts = Get-ColorScriptList -Tag Recommended -AsObject
$scripts | ForEach-Object { Show-ColorScript -Name $_.Name; Start-Sleep -Seconds 2 }
```

#### Workflow 4: Monitoraggio delle Prestazioni

```powershell
# Misura l'efficacia della cache
$uncached = Measure-Command { Show-ColorScript -Name mandelbrot-zoom -NoCache }
$cached = Measure-Command { Show-ColorScript -Name mandelbrot-zoom }

Write-Host "Senza cache: $($uncached.TotalMilliseconds)ms"
Write-Host "Con cache: $($cached.TotalMilliseconds)ms"
Write-Host "Miglioramento: $([math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 1))x"
```

#### Workflow 5: Personalizzazione e Sviluppo

```powershell
# Crea colorscript personalizzato
New-ColorScript -Name "my-custom-art" -Category "Custom" -Tag "MyTag" -GenerateMetadataSnippet

# Modifica lo script
code "$env:USERPROFILE\Documents\PowerShell\Modules\ColorScripts-Enhanced\Scripts\my-custom-art.ps1"

# Aggiungi metadati (usa la guida dalla generazione)
# Modifica ScriptMetadata.psd1

# Cache e test
New-ColorScriptCache -Name "my-custom-art" -Force
Show-ColorScript -Name "my-custom-art"
```
