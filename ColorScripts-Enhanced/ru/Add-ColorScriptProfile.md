---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ru/Add-ColorScriptProfile.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Add-ColorScriptProfile

## SYNOPSIS

Добавляет интеграцию ColorScripts-Enhanced в файлы профилей PowerShell.

## SYNTAX

```
Add-ColorScriptProfile [[-Scope] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Автоматически добавляет интеграцию запуска ColorScripts-Enhanced в ваш профиль PowerShell. Этот командлет изменяет ваши файлы профилей для импорта модуля ColorScripts-Enhanced и опционально отображает colorscript при запуске сессии.

Командлет поддерживает все стандартные области профилей PowerShell:
- CurrentUserCurrentHost: Профиль для текущего пользователя и текущего хоста
- CurrentUserAllHosts: Профиль для текущего пользователя во всех хостах
- AllUsersCurrentHost: Профиль для всех пользователей на текущем хосте (требует прав администратора)
- AllUsersAllHosts: Профиль для всех пользователей во всех хостах (требует прав администратора)

При выполнении добавляется фрагмент, который:
1. Импортирует модуль ColorScripts-Enhanced
2. Опционально отображает случайный colorscript при запуске
3. Предоставляет полезные псевдонимы для быстрого доступа

Интеграция разработана как ненавязчивая и может быть легко удалена путем прямого редактирования файлов профилей.

## EXAMPLES

### EXAMPLE 1

```powershell
Add-ColorScriptProfile
```

Добавляет интеграцию ColorScripts-Enhanced в ваш профиль по умолчанию (CurrentUserCurrentHost).

### EXAMPLE 2

```powershell
Add-ColorScriptProfile -Scope CurrentUserAllHosts
```

Добавляет интеграцию в ваш профиль, который применяется ко всем хостам PowerShell для текущего пользователя.

### EXAMPLE 3

```powershell
Add-ColorScriptProfile -Scope AllUsersCurrentHost
```

Добавляет интеграцию в профиль для всех пользователей на текущем хосте (требует привилегий администратора).

### EXAMPLE 4

```powershell
Add-ColorScriptProfile -WhatIf
```

Показывает, какие изменения будут внесены в ваш профиль, без фактического применения их.

### EXAMPLE 5

```powershell
Add-ColorScriptProfile -Confirm
```

Запрашивает подтверждение перед изменением вашего профиля.

## PARAMETERS

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

### -Scope

Указывает область профиля для изменения. Допустимые значения:
- CurrentUserCurrentHost (по умолчанию)
- CurrentUserAllHosts
- AllUsersCurrentHost
- AllUsersAllHosts

```yaml
Type: System.String
DefaultValue: CurrentUserCurrentHost
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

Показывает, что произойдет, если командлет будет выполнен. Командлет не выполняется.

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
**Requires:** PowerShell 5.1 или более поздней версии

**Profile Integration:**
Командлет добавляет фрагмент запуска, который импортирует ColorScripts-Enhanced и обеспечивает удобный доступ. Интеграция разработана как легковесная и ненавязчивая.

**Scope Considerations:**
- Области CurrentUser изменяют файлы в вашем каталоге профиля пользователя
- Области AllUsers требуют привилегий администратора и влияют на всех пользователей
- Изменения вступают в силу в новых сессиях PowerShell

**Safety Features:**
- Проверяет наличие существующей интеграции, чтобы избежать дублирования
- Использует стандартные механизмы профилей PowerShell
- Предоставляет опции WhatIf и Confirm для безопасной работы

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
