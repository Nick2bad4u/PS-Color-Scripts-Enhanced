---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: ru
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

Предварительно создает или обновляет кэш только для ресурсоемких рендереров, выбранных в CachePolicy.psd1.

## SYNTAX

### Selection (Default)

```
New-ColorScriptCache [-Name <string[]>] [-Force] [-PassThru] [-Category <string[]>]
 [-Tag <string[]>] [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon]
 [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Category <string[]>] [-Tag <string[]>]
 [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon] [-WhatIf] [-Confirm]
```

## ALIASES

- `Build-ColorScriptCache`
- `Update-ColorScriptCache`

## DESCRIPTION

`New-ColorScriptCache` визуализирует выбранные политикой вычислительные цветовые скрипты и сохраняет их вывод в UTF-8 без BOM. Подходящие встроенные рендереры используют изолированный путь выполнения модуля; параллельные рабочие процессы доступны в PowerShell 7 и более поздних версиях. Статически извлекаемые встроенные скрипты не подлежат кэшированию и не создают файлы кэша. Псевдонимы: `Update-ColorScriptCache` и `Build-ColorScriptCache`.

Вы можете ориентировать сценарии по имени (поддерживаются подстановочные знаки), категории или тегу. Если параметры не указаны, командлет разрешает имена в `CachePolicy.psd1` напрямую, а не перечисляет всю коллекцию. Точные связанные имена также используют прямой поиск файлов. Запросы подстановочных знаков, категорий и тегов перечисляются только тогда, когда этого требует их соответствующая семантика. Явные сценарии, не включенные в список, возвращаются со статусом `SkippedNotRequired` при использовании `-PassThru`, а все устаревшие файлы кэша для этих сценариев удаляются.

По умолчанию командлет отображает ход выполнения, а также краткую сводку операции кэширования и эффективный каталог кэша. Используйте `-PassThru` для возврата подробных объектов результатов для каждого сценария, которые вы можете проверить программно на предмет статуса, стандартного вывода и потоков ошибок. Объедините `-Quiet`, чтобы полностью подавить ход выполнения и сводку, или `-NoAnsiOutput`, чтобы выводить сводки в виде обычного текста без цветовых кодов ANSI для сред, которые их не поддерживают.

Командлет разумно пропускает сценарии, файлы кэша которых уже обновлены, если вы не укажете параметр `-Force`. Повторные сборки проверяют небольшой вспомогательный компонент `<name>.cacheinfo` без загрузки визуализированных полезных данных `<name>.cache`. `-Force` перестраивает подходящие записи кэша, но никогда не отменяет политику кэширования.

Оба файла находятся в `(Get-ColorScriptConfiguration).Cache.EffectivePath`. Файл `.cache` содержит визуализированный вывод терминала; `.cacheinfo` содержит только метаданные проверки. Вспомогательный файл без полезной нагрузки не является пригодной записью кэша и восстанавливается при следующей сборке. `Clear-ColorScriptCache -All` удаляет полные записи и потерянные вспомогательные файлы.

Для более быстрого перестроения в многоядерных системах используйте переключатель `-Parallel` вместе с параметром `-ThrottleLimit` (или `-Threads`) для управления количеством рабочих процессов. Командлет автоматически возвращается к последовательному выполнению, когда на текущем хосте невозможно создать параллельные пространства выполнения.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Решите и прогрейте только те вычислительные средства визуализации, которые выбраны политикой, без перечисления каждого сценария, поставляемого с модулем. Это поведение по умолчанию, когда параметры не указаны.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name Galaxy, 'rose-*'
```

Кэшируйте сочетание точных и подстановочных совпадений. Создаются только совпадения, включенные в `CachePolicy.psd1`; отчет о других совпадениях `SkippedNotRequired` с `-PassThru`.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name Galaxy -Force -PassThru | Format-List
```

Принудительно перестройте подходящий кэш «Галактики», даже если он обновлен, и изучите подробный объект результата.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Mathematical' -PassThru
```

Оценивайте сценарии в категории `Mathematical`, кэшируйте подходящие средства визуализации и возвращайте подробные результаты для каждого совпадения.

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

Перестройте подходящие кеши для сценариев, помеченных как «геометрические» или «красочные», принудительно выполняя регенерацию, даже если кеши являются текущими.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Mathematical -AsObject | New-ColorScriptCache -PassThru
```

Пример конвейера: оценка сценариев в категории `Mathematical`, кэширование всех выбранных политикой средств визуализации и возврат результата для каждого совпадения.

### EXAMPLE 7

```powershell
# Проверьте статистику кэша после сборки
$cachePath = (Get-ColorScriptConfiguration).Cache.EffectivePath
$before = @(Get-ChildItem $cachePath -Filter "*.cache" -ErrorAction SilentlyContinue).Count
New-ColorScriptCache
$after = @(Get-ChildItem $cachePath -Filter "*.cache").Count
Write-Host "Кэшированные скрипты: $before -> $after."
```

Измеряет рост кэша путем подсчета выбранных политикой файлов кэша до и после операции.

### EXAMPLE 8

```powershell
# Создайте кеш для часто используемых вычислительных средств визуализации.
$frequentScripts = @('Galaxy', 'rose-curves', 'wave-interference')
New-ColorScriptCache -Name $frequentScripts -PassThru | Format-Table Name, Status, ExitCode
```

Создает кэши для перечисленных скриптов, подходящих под `CachePolicy.psd1`; имена, не включенные в список, пропускаются.

### EXAMPLE 9

```powershell
# Используйте встроенный дисплей прогресса на уровне политики.
New-ColorScriptCache -All
```

Показывает встроенный прогресс для выбранных политикой средств визуализации без повторного выполнения всех доступных сценариев вручную.

### EXAMPLE 10

```powershell
# При необходимости добавьте отсутствующие или устаревшие записи политики из профиля PowerShell.
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Quiet
```

Проверяет выбранные политикой записи при загрузке профиля и создает только отсутствующие или устаревшие записи. Пропустите этот шаг профиля, если работа с кэшем при запуске не требуется.

### EXAMPLE 11

```powershell
# Перестройте каждую запись, выбранную политикой, для развертывания.
New-ColorScriptCache -All -Force -PassThru |
    Select-Object Name, Status |
    Export-Csv "./cache-deployment.csv"
```

Перестраивает каждую запись кэша, выбранную политикой, и экспортирует статусы в манифест развертывания.

### EXAMPLE 12

```powershell
# Найдите ошибки построения кэша
New-ColorScriptCache -Name "Galaxy" -Force -PassThru |
    Where-Object Status -eq 'Failed' |
    Select-Object Name, StdErr
```

Выявляет сбои кэширования, не рассматривая пропуски политики как ошибки.

### EXAMPLE 13

```powershell
# Подсчитать выбранные политикой записи, обновленные в результате этого запуска
New-ColorScriptCache -All -PassThru |
    Where-Object Status -eq 'Updated' |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

Проверяет каждую запись, выбранную политикой, и показывает, сколько полезных данных кэша было обновлено в результате этого запуска.

### EXAMPLE 14

```powershell
New-ColorScriptCache -All -Parallel -Threads 8
```

Создайте все выбранные политикой кэши, используя восемь рабочих потоков. Командлет автоматически возвращается к последовательному выполнению, когда параллельные задания недоступны на текущем хосте.

## PARAMETERS

### -All

Разрешите каждую запись политики кэширования напрямую. Обрабатываются только сценарии, выбранные политикой; полный инвентарь цветных сценариев не перечисляется.

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

Фильтрует оцениваемые скрипты по категориям метаданных (без учета регистра). Несколько значений обрабатываются как фильтр ИЛИ. Кэшируются только совпадения, разрешенные `CachePolicy.psd1`; отчет о других совпадениях `SkippedNotRequired` с `-PassThru`.

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

Запрашивает подтверждение перед запуском командлета. Полезно при кэшировании большого количества скриптов или при использовании `-Force` для предотвращения случайной регенерации кэша.

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

### -Force

Перестройте подходящие записи кэша, даже если их метаданные проверки `.cacheinfo` говорят, что они актуальны. Это не отменяет `CachePolicy.psd1`.

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

### -IncludePokemon

Устаревший параметр совместимости. В течение одного выпуска он принимается без сообщений и не выполняет действий, поскольку сценарии Pokémon следуют тем же правилам `CachePolicy.psd1`, что и все остальные сценарии.

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

### -Name

Одно или несколько имен цветовых сценариев для проверки кэширования. Поддерживает шаблоны подстановочных знаков (например, `aurora-*` и `*-wave`). Соответствующие сценарии кэшируются только в том случае, если они указаны в `CachePolicy.psd1`. Если этот параметр и все фильтры опущены, разрешаются и оцениваются только записи политики.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
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

Отключите последовательность цветов ANSI при выводе информации. Это полезно в средах, которые не отображают escape-коды ANSI (например, некоторые журналы CI/CD), сохраняя при этом цветной вывод, когда это необходимо.

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

### -Parallel

Включите многопоточное построение кэша. Если этот параметр указан, командлет выполняет задания кэширования в пуле пространства выполнения для более быстрого завершения на соответствующих системах. Используйте в сочетании с `-ThrottleLimit` (или псевдонимом `-Threads`), чтобы контролировать количество одновременно работающих рабочих процессов. Если многопоточность не может быть инициализирована, командлет автоматически возвращается к последовательному выполнению.

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

### -PassThru

Возвращайте подробные объекты результатов для каждой операции кэша. По умолчанию отображается только сводка. Объекты результатов включают такие свойства, как Name, Status, CacheFile, ExitCode, StdOut и StdErr, позволяющие программно проверять процесс кэширования.

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

### -Quiet

Подавить выполнение каждого сценария и вывод сводной информации. Используйте этот переключатель, когда вам нужен только структурированный вывод (через `-PassThru`) или когда сценарии автоматизации должны заглушать информационные сообщения, сохраняя при этом предупреждения и ошибки.

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

Фильтрует оцениваемые сценарии по тегу метаданных (без учета регистра). Несколько значений обрабатываются как фильтр ИЛИ. Кэшируются только совпадения, разрешенные `CachePolicy.psd1`; отчет о других совпадениях `SkippedNotRequired` с `-PassThru`.

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

### -ThrottleLimit

Указывает максимальное количество одновременных рабочих кэшей при запросе `-Parallel`. Принимает значения от 1 до 256. Значение по умолчанию (если опущено) — это количество логических процессоров на текущей машине. Псевдоним `-Threads` предоставлен для удобства. Значения меньше или равные единице автоматически возвращаются к последовательному выполнению.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Threads
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

Показывает, что произойдет, если командлет запустится без фактического выполнения операций кэширования. Полезно для предварительного просмотра сценариев, которые будут кэшированы, перед выполнением операции.

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

В этот командлет можно передать имена сценариев. Каждая строка рассматривается как потенциальное имя сценария и поддерживает сопоставление с подстановочными знаками.

### System.String[]

Вы можете передать массив имен сценариев или записей метаданных со свойством `Name` в этот командлет для пакетной обработки.

## OUTPUTS

### System.Object

Если указан `-PassThru`, для каждого обработанного сценария возвращается пользовательский объект, содержащий следующие свойства:

- **Name**: название цветового сценария.
- **ScriptPath**: полный путь к исходному цветовому сценарию.
- **CacheFile**: полный путь к созданному файлу кэша.
- **Status**: `Updated`, `SkippedUpToDate`, `SkippedNotRequired`, `SkippedByUser` или `Failed`.
- **Message**: локализованная информация о статусе.
- **CacheExists**: существует ли после операции необработанный файл полезной нагрузки .cache. Значение не указывает на допустимость по политике, действительность или актуальность кэша
- **ExitCode**: код завершения выполнения сценария (0 указывает на успех).
- **StdOut**: стандартный вывод, записываемый во время выполнения сценария.
- **StdErr**: стандартный вывод ошибок, фиксируемый во время выполнения сценария.

Без `-PassThru` записывает краткую информационную сводку, содержащую количество обработанных, обновленных, пропущенных и неудачных операций, а также эффективный каталог кэша.

## NOTES

**Автор:** Ник
**Модуль:** ColorScripts-Enhanced

**Псевдонимы**: `Update-ColorScriptCache` и `Build-ColorScriptCache`.

Файлы кэша хранятся под `(Get-ColorScriptConfiguration).Cache.EffectivePath`. Подписи источника и политики в сопутствующих метаданных используются для определения того, остается ли запись актуальной.

Командлет кэширует только те средства визуализации, которые требуют выполнения и разрешены политикой кэширования. Явные статические или не включенные в список сценарии обозначаются как `SkippedNotRequired`, а устаревшие записи удаляются.

## RELATED LINKS

- [Онлайн-версия](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)

