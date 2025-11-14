---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/pt/New-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 11/14/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScriptCache

## SYNOPSIS

Pré-constrói cache para otimização de desempenho do colorscript.

## SYNTAX

### Todos

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Selecionados

```
New-ColorScriptCache [-Name <String[]>] [-Category <String[]>] [-Tag <String[]>] [-Force] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Pré-gera saída em cache para colorscripts para garantir desempenho ideal na primeira exibição. Este cmdlet executa colorscripts antecipadamente e armazena sua saída renderizada para recuperação instantânea.

O sistema de cache fornece melhorias de desempenho de 6-19x. Na primeira execução, um colorscript é executado normalmente e sua saída é armazenada em cache. Exibições subsequentes usam a saída em cache para renderização quase instantânea. O cache é invalidado automaticamente quando os scripts de origem são modificados, garantindo precisão da saída.


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

Pré-constrói cache para todos os colorscripts disponíveis.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name "spectrum", "aurora-waves"
```

Armazena em cache colorscripts específicos por nome.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Category Nature
```

Pré-constrói cache para todos os colorscripts temáticos da natureza.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Tag animated
```

Armazena em cache todos os colorscripts marcados como "animados".

### EXAMPLE 5

```powershell
# Cache scripts for startup optimization
New-ColorScriptCache -Category Geometric -Tag minimal
```

Prepara cache para scripts geométricos leves ideais para exibições de inicialização rápida.

## PARAMETERS

### -Category

Filtrar scripts para cache por uma ou mais categorias.

```yaml
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
```

### -Confirm

Solicita confirmação antes de executar o cmdlet.

```yaml
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

### -Force

Força a reconstrução da cache mesmo quando os arquivos existentes já estão atualizados.

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

### -PassThru

Retorna objetos detalhados para cada script processado. Sem este parâmetro somente o resumo é exibido.

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
```

### -Name

Especificar nomes de colorscript para cache. Suporta curingas (\* e ?).

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
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
```

### -Tag

Filtrar scripts para cache por uma ou mais tags.

```yaml
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
```

### -WhatIf

Mostra o que aconteceria se o cmdlet fosse executado. O cmdlet não é executado.

```yaml
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
```

### CommonParameters

Este cmdlet suporta os parâmetros comuns: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction e -WarningVariable. Para mais informações, consulte
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

**Performance Impact:**
Pré-cache elimina o tempo de execução na primeira exibição, fornecendo feedback visual instantâneo. Particularmente benéfico para scripts complexos ou animados.

**Cache Management:**
Arquivos em cache são armazenados em diretórios gerenciados pelo módulo e automaticamente invalidados quando os scripts de origem mudam. Use Clear-ColorScriptCache para remover cache desatualizado.

**Best Practices:**

- Armazenar em cache scripts frequentemente usados para desempenho ideal
- Usar cache seletivo para evitar processamento desnecessário
- Executar após atualizações do módulo para garantir validade do cache

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
