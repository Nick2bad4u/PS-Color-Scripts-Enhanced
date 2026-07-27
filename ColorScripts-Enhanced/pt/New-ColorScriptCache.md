---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

Pré-construa ou atualize os arquivos de cache colorscript para uma renderização mais rápida.

## SYNTAX

### Selection (Default)

```
New-ColorScriptCache [-Name <string[]>] [-Force] [-PassThru] [-Category <string[]>]
 [-Tag <string[]>] [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon]
 [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Category <string[]>] [-Tag <string[]>]
 [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon] [-WhatIf] [-Confirm]
```

## ALIASES

- `Build-ColorScriptCache`
- `Update-ColorScriptCache`

## DESCRIPTION

`New-ColorScriptCache` renderiza colorscripts computacional selecionado por política e salva sua saída como UTF-8 sem BOM. Os renderizadores agrupados elegíveis usam o caminho de execução isolado do módulo; trabalhadores paralelos estão disponíveis no PowerShell 7+. Scripts determinísticos agrupados são renderizados em processo e nunca criam arquivos de cache. Os aliases são `Update-ColorScriptCache` e `Build-ColorScriptCache`.

Você pode direcionar scripts por nome (com suporte para curingas), categoria ou tag. Quando nenhum parâmetro é especificado, o cmdlet resolve os nomes em `CachePolicy.psd1` diretamente em vez de enumerar a coleção completa. Os nomes exatos do pacote também usam uma pesquisa direta de arquivo. Solicitações de curinga, categoria e tag são enumeradas somente quando sua semântica correspondente exige isso. Os scripts explícitos não listados são retornados com o status `SkippedNotRequired` quando `-PassThru` é usado e todos os arquivos de cache obsoletos desses scripts são removidos.

Por padrão, o cmdlet exibe o progresso, além de um resumo conciso da operação de cache e do diretório de cache efetivo. Use `-PassThru` para retornar objetos de resultados detalhados para cada script, que você pode inspecionar programaticamente quanto a status, saída padrão e fluxos de erros. Combine `-Quiet` para suprimir totalmente o progresso e o resumo ou `-NoAnsiOutput` para emitir resumos em texto simples sem códigos de cores ANSI para ambientes que não os suportam.

O cmdlet ignora de forma inteligente os scripts cujos arquivos de cache já estão atualizados, a menos que você especifique o parâmetro `-Force`. Construções repetidas validam o pequeno sidecar `<name>.cacheinfo` sem carregar a carga útil `<name>.cache` renderizada. `-Force` reconstrói entradas de cache qualificadas, mas nunca substitui a política de cache.

Ambos os arquivos residem em `(Get-ColorScriptConfiguration).Cache.EffectivePath`. O arquivo `.cache` contém saída de terminal renderizada; `.cacheinfo` contém apenas metadados de validação. Um sidecar sem sua carga útil não é uma entrada de cache utilizável e será reparado na próxima compilação. `Clear-ColorScriptCache -All` remove entradas completas e sidecars órfãos.

Para reconstruções mais rápidas em sistemas multi-core, use o switch `-Parallel` junto com o parâmetro `-ThrottleLimit` (ou `-Threads`) para controlar a contagem de trabalhadores. O cmdlet reverte automaticamente para a execução sequencial quando não é possível criar runspaces paralelos no host atual.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Resolva e aqueça apenas os renderizadores computacionais selecionados por política, sem enumerar todos os scripts fornecidos com o módulo. Este é o comportamento padrão quando nenhum parâmetro é especificado.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name Galaxy, 'rose-*'
```

Armazene em cache uma combinação de correspondências exatas e curinga. Somente as correspondências incluídas em `CachePolicy.psd1` são construídas; outras correspondências relatam `SkippedNotRequired` com `-PassThru`.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name Galaxy -Force -PassThru | Format-List
```

Force uma reconstrução do cache 'Galaxy' elegível, mesmo que esteja atualizado, e examine o objeto de resultado detalhado.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Mathematical' -PassThru
```

Avalie scripts na categoria `Mathematical`, armazene em cache renderizadores qualificados e retorne resultados detalhados para cada correspondência.

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

Reconstrua caches elegíveis para scripts marcados com 'geometric' ou 'colorful', forçando a regeneração mesmo que os caches sejam atuais.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Mathematical -AsObject | New-ColorScriptCache -PassThru
```

Exemplo de pipeline: avalie scripts na categoria `Mathematical`, armazene em cache quaisquer renderizadores selecionados por política e retorne um resultado para cada correspondência.

### EXAMPLE 7

```powershell
# Verifique as estatísticas do cache após a construção
$cachePath = (Get-ColorScriptConfiguration).Cache.EffectivePath
$before = @(Get-ChildItem $cachePath -Filter "*.cache" -ErrorAction SilentlyContinue).Count
New-ColorScriptCache
$after = @(Get-ChildItem $cachePath -Filter "*.cache").Count
Write-Host "Scripts em cache: $before -> $after"
```

Mede o crescimento do cache contando os arquivos de cache selecionados por política antes e depois da operação.

### EXAMPLE 8

```powershell
# Crie cache para renderizadores computacionais usados com frequência
$frequentScripts = @('Galaxy', 'rose-curves', 'wave-interference')
New-ColorScriptCache -Name $frequentScripts -PassThru | Format-Table Name, Status, ExitCode
```

Constrói caches para os scripts listados que são elegíveis em `CachePolicy.psd1`; nomes não listados são ignorados.

### EXAMPLE 9

```powershell
# Use a exibição de progresso integrada no escopo da política
New-ColorScriptCache -All
```

Mostra o progresso integrado para renderizadores selecionados por política sem iterar manualmente todos os scripts disponíveis.

### EXAMPLE 10

```powershell
# Opcionalmente, selecione entradas de política ausentes ou obsoletas de um perfil PowerShell.
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Quiet
```

Verifica as entradas selecionadas pela política quando o perfil é carregado e cria apenas entradas ausentes ou obsoletas. Omita esta etapa do perfil quando o trabalho do cache de inicialização não for desejado.

### EXAMPLE 11

```powershell
# Reconstrua todas as entradas selecionadas por política para implantação
New-ColorScriptCache -All -Force -PassThru |
    Select-Object Name, Status |
    Export-Csv "./cache-deployment.csv"
```

Reconstrói cada entrada de cache selecionada por política e exporta os status para um manifesto de implantação.

### EXAMPLE 12

```powershell
# Encontre falhas de compilação de cache
New-ColorScriptCache -Name "Galaxy" -Force -PassThru |
    Where-Object Status -eq 'Failed' |
    Select-Object Name, StdErr
```

Identifica falhas de cache sem tratar as omissões de políticas como erros.

### EXAMPLE 13

```powershell
# Contar entradas selecionadas por política atualizadas por esta execução
New-ColorScriptCache -All -PassThru |
    Where-Object Status -eq 'Updated' |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

Verifica todas as entradas selecionadas pela política e mostra quantas cargas de cache foram atualizadas por esta execução.

### EXAMPLE 14

```powershell
New-ColorScriptCache -All -Parallel -Threads 8
```

Crie todos os caches selecionados por política usando oito threads de trabalho. O cmdlet volta automaticamente para a execução sequencial quando os trabalhos paralelos não estão disponíveis no host atual.

## PARAMETERS

### -All

Resolva todas as entradas da política de cache diretamente. Somente scripts selecionados por política são processados; o inventário colorscript completo não é enumerado.

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

Filtra scripts avaliados por categoria de metadados (sem distinção entre maiúsculas e minúsculas). Vários valores são tratados como um filtro OR. Somente as correspondências permitidas por `CachePolicy.psd1` são armazenadas em cache; outras correspondências relatam `SkippedNotRequired` com `-PassThru`.

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

Solicita confirmação antes de executar o cmdlet. Útil ao armazenar em cache um grande número de scripts ou ao usar `-Force` para evitar a regeneração acidental do cache.

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

### -Force

Reconstrua entradas de cache qualificadas mesmo quando seus metadados de validação `.cacheinfo` indicarem que são atuais. Isso não substitui `CachePolicy.psd1`.

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

### -IncludePokemon

Parâmetro de compatibilidade obsoleto. É aceito silenciosamente sem efeito por uma versão porque os scripts Pokémon seguem as mesmas regras de `CachePolicy.psd1` que todos os outros scripts.

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

### -Name

Um ou mais nomes colorscript a serem avaliados para armazenamento em cache. Suporta padrões curinga (por exemplo, `aurora-*` e `*-wave`). Os scripts correspondentes são armazenados em cache somente quando listados em `CachePolicy.psd1`. Quando este parâmetro e todos os filtros são omitidos, apenas as entradas de política são resolvidas e avaliadas.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
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

Desative as sequências de cores ANSI na saída informativa. Isso é útil em ambientes que não renderizam códigos de escape ANSI (como alguns logs CI/CD) e ainda preservam a saída colorida quando desejado.

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

### -Parallel

Habilite a construção de cache multithread. Quando especificado, o cmdlet executa trabalhos de cache em um pool de runspace para uma conclusão mais rápida em sistemas compatíveis. Use em combinação com `-ThrottleLimit` (ou o alias `-Threads`) para controlar o número de trabalhadores simultâneos. Se o multithreading não puder ser inicializado, o cmdlet retornará automaticamente à execução sequencial.

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

### -PassThru

Retorne objetos de resultados detalhados para cada operação de cache. Por padrão, apenas um resumo é exibido. Os objetos de resultado incluem propriedades como Name, Status, CacheFile, ExitCode, StdOut e StdErr, permitindo a inspeção programática do processo de armazenamento em cache.

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

### -Quiet

Suprima o progresso por script e a saída de resumo informativo. Use esta opção quando desejar apenas saída estruturada (via `-PassThru`) ou quando os cenários de automação devem silenciar mensagens informativas enquanto ainda exibem avisos e erros.

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

Filtra scripts avaliados por tag de metadados (sem distinção entre maiúsculas e minúsculas). Vários valores são tratados como um filtro OR. Somente as correspondências permitidas por `CachePolicy.psd1` são armazenadas em cache; outras correspondências relatam `SkippedNotRequired` com `-PassThru`.

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

### -ThrottleLimit

Especifica o número máximo de trabalhos de cache simultâneos quando `-Parallel` é solicitado. Aceita valores de 1 a 256. O padrão (quando omitido) é o número de processadores lógicos na máquina atual. O alias `-Threads` é fornecido por conveniência. Valores menores ou iguais a um revertem automaticamente para execução sequencial.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Threads
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

Mostra o que aconteceria se o cmdlet fosse executado sem realmente realizar as operações de cache. Útil para visualizar quais scripts seriam armazenados em cache antes de confirmar a operação.

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

Você pode canalizar nomes de script para esse cmdlet. Cada string é tratado como um nome de script potencial e oferece suporte à correspondência de caracteres curinga.

### System.String[]

Você pode canalizar uma matriz de nomes de script ou registros de metadados com uma propriedade `Name` para esse cmdlet para processamento em lote.

## OUTPUTS

### System.Object

Quando `-PassThru` é especificado, retorna um objeto customizado para cada script processado contendo as seguintes propriedades:

- **Name**: O nome colorscript
- **ScriptPath**: Caminho completo para a origem colorscript
- **CacheFile**: Caminho completo para o arquivo de cache gerado
- **Status**: `Updated`, `SkippedUpToDate`, `SkippedNotRequired`, `SkippedByUser` ou `Failed`
- **Message**: detalhe de status localizado
- **CacheExists**: se existe um cache de saída após a operação
- **ExitCode**: O código de saída da execução do script (0 indica sucesso)
- **StdOut**: Saída padrão capturada durante a execução do script
- **StdErr**: saída de erro padrão capturada durante a execução do script

Sem `-PassThru`, grava um resumo informativo conciso contendo contagens processadas, atualizadas, ignoradas e com falha, além do diretório de cache efetivo.

## NOTES

**Autor:** Nick
**Módulo:** ColorScripts-Enhanced

**Aliases:** `Update-ColorScriptCache` e `Build-ColorScriptCache`.

Os arquivos de cache são armazenados em `(Get-ColorScriptConfiguration).Cache.EffectivePath`. As assinaturas de origem e de política nos metadados complementares são usadas para determinar se uma entrada permanece atual.

O cmdlet armazena em cache apenas renderizadores que exigem execução e são permitidos pela política de cache. Scripts explícitos estáticos ou não listados são relatados como `SkippedNotRequired` e entradas obsoletas são removidas.

## RELATED LINKS

- [Versão online](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)

