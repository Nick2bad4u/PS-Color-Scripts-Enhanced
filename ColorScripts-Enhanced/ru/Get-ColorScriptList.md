---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ru/Get-ColorScriptList.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptList

## SYNOPSIS

Получает список доступных цветовых скриптов с их метаданными.

## SYNTAX

```
Get-ColorScriptList [[-Name] <string[]>] [-Category <string[]>] [-Tag <string[]>] [-AsObject]
 [<CommonParameters>]
```

## DESCRIPTION

Возвращает информацию о доступных цветовых скриптах в коллекции ColorScripts-Enhanced. По умолчанию отображает отформатированную таблицу, показывающую имена скриптов, категории и описания. Используйте `-AsObject` для возврата структурированных объектов для программного доступа.

Командлет предоставляет всесторонние метаданные о каждом цветовом скрипте, включая:
- Name: Идентификатор скрипта (без расширения .ps1)
- Category: Тематическая группировка (Nature, Abstract, Geometric и т.д.)
- Tags: Дополнительные дескрипторы для фильтрации и обнаружения
- Description: Краткое объяснение визуального содержания скрипта

Этот командлет необходим для изучения коллекции и понимания доступных вариантов перед использованием других командлетов, таких как `Show-ColorScript`.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Отображает отформатированную таблицу всех доступных цветовых скриптов с их метаданными.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Category Nature
```

Перечисляет только цветовые скрипты, categorized как "Nature".

### EXAMPLE 3

```powershell
Get-ColorScriptList -Tag geometric -AsObject
```

Возвращает цветовые скрипты, tagged как "geometric", в виде объектов для дальнейшей обработки.

### EXAMPLE 4

```powershell
Get-ColorScriptList -Name "aurora*" | Format-Table Name, Category, Tags
```

Перечисляет цветовые скрипты, соответствующие шаблону подстановки, с выбранными свойствами.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject | Where-Object { $_.Tags -contains 'animated' }
```

Находит все анимированные цветовые скрипты с помощью фильтрации объектов.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Abstract,Geometric | Measure-Object
```

Подсчитывает цветовые скрипты в категориях Abstract или Geometric.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Tag retro | Select-Object Name, Description
```

Показывает имена и описания цветовых скриптов в стиле retro.

### EXAMPLE 8

```powershell
# Get random script from specific category
Get-ColorScriptList -Category Nature -AsObject | Get-Random | Select-Object -ExpandProperty Name
```

Выбирает случайное имя цветового скрипта из категории Nature.

### EXAMPLE 9

```powershell
# Export script inventory to CSV
Get-ColorScriptList -AsObject | Export-Csv -Path "colorscripts.csv" -NoTypeInformation
```

Экспортирует полные метаданные скриптов в файл CSV.

### EXAMPLE 10

```powershell
# Find scripts by multiple criteria
Get-ColorScriptList -AsObject | Where-Object {
    $_.Category -eq 'Geometric' -and $_.Tags -contains 'colorful'
}
```

Находит геометрические цветовые скрипты, которые также tagged как colorful.

## PARAMETERS

### -AsObject

Возвращает информацию о цветовых скриптах в виде структурированных объектов вместо отображения отформатированной таблицы. Объекты включают свойства Name, Category, Tags и Description для программного доступа.

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

### -Category

Фильтрует результаты по цветовыми скриптам, принадлежащим к одной или нескольким указанным категориям. Категории - это широкие тематические группировки, такие как "Nature", "Abstract", "Art", "Retro" и т.д.

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

### -Name

Фильтрует результаты по цветовыми скриптам, соответствующим одному или нескольким шаблонам имен. Поддерживает подстановочные знаки (* и ?) для гибкого сопоставления.

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

Фильтрует результаты по цветовыми скриптам, tagged с одним или несколькими указанными тегами. Теги - это более конкретные дескрипторы, такие как "geometric", "retro", "animated", "minimal" и т.д.

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

Когда указан `-AsObject`, возвращает пользовательские объекты со свойствами Name, Category, Tags и Description.

### None

Когда `-AsObject` не указан, вывод записывается непосредственно в консоль хоста.

## NOTES

**Автор:** Nick
**Модуль:** ColorScripts-Enhanced
**Требуется:** PowerShell 5.1 или новее

**Свойства метаданных:**
- Name: Идентификатор скрипта, используемый Show-ColorScript
- Category: Тематическая группировка для организации
- Tags: Массив описательных ключевых слов для фильтрации
- Description: Человеко-читаемое объяснение содержания

**Шаблоны использования:**
- Discovery: Изучите доступные скрипты перед выбором
- Filtering: Сузьте варианты с помощью категорий и тегов
- Automation: Используйте -AsObject для программного выбора скрипта
- Inventory: Экспортируйте метаданные для документации или отчетности

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
