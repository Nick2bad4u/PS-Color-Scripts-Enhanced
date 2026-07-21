---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

Pré-constrói cache para otimização de desempenho do colorscript.

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

Pré-gera saída em cache para colorscripts computacionalmente caros. Apenas os renderizadores listados em `CachePolicy.psd1` são executados e armazenados. Scripts estáticos ou não listados são ignorados com o estado `SkippedNotRequired`, e seus caches obsoletos são removidos.

O sistema de cache armazena saída apenas para os renderizadores selecionados em `CachePolicy.psd1`. O cache é invalidado automaticamente quando os scripts de origem são modificados. `-Force` reconstrói apenas entradas elegíveis e nunca substitui a política. Nenhum fator fixo de desempenho é garantido.


### -Quiet

Oculta a mensagem de resumo após a execução.

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
HelpMessage: ""
```

### -NoAnsiOutput

Desativa sequências ANSI no resumo, emitindo texto simples (útil para logs sem suporte a cores).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
 - NoColor
ParameterSets:
 - Name: (All)
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -IncludePokemon

Inclui todos os scripts de Pokémon (normais e shiny) na construção do cache. Por padrão, os scripts de Pokémon são ignorados; use `-IncludePokemon` para incluí-los. Observação: este parâmetro substitui o antigo `-ExcludePokemon` — a lógica foi invertida durante o refactor (agora opt-in).

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
HelpMessage: ""
```

Use este cmdlet para:

- Preparar cache para scripts frequentemente usados
- Garantir desempenho consistente entre sessões
- Pré-aquecer cache após atualizações do módulo
- Otimizar desempenho de inicialização

O cmdlet suporta cache seletivo por nome, categoria ou tags, permitindo preparação de cache direcionada.

Por padrão, um resumo compacto é exibido. Use `-PassThru` para retornar objetos detalhados, `-Quiet` para ocultar o resumo ou `-NoAnsiOutput` para gerar texto sem sequências ANSI.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Avalia todos os colorscripts disponíveis e pré-constrói cache apenas para os renderizadores selecionados por `CachePolicy.psd1`.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name "Galaxy", "rose-curves"
```

Armazena em cache colorscripts específicos por nome.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Category Nature
```

Avalia todos os colorscripts com tema de natureza e armazena em cache apenas os renderizadores elegíveis.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Tag animated
```

Avalia todos os colorscripts marcados como "animados" e armazena em cache apenas os renderizadores elegíveis.

### EXAMPLE 5

```powershell
# Cache scripts for startup optimization
New-ColorScriptCache -Category Geometric -Tag minimal
```

Prepara cache para scripts geométricos leves ideais para exibições de inicialização rápida.

## PARAMETERS

### -All

Processes every renderer selected by CachePolicy.psd1 without enumerating the full static script inventory.

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

Filtrar scripts para cache por uma ou mais categorias.

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

### -Force

Força a reconstrução das entradas de cache elegíveis mesmo quando já estão atualizadas, sem ignorar `CachePolicy.psd1`.

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

Exibe a ajuda detalhada deste comando sem executar a operação.

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

Inclui todos os scripts de Pokémon (normais e shiny) na construção do cache. Por padrão, os scripts de Pokémon são ignorados; use `-IncludePokemon` para incluí-los. Observação: este parâmetro substitui o antigo `-ExcludePokemon` — a lógica foi invertida durante o refactor (agora opt-in).

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

Especificar nomes de colorscript para cache. Suporta curingas (\* e ?).

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

Desativa sequências ANSI no resumo, emitindo texto simples (útil para logs sem suporte a cores).

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

Builds eligible cache entries concurrently. Unsupported hosts fall back to sequential execution.

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

Retorna objetos detalhados para cada script processado. Sem este parâmetro somente o resumo é exibido.

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

Oculta a mensagem de resumo após a execução.

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

Filtrar scripts para cache por uma ou mais tags.

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

Sets the maximum number of concurrent cache workers. Threads is an alias for this parameter.

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

Mostra o que aconteceria se o cmdlet fosse executado. O cmdlet não é executado.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet não aceita entrada do pipeline.

## OUTPUTS

### System.Object

Retorna resultados de construção de cache com status de sucesso/falha para cada script.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
