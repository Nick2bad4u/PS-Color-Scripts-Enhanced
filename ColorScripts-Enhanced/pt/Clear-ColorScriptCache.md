---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Clear-ColorScriptCache
---

# Clear-ColorScriptCache

## SYNOPSIS

Remova os arquivos de saída colorscript armazenados em cache.

## SYNTAX

### Selection (Default)

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

### Help

```
Clear-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-All] [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

## ALIASES

Este comando não tem aliases.

## DESCRIPTION

O cmdlet `Clear-ColorScriptCache` remove arquivos de saída armazenados em cache gerados pelo módulo ColorScripts-Enhanced. Cada entrada consiste em uma carga útil `<name>.cache` renderizada e um arquivo secundário de validação `<name>.cacheinfo` no diretório de cache efetivo.

Você pode excluir entradas de cache seletivamente usando o parâmetro `-Name` com padrões curinga ou remover todas as entradas de uma vez com o parâmetro `-All`. `-All` também remove sidecars órfãos cuja carga foi excluída. O cmdlet oferece suporte à filtragem por `-Category` e `-Tag` para direcionar subconjuntos específicos de scripts armazenados em cache.

Nomes de script incomparáveis relatam um status `Missing` nos resultados. Use `-DryRun` para visualizar ações de remoção sem modificar o sistema de arquivos e `-Path` para direcionar um diretório de cache alternativo (útil para configurações de cache personalizadas ou ambientes CI/CD).

As entradas de cache elegíveis são regeneradas quando o renderizador selecionado pela política correspondente é mostrado ou `New-ColorScriptCache` é invocado. Scripts determinísticos agrupados são renderizados em processo e não criam entradas de cache.

Para cenários de automação, combine `-PassThru` para capturar resultados estruturados, `-Quiet` para suprimir a mensagem de resumo ou `-NoAnsiOutput` para emitir resumos de texto simples sem códigos de cores ANSI.

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

Remove todos os arquivos de cache do diretório de cache padrão sem solicitar confirmação. Isso é útil para atualizar completamente o cache após atualizações do módulo ou ao solucionar problemas de exibição.

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

Visualiza quais arquivos de cache com tema aurora seriam removidos sem realmente excluí-los. A saída mostra os arquivos de cache que correspondem ao padrão, permitindo verificar a seleção antes de confirmar a exclusão.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name Galaxy -Path $env:TEMP -Confirm:$false
```

Limpa o arquivo de cache do renderizador 'Galaxy' qualificado de um diretório personalizado em TEMP. Isso é útil ao testar o `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` ou outro local de cache isolado.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Category Mathematical -WhatIf
```

Mostra o que aconteceria se os arquivos de cache dos scripts na categoria `Mathematical` fossem removidos. O parâmetro `-WhatIf` impede a exclusão.

### EXAMPLE 5

```powershell
Get-ColorScriptList -Tag retro | Clear-ColorScriptCache -DryRun
```

Usa entrada de pipeline para visualizar a remoção de arquivos de cache para todos os scripts marcados como 'retro'. Combina a filtragem por tag com uma visualização de teste antes de confirmar a exclusão.

### EXAMPLE 6

```powershell
Clear-ColorScriptCache -Name 'test-*', 'demo-*' -Confirm:$false
```

Remove arquivos de cache de todos os scripts cujos nomes começam com 'test-' ou 'demo-' sem confirmação. Vários padrões curinga podem ser especificados como uma matriz.

### EXAMPLE 7

```powershell
# Limpar arquivos de cache existentes e reconstruir entradas selecionadas pela política
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -PassThru | Measure-Object
Write-Host "Cache reconstruído com sucesso"
```

Limpa todos os conteúdos de cache, reconstrói as entradas selecionadas pela política de cache dinâmico e, em seguida, mostra estatísticas dessas entradas reconstruídas.

### EXAMPLE 8

```powershell
# Limpar entradas de cache antigas com mais de 30 dias
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$thirtyDaysAgo = (Get-Date).AddDays(-30)
Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $thirtyDaysAgo } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
Write-Host "Arquivos de cache antigos removidos"
```

Remove arquivos de cache que não foram atualizados há mais de 30 dias.

### EXAMPLE 9

```powershell
# Relatório de gerenciamento de cache
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$beforeCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Clear-ColorScriptCache -Category Geometric -Confirm:$false
$afterCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Write-Host "$($beforeCount - $afterCount) arquivos de cache geométricos removidos"
```

Mostra estatísticas sobre operações de limpeza de cache.

### EXAMPLE 10

```powershell
# Solução de problemas – limpar e reconstruir script específico
$scriptName = "Galaxy"
Clear-ColorScriptCache -Name $scriptName -Confirm:$false
New-ColorScriptCache -Name $scriptName -Force
Show-ColorScript -Name $scriptName
```

Limpa e reconstrói o cache de um único renderizador elegível pela política e depois o exibe para verificação.

### EXAMPLE 11

```powershell
# Filtrar por múltiplas categorias
Clear-ColorScriptCache -Category Geometric,Abstract -DryRun -PassThru |
    Select-Object CacheFile |
    Measure-Object
```

Mostra quantos arquivos de cache seriam excluídos se a filtragem fosse feita por diversas categorias.

## PARAMETERS

### -All

Selecione cada entrada de cache no diretório de destino. `-Category` e `-Tag` podem restringir ainda mais o conjunto de parâmetros de seleção total; `-Name` pertence ao conjunto de parâmetros de seleção.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

Filtre os scripts de destino por categoria antes de avaliar as entradas do cache. Somente arquivos de cache de scripts que correspondam às categorias especificadas serão considerados para remoção. Aceita uma variedade de nomes de categorias e pode ser combinado com `-Tag` para uma filtragem mais precisa.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Solicita confirmação antes de executar o cmdlet. Por padrão, isso está habilitado para evitar a exclusão acidental de arquivos de cache. Use `-Confirm:$false` para ignorar o prompt de confirmação.

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

### -DryRun

Visualize ações de remoção sem excluir nenhum arquivo. O cmdlet exibirá quais arquivos de cache seriam removidos, mas não modificará o sistema de arquivos. Isso é útil para verificar seus critérios de seleção antes de confirmar a exclusão.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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
- Name: Help
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

Nomes ou padrões curinga que identificam arquivos de cache a serem removidos. Aceita entrada de pipeline e associação de propriedades de objetos com uma propriedade `Name`. Caracteres curinga (`*`, `?`) são suportados para correspondência de padrões. Mutuamente exclusivo com `-All`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAnsiOutput

Desative as sequências de cores ANSI na saída de resumo. Isso é útil para consoles ou processadores de log que não interpretam o estilo ANSI, garantindo que o texto do resumo permaneça legível em texto simples.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- NoColor
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Retorna objetos de resultados detalhados para cada entrada de cache processada. Sem essa opção, o cmdlet grava apenas uma mensagem de resumo. Cada registro de passagem inclui o nome do script, o caminho do arquivo de cache, o status e qualquer texto de erro associado para inspeção ou relatório adicional.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Diretório de cache alternativo para operar. O padrão é o caminho de cache padrão do módulo, se não for especificado. Use este parâmetro ao trabalhar com locais de cache personalizados definidos por meio da variável de ambiente `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` ou ao gerenciar arquivos de cache em diretórios alternativos para fins de teste ou CI/CD.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Suprima a mensagem de resumo emitida após a conclusão da remoção do cache. Use esta opção ao executar em contextos de automação silenciosos, onde apenas saídas estruturadas (como registros `-PassThru`, avisos ou erros) devem ser produzidas.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Filtre os scripts de destino por tag de metadados antes de avaliar as entradas de cache. Somente arquivos de cache de scripts com tags correspondentes serão considerados para remoção. Aceita uma variedade de nomes de tags e pode ser combinado com `-Category` para um controle mais granular sobre quais arquivos de cache são direcionados.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Mostra o que aconteceria se o cmdlet fosse executado sem realmente executar a operação. O cmdlet exibe as ações que executaria, mas não modifica o sistema de arquivos. Este é um parâmetro comum padrão do PowerShell que funciona de forma semelhante ao `-DryRun`, mas segue as convenções integradas do PowerShell.

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

### System.String

Você pode canalizar nomes de script para esse cmdlet. Cada nome será avaliado para remoção do arquivo de cache com base nos parâmetros especificados.

### System.String[]

Você pode canalizar uma série de nomes de script para esse cmdlet. Isto é particularmente útil ao combinar com `Get-ColorScriptList` para filtrar scripts por vários critérios antes de limpar seus caches.

### System.Management.Automation.PSObject

Você pode canalizar objetos com uma propriedade `Name` para esse cmdlet. O cmdlet extrairá o valor da propriedade `Name` e o usará para identificar arquivos de cache para remoção.

## OUTPUTS

### System.Object

Com `-PassThru`, retorna um registro de status para cada arquivo de cache processado. Cada objeto de saída contém as seguintes propriedades:

- **Status**: O resultado da operação (`Removed`, `Missing`, `DryRun`, `SkippedByUser` ou `Error`)
- **CacheFile**: O caminho completo para o arquivo de cache que foi processado
- **Message**: Texto descritivo explicando o resultado da operação
- **Name**: O nome do script associado ao arquivo de cache

## NOTES

**Autor**: Nick
**Module**: ColorScripts-Enhanced

Os arquivos de cache são armazenados com uma extensão `.cache` no diretório de cache do módulo. Cada arquivo de cache corresponde a um único colorscript e contém a saída ANSI pré-renderizada.

As entradas de cache elegíveis são regeneradas quando o renderizador selecionado pela política correspondente é mostrado ou `New-ColorScriptCache` é invocado. Scripts determinísticos agrupados são renderizados em processo e não criam entradas de cache.

Consulte `(Get-ColorScriptConfiguration).Cache.EffectivePath` para obter o caminho efetivo padrão. Pode ser substituído pela configuração persistente ou `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`; `-Path` tem como destino um diretório diferente para uma chamada.

Ao usar `-DryRun` ou `-WhatIf`, o cmdlet ainda validará se o diretório de cache existe e relatará quaisquer problemas, mas não executará nenhuma exclusão.

A filtragem por `-Category` ou `-Tag` requer que os scripts tenham metadados associados. Scripts sem metadados não corresponderão a esses filtros.

### Melhores práticas

- Sempre use `-DryRun` ou `-WhatIf` antes de operações destrutivas
- Use `-Confirm:$false` somente quando tiver certeza sobre a operação
- Arquivar cache antes de grandes operações de limpeza para recuperação
- Monitore o espaço em disco regularmente para verificar o crescimento do cache
- Use limpeza seletiva em vez de limpeza completa quando possível
- Acompanhe scripts críticos que não devem ser apagados
- Agende limpezas automatizadas durante as janelas de manutenção
- Teste primeiro as operações de limpeza em não produção

### Solução de problemas (2)

- **"Nenhum arquivo de cache encontrado"**: Inspecione `(Get-ColorScriptConfiguration).Cache.EffectivePath` e use `Export-ColorScriptMetadata -IncludeCacheInfo` para verificar o estado do cache
- **"Permissão negada"**: Verifique o acesso de gravação ao diretório de cache
- **"Cache não regenerando"**: Scripts podem ter problemas de renderização; teste com `-NoCache`

## RELATED LINKS

- [Versão online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache)

