---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/it/Set-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Modifica le impostazioni di configurazione di ColorScripts-Enhanced.

## SYNTAX

```
Set-ColorScriptConfiguration [-CachePath <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Aggiorna le impostazioni di configurazione di ColorScripts-Enhanced con archiviazione persistente. Questo cmdlet consente la personalizzazione del comportamento del modulo attraverso opzioni configurabili dall'utente.

Le impostazioni configurabili includono:
- Posizione della directory cache
- Preferenze di ottimizzazione delle prestazioni
- Comportamento di visualizzazione predefinito
- Impostazioni operative del modulo

Le modifiche vengono automaticamente salvate nei file di configurazione specifici dell'utente e persistono tra le sessioni PowerShell. Usa Get-ColorScriptConfiguration per visualizzare le impostazioni attuali.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath "C:\MyCache"
```

Imposta un percorso personalizzato per la directory cache.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -CachePath $env:TEMP
```

Utilizza la directory temporanea del sistema per l'archiviazione della cache.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "~/.colorscript-cache"
```

Imposta il percorso della cache utilizzando la notazione della directory home in stile Unix.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -WhatIf
```

Mostra quali modifiche alla configurazione verrebbero apportate senza applicarle.

### EXAMPLE 5

```powershell
# Backup current config, modify, then restore if needed
$currentConfig = Get-ColorScriptConfiguration
Set-ColorScriptConfiguration -CachePath "D:\Cache"
# ... test new configuration ...
# Set-ColorScriptConfiguration -CachePath $currentConfig.CachePath
```

Dimostra il backup e il ripristino della configurazione.

## PARAMETERS

### -CachePath

Specifica il percorso della directory in cui verranno archiviati i file cache dei colorscript.

```yaml
Type: System.String
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
HelpMessage: ''
```

### -Confirm

Richiede conferma prima di eseguire il cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: false
SupportsWildcards: false
Aliases: cf
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

### -WhatIf

Mostra cosa accadrebbe se il cmdlet venisse eseguito. Il cmdlet non viene eseguito.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: false
SupportsWildcards: false
Aliases: wi
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

Questo cmdlet supporta i parametri comuni: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Per ulteriori informazioni, vedere
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Questo cmdlet non accetta input dalla pipeline.

## OUTPUTS

### None

Questo cmdlet non restituisce output alla pipeline.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 o versioni successive

**Persistenza della configurazione:**
Le impostazioni vengono automaticamente salvate nei file di configurazione specifici dell'utente e persistono tra le sessioni PowerShell.

**Risoluzione del percorso:**
I percorsi della cache supportano variabili d'ambiente, percorsi relativi e notazione standard di PowerShell.

**Convalida:**
Le modifiche alla configurazione vengono convalidate prima dell'applicazione per prevenire impostazioni non valide.

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
