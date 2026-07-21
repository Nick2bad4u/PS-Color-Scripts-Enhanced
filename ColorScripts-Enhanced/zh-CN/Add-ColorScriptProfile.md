---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

将 ColorScripts-Enhanced 集成添加到 PowerShell 配置文件中。

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

自动将 ColorScripts-Enhanced 启动集成添加到您的 PowerShell 配置文件中。此 cmdlet 修改您的配置文件以导入 ColorScripts-Enhanced 模块，并在会话启动时可选地显示颜色脚本。

此 cmdlet 支持所有标准 PowerShell 配置文件范围：

- CurrentUserCurrentHost：当前用户和当前主机的配置文件
- CurrentUserAllHosts：当前用户跨所有主机的配置文件
- AllUsersCurrentHost：当前主机上所有用户的配置文件（需要管理员权限）
- AllUsersAllHosts：跨所有主机所有用户的配置文件（需要管理员权限）

执行时，它添加一个代码片段，该片段：

1. 导入 ColorScripts-Enhanced 模块
2. 可选地在启动时显示随机颜色脚本
3. 提供便捷的别名以便快速访问

此集成设计为非侵入性的，可以通过直接编辑配置文件轻松移除。

## EXAMPLES

### EXAMPLE 1

```powershell
Add-ColorScriptProfile
```

将 ColorScripts-Enhanced 集成添加到您的默认配置文件（CurrentUserCurrentHost）。

### EXAMPLE 2

```powershell
Add-ColorScriptProfile -Scope CurrentUserAllHosts
```

将集成添加到适用于当前用户所有 PowerShell 主机的配置文件中。

### EXAMPLE 3

```powershell
Add-ColorScriptProfile -Scope AllUsersCurrentHost
```

将集成添加到当前主机上所有用户的配置文件中（需要管理员权限）。

### EXAMPLE 4

```powershell
Add-ColorScriptProfile -WhatIf
```

显示运行 cmdlet 时会发生什么，而不实际运行 cmdlet。

### EXAMPLE 5

```powershell
Add-ColorScriptProfile -Confirm
```

在修改您的配置文件之前提示确认。

## PARAMETERS

### -AutoShow

Controls whether the managed profile block displays a colorscript after importing the module.

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

Specifies the colorscript name written to the managed profile block for startup display.

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

Updates the managed profile block without removing unrelated profile content.

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

显示此命令的详细帮助，而不执行操作。

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

Allows Pokemon-themed scripts when the managed profile block displays a random colorscript.

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

预先回答宝可梦提示（Y/Yes 或 N/No）。同时尊重环境变量
`COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE` 和全局变量
`$Global:ColorScriptsEnhancedPokemonPromptResponse`。

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

Specifies the PowerShell profile file to update. The Path alias is also accepted.

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

在更新配置文件时跳过缓存预热。也尊重环境变量 `COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` 和全局变量
`$Global:ColorScriptsEnhancedSkipCacheBuild`。如果配置文件路径位于临时目录下，会自动跳过。

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

跳过启动时是否包含宝可梦脚本的提示。

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

Adds the module import but omits the startup Show-ColorScript invocation.

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

显示运行 cmdlet 时会发生什么。cmdlet 不会运行。

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

### None (2)

此 cmdlet 不向管道返回输出。

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 或更高版本

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
