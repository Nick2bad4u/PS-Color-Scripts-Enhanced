---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

Recupera uma lista de colorscripts disponíveis com seus metadados.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

Retorna informações sobre os colorscripts disponíveis na coleção ColorScripts-Enhanced. Por padrão, exibe uma tabela formatada mostrando nomes de scripts, categorias e descrições. Use `-AsObject` para retornar objetos estruturados para acesso programático.

O cmdlet fornece metadados abrangentes sobre cada colorscript, incluindo:

- Nome: O identificador do script (sem extensão .ps1)
- Categoria: Agrupamento temático (Natureza, Abstrato, Geométrico, etc.)
- Tags: Descritores adicionais para filtragem e descoberta
- Descrição: Breve explicação do conteúdo visual do script

Este cmdlet é essencial para explorar a coleção e entender as opções disponíveis antes de usar outros cmdlets como `Show-ColorScript`.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Exibe uma tabela formatada de todos os colorscripts disponíveis com seus metadados.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Category Nature
```

Lista apenas colorscripts categorizados como "Natureza".

### EXAMPLE 3

```powershell
Get-ColorScriptList -Tag geometric -AsObject
```

Retorna colorscripts marcados como "geométrico" como objetos para processamento adicional.

### EXAMPLE 4

```powershell
Get-ColorScriptList -Name "aurora*" | Format-Table Name, Category, Tags
```

Lista colorscripts correspondendo ao padrão curinga com propriedades selecionadas.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject | Where-Object { $_.Tags -contains 'animated' }
```

Encontra todos os colorscripts animados usando filtragem de objetos.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Abstract,Geometric | Measure-Object
```

Conta colorscripts nas categorias Abstrato ou Geométrico.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Tag retro | Select-Object Name, Description
```

Mostra nomes e descrições de colorscripts no estilo retrô.

### EXAMPLE 8

```powershell
# Get random script from specific category
Get-ColorScriptList -Category Nature -AsObject | Get-Random | Select-Object -ExpandProperty Name
```

Seleciona um nome de colorscript temático da natureza aleatoriamente.

### EXAMPLE 9

```powershell
# Export script inventory to CSV
Get-ColorScriptList -AsObject | Export-Csv -Path "colorscripts.csv" -NoTypeInformation
```

Exporta metadados completos do script para um arquivo CSV.

### EXAMPLE 10

```powershell
# Find scripts by multiple criteria
Get-ColorScriptList -AsObject | Where-Object {
    $_.Category -eq 'Geometric' -and $_.Tags -contains 'colorful'
}
```

Encontra colorscripts geométricos que também são marcados como coloridos.

## PARAMETERS

### -AsObject

Retorna informações de colorscript como objetos estruturados em vez de exibir uma tabela formatada. Os objetos incluem propriedades Nome, Categoria, Tags e Descrição para acesso programático.

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

### -Category

Filtra resultados para colorscripts pertencentes a uma ou mais categorias especificadas. As categorias são agrupamentos temáticos amplos como "Natureza", "Abstrato", "Arte", "Retrô", etc.

```yaml
Type: System.String[]
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

### -Detailed

Displays an expanded formatted view that includes descriptions and additional metadata.

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

### -Name

Filtra resultados para colorscripts correspondendo a um ou mais padrões de nome. Suporta curingas (\* e ?) para correspondência flexível.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
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

### -NoAnsiOutput

Desativa a formatação ANSI nas mensagens informativas e na saída renderizada para ambientes de texto simples.

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

### -Quiet

Suprime mensagens informativas sem ocultar a saída do comando nem os erros.

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

### -Tag

Filtra resultados para colorscripts marcados com uma ou mais tags especificadas. As tags são descritores mais específicos como "geométrico", "retrô", "animado", "minimal", etc.

```yaml
Type: System.String[]
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet não aceita entrada do pipeline.

## OUTPUTS

### System.Object

Quando `-AsObject` é especificado, retorna objetos personalizados com propriedades Nome, Categoria, Tags e Descrição.

### None (2)

Quando `-AsObject` não é especificado, a saída é escrita diretamente no host do console.

## NOTES

**Autor:** Nick
**Módulo:** ColorScripts-Enhanced
**Requer:** PowerShell 5.1 ou posterior

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
