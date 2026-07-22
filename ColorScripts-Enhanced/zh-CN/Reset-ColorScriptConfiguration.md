---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

将 ColorScripts-Enhanced 配置恢复为其默认值。

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

此命令没有别名。

## DESCRIPTION

`Reset-ColorScriptConfiguration` 用内置默认值替换持久配置，并重置模块的内存缓存状态。执行时，此 cmdlet：

- 清除配置的缓存路径覆盖，以便使用有效的平台默认值
- 恢复 `AutoShowOnImport`、`ProfileAutoShow` 和 `DefaultScript`
- 将默认配置写入 `config.json`
- 清除内存缓存/配置状态，以便后续操作使用重置值

此 cmdlet 支持 `-WhatIf` 和 `-Confirm` 参数，因为它通过覆盖配置文件来执行破坏性操作。重置操作无法自动撤消，因此用户应考虑在继续之前使用 `Get-ColorScriptConfiguration` 备份当前配置。

重置完成后，使用 `-PassThru` 参数立即检查新恢复的默认设置。

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

重置配置而不提示确认。这在自动化脚本中或当您确定要重置为默认值时非常有用。

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

重置配置并返回生成的哈希表以供检查，从而允许您验证默认值。

### EXAMPLE 3

```powershell
# 重置前备份当前配置
$backup = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
```

备份当前配置后，使用 `-WhatIf` 预览重置操作而不实际执行它。

### EXAMPLE 4

```powershell
Reset-ColorScriptConfiguration -Verbose
```

使用详细输出重置配置以查看有关操作的详细信息。

### EXAMPLE 5

```powershell
# 重置配置并清除缓存以完全恢复出厂设置
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "模块重置为出厂默认设置！"
```

执行完整的出厂重置，包括配置、缓存和重建缓存。

### EXAMPLE 6

```powershell
# 验证重置是否成功
$config = Reset-ColorScriptConfiguration -PassThru
if ($null -eq $config.Cache.Path -and $config.Cache.EffectivePath) {
    Write-Host "配置成功重置为平台默认值"
} else {
    Write-Host "配置重置但使用自定义路径：$($config.Cache.Path)"
}
```

重置并验证持久缓存覆盖是否为空以及有效的平台路径是否可用。

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

显示该命令的详细帮助而不执行操作。

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

重置完成后返回更新的配置对象。

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

显示如果 cmdlet 运行而不实际执行重置操作会发生什么情况。

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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
有关详细信息，请参阅
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

此 cmdlet 不接受管道输入。

## OUTPUTS

### System.Collections.Hashtable

当指定 `-PassThru` 时返回。

## NOTES

配置文件存放在`Get-ColorScriptConfiguration`解析的目录下。默认情况下，此位置是特定于平台的：

- **Windows**：`$env:APPDATA\ColorScripts-Enhanced`
- **Linux/macOS**：`$HOME/.config/ColorScripts-Enhanced`

如果在模块导入之前设置，环境变量 `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` 可以覆盖默认位置。

## RELATED LINKS

- [在线版本](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)

