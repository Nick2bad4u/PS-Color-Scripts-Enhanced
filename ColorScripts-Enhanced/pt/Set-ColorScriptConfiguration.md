---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Persista as alterações no cache ColorScripts-Enhanced e na configuração de inicialização.

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Este comando não tem aliases.

## DESCRIPTION

`Set-ColorScriptConfiguration` fornece uma maneira persistente de personalizar o comportamento e o local de armazenamento do módulo ColorScripts-Enhanced. Este cmdlet atualiza o arquivo de configuração do módulo, permitindo controlar vários aspectos da renderização e armazenamento de scripts.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

Move o cache para `D:/Temp/ColorScriptsCache`, ativa a exibição automática na importação do módulo, desativa a exibição automática do perfil e define `bars` como o script padrão.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

Limpa o script padrão e retorna o objeto de configuração resultante, permitindo verificar se a configuração foi removida.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

Realoca o cache para o diretório TEMP do Windows e exibe a configuração completa atualizada em formato de lista. Útil para cenários de teste temporários.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

Desativa a renderização automática do colorscript quando o módulo é carregado. Útil se você preferir o controle manual em vez de quando os scripts são exibidos.

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

Define um caminho de cache no estilo Linux/macOS usando expansão til e configura 'crunch' como o script padrão para todas as operações.

## PARAMETERS

### -AutoShowOnImport

Ative ou desative a renderização automática de um colorscript quando o módulo for importado. Quando ativado (`$true`), um colorscript é exibido imediatamente após a importação do módulo, fornecendo feedback visual instantâneo. Quando desativado (`$false`), os scripts são exibidos somente quando invocados explicitamente. Se não for especificado, a configuração existente permanecerá inalterada.

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -CachePath

Especifica o diretório onde as cargas úteis `.cache` renderizadas e os sidecars de validação `.cacheinfo` são armazenados. A fonte colorscripts e os metadados do módulo permanecem no módulo instalado. Suporta caminhos absolutos, caminhos relativos (resolvidos a partir do local atual), variáveis ​​de ambiente (por exemplo, `$env:USERPROFILE`) e expansão de til (`~`).

Se o diretório especificado não existir, ele será criado automaticamente com as permissões apropriadas. Forneça um string (`''`) vazio para limpar o caminho personalizado e reverter para o local padrão específico da plataforma. Quando não for especificado, a configuração do caminho do cache existente será preservada.

**Note**: A alteração do caminho do cache não migra automaticamente os arquivos armazenados em cache existentes. Pode ser necessário copiar os arquivos manualmente ou permitir que eles sejam regenerados.

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

### -DefaultScript

Define ou limpa o nome colorscript padrão usado por auxiliares de perfil, recursos de exibição automática e quando nenhum script é especificado explicitamente em comandos. Deve corresponder ao nome base de um arquivo de script sem extensão (por exemplo, `'bars'`, não `'bars.ps1'`).

Forneça um string (`''`) vazio para remover o padrão armazenado, revertendo para o comportamento padrão no nível do módulo (geralmente seleção aleatória). Quando esse parâmetro é omitido, a configuração de script padrão atual permanece inalterada.

O script especificado deve existir no diretório de script do módulo para ser usado com sucesso.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -h

Exibe ajuda detalhada para este comando sem executar a operação.

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

Retorna o objeto de configuração atualizado após fazer alterações. Sem essa opção, o cmdlet opera silenciosamente (sem saída). O objeto retornado tem a mesma estrutura que `Get-ColorScriptConfiguration` e pode ser inspecionado, armazenado ou canalizado para outros cmdlets para processamento adicional.

Útil para verificação, registro ou encadeamento de comandos de configuração.

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

### -ProfileAutoShow

Controla se os snippets de perfil gerados por `Add-ColorScriptProfile` incluem uma invocação automática de `Show-ColorScript`. Quando `$true`, o código do perfil exibirá colorscript em cada inicialização do shell. Quando `$false`, o perfil carregará o módulo, mas não exibirá scripts automaticamente.

Essa configuração afeta apenas o código de perfil recém-gerado; as modificações de perfil existentes não são atualizadas automaticamente. A omissão deste parâmetro deixa a configuração atual inalterada.

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -WhatIf

Executa o comando em um modo que apenas informa o que aconteceria sem executar as ações.

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

### None (2)

Por padrão, esse cmdlet não produz nenhuma saída.

### System.Collections.Hashtable

Quando `-PassThru` é especificado, retorna a tabela hash aninhada produzida por `Get-ColorScriptConfiguration`: os valores de cache estão em `Cache` e os valores de inicialização estão em `Startup`.

## NOTES

A configuração persiste somente após a validação e a confirmação serem bem-sucedidas. `-WhatIf` não executa nenhuma gravação no sistema de arquivos. Use `Get-ColorScriptConfiguration` para inspecionar os valores efetivos e caminhos de armazenamento após a operação.

## RELATED LINKS

- [Versão online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)

