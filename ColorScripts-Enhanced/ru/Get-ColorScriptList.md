---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: ru
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

Перечисляет доступные цветовые сценарии с дополнительной фильтрацией и выводом расширенных метаданных.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

У этой команды нет псевдонимов.

## DESCRIPTION

Командлет `Get-ColorScriptList` извлекает и отображает все цветовые сценарии, упакованные с помощью модуля ColorScripts-Enhanced. Он предоставляет гибкие возможности фильтрации и несколько форматов вывода для различных случаев использования.

По умолчанию командлет отображает краткую форматированную таблицу, показывающую имена и категории сценариев. Переключатель `-Detailed` расширяет это представление, включив в него теги и описания, предоставляя больше контекста.

Командлет всегда возвращает записи метаданных в конвейер успеха. Без `-AsObject` он также записывает форматированное представление хоста; `-AsObject` подавляет форматирование хоста для чистой автоматизации. Записи включают имя, путь, категорию, категории, теги, описание и исходное свойство метаданных.

Возможности фильтрации позволяют сузить список по:

- **Name**: поддерживает шаблоны подстановочных знаков (например, `aurora-*`) для гибкого сопоставления.
- **Category**: фильтрация по одному или нескольким названиям категорий (без учета регистра).
- **Tag**: фильтрация по тегам метаданных, например «Рекомендуется» или «Анимированный» (без учета регистра).

Командлет проверяет шаблоны фильтров и генерирует предупреждения для любых несовпадающих шаблонов имен, помогая выявить потенциальные опечатки или отсутствующие сценарии.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Отображает все доступные цветовые сценарии в компактном табличном формате с указанием имени и категории каждого сценария.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed
```

Показывает все цветовые сценарии с дополнительными столбцами, включая теги и описания, для более полного обзора.

### EXAMPLE 3

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

Отображает только скрипты из категории «Шаблоны» с полными метаданными, включая теги и описания.

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

Возвращает структурированные объекты для каждого скрипта, имя которого соответствует шаблону подстановочных знаков, а затем выбирает для отображения только свойства Name и Tags.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

Извлекает все сценарии, помеченные как «Рекомендуемые», и сортирует их в алфавитном порядке по имени. Полезно для поиска тщательно подобранных скриптов, подходящих для интеграции профиля.

### EXAMPLE 6

```powershell
Get-ColorScriptList -AsObject -Category Geometric,Abstract | Where-Object { $_.Tags -contains 'Colorful' }
```

Сочетает фильтрацию по категориям и тегам для поиска сценариев, которые относятся к категориям «Геометрический» или «Абстрактный» и помечены как «Цветные».

### EXAMPLE 7

```powershell
Get-ColorScriptList -Name blocks,pipes,matrix -AsObject | ForEach-Object { Show-ColorScript -Name $_.Name }
```

Извлекает определенные именованные сценарии и последовательно выполняет каждый из них, демонстрируя интеграцию конвейера с `Show-ColorScript`.

### EXAMPLE 8

```powershell
# Подсчитайте сценарии по категориям для целей инвентаризации.
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending
```

Предоставляет сводную информацию о том, сколько цветовых сценариев существует в каждой категории.

### EXAMPLE 9

```powershell
# Найдите скрипты с определенными ключевыми словами в описании.
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

Ищет сценарии на основе их описания с использованием сопоставления с образцом.

### EXAMPLE 10

```powershell
# Экспорт в CSV для обработки внешним инструментом.
Get-ColorScriptList -AsObject -Detailed |
    Select-Object Name, Category, Tags, Description |
    Export-Csv -Path "./colorscripts-inventory.csv" -NoTypeInformation
```

Экспортирует полный набор цветов в формат CSV для использования в приложениях для работы с электронными таблицами.

### EXAMPLE 11

```powershell
# Проверьте сценарии без определенной категории
$allScripts = Get-ColorScriptList -AsObject
$uncategorized = $allScripts | Where-Object { -not $_.Category }
Write-Host "Скрипты без категорий: $($uncategorized.Count)"
$uncategorized | Select-Object Name
```

Определяет сценарии, в которых отсутствуют метаданные категории.

### EXAMPLE 12

```powershell
# Создайте кеш для отфильтрованных скриптов.
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object {
        New-ColorScriptCache -Name $_.Name -PassThru
    } |
    Format-Table Name, Status
```

Оценивает сценарии с тегом `Recommended`; Создаются только средства визуализации, соответствующие политике кэширования, а другие записи сообщают `SkippedNotRequired`.

### EXAMPLE 13

```powershell
# Создайте форматированный отчет обо всех геометрических сценариях.
Get-ColorScriptList -Category Geometric -Detailed |
    Out-String |
    Tee-Object -FilePath "./geometric-report.txt"
```

Создает и сохраняет подробный отчет о цветовых сценариях геометрических категорий в файл.

### EXAMPLE 14

```powershell
# Найдите первый скрипт, соответствующий шаблону, для быстрого отображения.
$script = Get-ColorScriptList -Name "aurora-*" -AsObject | Select-Object -First 1
if ($script) {
    Show-ColorScript -Name $script.Name -PassThru
}
```

Быстро отображает первый соответствующий сценарий на основе шаблона подстановочных знаков.

### EXAMPLE 15

```powershell
# Прежде чем запускать автоматизацию, убедитесь, что все указанные сценарии существуют.
$requiredScripts = @("bars", "arch", "mandelbrot-zoom")
$available = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$missing = $requiredScripts | Where-Object { $_ -notin $available }
if ($missing) {
    Write-Warning "Отсутствующие скрипты: $($missing -join ', ')"
} else {
    Write-Host "Все необходимые скрипты имеются."
}
```

Проверяет наличие всех необходимых сценариев перед запуском автоматизации.

## PARAMETERS

### -AsObject

Возвращает объекты записей необработанных метаданных вместо отображения отформатированной таблицы на хосте. Это обеспечивает конвейерную обработку и программное манипулирование метаданными цветового сценария.

Если указан этот параметр, вы можете использовать стандартные командлеты PowerShell, такие как `Where-Object`, `Select-Object`, `Sort-Object` и `ForEach-Object`, для дальнейшей обработки результатов.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

Фильтрует список, чтобы включить только скрипты, принадлежащие одной или нескольким указанным категориям. Сопоставление категорий не учитывает регистр.

Общие категории включают в себя: «Узоры», «Геометрика», «Абстракция», «Природа», «Анимация», «Текст», «Ретро» и другие. Вы можете указать несколько категорий, чтобы расширить поиск.

```yaml
Type: System.String[]
DefaultValue: ''
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

### -Detailed

Включает дополнительные столбцы (теги и описание) при отрисовке форматированного табличного представления. Это позволяет с первого взгляда получить более полную информацию о каждом сценарии.

Без этого переключателя в выходных таблицах отображаются только имя и основная категория.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -h

Отображает подробную справку по этой команде без выполнения операции.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- help
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

Фильтрует список цветовых сценариев по одному или нескольким именам сценариев. Поддерживает подстановочные знаки (`*` и `?`) для гибкого сопоставления с образцом.

Если указанный шаблон не соответствует ни одному сценарию, генерируется предупреждение, помогающее выявить потенциальные проблемы. Сопоставление имен не учитывает регистр.

Вы можете указать точные имена или использовать шаблоны, например `aurora-*`, для сопоставления нескольких связанных сценариев.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAnsiOutput

Отключает стиль ANSI в информационных сообщениях и отображаемый вывод для сред с обычным текстом.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -Quiet

Подавляет информационные сообщения, сохраняя при этом вывод команды и ошибки.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -Tag

Фильтрует список, чтобы включить только сценарии, содержащие один или несколько указанных тегов метаданных. Сопоставление тегов не учитывает регистр.

Общие теги включают: «Рекомендуемый», «Анимированный», «Красочный», «Минимальный», «Ретро», «Сложный», «Простой» и другие. Теги помогают классифицировать сценарии по визуальному стилю, сложности или варианту использования.

```yaml
Type: System.String[]
DefaultValue: ''
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

### CommonParameters

Этот командлет поддерживает следующие общие параметры:
Дополнительные сведения см. в разделе
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Этот командлет не принимает входные данные конвейера.

## OUTPUTS

### System.Object

Возвращает объекты записей метаданных цветовых сценариев со следующими свойствами:

- **Name**: идентификатор сценария, используемый с `Show-ColorScript`.
- **Path**: полный исходный путь.
- **Category**: основная категория сценария.
- **Categories**: массив всех категорий, к которым принадлежит скрипт.
- **Tags**: массив тегов метаданных, описывающих скрипт.
- **Description**: удобочитаемое описание визуального вывода сценария.
- **Metadata**: исходный объект метаданных, содержащий всю необработанную информацию о сценарии.

Без `-AsObject` командлет записывает на хост отформатированную таблицу, при этом возвращая объекты записи для потенциальной конвейерной обработки.

## NOTES

**Автор**: Ник
**Модуль**: ColorScripts-Enhanced

Возвращенные записи метаданных предоставляют исчерпывающую информацию как для отображения, так и для целей автоматизации. Свойство `Name` можно использовать непосредственно с командлетом `Show-ColorScript` для выполнения определенных сценариев.

Все операции фильтрации (имя, категория, тег) не чувствительны к регистру и могут быть объединены для создания эффективных запросов. При использовании подстановочных знаков в параметре `-Name` несовпадающие шаблоны генерируют предупреждения, помогающие устранить неполадки.

Для достижения наилучших результатов при интеграции цветовых сценариев в профиль PowerShell используйте фильтр `-Tag Recommended`, чтобы определить тщательно подобранные сценарии, подходящие для отображения при запуске.

### Рекомендации

– Всегда используйте `-AsObject`, когда вам нужно программно фильтровать или манипулировать результатами.
– Используйте `-Detailed` при интерактивном просмотре, чтобы увидеть теги и описания.
- Объедините несколько фильтров для точных запросов
- Периодически экспортируйте метаданные, чтобы отслеживать изменения с течением времени.
- Используйте объекты результатов для автоматизации, а не для анализа текстового вывода.
– Учитывайте производительность при повторном выполнении запросов (по возможности кэшируйте результаты).
- Использование группового объекта для анализа и отчетности.
- Используйте Where-Object для сложной логики фильтрации.

## RELATED LINKS

- [Онлайн-версия](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)

