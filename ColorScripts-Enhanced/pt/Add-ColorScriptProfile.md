---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/pt/Add-ColorScriptProfile.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Add-ColorScriptProfile

## SYNOPSIS

Adiciona integração do ColorScripts-Enhanced aos arquivos de perfil do PowerShell.

## SYNTAX

```text
Add-ColorScriptProfile [[-Scope] <string>] [[-Path] <string>] [-h] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-PokemonPromptResponse <string>] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Adiciona automaticamente a integração de inicialização do ColorScripts-Enhanced ao seu perfil do PowerShell. Este cmdlet modifica seus arquivos de perfil para importar o módulo ColorScripts-Enhanced e, opcionalmente, exibir um colorscript na inicialização da sessão.

O cmdlet suporta todos os escopos padrão de perfil do PowerShell:

- CurrentUserCurrentHost: Perfil para o usuário atual e host atual
- CurrentUserAllHosts: Perfil para o usuário atual em todos os hosts
- AllUsersCurrentHost: Perfil para todos os usuários no host atual (requer admin)
- AllUsersAllHosts: Perfil para todos os usuários em todos os hosts (requer admin)

Quando executado, adiciona um snippet que:

1. Importa o módulo ColorScripts-Enhanced
2. Opcionalmente exibe um colorscript aleatório na inicialização
3. Fornece aliases úteis para acesso rápido

A integração é projetada para ser não intrusiva e pode ser facilmente removida editando diretamente seus arquivos de perfil.

## EXAMPLES

### EXAMPLE 1

```powershell
Add-ColorScriptProfile
```

Adiciona integração do ColorScripts-Enhanced ao seu perfil padrão (CurrentUserCurrentHost).

### EXAMPLE 2

```powershell
Add-ColorScriptProfile -Scope CurrentUserAllHosts
```

Adiciona integração ao seu perfil que se aplica a todos os hosts do PowerShell para o usuário atual.

### EXAMPLE 3

```powershell
Add-ColorScriptProfile -Scope AllUsersCurrentHost
```

Adiciona integração ao perfil para todos os usuários no host atual (requer privilégios de administrador).

### EXAMPLE 4

```powershell
Add-ColorScriptProfile -WhatIf
```

Mostra quais alterações seriam feitas ao seu perfil sem aplicá-las.

### EXAMPLE 5

```powershell
Add-ColorScriptProfile -Confirm
```

Solicita confirmação antes de modificar seu perfil.

## PARAMETERS

### -Confirm

Solicita confirmação antes de executar o cmdlet.

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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Scope

Especifica o escopo do perfil a modificar. Valores válidos são:

- CurrentUserCurrentHost (padrão)
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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Mostra o que aconteceria se o cmdlet fosse executado. O cmdlet não é executado.

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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SkipPokemonPrompt

Ignora o prompt que pergunta se deve incluir scripts de Pokémon na inicialização.

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

Responde antecipadamente ao prompt de Pokémon (Y/Yes ou N/No). Também respeita a variável de ambiente
`COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE` e a variável global
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

Evita o pré-aquecimento do cache ao atualizar o perfil. Também respeita a variável de ambiente
`COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` e a variável global
`$Global:ColorScriptsEnhancedSkipCacheBuild`. É automaticamente ignorado quando o caminho do perfil está
sob o diretório temporário.

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

Este cmdlet suporta os parâmetros comuns: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Para mais informações, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet não aceita entrada do pipeline.

## OUTPUTS

### None (2)

Este cmdlet não retorna saída para o pipeline.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 ou posterior

## Integração de Perfil
O cmdlet adiciona um snippet de inicialização que importa o ColorScripts-Enhanced e fornece acesso conveniente. A integração é projetada para ser leve e não disruptiva.

## Considerações de Escopo

- Escopos CurrentUser modificam arquivos no diretório de perfil do usuário
- Escopos AllUsers requerem privilégios de administrador e afetam todos os usuários
- As alterações entram em vigor em novas sessões do PowerShell

## Recursos de Segurança

- Verifica integração existente para evitar duplicação
- Usa mecanismos padrão de perfil do PowerShell
- Fornece opções WhatIf e Confirm para operação segura

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
