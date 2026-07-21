---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

为颜色脚本性能优化预构建缓存。

## SYNTAX

### Selection (Default)

```
New-ColorScriptCache [-Name <string[]>] [-Force] [-PassThru] [-Category <string[]>]
 [-Tag <string[]>] [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon]
 [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Category <string[]>] [-Tag <string[]>]
 [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon] [-WhatIf] [-Confirm]
```

## ALIASES

- `Build-ColorScriptCache`
- `Update-ColorScriptCache`

## DESCRIPTION

预先生成计算开销较大的颜色脚本的缓存输出。仅执行并保存 `CachePolicy.psd1` 中列出的渲染器。静态或未列出的脚本会以 `SkippedNotRequired` 状态跳过，并删除其过时缓存。

缓存系统为选定的渲染器提供 6-19 倍的性能提升。当源脚本被修改时，缓存内容会自动失效。`-Force` 只重建符合条件的缓存，且不会绕过缓存策略。


### -Quiet

抑制缓存构建后的摘要消息。

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

### -NoAnsiOutput

禁用摘要中的 ANSI 颜色，输出纯文本。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
 - NoColor
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
使用此 cmdlet 来：

### -IncludePokemon

在构建缓存时包含所有宝可梦脚本（普通与闪光版本）。默认情况下，宝可梦脚本将被跳过；使用 `-IncludePokemon` 将它们包含到缓存构建中。注意：此参数替换了旧的 `-ExcludePokemon`，在重构期间逻辑被反转（现在为 opt-in）。

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


- 为常用脚本准备缓存
- 确保跨会话的一致性能
- 在模块更新后预热缓存
- 优化启动性能

此 cmdlet 支持按名称、类别或标签进行选择性缓存，允许针对性缓存准备。

默认会显示一条简要摘要。使用 `-PassThru` 可返回详细结果对象，`-Quiet` 可抑制摘要，而 `-NoAnsiOutput` 会输出不含 ANSI 颜色的纯文本。

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

评估所有可用颜色脚本，并且只缓存 `CachePolicy.psd1` 选定的渲染器。

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name "Galaxy", "rose-curves"
```

按名称缓存特定的颜色脚本。

### EXAMPLE 3

```powershell
New-ColorScriptCache -Category Nature
```

评估所有自然主题颜色脚本，并且只缓存符合条件的渲染器。

### EXAMPLE 4

```powershell
New-ColorScriptCache -Tag animated
```

评估所有标记为 "animated" 的颜色脚本，并且只缓存符合条件的渲染器。

### EXAMPLE 5

```powershell
# Cache scripts for startup optimization
New-ColorScriptCache -Category Geometric -Tag minimal
```

为轻量级几何脚本准备缓存，这些脚本适合快速启动显示。

## PARAMETERS

### -All

Processes every renderer selected by CachePolicy.psd1 without enumerating the full static script inventory.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

按一个或多个类别过滤要缓存的脚本。

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

即使现有缓存已是最新状态，也强制重新生成符合条件的缓存，但不会绕过 `CachePolicy.psd1`。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

### -IncludePokemon

在构建缓存时包含所有宝可梦脚本（普通与闪光版本）。默认情况下，宝可梦脚本将被跳过；使用 `-IncludePokemon` 将它们包含到缓存构建中。注意：此参数替换了旧的 `-ExcludePokemon`，在重构期间逻辑被反转（现在为 opt-in）。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

指定要缓存的颜色脚本名称。支持通配符（\* 和 ?）。

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAnsiOutput

禁用摘要中的 ANSI 颜色，输出纯文本。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- NoColor
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Parallel

Builds eligible cache entries concurrently. Unsupported hosts fall back to sequential execution.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PassThru

返回每个脚本的详细结果对象。未指定时仅输出摘要。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

抑制缓存构建后的摘要消息。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

按一个或多个标签过滤要缓存的脚本。

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ThrottleLimit

Sets the maximum number of concurrent cache workers. Threads is an alias for this parameter.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Threads
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

显示 cmdlet 运行时会发生什么。该 cmdlet 不会运行。

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

返回缓存构建结果，其中包含每个脚本的成功/失败状态。

## NOTES

**作者：** Nick
**模块：** ColorScripts-Enhanced
**要求：** PowerShell 5.1 或更高版本

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
