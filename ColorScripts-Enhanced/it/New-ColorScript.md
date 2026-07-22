---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

Impalcatura di un nuovo file colorscript e facoltativamente emissione di indicazioni sui metadati.

## SYNTAX

### Scaffold

```
New-ColorScript -Name <string> -OutputPath <string> [-h] [-Force] [-GenerateMetadataSnippet]
 [-Category <string[]>] [-Tag <string[]>] [-OpenInEditor] [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScript [-h] [-Name <string>] [-WhatIf] [-Confirm]
```

## ALIASES

Questo comando non ha alias.

## DESCRIPTION

Il cmdlet `New-ColorScript` crea un'impalcatura colorscript minima contenente un array string e un ciclo che scrive ogni riga. Il file è codificato come UTF-8 senza contrassegno dell'ordine dei byte (BOM). È possibile includere indicazioni facoltative sui metadati come commento nel file generato e restituirle nell'oggetto risultato.

Sia `-Name` che `-OutputPath` sono obbligatori per i ponteggi. `-OutputPath` identifica una directory; il comando crea la directory quando necessario e scrive al suo interno `<Name>.ps1`.

I nomi degli script devono seguire le convenzioni di denominazione PowerShell: devono iniziare con un carattere alfanumerico e possono includere caratteri di sottolineatura o trattini. Se non fornita, l'estensione `.ps1` viene aggiunta automaticamente. I file esistenti sono protetti da sovrascritture accidentali a meno che l'interruttore `-Force` non sia esplicitamente specificato.

Se combinato con `-GenerateMetadataSnippet`, il cmdlet restituisce indicazioni che descrivono la voce da aggiungere a `ScriptMetadata.psd1`. Anche la categoria e i valori dei tag forniti vengono restituiti come matrici sull'oggetto risultato.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -OutputPath ./ColorScripts-Enhanced/Scripts -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

Crea `my-spectrum.ps1` nella directory richiesta e restituisce un oggetto contenente il percorso del file e la guida ai metadati.

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

Genera l'impalcatura in una directory personalizzata (`~/Dev/colorscripts`), creando la directory se non esiste. Se in quella posizione esiste già un file denominato `holiday-banner.ps1`, verrà sovrascritto a causa dello switch `-Force`.

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -OutputPath ./ColorScripts-Enhanced/Scripts -Category 'Artistic' -Tag '80s','Neon' -GenerateMetadataSnippet
$result.MetadataGuidance | Set-Clipboard
```

Crea un nuovo script di colori e copia la guida dei metadati negli appunti, facilitandone l'incollaggio in `ScriptMetadata.psd1`.

### EXAMPLE 4

```powershell
New-ColorScript -Name 'test-pattern' -OutputPath '.\temp' -WhatIf
```

Mostra cosa accadrebbe quando si crea uno script di modello di prova nella directory `.\temp` senza creare effettivamente il file. Utile per convalidare percorsi e nomi prima dell'esecuzione.

### EXAMPLE 5

```powershell
# Crea più colorscripts per un progetto
$scriptNames = @("company-logo", "team-banner", "status-display")
foreach ($name in $scriptNames) {
    New-ColorScript -Name $name -Category "Corporate" -Tag "Custom" -OutputPath ".\src" | Out-Null
}
Write-Host "Creati $($scriptNames.Count) modelli colorscript"
```

Crea più modelli colorscript in batch per un progetto.

### EXAMPLE 6

```powershell
# Crea e apri immediatamente nell'editor
New-ColorScript -Name "my-art" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -GenerateMetadataSnippet -OpenInEditor
```

Crea un colorscript e chiede al gestore registrato della piattaforma di aprirlo.

### EXAMPLE 7

```powershell
# Crea con l'automazione completa del flusso di lavoro
$newScript = New-ColorScript -Name "interactive-demo" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Custom" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "Creato: $($newScript.Name)"
Write-Host "Percorso: $($newScript.Path)"
Write-Host "Indicazioni sui metadati copiate negli appunti"
$newScript.MetadataGuidance | Set-Clipboard
```

Crea un colorscript con la guida dei metadati copiata automaticamente negli appunti.

### EXAMPLE 8

```powershell
# Verificare le convenzioni sui nomi degli script
$validName = "123-start"
$invalidNames = @("-invalid", "_underscore-only", "contains space")
foreach ($name in $invalidNames) {
    try {
        New-ColorScript -Name $name -OutputPath ./temp -WhatIf -ErrorAction Stop
    } catch {
        Write-Warning "Nome non valido '$name': $_"
    }
}
```

Dimostra la convalida delle convenzioni di denominazione per gli script di colori.

### EXAMPLE 9

```powershell
# Crea in una posizione portatile per la distribuzione
$portableDir = Join-Path $PSScriptRoot "colorscripts"
$scaffold = New-ColorScript -Name "portable-art" -OutputPath $portableDir -GenerateMetadataSnippet
Write-Host "Colorscript portatile creato in: $($scaffold.Path)"
```

Crea script di colori in una posizione portatile rispetto allo script corrente.

### EXAMPLE 10

```powershell
# Crea con la convalida di categorie e tag
$categories = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Category -Unique
if ("Retro" -in $categories) {
    New-ColorScript -Name "retro-party" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -Tag "Fun","Social"
} else {
    Write-Warning "Categoria Retro non trovata"
}
```

Verifica che una categoria esista prima di creare un nuovo colorscript.

## PARAMETERS

### -Category

Specifica una o più categorie restituite con lo scaffold e incluse nella guida ai metadati. I valori dovrebbero essere allineati alle categorie già utilizzate in `ScriptMetadata.psd1`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

### -Force

Sovrascrive il file di destinazione se esiste già. Senza questa opzione, il cmdlet verrà terminato con un errore se nella posizione di destinazione viene trovato un file con lo stesso nome. Utilizzare con cautela per evitare la perdita di dati.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Overwrite
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GenerateMetadataSnippet

Include uno snippet guida nell'output che mostra come registrare il nuovo script in `ScriptMetadata.psd1`. Lo snippet utilizza i valori dei parametri `-Category` e `-Tag`, se forniti. Ciò è particolarmente utile per mantenere metadati coerenti tra tutti gli colorscripts nel modulo.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

Specifica il nome del nuovo colorscript. Il nome deve iniziare con un carattere alfanumerico e può includere trattini bassi o trattini. L'estensione `.ps1` viene aggiunta automaticamente se non inclusa. Questo nome verrà utilizzato come nome file e dovrebbe essere descrittivo del contenuto o del tema dello script.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Help
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OpenInEditor

Apre il colorscript generato con il comando configurato dall'ambiente quando la creazione ha esito positivo.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputPath

Specifica la directory di destinazione obbligatoria. Il comando crea <Name>.ps1 in questa directory.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Destination
- Path
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

Specifica uno o più tag di metadati per colorscript. Tags forniscono una classificazione aggiuntiva oltre alla categoria primaria e sono utili per filtrare e cercare. I tag comuni includono descrittori di temi come 'Minimal', 'Colorful', 'Animated', riferimenti tecnologici come 'Matrix', 'ASCII' o indicatori contestuali come 'Holiday', 'Season'. È possibile specificare più tag come array separato da virgole.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

Mostra cosa accadrebbe se il cmdlet venisse eseguito senza eseguire effettivamente alcuna azione. Visualizza il percorso del file che verrebbe creato e gli eventuali controlli di convalida che verrebbero eseguiti. Il cmdlet non crea file o directory quando viene specificata questa opzione.

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

Non è possibile reindirizzare oggetti a questo cmdlet.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Il cmdlet restituisce un oggetto personalizzato con le seguenti proprietà:

- **Name**: il nome colorscript senza l'estensione `.ps1`
- **Path**: il percorso completo del file generato
- **Categories**: l'array di valori di categoria specificati (se presenti)
- **Tags**: l'array di valori di tag specificati (se presenti)
- **MetadataGuidance**: il testo dello snippet dei metadati (solo quando viene utilizzato -GenerateMetadataSnippet)

## NOTES

**Codifica**: lo scaffold è scritto con la codifica UTF-8 senza byte-order mark (BOM), garantendo la compatibilità tra diverse piattaforme ed editor.

**Struttura del modello**: il modello generato include:

- Un commento sull'impalcatura
- Un segnaposto array string per l'art
- Un loop che scrive ogni riga con `Write-Host`

**Integrazione Metadata**: sebbene il cmdlet possa generare indicazioni sui metadati, è necessario aggiungere manualmente lo snippet a `ScriptMetadata.psd1` per integrare completamente lo script nel sistema di rilevamento e categorizzazione del modulo.

**Flusso di lavoro di sviluppo**:

1. Utilizzare `New-ColorScript` per creare l'impalcatura
2. Modifica il file .ps1 generato per aggiungere la tua grafica ANSI
3. Se è stata generata una guida ai metadati, copiarla in `ScriptMetadata.psd1`
4. Prova il tuo script con `Show-ColorScript -Name <your-script-name>`

**Best practice**:

- Scegli nomi descrittivi e con trattino che indichino chiaramente il tema della sceneggiatura
- Utilizza valori di categoria coerenti in linea con gli script esistenti
- Applicare più tag per migliorare la rilevabilità
- Testare gli script in diversi ambienti terminali per garantire la compatibilità

## RELATED LINKS

- [Versione online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)

