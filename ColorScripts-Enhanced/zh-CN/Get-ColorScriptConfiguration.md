---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/zh-CN/Get-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptConfiguration

## SYNOPSIS

检索当前 ColorScripts-Enhanced 配置设置。

## SYNTAX

```
Get-ColorScriptConfiguration [<CommonParameters>]
```

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

### CommonParameters

此 cmdlet 支持通用参数：-Debug、-ErrorAction、-ErrorVariable、
-InformationAction、-InformationVariable、-OutBuffer、-OutVariable、-PipelineVariable、
-ProgressAction、-Verbose、-WarningAction 和 -WarningVariable。有关更多信息，请参见
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

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

**Configuration Properties:**

- CachePath：存储缓存脚本输出的位置
- 用于优化的性能设置
- 默认行为的显示偏好
- 模块特定的配置选项

**Configuration Location:**
设置存储在用户特定的配置文件中。使用标准的 PowerShell 配置机制来实现持久性。

## RELATED LINKS

- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
