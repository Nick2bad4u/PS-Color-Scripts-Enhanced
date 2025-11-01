---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/pt/Clear-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Clear-ColorScriptCache

## SYNOPSIS

Limpa arquivos de saída em cache dos colorscripts.

## SYNTAX

```
Clear-ColorScriptCache [[-Name] <string[]>] [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Remove arquivos de saída em cache para colorscripts para forçar a execução fresca na próxima exibição. Este cmdlet fornece gerenciamento de cache direcionado para scripts individuais ou operações em massa.

O sistema de cache armazena saída ANSI renderizada para fornecer desempenho de exibição quase instantâneo. Com o tempo, os arquivos em cache podem se tornar desatualizados se os scripts de origem forem modificados, ou você pode querer limpar o cache para fins de solução de problemas.

Use este cmdlet quando:
- Scripts de origem colorscripts foram modificados
- Corrupção de cache é suspeitada
- Você deseja garantir execução fresca
- Liberar espaço em disco é desejado

O cmdlet suporta tanto limpeza direcionada (scripts específicos) quanto operações em massa (todos os arquivos em cache).

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -Name "spectrum"
```

Limpa o cache para o colorscript específico chamado "spectrum".

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -All
```

Limpa todos os arquivos em cache dos colorscripts.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name "aurora*", "geometric*"
```

Limpa o cache para colorscripts correspondendo aos padrões de curinga especificados.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Name aurora-waves -WhatIf
```

Mostra quais arquivos de cache seriam limpos sem realmente removê-los.

### EXAMPLE 5

```powershell
# Limpar cache para todos os scripts em uma categoria
Get-ColorScriptList -Category Nature -AsObject | ForEach-Object {
    Clear-ColorScriptCache -Name $_.Name
}
```

Limpa o cache para todos os colorscripts temáticos da natureza.

## PARAMETERS

### -All

Limpa todos os arquivos em cache dos colorscripts. Não pode ser usado com o parâmetro -Name.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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
```

### -Name

Especifica os nomes dos colorscripts para limpar do cache. Suporta curingas (* e ?) para correspondência de padrões.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Name
  Position: 0
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
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Para mais informações, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet não aceita entrada do pipeline.

## OUTPUTS

### None

Este cmdlet não retorna saída para o pipeline.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 ou posterior

**Localização do Cache:**
Os arquivos de cache são armazenados em um diretório gerenciado pelo módulo. Use `(Get-Module ColorScripts-Enhanced).ModuleBase` para localizar o diretório do módulo, então procure o subdiretório de cache.

**Quando Limpar o Cache:**
- Após modificar arquivos de script de origem colorscript
- Ao solucionar problemas de exibição
- Para garantir execução fresca dos scripts
- Antes de benchmarking de desempenho

**Impacto no Desempenho:**
Limpar o cache fará com que os scripts sejam executados normalmente na próxima exibição, o que pode levar mais tempo do que a execução em cache. O cache será reconstruído automaticamente em exibições subsequentes.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
