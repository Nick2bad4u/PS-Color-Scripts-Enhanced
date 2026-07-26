---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Adiciona ou atualiza um bloco de inicialização ColorScripts-Enhanced gerenciado em um arquivo de perfil PowerShell.

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

Este comando não tem aliases.

## DESCRIPTION

Adiciona um bloco de inicialização gerenciado ao perfil PowerShell selecionado. O bloco importa ColorScripts-Enhanced e pode chamar `Show-ColorScript` após a importação. `-SkipStartupScript` grava um bloco somente de importação.

Quando `-ProfilePath` é omitido, o comando prefere `$PROFILE.CurrentUserAllHosts` e, caso contrário, usa o primeiro caminho de perfil definido. O arquivo de perfil e os diretórios pai ausentes são criados quando necessário.

Os blocos ColorScripts-Enhanced gerenciados ou legados existentes são substituídos em vez de duplicados. Se o perfil já importa o módulo fora de um bloco gerenciado, o comando o deixa inalterado, a menos que `-Force` seja especificado. `-Force` permite substituir o conteúdo do módulo reconhecido enquanto preserva o conteúdo do perfil não relacionado.

O comportamento de inicialização gerado é resolvido a partir de parâmetros explícitos e configuração persistente. `-AutoShow` permite explicitamente a exibição, `-DefaultStartupScript` seleciona um script nomeado e a inclusão de Pokémon pode ser fornecida diretamente ou resolvida por meio do prompt interativo e suas substituições documentadas. A menos que `-SkipCacheBuild` seja usado, o comando pode pré-aquecer entradas de cache selecionadas por política após atualizar o perfil.

## EXAMPLES

### EXAMPLE 1

Adicione ao perfil do usuário atual para todos os hosts (comportamento padrão).

```powershell
Add-ColorScriptProfile
```

Isso adiciona a importação do módulo e a chamada `Show-ColorScript` a `$PROFILE.CurrentUserAllHosts`.

### EXAMPLE 2

Adicione ao perfil do usuário atual somente para o host atual, sem o script de inicialização.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost -SkipStartupScript
```

Isso adiciona um bloco gerenciado somente para importação ao perfil do host atual.

### EXAMPLE 3

Adicione a um caminho de perfil personalizado com expansão de variável de ambiente.

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

Isso tem como alvo um arquivo de perfil específico fora dos locais de perfil padrão PowerShell.

### EXAMPLE 4

Force a adição adicional do snippet, mesmo que ele já exista.

```powershell
Add-ColorScriptProfile -Force
```

Isso atualiza o conteúdo do perfil ColorScripts-Enhanced reconhecido, preservando linhas de perfil não relacionadas.

### EXAMPLE 5

Configuração em uma nova máquina - crie um perfil, se necessário, e adicione ColorScripts a todos os hosts.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts -Confirm:$false
Write-Host "Perfil configurado. Reinicie o terminal para exibir colorscripts na inicialização."
```

### EXAMPLE 6

Adicione um colorscript específico para exibição de inicialização:

```powershell
Add-ColorScriptProfile -DefaultStartupScript mandelbrot-zoom -AutoShow
```

### EXAMPLE 7

Verifique se o perfil foi adicionado corretamente:

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Direcione explicitamente o perfil do host atual ou de todos os hosts:

```powershell
# Somente para Terminal Windows ou ConEmu
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost

# Para todos os hosts PowerShell (ISE, VSCode, Console)
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts
```

### EXAMPLE 9

Usando caminhos relativos e expansão de til:

```powershell
# Usando expansão til para diretório inicial
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# Usando o caminho relativo do diretório atual
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

Exiba colorscript diferentes diariamente adicionando lógica personalizada:

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Em seguida, adicione manualmente o seguinte ao $PROFILE
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

### EXAMPLE 11

Ignore automaticamente os scripts Pokémon ao exibir a arte inicial:

```powershell
Add-ColorScriptProfile -IncludePokemon
```

Isso anexa `Show-ColorScript -IncludePokemon` (envolto em um try/catch protetor) ao perfil, portanto a arte de lançamento pode incluir scripts Pokémon.

## PARAMETERS

### -AutoShow

Controla se o bloco de perfil gerenciado exibe um colorscript após importar o módulo.

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

Solicita confirmação antes de executar o cmdlet.

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

Especifica o nome colorscript gravado no bloco de perfil gerenciado para exibição de inicialização.

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

Atualiza o conteúdo reconhecido do ColorScripts-Enhanced no perfil, preservando as linhas não relacionadas. Não acrescenta deliberadamente blocos geridos duplicados.

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

Exibe informações de ajuda para este cmdlet. Equivalente a usar `Get-Help Add-ColorScriptProfile`.

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

Adicione `-IncludePokemon` à chamada `Show-ColorScript` gerada para que o Pokémon colorscripts seja incluído na inicialização, quando presente. Ignorado quando `-SkipStartupScript` é usado.

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

Pré-responda ao prompt de inclusão de Pokémon. Aceita S/Sim ou N/Não. Também respeita a variável de ambiente
`COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE` e a variável global
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

Especifica o arquivo de perfil PowerShell a ser atualizado. O alias Path também é aceito.

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

Suprima o pré-aquecimento do cache opcional. Um pré-aquecimento é tentado somente quando o `ProfileAutoShow` resolvido
configuração está ativada, a construção de cache não foi desativada, o perfil de destino está fora do
diretório temporário do sistema e a operação é aprovada por `ShouldProcess`. O comando também respeita o
variável de ambiente `COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` e a variável global
`$Global:ColorScriptsEnhancedSkipCacheBuild`.

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

Ignore o prompt interativo que pergunta se o Pokémon colorscripts deve ser incluído na inicialização.

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

Ignore a adição de `Show-ColorScript` ao perfil. Somente a linha `Import-Module ColorScripts-Enhanced` é anexada. Use isto se desejar controlar manualmente quando colorscripts são exibidos.

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

Mostra o que aconteceria se o cmdlet fosse executado. O cmdlet não é executado.

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

Este cmdlet suporta os parâmetros comuns:
Para obter mais informações, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet não aceita entrada de pipeline.

## OUTPUTS

### System.Object

Retorna um objeto personalizado com as seguintes propriedades:

- **Path** (string): O caminho completo para o arquivo de perfil selecionado
- **Changed** (bool): Se o perfil foi realmente modificado
- **Message** (string): Uma mensagem de status descrevendo o resultado da operação
- **IncludePokemon** (bool): A escolha inicial de inclusão de Pokémon
- **CacheBuilt** (bool): Se o aquecimento do cache opcional foi concluído

## NOTES

**Autor:** Nick

**Módulo:** ColorScripts-Enhanced

**Requer:** PowerShell 5.1 ou posterior

O arquivo de perfil será criado automaticamente se não existir, incluindo os diretórios pai necessários. O comando gerencia caminhos de arquivos fornecidos pelo usuário; ele não expõe um seletor de escopo separado.

## RELATED LINKS

- [Versão online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)

