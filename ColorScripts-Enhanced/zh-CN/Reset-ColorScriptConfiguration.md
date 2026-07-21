---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

重置 ColorScripts-Enhanced 配置为默认值。

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

恢复 ColorScripts-Enhanced 配置设置到其默认值。此 cmdlet 删除所有用户自定义设置，并将模块返回到其原始配置状态。

重置操作包括：

- 缓存路径设置
- 性能首选项
- 显示选项
- 模块行为设置

此 cmdlet 在以下情况下很有用：

- 配置变得损坏时
- 您想要使用默认设置重新开始时
- 排除配置相关问题时
- 为干净的模块测试做准备时

重置操作默认需要确认，以防止意外数据丢失。

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration
```

重置所有配置设置到默认值，并显示确认提示。

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

在不显示确认提示的情况下重置配置。

### EXAMPLE 3

```powershell
Reset-ColorScriptConfiguration -WhatIf
```

显示 cmdlet 运行时会发生什么，而不应用它们。

### EXAMPLE 4

```powershell
# 重置并验证
Reset-ColorScriptConfiguration
Get-ColorScriptConfiguration
```

重置配置并显示新的默认设置。

## PARAMETERS

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

### -PassThru

Returns the effective default configuration after the reset succeeds.

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

显示 cmdlet 运行时会发生什么。Cmdlet 不会运行。

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

此 cmdlet 不返回输出到管道。

## NOTES

**作者：** Nick
**模块：** ColorScripts-Enhanced
**需要：** PowerShell 5.1 或更高版本

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)
