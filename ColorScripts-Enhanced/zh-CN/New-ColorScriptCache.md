---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

仅为 CachePolicy.psd1 选定的高开销渲染器预构建或刷新缓存。

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

`New-ColorScriptCache` 渲染策略选定的计算型颜色脚本，并将其输出保存为无 BOM 的 UTF-8。合格的捆绑渲染器使用模块的隔离执行路径；并行工作程序可在 PowerShell 7 及更高版本中使用。可静态提取的捆绑脚本不符合缓存条件，也不会创建缓存文件。别名为 `Update-ColorScriptCache` 和 `Build-ColorScriptCache`。

您可以按名称（支持通配符）、类别或标签来定位脚本。未指定参数时，cmdlet 会直接解析 `CachePolicy.psd1` 中的名称，而不会枚举完整集合。精确的捆绑名称也使用直接文件查找。仅当匹配语义需要时，才会枚举通配符、类别和标签请求。显式指定但不在策略中的脚本会标记为 `SkippedNotRequired`；使用 `-PassThru` 时会返回该结果，并删除这些脚本的所有过时缓存文件。

默认情况下，cmdlet 显示进度以及缓存操作和有效缓存目录的简明摘要。使用 `-PassThru` 返回每个脚本的详细结果对象，您可以通过编程方式检查其状态、标准输出和错误流。结合 `-Quiet` 来完全抑制进度和摘要，或者结合 `-NoAnsiOutput` 来为不支持它们的环境发出没有 ANSI 颜色代码的纯文本摘要。

除非指定 `-Force` 参数，否则 cmdlet 会跳过缓存文件已是最新的脚本。重复构建会验证小型 `<name>.cacheinfo` 伴随元数据文件，而不加载渲染后的 `<name>.cache` 有效负载。`-Force` 会重建符合条件的缓存条目，但绝不会覆盖缓存策略。

这两个文件都位于 `(Get-ColorScriptConfiguration).Cache.EffectivePath` 中。`.cache` 文件包含渲染后的终端输出；`.cacheinfo` 仅包含验证元数据。没有有效负载的伴随元数据文件不是可用的缓存条目，将由下一次构建修复。`Clear-ColorScriptCache -All` 会删除完整条目和孤立的伴随元数据文件。

为了在多核系统上更快地重建，请将 `-Parallel` 开关与 `-ThrottleLimit` （或 `-Threads`）参数一起使用来控制工作线程数。当无法在当前主机上创建并行运行空间时，cmdlet 会自动恢复为顺序执行。

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

仅解析和预热策略选择的计算渲染器，而不枚举模块附带的每个脚本。这是未指定参数时的默认行为。

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name Galaxy, 'rose-*'
```

缓存精确匹配和通配符匹配的混合。仅构建 `CachePolicy.psd1` 中包含的匹配；其他匹配报告 `SkippedNotRequired` 和 `-PassThru`。

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name Galaxy -Force -PassThru | Format-List
```

强制重建符合条件的“Galaxy”缓存，即使它是最新的，并检查详细的结果对象。

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Mathematical' -PassThru
```

评估 `Mathematical` 类别中的脚本，缓存符合条件的渲染器，并返回每场比赛的详细结果。

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

为标记有“几何”或“彩色”的脚本重建符合条件的缓存，即使缓存是最新的，也强制重新生成。

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Mathematical -AsObject | New-ColorScriptCache -PassThru
```

管道示例：评估 `Mathematical` 类别中的脚本，缓存任何策略选择的渲染器，并返回每个匹配的结果。

### EXAMPLE 7

```powershell
# 构建后检查缓存统计信息
$cachePath = (Get-ColorScriptConfiguration).Cache.EffectivePath
$before = @(Get-ChildItem $cachePath -Filter "*.cache" -ErrorAction SilentlyContinue).Count
New-ColorScriptCache
$after = @(Get-ChildItem $cachePath -Filter "*.cache").Count
Write-Host "缓存脚本：$before -> $after"
```

通过在操作之前和之后对策略选择的缓存文件进行计数来测量缓存增长。

### EXAMPLE 8

```powershell
# 为常用的计算渲染器构建缓存
$frequentScripts = @('Galaxy', 'rose-curves', 'wave-interference')
New-ColorScriptCache -Name $frequentScripts -PassThru | Format-Table Name, Status, ExitCode
```

为 `CachePolicy.psd1` 下符合条件的列出脚本构建缓存；未列出的名称将被跳过。

### EXAMPLE 9

```powershell
# 使用内置的策略范围进度显示
New-ColorScriptCache -All
```

显示策略选择渲染器的内置进度，无需手动迭代所有可用脚本。

### EXAMPLE 10

```powershell
# （可选）从 PowerShell 配置文件中填充丢失或过时的策略条目。
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Quiet
```

当配置文件加载时检查策略选择的条目，并仅构建丢失或过时的条目。当不需要启动缓存工作时，请忽略此配置文件步骤。

### EXAMPLE 11

```powershell
# 重建每个策略选择的部署条目
New-ColorScriptCache -All -Force -PassThru |
    Select-Object Name, Status |
    Export-Csv "./cache-deployment.csv"
```

重建每个策略选择的缓存条目并将状态导出到部署清单。

### EXAMPLE 12

```powershell
# 查找缓存构建失败
New-ColorScriptCache -Name "Galaxy" -Force -PassThru |
    Where-Object Status -eq 'Failed' |
    Select-Object Name, StdErr
```

识别缓存失败，而不将策略跳过视为错误。

### EXAMPLE 13

```powershell
# 计算本次运行更新的策略选择条目的数量
New-ColorScriptCache -All -PassThru |
    Where-Object Status -eq 'Updated' |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

检查每个策略选择的条目并显示本次运行更新了多少缓存有效负载。

### EXAMPLE 14

```powershell
New-ColorScriptCache -All -Parallel -Threads 8
```

使用八个工作线程构建所有策略选择的缓存。当并行作业在当前主机上不可用时，cmdlet 会自动回退到顺序执行。

## PARAMETERS

### -All

直接解析每个缓存策略条目。仅处理策略选择的脚本；不会列出完整的颜色脚本清单。

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

按元数据类别过滤评估的脚本（不区分大小写）。多个值被视为 OR 过滤器。仅缓存 `CachePolicy.psd1` 允许的匹配项；其他匹配报告 `SkippedNotRequired` 和 `-PassThru`。

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

在运行 cmdlet 之前提示您进行确认。当缓存大量脚本或使用 `-Force` 来防止意外的缓存重新生成时很有用。

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

重建符合条件的缓存条目，即使它们的 `.cacheinfo` 验证元数据表明它们是最新的。这不会覆盖 `CachePolicy.psd1`。

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

### -IncludePokemon

扩大了评估神奇宝贝脚本的资格选择范围。它不会覆盖 `CachePolicy.psd1`；只能缓存 `CacheablePokemonScripts` 中列出的神奇宝贝名称，并且该列表当前为空。

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

用于评估缓存的一个或多个颜色脚本名称。支持通配符模式（例如 `aurora-*` 和 `*-wave`）。仅当在 `CachePolicy.psd1` 中列出时才会缓存匹配的脚本。当省略此参数和所有过滤器时，仅解析和评估策略条目。

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

在信息输出中禁用 ANSI 颜色序列。这在不渲染 ANSI 转义码（例如某些 CI/CD 日志）的环境中非常有用，同时在需要时仍保留彩色输出。

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

启用多线程缓存构建。指定后，cmdlet 会跨运行空间池执行缓存作业，以便在有能力的系统上更快地完成。与 `-ThrottleLimit` （或 `-Threads` 别名）结合使用来控制并发工作线程的数量。如果无法初始化多线程，cmdlet 会自动回退到顺序执行。

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

返回每个缓存操作的详细结果对象。默认情况下，仅显示摘要。结果对象包括 Name、Status、CacheFile、ExitCode、StdOut 和 StdErr 等属性，允许以编程方式检查缓存过程。

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

抑制每个脚本的进度和信息摘要输出。当您只需要结构化输出（通过 `-PassThru`）或当自动化方案应静默信息消息同时仍显示警告和错误时，请使用此开关。

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

按元数据标签过滤评估的脚本（不区分大小写）。多个值被视为 OR 过滤器。仅缓存 `CachePolicy.psd1` 允许的匹配项；其他匹配报告 `SkippedNotRequired` 和 `-PassThru`。

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

指定请求 `-Parallel` 时并发缓存工作器的最大数量。接受 1 到 256 之间的值。默认值（省略时）是当前计算机上的逻辑处理器数量。为方便起见，提供了别名 `-Threads`。小于或等于 1 的值会自动恢复为顺序执行。

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

显示如果 cmdlet 运行而不实际执行缓存操作会发生什么情况。对于在提交操作之前预览将缓存哪些脚本非常有用。

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
有关详细信息，请参阅
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### System.String

您可以通过管道将脚本名称传递给此 cmdlet。每个字符串都被视为潜在的脚本名称并支持通配符匹配。

### System.String[]

您可以将具有 `Name` 属性的脚本名称或元数据记录数组通过管道传输到此 cmdlet 以进行批处理。

## OUTPUTS

### System.Object

当指定 `-PassThru` 时，为每个已处理的脚本返回一个包含以下属性的自定义对象：

- **Name**：颜色脚本名称
- **ScriptPath**：源颜色脚本的完整路径
- **CacheFile**：生成的缓存文件的完整路径
- **Status**：`Updated`、`SkippedUpToDate`、`SkippedNotRequired`、`SkippedByUser` 或 `Failed`
- **Message**：本地化状态详细信息
- **CacheExists**：操作后原始 .cache 有效负载是否存在；此值不表示策略资格、有效性或是否为最新状态
- **ExitCode**：脚本执行的退出代码（0表示成功）
- **StdOut**：脚本执行期间捕获的标准输出
- **StdErr**：脚本执行期间捕获的标准错误输出

如果没有 `-PassThru`，则写入包含已处理、已更新、已跳过和失败计数以及有效缓存目录的简明信息摘要。

## NOTES

**作者：** 尼克
**模块：** ColorScripts-Enhanced

**别名：** `Update-ColorScriptCache` 和 `Build-ColorScriptCache`。

缓存文件存储在 `(Get-ColorScriptConfiguration).Cache.EffectivePath` 下。伴随元数据中的源和策略签名用于确定条目是否保持最新。

该 cmdlet 仅缓存需要执行且缓存策略允许的渲染器。显式静态或未列出的脚本将报告为 `SkippedNotRequired` 并删除过时的条目。

## RELATED LINKS

- [在线版本](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)

