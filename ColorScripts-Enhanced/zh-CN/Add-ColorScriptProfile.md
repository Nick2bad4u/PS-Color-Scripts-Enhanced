---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

在 PowerShell 配置文件中添加或更新托管 ColorScripts-Enhanced 启动块。

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

此命令没有别名。

## DESCRIPTION

将托管启动块添加到选定的 PowerShell 配置文件。该块导入 ColorScripts-Enhanced，并可以在导入后调用 `Show-ColorScript`。 `-SkipStartupScript` 写入仅导入块。

当省略 `-ProfilePath` 时，该命令优先选择 `$PROFILE.CurrentUserAllHosts`，否则使用第一个定义的配置文件路径。需要时会创建配置文件和缺失的父目录。

现有的托管或旧版 ColorScripts-Enhanced 块将被替换而不是重复。如果配置文件已导入托管块外部的模块，则该命令将使其保持不变，除非指定 `-Force`。 `-Force` 允许替换已识别的模块内容，同时保留不相关的配置文件内容。

生成的启动行为是通过显式参数和持久配置解析的。`-AutoShow` 明确启用显示，`-DefaultStartupScript` 选择命名脚本。神奇宝贝脚本正常参与；新的托管配置文件不会询问神奇宝贝，也不会输出 `-IncludePokemon`。除非使用 `-SkipCacheBuild`，否则该命令可以在更新配置文件后预热策略选择的缓存条目。

## EXAMPLES

### EXAMPLE 1

添加到所有主机的当前用户配置文件（默认行为）。

```powershell
Add-ColorScriptProfile
```

这会将模块导入和 `Show-ColorScript` 调用添加到 `$PROFILE.CurrentUserAllHosts` 中。

### EXAMPLE 2

仅添加到当前主机的当前用户配置文件，而不添加启动脚本。

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost -SkipStartupScript
```

这会将仅导入的托管块添加到当前主机配置文件中。

### EXAMPLE 3

添加到具有环境变量扩展的自定义配置文件路径。

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

这针对的是标准 PowerShell 配置文件位置之外的特定配置文件。

### EXAMPLE 4

强制重新添加片段，即使它已经存在。

```powershell
Add-ColorScriptProfile -Force
```

这会更新已识别的 ColorScripts-Enhanced 配置文件内容，同时保留不相关的配置文件行。

### EXAMPLE 5

在新计算机上进行设置 - 如果需要，创建配置文件并将 ColorScript 添加到所有主机。

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts -Confirm:$false
Write-Host "配置文件已配置！重新启动终端以在启动时查看颜色脚本。"
```

### EXAMPLE 6

添加特定的颜色脚本以用于启动显示：

```powershell
Add-ColorScriptProfile -DefaultStartupScript mandelbrot-zoom -AutoShow
```

### EXAMPLE 7

验证配置文件是否已正确添加：

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

明确以当前主机或所有主机配置文件为目标：

```powershell
# 仅适用于 Windows 终端或 ConEmu
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost

# 对于所有 PowerShell 主机（ISE、VSCode、控制台）
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts
```

### EXAMPLE 9

使用相对路径和波形符扩展：

```powershell
# 对主目录使用波形符扩展
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# 使用当前目录相对路径
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

通过添加自定义逻辑显示每日不同的颜色脚本：

```powershell
Add-ColorScriptProfile -SkipStartupScript
# 然后手动将其添加到 $PROFILE 中：
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

### EXAMPLE 11

在现有自动化调用中使用已弃用的兼容性开关：

```powershell
Add-ColorScriptProfile -IncludePokemon
```

此开关在一个兼容版本中作为无操作静默开关接受。神奇宝贝脚本已正常参与，生成的配置文件只调用 `Show-ColorScript`。

## PARAMETERS

### -AutoShow

控制托管配置文件块在导入模块后是否显示颜色脚本。

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

### -DefaultStartupScript

指定写入托管配置文件块以供启动显示的颜色脚本名称。

```yaml
Type: System.String
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

### -Force

更新配置文件中识别出的 ColorScripts-Enhanced 内容，同时保留不相关的行。此参数不会故意追加重复的托管块。

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

显示此 cmdlet 的帮助信息。相当于使用 `Get-Help Add-ColorScriptProfile`。

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

### -IncludePokemon

已弃用的兼容性开关。在一个版本中作为无操作静默开关接受；神奇宝贝颜色脚本已正常参与，生成的配置文件不会输出此开关。

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

### -PokemonPromptResponse

已弃用的兼容性参数。由于配置文件生成不再询问神奇宝贝，因此在一个版本中作为无操作静默参数接受。

```yaml
Type: System.String
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

### -ProfilePath

指定要更新的 PowerShell 配置文件。路径别名也被接受。

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Path
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

### -SkipCacheBuild

抑制可选的缓存预热。仅当解决 `ProfileAutoShow` 时才会尝试预热
设置已启用，缓存构建未以其他方式禁用，目标配置文件位于
系统临时目录，且该操作经过`ShouldProcess`批准。该命令还尊重
环境变量 `COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` 和全局变量
`$Global:ColorScriptsEnhancedSkipCacheBuild`。

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

### -SkipPokemonPrompt

已弃用的兼容性开关。由于配置文件生成不再询问神奇宝贝，因此在一个版本中作为无操作静默开关接受。

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

### -SkipStartupScript

跳过将 `Show-ColorScript` 添加到配置文件。仅附加 `Import-Module ColorScripts-Enhanced` 行。如果您想手动控制颜色脚本的显示时间，请使用此选项。

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

### -WhatIf

显示 cmdlet 运行时会发生什么情况。该 cmdlet 未运行。

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

### None

此 cmdlet 不接受管道输入。

## OUTPUTS

### System.Object

返回具有以下属性的自定义对象：

- **Path**（字符串）：所选配置文件的完整路径
- **Changed** (bool)：配置文件是否实际被修改
- **Message**（字符串）：描述操作结果的状态消息
- **IncludePokemon** (bool)：始终为 `$true`；暂时保留以兼容结果对象
- **CacheBuilt** (bool): 可选的缓存预热是否完成

## NOTES

**作者：** 尼克

**模块：** ColorScripts-Enhanced

**需要：** PowerShell 5.1 或更高版本

如果配置文件不存在，则会自动创建，包括必要的父目录。该命令管理用户提供的文件路径；它不公开单独的范围选择器。

## RELATED LINKS

- [在线版本](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)

