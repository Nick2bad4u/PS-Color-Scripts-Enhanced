---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Export-ColorScriptMetadata
---

# Export-ColorScriptMetadata

## SYNOPSIS

Exporta metadados abrangentes de todos os colorscripts para o formato JSON ou emite objetos estruturados para o pipeline.

## SYNTAX

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-h] [-IncludeFileInfo] [-IncludeCacheInfo]
 [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Este comando não tem aliases.

## DESCRIPTION

O cmdlet `Export-ColorScriptMetadata` compila um inventário abrangente de todos os colorscripts no catálogo do módulo e gera um conjunto de dados estruturado que descreve cada entrada. Esses metadados incluem informações essenciais, como nomes de scripts, categorias, tags e enriquecimentos opcionais.

Por padrão, o cmdlet retorna objetos PowerShell ao pipeline. Quando o parâmetro `-Path` é fornecido, ele grava os metadados como JSON formatados no arquivo especificado, criando automaticamente diretórios pais se eles não existirem.

O cmdlet oferece dois sinalizadores de enriquecimento opcionais:

- **IncludeFileInfo**: Adiciona metadados do sistema de arquivos, incluindo caminhos completos, tamanhos de arquivo (em bytes) e carimbos de data/hora da última modificação
- **IncludeCacheInfo**: acrescenta informações relacionadas ao cache, incluindo caminhos de arquivos de cache, status de existência e carimbos de data/hora do cache

Este cmdlet é particularmente útil para:

- Criação de documentação ou dashboards mostrando todos os colorscripts disponíveis
- Relatório de presença e carimbos de data/hora de arquivo de carga útil de cache bruto
- Alimentação de metadados para ferramentas externas ou pipelines de automação
- Auditoria do inventário colorscript e status do sistema de arquivos
- Geração de relatórios sobre uso e organização do colorscript

A saída é ordenada de forma consistente, tornando-a adequada para controle de versão e operações de comparação quando exportada para JSON.

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

Exporta metadados básicos de todos os colorscripts para o pipeline sem informações de arquivo ou cache.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

Retorna objetos que incluem detalhes do sistema de arquivos (caminho completo, tamanho e hora da última gravação) para cada colorscript.

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

Gera um arquivo JSON contendo metadados básicos e grava-os no diretório `dist`, criando a pasta caso ela não exista.

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

Gera um arquivo JSON abrangente com metadados enriquecidos, incluindo sistema de arquivos e informações de cache, gravando-o no diretório `dist`.

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeCacheInfo -PassThru | Where-Object { -not $_.CacheExists }
```

Grava o arquivo de metadados e retorna registros cuja carga bruta `.cache` está ausente. Isso relata apenas a ocupação do arquivo, não a elegibilidade, validade ou atualidade do cache.

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

Agrupa colorscripts por categoria e exibe contagens, úteis para analisar a distribuição de scripts entre categorias.

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property ScriptSizeBytes -Sum).Sum
Write-Host "Tamanho total de todos os colorscripts: $($totalSize / 1KB) KB"
```

Calcula o espaço total em disco usado por todos os arquivos colorscript.

### EXAMPLE 8

```powershell
# Gerar estatísticas e salvar relatório
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachePayloadFiles = ($metadata | Where-Object CacheExists).Count
    TotalScriptSizeBytes = ($metadata | Measure-Object ScriptSizeBytes -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

Gera estatísticas de inventário e conta arquivos de carga `.cache` brutos. A presença da carga útil não é uma verificação de elegibilidade, validade ou atualidade do cache.

### EXAMPLE 9

```powershell
# Exporte e compare com backup anterior
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "Novos scripts: $($new.Count) | Scripts removidos: $($removed.Count)"
```

Compara os metadados atuais com uma versão anterior para identificar alterações.

### EXAMPLE 10

```powershell
# Crie uma resposta de API para painel da web
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

Gera JSON pronto para API com informações de controle de versão e carimbo de data/hora.

### EXAMPLE 11

```powershell
# Crie ou valide cada entrada de cache selecionada por política e revise os status.
$results = New-ColorScriptCache -All -PassThru
$results | Group-Object Status | Select-Object Name, Count
```

Usa a política de cache como fonte de verdade e relata se as entradas elegíveis foram atualizadas, já atuais, ignoradas ou falharam.

### EXAMPLE 12

```powershell
# Crie uma galeria HTML a partir de metadados
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$html = @"
<html>
<head><title>ColorScripts-Enhanced Gallery</title></head>
<body>
<h1>ColorScripts-Enhanced</h1>
<ul>
"@
foreach ($script in $metadata) {
    $html += "<li><strong>$($script.Name)</strong> [$($script.Category)]</li>`n"
}
$html += "</ul></body></html>"
$html | Out-File "./gallery.html" -Encoding UTF8
```

Cria uma página de galeria HTML listando todos os colorscripts disponíveis.

### EXAMPLE 13

```powershell
# Monitore os tamanhos dos scripts ao longo do tempo
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object ScriptSizeBytes -Average).Average) bytes avg" }
```

Rastreia alterações no tamanho do arquivo para scripts individuais em múltiplas exportações.

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
DefaultValue: False
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

### -IncludeCacheInfo

Adiciona o caminho de carga `.cache` bruto, o sinalizador de presença de arquivo e o carimbo de data/hora da última gravação a cada registro. Esses campos não relatam elegibilidade para política de cache, presença, validade ou atualidade do sidecar `.cacheinfo`.

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
HelpMessage: ''
```

### -IncludeFileInfo

Inclui detalhes do sistema de arquivos (caminho completo, tamanho em bytes e hora da última gravação) em cada registro. Quando os metadados do arquivo não podem ser lidos (devido a permissões ou arquivos ausentes), os erros são registrados por meio de saída detalhada e as propriedades afetadas são definidas como valores nulos. Essa opção é valiosa para auditar tamanhos de arquivos e datas de modificação.

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
HelpMessage: ''
```

### -PassThru

Retorna os objetos de metadados para o pipeline mesmo quando o parâmetro `-Path` é especificado. Isso permite salvar os metadados em um arquivo e executar processamento ou filtragem adicional nos objetos em um único comando. Sem essa opção, a especificação de `-Path` suprime a saída do pipeline.

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
HelpMessage: ''
```

### -Path

Especifica o caminho do arquivo de destino para a exportação JSON. Suporta caminhos relativos, caminhos absolutos, variáveis ​​de ambiente (por exemplo, `$env:TEMP\metadata.json`) e expansão de til (por exemplo, `~/Documents/metadata.json`). Os diretórios pais são criados automaticamente se não existirem. Quando este parâmetro é omitido, o cmdlet envia objetos diretamente para o pipeline em vez de gravar em um arquivo. A saída JSON é formatada com recuo para facilitar a leitura.

```yaml
Type: System.String
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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Para obter mais informações, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet não aceita entrada de pipeline.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Quando `-Path` não é especificado ou quando `-PassThru` é usado, o cmdlet retorna objetos personalizados. Cada objeto representa um único colorscript com as seguintes propriedades básicas:

- **Name**: nome do arquivo do colorscript sem extensão
- **Category**: a principal categoria organizacional
- **Categories**: todas as categorias atribuídas
- **Tags**: uma matriz de tags descritivas para filtragem e pesquisa
- **Description**: a descrição dos metadados

Quando `-IncludeFileInfo` é especificado, estas propriedades adicionais são incluídas:

- **ScriptPath**: o caminho completo do sistema de arquivos para o arquivo de script
- **ScriptSizeBytes**: Tamanho em bytes (nulo se o arquivo estiver inacessível)
- **ScriptLastWriteTimeUtc**: carimbo de data/hora UTC da última modificação (nulo se indisponível)

Quando `-IncludeCacheInfo` é especificado, estas propriedades adicionais são incluídas:

- **CachePath**: O caminho completo para o arquivo de cache correspondente
- **CacheExists**: Booleano que indica se existe um arquivo de cache
- **CacheLastWriteTimeUtc**: carimbo de data/hora UTC da modificação do arquivo de cache (nulo se o cache não existir)

## NOTES

## RELATED LINKS

- [Versão online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)

