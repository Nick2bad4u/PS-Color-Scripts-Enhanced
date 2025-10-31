---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ru/Export-ColorScriptMetadata.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Export-ColorScriptMetadata

## SYNOPSIS

Экспортирует метаданные цветовых скриптов в различные форматы для внешнего использования.

## SYNTAX

```
Export-ColorScriptMetadata [-Path] <string> [[-Format] <string>] [-Category <string[]>] [-Tag <string[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Экспортирует всесторонние метаданные о цветовых скриптах во внешние файлы для документации, отчетности или интеграции с другими инструментами. Поддерживает несколько форматов вывода, включая JSON, CSV и XML.

Экспортированные метаданные включают:
- Имена скриптов и пути к файлам
- Категории и теги
- Описания и метаданные
- Размеры файлов и даты изменения
- Информацию о состоянии кэша

Этот командлет полезен для:
- Генерации документации
- Создания инвентарей
- Интеграции с системами CI/CD
- Резервного копирования и миграции
- Анализа и отчетности

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata -Path "colorscripts.json"
```

Экспортирует все метаданные цветовых скриптов в файл JSON.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -Path "inventory.csv" -Format CSV
```

Экспортирует метаданные в формате CSV для анализа в электронных таблицах.

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path "nature-scripts.xml" -Category Nature -Format XML
```

Экспортирует только цветовые скрипты на тему природы в формате XML.

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path "geometric.json" -Tag geometric
```

Экспортирует цветовые скрипты, помеченные как "geometric", в JSON.

### EXAMPLE 5

```powershell
# Export with timestamp
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
Export-ColorScriptMetadata -Path "backup-$timestamp.json"
```

Создает резервную копию всех метаданных с отметкой времени.

## PARAMETERS

### -Category

Фильтрует экспортируемые скрипты по одной или нескольким категориям перед экспортом.

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

Запрашивает подтверждение перед выполнением командлета.

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

### -Format

Указывает формат вывода. Допустимые значения: JSON, CSV и XML.

```yaml
Type: System.String
DefaultValue: JSON
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

Указывает путь к файлу, куда будут сохранены экспортированные метаданные.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

Фильтрует экспортируемые скрипты по одному или нескольким тегам перед экспортом.

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

Показывает, что произойдет при выполнении командлета. Командлет не выполняется.

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

### None

Этот командлет не возвращает выходные данные в конвейер.

## NOTES

**Автор:** Nick
**Модуль:** ColorScripts-Enhanced
**Требуется:** PowerShell 5.1 или новее

**Форматы вывода:**
- JSON: Структурированные данные для программного доступа
- CSV: Формат, совместимый с электронными таблицами
- XML: Иерархическая структура данных

**Случаи использования:**
- Генерация документации
- Управление инвентарем
- Интеграция CI/CD
- Резервное копирование и восстановление
- Аналитика и отчетность

## RELATED LINKS

- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
