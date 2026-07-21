---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Recupera as configurações atuais do ColorScripts-Enhanced.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

Exibe as configurações atuais do ColorScripts-Enhanced. Isso inclui caminhos de cache, configurações de desempenho e preferências do usuário que afetam o comportamento do módulo.

O sistema de configuração fornece configurações persistentes que personalizam a operação do módulo. As configurações são armazenadas em arquivos de configuração específicos do usuário e podem ser modificadas usando Set-ColorScriptConfiguration.

As informações exibidas incluem:

- Localização do diretório de cache
- Configurações de otimização de desempenho
- Preferências de exibição padrão
- Configurações de comportamento do módulo

Este cmdlet é essencial para entender a configuração atual do módulo e solucionar problemas relacionados à configuração.

## EXAMPLES

### EXAMPLE 1

`powershell
Get-ColorScriptConfiguration
`

Exibe todas as configurações atuais.

### EXAMPLE 2

`powershell
Get-ColorScriptConfiguration | Format-List
`

Exibe a configuração em formato de lista para melhor legibilidade.

### EXAMPLE 3

`powershell

# Check cache location

(Get-ColorScriptConfiguration).CachePath
`

Recupera apenas a configuração do caminho do cache.

### EXAMPLE 4

`powershell

# Verify configuration is loaded

if (Get-ColorScriptConfiguration) {
Write-Host "Configuration loaded successfully"
}
`

Verifica se a configuração está carregada corretamente.

## PARAMETERS

### -h

Exibe a ajuda detalhada deste comando sem executar a operação.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet nao aceita entrada do pipeline.

## OUTPUTS

### System.Object

Retorna um objeto personalizado contendo propriedades de configuração.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

