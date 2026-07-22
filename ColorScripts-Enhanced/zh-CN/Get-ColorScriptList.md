---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

列出可用的颜色脚本，具有可选的过滤和丰富的元数据输出。

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

此命令没有别名。

## DESCRIPTION

`Get-ColorScriptList` cmdlet 检索并显示与 ColorScripts-Enhanced 模块一起打包的所有颜色脚本。它提供灵活的过滤选项和多种输出格式以适应不同的用例。

默认情况下，cmdlet 显示一个简洁的格式化表，其中显示脚本名称和类别。 `-Detailed` 开关扩展了此视图以包含标签和描述，从而提供更多上下文一目了然。

该 cmdlet 始终将元数据记录返回到成功管道。如果没有`-AsObject`，它也会写入一个格式化的宿主视图； `-AsObject` 抑制主机格式以实现干净的自动化。记录包括名称、路径、类别、类别、标签、描述和原始元数据属性。

过滤功能允许您通过以下方式缩小列表范围：

- **Name**：支持通配符模式（例如 `aurora-*`）以进行灵活匹配
- **Category**：按一个或多个类别名称筛选（不区分大小写）
- **Tag**：按元数据标签筛选，例如“推荐”或“动画”（不区分大小写）

该 cmdlet 验证筛选模式并针对任何不匹配的名称模式生成警告，帮助您识别潜在的拼写错误或丢失的脚本。

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

以紧凑的表格格式显示所有可用的颜色脚本，并显示每个脚本的名称和类别。

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed
```

显示所有颜色脚本以及附加列，包括标签和描述以进行全面概述。

### EXAMPLE 3

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

仅显示“模式”类别中的脚本以及完整的元数据，包括标签和描述。

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

返回名称与通配符模式匹配的每个脚本的结构化对象，然后仅选择“名称”和“标签”属性进行显示。

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

检索所有标记为“推荐”的脚本并按名称字母顺序对它们进行排序。对于查找适合配置文件集成的精选脚本很有用。

### EXAMPLE 6

```powershell
Get-ColorScriptList -AsObject -Category Geometric,Abstract | Where-Object { $_.Tags -contains 'Colorful' }
```

结合类别和标签过滤来查找属于几何或抽象类别并标记为彩色的脚本。

### EXAMPLE 7

```powershell
Get-ColorScriptList -Name blocks,pipes,matrix -AsObject | ForEach-Object { Show-ColorScript -Name $_.Name }
```

检索特定的命名脚本并按顺序执行每个脚本，演示与 `Show-ColorScript` 的管道集成。

### EXAMPLE 8

```powershell
# 按类别对脚本进行计数以用于库存目的
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending
```

提供每个类别中存在多少个颜色脚本的摘要。

### EXAMPLE 9

```powershell
# 查找描述中包含特定关键字的脚本
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

使用模式匹配根据描述内容搜索脚本。

### EXAMPLE 10

```powershell
# 导出为 CSV 以供外部工具处理
Get-ColorScriptList -AsObject -Detailed |
    Select-Object Name, Category, Tags, Description |
    Export-Csv -Path "./colorscripts-inventory.csv" -NoTypeInformation
```

将完整的颜色脚本清单导出为 CSV 格式，以便在电子表格应用程序中使用。

### EXAMPLE 11

```powershell
# 检查没有特定类别的脚本
$allScripts = Get-ColorScriptList -AsObject
$uncategorized = $allScripts | Where-Object { -not $_.Category }
Write-Host "未分类的脚本：$($uncategorized.Count)"
$uncategorized | Select-Object Name
```

识别缺少类别元数据的脚本。

### EXAMPLE 12

```powershell
# 为过滤后的脚本构建缓存
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object {
        New-ColorScriptCache -Name $_.Name -PassThru
    } |
    Format-Table Name, Status
```

评估标记为 `Recommended` 的脚本；仅构建符合缓存策略资格的渲染器，其他记录报告 `SkippedNotRequired`。

### EXAMPLE 13

```powershell
# 创建所有几何脚本的格式化报告
Get-ColorScriptList -Category Geometric -Detailed |
    Out-String |
    Tee-Object -FilePath "./geometric-report.txt"
```

生成几何类别颜色脚本的详细报告并将其保存到文件中。

### EXAMPLE 14

```powershell
# 查找第一个与模式匹配的脚本以快速显示
$script = Get-ColorScriptList -Name "aurora-*" -AsObject | Select-Object -First 1
if ($script) {
    Show-ColorScript -Name $script.Name -PassThru
}
```

根据通配符模式快速显示第一个匹配的脚本。

### EXAMPLE 15

```powershell
# 在运行自动化之前验证所有引用的脚本是否存在
$requiredScripts = @("bars", "arch", "mandelbrot-zoom")
$available = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$missing = $requiredScripts | Where-Object { $_ -notin $available }
if ($missing) {
    Write-Warning "缺少脚本：$($missing -join ', ')"
} else {
    Write-Host "所有必需的脚本均可用"
}
```

在自动化运行之前验证所有必需的脚本是否存在。

## PARAMETERS

### -AsObject

返回原始元数据记录对象，而不是将格式化表呈现给主机。这使得彩色脚本元数据的管道处理和编程操作成为可能。

指定此开关后，您可以使用标准 PowerShell cmdlet（例如 `Where-Object`、`Select-Object`、`Sort-Object` 和 `ForEach-Object`）来进一步处理结果。

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

### -Category

过滤列表以仅包含属于一个或多个指定类别的脚本。类别匹配不区分大小写。

常见类别包括：图案、几何、抽象、自然、动画、文本、复古等。您可以指定多个类别来扩大搜索范围。

```yaml
Type: System.String[]
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

### -Detailed

呈现格式化表视图时包括附加列（标签和描述）。这提供了有关每个脚本的更全面的信息，一目了然。

如果没有此开关，则表输出中仅显示名称和主要类别。

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

显示该命令的详细帮助而不执行操作。

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

### -Name

按一个或多个脚本名称过滤颜色脚本列表。支持通配符（`*` 和 `?`）以实现灵活的模式匹配。

如果指定的模式与任何脚本都不匹配，则会生成警告以帮助识别潜在问题。名称匹配不区分大小写。

您可以指定确切的名称或使用 `aurora-*` 等模式来匹配多个相关脚本。

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
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

### -NoAnsiOutput

在纯文本环境的信息消息和渲染输出中禁用 ANSI 样式。

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

### -Quiet

抑制信息性消息，同时保留命令输出和错误。

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

### -Tag

过滤列表以仅包含包含一个或多个指定元数据标签的脚本。标签匹配不区分大小写。

常见标签包括：推荐、动画、多彩、简约、复古、复杂、简单等。标签有助于按视觉风格、复杂性或用例对脚本进行分类。

```yaml
Type: System.String[]
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

### CommonParameters

此 cmdlet 支持以下常用参数：
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
有关详细信息，请参阅
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

此 cmdlet 不接受管道输入。

## OUTPUTS

### System.Object

返回具有以下属性的颜色脚本元数据记录对象：

- **Name**：与 `Show-ColorScript` 一起使用的脚本标识符
- **Path**：完整的源路径
- **Category**：脚本的主要类别
- **Categories**：脚本所属的所有类别数组
- **Tags**：描述脚本的元数据标签数组
- **Description**：脚本视觉输出的可读描述
- **Metadata**：包含所有原始脚本信息的原始元数据对象

如果没有 `-AsObject`，cmdlet 会将格式化表写入主机，同时仍返回记录对象以进行潜在的管道处理。

## NOTES

**作者**：尼克
**模块**：ColorScripts-Enhanced

返回的元数据记录为显示和自动化目的提供全面的信息。 `Name` 属性可以直接与 `Show-ColorScript` cmdlet 一起使用来执行特定脚本。

所有过滤操作（名称、类别、标签）都不区分大小写，并且可以组合起来创建强大的查询。在 `-Name` 参数中使用通配符时，不匹配的模式会生成警告以帮助进行故障排除。

为了在将颜色脚本集成到 PowerShell 配置文件时获得最佳结果，请使用 `-Tag Recommended` 过滤器来识别适合启动显示的精选脚本。

### 最佳实践

- 当您需要以编程方式过滤或操作结果时，始终使用 `-AsObject`
- 交互探索时使用 `-Detailed` 查看标签和描述
- 组合多个过滤器进行精准查询
- 定期导出元数据以跟踪随时间的变化
- 使用结果对象进行自动化而不是解析文本输出
- 重复运行查询时考虑性能（如果可能的话缓存结果）
- 利用组对象进行分析和报告
- 使用Where-Object进行复杂的过滤逻辑

## RELATED LINKS

- [在线版本](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)

