---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Export-ColorScriptMetadata
---

# Export-ColorScriptMetadata

## SYNOPSIS

Esporta metadati completi per tutti i formati da colorscripts a JSON o emette oggetti strutturati nella pipeline.

## SYNTAX

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-h] [-IncludeFileInfo] [-IncludeCacheInfo]
 [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Questo comando non ha alias.

## DESCRIPTION

Il cmdlet `Export-ColorScriptMetadata` compila un inventario completo di tutti gli script di colori nel catalogo del modulo e genera un set di dati strutturato che descrive ciascuna voce. Questi metadati includono informazioni essenziali come nomi di script, categorie, tag e arricchimenti facoltativi.

Per impostazione predefinita, il cmdlet restituisce gli oggetti PowerShell alla pipeline. Quando viene fornito il parametro `-Path`, scrive i metadati come formattato JSON nel file specificato, creando automaticamente le directory principali se non esistono.

Il cmdlet offre due flag di arricchimento facoltativi:

- **IncludeFileInfo**: aggiunge metadati del file system inclusi percorsi completi, dimensioni dei file (in byte) e timestamp dell'ultima modifica
- **IncludeCacheInfo**: aggiunge informazioni relative alla cache inclusi percorsi dei file di cache, stato di esistenza e timestamp della cache

Questo cmdlet è particolarmente utile per:

- Creazione di documentazione o dashboard che mostrano tutti gli script di colori disponibili
- Segnalazione della presenza e dei timestamp dei file di payload della cache non elaborati
- Alimentazione di metadati a strumenti esterni o pipeline di automazione
- Controllo dell'inventario colorscript e dello stato del file system
- Generazione di report sull'utilizzo e l'organizzazione di colorscript

L'output è ordinato in modo coerente, rendendolo adatto per il controllo della versione e le operazioni di differenza quando esportato in JSON.

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

Esporta i metadati di base per tutti gli script di colori nella pipeline senza informazioni su file o cache.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

Restituisce oggetti che includono i dettagli del file system (percorso completo, dimensione e ora dell'ultima scrittura) per ogni colorscript.

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

Genera un file JSON contenente metadati di base e lo scrive nella directory `dist`, creando la cartella se non esiste.

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

Genera un file JSON completo con metadati arricchiti che includono sia informazioni sul file system che sulla cache, scrivendolo nella directory `dist`.

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeCacheInfo -PassThru | Where-Object { -not $_.CacheExists }
```

Scrive il file di metadati e restituisce i record il cui payload `.cache` non elaborato è assente. Ciò segnala solo l'occupazione dei file, non l'idoneità, la validità o l'attualità della cache.

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

Raggruppa gli script a colori per categoria e visualizza i conteggi, utili per analizzare la distribuzione degli script tra le categorie.

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property ScriptSizeBytes -Sum).Sum
Write-Host "Dimensione totale di tutti i colorscript: $($totalSize / 1KB) KB"
```

Calcola lo spazio su disco totale utilizzato da tutti i file colorscript.

### EXAMPLE 8

```powershell
# Genera statistiche e salva report
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachePayloadFiles = ($metadata | Where-Object CacheExists).Count
    TotalScriptSizeBytes = ($metadata | Measure-Object ScriptSizeBytes -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

Genera statistiche di inventario e conta i file di carico utile `.cache` non elaborati. La presenza del payload non è un controllo di idoneità, validità o attualità della cache.

### EXAMPLE 9

```powershell
# Esporta e confronta con il backup precedente
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "Nuovi script: $($new.Count) | Script rimossi: $($removed.Count)"
```

Confronta i metadati attuali con una versione precedente per identificare le modifiche.

### EXAMPLE 10

```powershell
# Crea una risposta API per la dashboard web
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

Genera JSON pronto per l'API con informazioni su versione e timestamp.

### EXAMPLE 11

```powershell
# Crea o convalida ogni voce della cache selezionata dalla policy e rivedi gli stati.
$results = New-ColorScriptCache -All -PassThru
$results | Group-Object Status | Select-Object Name, Count
```

Utilizza la policy della cache come fonte attendibile e segnala se le voci idonee sono state aggiornate, già correnti, ignorate o non riuscite.

### EXAMPLE 12

```powershell
# Crea una galleria HTML dai metadati
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$html = @"
<html>
<head><title>ColorScripts-Enhanced Gallery</title></head>
<body>
<h1>ColorScripts-Enhanced</h1>
<ul>
"@
foreach ($script in $metadata) {
    $html += "<li><strong>$($script.Name)</strong> [$($script.Category)]</li>`n"
}
$html += "</ul></body></html>"
$html | Out-File "./gallery.html" -Encoding UTF8
```

Crea una pagina di galleria HTML che elenca tutti gli script di colori disponibili.

### EXAMPLE 13

```powershell
# Monitorare le dimensioni degli script nel tempo
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object ScriptSizeBytes -Average).Average) bytes avg" }
```

Tiene traccia delle modifiche alle dimensioni dei file per singoli script su più esportazioni.

## PARAMETERS

### -Confirm

Richiede conferma prima di eseguire il cmdlet.

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

### -h

Visualizza la guida dettagliata per questo comando senza eseguire l'operazione.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -IncludeCacheInfo

Aggiunge il percorso del payload `.cache` non elaborato, il flag di presenza del file e il timestamp dell'ultima scrittura a ciascun record. Questi campi non riportano l'idoneità della policy della cache, la presenza, la validità o l'attualità del sidecar `.cacheinfo`.

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

### -IncludeFileInfo

Include i dettagli del file system (percorso completo, dimensione in byte e ora dell'ultima scrittura) in ogni record. Quando i metadati del file non possono essere letti (a causa di autorizzazioni o file mancanti), gli errori vengono registrati tramite output dettagliato e le proprietà interessate vengono impostate su valori null. Questa opzione è utile per controllare le dimensioni dei file e le date di modifica.

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

### -PassThru

Restituisce gli oggetti metadati alla pipeline anche quando è specificato il parametro `-Path`. Ciò consente sia di salvare i metadati in un file sia di eseguire ulteriori elaborazioni o filtri sugli oggetti in un unico comando. Senza questa opzione, specificando `-Path` si elimina l'output della pipeline.

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

### -Path

Specifica il percorso del file di destinazione per l'esportazione JSON. Supporta percorsi relativi, percorsi assoluti, variabili di ambiente (ad esempio, `$env:TEMP\metadata.json`) ed espansione tilde (ad esempio, `~/Documents/metadata.json`). Le directory principali vengono create automaticamente se non esistono. Quando questo parametro viene omesso, il cmdlet restituisce gli oggetti direttamente nella pipeline invece di scriverli in un file. L'output JSON è formattato con rientro per la leggibilità.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
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

### -WhatIf

Esegue il comando in una modalità che segnala solo cosa accadrebbe senza eseguire le azioni.

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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Per ulteriori informazioni, vedere
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Questo cmdlet non accetta input dalla pipeline.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Quando `-Path` non è specificato o quando viene utilizzato `-PassThru`, il cmdlet restituisce oggetti personalizzati. Ogni oggetto rappresenta un singolo colorscript con le seguenti proprietà di base:

- **Name**: nome file del colorscript senza estensione
- **Category**: la categoria organizzativa primaria
- **Categories**: tutte le categorie assegnate
- **Tags**: una serie di tag descrittivi per il filtraggio e la ricerca
- **Description**: la descrizione dei metadati

Quando viene specificato `-IncludeFileInfo`, vengono incluse queste proprietà aggiuntive:

- **ScriptPath**: il percorso completo del file system del file di script
- **ScriptSizeBytes**: dimensione in byte (null se il file è inaccessibile)
- **ScriptLastWriteTimeUtc**: timestamp UTC dell'ultima modifica (null se non disponibile)

Quando viene specificato `-IncludeCacheInfo`, vengono incluse queste proprietà aggiuntive:

- **CachePath**: il percorso completo del file di cache corrispondente
- **CacheExists**: booleano che indica se esiste un file di cache
- **CacheLastWriteTimeUtc**: timestamp UTC della modifica del file di cache (null se la cache non esiste)

## NOTES

## RELATED LINKS

- [Versione online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)

