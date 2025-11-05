---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/zh-CN/New-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScriptCache

## SYNOPSIS

为颜色脚本性能优化预构建缓存。

## SYNTAX

```
New-ColorScriptCache [[-Name] <string[]>] [-Category <string[]>] [-Tag <string[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

预先生成颜色脚本的缓存输出，以确保首次显示时的最佳性能。此 cmdlet 提前执行颜色脚本并存储其渲染输出，以便即时检索。

缓存系统通过消除显示时的脚本执行时间，提供 6-19 倍的性能提升。当源脚本被修改时，缓存内容会自动失效。

使用此 cmdlet 来：

- 为常用脚本准备缓存
- 确保跨会话的一致性能
- 在模块更新后预热缓存
- 优化启动性能

此 cmdlet 支持按名称、类别或标签进行选择性缓存，允许针对性缓存准备。

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

预构建所有可用颜色脚本的缓存。

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name "spectrum", "aurora-waves"
```

按名称缓存特定的颜色脚本。

### EXAMPLE 3

```powershell
New-ColorScriptCache -Category Nature
```

预构建所有自然主题颜色脚本的缓存。

### EXAMPLE 4

```powershell
New-ColorScriptCache -Tag animated
```

缓存所有标记为 "animated" 的颜色脚本。

### EXAMPLE 5

```powershell
# Cache scripts for startup optimization
New-ColorScriptCache -Category Geometric -Tag minimal
```

为轻量级几何脚本准备缓存，这些脚本适合快速启动显示。

## PARAMETERS

### -Category

按一个或多个类别过滤要缓存的脚本。

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

### -Confirm

在运行 cmdlet 之前提示您进行确认。

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
HelpMessage: ""
```

### -Name

指定要缓存的颜色脚本名称。支持通配符（\* 和 ?）。

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

按一个或多个标签过滤要缓存的脚本。

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

### -WhatIf

显示 cmdlet 运行时会发生什么。该 cmdlet 不会运行。

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
HelpMessage: ""
```

### CommonParameters

此 cmdlet 支持通用参数：-Debug、-ErrorAction、-ErrorVariable、-InformationAction、-InformationVariable、-OutBuffer、-OutVariable、-PipelineVariable、-ProgressAction、-Verbose、-WarningAction 和 -WarningVariable。有关详细信息，请参阅 [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

此 cmdlet 不接受来自管道的输入。

## OUTPUTS

### System.Object

返回缓存构建结果，其中包含每个脚本的成功/失败状态。

## NOTES

**作者：** Nick
**模块：** ColorScripts-Enhanced
**要求：** PowerShell 5.1 或更高版本

**性能影响：**
预缓存消除了首次显示时的执行时间，提供即时视觉反馈。对复杂或动画脚本特别有益。

**缓存管理：**
缓存文件存储在模块管理的目录中，当源脚本更改时会自动失效。使用 Clear-ColorScriptCache 删除过时的缓存。

**最佳实践：**

- 为常用脚本缓存以获得最佳性能
- 使用选择性缓存以避免不必要的处理
- 在模块更新后运行以确保缓存有效性

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [在线文档](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
