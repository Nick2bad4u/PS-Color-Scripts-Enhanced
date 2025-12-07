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

```text
Add-ColorScriptProfile [[-Scope] <string>] [[-Path] <string>] [-h] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-PokemonPromptResponse <string>] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
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

Aggiunge lo snippet ColorScripts-Enhanced al profilo predefinito.

### EXAMPLE 2

```powershell
Add-ColorScriptProfile -Scope CurrentUserAllHosts -IncludePokemon
```

Aggiunge lo snippet a tutti gli host per l'utente corrente e configura `Show-ColorScript -IncludePokemon`.

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

### -SkipPokemonPrompt

Ignora il prompt che chiede se includere i colorscript Pokémon all'avvio.

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
HelpMessage: ""
```

### -PokemonPromptResponse

Risponde in anticipo al prompt Pokémon (Y/Yes o N/No). Supporta la variabile di ambiente
`COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE` e la variabile globale
`$Global:ColorScriptsEnhancedPokemonPromptResponse`.

```yaml
Type: System.String
DefaultValue: ""
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

### -SkipCacheBuild

Evita il pre-caricamento della cache quando si aggiorna il profilo. Rispetta la variabile di ambiente
`COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` e la variabile globale
`$Global:ColorScriptsEnhancedSkipCacheBuild`. Il pre-caricamento è saltato automaticamente se il profilo
si trova sotto la cartella temporanea.

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
HelpMessage: ""
```

### CommonParameters

Questo cmdlet supporta i parametri comuni: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Per ulteriori informazioni, vedere
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).
- Le modifiche hanno effetto nelle nuove sessioni PowerShell

## Funzionalità di sicurezza

- Verifica l'integrazione esistente per evitare duplicazioni
- Utilizza meccanismi di profilo PowerShell standard
- Fornisce opzioni WhatIf e Confirm per operazioni sicure

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
