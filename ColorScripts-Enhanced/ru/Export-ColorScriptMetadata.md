---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: ru
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Export-ColorScriptMetadata
---

# Export-ColorScriptMetadata

## SYNOPSIS

Экспортирует полные метаданные для всех цветовых сценариев в формат JSON или отправляет структурированные объекты в конвейер.

## SYNTAX

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-h] [-IncludeFileInfo] [-IncludeCacheInfo]
 [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

У этой команды нет псевдонимов.

## DESCRIPTION

Командлет `Export-ColorScriptMetadata` составляет полный перечень всех цветовых сценариев в каталоге модуля и генерирует структурированный набор данных, описывающий каждую запись. Эти метаданные включают важную информацию, такую ​​как имена сценариев, категории, теги и дополнительные дополнения.

По умолчанию командлет возвращает объекты PowerShell в конвейер. Если указан параметр `-Path`, он записывает метаданные в формате JSON в указанный файл, автоматически создавая родительские каталоги, если они не существуют.

Командлет предлагает два дополнительных флага расширения:

- **IncludeFileInfo**: добавляет метаданные файловой системы, включая полные пути, размеры файлов (в байтах) и временные метки последнего изменения.
- **IncludeCacheInfo**: добавляет информацию, связанную с кешем, включая пути к файлам кеша, состояние существования и временные метки кеша.

Этот командлет особенно полезен для:

- Создание документации или информационных панелей, показывающих все доступные цветовые сценарии.
- Отчеты о наличии файлов необработанного кэша и временных метках.
- Передача метаданных во внешние инструменты или конвейеры автоматизации.
- Аудит инвентаризации цветовых сценариев и состояния файловой системы.
- Создание отчетов об использовании и организации цветовых сценариев.

Вывод упорядочивается последовательно, что делает его пригодным для контроля версий и операций сравнения при экспорте в JSON.

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

Экспортирует базовые метаданные для всех цветовых сценариев в конвейер без информации о файле или кэше.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

Возвращает объекты, содержащие сведения о файловой системе (полный путь, размер и время последней записи) для каждого цветового сценария.

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

Создает файл JSON, содержащий основные метаданные, и записывает его в каталог `dist`, создавая папку, если она не существует.

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

Создает полный файл JSON с расширенными метаданными, включая информацию о файловой системе и кэше, записывая его в каталог `dist`.

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeCacheInfo -PassThru | Where-Object { -not $_.CacheExists }
```

Записывает файл метаданных и возвращает записи, в которых необработанная полезная нагрузка `.cache` отсутствует. Это сообщает только о занятости файла, а не о пригодности к кэшированию, действительности или актуальности.

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

Группирует цветовые сценарии по категориям и отображает их количество, что полезно для анализа распределения сценариев по категориям.

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property ScriptSizeBytes -Sum).Sum
Write-Host "Общий размер всех цветовых сценариев: $($totalSize / 1KB) КБ."
```

Вычисляет общее дисковое пространство, используемое всеми файлами цветных сценариев.

### EXAMPLE 8

```powershell
# Генерация статистики и сохранение отчета
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachePayloadFiles = ($metadata | Where-Object CacheExists).Count
    TotalScriptSizeBytes = ($metadata | Measure-Object ScriptSizeBytes -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

Генерирует статистику инвентаризации и подсчитывает необработанные файлы полезной нагрузки `.cache`. Наличие полезной нагрузки не является проверкой пригодности, действительности или актуальности кэша.

### EXAMPLE 9

```powershell
# Экспортируйте и сравните с предыдущей резервной копией.
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "Новые скрипты: $($new.Count) | Удалены скрипты: $($removed.Count)"
```

Сравнивает текущие метаданные с предыдущей версией для выявления изменений.

### EXAMPLE 10

```powershell
# Создайте ответ API для веб-панели
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

Генерирует JSON, готовый к API, с информацией о версии и метке времени.

### EXAMPLE 11

```powershell
# Создайте или проверьте каждую запись кэша, выбранную политикой, и просмотрите статусы.
$results = New-ColorScriptCache -All -PassThru
$results | Group-Object Status | Select-Object Name, Count
```

Использует политику кэширования в качестве источника достоверной информации и сообщает, были ли подходящие записи обновлены, уже являются текущими, пропущены или возникли ошибки.

### EXAMPLE 12

```powershell
# Создать HTML-галерею из метаданных
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$html = @"
<html>
<head><title>ColorScripts-Enhanced Gallery</title></head>
<body>
<h1>ColorScripts-Enhanced</h1>
<ul>
"@
foreach ($script in $metadata) {
    $html += "<li><strong>$($script.Name)</strong> [$($script.Category)]</li>`n"
}
$html += "</ul></body></html>"
$html | Out-File "./gallery.html" -Encoding UTF8
```

Создает страницу галереи HTML со списком всех доступных цветовых сценариев.

### EXAMPLE 13

```powershell
# Мониторинг размеров скриптов с течением времени
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object ScriptSizeBytes -Average).Average) bytes avg" }
```

Отслеживает изменения размера файла для отдельных сценариев при многократном экспорте.

## PARAMETERS

### -Confirm

Запрашивает подтверждение перед запуском командлета.

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

### -h

Отображает подробную справку по этой команде без выполнения операции.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -IncludeCacheInfo

Добавляет к каждой записи путь к необработанной полезной нагрузке `.cache`, флаг наличия файла и время последней записи. Эти поля не сообщают о соответствии политике кэширования, наличии вспомогательного файла `.cacheinfo`, его действительности или актуальности.

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

### -IncludeFileInfo

Включает сведения о файловой системе (полный путь, размер в байтах и ​​время последней записи) в каждой записи. Если метаданные файла не могут быть прочитаны (из-за разрешений или отсутствия файлов), ошибки регистрируются посредством подробного вывода, а затронутым свойствам присваиваются нулевые значения. Этот переключатель полезен для проверки размеров файлов и дат изменения.

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

### -PassThru

Возвращает объекты метаданных в конвейер, даже если указан параметр `-Path`. Это позволяет не только сохранять метаданные в файл, но и выполнять дополнительную обработку или фильтрацию объектов с помощью одной команды. Без этого переключателя указание `-Path` подавляет вывод конвейера.

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

### -Path

Указывает путь к целевому файлу для экспорта JSON. Поддерживает относительные пути, абсолютные пути, переменные среды (например, `$env:TEMP\metadata.json`) и расширение тильды (например, `~/Documents/metadata.json`). Родительские каталоги создаются автоматически, если они не существуют. Если этот параметр опущен, командлет выводит объекты непосредственно в конвейер, а не записывает их в файл. Вывод JSON форматируется с отступами для удобства чтения.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
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

### -WhatIf

Запускает команду в режиме, который сообщает только о том, что произойдет, без выполнения действий.

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

Этот командлет поддерживает следующие общие параметры:
Дополнительные сведения см. в разделе
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Этот командлет не принимает входные данные конвейера.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Если `-Path` не указан или используется `-PassThru`, командлет возвращает пользовательские объекты. Каждый объект представляет собой один цветовой сценарий со следующими базовыми свойствами:

- **Name**: имя файла цветового сценария без расширения.
- **Category**: основная организационная категория.
- **Categories**: все назначенные категории.
- **Tags**: массив описательных тегов для фильтрации и поиска.
- **Description**: описание метаданных.

Если указан `-IncludeFileInfo`, включаются следующие дополнительные свойства:

- **ScriptPath**: полный путь файловой системы к файлу сценария.
- **ScriptSizeBytes**: размер в байтах (ноль, если файл недоступен).
- **ScriptLastWriteTimeUtc**: временная метка последнего изменения в формате UTC (нуль, если недоступно).

Если указан `-IncludeCacheInfo`, включаются следующие дополнительные свойства:

- **CachePath**: полный путь к соответствующему файлу кэша.
- **CacheExists**: логическое значение наличия необработанного файла полезной нагрузки .cache. Оно не указывает на допустимость по политике, действительность или актуальность кэша
- **CacheLastWriteTimeUtc**: временная метка UTC изменения файла кэша (нуль, если кэш не существует).

## NOTES

Нет.

## RELATED LINKS

- [Онлайн-версия](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)

