---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

Visualizza un colorscript e usa la cache selettiva solo per i renderer costosi.

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Help

```
Show-ColorScript [-h] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Named

```
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### List

```
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### All

```
Show-ColorScript [-All] [-WaitForInput] [-NoClear] [-NoCache] [-Category <string[]>]
 [-Tag <string[]>] [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

## ALIASES

- `scs`

## DESCRIPTION

Rendering di bellissimi script di colore ANSI nel tuo terminale con ottimizzazione intelligente delle prestazioni. Il cmdlet fornisce quattro modalità operative principali:

**Random Mode (Default):** Visualizza uno script di colore selezionato casualmente dalla collezione disponibile. Questo è il comportamento predefinito quando non vengono specificati parametri.

**Named Mode:** Visualizza uno specifico script di colore per nome. Supporta pattern con caratteri jolly per una corrispondenza flessibile. Quando più script corrispondono a un pattern, viene selezionato il primo match in ordine alfabetico.

**List Mode:** Visualizza una lista formattata di tutti gli script di colore disponibili con i loro metadati, inclusi nome, categoria, tag e descrizioni.

**All Mode:** Scorre attraverso tutti gli script di colore disponibili in ordine alfabetico. Particolarmente utile per mostrare l'intera collezione o scoprire nuovi script.

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

### -Category

Filtra la collezione di script disponibili per una o più categorie prima che avvenga qualsiasi selezione o visualizzazione. Le categorie sono tipicamente temi ampi come "Nature", "Abstract", "Art", "Retro", ecc. È possibile specificare più categorie come array. Questo parametro funziona in congiunzione con tutte le modalità (Random, Named, List, All) per restringere il set di lavoro.

```yaml
Type: System.String[]
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

### -ExcludeCategory

Exclude scripts from one or more categories.
Use this to filter out large collections like Pokemon scripts.

```yaml
Type: System.String[]
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

### -h

Visualizza la guida dettagliata del comando senza eseguire l'operazione.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- help
ParameterSets:
- Name: Help
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IncludePokemon

Opt-in flag to include Pokemon colorscripts in the random selection.
When omitted, Pokemon scripts are filtered out automatically.

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
HelpMessage: ''
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
HelpMessage: ''
```

### -Name

Il nome dello script di colore da visualizzare (senza l'estensione .ps1). Supporta pattern con caratteri jolly (\* e ?) per una corrispondenza flessibile. Quando più script corrispondono a un pattern con caratteri jolly, viene selezionato e visualizzato il primo match in ordine alfabetico. Usa `-PassThru` per verificare quale script è stato scelto quando si utilizzano caratteri jolly.

```yaml
Type: System.String
DefaultValue: ''
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
HelpMessage: ''
```

### -NoAnsiOutput

Disabilita la formattazione ANSI nei messaggi informativi e nell'output renderizzato per gli ambienti di solo testo.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- NoColor
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
HelpMessage: ''
```

### -NoClear

When cycling through scripts with -All, skip clearing the host between displays so prior output remains visible.

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
HelpMessage: ''
```

### -Quiet

Nasconde i messaggi informativi senza sopprimere l'output del comando o gli errori.

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
HelpMessage: ''
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
HelpMessage: ''
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
HelpMessage: ''
```

### -Tag

Filtra la collezione di script disponibili per tag di metadati (case-insensitive). I tag sono descrittori più specifici delle categorie, come "geometric", "retro", "animated", "minimal", ecc. È possibile specificare più tag come array. Gli script che corrispondono a qualsiasi dei tag specificati verranno inclusi nel set di lavoro prima che avvenga la selezione.

```yaml
Type: System.String[]
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

### -ValidateCache

Forces cache validation before rendering.
Use when you need to rebuild cached colorscript output manually.

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
HelpMessage: ''
```

### -WaitForInput

Quando utilizzato con `-All`, mette in pausa dopo aver visualizzato ogni script di colore e attende l'input dell'utente prima di procedere. Premi la barra spaziatrice per avanzare al prossimo script nella sequenza. Premi 'q' per uscire dalla sequenza presto e tornare al prompt. Questo fornisce un'esperienza di navigazione interattiva attraverso l'intera collezione.

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

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

