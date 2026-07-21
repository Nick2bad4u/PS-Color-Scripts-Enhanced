---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

使用自动缓存显示颜色脚本以增强性能。

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
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
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
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
 [-Tag <string[]>] [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

## ALIASES

- `scs`

## DESCRIPTION

在您的终端中渲染美丽的 ANSI 颜色脚本，具有智能性能优化。该 cmdlet 提供四种主要操作模式：

**随机模式（默认）：** 从可用集合中显示随机选择的颜色脚本。当未指定参数时，这是默认行为。

**命名模式：** 按名称显示特定的颜色脚本。支持通配符模式以实现灵活匹配。当多个脚本匹配模式时，按字母顺序选择第一个匹配项。

**列表模式：** 显示所有可用颜色脚本的格式化列表及其元数据，包括名称、类别、标签和描述。

**全部模式：** 按字母顺序循环显示所有可用颜色脚本。特别适用于展示整个集合或发现新脚本。

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

显示启用缓存的随机颜色脚本。这是为您的终端会话添加视觉风格的最快方法。

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

按确切名称显示指定的颜色脚本。不需要 .ps1 扩展名。

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

显示（按字母顺序）匹配通配符模式"aurora-\*"的第一个颜色脚本。当您记住脚本名称的一部分时很有用。

### EXAMPLE 4

```powershell
scs hearts
```

使用模块的别名 'scs' 快速访问 hearts 颜色脚本。别名提供频繁使用的便捷快捷方式。

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

以格式化表格列出所有可用颜色脚本及其元数据。有助于发现可用脚本及其属性。

### EXAMPLE 6

```powershell
Show-ColorScript -Name arch -NoCache
```

不使用缓存显示 arch 颜色脚本，强制新鲜执行。在开发期间或排除缓存问题时很有用。

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

显示随机自然主题脚本并捕获其元数据对象以进行进一步检查或处理。

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

渲染颜色脚本并将其输出保存到文本文件中。渲染的 ANSI 代码被保留，允许稍后显示文件时具有正确的着色。

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

按字母顺序显示所有颜色脚本，每个之间有短暂的自动延迟。非常适合整个集合的视觉展示。

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

一次显示一个颜色脚本，每个后暂停。按空格键前进到下一个脚本，或按 'q' 提前退出序列。

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

使用手动进度循环显示所有自然主题颜色脚本。将过滤与交互式浏览相结合以获得定制体验。

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

显示具有"retro"和"geometric"标签的随机颜色脚本。标签过滤启用精确子集选择。

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Art,Abstract
```

仅列出分类为"Art"或"Abstract"的颜色脚本，帮助您发现特定主题中的脚本。

### EXAMPLE 14

```powershell
# Measure performance improvement from caching
$uncached = Measure-Command { Show-ColorScript -Name spectrum -NoCache }
$cached = Measure-Command { Show-ColorScript -Name spectrum }
Write-Host "Uncached: $($uncached.TotalMilliseconds)ms | Cached: $($cached.TotalMilliseconds)ms | Speedup: $([math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 1))x"
```

通过测量执行时间演示缓存提供的性能改进。

### EXAMPLE 15

```powershell
# Set up daily rotation of different colorscripts
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

根据日期显示一致但不同的颜色脚本每天。

### EXAMPLE 16

```powershell
# Export rendered colorscript to file for sharing
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Later, display the saved file
Get-Content "./aurora.ansi" -Raw | Write-Host
```

将渲染的颜色脚本保存到文件中，可以稍后显示或与他人共享。

### EXAMPLE 17

```powershell
# Create a slideshow of geometric colorscripts
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

Automatically displays a sequence of geometric colorscripts with 3-second delays between each.

### EXAMPLE 18

```powershell
# Error handling example
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Script not found: $_"
    Show-ColorScript  # Fallback to random
}
```

Demonstrates error handling when requesting a script that doesn't exist.

### EXAMPLE 19

```powershell
# Build automation integration
if ($env:CI) {
    Show-ColorScript -Name "nerd-font-test" -NoCache
} else {
    Show-ColorScript  # Random display for interactive use
}
```

Shows how to conditionally display different colorscripts in CI/CD environments vs. interactive sessions.

### EXAMPLE 20

```powershell
# Scheduled task for terminal greeting
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

Demonstrates running a specific colorscript as part of scheduled task or startup automation.

## PARAMETERS

### -All

Cycle through all available colorscripts in alphabetical order. When specified alone, scripts are displayed continuously with a short automatic delay. Combine with `-WaitForInput` to manually control progression through the collection. This mode is ideal for showcasing the full library or discovering new favorites.

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

Filter the available script collection by one or more categories before any selection or display occurs. Categories are typically broad themes like "Nature", "Abstract", "Art", "Retro", etc. Multiple categories can be specified as an array. This parameter works in conjunction with all modes (Random, Named, List, All) to narrow the working set.

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

Exclude scripts from one or more categories.
Use this to filter out large collections like Pokemon scripts.

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

显示此命令的详细帮助，而不执行操作。

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

Opt-in flag to include Pokemon colorscripts in the random selection.
When omitted, Pokemon scripts are filtered out automatically.

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

Display a formatted list of all available colorscripts with their associated metadata. The output includes script name, category, tags, and description. This is useful for exploring available options and understanding the collection's organization. Can be combined with `-Category` or `-Tag` to list only filtered subsets.

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

The name of the colorscript to display (without the .ps1 extension). Supports wildcard patterns (\* and ?) for flexible matching. When multiple scripts match a wildcard pattern, the first match in alphabetical order is selected and displayed. Use `-PassThru` to verify which script was chosen when using wildcards.

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

为纯文本环境禁用信息性消息和渲染输出中的 ANSI 样式。

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

Bypass the caching system and execute the colorscript directly. This forces fresh execution and can be useful when testing script modifications, debugging, or when cache corruption is suspected. Without this switch, cached output is used when available for optimal performance.

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

When cycling through scripts with -All, skip clearing the host between displays so prior output remains visible.

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

Return the selected colorscript's metadata object to the pipeline in addition to displaying the colorscript. The metadata object contains properties like Name, Path, Category, Tags, and Description. This enables programmatic access to script information for filtering, logging, or further processing while still rendering the visual output.

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

禁止显示信息性消息，但保留命令输出和错误。

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

Explicitly request a random colorscript selection. This is the default behavior when no name is specified, so this switch is primarily useful for clarity in scripts or when you want to be explicit about the selection mode. Can be combined with `-Category` or `-Tag` to randomize within a filtered subset.

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

Emit the rendered colorscript as a string to the PowerShell pipeline instead of writing directly to the console host. This allows the output to be captured in a variable, redirected to a file, or piped to other commands. The output retains all ANSI escape sequences, so it will display with proper colors when later written to a compatible terminal.

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

### -Tag

Filter the available script collection by metadata tags (case-insensitive). Tags are more specific descriptors than categories, such as "geometric", "retro", "animated", "minimal", etc. Multiple tags can be specified as an array. Scripts matching any of the specified tags will be included in the working set before selection occurs.

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

Forces cache validation before rendering.
Use when you need to rebuild cached colorscript output manually.

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

When used with `-All`, pause after displaying each colorscript and wait for user input before proceeding. Press the spacebar to advance to the next script in the sequence. Press 'q' to quit the sequence early and return to the prompt. This provides an interactive browsing experience through the entire collection.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

You can pipe colorscript names to Show-ColorScript. This enables pipeline-based workflows where script names are generated or filtered by other commands.

## OUTPUTS

### System.Object

When `-PassThru` is specified, returns the selected colorscript's metadata object containing properties like Name, Path, Category, Tags, and Description.

### System.String (2)

When `-ReturnText` is specified, emits the rendered colorscript as a string to the pipeline. This string contains all ANSI escape sequences for proper color rendering when displayed in a compatible terminal.

### None

In default operation (without `-PassThru` or `-ReturnText`), output is written directly to the console host and nothing is returned to the pipeline.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

