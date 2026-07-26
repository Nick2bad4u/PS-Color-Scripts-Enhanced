---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

Lista colorscripts disponível com filtragem opcional e saída rica de metadados.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

Este comando não tem aliases.

## DESCRIPTION

O cmdlet `Get-ColorScriptList` recupera e exibe todos os colorscripts empacotados com o módulo ColorScripts-Enhanced. Ele fornece opções de filtragem flexíveis e vários formatos de saída para atender a diferentes casos de uso.

Por padrão, o cmdlet exibe uma tabela formatada concisa mostrando nomes e categorias de scripts. O switch `-Detailed` expande essa visualização para incluir tags e descrições, fornecendo mais contexto rapidamente.

O cmdlet sempre retorna registros de metadados para o pipeline de sucesso. Sem `-AsObject`, ele também grava uma visualização de host formatada; `-AsObject` suprime essa formatação de host para automação limpa. Os registros incluem nome, caminho, categoria, categorias, tags, descrição e a propriedade de metadados original.

Os recursos de filtragem permitem restringir a lista por:

- **Name**: Suporta padrões curinga (por exemplo, `aurora-*`) para correspondência flexível
- **Category**: Filtre por um ou mais nomes de categoria (sem distinção entre maiúsculas e minúsculas)
- **Tag**: Filtrar por tags de metadados, como "Recommended" ou "Animated" (sem distinção entre maiúsculas e minúsculas)

O cmdlet valida padrões de filtro e gera avisos para quaisquer padrões de nomes incompatíveis, ajudando você a identificar possíveis erros de digitação ou scripts ausentes.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Exibe todos os colorscripts disponíveis em um formato de tabela compacta mostrando o nome e a categoria de cada script.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed
```

Mostra todos os colorscripts com colunas adicionais, incluindo tags e descrições para uma visão geral abrangente.

### EXAMPLE 3

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

Exibe apenas scripts na categoria "Patterns" com metadados completos, incluindo tags e descrições.

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

Retorna objetos estruturados para cada script cujo nome corresponde ao padrão curinga e, em seguida, seleciona apenas as propriedades Name e Tags para exibição.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

Recupera todos os scripts marcados como "Recommended" e os classifica em ordem alfabética por nome. Útil para encontrar scripts selecionados adequados para integração de perfis.

### EXAMPLE 6

```powershell
Get-ColorScriptList -AsObject -Category Geometric,Abstract | Where-Object { $_.Tags -contains 'Colorful' }
```

Combina filtragem de categorias e tags para encontrar scripts que estejam nas categorias Geométrica ou Abstrata e marcados como Coloridos.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Name blocks,pipes,matrix -AsObject | ForEach-Object { Show-ColorScript -Name $_.Name }
```

Recupera scripts nomeados específicos e executa cada um deles em sequência, demonstrando a integração do pipeline com `Show-ColorScript`.

### EXAMPLE 8

```powershell
# Contar scripts por categoria para fins de inventário
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending
```

Fornece um resumo de quantos colorscripts existem em cada categoria.

### EXAMPLE 9

```powershell
# Encontre scripts com palavras-chave específicas na descrição
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

Pesquisa scripts com base no conteúdo da descrição usando correspondência de padrões.

### EXAMPLE 10

```powershell
# Exportar para CSV para processamento de ferramentas externas
Get-ColorScriptList -AsObject -Detailed |
    Select-Object Name, Category, Tags, Description |
    Export-Csv -Path "./colorscripts-inventory.csv" -NoTypeInformation
```

Exporta o inventário colorscript completo para o formato CSV para uso em aplicativos de planilha.

### EXAMPLE 11

```powershell
# Verifique se há scripts sem categoria específica
$allScripts = Get-ColorScriptList -AsObject
$uncategorized = $allScripts | Where-Object { -not $_.Category }
Write-Host "Scripts sem categoria: $($uncategorized.Count)"
$uncategorized | Select-Object Name
```

Identifica scripts que não possuem metadados de categoria.

### EXAMPLE 12

```powershell
# Crie cache para scripts filtrados
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object {
        New-ColorScriptCache -Name $_.Name -PassThru
    } |
    Format-Table Name, Status
```

Avalia scripts marcados como `Recommended`; apenas renderizadores qualificados para política de cache são criados e outros registros relatam `SkippedNotRequired`.

### EXAMPLE 13

```powershell
# Crie um relatório formatado de todos os scripts geométricos
Get-ColorScriptList -Category Geometric -Detailed |
    Out-String |
    Tee-Object -FilePath "./geometric-report.txt"
```

Gera e salva um relatório detalhado da categoria geométrica colorscripts em um arquivo.

### EXAMPLE 14

```powershell
# Encontre o primeiro script que corresponda a um padrão para exibição rápida
$script = Get-ColorScriptList -Name "aurora-*" -AsObject | Select-Object -First 1
if ($script) {
    Show-ColorScript -Name $script.Name -PassThru
}
```

Exibe rapidamente o primeiro script correspondente com base em um padrão curinga.

### EXAMPLE 15

```powershell
# Verifique se todos os scripts referenciados existem antes de executar a automação
$requiredScripts = @("bars", "arch", "mandelbrot-zoom")
$available = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$missing = $requiredScripts | Where-Object { $_ -notin $available }
if ($missing) {
    Write-Warning "Scripts ausentes: $($missing -join ', ')"
} else {
    Write-Host "Todos os scripts necessários estão disponíveis"
}
```

Valida se todos os scripts necessários existem antes da execução da automação.

## PARAMETERS

### -AsObject

Retorna objetos de registro de metadados brutos em vez de renderizar uma tabela formatada para o host. Isso permite o processamento de pipeline e a manipulação programática dos metadados colorscript.

Quando essa opção é especificada, você pode usar cmdlets PowerShell padrão como `Where-Object`, `Select-Object`, `Sort-Object` e `ForEach-Object` para processar ainda mais os resultados.

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

Filtra a lista para incluir apenas scripts pertencentes a uma ou mais categorias especificadas. A correspondência Category não diferencia maiúsculas de minúsculas.

As categorias comuns incluem: Padrões, Geométrico, Abstrato, Natureza, Animado, Texto, Retro e muito mais. Você pode especificar várias categorias para ampliar sua pesquisa.

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

Inclui colunas adicionais (tags e descrição) ao renderizar a visualização de tabela formatada. Isso fornece informações mais abrangentes sobre cada script rapidamente.

Sem essa opção, apenas o nome e a categoria primária são exibidos na saída da tabela.

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

### -Name

Filtra a lista colorscript por um ou mais nomes de script. Suporta caracteres curinga (`*` e `?`) para correspondência de padrões flexível.

Se um padrão especificado não corresponder a nenhum script, um aviso será gerado para ajudar a identificar possíveis problemas. A correspondência Name não diferencia maiúsculas de minúsculas.

Você pode especificar nomes exatos ou usar padrões como `aurora-*` para corresponder a vários scripts relacionados.

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

Desativa o estilo ANSI em mensagens informativas e saída renderizada para ambientes de texto simples.

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

Suprime mensagens informativas enquanto preserva a saída de comandos e erros.

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

Filtra a lista para incluir apenas scripts que contenham uma ou mais tags de metadados especificadas. A correspondência de tags não diferencia maiúsculas de minúsculas.

Tags comuns incluem: Recomendado, Animado, Colorido, Mínimo, Retro, Complexo, Simples e muito mais. Tags ajuda a categorizar scripts por estilo visual, complexidade ou caso de uso.

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

Este cmdlet suporta os parâmetros comuns:
Para obter mais informações, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet não aceita entrada de pipeline.

## OUTPUTS

### System.Object

Retorna objetos de registro de metadados colorscript com as seguintes propriedades:

- **Name**: o identificador de script usado com `Show-ColorScript`
- **Path**: O caminho de origem completo
- **Category**: a categoria principal do script
- **Categories**: uma matriz de todas as categorias às quais o script pertence
- **Tags**: uma matriz de tags de metadados que descrevem o script
- **Description**: uma descrição legível da saída visual do script
- **Metadata**: o objeto de metadados original que contém todas as informações brutas do script

Sem `-AsObject`, o cmdlet grava uma tabela formatada no host enquanto ainda retorna os objetos de registro para possível processamento de pipeline.

## NOTES

**Autor**: Nick
**Module**: ColorScripts-Enhanced

Os registros de metadados retornados fornecem informações abrangentes para fins de exibição e automação. A propriedade `Name` pode ser usada diretamente com o cmdlet `Show-ColorScript` para executar scripts específicos.

Todas as operações de filtragem (Name, Category, Tag) não diferenciam maiúsculas de minúsculas e podem ser combinadas para criar consultas poderosas. Ao usar curingas no parâmetro `-Name`, padrões incomparáveis ​​geram avisos para ajudar na solução de problemas.

Para obter melhores resultados ao integrar colorscripts ao seu perfil PowerShell, use o filtro `-Tag Recommended` para identificar scripts selecionados adequados para exibição de inicialização.

### Melhores práticas

- Sempre use `-AsObject` quando precisar filtrar ou manipular resultados programaticamente
- Use `-Detailed` ao explorar interativamente para ver tags e descrições
- Combine vários filtros para consultas precisas
- Exporte metadados periodicamente para rastrear alterações ao longo do tempo
- Use objetos de resultado para automação em vez de analisar a saída de texto
- Considere o desempenho ao executar consultas repetidamente (armazenar os resultados em cache, se possível)
- Aproveite Group-Object para análise e relatórios
- Use Where-Object para lógica de filtragem complexa

## RELATED LINKS

- [Versão online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)

