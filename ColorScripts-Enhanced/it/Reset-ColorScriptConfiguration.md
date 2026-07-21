---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Ripristina la configurazione di ColorScripts-Enhanced ai valori predefiniti.

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

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

Visualizza la guida dettagliata del comando senza eseguire l'operazione.

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

### -PassThru

Returns the effective default configuration after the reset succeeds.

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

### -WhatIf

Mostra cosa accadrebbe se il cmdlet venisse eseguito. Il cmdlet non viene eseguito.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Questo cmdlet non accetta input dalla pipeline.

## OUTPUTS

### None (2)

Questo cmdlet non restituisce output alla pipeline.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 o versioni successive

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)

