---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

Elenca colorscripts disponibili con filtraggio opzionale e output di metadati avanzati.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

Questo comando non ha alias.

## DESCRIPTION

Il cmdlet `Get-ColorScriptList` recupera e visualizza tutti gli colorscripts inclusi nel modulo ColorScripts-Enhanced. Fornisce opzioni di filtro flessibili e molteplici formati di output per adattarsi a diversi casi d'uso.

Per impostazione predefinita, il cmdlet visualizza una tabella formattata concisa che mostra i nomi e le categorie degli script. Lo switch `-Detailed` espande questa visualizzazione per includere tag e descrizioni, fornendo più contesto a colpo d'occhio.

Il cmdlet restituisce sempre i record di metadati alla pipeline di successo. Senza `-AsObject`, scrive anche una vista host formattata; `-AsObject` sopprime la formattazione dell'host per un'automazione pulita. I record includono nome, percorso, categoria, categorie, tag, descrizione e la proprietà dei metadati originali.

Le funzionalità di filtro consentono di restringere l'elenco in base a:

- **Name**: supporta modelli di caratteri jolly (ad esempio, `aurora-*`) per una corrispondenza flessibile
- **Category**: filtra per uno o più nomi di categoria (senza distinzione tra maiuscole e minuscole)
- **Tag**: filtra per tag di metadati come "Recommended" o "Animated" (senza distinzione tra maiuscole e minuscole)

Il cmdlet convalida i modelli di filtro e genera avvisi per eventuali modelli di nome senza corrispondenza, aiutandoti a identificare potenziali errori di battitura o script mancanti.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Visualizza tutti gli colorscripts disponibili in un formato tabella compatto che mostra il nome e la categoria di ciascuno script.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed
```

Mostra tutti gli colorscripts con colonne aggiuntive che includono tag e descrizioni per una panoramica completa.

### EXAMPLE 3

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

Visualizza solo gli script nella categoria "Patterns" con metadati completi inclusi tag e descrizioni.

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

Restituisce oggetti strutturati per ogni script il cui nome corrisponde al modello di caratteri jolly, quindi seleziona solo le proprietà Name e Tags per la visualizzazione.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

Recupera tutti gli script contrassegnati come "Recommended" e li ordina in ordine alfabetico per nome. Utile per trovare script curati adatti all'integrazione del profilo.

### EXAMPLE 6

```powershell
Get-ColorScriptList -AsObject -Category Geometric,Abstract | Where-Object { $_.Tags -contains 'Colorful' }
```

Combina il filtraggio di categorie e tag per trovare script che si trovano sia nelle categorie Geometrico che Astratto e contrassegnati come Colorati.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Name blocks,pipes,matrix -AsObject | ForEach-Object { Show-ColorScript -Name $_.Name }
```

Recupera script con nome specifico ed esegue ciascuno di essi in sequenza, dimostrando l'integrazione della pipeline con `Show-ColorScript`.

### EXAMPLE 8

```powershell
# Conta gli script per categoria a scopo di inventario
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending
```

Fornisce un riepilogo di quanti colorscripts esistono in ciascuna categoria.

### EXAMPLE 9

```powershell
# Trova script con parole chiave specifiche nella descrizione
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

Cerca gli script in base al contenuto della descrizione utilizzando la corrispondenza dei modelli.

### EXAMPLE 10

```powershell
# Esporta in CSV per l'elaborazione di strumenti esterni
Get-ColorScriptList -AsObject -Detailed |
    Select-Object Name, Category, Tags, Description |
    Export-Csv -Path "./colorscripts-inventory.csv" -NoTypeInformation
```

Esporta l'inventario colorscript completo in formato CSV per l'utilizzo in applicazioni per fogli di calcolo.

### EXAMPLE 11

```powershell
# Controlla gli script senza una categoria specifica
$allScripts = Get-ColorScriptList -AsObject
$uncategorized = $allScripts | Where-Object { -not $_.Category }
Write-Host "Script senza categoria: $($uncategorized.Count)"
$uncategorized | Select-Object Name
```

Identifica gli script a cui mancano i metadati della categoria.

### EXAMPLE 12

```powershell
# Crea cache per script filtrati
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object {
        New-ColorScriptCache -Name $_.Name -PassThru
    } |
    Format-Table Name, Status
```

Valuta gli script contrassegnati con `Recommended`; vengono creati solo renderer idonei ai criteri di cache e altri record riportano `SkippedNotRequired`.

### EXAMPLE 13

```powershell
# Crea un report formattato di tutti gli script geometrici
Get-ColorScriptList -Category Geometric -Detailed |
    Out-String |
    Tee-Object -FilePath "./geometric-report.txt"
```

Genera e salva un rapporto dettagliato della categoria geometrica colorscripts in un file.

### EXAMPLE 14

```powershell
# Trova il primo script che corrisponde a un modello per una visualizzazione rapida
$script = Get-ColorScriptList -Name "aurora-*" -AsObject | Select-Object -First 1
if ($script) {
    Show-ColorScript -Name $script.Name -PassThru
}
```

Visualizza rapidamente il primo script corrispondente in base a un modello di caratteri jolly.

### EXAMPLE 15

```powershell
# Verificare che tutti gli script di riferimento esistano prima di eseguire l'automazione
$requiredScripts = @("bars", "arch", "mandelbrot-zoom")
$available = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$missing = $requiredScripts | Where-Object { $_ -notin $available }
if ($missing) {
    Write-Warning "Script mancanti: $($missing -join ', ')"
} else {
    Write-Host "Tutti gli script richiesti sono disponibili"
}
```

Verifica che tutti gli script richiesti esistano prima dell'esecuzione dell'automazione.

## PARAMETERS

### -AsObject

Restituisce oggetti record di metadati non elaborati invece di eseguire il rendering di una tabella formattata sull'host. Ciò consente l'elaborazione della pipeline e la manipolazione programmatica dei metadati colorscript.

Quando viene specificata questa opzione, è possibile utilizzare i cmdlet PowerShell standard come `Where-Object`, `Select-Object`, `Sort-Object` e `ForEach-Object` per elaborare ulteriormente i risultati.

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

### -Category

Filtra l'elenco per includere solo gli script appartenenti a una o più categorie specificate. La corrispondenza Category non fa distinzione tra maiuscole e minuscole.

Le categorie comuni includono: motivi, geometrici, astratti, naturali, animati, testo, retrò e altro ancora. Puoi specificare più categorie per ampliare la ricerca.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Detailed

Include colonne aggiuntive (tag e descrizione) durante il rendering della vista tabella formattata. Ciò fornisce informazioni più complete su ogni script a colpo d'occhio.

Senza questa opzione, nell'output della tabella vengono visualizzati solo il nome e la categoria primaria.

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

### -Name

Filtra l'elenco colorscript in base a uno o più nomi di script. Supporta caratteri jolly (`*` e `?`) per la corrispondenza dei modelli flessibile.

Se un modello specificato non corrisponde ad alcuno script, viene generato un avviso per aiutare a identificare potenziali problemi. La corrispondenza Name non fa distinzione tra maiuscole e minuscole.

Puoi specificare nomi esatti o utilizzare modelli come `aurora-*` per abbinare più script correlati.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: (All)
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

### -Quiet

Elimina i messaggi informativi preservando l'output e gli errori dei comandi.

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

### -Tag

Filtra l'elenco per includere solo gli script contenenti uno o più tag di metadati specificati. La corrispondenza dei tag non fa distinzione tra maiuscole e minuscole.

I tag comuni includono: Consigliato, Animato, Colorato, Minimal, Retro, Complesso, Semplice e altro. Tags aiuta a classificare gli script in base allo stile visivo, alla complessità o al caso d'uso.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
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

### System.Object

Restituisce oggetti record di metadati colorscript con le seguenti proprietà:

- **Name**: l'identificatore dello script utilizzato con `Show-ColorScript`
- **Path**: il percorso di origine completo
- **Category**: la categoria principale dello script
- **Categories**: un array di tutte le categorie a cui appartiene lo script
- **Tags**: un array di tag di metadati che descrivono lo script
- **Description**: una descrizione leggibile dell'output visivo dello script
- **Metadata**: l'oggetto metadati originale contenente tutte le informazioni sullo script non elaborato

Senza `-AsObject`, il cmdlet scrive una tabella formattata nell'host restituendo comunque gli oggetti record per la potenziale elaborazione della pipeline.

## NOTES

**Autore**: Nick
**Module**: ColorScripts-Enhanced

I record di metadati restituiti forniscono informazioni complete sia per scopi di visualizzazione che di automazione. La proprietà `Name` può essere utilizzata direttamente con il cmdlet `Show-ColorScript` per eseguire script specifici.

Tutte le operazioni di filtro (Name, Category, Tag) non fanno distinzione tra maiuscole e minuscole e possono essere combinate per creare query potenti. Quando si utilizzano caratteri jolly nel parametro `-Name`, i modelli senza corrispondenza generano avvisi per facilitare la risoluzione dei problemi.

Per ottenere i migliori risultati quando si integra colorscripts nel profilo PowerShell, utilizzare il filtro `-Tag Recommended` per identificare gli script curati adatti alla visualizzazione all'avvio.

### Migliori pratiche

- Utilizza sempre `-AsObject` quando devi filtrare o manipolare i risultati a livello di codice
- Utilizza `-Detailed` durante l'esplorazione interattiva per vedere tag e descrizioni
- Combina più filtri per query precise
- Esporta periodicamente i metadati per tenere traccia delle modifiche nel tempo
- Utilizzare gli oggetti risultato per l'automazione anziché per l'analisi dell'output di testo
- Considerare le prestazioni quando si eseguono query ripetutamente (memorizza i risultati nella cache se possibile)
- Sfrutta Group-Object per analisi e reporting
- Utilizzare Where-Object per logiche di filtraggio complesse

## RELATED LINKS

- [Versione online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)

