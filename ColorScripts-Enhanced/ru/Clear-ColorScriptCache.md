---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache
Locale: ru
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Clear-ColorScriptCache
---

# Clear-ColorScriptCache

## SYNOPSIS

Удалите кэшированные выходные файлы цветных сценариев.

## SYNTAX

### Selection (Default)

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

### Help

```
Clear-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-All] [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

## ALIASES

У этой команды нет псевдонимов.

## DESCRIPTION

Командлет `Clear-ColorScriptCache` удаляет кэшированные выходные файлы, созданные модулем ColorScripts-Enhanced. Каждая запись состоит из отображаемой полезной нагрузки `<name>.cache` и вспомогательного компонента проверки `<name>.cacheinfo` в эффективном каталоге кэша.

Вы можете удалять записи кэша выборочно, используя параметр `-Name` с шаблонами подстановочных знаков, или удалить все записи одновременно с помощью параметра `-All`. `-All` также удаляет потерянные вспомогательные файлы, полезная нагрузка которых была удалена. Командлет поддерживает фильтрацию по `-Category` и `-Tag` для определённых подмножеств кэшированных сценариев.

Несовпадающие имена сценариев сообщают о статусе `Missing` в результатах. Используйте `-DryRun` для предварительного просмотра действий по удалению без изменения файловой системы и `-Path` для выбора альтернативного каталога кэша (полезно для пользовательских конфигураций кэша или сред CI/CD).

Подходящие записи кэша создаются заново при отображении соответствующего выбранного политикой рендерера или при вызове `New-ColorScriptCache`. Статически извлекаемые встроенные скрипты не подлежат кэшированию и не создают записи кэша.

В сценариях автоматизации объедините `-PassThru` для получения структурированных результатов, `-Quiet` для подавления сводного сообщения или `-NoAnsiOutput` для вывода сводок в виде обычного текста без цветовых кодов ANSI.

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

Удаляет каждый файл кэша в каталоге кэша по умолчанию без запроса подтверждения. Это полезно для полного обновления кэша после обновления модуля или при устранении проблем с отображением.

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

Предварительный просмотр файлов кэша на тему сияний, которые будут удалены без их фактического удаления. В выходных данных показаны файлы кэша, соответствующие шаблону, что позволяет вам проверить выбор перед выполнением удаления.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name Galaxy -Path $env:TEMP -Confirm:$false
```

Очищает файл кэша подходящего средства визуализации «Галактика» из пользовательского каталога в папке TEMP. Это полезно при тестировании `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` или другого изолированного местоположения кэша.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Category Mathematical -WhatIf
```

Показывает, что произойдет, если файлы кэша для сценариев в категории `Mathematical` будут удалены. Параметр `-WhatIf` предотвращает удаление.

### EXAMPLE 5

```powershell
Get-ColorScriptList -Tag retro | Clear-ColorScriptCache -DryRun
```

Использует входные данные конвейера для предварительного просмотра удаления файлов кэша для всех сценариев, помеченных как «ретро». Сочетает фильтрацию по тегу с предварительным просмотром перед удалением.

### EXAMPLE 6

```powershell
Clear-ColorScriptCache -Name 'test-*', 'demo-*' -Confirm:$false
```

Удаляет файлы кэша для всех скриптов, имена которых начинаются с «test-» или «demo-», без подтверждения. В виде массива можно указать несколько шаблонов подстановочных знаков.

### EXAMPLE 7

```powershell
# Очистить существующие файлы кэша и перестроить выбранные политикой записи
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -PassThru | Measure-Object
Write-Host "Кэш успешно восстановлен"
```

Удаляет все полезные нагрузки кэша, перестраивает только записи, выбранные политикой динамического кэширования, и выводит статистику перестроенных записей.

### EXAMPLE 8

```powershell
# Очистите старые записи кэша старше 30 дней.
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$thirtyDaysAgo = (Get-Date).AddDays(-30)
Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $thirtyDaysAgo } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
Write-Host "Старые файлы кеша очищены"
```

Удаляет файлы кэша, которые не обновлялись более 30 дней.

### EXAMPLE 9

```powershell
# Отчет об управлении кэшем
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$beforeCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Clear-ColorScriptCache -Category Geometric -Confirm:$false
$afterCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Write-Host "Очищены файлы геометрического кэша $($beforeCount - $afterCount)."
```

Показывает статистику об операциях очистки кэша.

### EXAMPLE 10

```powershell
# Устранение неполадок: очистка и перестройка конкретного сценария.
$scriptName = "Galaxy"
Clear-ColorScriptCache -Name $scriptName -Confirm:$false
New-ColorScriptCache -Name $scriptName -Force
Show-ColorScript -Name $scriptName
```

Очищает и перестраивает кэш одного рендерера, разрешенного политикой, а затем отображает его для проверки.

### EXAMPLE 11

```powershell
# Фильтровать по нескольким категориям
Clear-ColorScriptCache -Category Geometric,Abstract -DryRun -PassThru |
    Select-Object CacheFile |
    Measure-Object
```

Показывает, сколько файлов кэша будет удалено при фильтрации по нескольким категориям.

## PARAMETERS

### -All

Выберите каждую запись кэша в целевом каталоге. `-Category` и `-Tag` могут дополнительно ограничить набор параметров полного выбора; Вместо этого `-Name` принадлежит набору параметров выбора.

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

Прежде чем оценивать записи кэша, отфильтруйте целевые сценарии по категориям. Для удаления будут рассматриваться только файлы кэша для скриптов, соответствующие указанным категориям. Принимает массив названий категорий и может комбинироваться с `-Tag` для более точной фильтрации.

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

Запрашивает подтверждение перед запуском командлета. По умолчанию это включено, чтобы предотвратить случайное удаление файлов кэша. Используйте `-Confirm:$false`, чтобы обойти запрос на подтверждение.

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

### -DryRun

Предварительный просмотр действий по удалению без удаления файлов. Командлет покажет, какие файлы кэша будут удалены, но не изменит файловую систему. Это полезно для проверки критериев выбора перед удалением.

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

Отображает подробную справку по этой команде без выполнения операции.

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

### -Name

Имена или шаблоны подстановочных знаков, определяющие файлы кэша, которые необходимо удалить. Принимает входные данные конвейера и привязку свойств от объектов со свойством `Name`. Подстановочные знаки (`*`, `?`) поддерживаются для сопоставления с образцом. Взаимоисключающе с `-All`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
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

Отключите последовательность цветов ANSI в сводном выводе. Это полезно для консолей или обработчиков журналов, которые не интерпретируют стили ANSI, гарантируя, что текст сводки останется разборчивым в виде обычного текста.

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

### -PassThru

Возвращайте подробные объекты результатов для каждой обработанной записи кэша. Без этого переключателя командлет записывает только сводное сообщение. Каждая сквозная запись включает имя сценария, путь к файлу кэша, состояние и любой связанный текст ошибки для дальнейшей проверки или составления отчета.

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

### -Path

Альтернативный каталог кэша для работы. По умолчанию используется стандартный путь к кэшу модуля, если он не указан. Используйте этот параметр при работе с настраиваемыми местоположениями кэша, установленными через переменную среды `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`, или при управлении файлами кэша в альтернативных каталогах для тестирования или целей CI/CD.

```yaml
Type: System.String
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

Подавить сводное сообщение, выдаваемое после завершения удаления кэша. Используйте этот переключатель при работе в контекстах тихой автоматизации, где должен создаваться только структурированный вывод (например, записи `-PassThru`, предупреждения или ошибки).

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

Прежде чем оценивать записи кэша, отфильтруйте целевые сценарии по тегу метаданных. Для удаления будут рассматриваться только файлы кэша для скриптов с совпадающими тегами. Принимает массив имен тегов и может комбинироваться с `-Category` для более детального контроля над тем, какие файлы кэша являются целевыми.

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

### -WhatIf

Показывает, что произойдет, если командлет запустится без фактического выполнения операции. Командлет отображает действия, которые он будет выполнять, но не изменяет файловую систему. Это стандартный общий параметр PowerShell, который работает аналогично `-DryRun`, но соответствует встроенным соглашениям PowerShell.

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

### System.String

В этот командлет можно передать имена сценариев. Каждое имя будет оцениваться на предмет удаления файла кэша на основе указанных параметров.

### System.String[]

В этот командлет можно передать массив имен сценариев. Это особенно полезно при сочетании с `Get-ColorScriptList` для фильтрации сценариев по различным критериям перед очисткой их кешей.

### System.Management.Automation.PSObject

В этот командлет можно передать объекты со свойством `Name`. Командлет извлечет значение свойства `Name` и будет использовать его для идентификации файлов кэша, подлежащих удалению.

## OUTPUTS

### System.Object

При указании `-PassThru` возвращает запись состояния для каждого обработанного файла кэша. Каждый выходной объект содержит следующие свойства:

- **Status**: результат операции (`Removed`, `Missing`, `DryRun`, `SkippedByUser` или `Error`).
- **CacheFile**: полный путь к обработанному файлу кэша.
- **Message**: описательный текст, объясняющий результат операции.
- **Name**: имя сценария, связанного с файлом кэша.

## NOTES

**Автор**: Ник
**Модуль**: ColorScripts-Enhanced

Файлы кэша хранятся с расширением `.cache` в каталоге кэша модуля. Каждый файл кэша соответствует одному цветовому сценарию и содержит предварительно обработанный вывод ANSI.

Подходящие записи кэша создаются заново при отображении соответствующего выбранного политикой рендерера или при вызове `New-ColorScriptCache`. Статически извлекаемые встроенные скрипты не подлежат кэшированию и не создают записи кэша.

Запросите `(Get-ColorScriptConfiguration).Cache.EffectivePath` для эффективного пути по умолчанию. Его можно переопределить с помощью сохраняемой конфигурации или `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`; `-Path` нацелен на другой каталог для одного вызова.

При использовании `-DryRun` или `-WhatIf` командлет по-прежнему будет проверять существование каталога кэша и сообщать о любых проблемах, но не будет выполнять никаких удалений.

Фильтрация по `-Category` или `-Tag` требует, чтобы сценарии имели связанные метаданные. Скрипты без метаданных не будут соответствовать этим фильтрам.

### Рекомендации

- Всегда используйте `-DryRun` или `-WhatIf` перед деструктивными операциями.
– Используйте `-Confirm:$false` только в том случае, если вы уверены в правильности операции.
- Архивируйте кеш перед основными операциями очистки для восстановления.
- Регулярно отслеживайте дисковое пространство на предмет роста кэша.
- По возможности используйте выборочную очистку вместо полной очистки.
- Отслеживайте критические сценарии, которые не следует удалять.
- Планирование автоматической очистки во время периодов обслуживания.
- Сначала протестируйте операции очистки в непроизводственных целях.

### Устранение неполадок (2)

- **"Файлы кэша не найдены"**: проверьте `(Get-ColorScriptConfiguration).Cache.EffectivePath` и используйте `Export-ColorScriptMetadata -IncludeCacheInfo` для проверки состояния кэша.
- **"Отказано в разрешении"**: проверьте доступ на запись в каталог кэша.
- **"Кэш не восстанавливается"**: в сценариях могут возникать проблемы с рендерингом; протестируйте с `-NoCache`

## RELATED LINKS

- [Онлайн-версия](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache)

