---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: ru
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Добавляет или обновляет управляемый блок запуска ColorScripts-Enhanced в файле профиля PowerShell.

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

У этой команды нет псевдонимов.

## DESCRIPTION

Добавляет управляемый блок запуска в выбранный профиль PowerShell. Блок импортирует ColorScripts-Enhanced и может вызывать `Show-ColorScript` после импорта. `-SkipStartupScript` записывает блок только для импорта.

Если `-ProfilePath` опущен, команда предпочитает `$PROFILE.CurrentUserAllHosts`, а в противном случае использует первый определенный путь к профилю. Файл профиля и отсутствующие родительские каталоги создаются при необходимости.

Существующие управляемые или устаревшие блоки ColorScripts-Enhanced заменяются, а не дублируются. Если профиль уже импортирует модуль за пределы управляемого блока, команда оставляет его неизменным, если не указано `-Force`. `-Force` позволяет заменять распознанное содержимое модуля, сохраняя несвязанное содержимое профиля.

Сгенерированное поведение при запуске решается на основе явных параметров и сохраненной конфигурации. `-AutoShow` явно включает отображение, `-DefaultStartupScript` выбирает именованный сценарий, а включение покемонов может быть задано напрямую или разрешено с помощью интерактивной подсказки и ее документированных переопределений. Если не используется `-SkipCacheBuild`, команда может предварительно разогревать записи кэша, выбранные политикой, после обновления профиля.

## EXAMPLES

### EXAMPLE 1

Добавить в профиль текущего пользователя для всех хостов (поведение по умолчанию).

```powershell
Add-ColorScriptProfile
```

При этом вызов `Show-ColorScript` и импорт модуля добавляются в `$PROFILE.CurrentUserAllHosts`.

### EXAMPLE 2

Добавлять в профиль текущего пользователя только для текущего хоста, без сценария запуска.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost -SkipStartupScript
```

Это добавляет управляемый блок, предназначенный только для импорта, в профиль текущего хоста.

### EXAMPLE 3

Добавьте в пользовательский путь к профилю с расширением переменной среды.

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

Это нацелено на определенный файл профиля, находящийся за пределами стандартных местоположений профилей PowerShell.

### EXAMPLE 4

Принудительно повторно добавьте фрагмент, даже если он уже существует.

```powershell
Add-ColorScriptProfile -Force
```

При этом обновляется распознанное содержимое профиля ColorScripts-Enhanced, сохраняя при этом несвязанные линии профиля.

### EXAMPLE 5

Настройка на новой машине — при необходимости создайте профиль и добавьте ColorScripts на все хосты.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts -Confirm:$false
Write-Host "Профиль настроен! Перезагрузите терминал, чтобы увидеть цветные сценарии при запуске."
```

### EXAMPLE 6

Добавьте определенный цветовой сценарий для отображения при запуске:

```powershell
Add-ColorScriptProfile -DefaultStartupScript mandelbrot-zoom -AutoShow
```

### EXAMPLE 7

Убедитесь, что профиль добавлен правильно:

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Явно укажите профиль текущего хоста или всех хостов:

```powershell
# Только для терминала Windows или ConEmu
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost

# Для всех хостов PowerShell (ISE, VSCode, Console)
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts
```

### EXAMPLE 9

Использование относительных путей и расширения тильды:

```powershell
# Использование расширения тильды для домашнего каталога
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# Использование относительного пути текущего каталога
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

Ежедневно отображайте различные цветовые сценарии, добавляя собственную логику:

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Затем добавьте это в $PROFILE вручную:
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

### EXAMPLE 11

Автоматически пропускать скрипты Pokémon при показе заставки:

```powershell
Add-ColorScriptProfile -IncludePokemon
```

При этом к профилю добавляется `Show-ColorScript -IncludePokemon` (обёрнутый защитным блоком try/catch), поэтому изображение при запуске может включать сценарии Pokémon.

## PARAMETERS

### -AutoShow

Определяет, отображает ли блок управляемого профиля цветной сценарий после импорта модуля.

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

### -DefaultStartupScript

Указывает имя цветового сценария, записываемое в блок управляемого профиля для отображения при запуске.

```yaml
Type: System.String
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

### -Force

Обновляет распознанное содержимое ColorScripts-Enhanced в профиле, сохраняя несвязанные строки. Команда намеренно не добавляет повторяющиеся управляемые блоки.

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

### -h

Отображает справочную информацию для этого командлета. Эквивалентно использованию `Get-Help Add-ColorScriptProfile`.

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

### -IncludePokemon

Добавьте `-IncludePokemon` к сгенерированному вызову `Show-ColorScript`, чтобы цветовые сценарии Pokémon включались при запуске, если они есть. Игнорируется при использовании `-SkipStartupScript`.

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

### -PokemonPromptResponse

Предварительно ответьте на запрос о включении покемонов. Принимает Да/Да или Нет/Нет. Также учитывается переменная среды
`COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE` и глобальная переменная
`$Global:ColorScriptsEnhancedPokemonPromptResponse`.

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

### -ProfilePath

Указывает файл профиля PowerShell для обновления. Псевдоним Path также принимается.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Path
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

### -SkipCacheBuild

Подавить дополнительный предварительный разогрев кэша. Предварительный прогрев предпринимается только в том случае, если решена проблема `ProfileAutoShow`.
параметр включен, построение кэша иначе не отключено, целевой профиль находится за пределами
системный временный каталог, и операция одобрена `ShouldProcess`. Командование также уважает
переменная среды `COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` и глобальная переменная
`$Global:ColorScriptsEnhancedSkipCacheBuild`.

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

### -SkipPokemonPrompt

Пропустите интерактивный запрос, в котором спрашивается, включать ли цветовые сценарии Pokémon при запуске.

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

### -SkipStartupScript

Пропустите добавление `Show-ColorScript` в профиль. Добавляется только строка `Import-Module ColorScripts-Enhanced`. Используйте это, если вы хотите вручную контролировать отображение цветовых сценариев.

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

Показывает, что произойдет, если командлет запустится. Командлет не запускается.

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

### System.Object

Возвращает пользовательский объект со следующими свойствами:

- **Path** (строка): полный путь к выбранному файлу профиля.
- **Changed** (bool): был ли профиль действительно изменен.
- **Message** (строка): сообщение о состоянии, описывающее результат операции.
- **IncludePokemon** (bool): выбор включения покемонов при запуске.
- **CacheBuilt** (bool): завершен ли дополнительный прогрев кэша.

## NOTES

**Автор:** Ник

**Модуль:** ColorScripts-Enhanced

**Требуется:** PowerShell 5.1 или более поздней версии.

Файл профиля создается автоматически, если он не существует, включая необходимые родительские каталоги. Команда управляет путями к файлам, указанными пользователем; он не предоставляет отдельный селектор области.

## RELATED LINKS

- [Онлайн-версия](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)

