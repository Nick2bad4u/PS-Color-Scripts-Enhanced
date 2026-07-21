---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

修改 ColorScripts-Enhanced 配置设置。

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

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

### -AutoShowOnImport

Controls whether importing the module automatically displays a colorscript.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -CachePath

指定存储颜色脚本缓存文件的目录路径。

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

### -Confirm

在运行 cmdlet 之前提示您确认。

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

### -DefaultScript

Specifies the default colorscript used by startup and profile integration.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
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

Returns the effective configuration after the requested changes succeed.

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

### -ProfileAutoShow

Controls whether profile integration displays a colorscript after importing the module.

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -WhatIf

显示 cmdlet 运行时会发生什么。cmdlet 不会运行。

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

**作者：** Nick
**模块：** ColorScripts-Enhanced
**需要：** PowerShell 5.1 或更高版本

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)

