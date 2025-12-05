---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/pt/Export-ColorScriptMetadata.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Export-ColorScriptMetadata

## SYNOPSIS

Exporta metadados de colorscript para vários formatos para uso externo.

## SYNTAX

`Export-ColorScriptMetadata [-Path] <string> [[-Format] <string>] [-Category <string[]>] [-Tag <string[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]`

## DESCRIPTION

Exporta metadados abrangentes sobre colorscripts para arquivos externos para documentação, relatórios ou integração com outras ferramentas. Suporta vários formatos de saída, incluindo JSON, CSV e XML.

Os metadados exportados incluem:

- Nomes de scripts e caminhos de arquivos
- Categorias e tags
- Descrições e metadados
- Tamanhos de arquivos e datas de modificação
- Informações de status do cache

Este cmdlet é útil para:

- Gerar documentação
- Criar inventários
- Integração com sistemas CI/CD
- Propósitos de backup e migração
- Análise e relatórios

## EXAMPLES

### EXAMPLE 1

`powershell
Export-ColorScriptMetadata -Path "colorscripts.json"
`

Exporta todos os metadados de colorscript para um arquivo JSON.

### EXAMPLE 2

`powershell
Export-ColorScriptMetadata -Path "inventory.csv" -Format CSV
`

Exporta metadados no formato CSV para análise em planilha.

### EXAMPLE 3

`powershell
Export-ColorScriptMetadata -Path "nature-scripts.xml" -Category Nature -Format XML
`

Exporta apenas colorscripts de natureza para formato XML.

### EXAMPLE 4

`powershell
Export-ColorScriptMetadata -Path "geometric.json" -Tag geometric
`

Exporta colorscripts marcados como "geometric" para JSON.

### EXAMPLE 5

`powershell

# Exportar com timestamp

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
Export-ColorScriptMetadata -Path "backup-$timestamp.json"
`

Cria backup com timestamp de todos os metadados.

## PARAMETERS

### -Category

Filtrar scripts exportados por uma ou mais categorias antes da exportação.

`yaml
Type: System.String[]
DefaultValue: None
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
  `

### -Confirm

Solicita confirmação antes de executar o cmdlet.

`yaml
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
  `

### -Format

Especifica o formato de saída. Valores válidos são JSON, CSV e XML.

`yaml
Type: System.String
DefaultValue: JSON
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
  `

### -Path

Especifica o caminho onde o arquivo de metadados exportado será salvo.

`yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:

- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
  DontShow: false
  AcceptedValues: []
  HelpMessage: ''
  `

### -Tag

Filtrar scripts exportados por uma ou mais tags antes da exportação.

`yaml
Type: System.String[]
DefaultValue: None
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
  `

### -WhatIf

Mostra o que aconteceria se o cmdlet fosse executado. O cmdlet não é executado.

`yaml
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
  `

### CommonParameters

Este cmdlet suporta os parâmetros comuns: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction e -WarningVariable. Para mais informações, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet não aceita entrada do pipeline.

## OUTPUTS

### None (2)

Este cmdlet não retorna saída para o pipeline.

## NOTES

**Autor:** Nick
**Módulo:** ColorScripts-Enhanced
**Requer:** PowerShell 5.1 ou posterior

## Formatos de Saída

- JSON: Dados estruturados para acesso programático
- CSV: Formato compatível com planilha
- XML: Estrutura de dados hierárquica

## Casos de Uso

- Geração de documentação
- Gerenciamento de inventário
- Integração CI/CD
- Backup e recuperação
- Análises e relatórios

## RELATED LINKS

- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
