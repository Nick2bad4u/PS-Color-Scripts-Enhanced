---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ru/Clear-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Clear-ColorScriptCache

## SYNOPSIS

Очищает кэшированные файлы вывода цветов скриптов.

## SYNTAX

```
Clear-ColorScriptCache [[-Name] <string[]>] [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Удаляет кэшированные файлы вывода для цветов скриптов, чтобы принудительно выполнить свежий запуск при следующем отображении. Этот командлет предоставляет целевое управление кэшем для отдельных скриптов или массовых операций.

Система кэша хранит отрендеренный вывод ANSI для обеспечения почти мгновенной производительности отображения. Со временем кэшированные файлы могут устареть, если исходные скрипты были изменены, или вы можете захотеть очистить кэш для целей устранения неисправностей.

Используйте этот командлет, когда:
- Исходные цветов скрипты были изменены
- Подозревается повреждение кэша
- Вы хотите обеспечить свежий запуск
- Желаемо освобождение дискового пространства

Командлет поддерживает как целевую очистку (конкретные скрипты), так и массовые операции (все кэшированные файлы).

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -Name "spectrum"
```

Очищает кэш для конкретного цветов скрипта с именем "spectrum".

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -All
```

Очищает все кэшированные файлы цветов скриптов.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name "aurora*", "geometric*"
```

Очищает кэш для цветов скриптов, соответствующих указанным шаблонам подстановки.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Name aurora-waves -WhatIf
```

Показывает, какие файлы кэша будут очищены, без их фактического удаления.

### EXAMPLE 5

```powershell
# Clear cache for all scripts in a category
Get-ColorScriptList -Category Nature -AsObject | ForEach-Object {
    Clear-ColorScriptCache -Name $_.Name
}
```

Очищает кэш для всех цветов скриптов на тему природы.

## PARAMETERS

### -All

Очищает все кэшированные файлы цветов скриптов. Не может использоваться с параметром -Name.

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
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Запрашивает подтверждение перед запуском командлета.

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
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

Указывает имена цветов скриптов для очистки из кэша. Поддерживает подстановочные знаки (* и ?) для сопоставления шаблонов.

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
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Показывает, что произойдет, если командлет запустится. Командлет не запускается.

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

Этот командлет не принимает ввод из конвейера.

## OUTPUTS

### None

Этот командлет не возвращает вывод в конвейер.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

**Cache Location:**
Файлы кэша хранятся в управляемом модулем каталоге. Используйте `(Get-Module ColorScripts-Enhanced).ModuleBase`, чтобы найти каталог модуля, затем найдите подкаталог cache.

**When to Clear Cache:**
Когда очищать кэш:
- После изменения исходных файлов цветов скриптов
- При устранении неисправностей отображения
- Чтобы обеспечить свежий запуск скриптов
- Перед benchmarking производительности

**Performance Impact:**
Влияние на производительность:
Очистка кэша приведет к нормальному запуску скриптов при следующем отображении, что может занять больше времени, чем кэшированное выполнение. Кэш будет автоматически перестроен при последующих отображениях.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
