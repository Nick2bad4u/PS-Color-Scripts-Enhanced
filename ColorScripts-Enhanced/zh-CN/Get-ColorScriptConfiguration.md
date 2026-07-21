---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

检索当前 ColorScripts-Enhanced 配置设置。

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

显示 ColorScripts-Enhanced 的当前配置设置。这包括缓存路径、性能设置以及影响模块行为的用户偏好。

配置系统提供持久设置，用于自定义模块的操作。设置存储在用户特定的配置文件中，可以使用 Set-ColorScriptConfiguration 修改。

显示的信息包括：

- 缓存目录位置
- 性能优化设置
- 默认显示偏好
- 模块行为设置

此 cmdlet 对于了解当前模块配置和排除配置相关问题至关重要。

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

显示所有当前配置设置。

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | Format-List
```

以列表格式显示配置，以提高可读性。

### EXAMPLE 3

```powershell
# Check cache location
(Get-ColorScriptConfiguration).CachePath
```

仅检索缓存路径设置。

### EXAMPLE 4

```powershell
# Verify configuration is loaded
if (Get-ColorScriptConfiguration) {
    Write-Host "Configuration loaded successfully"
}
```

检查配置是否正确加载。

## PARAMETERS

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

此 cmdlet 不接受来自管道的输入。

## OUTPUTS

### System.Object

返回包含配置属性的自定义对象。

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

