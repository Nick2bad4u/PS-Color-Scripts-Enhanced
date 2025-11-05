---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/pt/Get-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Recupera as configurações atuais do ColorScripts-Enhanced.

## SYNTAX

`Get-ColorScriptConfiguration [<CommonParameters>]`

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

### CommonParameters

Este cmdlet suporta os parâmetros comuns: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction e -WarningVariable. Para mais informaçoes, consulte
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

**Propriedades de Configuração:**

- CachePath: Local onde a saída do script em cache é armazenada
- Configurações de desempenho para otimização
- Preferências de exibição para comportamento padrão
- Opções de configuração específicas do módulo

**Localização da Configuração:**
As configurações são armazenadas em arquivos de configuração específicos do usuário. Use mecanismos de configuração padrão do PowerShell para persistência.

## RELATED LINKS

- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
