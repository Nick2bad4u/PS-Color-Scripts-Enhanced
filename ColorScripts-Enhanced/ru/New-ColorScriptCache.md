---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ru/New-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScriptCache

## SYNOPSIS

Предварительно строит кэш для оптимизации производительности цветовых скриптов.

## SYNTAX

```
New-ColorScriptCache [[-Name] <string[]>] [-Category <string[]>] [-Tag <string[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

Предварительно генерирует кэшированный вывод цветовых скриптов для обеспечения оптимальной производительности при первом отображении. Этот командлет выполняет цветовые скрипты заранее и сохраняет их отрендеренный вывод для мгновенного извлечения.

Система кэширования обеспечивает улучшение производительности в 6-19 раз за счет устранения времени выполнения скрипта при первом отображении. Кэшированное содержимое автоматически аннулируется при изменении исходных скриптов.

Используйте этот командлет для:
- Подготовки кэша для часто используемых скриптов
- Обеспечения последовательной производительности в сеансах
- Предварительного разогрева кэша после обновлений модуля
- Оптимизации производительности запуска

Командлет поддерживает выборочное кэширование по имени, категории или тегам, позволяя целевую подготовку кэша.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Предварительно строит кэш для всех доступных цветовых скриптов.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name "spectrum", "aurora-waves"
```

Кэширует определенные цветовые скрипты по имени.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Category Nature
```

Предварительно строит кэш для всех цветовых скриптов тематики природы.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Tag animated
```

Кэширует все цветовые скрипты, помеченные как "animated".

### EXAMPLE 5

```powershell
# Cache scripts for startup optimization
New-ColorScriptCache -Category Geometric -Tag minimal
```

Подготавливает кэш для легких геометрических скриптов, идеальных для быстрого отображения при запуске.

## PARAMETERS

### -Category

Фильтрует скрипты для кэширования по одной или нескольким категориям.

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

Указывает имена цветовых скриптов для кэширования. Поддерживает подстановочные знаки (* и ?).

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
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

Фильтрует скрипты для кэширования по одному или нескольким тегам.

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
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Показывает, что произойдет, если командлет выполнится. Командлет не выполняется.

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

Этот командлет поддерживает общие параметры: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Для получения дополнительной информации см.
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Этот командлет не принимает входные данные из конвейера.

## OUTPUTS

### System.Object

Возвращает результаты построения кэша с статусом успеха/неудачи для каждого скрипта.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

**Performance Impact:**
Предварительное кэширование устраняет время выполнения при первом отображении, обеспечивая мгновенную визуальную обратную связь. Особенно полезно для сложных или анимированных скриптов.

**Cache Management:**
Кэшированные файлы хранятся в управляемых модулем каталогах и автоматически аннулируются при изменении исходных скриптов. Используйте Clear-ColorScriptCache для удаления устаревшего кэша.

**Best Practices:**
- Кэшируйте часто используемые скрипты для оптимальной производительности
- Используйте выборочное кэширование, чтобы избежать ненужной обработки
- Запускайте после обновлений модуля для обеспечения актуальности кэша

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
