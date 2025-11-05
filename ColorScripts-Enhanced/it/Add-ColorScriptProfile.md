---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/it/Add-ColorScriptProfile.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Add-ColorScriptProfile

## SYNOPSIS

Aggiunge l'integrazione ColorScripts-Enhanced ai file di profilo PowerShell.

## SYNTAX

```
Add-ColorScriptProfile [[-Scope] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Aggiunge automaticamente l'integrazione di avvio ColorScripts-Enhanced al tuo profilo PowerShell. Questo cmdlet modifica i tuoi file di profilo per importare il modulo ColorScripts-Enhanced e opzionalmente visualizzare un colorscript all'avvio della sessione.

Il cmdlet supporta tutti gli ambiti di profilo PowerShell standard:

- CurrentUserCurrentHost: Profilo per l'utente corrente e l'host corrente
- CurrentUserAllHosts: Profilo per l'utente corrente su tutti gli host
- AllUsersCurrentHost: Profilo per tutti gli utenti sull'host corrente (richiede admin)
- AllUsersAllHosts: Profilo per tutti gli utenti su tutti gli host (richiede admin)

Quando eseguito, aggiunge uno snippet che:

1. Importa il modulo ColorScripts-Enhanced
2. Opzionalmente visualizza un colorscript casuale all'avvio
3. Fornisce alias utili per l'accesso rapido

L'integrazione è progettata per essere non intrusiva e può essere facilmente rimossa modificando direttamente i tuoi file di profilo.

## EXAMPLES

### EXAMPLE 1

```powershell
Add-ColorScriptProfile
```

Aggiunge l'integrazione ColorScripts-Enhanced al tuo profilo predefinito (CurrentUserCurrentHost).

### EXAMPLE 2

```powershell
Add-ColorScriptProfile -Scope CurrentUserAllHosts
```

Aggiunge l'integrazione al tuo profilo che si applica a tutti gli host PowerShell per l'utente corrente.

### EXAMPLE 3

```powershell
Add-ColorScriptProfile -Scope AllUsersCurrentHost
```

Aggiunge l'integrazione al profilo per tutti gli utenti sull'host corrente (richiede privilegi di amministratore).

### EXAMPLE 4

```powershell
Add-ColorScriptProfile -WhatIf
```

Mostra quali modifiche verrebbero apportate al tuo profilo senza applicarle effettivamente.

### EXAMPLE 5

```powershell
Add-ColorScriptProfile -Confirm
```

Richiede conferma prima di modificare il tuo profilo.

## PARAMETERS

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
HelpMessage: ""
```

### -Scope

Specifica l'ambito del profilo da modificare. I valori validi sono:

- CurrentUserCurrentHost (predefinito)
- CurrentUserAllHosts
- AllUsersCurrentHost
- AllUsersAllHosts

```yaml
Type: System.String
DefaultValue: CurrentUserCurrentHost
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
HelpMessage: ""
```

### -WhatIf

Mostra cosa accadrebbe se il cmdlet viene eseguito. Il cmdlet non viene eseguito.

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
HelpMessage: ""
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
**Requires:** PowerShell 5.1 o successivo

**Integrazione profilo:**
Il cmdlet aggiunge uno snippet di avvio che importa ColorScripts-Enhanced e fornisce accesso conveniente. L'integrazione è progettata per essere leggera e non disturbare.

**Considerazioni ambito:**

- Gli ambiti CurrentUser modificano i file nella directory del profilo utente
- Gli ambiti AllUsers richiedono privilegi di amministratore e influenzano tutti gli utenti
- Le modifiche hanno effetto nelle nuove sessioni PowerShell

**Funzionalità di sicurezza:**

- Verifica l'integrazione esistente per evitare duplicazioni
- Utilizza meccanismi di profilo PowerShell standard
- Fornisce opzioni WhatIf e Confirm per operazioni sicure

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
