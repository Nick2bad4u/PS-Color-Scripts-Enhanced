---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: ru
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

Отображает цветовой сценарий с выборочным кэшированием для дорогих рендереров.

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-ShowInfo] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

### Help

```
Show-ColorScript [-h] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Named

```
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-ShowInfo] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

### List

```
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### All

```
Show-ColorScript [-All] [-WaitForInput] [-NoClear] [-NoCache] [-Category <string[]>]
 [-Tag <string[]>] [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-ShowInfo]
 [-Quiet] [-NoAnsiOutput] [-ValidateCache]
```

## ALIASES

- `scs`

## DESCRIPTION

Отображает цветовые скрипты ANSI в терминале и применяет выборочную оптимизацию производительности только к ресурсоемким рендерерам. Командлет поддерживает четыре основных режима работы:

**Случайный режим (по умолчанию):** отображает случайно выбранный цветовой сценарий из доступной коллекции. Это поведение по умолчанию, когда параметры не указаны.

**Именованный режим:** отображает определенный цветовой сценарий по имени. Поддерживает шаблоны подстановочных знаков для гибкого сопоставления. Если шаблону соответствует несколько сценариев, выбирается первое совпадение в алфавитном порядке.

**Режим списка:** отображает компактную таблицу, содержащую названия цветовых сценариев и основные категории. Используйте `Get-ColorScriptList -AsObject` для полных записей метаданных.

**Режим «Все»:** циклически перебирает все доступные цветовые сценарии в алфавитном порядке. Особенно полезно для демонстрации всей коллекции или открытия новых сценариев.

Для статически извлекаемых встроенных скриптов вывод получает узкий отказоустойчивый вычислитель AST без выполнения самого скрипта. Явно разрешенные встроенные динамические скрипты выполняются в изолированном пространстве выполнения внутри процесса. Неизвестные и пользовательские скрипты выполняются в дочернем процессе, чтобы исключить утечку состояния сеанса. Ни пространство выполнения, ни дочерний процесс не являются изолированной средой безопасности: скрипты выполняются с правами текущего пользователя.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Отображает случайный цветовой скрипт. Вывод статически извлекаемых встроенных скриптов получается без их выполнения, а подходящие вычислительные рендереры могут повторно использовать проверенные кэшированные данные.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Отображает указанный цветовой сценарий по точному имени. Расширение .ps1 не требуется.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Отображает первый цветовой сценарий (в алфавитном порядке), соответствующий шаблону подстановочных знаков «aurora-\*». Полезно, если вы помните часть имени сценария.

### EXAMPLE 4

```powershell
scs hearts
```

Использует псевдоним модуля «scs» для быстрого доступа к цветовому сценарию сердец. Псевдонимы предоставляют удобные ярлыки для частого использования.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Перечисляет доступные цветовые сценарии по имени и основной категории. Полезно для быстрого открытия.

### EXAMPLE 6

```powershell
Show-ColorScript -Name Galaxy -NoCache
```

Отображает подходящий модуль рендеринга Galaxy без чтения кэшированных выходных данных, что приводит к новому изолированному рендерингу. Полезно при тестировании изменений средства рендеринга или исследовании повреждения кэша.

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

Отображает случайный сценарий на тему природы и записывает его объект метаданных для дальнейшей проверки или обработки.

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

Отображает цветовой сценарий и сохраняет выходные данные в текстовый файл. Отображенные коды ANSI сохраняются, что позволяет позже отобразить файл с правильной окраской.

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

Отображает все цветовые сценарии в алфавитном порядке с небольшой автоматической задержкой между ними. Идеально подходит для визуальной демонстрации всей коллекции.

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

Отображает все цветовые сценарии по одному, делая паузу после каждого. Нажмите пробел, чтобы перейти к следующему сценарию, или нажмите «q», чтобы досрочно завершить последовательность.

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

Циклическое переключение всех цветовых сценариев на тему природы с ручным развитием. Сочетает в себе фильтрацию и интерактивный просмотр для тщательно подобранного опыта.

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

Отображает случайный цветовой сценарий с тегом «ретро» или «геометрический». Несколько значений тега используют семантику любого совпадения.

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Artistic,Abstract
```

Перечисляет только цветовые сценарии, отнесенные к категориям «Искусство» или «Абстракция», что помогает вам находить сценарии в рамках определенных тем.

### EXAMPLE 14

```powershell
# Проверьте возможность кэширования и статус сборки для выбранного в соответствии с политикой средства визуализации.
New-ColorScriptCache -Name Galaxy -Force -PassThru |
    Select-Object Name, Status, CacheFile
Show-ColorScript -Name Galaxy
```

Создает и проверяет запись кэша на наличие подходящего средства визуализации, не требуя машинно-независимого множителя производительности.

### EXAMPLE 15

```powershell
# Настройте ежедневную ротацию различных цветовых сценариев.
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

Отображает единый, но разный цветовой сценарий каждый день в зависимости от даты.

### EXAMPLE 16

```powershell
# Экспортируйте обработанный цветовой сценарий в файл для совместного использования.
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Позже отобразить сохраненный файл
Get-Content "./aurora.ansi" -Raw | Write-Host
```

Сохраняет визуализированный цветовой сценарий в файл, который можно отобразить позже или поделиться с другими.

### EXAMPLE 17

```powershell
# Создайте слайд-шоу из геометрических цветовых сценариев.
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

Автоматически отображает последовательность геометрических цветовых сценариев с 3-секундной задержкой между каждым.

### EXAMPLE 18

```powershell
# Пример обработки ошибок
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Сценарий не найден: $_"
    Show-ColorScript  # Возврат к случайному выбору
}
```

Демонстрирует обработку ошибок при запросе несуществующего сценария.

### EXAMPLE 19

```powershell
# Интеграция автоматизации сборки
if ($env:CI) {
    Show-ColorScript -Name "Galaxy" -NoCache
} else {
    Show-ColorScript  # Случайное отображение для интерактивного использования
}
```

Показывает, как условно отображать различные цветовые сценарии в средах CI/CD по сравнению с интерактивными сеансами.

### EXAMPLE 20

```powershell
# Запланированная задача для приветствия терминала
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

Демонстрирует запуск определенного цветового сценария как часть запланированной задачи или автоматизации запуска.

### EXAMPLE 21

```powershell
Show-ColorScript -IncludePokemon
```

Демонстрирует устаревший параметр совместимости. В течение одного выпуска он принимается без сообщений и не выполняет действий, поскольку сценарии Pokémon и ShinyPokemon уже участвуют в обычном выборе.

### EXAMPLE 22

```powershell
Show-ColorScript -Random -ExcludeCategory Pokemon,ShinyPokemon
```

Отображает случайный цветовой сценарий, исключая обе категории Pokémon. Объедините с `-Category` или `-Tag`, чтобы уточнить выбор.

### EXAMPLE 23

```powershell
Show-ColorScript -Random -ShowInfo
```

Отображает случайный цветовой сценарий, а затем записывает его имя и полный путь в информационный поток. Используйте `-Quiet`, чтобы подавить строку идентификации.

## PARAMETERS

### -All

Перебирайте все доступные цветовые сценарии в алфавитном порядке. Если указано отдельно, сценарии отображаются непрерывно с небольшой автоматической задержкой. Объедините с `-WaitForInput`, чтобы вручную контролировать ход сбора коллекции. Этот режим идеально подходит для демонстрации всей библиотеки или открытия новых фаворитов.

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

### -Category

Отфильтруйте доступную коллекцию сценариев по одной или нескольким категориям, прежде чем произойдет какой-либо выбор или отображение. Категории обычно представляют собой широкие темы, такие как «Природа», «Абстракция», «Искусство», «Ретро» и т. д. В виде массива можно указать несколько категорий. Этот параметр работает совместно со всеми режимами (Случайный, Именованный, Список, Все) для сужения рабочего набора.

```yaml
Type: System.String[]
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

### -ExcludeCategory

Прежде чем произойдет выбор, исключите сценарии из одной или нескольких категорий. Например, используйте `-ExcludeCategory Pokemon,ShinyPokemon`, чтобы исключить все сценарии Pokémon, или укажите любое другое сочетание категорий. Работает во всех режимах (Случайный, По имени, Список, Все) и сочетается с фильтрами `-Category` и `-Tag`.

```yaml
Type: System.String[]
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
DefaultValue: False
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

Устаревший параметр совместимости. В течение одного выпуска он принимается без сообщений и не выполняет действий, поскольку цветовые сценарии Pokémon и ShinyPokemon уже участвуют в обычном выборе. Для исключения используйте `-ExcludeCategory Pokemon,ShinyPokemon`.

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

### -List

Отображение форматированного списка всех доступных цветовых сценариев со связанными с ними метаданными. Вывод включает имя сценария, категорию, теги и описание. Это полезно для изучения доступных опций и понимания организации коллекции. Можно комбинировать с `-Category` или `-Tag` для отображения только отфильтрованных подмножеств.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: List
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

Имя отображаемого цветового сценария (без расширения .ps1). Поддерживает шаблоны подстановочных знаков (\* и ?) для гибкого сопоставления. Если несколько сценариев соответствуют шаблону подстановочных знаков, выбирается и отображается первое совпадение в алфавитном порядке. Используйте `-PassThru`, чтобы проверить, какой сценарий был выбран при использовании подстановочных знаков.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Named
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
DefaultValue: False
SupportsWildcards: false
Aliases:
- NoColor
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

### -NoCache

Обходит проверенное чтение кэша для выбранных политикой рендереров и принудительно выполняет новую изолированную визуализацию. Это полезно при тестировании изменений рендерера или исследовании повреждения кэша. Статически извлекаемые встроенные скрипты, а также скрипты вне политики и пользовательские скрипты изначально не используют кэш. Статически извлекаемое встроенное содержимое по-прежнему получается без выполнения скрипта.

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

### -NoClear

При использовании с `-All` пропустите автоматический вызов `Clear-Host` между цветовыми сценариями, чтобы каждый отображаемый сценарий оставался видимым над следующим. Это особенно полезно, когда вы хотите параллельно сравнить сценарии или зафиксировать всю демонстрацию в стенограммах сеанса.

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

### -PassThru

Верните объект метаданных выбранного цветового сценария в конвейер в дополнение к отображению цветового сценария. Объект метаданных содержит такие свойства, как имя, путь, категория, теги и описание. Это обеспечивает программный доступ к информации сценария для фильтрации, регистрации или дальнейшей обработки, сохраняя при этом визуальный вывод.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Named
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

### -Random

Явно запрашивайте случайный выбор цветового сценария. Это поведение по умолчанию, когда имя не указано, поэтому этот переключатель в первую очередь полезен для ясности в сценариях или когда вы хотите явно указать режим выбора. Можно комбинировать с `-Category` или `-Tag` для рандомизации внутри отфильтрованного подмножества.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ReturnText

Отправьте обработанный цветовой сценарий в виде строки в конвейер PowerShell вместо записи непосредственно на хост консоли. Это позволяет записывать выходные данные в переменную, перенаправлять их в файл или передавать по конвейеру другим командам. В выводе сохраняются все escape-последовательности ANSI, поэтому при последующей записи на совместимый терминал он будет отображаться с правильными цветами.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- AsString
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

### -ShowInfo

После отображения каждого выбранного цветового сценария записывает в информационный поток одну краткую строку с именем сценария и полным путем. `-Quiet` подавляет эту строку. `-ReturnText` не включает ее, а `-PassThru` по-прежнему возвращает структурированные метаданные.

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
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Named
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

Отфильтруйте доступную коллекцию скриптов по тегам метаданных (без учета регистра). Теги — это более конкретные дескрипторы, чем категории, такие как «геометрический», «ретро», «анимированный», «минималистичный» и т. д. В виде массива можно указать несколько тегов. Скрипты, соответствующие любому из указанных тегов, будут включены в рабочий набор до того, как произойдет выбор.

```yaml
Type: System.String[]
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

### -ValidateCache

Обновляет маркер метаданных кэша уровня модуля перед рендерингом, в том числе, когда каталог кэша уже был инициализирован в текущем сеансе модуля. Он не перестраивает записи выходного кэша и не заменяет обычную проверку каждой записи. Установка `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE` в `1`, `true` или `yes` требует того же обновления во время инициализации кэша.

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

### -WaitForInput

При использовании с `-All` делайте паузу после отображения каждого цветового сценария и ждите ввода пользователя, прежде чем продолжить. Нажмите пробел, чтобы перейти к следующему сценарию в последовательности. Нажмите «q», чтобы досрочно выйти из последовательности и вернуться к подсказке. Это обеспечивает интерактивный просмотр всей коллекции.

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

### CommonParameters

Этот командлет поддерживает следующие общие параметры:
Дополнительные сведения см. в разделе
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Этот командлет не принимает входные данные конвейера. Записи инвентаризации труб в `ForEach-Object` и вызов `Show-ColorScript -Name $_.Name` при составлении трубопровода.

## OUTPUTS

### System.Object

Если указан `-PassThru`, возвращается объект метаданных выбранного цветового сценария, содержащий такие свойства, как имя, путь, категория, теги и описание.

### System.String (2)

Если указан `-ReturnText`, визуализируемый цветовой сценарий передается в конвейер в виде строки. Эта строка содержит все escape-последовательности ANSI для правильной цветопередачи при отображении на совместимом терминале.

### None

При работе по умолчанию (без `-PassThru` или `-ReturnText`) выходные данные записываются непосредственно на хост консоли, и в конвейер ничего не возвращается.

## NOTES

**Автор:** Ник
**Модуль:** ColorScripts-Enhanced
**Требуется:** PowerShell 5.1 или более поздней версии.

## RELATED LINKS

- [Онлайн-версия](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

