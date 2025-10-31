---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ru/New-ColorScript.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScript

## SYNOPSIS

Создает новый colorscript с метаданными и структурой шаблона.

## SYNTAX

```
New-ColorScript [-Name] <string> [[-Category] <string>] [[-Tags] <string[]>] [[-Description] <string>]
 [-Path <string>] [-Template <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Создает новый файл colorscript с правильной структурой метаданных и необязательным содержимым шаблона. Этот командлет предоставляет стандартизированный способ создания новых colorscripts, которые seamlessly интегрируются с экосистемой ColorScripts-Enhanced.

Командлет генерирует:
- Новый файл .ps1 с базовой структурой
- Связанные метаданные для категоризации
- Содержимое шаблона на основе выбранного стиля
- Правильную организацию файлов

Доступные шаблоны включают:
- Basic: Минимальная структура для пользовательских скриптов
- Animated: Шаблон с контролем времени
- Interactive: Шаблон с обработкой пользовательского ввода
- Geometric: Шаблон для геометрических узоров
- Nature: Шаблон для дизайнов, вдохновленных природой

Созданные скрипты автоматически интегрируются с системами кэширования и отображения модуля.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name "MyScript"
```

Создает новый colorscript с базовым шаблоном.

### EXAMPLE 2

```powershell
New-ColorScript -Name "Sunset" -Category Nature -Tags "animated", "colorful" -Description "Beautiful sunset animation"
```

Создает анимированный colorscript на тему природы с метаданными.

### EXAMPLE 3

```powershell
New-ColorScript -Name "GeometricPattern" -Template Geometric -Path "./custom-scripts/"
```

Создает геометрический colorscript в пользовательском каталоге.

### EXAMPLE 4

```powershell
New-ColorScript -Name "InteractiveDemo" -Template Interactive -WhatIf
```

Показывает, что будет создано, без фактического создания файлов.

### EXAMPLE 5

```powershell
# Create multiple related scripts
$themes = @("Forest", "Ocean", "Mountain")
foreach ($theme in $themes) {
    New-ColorScript -Name $theme -Category Nature -Tags "landscape"
}
```

Создает несколько colorscripts на тему природы.

## PARAMETERS

### -Category

Указывает категорию для нового colorscript. Категории помогают организовывать скрипты тематически.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
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

### -Description

Предоставляет описание для colorscript, которое объясняет его визуальное содержимое.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

Имя нового colorscript (без расширения .ps1).

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

### -Path

Указывает каталог, где будет создан colorscript.

```yaml
Type: System.String
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

### -Tags

Указывает теги для colorscript. Теги предоставляют дополнительные возможности категоризации и фильтрации.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Template

Указывает шаблон для использования в новом colorscript. Доступные шаблоны: Basic, Animated, Interactive, Geometric, Nature.

```yaml
Type: System.String
DefaultValue: Basic
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

Показывает, что произойдет, если командлет будет запущен. Командлет не выполняется.

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

Этот командлет не принимает ввод из конвейера.

## OUTPUTS

### System.Object

Возвращает объект с информацией о созданном colorscript.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 или более поздней версии

**Templates:**
- Basic: Минимальная структура для пользовательских скриптов
- Animated: Шаблон с контролем времени
- Interactive: Шаблон с обработкой пользовательского ввода
- Geometric: Шаблон для геометрических узоров
- Nature: Шаблон для дизайнов, вдохновленных природой

**File Structure:**
Созданные скрипты следуют стандартной организации модуля и автоматически интегрируются с системами кэширования и отображения.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
