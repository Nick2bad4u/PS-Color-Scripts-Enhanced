---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: it
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Aggiunge l'integrazione ColorScripts-Enhanced ai file di profilo PowerShell.

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

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

### -AutoShow

Controls whether the managed profile block displays a colorscript after importing the module.

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

### -DefaultStartupScript

Specifies the colorscript name written to the managed profile block for startup display.

```yaml
Type: System.String
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

### -Force

Updates the managed profile block without removing unrelated profile content.

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

### -IncludePokemon

Allows Pokemon-themed scripts when the managed profile block displays a random colorscript.

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

### -PokemonPromptResponse

Risponde in anticipo al prompt Pokémon (Y/Yes o N/No). Supporta la variabile di ambiente
`COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE` e la variabile globale
`$Global:ColorScriptsEnhancedPokemonPromptResponse`.

```yaml
Type: System.String
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

### -ProfilePath

Specifies the PowerShell profile file to update. The Path alias is also accepted.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Path
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

### -SkipCacheBuild

Evita il pre-caricamento della cache quando si aggiorna il profilo. Rispetta la variabile di ambiente
`COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` e la variabile globale
`$Global:ColorScriptsEnhancedSkipCacheBuild`. Il pre-caricamento è saltato automaticamente se il profilo
si trova sotto la cartella temporanea.

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

### -SkipPokemonPrompt

Ignora il prompt che chiede se includere i colorscript Pokémon all'avvio.

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

### -SkipStartupScript

Adds the module import but omits the startup Show-ColorScript invocation.

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

Runs the command in a mode that only reports what would happen without performing the actions.

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

This cmdlet does not accept pipeline input.

## OUTPUTS

### System.Object

Returns a custom object with the following properties:

- **ProfilePath** (string): The full path to the modified profile file
- **Changed** (bool): Whether the profile was actually modified
- **Message** (string): A status message describing the operation result

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

The profile file is created automatically if it does not exist, including any necessary parent directories.
Duplicate imports are detected and suppressed unless `-Force` is used.

If you need elevated permissions to modify an AllUsers profile, ensure you run PowerShell as Administrator.

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
