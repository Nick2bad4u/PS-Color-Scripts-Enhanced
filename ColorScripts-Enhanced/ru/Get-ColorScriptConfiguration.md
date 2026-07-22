---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: ru
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Получает текущие настройки конфигурации модуля ColorScripts-Enhanced.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

У этой команды нет псевдонимов.

## DESCRIPTION

`Get-ColorScriptConfiguration` возвращает копию действующей конфигурации модуля. Текущая схема содержит:

- **Настройки кэша**: настроенный переопределенный и разрешенный эффективный каталог кэша.
- **Поведение при запуске**: `AutoShowOnImport`, `ProfileAutoShow` и `DefaultScript`.

Конфигурация собирается из нескольких источников в порядке приоритета:

1. Настройки встроенного модуля по умолчанию (самый низкий приоритет)
2. Сохраняемые пользовательские переопределения из файла конфигурации.
3. `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` для возвращаемого эффективного пути к кэшу.

Файл конфигурации обычно находится по адресу `%APPDATA%\ColorScripts-Enhanced\config.json` в Windows или `~/.config/ColorScripts-Enhanced/config.json` в Unix-подобных системах.

Возвращенная хэш-таблица представляет собой снимок текущего состояния конфигурации, и ее можно безопасно проверять, клонировать или сериализовать, не затрагивая активную конфигурацию.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Отображает текущую конфигурацию с использованием табличного представления по умолчанию, показывая все параметры кэша и запуска.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Сериализует конфигурацию в формат JSON для ведения журнала, отладки или экспорта в другие инструменты.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.EffectivePath
```

Получает разрешенный каталог кэша. `Cache.Path` остается необязательным переопределением, настраиваемым пользователем;
`Cache.EffectivePath` показывает каталог, который модуль фактически использует после настроек платформы по умолчанию и
применяются переопределения среды.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.AutoShowOnImport) {
    Write-Host "Сценарии запуска включены"
}
```

Проверяет, включены ли сценарии запуска в текущей конфигурации.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Отображает все свойства конфигурации в формате подробного списка для всесторонней проверки.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Путь к кэшу: $($config.Cache.Path)"
Write-Host "Автопоказ профиля: $($config.Startup.ProfileAutoShow)"
Write-Host "Скрипт по умолчанию: $($config.Startup.DefaultScript)"
```

Извлекает и отображает определенные свойства конфигурации для целей аудита или сценариев.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Настроен пользовательский путь кеширования: $($config.Cache.Path)."
} else {
    Write-Host "Использование пути к кэшу по умолчанию"
}

Write-Host "Эффективный путь кеширования: $($config.Cache.EffectivePath)."
```

Определяет, настроен ли пользовательский путь кеширования или используются значения модуля по умолчанию.

### EXAMPLE 8

```powershell
$config = Get-ColorScriptConfiguration
$config | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Создает резервную копию текущей конфигурации в файл JSON для архивирования или аварийного восстановления.

### EXAMPLE 9

```powershell
# Сравните текущую конфигурацию со значениями по умолчанию
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Просмотрите выходные данные -WhatIf, чтобы узнать, что изменится.
```

Сравнивает текущую конфигурацию со значениями модуля по умолчанию для определения пользовательских настроек.

### EXAMPLE 10

```powershell
# Отслеживание изменений конфигурации между сеансами
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Создает снимки конфигурации с отметкой времени для отслеживания изменений с течением времени.

## PARAMETERS

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

### CommonParameters

Этот командлет поддерживает следующие общие параметры:
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Дополнительные сведения см. в разделе
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Этот командлет не принимает входные данные конвейера.

## OUTPUTS

### System.Collections.Hashtable

Возвращает вложенную хеш-таблицу, содержащую следующую структуру:

- **Cache** (хэш-таблица): настройки, связанные с кешем.
- **Path** (строка): необязательное переопределение пути к постоянному кэшу.
- **EffectivePath** (String): разрешенный каталог кэша, используемый в данный момент модулем.
- **Startup** (хэш-таблица): настройки поведения при запуске.
- **AutoShowOnImport** (логическое значение): вызывает ли импорт поведение отображения при запуске.
- **ProfileAutoShow** (логическое значение): выбор автоматического отображения по умолчанию для блоков управляемого профиля.
- **DefaultScript** (строка): необязательный именованный цветовой сценарий запуска.

## NOTES

**Инициализация модуля**: конфигурация инициализируется автоматически при загрузке модуля ColorScripts-Enhanced. Этот командлет извлекает текущее состояние конфигурации в памяти.

**Без изменений**: вызов этого командлета доступен только для чтения и не изменяет никакие сохраненные параметры или активную конфигурацию.

**Потокобезопасность**: возвращаемая хэш-таблица представляет собой копию конфигурации, что делает ее безопасной для одновременного доступа и изменения, не затрагивая внутреннее состояние модуля.

**Производительность**: получение конфигурации является упрощенным и подходит для частых вызовов, поскольку возвращает кэшированную конфигурацию в памяти, а не считывает с диска.

**Формат файла конфигурации**. Сохраняемая конфигурация использует формат JSON с кодировкой UTF-8. Редактирование вручную поддерживается, но не рекомендуется; вместо этого используйте `Set-ColorScriptConfiguration`.

### Рекомендации

- Запросить конфигурацию один раз и повторно использовать результат
- Проверка конфигурации перед использованием значений.
- Мониторинг конфигурации на предмет дрейфа с течением времени
- Сохраняйте резервные копии только там, где они не могут раскрыть пути, специфичные для машины, или личные данные.
- Документируйте любые изменения, внесенные в конфигурацию.
- Сначала протестируйте изменения конфигурации в непроизводственной среде.
- Используйте журналы аудита конфигурации для обеспечения соответствия.

## RELATED LINKS

- [Онлайн-версия](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

