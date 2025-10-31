---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/zh-CN/Set-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Set-ColorScriptConfiguration

## SYNOPSIS

修改 ColorScripts-Enhanced 配置设置。

## SYNTAX

```
Set-ColorScriptConfiguration [-CachePath <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

使用持久存储更新 ColorScripts-Enhanced 配置设置。此 cmdlet 允许通过用户可配置选项自定义模块行为。

可配置设置包括：
- 缓存目录位置
- 性能优化偏好
- 默认显示行为
- 模块操作设置

更改会自动保存到用户特定的配置文件中，并在 PowerShell 会话之间保持。使用 Get-ColorScriptConfiguration 查看当前设置。

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath "C:\MyCache"
```

设置自定义缓存目录路径。

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -CachePath $env:TEMP
```

使用系统临时目录进行缓存存储。

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "~/.colorscript-cache"
```

使用 Unix 风格的主目录表示法设置缓存路径。

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -WhatIf
```

显示 cmdlet 运行时会发生什么，而不实际运行 cmdlet。

### EXAMPLE 5

```powershell
# 备份当前配置，修改，然后在需要时恢复
$currentConfig = Get-ColorScriptConfiguration
Set-ColorScriptConfiguration -CachePath "D:\Cache"
# ... 测试新配置 ...
# Set-ColorScriptConfiguration -CachePath $currentConfig.CachePath
```

演示配置备份和恢复。

## PARAMETERS

### -CachePath

指定存储颜色脚本缓存文件的目录路径。

```yaml
Type: System.String
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
HelpMessage: ''
```

### -Confirm

在运行 cmdlet 之前提示您确认。

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
HelpMessage: ''
```

### -WhatIf

显示 cmdlet 运行时会发生什么。cmdlet 不会运行。

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
HelpMessage: ''
```

### CommonParameters

此 cmdlet 支持通用参数：-Debug、-ErrorAction、-ErrorVariable、-InformationAction、-InformationVariable、-OutBuffer、-OutVariable、-PipelineVariable、-ProgressAction、-Verbose、-WarningAction 和 -WarningVariable。有关详细信息，请参阅 [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

此 cmdlet 不接受来自管道的输入。

## OUTPUTS

### None

此 cmdlet 不向管道返回输出。

## NOTES

**作者：** Nick
**模块：** ColorScripts-Enhanced
**需要：** PowerShell 5.1 或更高版本

**配置持久性：**
设置会自动保存到用户特定的配置文件中，并在 PowerShell 会话之间保持。

**路径解析：**
缓存路径支持环境变量、相对路径和标准 PowerShell 路径表示法。

**验证：**
配置更改在应用之前会进行验证，以防止无效设置。

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [在线文档](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
