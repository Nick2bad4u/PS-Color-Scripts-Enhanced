---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Clear-ColorScriptCache
---

# Clear-ColorScriptCache

## SYNOPSIS

Rimuovi i file di output colorscript memorizzati nella cache.

## SYNTAX

### Selection (Default)

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

### Help

```
Clear-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-All] [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

## ALIASES

Questo comando non ha alias.

## DESCRIPTION

Il cmdlet `Clear-ColorScriptCache` rimuove i file di output memorizzati nella cache generati dal modulo ColorScripts-Enhanced. Ogni voce è costituita da un payload `<name>.cache` renderizzato e da un sidecar di convalida `<name>.cacheinfo` nella directory della cache effettiva.

È possibile eliminare le voci della cache in modo selettivo utilizzando il parametro `-Name` con caratteri jolly oppure rimuovere tutte le voci contemporaneamente con il parametro `-All`. `-All` rimuove anche i sidecar orfani il cui carico utile è stato eliminato. Il cmdlet supporta il filtraggio in base a `-Category` e `-Tag` per indirizzare sottoinsiemi specifici di script memorizzati nella cache.

I nomi di script senza corrispondenza riportano uno stato `Missing` nei risultati. Utilizzare `-DryRun` per visualizzare in anteprima le azioni di rimozione senza modificare il file system e `-Path` per indirizzare una directory della cache alternativa (utile per configurazioni di cache personalizzate o ambienti CI/CD).

Le voci della cache idonee vengono rigenerate quando viene visualizzato il renderer selezionato dalla policy corrispondente o viene richiamato `New-ColorScriptCache`. Gli script deterministici in bundle eseguono il rendering in-process e non creano voci nella cache.

Per gli scenari di automazione, combina `-PassThru` per acquisire risultati strutturati, `-Quiet` per eliminare il messaggio di riepilogo o `-NoAnsiOutput` per emettere riepiloghi in testo semplice senza codici colore ANSI.

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

Rimuove tutti i file della cache nella directory della cache predefinita senza richiedere conferma. Ciò è utile per aggiornare completamente la cache dopo gli aggiornamenti del modulo o durante la risoluzione dei problemi di visualizzazione.

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

Visualizza in anteprima quali file di cache a tema Aurora verranno rimossi senza effettivamente eliminarli. L'output mostra i file della cache che corrispondono al modello, consentendoti di verificare la selezione prima di procedere all'eliminazione.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name Galaxy -Path $env:TEMP -Confirm:$false
```

Cancella il file di cache per il renderer 'Galaxy' idoneo da una directory personalizzata in TEMP. Ciò è utile quando si testa `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` o un'altra posizione cache isolata.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Category Mathematical -WhatIf
```

Mostra cosa accadrebbe se i file di cache per gli script nella categoria `Mathematical` venissero rimossi. Il parametro `-WhatIf` impedisce la cancellazione.

### EXAMPLE 5

```powershell
Get-ColorScriptList -Tag retro | Clear-ColorScriptCache -DryRun
```

Utilizza l'input della pipeline per visualizzare in anteprima la rimozione dei file di cache per tutti gli script contrassegnati come 'retro'. Combina il filtraggio per tag con un'anteprima di prova prima di impegnarsi nell'eliminazione.

### EXAMPLE 6

```powershell
Clear-ColorScriptCache -Name 'test-*', 'demo-*' -Confirm:$false
```

Rimuove i file di cache per tutti gli script i cui nomi iniziano con 'test-' o 'demo-' senza conferma. È possibile specificare più modelli di caratteri jolly come array.

### EXAMPLE 7

```powershell
# Cancella i file di cache esistenti e ricostruisci le voci selezionate dalla policy
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -PassThru | Measure-Object
Write-Host "Cache ricostruita correttamente"
```

Cancella tutti i payload della cache, ricostruisce le voci selezionate dalla policy della cache dinamica e quindi mostra le statistiche relative alle voci ricostruite.

### EXAMPLE 8

```powershell
# Cancella le vecchie voci della cache risalenti a più di 30 giorni fa
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$thirtyDaysAgo = (Get-Date).AddDays(-30)
Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $thirtyDaysAgo } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
Write-Host "File di cache obsoleti rimossi"
```

Rimuove i file della cache che non sono stati aggiornati da più di 30 giorni.

### EXAMPLE 9

```powershell
# Rapporto sulla gestione della cache
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$beforeCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Clear-ColorScriptCache -Category Geometric -Confirm:$false
$afterCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Write-Host "Rimossi $($beforeCount - $afterCount) file di cache geometrici"
```

Mostra le statistiche sulle operazioni di svuotamento della cache.

### EXAMPLE 10

```powershell
# Risoluzione dei problemi: cancella e ricostruisci lo script specifico
$scriptName = "Galaxy"
Clear-ColorScriptCache -Name $scriptName -Confirm:$false
New-ColorScriptCache -Name $scriptName -Force
Show-ColorScript -Name $scriptName
```

Cancella e ricostruisce la cache per un singolo renderer idoneo in base alla policy, quindi lo visualizza per la verifica.

### EXAMPLE 11

```powershell
# Filtra per più categorie
Clear-ColorScriptCache -Category Geometric,Abstract -DryRun -PassThru |
    Select-Object CacheFile |
    Measure-Object
```

Mostra quanti file di cache verrebbero eliminati se si filtrasse per più categorie.

## PARAMETERS

### -All

Seleziona ogni voce della cache nella directory di destinazione. `-Category` e `-Tag` possono limitare ulteriormente il set di parametri di selezione completa; `-Name` appartiene invece al set di parametri di selezione.

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

Filtra gli script di destinazione per categoria prima di valutare le voci della cache. Verranno presi in considerazione per la rimozione solo i file di cache per gli script che corrispondono alle categorie specificate. Accetta una serie di nomi di categoria e può essere combinato con `-Tag` per un filtraggio più preciso.

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

Richiede conferma prima di eseguire il cmdlet. Per impostazione predefinita, questa opzione è abilitata per impedire la cancellazione accidentale dei file della cache. Utilizzare `-Confirm:$false` per ignorare la richiesta di conferma.

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

### -DryRun

Anteprima delle azioni di rimozione senza eliminare alcun file. Il cmdlet visualizzerà quali file di cache verranno rimossi ma non modificherà il file system. Ciò è utile per verificare i criteri di selezione prima di impegnarsi nella cancellazione.

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

### -Name

Nomi o modelli di caratteri jolly che identificano i file di cache da rimuovere. Accetta input di pipeline e associazione di proprietà da oggetti con una proprietà `Name`. I caratteri jolly (`*`, `?`) sono supportati per la corrispondenza dei modelli. Si escludono a vicenda con `-All`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
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

Disabilita le sequenze di colori ANSI nell'output di riepilogo. Ciò è utile per le console o i processori di registro che non interpretano lo stile ANSI, garantendo che il testo di riepilogo rimanga leggibile in testo normale.

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

### -PassThru

Restituisce oggetti risultato dettagliati per ogni voce della cache elaborata. Senza questa opzione, il cmdlet scrive solo un messaggio di riepilogo. Ogni record pass-through include il nome dello script, il percorso del file di cache, lo stato e qualsiasi testo di errore associato per ulteriori controlli o report.

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

### -Path

Directory della cache alternativa su cui operare. Se non specificato, il valore predefinito è il percorso cache standard del modulo. Utilizzare questo parametro quando si lavora con posizioni cache personalizzate impostate tramite la variabile di ambiente `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` o quando si gestiscono file di cache in directory alternative per scopi di test o CI/CD.

```yaml
Type: System.String
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

Elimina il messaggio di riepilogo emesso al termine della rimozione della cache. Utilizzare questa opzione durante l'esecuzione in contesti di automazione silenziosi in cui deve essere prodotto solo output strutturato (come record, avvisi o errori `-PassThru`).

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

Filtra gli script di destinazione in base al tag dei metadati prima di valutare le voci della cache. Verranno presi in considerazione per la rimozione solo i file di cache per gli script con tag corrispondenti. Accetta una serie di nomi di tag e può essere combinato con `-Category` per un controllo più granulare su quali file di cache vengono presi di mira.

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

### -WhatIf

Mostra cosa accadrebbe se il cmdlet venisse eseguito senza eseguire effettivamente l'operazione. Il cmdlet visualizza le azioni che verrebbe eseguito ma non modifica il file system. Questo è un parametro comune standard di PowerShell che funziona in modo simile a `-DryRun` ma segue le convenzioni integrate di PowerShell.

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

È possibile reindirizzare i nomi degli script a questo cmdlet. Ogni nome verrà valutato per la rimozione del file di cache in base ai parametri specificati.

### System.String[]

È possibile reindirizzare una serie di nomi di script a questo cmdlet. Ciò è particolarmente utile quando si combina con `Get-ColorScriptList` per filtrare gli script in base a vari criteri prima di svuotarne la cache.

### System.Management.Automation.PSObject

È possibile reindirizzare oggetti con una proprietà `Name` a questo cmdlet. Il cmdlet estrarrà il valore della proprietà `Name` e lo utilizzerà per identificare i file della cache da rimuovere.

## OUTPUTS

### System.Object

Con `-PassThru`, restituisce un record di stato per ogni file di cache elaborato. Ogni oggetto di output contiene le seguenti proprietà:

- **Status**: il risultato dell'operazione (`Removed`, `Missing`, `DryRun`, `SkippedByUser` o `Error`)
- **CacheFile**: il percorso completo del file di cache elaborato
- **Message**: Testo descrittivo che spiega l'esito dell'operazione
- **Name**: il nome dello script associato al file di cache

## NOTES

**Autore**: Nick
**Module**: ColorScripts-Enhanced

I file della cache vengono archiviati con un'estensione `.cache` nella directory della cache del modulo. Ogni file di cache corrisponde a un singolo colorscript e contiene l'output ANSI pre-renderizzato.

Le voci della cache idonee vengono rigenerate quando viene visualizzato il renderer selezionato dalla policy corrispondente o viene richiamato `New-ColorScriptCache`. Gli script deterministici in bundle eseguono il rendering in-process e non creano voci nella cache.

Interrogare `(Get-ColorScriptConfiguration).Cache.EffectivePath` per il percorso effettivo predefinito. Può essere sovrascritto con la configurazione persistente o `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`; `-Path` ha come target una directory diversa per una invocazione.

Quando si utilizza `-DryRun` o `-WhatIf`, il cmdlet convaliderà comunque l'esistenza della directory della cache e segnalerà eventuali problemi, ma non eseguirà alcuna eliminazione.

Il filtraggio in base a `-Category` o `-Tag` richiede che gli script abbiano metadati associati. Gli script senza metadati non corrisponderanno a questi filtri.

### Migliori pratiche

- Utilizzare sempre `-DryRun` o `-WhatIf` prima di operazioni distruttive
- Utilizzare `-Confirm:$false` solo quando si è certi del funzionamento
- Archivia la cache prima delle principali operazioni di pulizia per il ripristino
- Monitorare regolarmente lo spazio su disco per verificare la crescita della cache
- Utilizzare la pulizia selettiva invece della pulizia completa quando possibile
- Tieni traccia degli script critici che non dovrebbero essere cancellati
- Pianifica le pulizie automatizzate durante le finestre di manutenzione
- Testare prima le operazioni di pulizia in modalità non di produzione

### Risoluzione dei problemi (2)

- **"Nessun file di cache trovato"**: ispeziona `(Get-ColorScriptConfiguration).Cache.EffectivePath` e utilizza `Export-ColorScriptMetadata -IncludeCacheInfo` per verificare lo stato della cache
- **"Autorizzazione negata"**: verifica l'accesso in scrittura alla directory della cache
- **"La cache non viene rigenerata"**: gli script potrebbero avere problemi di rendering; provare con `-NoCache`

## RELATED LINKS

- [Versione online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache)

