---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ru/Set-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Изменяет настройки конфигурации ColorScripts-Enhanced.

## SYNTAX

```
Set-ColorScriptConfiguration [-CachePath <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Обновляет настройки конфигурации ColorScripts-Enhanced с постоянным хранением. Этот командлет позволяет настраивать поведение модуля через пользовательские параметры.

Настраиваемые параметры включают:
- Расположение каталога кэша
- Предпочтения оптимизации производительности
- Поведение отображения по умолчанию
- Настройки работы модуля

Изменения автоматически сохраняются в пользовательские файлы конфигурации и сохраняются между сеансами PowerShell. Используйте Get-ColorScriptConfiguration для просмотра текущих настроек.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath "C:\MyCache"
```

Устанавливает пользовательский путь к каталогу кэша.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -CachePath $env:TEMP
```

Использует системный временный каталог для хранения кэша.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "~/.colorscript-cache"
```

Устанавливает путь кэша с использованием нотации домашнего каталога в стиле Unix.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -WhatIf
```

Показывает, какие изменения конфигурации будут внесены без их применения.

### EXAMPLE 5

```powershell
# Backup current config, modify, then restore if needed
$currentConfig = Get-ColorScriptConfiguration
Set-ColorScriptConfiguration -CachePath "D:\Cache"
# ... test new configuration ...
# Set-ColorScriptConfiguration -CachePath $currentConfig.CachePath
```

Демонстрирует резервное копирование и восстановление конфигурации.

## PARAMETERS

### -CachePath

Указывает путь к каталогу, где будут храниться файлы кэша colorscript.

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

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

**Сохранение конфигурации:**
Настройки автоматически сохраняются в пользовательские файлы конфигурации и сохраняются между сеансами PowerShell.

**Разрешение путей:**
Пути кэша поддерживают переменные среды, относительные пути и стандартную нотацию путей PowerShell.

**Проверка:**
Изменения конфигурации проверяются перед применением для предотвращения недопустимых настроек.

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
