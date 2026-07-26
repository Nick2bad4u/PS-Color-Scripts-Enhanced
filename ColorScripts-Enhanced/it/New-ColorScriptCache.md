---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

Precostruisci o aggiorna i file di cache colorscript per un rendering più veloce.

## SYNTAX

### Selection (Default)

```
New-ColorScriptCache [-Name <string[]>] [-Force] [-PassThru] [-Category <string[]>]
 [-Tag <string[]>] [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon]
 [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Category <string[]>] [-Tag <string[]>]
 [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon] [-WhatIf] [-Confirm]
```

## ALIASES

- `Build-ColorScriptCache`
- `Update-ColorScriptCache`

## DESCRIPTION

`New-ColorScriptCache` esegue il rendering dei colorscript computazionali selezionati in base ai criteri e salva l'output come UTF-8 senza BOM. I renderer in bundle idonei utilizzano il percorso di esecuzione isolato del modulo; i lavoratori paralleli sono disponibili su PowerShell 7+. Gli script deterministici in bundle eseguono il rendering in-process e non creano mai file di cache. Gli alias sono `Update-ColorScriptCache` e `Build-ColorScriptCache`.

È possibile indirizzare gli script per nome (caratteri jolly supportati), categoria o tag. Quando non vengono specificati parametri, il cmdlet risolve direttamente i nomi in `CachePolicy.psd1` invece di enumerare l'intera raccolta. Anche i nomi esatti raggruppati utilizzano una ricerca diretta di file. Le richieste di caratteri jolly, categorie e tag vengono enumerate solo quando la semantica corrispondente lo richiede. Gli script espliciti non elencati vengono restituiti con lo stato `SkippedNotRequired` quando viene utilizzato `-PassThru` e tutti i file di cache obsoleti per tali script vengono rimossi.

Per impostazione predefinita, il cmdlet visualizza lo stato di avanzamento oltre a un riepilogo conciso dell'operazione di memorizzazione nella cache e della directory della cache effettiva. Utilizza `-PassThru` per restituire oggetti risultato dettagliati per ogni script, che puoi ispezionare a livello di codice per verificare lo stato, l'output standard e i flussi di errore. Combina `-Quiet` per sopprimere completamente l'avanzamento e il riepilogo oppure `-NoAnsiOutput` per generare riepiloghi in testo semplice senza codici colore ANSI per ambienti che non li supportano.

Il cmdlet ignora in modo intelligente gli script i cui file di cache sono già aggiornati a meno che non si specifichi il parametro `-Force`. Le build ripetute convalidano il piccolo sidecar `<name>.cacheinfo` senza caricare il payload `<name>.cache` renderizzato. `-Force` ricostruisce le voci della cache idonee ma non sovrascrive mai la policy della cache.

Entrambi i file risiedono in `(Get-ColorScriptConfiguration).Cache.EffectivePath`. Il file `.cache` contiene l'output del terminale renderizzato; `.cacheinfo` contiene solo metadati di convalida. Un sidecar senza il suo carico utile non è una voce della cache utilizzabile e viene riparato dalla build successiva. `Clear-ColorScriptCache -All` rimuove le voci complete e i sidecar orfani.

Per ricostruzioni più rapide su sistemi multi-core, utilizzare lo switch `-Parallel` insieme al parametro `-ThrottleLimit` (o `-Threads`) per controllare il conteggio dei lavoratori. Il cmdlet ripristina automaticamente l'esecuzione sequenziale quando non è possibile creare spazi di esecuzione paralleli sull'host corrente.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Risolvi e riscalda solo i renderer computazionali selezionati dalla policy senza enumerare tutti gli script forniti con il modulo. Questo è il comportamento predefinito quando non vengono specificati parametri.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name Galaxy, 'rose-*'
```

Memorizza nella cache un mix di corrispondenze esatte e con caratteri jolly. Vengono create solo le partite incluse in `CachePolicy.psd1`; altre corrispondenze riportano `SkippedNotRequired` con `-PassThru`.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name Galaxy -Force -PassThru | Format-List
```

Forzare una ricostruzione della cache 'Galaxy' idonea anche se è aggiornata ed esaminare l'oggetto risultato dettagliato.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Mathematical' -PassThru
```

Valuta gli script nella categoria `Mathematical`, memorizza nella cache i renderer idonei e restituisce risultati dettagliati per ogni corrispondenza.

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

Ricostruisci le cache idonee per gli script contrassegnati con 'geometric' o 'colorful', forzando la rigenerazione anche se le cache sono correnti.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Mathematical -AsObject | New-ColorScriptCache -PassThru
```

Esempio di pipeline: valuta gli script nella categoria `Mathematical`, memorizza nella cache tutti i renderer selezionati dai criteri e restituisce un risultato per ogni corrispondenza.

### EXAMPLE 7

```powershell
# Controlla le statistiche della cache dopo la creazione
$cachePath = (Get-ColorScriptConfiguration).Cache.EffectivePath
$before = @(Get-ChildItem $cachePath -Filter "*.cache" -ErrorAction SilentlyContinue).Count
New-ColorScriptCache
$after = @(Get-ChildItem $cachePath -Filter "*.cache").Count
Write-Host "Script memorizzati nella cache: $before -> $after"
```

Misura la crescita della cache contando i file di cache selezionati dai criteri prima e dopo l'operazione.

### EXAMPLE 8

```powershell
# Crea cache per renderer computazionali utilizzati di frequente
$frequentScripts = @('Galaxy', 'rose-curves', 'wave-interference')
New-ColorScriptCache -Name $frequentScripts -PassThru | Format-Table Name, Status, ExitCode
```

Crea cache per gli script elencati idonei in `CachePolicy.psd1`; i nomi non elencati vengono saltati.

### EXAMPLE 9

```powershell
# Utilizza la visualizzazione dell'avanzamento integrata nell'ambito dei criteri
New-ColorScriptCache -All
```

Mostra l'avanzamento integrato per i renderer selezionati tramite policy senza ripetere manualmente tutti gli script disponibili.

### EXAMPLE 10

```powershell
# Facoltativamente, primerizza le voci di policy mancanti o obsolete da un profilo PowerShell.
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Quiet
```

Controlla le voci selezionate dai criteri quando il profilo viene caricato e crea solo le voci mancanti o obsolete. Omettere questo passaggio del profilo quando non si desidera il funzionamento della cache di avvio.

### EXAMPLE 11

```powershell
# Ricostruisci ogni voce selezionata dalla policy per la distribuzione
New-ColorScriptCache -All -Force -PassThru |
    Select-Object Name, Status |
    Export-Csv "./cache-deployment.csv"
```

Ricostruisce ogni voce della cache selezionata dalla policy ed esporta gli stati in un manifesto di distribuzione.

### EXAMPLE 12

```powershell
# Trova gli errori di compilazione della cache
New-ColorScriptCache -Name "Galaxy" -Force -PassThru |
    Where-Object Status -eq 'Failed' |
    Select-Object Name, StdErr
```

Identifica gli errori di memorizzazione nella cache senza considerare i salti dei criteri come errori.

### EXAMPLE 13

```powershell
# Conta le voci selezionate dai criteri aggiornate da questa esecuzione
New-ColorScriptCache -All -PassThru |
    Where-Object Status -eq 'Updated' |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

Controlla ogni voce selezionata dalla policy e mostra quanti payload della cache sono stati aggiornati da questa esecuzione.

### EXAMPLE 14

```powershell
New-ColorScriptCache -All -Parallel -Threads 8
```

Crea tutte le cache selezionate dalla policy utilizzando otto thread di lavoro. Il cmdlet torna automaticamente all'esecuzione sequenziale quando i processi paralleli non sono disponibili sull'host corrente.

## PARAMETERS

### -All

Risolvi direttamente ogni voce della policy della cache. Vengono elaborati solo gli script selezionati dai criteri; l'intero inventario colorscript non viene enumerato.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

Filtra gli script valutati per categoria di metadati (senza distinzione tra maiuscole e minuscole). Più valori vengono trattati come un filtro OR. Vengono memorizzate nella cache solo le corrispondenze consentite da `CachePolicy.psd1`; altre corrispondenze riportano `SkippedNotRequired` con `-PassThru`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Richiede conferma prima di eseguire il cmdlet. Utile quando si memorizza nella cache un numero elevato di script o quando si utilizza `-Force` per impedire la rigenerazione accidentale della cache.

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

### -Force

Ricostruisci le voci della cache idonee anche quando i metadati di convalida `.cacheinfo` indicano che sono aggiornati. Ciò non prevale su `CachePolicy.psd1`.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Amplia la selezione idonea per valutare gli script Pokémon. Non sovrascrive `CachePolicy.psd1`; solo i nomi dei Pokémon elencati in `CacheablePokemonScripts` possono essere memorizzati nella cache e l'elenco è attualmente vuoto.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Uno o più nomi colorscript da valutare per la memorizzazione nella cache. Supporta modelli con caratteri jolly (ad esempio, `aurora-*` e `*-wave`). Gli script corrispondenti vengono memorizzati nella cache solo quando elencati in `CachePolicy.psd1`. Quando questo parametro e tutti i filtri vengono omessi, solo le voci dei criteri vengono risolte e valutate.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAnsiOutput

Disabilita le sequenze di colori ANSI nell'output informativo. Ciò è utile in ambienti che non eseguono il rendering dei codici di escape ANSI (come alcuni registri CI/CD) preservando comunque l'output colorato quando lo si desidera.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- NoColor
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Parallel

Abilita la creazione di cache multi-thread. Quando specificato, il cmdlet esegue processi di cache in un pool di spazi di esecuzione per un completamento più rapido sui sistemi compatibili. Utilizzare in combinazione con `-ThrottleLimit` (o l'alias `-Threads`) per controllare il numero di lavoratori simultanei. Se non è possibile inizializzare il multithreading, il cmdlet torna automaticamente all'esecuzione sequenziale.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Restituisce oggetti risultato dettagliati per ogni operazione di cache. Per impostazione predefinita, viene visualizzato solo un riepilogo. Gli oggetti risultato includono proprietà come Name, Status, CacheFile, ExitCode, StdOut e StdErr, consentendo l'ispezione programmatica del processo di memorizzazione nella cache.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Elimina l'avanzamento dello script e l'output di riepilogo informativo. Utilizza questo interruttore quando desideri solo un output strutturato (tramite `-PassThru`) o quando gli scenari di automazione dovrebbero silenziare i messaggi informativi pur continuando a far emergere avvisi ed errori.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Filtra gli script valutati in base al tag dei metadati (senza distinzione tra maiuscole e minuscole). Più valori vengono trattati come un filtro OR. Vengono memorizzate nella cache solo le corrispondenze consentite da `CachePolicy.psd1`; altre corrispondenze riportano `SkippedNotRequired` con `-PassThru`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ThrottleLimit

Specifica il numero massimo di cacheworker simultanei quando viene richiesto `-Parallel`. Accetta valori da 1 a 256. Il valore predefinito (se omesso) è il numero di processori logici sulla macchina corrente. L'alias `-Threads` viene fornito per comodità. I valori inferiori o uguali a uno ripristinano automaticamente l'esecuzione sequenziale.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Threads
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Mostra cosa accadrebbe se il cmdlet venisse eseguito senza eseguire effettivamente le operazioni di memorizzazione nella cache. Utile per visualizzare in anteprima quali script verranno memorizzati nella cache prima di impegnarsi nell'operazione.

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

### System.String

È possibile reindirizzare i nomi degli script a questo cmdlet. Ogni string viene trattato come un potenziale nome di script e supporta la corrispondenza con caratteri jolly.

### System.String[]

È possibile reindirizzare una matrice di nomi di script o record di metadati con una proprietà `Name` a questo cmdlet per l'elaborazione batch.

## OUTPUTS

### System.Object

Quando viene specificato `-PassThru`, restituisce un oggetto personalizzato per ogni script elaborato contenente le seguenti proprietà:

- **Name**: il nome dello script colore
- **ScriptPath**: percorso completo al colorscript di origine
- **CacheFile**: percorso completo del file di cache generato
- **Status**: `Updated`, `SkippedUpToDate`, `SkippedNotRequired`, `SkippedByUser` o `Failed`
- **Message**: dettaglio stato localizzato
- **CacheExists**: se esiste una cache di output dopo l'operazione
- **ExitCode**: Il codice di uscita dall'esecuzione dello script (0 indica successo)
- **StdOut**: output standard catturato durante l'esecuzione dello script
- **StdErr**: output dell'errore standard acquisito durante l'esecuzione dello script

Senza `-PassThru`, scrive un riepilogo informativo conciso contenente i conteggi elaborati, aggiornati, ignorati e non riusciti oltre alla directory della cache effettiva.

## NOTES

**Autore:** Nick
**Modulo:** ColorScripts-Enhanced

**Alias:** `Update-ColorScriptCache` e `Build-ColorScriptCache`.

I file di cache vengono archiviati in `(Get-ColorScriptConfiguration).Cache.EffectivePath`. Le firme di origine e policy nei metadati associati vengono utilizzate per determinare se una voce rimane aggiornata.

Il cmdlet memorizza nella cache solo i renderer che richiedono l'esecuzione e sono consentiti dai criteri di cache. Gli script statici o non elencati espliciti vengono segnalati come `SkippedNotRequired` e le voci obsolete vengono rimosse.

## RELATED LINKS

- [Versione online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)

