---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

显示带有选择性缓存的彩色脚本，用于昂贵的渲染器。

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-ShowInfo] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

### Help

```
Show-ColorScript [-h] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Named

```
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-ShowInfo] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

### List

```
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### All

```
Show-ColorScript [-All] [-WaitForInput] [-NoClear] [-NoCache] [-Category <string[]>]
 [-Tag <string[]>] [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-ShowInfo]
 [-Quiet] [-NoAnsiOutput] [-ValidateCache]
```

## ALIASES

- `scs`

## DESCRIPTION

在终端中渲染 ANSI 颜色脚本，并且只对高开销渲染器应用选择性性能优化。该 cmdlet 提供四种主要操作模式：

**随机模式（默认）：** 显示从可用集合中随机选择的颜色脚本。这是未指定参数时的默认行为。

**命名模式：** 按名称显示特定的颜色脚本。支持通配符模式，灵活匹配。当多个脚本与某个模式匹配时，将选择按字母顺序排列的第一个匹配项。

**列表模式：** 显示包含颜色脚本名称和主要类别的紧凑表格。使用 `Get-ColorScriptList -AsObject` 获取完整的元数据记录。

**所有模式：** 按字母顺序循环显示所有可用的颜色脚本。对于展示整个集合或发现新脚本特别有用。

对于可静态提取的捆绑脚本，模块通过范围受限且失败时拒绝处理的 AST 求值器获取输出，而不执行脚本。明确列入允许列表的捆绑动态脚本在隔离的进程内运行空间中执行。未知或自定义脚本在子进程中执行，以防止会话状态泄漏。运行空间和子进程都不是安全沙箱；脚本以当前用户的权限运行。

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

显示随机颜色脚本。可静态提取的捆绑脚本无需执行即可获取输出；合格的计算型渲染器可以重用经过验证的缓存输出。

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

按确切名称显示指定的颜色脚本。不需要 .ps1 扩展名。

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

显示与通配符模式“aurora-\*”匹配的第一个颜色脚本（按字母顺序）。当您记住脚本名称的一部分时很有用。

### EXAMPLE 4

```powershell
scs hearts
```

使用模块的别名“scs”快速访问红心颜色脚本。别名为频繁使用提供了方便的快捷方式。

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

按名称和主要类别列出可用的颜色脚本。有助于快速发现。

### EXAMPLE 6

```powershell
Show-ColorScript -Name Galaxy -NoCache
```

显示符合条件的 Galaxy 渲染器，而不读取缓存的输出，强制进行新的隔离渲染。在测试渲染器更改或调查缓存损坏时很有用。

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

显示随机的自然主题脚本并捕获其元数据对象以供进一步检查或处理。

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

渲染颜色脚本并将输出保存到文本文件。渲染的 ANSI 代码将被保留，以便稍后以适当的颜色显示文件。

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

按字母顺序显示所有颜色脚本，每个颜色脚本之间有短暂的自动延迟。非常适合整个系列的视觉展示。

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

一次显示一个所有颜色脚本，每个颜色脚本后暂停。按空格键前进到下一个脚本，或按“q”提前退出序列。

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

通过手动进度循环浏览所有以自然为主题的颜色脚本。将过滤与交互式浏览相结合，提供精心策划的体验。

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

显示带有“复古”或“几何”标签的随机颜色脚本。多个标签值使用任意匹配语义。

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Artistic,Abstract
```

仅列出分类为“艺术”或“抽象”的彩色脚本，帮助您发现特定主题内的脚本。

### EXAMPLE 14

```powershell
# 检查策略选择的渲染器的缓存资格和构建状态。
New-ColorScriptCache -Name Galaxy -Force -PassThru |
    Select-Object Name, Status, CacheFile
Show-ColorScript -Name Galaxy
```

构建并检查符合条件的渲染器的缓存条目，而无需声明独立于机器的性能乘数。

### EXAMPLE 15

```powershell
# 设置不同颜色脚本的每日轮换
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

每天根据日期显示一致但不同的颜色脚本。

### EXAMPLE 16

```powershell
# 将渲染的颜色脚本导出到文件以供共享
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# 稍后显示保存的文件
Get-Content "./aurora.ansi" -Raw | Write-Host
```

将渲染的颜色脚本保存到文件中，以便稍后显示或与其他人共享。

### EXAMPLE 17

```powershell
# 创建几何彩色脚本的幻灯片
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

自动显示一系列几何彩色脚本，每个几何彩色脚本之间有 3 秒的延迟。

### EXAMPLE 18

```powershell
# 错误处理示例
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "未找到脚本：$_"
    Show-ColorScript  # 回退到随机
}
```

演示请求不存在的脚本时的错误处理。

### EXAMPLE 19

```powershell
# 构建自动化集成
if ($env:CI) {
    Show-ColorScript -Name "Galaxy" -NoCache
} else {
    Show-ColorScript  # 随机显示供交互使用
}
```

展示如何在 CI/CD 环境与交互式会话中有条件地显示不同的颜色脚本。

### EXAMPLE 20

```powershell
# 终端问候定时任务
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

演示作为计划任务或启动自动化的一部分运行特定的颜色脚本。

### EXAMPLE 21

```powershell
Show-ColorScript -IncludePokemon
```

演示已弃用的兼容性开关。由于神奇宝贝和异色神奇宝贝脚本已正常参与选择，因此该开关在一个版本中静默且无操作。

### EXAMPLE 22

```powershell
Show-ColorScript -Random -ExcludeCategory Pokemon,ShinyPokemon
```

显示随机颜色脚本，同时排除两个神奇宝贝类别。与 `-Category` 或 `-Tag` 结合以进一步细化选择。

### EXAMPLE 23

```powershell
Show-ColorScript -Random -ShowInfo
```

显示随机颜色脚本，然后将其脚本名称和完整路径写入信息流。使用 `-Quiet` 可禁止显示标识行。

## PARAMETERS

### -All

按字母顺序循环浏览所有可用的颜色脚本。单独指定时，脚本会连续显示，并带有短暂的自动延迟。与 `-WaitForInput` 结合使用可手动控制集合的进度。此模式非常适合展示完整的图书馆或发现新的收藏夹。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

在进行任何选择或显示之前，按一个或多个类别过滤可用脚本集合。类别通常是广泛的主题，如“自然”、“抽象”、“艺术”、“复古”等。可以将多个类别指定为数组。此参数与所有模式（随机、命名、列表、全部）结合使用，以缩小工作集范围。

```yaml
Type: System.String[]
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

### -ExcludeCategory

在进行选择之前，从一个或多个类别中排除脚本。例如，使用 `-ExcludeCategory Pokemon,ShinyPokemon` 排除所有神奇宝贝脚本，或指定任何其他类别组合。适用于所有模式（随机、命名、列表、全部），并与 `-Category` 和 `-Tag` 过滤器结合使用。

```yaml
Type: System.String[]
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
DefaultValue: False
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

已弃用的兼容性开关。由于神奇宝贝和异色神奇宝贝颜色脚本已正常参与选择，因此在一个版本中作为无操作静默开关接受。使用 `-ExcludeCategory Pokemon,ShinyPokemon` 可将其排除。

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
HelpMessage: ''
```

### -List

显示所有可用颜色脚本及其关联元数据的格式化列表。输出包括脚本名称、类别、标签和描述。这对于探索可用选项和了解集合的组织很有用。可以与 `-Category` 或 `-Tag` 结合使用以仅列出过滤的子集。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: List
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

要显示的颜色脚本的名称（不带 .ps1 扩展名）。支持通配符模式（\* 和 ?）以实现灵活匹配。当多个脚本与通配符模式匹配时，将选择并显示按字母顺序排列的第一个匹配项。使用 `-PassThru` 验证使用通配符时选择了哪个脚本。

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Named
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
HelpMessage: ''
```

### -NoCache

绕过策略选定渲染器的已验证缓存读取，并强制执行新的隔离渲染。这适用于测试渲染器更改或调查缓存损坏。可静态提取的捆绑脚本、策略之外的脚本以及自定义脚本本来就不使用缓存。可静态提取的捆绑内容仍然无需执行脚本即可获取。

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
HelpMessage: ''
```

### -NoClear

与 `-All` 一起使用时，跳过颜色脚本之间的自动 `Clear-Host` 调用，以便每个渲染的脚本在下一个脚本之上保持可见。当您想要并排比较脚本或捕获会话记录中的整个展示时，这特别有用。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -PassThru

除了显示颜色脚本之外，还将所选颜色脚本的元数据对象返回到管道。元数据对象包含名称、路径、类别、标签和描述等属性。这使得能够以编程方式访问脚本信息以进行过滤、记录或进一步处理，同时仍然呈现视觉输出。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Named
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
HelpMessage: ''
```

### -Random

明确请求随机颜色脚本选择。这是未指定名称时的默认行为，因此此开关主要用于使脚本清晰或当您想要明确选择模式时。可以与 `-Category` 或 `-Tag` 结合使用，在过滤的子集中进行随机化。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ReturnText

将渲染的颜色脚本作为字符串发送到 PowerShell 管道，而不是直接写入控制台主机。这允许将输出捕获在变量中、重定向到文件或通过管道传输到其他命令。输出保留所有 ANSI 转义序列，因此当稍后写入兼容终端时，它将以正确的颜色显示。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- AsString
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

### -ShowInfo

渲染每个选定的颜色脚本后，向信息流写入一行简洁内容，其中包含脚本名称和完整路径。`-Quiet` 会禁止显示此行。`-ReturnText` 的输出不包含此行，`-PassThru` 则继续返回结构化元数据。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Named
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

按元数据标签过滤可用脚本集合（不区分大小写）。标签是比类别更具体的描述符，例如“几何”、“复古”、“动画”、“最小”等。多个标签可以指定为一个数组。在选择发生之前，与任何指定标签匹配的脚本将包含在工作集中。

```yaml
Type: System.String[]
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

### -ValidateCache

在渲染之前刷新模块级缓存元数据标记，包括当缓存目录已在当前模块会话中初始化时。它不会重建输出缓存条目或替换正常的每条目验证。将 `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE` 设置为 `1`、`true` 或 `yes` 会在缓存初始化期间请求相同的刷新。

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
HelpMessage: ''
```

### -WaitForInput

与 `-All` 一起使用时，在显示每个颜色脚本后暂停并等待用户输入，然后再继续。按空格键前进到序列中的下一个脚本。按“q”提前退出序列并返回到提示符。这为整个集合提供了交互式浏览体验。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### CommonParameters

此 cmdlet 支持以下常用参数：
有关详细信息，请参阅
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

此 cmdlet 不接受管道输入。将库存记录通过管道传输到 `ForEach-Object` 中，并在构建管道时调用 `Show-ColorScript -Name $_.Name` 。

## OUTPUTS

### System.Object

指定 `-PassThru` 时，返回所选颜色脚本的元数据对象，其中包含名称、路径、类别、标签和描述等属性。

### System.String (2)

当指定 `-ReturnText` 时，将渲染的颜色脚本作为字符串发送到管道。该字符串包含所有 ANSI 转义序列，以便在兼容终端中显示时正确呈现颜色。

### None

在默认操作中（没有 `-PassThru` 或 `-ReturnText`），输出直接写入控制台主机，并且不会将任何内容返回到管道。

## NOTES

**作者：** 尼克
**模块：** ColorScripts-Enhanced
**需要：** PowerShell 5.1 或更高版本

## RELATED LINKS

- [在线版本](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

