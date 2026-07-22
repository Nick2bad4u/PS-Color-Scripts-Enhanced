---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Clear-ColorScriptCache
---

# Clear-ColorScriptCache

## SYNOPSIS

删除缓存的颜色脚本输出文件。

## SYNTAX

### Selection (Default)

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

### Help

```
Clear-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-All] [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

## ALIASES

此命令没有别名。

## DESCRIPTION

`Clear-ColorScriptCache` cmdlet 删除 ColorScripts-Enhanced 模块生成的缓存输出文件。每个条目由有效缓存目录中渲染后的 `<name>.cache` 有效负载和 `<name>.cacheinfo` 验证伴随元数据文件组成。

您可以使用带有通配符模式的 `-Name` 参数有选择地删除缓存条目，或使用 `-All` 参数一次性删除所有条目。`-All` 还会删除有效负载已被删除的孤立伴随元数据文件。该 cmdlet 支持按 `-Category` 和 `-Tag` 进行筛选，以定位缓存脚本的特定子集。

不匹配的脚本名称在结果中报告 `Missing` 状态。使用 `-DryRun` 预览删除操作而不修改文件系统，并使用 `-Path` 定位备用缓存目录（对于自定义缓存配置或 CI/CD 环境很有用）。

显示相应的策略选定渲染器或调用 `New-ColorScriptCache` 时，会重新生成符合条件的缓存条目。可静态提取的捆绑脚本不符合缓存条件，也不会创建缓存条目。

对于自动化场景，结合 `-PassThru` 捕获结构化结果，结合 `-Quiet` 抑制摘要消息，或结合 `-NoAnsiOutput` 发出不带 ANSI 颜色代码的纯文本摘要。

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

删除默认缓存目录中的每个缓存文件，而不提示确认。这对于在模块更新后或排除显示问题时完全刷新缓存非常有用。

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

预览将删除哪些极光主题缓存文件，而不实际删除它们。输出显示与模式匹配的缓存文件，允许您在提交删除之前验证选择。

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name Galaxy -Path $env:TEMP -Confirm:$false
```

从 TEMP 下的自定义目录中清除符合条件的“Galaxy”渲染器的缓存文件。这在测试 `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` 或其他隔离的缓存位置时很有用。

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Category Mathematical -WhatIf
```

显示如果删除 `Mathematical` 类别中的脚本的缓存文件会发生什么情况。 `-WhatIf` 参数可防止删除。

### EXAMPLE 5

```powershell
Get-ColorScriptList -Tag retro | Clear-ColorScriptCache -DryRun
```

使用管道输入预览标记为“retro”的所有脚本的缓存文件的删除。将按标签过滤与提交删除之前的试运行预览相结合。

### EXAMPLE 6

```powershell
Clear-ColorScriptCache -Name 'test-*', 'demo-*' -Confirm:$false
```

删除名称以“test-”或“demo-”开头的所有脚本的缓存文件，无需确认。可以将多个通配符模式指定为数组。

### EXAMPLE 7

```powershell
# 清除现有缓存文件并重建策略选定条目
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -PassThru | Measure-Object
Write-Host "缓存重建成功"
```

清除所有缓存有效负载，仅重建动态缓存策略选定的条目，然后显示这些重建条目的统计信息。

### EXAMPLE 8

```powershell
# 清除超过 30 天的旧缓存条目
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$thirtyDaysAgo = (Get-Date).AddDays(-30)
Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $thirtyDaysAgo } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
Write-Host "旧的缓存文件已清理"
```

删除超过 30 天未更新的缓存文件。

### EXAMPLE 9

```powershell
# 缓存管理报告
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$beforeCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Clear-ColorScriptCache -Category Geometric -Confirm:$false
$afterCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Write-Host "清除$($beforeCount - $afterCount)几何缓存文件"
```

显示有关缓存清除操作的统计信息。

### EXAMPLE 10

```powershell
# 故障排除 - 清除并重建特定脚本
$scriptName = "Galaxy"
Clear-ColorScriptCache -Name $scriptName -Confirm:$false
New-ColorScriptCache -Name $scriptName -Force
Show-ColorScript -Name $scriptName
```

清除并重建一个符合策略条件的渲染器缓存，然后显示该渲染器以进行验证。

### EXAMPLE 11

```powershell
# 按多个类别过滤
Clear-ColorScriptCache -Category Geometric,Abstract -DryRun -PassThru |
    Select-Object CacheFile |
    Measure-Object
```

显示按多个类别过滤时将删除多少个缓存文件。

## PARAMETERS

### -All

选择目标目录中的每个缓存条目。 `-Category`和`-Tag`可以进一步限制全选参数集； `-Name` 属于选择参数集。

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

在评估缓存条目之前按类别过滤目标脚本。仅考虑删除与指定类别匹配的脚本的缓存文件。接受类别名称数组，并可以与 `-Tag` 组合以进行更精确的过滤。

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

在运行 cmdlet 之前提示您进行确认。默认情况下，启用此功能是为了防止意外删除缓存文件。使用 `-Confirm:$false` 绕过确认提示。

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

### -DryRun

预览删除操作而不删除任何文件。该 cmdlet 将显示哪些缓存文件将被删除，但不会修改文件系统。这对于在提交删除之前验证您的选择标准很有用。

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

显示该命令的详细帮助而不执行操作。

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

### -Name

标识要删除的缓存文件的名称或通配符模式。接受来自具有 `Name` 属性的对象的管道输入和属性绑定。模式匹配支持通配符（`*`、`?`）。与 `-All` 互斥。

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
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

在摘要输出中禁用 ANSI 颜色序列。这对于不解释 ANSI 样式的控制台或日志处理器很有帮助，确保摘要文本以纯文本形式保持清晰。

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

### -PassThru

返回处理的每个缓存条目的详细结果对象。如果没有此开关，cmdlet 仅写入摘要消息。每个传递记录包括脚本名称、缓存文件路径、状态以及任何关联的错误文本，以供进一步检查或报告。

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

### -Path

要操作的备用缓存目录。如果未指定，则默认为模块的标准缓存路径。当使用通过 `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` 环境变量设置的自定义缓存位置时，或者在出于测试或 CI/CD 目的而管理备用目录中的缓存文件时，请使用此参数。

```yaml
Type: System.String
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

禁止在缓存删除完成后发出摘要消息。在仅应生成结构化输出（例如 `-PassThru` 记录、警告或错误）的安静自动化环境中运行时，请使用此开关。

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

在评估缓存条目之前，通过元数据标签过滤目标脚本。只有具有匹配标签的脚本的缓存文件才会被考虑删除。接受标签名称数组，并可以与 `-Category` 结合使用，以更精细地控制目标缓存文件。

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

### -WhatIf

显示如果 cmdlet 运行而不实际执行操作会发生什么情况。该 cmdlet 显示它将执行的操作，但不会修改文件系统。这是一个标准的 PowerShell 通用参数，其工作方式与 `-DryRun` 类似，但遵循 PowerShell 的内置约定。

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

### System.String

您可以通过管道将脚本名称传递给此 cmdlet。将根据指定的参数评估每个名称是否删除缓存文件。

### System.String[]

您可以通过管道将脚本名称数组传递给此 cmdlet。当与 `Get-ColorScriptList` 结合使用以在清除缓存之前按各种条件过滤脚本时，这特别有用。

### System.Management.Automation.PSObject

您可以通过管道将具有 `Name` 属性的对象传递给此 cmdlet。该 cmdlet 将提取 `Name` 属性值并使用它来识别要删除的缓存文件。

## OUTPUTS

### System.Object

指定 `-PassThru` 时，为每个已处理的缓存文件返回一条状态记录。每个输出对象包含以下属性：

- **Status**：操作结果（`Removed`、`Missing`、`DryRun`、`SkippedByUser` 或 `Error`）
- **CacheFile**：已处理的缓存文件的完整路径
- **Message**：解释操作结果的描述性文本
- **Name**：与缓存文件关联的脚本的名称

## NOTES

**作者**：尼克
**模块**：ColorScripts-Enhanced

缓存文件以 `.cache` 扩展名存储在模块的缓存目录中。每个缓存文件对应一个颜色脚本并包含预渲染的 ANSI 输出。

显示相应的策略选定渲染器或调用 `New-ColorScriptCache` 时，会重新生成符合条件的缓存条目。可静态提取的捆绑脚本不符合缓存条件，也不会创建缓存条目。

查询 `(Get-ColorScriptConfiguration).Cache.EffectivePath` 以获取默认有效路径。可以使用持久配置或 `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` 覆盖它； `-Path` 一次调用的目标目录不同。

使用 `-DryRun` 或 `-WhatIf` 时，cmdlet 仍将验证缓存目录是否存在并报告任何问题，但不会执行任何删除。

按 `-Category` 或 `-Tag` 进行过滤要求脚本具有关联的元数据。没有元数据的脚本将不匹配这些过滤器。

### 最佳实践

- 在破坏性操作之前始终使用 `-DryRun` 或 `-WhatIf`
- 仅当您确定操作时才使用 `-Confirm:$false`
- 在主要清理操作之前存档缓存以进行恢复
- 定期监控磁盘空间以了解缓存增长
- 尽可能使用选择性清洁而不是全面清洁
- 跟踪不应清除的关键脚本
- 在维护时段安排自动清理
- 首先在非生产环境中测试清理操作

### 故障排除 (2)

- **“未找到缓存文件”**：检查 `(Get-ColorScriptConfiguration).Cache.EffectivePath` 并使用 `Export-ColorScriptMetadata -IncludeCacheInfo` 验证缓存状态
- **“权限被拒绝”**：验证对缓存目录的写访问权限
- **“缓存未重新生成”**：脚本可能存在渲染问题；使用 `-NoCache` 进行测试

## RELATED LINKS

- [在线版本](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache)

