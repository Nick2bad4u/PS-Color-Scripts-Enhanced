---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/zh-CN/Clear-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Clear-ColorScriptCache

## SYNOPSIS

清除缓存的颜色脚本输出文件。

## SYNTAX

```
Clear-ColorScriptCache [[-Name] <string[]>] [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

删除颜色脚本的缓存输出文件，以在下次显示时强制执行新鲜执行。此 cmdlet 为单个脚本或批量操作提供目标缓存管理。

缓存系统存储渲染的 ANSI 输出，以提供近乎即时的显示性能。随着时间的推移，如果源脚本被修改，缓存文件可能会过时，或者您可能出于故障排除目的想要清除缓存。

使用此 cmdlet 的情况：

- 源颜色脚本已被修改
- 怀疑缓存损坏
- 您想要确保新鲜执行
- 希望释放磁盘空间

此 cmdlet 支持目标清除（特定脚本）和批量操作（所有缓存文件）。

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -Name "spectrum"
```

清除名为 "spectrum" 的特定颜色脚本的缓存。

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -All
```

清除所有缓存的颜色脚本文件。

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name "aurora*", "geometric*"
```

清除与指定通配符模式匹配的颜色脚本的缓存。

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Name aurora-waves -WhatIf
```

显示将清除哪些缓存文件，而不实际删除它们。

### EXAMPLE 5

```powershell
# Clear cache for all scripts in a category
Get-ColorScriptList -Category Nature -AsObject | ForEach-Object {
    Clear-ColorScriptCache -Name $_.Name
}
```

清除所有自然主题颜色脚本的缓存。

## PARAMETERS

### -All

清除所有缓存的颜色脚本文件。不能与 -Name 参数一起使用。

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
HelpMessage: ""
```

### -Confirm

运行 cmdlet 之前提示您确认。

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
HelpMessage: ""
```

### -Name

指定要从缓存中清除的颜色脚本名称。支持通配符（\* 和 ?）进行模式匹配。

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
 - Name: Name
   Position: 0
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
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
HelpMessage: ""
```

### CommonParameters

此 cmdlet 支持通用参数：-Debug、-ErrorAction、-ErrorVariable、-InformationAction、-InformationVariable、-OutBuffer、-OutVariable、-PipelineVariable、-ProgressAction、-Verbose、-WarningAction 和 -WarningVariable。有关更多信息，请参阅 [about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

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

**缓存位置：**
缓存文件存储在模块管理的目录中。使用 `(Get-Module ColorScripts-Enhanced).ModuleBase` 定位模块目录，然后查找缓存子目录。

**何时清除缓存：**

- 修改源颜色脚本文件后
- 故障排除显示问题时
- 确保脚本的新鲜执行
- 性能基准测试前

**性能影响：**
清除缓存将导致脚本在下次显示时正常运行，这可能比缓存执行需要更长的时间。缓存将在后续显示时自动重建。

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
