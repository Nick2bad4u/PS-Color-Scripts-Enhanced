---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: ru
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Восстановите конфигурацию ColorScripts-Enhanced до значений по умолчанию.

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

У этой команды нет псевдонимов.

## DESCRIPTION

`Reset-ColorScriptConfiguration` заменяет сохраненную конфигурацию встроенными настройками по умолчанию и сбрасывает состояние кэша модуля в памяти. При выполнении этот командлет:

- Очищает настроенное переопределение пути кеширования, поэтому используется эффективная платформа по умолчанию.
- Восстанавливает `AutoShowOnImport`, `ProfileAutoShow` и `DefaultScript`.
- Записывает конфигурацию по умолчанию в `config.json`.
- Очищает кэш/состояние конфигурации в памяти, поэтому последующие операции используют значения сброса.

Этот командлет поддерживает параметры `-WhatIf` и `-Confirm`, поскольку он выполняет разрушительную операцию, перезаписывая файл конфигурации. Операцию сброса нельзя отменить автоматически, поэтому перед продолжением пользователям следует рассмотреть возможность резервного копирования текущей конфигурации с помощью `Get-ColorScriptConfiguration`.

Используйте параметр `-PassThru`, чтобы немедленно проверить вновь восстановленные настройки по умолчанию после завершения сброса.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Сбрасывает конфигурацию без запроса подтверждения. Это полезно в автоматизированных сценариях или когда вы уверены в возврате к настройкам по умолчанию.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

Сбрасывает конфигурацию и возвращает полученную хеш-таблицу для проверки, что позволяет проверить значения по умолчанию.

### EXAMPLE 3

```powershell
# Резервное копирование текущей конфигурации перед сбросом
$backup = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
```

Использует `-WhatIf` для предварительного просмотра операции сброса без ее фактического выполнения после резервного копирования текущей конфигурации.

### EXAMPLE 4

```powershell
Reset-ColorScriptConfiguration -Verbose
```

Сбрасывает конфигурацию с подробным выводом для просмотра подробной информации об операции.

### EXAMPLE 5

```powershell
# Сбросьте конфигурацию и очистите кеш для полного сброса настроек.
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "Сброс модуля к заводским настройкам!"
```

Выполняет полный сброс настроек к заводским настройкам, включая настройку, кэш и восстановление кэша.

### EXAMPLE 6

```powershell
# Убедитесь, что сброс прошел успешно
$config = Reset-ColorScriptConfiguration -PassThru
if ($null -eq $config.Cache.Path -and $config.Cache.EffectivePath) {
    Write-Host "Конфигурация успешно сброшена до значений платформы по умолчанию."
} else {
    Write-Host "Сброс конфигурации, но с использованием пользовательского пути: $($config.Cache.Path)"
}
```

Сбрасывает и проверяет, что переопределение постоянного кэша пусто и доступен эффективный путь к платформе.

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

Верните обновленный объект конфигурации после завершения сброса.

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

### -WhatIf

Показывает, что произойдет, если командлет запустится без фактического выполнения операции сброса.

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

### System.Collections.Hashtable

Возвращается, если указан `-PassThru`.

## NOTES

Файл конфигурации хранится в каталоге, разрешенном `Get-ColorScriptConfiguration`. По умолчанию это расположение зависит от платформы:

- **Windows**: `$env:APPDATA\ColorScripts-Enhanced`
- **Linux/macOS**: `$HOME/.config/ColorScripts-Enhanced`

Переменная среды `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` может переопределить местоположение по умолчанию, если она установлена ​​перед импортом модуля.

## RELATED LINKS

- [Онлайн-версия](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)

