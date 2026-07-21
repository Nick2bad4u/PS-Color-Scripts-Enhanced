---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

创建一个带有元数据和模板结构的新颜色脚本。

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

This command has no aliases.

## DESCRIPTION

创建一个新的颜色脚本文件，具有适当的元数据结构和可选的模板内容。此 cmdlet 提供了一种标准化的方式来创建新的颜色脚本，这些脚本可以无缝集成到 ColorScripts-Enhanced 生态系统中。

此 cmdlet 生成：

- 一个具有基本结构的新 .ps1 文件
- 用于分类的关联元数据
- 基于所选样式的模板内容
- 适当的文件组织

可用的模板包括：

- Basic：自定义脚本的最小结构
- Animated：具有定时控制的模板
- Interactive：具有用户输入处理的模板
- Geometric：几何图案的模板
- Nature：自然灵感设计的模板

创建的脚本会自动与模块的缓存和显示系统集成。

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name "MyScript"
```

创建一个具有基本模板的新颜色脚本。

### EXAMPLE 2

```powershell
New-ColorScript -Name "Sunset" -Category Nature -Tags "animated", "colorful" -Description "Beautiful sunset animation"
```

创建一个具有元数据的自然主题动画颜色脚本。

### EXAMPLE 3

```powershell
New-ColorScript -Name "GeometricPattern" -Template Geometric -Path "./custom-scripts/"
```

在自定义目录中创建一个几何颜色脚本。

### EXAMPLE 4

```powershell
New-ColorScript -Name "InteractiveDemo" -Template Interactive -WhatIf
```

显示将要创建的内容，而不实际创建文件。

### EXAMPLE 5

```powershell
# Create multiple related scripts
$themes = @("Forest", "Ocean", "Mountain")
foreach ($theme in $themes) {
    New-ColorScript -Name $theme -Category Nature -Tags "landscape"
}
```

创建多个自然主题的颜色脚本。

## PARAMETERS

### -Category

指定新颜色脚本的类别。类别有助于按主题组织脚本。

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

Overwrites an existing colorscript file at the resolved output path.

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

Includes metadata guidance for adding the new script to ScriptMetadata.psd1.

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

显示此命令的详细帮助，而不执行操作。

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

新颜色脚本的名称（不带 .ps1 扩展名）。

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

Opens the generated colorscript with the command configured by the environment when creation succeeds.

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

Specifies the target directory or .ps1 file path for the generated colorscript.

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

Specifies metadata tags to include in the generated metadata guidance.

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

显示 cmdlet 运行时会发生什么。cmdlet 不会运行。

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

此 cmdlet 不接受来自管道的输入。

## OUTPUTS

### System.Object

返回一个包含有关创建的颜色脚本信息的对象。

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 或更高版本

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)

