---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

Visualizza uno colorscript con memorizzazione nella cache selettiva per renderer costosi.

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

Rende bellissimi ANSI colorscripts nel tuo terminale con l'ottimizzazione intelligente delle prestazioni. Il cmdlet fornisce quattro modalità operative principali:

**Modalità casuale (impostazione predefinita):** Visualizza uno colorscript selezionato casualmente dalla collezione disponibile. Questo è il comportamento predefinito quando non vengono specificati parametri.

**Modalità con nome:** Visualizza uno colorscript specifico per nome. Supporta modelli di caratteri jolly per una corrispondenza flessibile. Quando più script corrispondono a un modello, viene selezionata la prima corrispondenza in ordine alfabetico.

**Modalità elenco:** Visualizza una tabella compatta contenente i nomi colorscript e le categorie primarie. Utilizzare `Get-ColorScriptList -AsObject` per record di metadati completi.

**Tutte le modalità:** scorre tutti gli colorscripts disponibili in ordine alfabetico. Particolarmente utile per mostrare l'intera collezione o scoprire nuovi script.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Visualizza uno colorscript casuale. Gli script deterministici in bundle eseguono il rendering in-process; i renderer computazionali idonei possono riutilizzare l'output memorizzato nella cache convalidato.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Visualizza lo colorscript specificato per nome esatto. L'estensione .ps1 non è richiesta.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Visualizza il primo colorscript (in ordine alfabetico) che corrisponde al modello di carattere jolly "aurora-\*". Utile quando ricordi parte del nome di uno script.

### EXAMPLE 4

```powershell
scs hearts
```

Utilizza l'alias del modulo 'scs' per un rapido accesso ai cuori colorscript. Gli alias forniscono comode scorciatoie per un uso frequente.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Elenca colorscripts disponibili per nome e categoria principale. Utile per una rapida scoperta.

### EXAMPLE 6

```powershell
Show-ColorScript -Name Galaxy -NoCache
```

Visualizza il renderer Galaxy idoneo senza leggere l'output memorizzato nella cache, forzando un nuovo rendering isolato. Utile quando si testano le modifiche del renderer o si indaga sulla corruzione della cache.

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

Visualizza uno script casuale a tema naturale e ne acquisisce l'oggetto metadati per un'ulteriore ispezione o elaborazione.

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

Esegue il rendering di colorscript e salva l'output in un file di testo. I codici ANSI renderizzati vengono conservati, consentendo la visualizzazione successiva del file con la colorazione corretta.

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

Visualizza tutti gli colorscripts in ordine alfabetico con un breve ritardo automatico tra ciascuno. Perfetto per una vetrina visiva dell'intera collezione.

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

Visualizza tutti gli colorscripts uno alla volta, facendo una pausa dopo ciascuno. Premi la barra spaziatrice per avanzare allo script successivo oppure premi 'q' per uscire anticipatamente dalla sequenza.

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

Passa attraverso tutti gli colorscripts a tema naturale con progressione manuale. Combina il filtraggio con la navigazione interattiva per un'esperienza curata.

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

Visualizza uno colorscript casuale con il tag "retro" o "geometric". Più valori di tag utilizzano la semantica di corrispondenza qualsiasi.

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Artistic,Abstract
```

Elenca solo colorscripts classificato come "Art" o "Abstract", aiutandoti a scoprire script all'interno di temi specifici.

### EXAMPLE 14

```powershell
# Esamina l'idoneità della cache e lo stato di creazione per un renderer selezionato tramite policy.
New-ColorScriptCache -Name Galaxy -Force -PassThru |
    Select-Object Name, Status, CacheFile
Show-ColorScript -Name Galaxy
```

Crea e controlla una voce della cache per un renderer idoneo senza richiedere un moltiplicatore di prestazioni indipendente dalla macchina.

### EXAMPLE 15

```powershell
# Imposta la rotazione giornaliera di diversi colorscripts
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

Visualizza un colorscript coerente ma diverso ogni giorno in base alla data.

### EXAMPLE 16

```powershell
# Esporta colorscript renderizzato in un file per la condivisione
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Successivamente, visualizza il file salvato
Get-Content "./aurora.ansi" -Raw | Write-Host
```

Salva uno colorscript renderizzato in un file che può essere visualizzato in seguito o condiviso con altri.

### EXAMPLE 17

```powershell
# Crea una presentazione di colorscripts geometrico
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

Visualizza automaticamente una sequenza di colorscripts geometrici con ritardi di 3 secondi tra ciascuno.

### EXAMPLE 18

```powershell
# Esempio di gestione degli errori
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Script non trovato: $_"
    Show-ColorScript  # Ritorno al casuale
}
```

Dimostra la gestione degli errori quando si richiede uno script che non esiste.

### EXAMPLE 19

```powershell
# Costruisci l'integrazione dell'automazione
if ($env:CI) {
    Show-ColorScript -Name "Galaxy" -NoCache
} else {
    Show-ColorScript  # Visualizzazione casuale per uso interattivo
}
```

Mostra come visualizzare in modo condizionale diversi colorscripts negli ambienti CI/CD rispetto alle sessioni interattive.

### EXAMPLE 20

```powershell
# Attività pianificata per il saluto del terminale
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

Dimostra l'esecuzione di uno colorscript specifico come parte di un'attività pianificata o dell'automazione dell'avvio.

### EXAMPLE 21

```powershell
Show-ColorScript -IncludePokemon
```

Visualizza uno colorscript casuale inclusi gli script nella categoria `Pokemon`. Utile quando vuoi che le illustrazioni dei Pokémon siano incluse nella tua selezione casuale.

### EXAMPLE 22

```powershell
Show-ColorScript -Random -ExcludeCategory Pokemon,Gaming
```

Visualizza uno colorscript casuale escludendo entrambe le categorie `Pokemon` e `Gaming`. Combinalo con `-Category` o `-Tag` per perfezionare ulteriormente la selezione.

## PARAMETERS

### -All

Scorri tutti gli colorscripts disponibili in ordine alfabetico. Se specificati da soli, gli script vengono visualizzati continuamente con un breve ritardo automatico. Combinalo con `-WaitForInput` per controllare manualmente la progressione attraverso la raccolta. Questa modalità è ideale per mostrare la libreria completa o scoprire nuovi preferiti.

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

Filtra la raccolta di script disponibile in base a una o più categorie prima che venga eseguita qualsiasi selezione o visualizzazione. Categories sono in genere temi ampi come "Nature", "Abstract", "Art", "Retro", ecc. È possibile specificare più categorie come array. Questo parametro funziona insieme a tutte le modalità (Casuale, Con nome, Elenco, Tutto) per restringere il working set.

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

Escludere gli script da una o più categorie prima che avvenga la selezione. Ad esempio, utilizza `-ExcludeCategory Pokemon` per evitare tutti gli script Pokémon o specifica più categorie come `-ExcludeCategory Pokemon,Gaming`. Funziona in tutte le modalità (Casuale, Con nome, Elenco, Tutte) e si combina con i filtri `-Category` e `-Tag`.

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

Visualizza la guida dettagliata per questo comando senza eseguire l'operazione.

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

Attiva il flag per includere il Pokémon colorscripts nella selezione. Se omessi, gli script Pokémon vengono filtrati automaticamente (impostazione predefinita). Nota: questo sostituisce il vecchio parametro `-ExcludePokemon`: il refactoring ha invertito la semantica, quindi ora accetti di mostrare gli script Pokémon invece di disattivarli.

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

Visualizza un elenco formattato di tutti gli colorscripts disponibili con i relativi metadati associati. L'output include nome dello script, categoria, tag e descrizione. Ciò è utile per esplorare le opzioni disponibili e comprendere l'organizzazione della raccolta. Può essere combinato con `-Category` o `-Tag` per elencare solo i sottoinsiemi filtrati.

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

Il nome dello colorscript da visualizzare (senza l'estensione .ps1). Supporta modelli di caratteri jolly (\* e ?) per una corrispondenza flessibile. Quando più script corrispondono a un modello di caratteri jolly, viene selezionata e visualizzata la prima corrispondenza in ordine alfabetico. Utilizzare `-PassThru` per verificare quale script è stato scelto quando si utilizzano i caratteri jolly.

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

Disabilita lo stile ANSI nei messaggi informativi e nell'output renderizzato per ambienti di testo normale.

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

Ignora le letture cache convalidate per i renderer selezionati tramite policy e forza un nuovo rendering isolato. Ciò è utile quando si testano le modifiche del renderer o si indaga sulla corruzione della cache. Gli script deterministici in bundle e gli script non elencati o personalizzati ignorano già la cache; il contenuto deterministico in bundle viene ancora visualizzato in-process.

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

Se utilizzato con `-All`, salta la chiamata automatica `Clear-Host` tra colorscripts in modo che ogni script renderizzato rimanga visibile sopra quello successivo. Ciò è particolarmente utile quando desideri confrontare gli script fianco a fianco o acquisire l'intera presentazione nelle trascrizioni delle sessioni.

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

Restituisce l'oggetto metadati di colorscript selezionato alla pipeline oltre a visualizzare colorscript. L'oggetto metadati contiene proprietà come Name, Path, Category, Tags e Description. Ciò consente l'accesso programmatico alle informazioni dello script per il filtraggio, la registrazione o l'ulteriore elaborazione pur continuando a eseguire il rendering dell'output visivo.

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

Elimina i messaggi informativi preservando l'output e gli errori dei comandi.

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

Richiedere esplicitamente una selezione casuale di colorscript. Questo è il comportamento predefinito quando non viene specificato alcun nome, quindi questa opzione è utile principalmente per chiarezza negli script o quando si desidera essere espliciti sulla modalità di selezione. Può essere combinato con `-Category` o `-Tag` per randomizzare all'interno di un sottoinsieme filtrato.

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

Emetti lo colorscript renderizzato come string nella pipeline PowerShell invece di scrivere direttamente sull'host della console. Ciò consente di acquisire l'output in una variabile, reindirizzarlo a un file o reindirizzarlo ad altri comandi. L'output conserva tutte le sequenze di escape ANSI, quindi verrà visualizzato con i colori appropriati quando verrà successivamente scritto su un terminale compatibile.

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

Filtra la raccolta di script disponibile in base ai tag di metadati (senza distinzione tra maiuscole e minuscole). Tags sono descrittori più specifici delle categorie, come "geometric", "retro", "animated", "minimal", ecc. È possibile specificare più tag come array. Gli script che corrispondono a uno qualsiasi dei tag specificati verranno inclusi nel working set prima che venga effettuata la selezione.

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

Aggiorna l'indicatore dei metadati della cache a livello di modulo prima del rendering, anche quando la directory della cache era già inizializzata nella sessione del modulo corrente. Non ricostruisce le voci della cache di output né sostituisce la normale convalida per voce. L'impostazione di `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE` su `1`, `true` o `yes` richiede lo stesso aggiornamento durante l'inizializzazione della cache.

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

Se utilizzato con `-All`, fare una pausa dopo aver visualizzato ciascun colorscript e attendere l'input dell'utente prima di procedere. Premi la barra spaziatrice per avanzare allo script successivo nella sequenza. Premere 'q' per uscire anticipatamente dalla sequenza e tornare al prompt. Ciò fornisce un'esperienza di navigazione interattiva attraverso l'intera raccolta.

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

Questo cmdlet supporta i parametri comuni:
Per ulteriori informazioni, vedere
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Questo cmdlet non accetta input dalla pipeline. Convogliare i record di inventario in `ForEach-Object` e chiamare `Show-ColorScript -Name $_.Name` durante la composizione di una pipeline.

## OUTPUTS

### System.Object

Quando è specificato `-PassThru`, restituisce l'oggetto metadati di colorscript selezionato contenente proprietà come Nome, Path, Categoria, Tag e Descrizione.

### System.String (2)

Quando viene specificato `-ReturnText`, emette lo colorscript renderizzato come string nella pipeline. Questo string contiene tutte le sequenze di escape ANSI per una corretta resa cromatica quando visualizzato in un terminale compatibile.

### None

Nel funzionamento predefinito (senza `-PassThru` o `-ReturnText`), l'output viene scritto direttamente sull'host della console e non viene restituito nulla alla pipeline.

## NOTES

**Autore:** Nick
**Modulo:** ColorScripts-Enhanced
**Richiede:** PowerShell 5.1 o versione successiva

## RELATED LINKS

- [Versione online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

