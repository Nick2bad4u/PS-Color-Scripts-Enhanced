---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ru/Reset-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Сбрасывает конфигурацию ColorScripts-Enhanced к значениям по умолчанию.

## SYNTAX

```
Reset-ColorScriptConfiguration [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Восстанавливает настройки конфигурации ColorScripts-Enhanced к их значениям по умолчанию. Этот командлет удаляет все пользовательские настройки и возвращает модуль к его исходному состоянию конфигурации.

Операции сброса включают:
- Настройки пути кэша
- Предпочтения производительности
- Параметры отображения
- Настройки поведения модуля

Этот командлет полезен, когда:
- Конфигурация становится поврежденной
- Вы хотите начать заново с настройками по умолчанию
- Устранение неполадок, связанных с конфигурацией
- Подготовка к чистому тестированию модуля

Операция сброса по умолчанию требует подтверждения, чтобы предотвратить случайную потерю данных.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration
```

Сбрасывает все настройки конфигурации к значениям по умолчанию с запросом подтверждения.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Сбрасывает конфигурацию без запроса подтверждения.

### EXAMPLE 3

```powershell
Reset-ColorScriptConfiguration -WhatIf
```

Показывает, какие изменения конфигурации будут сделаны, без применения их.

### EXAMPLE 4

```powershell
# Сброс и проверка
Reset-ColorScriptConfiguration
Get-ColorScriptConfiguration
```

Сбрасывает конфигурацию и отображает новые настройки по умолчанию.

## PARAMETERS

### -Confirm

Запрашивает подтверждение перед выполнением командлета.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: true
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

Показывает, что произойдет, если командлет выполнится. Командлет не выполняется.

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

**Автор:** Nick
**Модуль:** ColorScripts-Enhanced
**Требуется:** PowerShell 5.1 или новее

**Область сброса:**
Сбрасывает все настраиваемые пользователем настройки к значениям по умолчанию модуля. Это включает пути кэша, настройки производительности и предпочтения отображения.

**Безопасность данных:**
Сброс конфигурации не влияет на кэшированный вывод скриптов или созданные пользователем цветные скрипты. Затрагиваются только настройки конфигурации.

**Восстановление:**
После сброса используйте Set-ColorScriptConfiguration для повторного применения пользовательских настроек, если необходимо.

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
