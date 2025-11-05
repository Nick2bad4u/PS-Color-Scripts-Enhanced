---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/zh-CN/Get-ColorScriptList.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptList

## SYNOPSIS

检索可用颜色脚本及其元数据的列表。

## SYNTAX

```
Get-ColorScriptList [[-Name] <string[]>] [-Category <string[]>] [-Tag <string[]>] [-AsObject]
 [<CommonParameters>]
```

## DESCRIPTION

返回 ColorScripts-Enhanced 集合中可用颜色脚本的信息。默认情况下，显示一个格式化的表格，显示脚本名称、类别和描述。使用 `-AsObject` 返回结构化对象以进行编程访问。

该 cmdlet 提供每个颜色脚本的全面元数据，包括：

- 名称：脚本标识符（不带 .ps1 扩展名）
- 类别：主题分组（自然、抽象、几何等）
- 标签：用于过滤和发现的附加描述符
- 描述：脚本视觉内容的简要说明

此 cmdlet 对于探索集合并在使用其他 cmdlet（如 `Show-ColorScript`）之前了解可用选项至关重要。

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

显示所有可用颜色脚本及其元数据的格式化表格。

### EXAMPLE 2

```powershell
Get-ColorScriptList -Category Nature
```

仅列出分类为 "Nature" 的颜色脚本。

### EXAMPLE 3

```powershell
Get-ColorScriptList -Tag geometric -AsObject
```

以对象形式返回标记为 "geometric" 的颜色脚本，以供进一步处理。

### EXAMPLE 4

```powershell
Get-ColorScriptList -Name "aurora*" | Format-Table Name, Category, Tags
```

列出匹配通配符模式的颜色脚本，并显示选定的属性。

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject | Where-Object { $_.Tags -contains 'animated' }
```

使用对象过滤查找所有动画颜色脚本。

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Abstract,Geometric | Measure-Object
```

计算 Abstract 或 Geometric 类别中的颜色脚本数量。

### EXAMPLE 7

```powershell
Get-ColorScriptList -Tag retro | Select-Object Name, Description
```

显示复古风格颜色脚本的名称和描述。

### EXAMPLE 8

```powershell
# 从特定类别中获取随机脚本
Get-ColorScriptList -Category Nature -AsObject | Get-Random | Select-Object -ExpandProperty Name
```

选择一个随机的自然主题颜色脚本名称。

### EXAMPLE 9

```powershell
# 将脚本清单导出到 CSV
Get-ColorScriptList -AsObject | Export-Csv -Path "colorscripts.csv" -NoTypeInformation
```

将完整的脚本元数据导出到 CSV 文件。

### EXAMPLE 10

```powershell
# 通过多个条件查找脚本
Get-ColorScriptList -AsObject | Where-Object {
    $_.Category -eq 'Geometric' -and $_.Tags -contains 'colorful'
}
```

查找几何颜色脚本，这些脚本也被标记为多彩。

## PARAMETERS

### -AsObject

以结构化对象的形式返回颜色脚本信息，而不是显示格式化的表格。对象包括 Name、Category、Tags 和 Description 属性，用于编程访问。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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
HelpMessage: ""
```

### -Category

将结果过滤为属于一个或多个指定类别的颜色脚本。类别是像 "Nature"、"Abstract"、"Art"、"Retro" 等广泛的主题分组。

```yaml
Type: System.String[]
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
HelpMessage: ""
```

### -Name

将结果过滤为匹配一个或多个名称模式的颜色脚本。支持通配符（\* 和 ?）以进行灵活匹配。

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
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
HelpMessage: ""
```

### -Tag

将结果过滤为带有指定标签的一个或多个颜色脚本。标签是更具体的描述符，如 "geometric"、"retro"、"animated"、"minimal" 等。

```yaml
Type: System.String[]
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
HelpMessage: ""
```

### CommonParameters

此 cmdlet 支持通用参数：-Debug、-ErrorAction、-ErrorVariable、-InformationAction、-InformationVariable、-OutBuffer、-OutVariable、-PipelineVariable、-ProgressAction、-Verbose、-WarningAction 和 -WarningVariable。有关更多信息，请参阅 [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

此 cmdlet 不接受来自管道的输入。

## OUTPUTS

### System.Object

指定 `-AsObject` 时，返回具有 Name、Category、Tags 和 Description 属性的自定义对象。

### None

未指定 `-AsObject` 时，输出直接写入控制台主机。

## NOTES

**作者：** Nick
**模块：** ColorScripts-Enhanced
**需要：** PowerShell 5.1 或更高版本

**元数据属性：**

- 名称：Show-ColorScript 使用的脚本标识符
- 类别：用于组织的主题分组
- 标签：用于过滤的描述性关键字数组
- 描述：内容的易读说明

**使用模式：**

- 发现：在选择之前探索可用脚本
- 过滤：使用类别和标签缩小选项范围
- 自动化：使用 -AsObject 进行编程脚本选择
- 清单：导出元数据以用于文档或报告

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [在线文档](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
