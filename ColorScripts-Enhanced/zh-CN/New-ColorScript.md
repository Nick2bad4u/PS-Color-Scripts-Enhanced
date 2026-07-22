---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

创建新的颜色脚本文件，并可选择输出元数据指导。

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

此命令没有别名。

## DESCRIPTION

`New-ColorScript` cmdlet 创建一个最小的颜色脚本脚手架，其中包含一个字符串数组和一个逐行写入的循环。该文件使用不带字节顺序标记 (BOM) 的 UTF-8 编码。可选的元数据指导可以作为注释包含在生成的文件中，并在结果对象中返回。

搭建脚手架时，`-Name` 和 `-OutputPath` 都是必需的。 `-OutputPath` 标识一个目录；该命令在需要时创建目录并在其中写入 `<Name>.ps1` 。

脚本名称必须遵循 PowerShell 命名约定：它们必须以字母数字字符开头，并且可以包含下划线或连字符。如果未提供，则会自动附加 `.ps1` 扩展名。除非显式指定 `-Force` 开关，否则现有文件将受到保护，不会被意外覆盖。

与 `-GenerateMetadataSnippet` 结合使用时，cmdlet 返回描述要添加到 `ScriptMetadata.psd1` 的条目的指导。提供的类别和标签值也会作为结果对象上的数组返回。

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -OutputPath ./ColorScripts-Enhanced/Scripts -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

在请求的目录中创建 `my-spectrum.ps1` 并返回包含文件路径和元数据指导的对象。

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

在自定义目录 (`~/Dev/colorscripts`) 下生成脚手架，如果该目录不存在则创建该目录。如果该位置已存在名为 `holiday-banner.ps1` 的文件，则由于 `-Force` 开关，该文件将被覆盖。

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -OutputPath ./ColorScripts-Enhanced/Scripts -Category 'Artistic' -Tag '80s','Neon' -GenerateMetadataSnippet
$result.MetadataGuidance | Set-Clipboard
```

创建新的颜色脚本并将元数据指南复制到剪贴板，以便轻松粘贴到 `ScriptMetadata.psd1` 中。

### EXAMPLE 4

```powershell
New-ColorScript -Name 'test-pattern' -OutputPath '.\temp' -WhatIf
```

显示在 `.\temp` 目录中创建测试模式脚本而不实际创建文件时会发生什么。对于在执行之前验证路径和名称很有用。

### EXAMPLE 5

```powershell
# 为一个项目创建多个颜色脚本
$scriptNames = @("company-logo", "team-banner", "status-display")
foreach ($name in $scriptNames) {
    New-ColorScript -Name $name -Category "Corporate" -Tag "Custom" -OutputPath ".\src" | Out-Null
}
Write-Host "创建了 $($scriptNames.Count) 个颜色脚本模板"
```

为一个项目批量创建多个颜色脚本模板。

### EXAMPLE 6

```powershell
# 创建并立即在编辑器中打开
New-ColorScript -Name "my-art" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -GenerateMetadataSnippet -OpenInEditor
```

创建一个颜色脚本并要求平台的注册处理程序打开它。

### EXAMPLE 7

```powershell
# 通过完整的工作流程自动化进行创建
$newScript = New-ColorScript -Name "interactive-demo" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Custom" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "创建：$($newScript.Name)"
Write-Host "路径：$($newScript.Path)"
Write-Host "剪贴板中已准备好元数据指南"
$newScript.MetadataGuidance | Set-Clipboard
```

创建带有自动复制到剪贴板的元数据指导的颜色脚本。

### EXAMPLE 8

```powershell
# 验证脚本名称约定
$validName = "123-start"
$invalidNames = @("-invalid", "_underscore-only", "contains space")
foreach ($name in $invalidNames) {
    try {
        New-ColorScript -Name $name -OutputPath ./temp -WhatIf -ErrorAction Stop
    } catch {
        Write-Warning "无效名称“$name”：$_"
    }
}
```

演示颜色脚本的命名约定验证。

### EXAMPLE 9

```powershell
# 在便携式位置创建以便分发
$portableDir = Join-Path $PSScriptRoot "colorscripts"
$scaffold = New-ColorScript -Name "portable-art" -OutputPath $portableDir -GenerateMetadataSnippet
Write-Host "在 $($scaffold.Path) 创建了便携式彩色脚本"
```

在相对于当前脚本的可移植位置创建颜色脚本。

### EXAMPLE 10

```powershell
# 使用类别和标签验证进行创建
$categories = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Category -Unique
if ("Retro" -in $categories) {
    New-ColorScript -Name "retro-party" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -Tag "Fun","Social"
} else {
    Write-Warning "未找到复古类别"
}
```

在创建新的颜色脚本之前验证类别是否存在。

## PARAMETERS

### -Category

指定随脚手架返回并包含在元数据指南中的一个或多个类别。值应与 `ScriptMetadata.psd1` 中已使用的类别一致。

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

在运行 cmdlet 之前提示您进行确认。

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

如果目标文件已存在，则覆盖该文件。如果没有此开关，如果在目标位置找到同名文件，则 cmdlet 将终止并出现错误。请谨慎使用以避免数据丢失。

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

在输出中包含一个指导片段，演示如何在 `ScriptMetadata.psd1` 中注册新脚本。该代码段使用 `-Category` 和 `-Tag` 参数（如果提供）中的值。这对于在模块中的所有颜色脚本中维护一致的元数据特别有用。

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

显示该命令的详细帮助而不执行操作。

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

指定新颜色脚本的名称。该名称必须以字母数字字符开头，并且可以包含下划线或连字符。如果未包含，则会自动附加 `.ps1` 扩展名。该名称将用作文件名，并且应该描述脚本的内容或主题。

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

创建成功后，使用环境配置的命令打开生成的颜色脚本。

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

指定必需的目标目录。该命令会在此目录中创建 <Name>.ps1。

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

为彩色脚本指定一个或多个元数据标签。标签提供了主要类别之外的附加分类，对于过滤和搜索非常有用。常见标签包括主题描述符（如“最小”、“多彩”、“动画”）、技术参考（如“矩阵”、“ASCII”）或上下文标记（如“假期”、“季节”）。可以将多个标签指定为逗号分隔的数组。

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

显示如果 cmdlet 运行而不实际执行任何操作，将会发生什么情况。显示将创建的文件路径以及将执行的任何验证检查。指定此开关时，cmdlet 不会创建任何文件或目录。

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

此 cmdlet 支持以下常用参数：
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
有关详细信息，请参阅
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

您无法通过管道将对象传递给此 cmdlet。

## OUTPUTS

### System.Management.Automation.PSCustomObject

该 cmdlet 返回具有以下属性的自定义对象：

- **Name**：不带 `.ps1` 扩展名的颜色脚本名称
- **Path**：生成文件的完整路径
- **Categories**：指定的类别值数组（如果有）
- **Tags**：指定的标签值数组（如果有）
- **MetadataGuidance**：元数据片段文本（仅当使用 -GenerateMetadataSnippet 时）

## NOTES

**编码**：脚手架采用UTF-8编码编写，无字节顺序标记（BOM），确保跨平台和编辑器的兼容性。

**模板结构**：生成的模板包括：

- 脚手架评论
- 艺术的字符串数组占位符
- 用 `Write-Host` 写入每一行的循环

**元数据集成**：虽然 cmdlet 可以生成元数据指导，但您必须手动将代码段添加到 `ScriptMetadata.psd1` 以将脚本完全集成到模块的发现和分类系统中。

**开发工作流程**：

1.使用`New-ColorScript`创建脚手架
2. 编辑生成的 .ps1 文件以添加您的 ANSI 艺术作品
3. 如果生成了元数据指南，请将其复制到 `ScriptMetadata.psd1`
4. 使用 `Show-ColorScript -Name <your-script-name>` 测试您的脚本

**最佳实践**：

- 选择具有连字符的描述性名称，以清楚地表明脚本的主题
- 使用与现有脚本一致的一致类别值
- 应用多个标签以提高可发现性
- 在不同终端环境下测试脚本，确保兼容性

## RELATED LINKS

- [在线版本](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)

