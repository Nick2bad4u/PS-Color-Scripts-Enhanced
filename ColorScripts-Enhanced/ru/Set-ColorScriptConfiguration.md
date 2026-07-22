---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: ru
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Сохранять изменения в кэше ColorScripts-Enhanced и конфигурации запуска.

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

У этой команды нет псевдонимов.

## DESCRIPTION

`Set-ColorScriptConfiguration` предоставляет постоянный способ настройки поведения и места хранения модуля ColorScripts-Enhanced. Этот командлет обновляет файл конфигурации модуля, позволяя вам контролировать различные аспекты отрисовки и хранения скриптов.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

Перемещает кеш в `D:/Temp/ColorScriptsCache`, включает автоматическое отображение при импорте модуля, отключает автоматическое отображение профиля и устанавливает `bars` в качестве сценария по умолчанию.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

Очищает сценарий по умолчанию и возвращает результирующий объект конфигурации, позволяя вам убедиться, что параметр был удален.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

Перемещает кэш в каталог Windows TEMP и отображает полную обновленную конфигурацию в формате списка. Полезно для временных сценариев тестирования.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

Отключает автоматический рендеринг цветового сценария при загрузке модуля. Полезно, если вы предпочитаете вручную контролировать отображение сценариев.

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

Устанавливает путь к кэшу в стиле Linux/macOS с использованием расширения тильды и настраивает «crunch» в качестве сценария по умолчанию для всех операций.

## PARAMETERS

### -AutoShowOnImport

Включите или отключите автоматическую отрисовку цветового сценария при импорте модуля. Если этот параметр включен (`$true`), цветовой сценарий отображается сразу после импорта модуля, обеспечивая мгновенную визуальную обратную связь. Если этот параметр отключен (`$false`), сценарии отображаются только при явном вызове. Если не указано, существующая настройка остается неизменной.

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -CachePath

Указывает каталог, в котором хранятся визуализированные полезные данные `.cache` и дополнительные файлы проверки `.cacheinfo`. Исходные цветовые сценарии и метаданные модуля остаются в установленном модуле. Поддерживает абсолютные пути, относительные пути (разрешенные из текущего местоположения), переменные среды (например, `$env:USERPROFILE`) и расширение тильды (`~`).

Если указанный каталог не существует, он будет создан автоматически с соответствующими разрешениями. Укажите пустую строку (`''`), чтобы очистить пользовательский путь и вернуться к расположению по умолчанию для конкретной платформы. Если не указать существующий путь к кэшу, сохраняется.

**Примечание**. Изменение пути к кэшу не приводит к автоматическому переносу существующих кэшированных файлов. Возможно, вам придется скопировать файлы вручную или разрешить их повторное создание.

```yaml
Type: System.String
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

### -DefaultScript

Устанавливает или очищает имя цветового сценария по умолчанию, используемое помощниками профиля, функциями автоматического отображения, а также когда сценарий явно не указан в командах. Оно должно соответствовать базовому имени файла сценария без расширения (например, `'bars'`, а не `'bars.ps1'`).

Укажите пустую строку (`''`), чтобы удалить сохраненное значение по умолчанию и вернуться к поведению по умолчанию на уровне модуля (обычно случайный выбор). Если этот параметр опущен, текущая настройка сценария по умолчанию не изменяется.

Для успешного использования указанный сценарий должен существовать в каталоге сценариев модуля.

```yaml
Type: System.String
DefaultValue: ''
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

### -PassThru

Возвращает обновленный объект конфигурации после внесения изменений. Без этого переключателя командлет работает автоматически (без вывода). Возвращенный объект имеет ту же структуру, что и `Get-ColorScriptConfiguration`, и его можно проверять, сохранять или передавать другим командлетам для дальнейшей обработки.

Полезно для проверки, регистрации или объединения команд конфигурации.

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

### -ProfileAutoShow

Определяет, включают ли фрагменты профиля, созданные `Add-ColorScriptProfile`, автоматический вызов `Show-ColorScript`. Если `$true`, код профиля будет отображать цветной сценарий при каждом запуске оболочки. Если `$false`, профиль будет загружать модуль, но не сценарии автоматического отображения.

Этот параметр влияет только на вновь созданный код профиля; существующие изменения профиля не обновляются автоматически. Если опустить этот параметр, текущая настройка останется неизменной.

```yaml
Type: System.Nullable`1[System.Boolean]
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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Дополнительные сведения см. в разделе
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Этот командлет не принимает входные данные конвейера.

## OUTPUTS

### None (2)

По умолчанию этот командлет не выдает никаких результатов.

### System.Collections.Hashtable

Если указан `-PassThru`, возвращается вложенная хеш-таблица, созданная `Get-ColorScriptConfiguration`: значения кэша находятся под `Cache`, а значения запуска — под `Startup`.

## NOTES

Конфигурация сохраняется только после успешной проверки и подтверждения. `-WhatIf` не выполняет запись в файловую систему. Используйте `Get-ColorScriptConfiguration` для проверки действующих значений и путей хранения после операции.

## RELATED LINKS

- [Онлайн-версия](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)

