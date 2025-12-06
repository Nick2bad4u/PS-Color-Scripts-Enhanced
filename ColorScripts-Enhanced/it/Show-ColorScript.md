---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/it/Show-ColorScript.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Show-ColorScript

## SYNOPSIS

Visualizza uno script di colore con caching automatico per prestazioni migliorate.

## SYNTAX

### Random (Default)

```text
Show-ColorScript [-Random] [-NoCache] [-Category <String[]>] [-Tag <String[]>]
 [-ExcludeCategory <String[]>] [-IncludePokemon] [-PassThru]
 [-ReturnText] [<CommonParameters>]
```

### Named

```text
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <String[]>] [-IncludePokemon] [-PassThru]
 [-ReturnText] [<CommonParameters>]
```

### List

```text
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <String[]>] [-IncludePokemon] [-ReturnText]
 [<CommonParameters>]
```

### All

```text
Show-ColorScript [-All] [-WaitForInput] [-NoCache] [-Category <String[]>] [-Tag <String[]>]
 [-ExcludeCategory <String[]>] [-IncludePokemon]
 [<CommonParameters>]
```

## DESCRIPTION

Rendering di bellissimi script di colore ANSI nel tuo terminale con ottimizzazione intelligente delle prestazioni. Il cmdlet fornisce quattro modalità operative principali:

**Random Mode (Default):** Visualizza uno script di colore selezionato casualmente dalla collezione disponibile. Questo è il comportamento predefinito quando non vengono specificati parametri.

**Named Mode:** Visualizza uno specifico script di colore per nome. Supporta pattern con caratteri jolly per una corrispondenza flessibile. Quando più script corrispondono a un pattern, viene selezionato il primo match in ordine alfabetico.

**List Mode:** Visualizza una lista formattata di tutti gli script di colore disponibili con i loro metadati, inclusi nome, categoria, tag e descrizioni.

**All Mode:** Scorre attraverso tutti gli script di colore disponibili in ordine alfabetico. Particolarmente utile per mostrare l'intera collezione o scoprire nuovi script.

## Performance Features
Il sistema di caching fornisce miglioramenti delle prestazioni di 6-19x. Alla prima esecuzione, uno script di colore viene eseguito normalmente e il suo output viene memorizzato nella cache. Le visualizzazioni successive utilizzano l'output memorizzato nella cache per un rendering quasi istantaneo. La cache viene invalidata automaticamente quando gli script sorgente vengono modificati, garantendo l'accuratezza dell'output.

## Filtering Capabilities
Filtra gli script per categoria o tag prima che avvenga la selezione. Questo si applica attraverso tutte le modalità, permettendo di lavorare con sottoinsiemi della collezione (ad esempio, solo script a tema natura o script taggati come "retro").

## Output Options
Per impostazione predefinita, gli script di colore vengono scritti direttamente nella console per una visualizzazione visiva immediata. Usa `-ReturnText` per emettere l'output renderizzato nella pipeline per cattura, reindirizzamento o ulteriore elaborazione. Usa `-PassThru` per ricevere l'oggetto metadati dello script per uso programmatico.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Visualizza uno script di colore casuale con caching abilitato. Questo è il modo più veloce per aggiungere un tocco visivo alla tua sessione terminale.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Visualizza lo script di colore specificato per nome esatto. L'estensione .ps1 non è richiesta.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Visualizza il primo script di colore (in ordine alfabetico) che corrisponde al pattern con caratteri jolly "aurora-\*". Utile quando ricordi parte del nome di uno script.

### EXAMPLE 4

```powershell
scs hearts
```

Utilizza l'alias del modulo 'scs' per un accesso rapido allo script di colore hearts. Gli alias forniscono scorciatoie convenienti per uso frequente.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Elenca tutti gli script di colore disponibili con i loro metadati in una tabella formattata. Utile per scoprire script disponibili e i loro attributi.

### EXAMPLE 6

```powershell
Show-ColorScript -Name arch -NoCache
```

Visualizza lo script di colore arch senza utilizzare la cache, forzando un'esecuzione fresca. Utile durante lo sviluppo o quando si risolvono problemi di cache.

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

Visualizza uno script casuale a tema natura e cattura il suo oggetto metadati per ulteriore ispezione o elaborazione.

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

Rendering dello script di colore e salva l'output in un file di testo. I codici ANSI renderizzati sono preservati, permettendo al file di essere visualizzato successivamente con la colorazione appropriata.

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

Visualizza tutti gli script di colore in ordine alfabetico con un breve ritardo automatico tra ciascuno. Perfetto per una presentazione visiva dell'intera collezione.

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

Visualizza tutti gli script di colore uno alla volta, facendo pausa dopo ciascuno. Premi barra spaziatrice per avanzare al prossimo script, o premi 'q' per uscire dalla sequenza presto.

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

Scorre attraverso tutti gli script di colore a tema natura con progressione manuale. Combina filtraggio con navigazione interattiva per un'esperienza curata.

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

Visualizza uno script di colore casuale che ha sia i tag "retro" che "geometric". Il filtraggio per tag abilita una selezione precisa di sottoinsiemi.

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Art,Abstract
```

Elenca solo gli script di colore categorizzati come "Art" o "Abstract", aiutandoti a scoprire script all'interno di temi specifici.

### EXAMPLE 14

```powershell
# Measure performance improvement from caching
$uncached = Measure-Command { Show-ColorScript -Name spectrum -NoCache }
$cached = Measure-Command { Show-ColorScript -Name spectrum }
Write-Host "Uncached: $($uncached.TotalMilliseconds)ms | Cached: $($cached.TotalMilliseconds)ms | Speedup: $([math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 1))x"
```

Dimostra il miglioramento delle prestazioni fornito dal caching misurando il tempo di esecuzione.

### EXAMPLE 15

```powershell
# Set up daily rotation of different colorscripts
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

Visualizza uno script di colore consistente ma diverso ogni giorno basato sulla data.

### EXAMPLE 16

```powershell
# Export rendered colorscript to file for sharing
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Later, display the saved file
Get-Content "./aurora.ansi" -Raw | Write-Host
```

Salva uno script di colore renderizzato in un file che può essere visualizzato successivamente o condiviso con altri.

### EXAMPLE 17

```powershell
# Create a slideshow of geometric colorscripts
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

Visualizza automaticamente una sequenza di script di colore geometrici con ritardi di 3 secondi tra ciascuno.

### EXAMPLE 18

```powershell
# Error handling example
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Script not found: $_"
    Show-ColorScript  # Fallback to random
}
```

Dimostra la gestione degli errori quando si richiede uno script che non esiste.

### EXAMPLE 19

```powershell
# Build automation integration
if ($env:CI) {
    Show-ColorScript -Name "nerd-font-test" -NoCache
} else {
    Show-ColorScript  # Random display for interactive use
}
```

Mostra come visualizzare condizionatamente diversi script di colore in ambienti CI/CD vs. sessioni interattive.

### EXAMPLE 20

```powershell
# Scheduled task for terminal greeting
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

Dimostra l'esecuzione di uno specifico script di colore come parte di un task programmato o automazione di avvio.

## PARAMETERS

### -All

Scorre attraverso tutti gli script di colore disponibili in ordine alfabetico. Quando specificato da solo, gli script vengono visualizzati continuamente con un breve ritardo automatico. Combina con `-WaitForInput` per controllare manualmente la progressione attraverso la collezione. Questa modalità è ideale per mostrare l'intera libreria o scoprire nuovi preferiti.

```yaml
Type: SwitchParameter
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
HelpMessage: ""
```

### -Category

Filtra la collezione di script disponibili per una o più categorie prima che avvenga qualsiasi selezione o visualizzazione. Le categorie sono tipicamente temi ampi come "Nature", "Abstract", "Art", "Retro", ecc. È possibile specificare più categorie come array. Questo parametro funziona in congiunzione con tutte le modalità (Random, Named, List, All) per restringere il set di lavoro.

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

### -List

Visualizza una lista formattata di tutti gli script di colore disponibili con i loro metadati associati. L'output include nome dello script, categoria, tag e descrizione. Questo è utile per esplorare le opzioni disponibili e comprendere l'organizzazione della collezione. Può essere combinato con `-Category` o `-Tag` per elencare solo sottoinsiemi filtrati.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: List
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

Il nome dello script di colore da visualizzare (senza l'estensione .ps1). Supporta pattern con caratteri jolly (\* e ?) per una corrispondenza flessibile. Quando più script corrispondono a un pattern con caratteri jolly, viene selezionato e visualizzato il primo match in ordine alfabetico. Usa `-PassThru` per verificare quale script è stato scelto quando si utilizzano caratteri jolly.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
 - Name: Named
   Position: 0
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -NoCache

Ignora il sistema di caching ed esegue lo script di colore direttamente. Questo forza un'esecuzione fresca e può essere utile quando si testano modifiche agli script, si esegue il debug o quando si sospetta una corruzione della cache. Senza questo switch, viene utilizzato l'output memorizzato nella cache quando disponibile per prestazioni ottimali.

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

### -PassThru

Restituisce l'oggetto metadati dello script di colore selezionato alla pipeline oltre a visualizzare lo script di colore. L'oggetto metadati contiene proprietà come Name, Path, Category, Tags e Description. Questo abilita l'accesso programmatico alle informazioni dello script per filtraggio, logging o ulteriore elaborazione continuando a rendere l'output visivo.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Random
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
 - Name: Named
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Random

Richiede esplicitamente una selezione casuale di script di colore. Questo è il comportamento predefinito quando non viene specificato alcun nome, quindi questo switch è principalmente utile per chiarezza negli script o quando si vuole essere espliciti sulla modalità di selezione. Può essere combinato con `-Category` o `-Tag` per randomizzare all'interno di un sottoinsieme filtrato.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Random
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -ReturnText

Emette lo script di colore renderizzato come stringa nella pipeline di PowerShell invece di scrivere direttamente nell'host della console. Questo permette di catturare l'output in una variabile, reindirizzarlo a un file o inviarlo ad altri comandi. L'output mantiene tutte le sequenze di escape ANSI, quindi verrà visualizzato con i colori appropriati quando scritto successivamente in un terminale compatibile.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
 - AsString
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

Filtra la collezione di script disponibili per tag di metadati (case-insensitive). I tag sono descrittori più specifici delle categorie, come "geometric", "retro", "animated", "minimal", ecc. È possibile specificare più tag come array. Gli script che corrispondono a qualsiasi dei tag specificati verranno inclusi nel set di lavoro prima che avvenga la selezione.

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

### -WaitForInput

Quando utilizzato con `-All`, mette in pausa dopo aver visualizzato ogni script di colore e attende l'input dell'utente prima di procedere. Premi la barra spaziatrice per avanzare al prossimo script nella sequenza. Premi 'q' per uscire dalla sequenza presto e tornare al prompt. Questo fornisce un'esperienza di navigazione interattiva attraverso l'intera collezione.

```yaml
Type: SwitchParameter
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
HelpMessage: ""
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Puoi passare i nomi degli script di colore tramite pipeline a Show-ColorScript. Questo abilita flussi di lavoro basati su pipeline dove i nomi degli script vengono generati o filtrati da altri comandi.

## OUTPUTS

### System.Object

Quando viene specificato `-PassThru`, restituisce l'oggetto metadati dello script di colore selezionato contenente proprietà come Name, Path, Category, Tags e Description.

### System.String (2)

Quando viene specificato `-ReturnText`, emette lo script di colore renderizzato come stringa nella pipeline. Questa stringa contiene tutte le sequenze di escape ANSI per il corretto rendering dei colori quando visualizzata in un terminale compatibile.

### None

Nell'operazione predefinita (senza `-PassThru` o `-ReturnText`), l'output viene scritto direttamente nell'host della console e nulla viene restituito alla pipeline.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## Performance
Il sistema di caching intelligente fornisce miglioramenti delle prestazioni di 6-19x rispetto all'esecuzione diretta. I file di cache sono memorizzati in una directory gestita dal modulo e vengono invalidati automaticamente quando gli script sorgente vengono modificati, garantendo l'accuratezza.

## Cache Management

- Posizione cache: Usa `(Get-Module ColorScripts-Enhanced).ModuleBase` e cerca la directory cache
- Cancella cache: Usa `Clear-ColorScriptCache` per ricostruire da zero
- Ricostruisci cache: Usa `New-ColorScriptCache` per pre-popolare la cache per tutti gli script
- Ispeziona cache: I file di cache sono testo semplice e possono essere visualizzati direttamente

## Tips

- Aggiungi `Show-ColorScript -Random` al tuo profilo PowerShell per un saluto colorato ad ogni avvio di sessione
- Usa l'alias del modulo `scs` per un accesso rapido: `scs -Random`
- Combina filtri di categoria e tag per una selezione precisa
- Usa `-List` per scoprire nuovi script e imparare sui loro temi
- La combinazione `-All -WaitForInput` è perfetta per presentare la collezione ad altri

## Compatibility
Colorscripts use ANSI escape sequences and display best in terminals with full color support, such as Windows Terminal, ConEmu, or modern Unix terminals.

## ADVANCED USAGE

### Filtering Strategies

## By Category and Tag Combination

```powershell
# Mostra solo gli script di colore geometrici taggati come minimal
Show-ColorScript -Category Geometric -Tag minimal -Random

# Mostra solo gli script di colore raccomandati dalla categoria natura
Show-ColorScript -Category Nature -Tag Recommended -Random

# Visualizza più categorie con tag specifico
Show-ColorScript -Category Geometric,Abstract -Tag colorful -Random
```

## Dynamic Filtering Based on Time

```powershell
# Mattina: colori brillanti
if ((Get-Date).Hour -lt 12) {
    Show-ColorScript -Tag bright,colorful -Random
}
# Sera: palette più scure
else {
    Show-ColorScript -Tag dark,minimal -Random
}
```

### Output Capture Patterns

## Save for Later Viewing

```powershell
# Salva in variabile
$art = Show-ColorScript -Name spectrum -ReturnText
$art | Out-File "./my-art.ansi" -Encoding UTF8

# Visualizza successivamente
Get-Content "./my-art.ansi" -Raw | Write-Host
```

## Create Themed Collections

```powershell
# Raccogli tutti gli script geometrici
$geometric = Get-ColorScriptList -Category Geometric -AsObject

# Salva ciascuno
$geometric | ForEach-Object {
    Show-ColorScript -Name $_.Name -ReturnText |
        Out-File "./collection/$($_.Name).ansi" -Encoding UTF8
}
```

### Performance Analysis

## Comprehensive Benchmark

```powershell
# Funzione per misurare le prestazioni degli script di colore
function Measure-ColorScriptPerformance {
    param([string]$Name)

    # Riscaldamento cache
    Show-ColorScript -Name $Name | Out-Null

    # Prestazioni con cache
    $cached = Measure-Command { Show-ColorScript -Name $Name }

    # Prestazioni senza cache
    Clear-ColorScriptCache -Name $Name -Confirm:$false
    $uncached = Measure-Command { Show-ColorScript -Name $Name -NoCache }

    [PSCustomObject]@{
        Script = $Name
        Cached = $cached.TotalMilliseconds
        Uncached = $uncached.TotalMilliseconds
        Improvement = [math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 2)
    }
}

# Testa più script
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object { Measure-ColorScriptPerformance -Name $_.Name }
```

### Terminal Customization

## Terminal-Specific Display

```powershell
# Windows Terminal con supporto ANSI
if ($env:WT_SESSION) {
    Show-ColorScript -Category Abstract -Random  # Colori massimi
}

# Terminale VS Code
if ($env:TERM_PROGRAM -eq "vscode") {
    Show-ColorScript -Tag simple  # Evita rendering complesso
}

# Sessione SSH (potenzialmente limitata)
if ($env:SSH_CONNECTION) {
    Show-ColorScript -NoCache -Category Simple  # Overhead minimo
}

# Terminale ConEmu
if ($env:ConEmuANSI -eq "ON") {
    Show-ColorScript -Random  # Supporto ANSI completo
}
```

### Automation Integration

## Scheduled Colorscript Rotation

```powershell
# Crea wrapper per task programmato
function Start-ColorScriptSession {
    param(
        [int]$MaxScripts = 5,
        [string[]]$Categories = @("Geometric", "Nature"),
        [int]$DelaySeconds = 2
    )

    Get-ColorScriptList -Category $Categories -AsObject |
        Select-Object -First $MaxScripts |
        ForEach-Object {
            Write-Host "`n=== $($_.Name) ($($_.Category)) ===" -ForegroundColor Cyan
            Show-ColorScript -Name $_.Name
            Start-Sleep -Seconds $DelaySeconds
        }
}
```

### Error Handling and Resilience

## Graceful Fallback

```powershell
# Prova script specifico, fallback a casuale
try {
    Show-ColorScript -Name "specific-script" -ErrorAction Stop
} catch {
    Write-Warning "Script specifico non trovato, mostra casuale"
    Show-ColorScript -Random
}
```

## Validation Before Display

```powershell
# Verifica che lo script esista prima di visualizzarlo
$scripts = Get-ColorScriptList -AsObject
$scriptName = "aurora-waves"

if ($scriptName -in $scripts.Name) {
    Show-ColorScript -Name $scriptName
} else {
    Write-Error "$scriptName non trovato"
    Get-ColorScriptList | Out-Host
}
```

### Metadata Inspection

## Inspect Before Displaying

```powershell
# Ottieni metadati durante la visualizzazione
$metadata = Show-ColorScript -Name aurora-waves -PassThru

Write-Host "`nDettagli Script:`n"
$metadata | Select-Object Name, Category, Tags, Description | Format-List

# Usa metadati per decisioni
if ($metadata.Tags -contains "Animated") {
    Write-Host "Questo è uno script animato"
}
```

## NOTES (2)

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## Performance (2)
The intelligent caching system provides 6-19x performance improvements over direct execution. Cache files are stored in a module-managed directory and are automatically invalidated when source scripts are modified, ensuring accuracy.

## Cache Management (2)

- Cache location: Use `(Get-Module ColorScripts-Enhanced).ModuleBase` and look for the cache directory
- Clear cache: Use `Clear-ColorScriptCache` to rebuild from scratch
- Rebuild cache: Use `New-ColorScriptCache` to pre-populate cache for all scripts
- Inspect cache: Cache files are plain text and can be viewed directly

## Advanced Tips

- Use `-PassThru` to get metadata while displaying for post-processing
- Combine `-ReturnText` with pipeline commands for advanced text manipulation
- Use `-NoCache` during development of custom colorscripts for immediate feedback
- Filter by multiple categories/tags for more precise selection
- Store frequently-used scripts in variables for quick access
- Use `-List` with `-Category` and `-Tag` to explore available content
- Monitor cache hits with performance measurements
- Consider terminal capabilities when selecting scripts
- Use environment variables to customize behavior per environment
- Implement error handling for automated display scenarios

## Terminal Compatibility Matrix

| Terminal           | ANSI Support | UTF-8     | Performance | Notes                      |
| ------------------ | ------------ | --------- | ----------- | -------------------------- |
| Windows Terminal   | ✓ Excellent  | ✓ Full    | Excellent   | Recommended                |
| ConEmu             | ✓ Good       | ✓ Full    | Good        | Legacy but reliable        |
| VS Code            | ✓ Good       | ✓ Full    | Very Good   | Slight rendering delay     |
| PowerShell ISE     | ✗ Limited    | ✗ Limited | N/A         | Not recommended            |
| SSH Terminal       | ✓ Varies     | ✓ Depends | Varies      | Network latency may affect |
| Windows 10 Console | ✗ No         | ✓ Yes     | N/A         | Not recommended            |

## RELATED LINKS

- [Get-ColorScriptList](Get-ColorScriptList.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)

