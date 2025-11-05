---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/zh-CN/Reset-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

重置 ColorScripts-Enhanced 配置为默认值。

## SYNTAX

```
Reset-ColorScriptConfiguration [-WhatIf] [-Confirm] [<CommonParameters>]
```

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
DefaultValue: true
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

### -WhatIf

显示 cmdlet 运行时会发生什么。Cmdlet 不会运行。

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

此 cmdlet 支持通用参数：-Debug、-ErrorAction、-ErrorVariable、-InformationAction、-InformationVariable、-OutBuffer、-OutVariable、-PipelineVariable、-ProgressAction、-Verbose、-WarningAction 和 -WarningVariable。有关更多信息，请参阅 [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

此 cmdlet 不接受来自管道的输入。

## OUTPUTS

### None

此 cmdlet 不返回输出到管道。

## NOTES

**作者：** Nick
**模块：** ColorScripts-Enhanced
**需要：** PowerShell 5.1 或更高版本

**重置范围：**
重置所有用户可配置设置到模块默认值。这包括缓存路径、性能设置和显示首选项。

**数据安全：**
配置重置不会影响缓存的脚本输出或用户创建的颜色脚本。只影响配置设置。

**恢复：**
重置后，如果需要，使用 Set-ColorScriptConfiguration 重新应用自定义设置。

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
