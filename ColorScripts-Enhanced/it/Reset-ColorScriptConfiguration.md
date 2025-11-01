---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/it/Reset-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Ripristina la configurazione di ColorScripts-Enhanced ai valori predefiniti.

## SYNTAX

```
Reset-ColorScriptConfiguration [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Ripristina le impostazioni di configurazione di ColorScripts-Enhanced ai valori predefiniti. Questo cmdlet rimuove tutte le personalizzazioni dell'utente e riporta il modulo al suo stato di configurazione originale.

Le operazioni di ripristino includono:
- Impostazioni del percorso della cache
- Preferenze di prestazioni
- Opzioni di visualizzazione
- Impostazioni del comportamento del modulo

Questo cmdlet è utile quando:
- La configurazione diventa corrotta
- Si desidera ricominciare con le impostazioni predefinite
- Si risolvono problemi relativi alla configurazione
- Si prepara il modulo per test puliti

L'operazione di ripristino richiede conferma per impostazione predefinita per prevenire la perdita accidentale di dati.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration
```

Ripristina tutte le impostazioni di configurazione ai valori predefiniti con richiesta di conferma.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Ripristina la configurazione senza richiesta di conferma.

### EXAMPLE 3

```powershell
Reset-ColorScriptConfiguration -WhatIf
```

Mostra quali modifiche alla configurazione verrebbero apportate senza applicarle.

### EXAMPLE 4

```powershell
# Reset and verify
Reset-ColorScriptConfiguration
Get-ColorScriptConfiguration
```

Ripristina la configurazione e visualizza le nuove impostazioni predefinite.

## PARAMETERS

### -Confirm

Richiede conferma prima di eseguire il cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: true
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

**Ambito del ripristino:**
Ripristina tutte le impostazioni configurabili dall'utente ai valori predefiniti del modulo. Ciò include percorsi della cache, impostazioni di prestazioni e preferenze di visualizzazione.

**Sicurezza dei dati:**
Il ripristino della configurazione non influisce sull'output degli script memorizzati nella cache o sui colorscript creati dall'utente. Solo le impostazioni di configurazione sono interessate.

**Ripristino:**
Dopo il ripristino, utilizzare Set-ColorScriptConfiguration per riapplicare le impostazioni personalizzate se necessario.

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
