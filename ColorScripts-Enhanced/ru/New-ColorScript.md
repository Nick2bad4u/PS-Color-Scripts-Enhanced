---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: ru
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

Создайте новый файл цветного сценария и, при необходимости, создайте руководство по метаданным.

## SYNTAX

### Scaffold

```
New-ColorScript -Name <string> -OutputPath <string> [-h] [-Force] [-GenerateMetadataSnippet]
 [-Category <string[]>] [-Tag <string[]>] [-OpenInEditor] [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScript [-h] [-Name <string>] [-WhatIf] [-Confirm]
```

## ALIASES

У этой команды нет псевдонимов.

## DESCRIPTION

Командлет `New-ColorScript` создает минимальный шаблон цветового сценария, содержащий массив строк и цикл, записывающий каждую строку. Файл имеет кодировку UTF-8 без метки порядка байтов (BOM). Дополнительное руководство по метаданным можно включить в виде комментария в сгенерированный файл и вернуть в объект результата.

Оба `-Name` и `-OutputPath` являются обязательными при создании строительных лесов. `-OutputPath` идентифицирует каталог; команда создает каталог при необходимости и записывает в него `<Name>.ps1`.

Имена сценариев должны соответствовать соглашениям об именах PowerShell: они должны начинаться с буквенно-цифрового символа и могут включать символы подчеркивания или дефисы. Расширение `.ps1` добавляется автоматически, если оно не указано. Существующие файлы защищены от случайной перезаписи, если явно не указан переключатель `-Force`.

В сочетании с `-GenerateMetadataSnippet` командлет возвращает руководство с описанием записи, которую нужно добавить в `ScriptMetadata.psd1`. Предоставленные значения категорий и тегов также возвращаются в виде массивов в объекте результата.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -OutputPath ./ColorScripts-Enhanced/Scripts -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

Создает `my-spectrum.ps1` в запрошенном каталоге и возвращает объект, содержащий путь к файлу и руководство по метаданным.

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

Создает шаблон в пользовательском каталоге (`~/Dev/colorscripts`), создавая каталог, если он не существует. Если файл с именем `holiday-banner.ps1` уже существует в этом месте, он будет перезаписан из-за переключателя `-Force`.

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -OutputPath ./ColorScripts-Enhanced/Scripts -Category 'Artistic' -Tag '80s','Neon' -GenerateMetadataSnippet
$result.MetadataGuidance | Set-Clipboard
```

Создает новый цветовой сценарий и копирует руководство по метаданным в буфер обмена, что упрощает вставку в `ScriptMetadata.psd1`.

### EXAMPLE 4

```powershell
New-ColorScript -Name 'test-pattern' -OutputPath '.\temp' -WhatIf
```

Показывает, что произойдет при создании сценария тестового шаблона в каталоге `.\temp` без фактического создания файла. Полезно для проверки путей и имен перед выполнением.

### EXAMPLE 5

```powershell
# Создание нескольких цветовых сценариев для проекта
$scriptNames = @("company-logo", "team-banner", "status-display")
foreach ($name in $scriptNames) {
    New-ColorScript -Name $name -Category "Corporate" -Tag "Custom" -OutputPath ".\src" | Out-Null
}
Write-Host "Создано $($scriptNames.Count) шаблонов цветных сценариев."
```

Пакетное создание нескольких шаблонов цветовых сценариев для проекта.

### EXAMPLE 6

```powershell
# Создать и сразу открыть в редакторе
New-ColorScript -Name "my-art" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -GenerateMetadataSnippet -OpenInEditor
```

Создает цветовой сценарий и просит зарегистрированного обработчика платформы открыть его.

### EXAMPLE 7

```powershell
# Создавайте с полной автоматизацией рабочих процессов
$newScript = New-ColorScript -Name "interactive-demo" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Custom" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "Создано: $($newScript.Name)"
Write-Host "Путь: $($newScript.Path)"
Write-Host "Руководство по метаданным готово в буфере обмена"
$newScript.MetadataGuidance | Set-Clipboard
```

Создает цветовой сценарий с указаниями по метаданным, автоматически копируемыми в буфер обмена.

### EXAMPLE 8

```powershell
# Проверьте соглашения об именах сценариев.
$validName = "123-start"
$invalidNames = @("-invalid", "_underscore-only", "contains space")
foreach ($name in $invalidNames) {
    try {
        New-ColorScript -Name $name -OutputPath ./temp -WhatIf -ErrorAction Stop
    } catch {
        Write-Warning "Неверное имя «$name»: $_."
    }
}
```

Демонстрирует проверку соглашения об именах для цветовых сценариев.

### EXAMPLE 9

```powershell
# Создать в переносном месте для распространения
$portableDir = Join-Path $PSScriptRoot "colorscripts"
$scaffold = New-ColorScript -Name "portable-art" -OutputPath $portableDir -GenerateMetadataSnippet
Write-Host "Создан переносимый цветовой сценарий по адресу: $($scaffold.Path)."
```

Создает цветовые сценарии в переносимом месте относительно текущего сценария.

### EXAMPLE 10

```powershell
# Создать с проверкой категорий и тегов
$categories = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Category -Unique
if ("Retro" -in $categories) {
    New-ColorScript -Name "retro-party" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -Tag "Fun","Social"
} else {
    Write-Warning "Категория ретро не найдена"
}
```

Проверяет существование категории перед созданием нового цветового сценария.

## PARAMETERS

### -Category

Указывает одну или несколько категорий, возвращаемых вместе с шаблоном и включенных в руководство по метаданным. Значения должны соответствовать категориям, уже использованным в `ScriptMetadata.psd1`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

### -Force

Перезаписывает целевой файл, если он уже существует. Без этого параметра командлет завершится с ошибкой, если в целевом расположении будет найден файл с таким же именем. Используйте с осторожностью, чтобы избежать потери данных.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Overwrite
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GenerateMetadataSnippet

В выходные данные включает фрагмент руководства, демонстрирующий, как зарегистрировать новый скрипт в `ScriptMetadata.psd1`. Фрагмент использует значения параметров `-Category` и `-Tag`, если они предусмотрены. Это особенно полезно для поддержания согласованности метаданных во всех цветовых сценариях в модуле.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

Указывает имя нового цветового сценария. Имя должно начинаться с буквенно-цифрового символа и может включать символы подчеркивания или дефисы. Расширение `.ps1` добавляется автоматически, если оно не включено. Это имя будет использоваться в качестве имени файла и должно описывать содержимое или тему сценария.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Help
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OpenInEditor

Открывает сгенерированный цветной сценарий с помощью команды, настроенной средой, в случае успешного создания.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputPath

Задает обязательный целевой каталог. Команда создает в нем файл <Name>.ps1.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Destination
- Path
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

Указывает один или несколько тегов метаданных для цветового сценария. Теги обеспечивают дополнительную классификацию помимо основной категории и полезны для фильтрации и поиска. Общие теги включают дескрипторы тем, такие как «Минимальный», «Красочный», «Анимированный», ссылки на технологии, такие как «Матрица», «ASCII», или контекстные маркеры, такие как «Праздник», «Сезон». Несколько тегов можно указать в виде массива, разделенного запятыми.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

Показывает, что произойдет, если командлет запустится, фактически не выполняя никаких действий. Отображает путь к файлу, который будет создан, и любые проверки, которые будут выполнены. Если указан этот параметр, командлет не создает никаких файлов или каталогов.

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

Вы не можете передавать объекты в этот командлет.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Командлет возвращает пользовательский объект со следующими свойствами:

- **Name**: имя цветового сценария без расширения `.ps1`.
- **Path**: полный путь к созданному файлу.
- **Categories**: указанный массив значений категорий (если есть).
- **Tags**: массив указанных значений тегов (если есть).
- **MetadataGuidance**: текст фрагмента метаданных (только при использовании -GenerateMetadataSnippet).

## NOTES

**Кодировка**: Scaffold написан в кодировке UTF-8 без метки порядка байтов (BOM), что обеспечивает совместимость с различными платформами и редакторами.

**Структура шаблона**. Созданный шаблон включает в себя:

- комментарий на эшафот
— Заполнитель строкового массива для изображения.
— Цикл, который записывает каждую строку с помощью `Write-Host`.

**Интеграция метаданных**. Хотя командлет может генерировать руководство по метаданным, вам необходимо вручную добавить фрагмент в `ScriptMetadata.psd1`, чтобы полностью интегрировать сценарий в систему обнаружения и категоризации модуля.

**Рабочий процесс разработки**:

1. Используйте `New-ColorScript` для создания каркаса.
2. Отредактируйте созданный файл .ps1, добавив свое изображение ANSI.
3. Если руководство по метаданным было создано, скопируйте его в `ScriptMetadata.psd1`.
4. Проверьте свой скрипт с помощью `Show-ColorScript -Name <your-script-name>`.

**Рекомендации**:

- Выбирайте описательные названия, написанные через дефис, которые четко обозначают тему сценария.
– Используйте согласованные значения категорий, соответствующие существующим сценариям.
- Применяйте несколько тегов для улучшения обнаружения.
- Тестируйте сценарии в различных терминальных средах, чтобы убедиться в совместимости.

## RELATED LINKS

- [Онлайн-версия](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)

