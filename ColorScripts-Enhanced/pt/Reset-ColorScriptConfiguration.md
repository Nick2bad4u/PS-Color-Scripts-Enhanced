---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Restaure a configuração do ColorScripts-Enhanced para seus valores padrão.

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Este comando não tem aliases.

## DESCRIPTION

`Reset-ColorScriptConfiguration` substitui a configuração persistente pelos padrões integrados e redefine o estado do cache na memória do módulo. Quando executado, este cmdlet:

- Limpa a substituição do caminho de cache configurado para que o padrão de plataforma efetivo seja usado
- Restaura `AutoShowOnImport`, `ProfileAutoShow` e `DefaultScript`
- Grava a configuração padrão em `config.json`
- Limpa o estado de cache/configuração da memória para que as operações subsequentes usem os valores redefinidos

Este cmdlet oferece suporte aos parâmetros `-WhatIf` e `-Confirm` porque executa uma operação destrutiva ao substituir o arquivo de configuração. A operação de redefinição não pode ser desfeita automaticamente, portanto, os usuários devem considerar fazer backup de sua configuração atual usando `Get-ColorScriptConfiguration` antes de continuar.

Use o parâmetro `-PassThru` para inspecionar imediatamente as configurações padrão recém-restauradas após a conclusão da redefinição.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Redefine a configuração sem solicitar confirmação. Isso é útil em scripts automatizados ou quando você tem certeza de redefinir os padrões.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

Redefine a configuração e retorna a tabela hash resultante para inspeção, permitindo verificar os valores padrão.

### EXAMPLE 3

```powershell
# Faça backup da configuração atual antes de redefinir
$backup = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
```

Usa `-WhatIf` para visualizar a operação de redefinição sem realmente executá-la, após fazer backup da configuração atual.

### EXAMPLE 4

```powershell
Reset-ColorScriptConfiguration -Verbose
```

Redefine a configuração com saída detalhada para ver informações detalhadas sobre a operação.

### EXAMPLE 5

```powershell
# Redefina a configuração e limpe o cache para uma redefinição completa de fábrica
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "Módulo restaurado aos padrões de fábrica."
```

Executa uma redefinição de fábrica completa, incluindo configuração, cache e reconstrução do cache.

### EXAMPLE 6

```powershell
# Verifique se a redefinição foi bem-sucedida
$config = Reset-ColorScriptConfiguration -PassThru
if ($null -eq $config.Cache.Path -and $config.Cache.EffectivePath) {
    Write-Host "Configuração restaurada ao padrão da plataforma"
} else {
    Write-Host "Configuração restaurada, mas usando um caminho personalizado: $($config.Cache.Path)"
}
```

Redefine e verifica se a substituição do cache persistente está vazia e se um caminho de plataforma efetivo está disponível.

## PARAMETERS

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

Retorne o objeto de configuração atualizado após a conclusão da redefinição.

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

Mostra o que aconteceria se o cmdlet fosse executado sem realmente executar a operação de redefinição.

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

### System.Collections.Hashtable

Retornado quando `-PassThru` é especificado.

## NOTES

O arquivo de configuração é armazenado no diretório resolvido por `Get-ColorScriptConfiguration`. Por padrão, este local é específico da plataforma:

- **Windows**: `$env:APPDATA\ColorScripts-Enhanced`
- **Linux/macOS**: `$HOME/.config/ColorScripts-Enhanced`

A variável de ambiente `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` pode substituir o local padrão se for definida antes da importação do módulo.

## RELATED LINKS

- [Versão online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)

