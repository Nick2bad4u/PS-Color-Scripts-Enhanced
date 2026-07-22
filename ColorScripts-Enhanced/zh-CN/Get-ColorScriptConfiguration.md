---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

检索当前的 ColorScripts-Enhanced 模块配置设置。

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

此命令没有别名。

## DESCRIPTION

`Get-ColorScriptConfiguration` 返回有效模块配置的副本。当前架构包含：

- **缓存设置**：配置的覆盖和解析的有效缓存目录
- **启动行为**：`AutoShowOnImport`、`ProfileAutoShow` 和 `DefaultScript`

配置由多个源按优先顺序组装而成：

1.内置模块默认（最低优先级）
2. 从配置文件中保留用户覆盖
3、`COLOR_SCRIPTS_ENHANCED_CACHE_PATH`为返回的有效缓存路径

配置文件通常位于 Windows 上的 `%APPDATA%\ColorScripts-Enhanced\config.json` 或类 Unix 系统上的 `~/.config/ColorScripts-Enhanced/config.json` 处。

返回的哈希表是当前配置状态的快照，可以安全地检查、克隆或序列化，而不会影响活动配置。

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

使用默认表视图显示当前配置，显示所有缓存和启动设置。

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

将配置序列化为 JSON 格式，以便进行日志记录、调试或导出到其他工具。

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.EffectivePath
```

检索已解析的缓存目录。 `Cache.Path` 仍然是可选的用户配置覆盖；
`Cache.EffectivePath` 显示平台默认后模块实际使用的目录
应用环境覆盖。

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.AutoShowOnImport) {
    Write-Host "启动脚本已启用"
}
```

检查当前配置中是否启用启动脚本。

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

以详细列表格式显示所有配置属性，以便进行全面检查。

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "缓存路径：$($config.Cache.Path)"
Write-Host "配置文件自动显示：$($config.Startup.ProfileAutoShow)"
Write-Host "默认脚本：$($config.Startup.DefaultScript)"
```

提取并显示特定的配置属性以用于审核或脚本编写目的。

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "配置的自定义缓存路径：$($config.Cache.Path)"
} else {
    Write-Host "使用默认缓存路径"
}

Write-Host "有效缓存路径：$($config.Cache.EffectivePath)"
```

确定是否配置自定义缓存路径与使用模块默认值。

### EXAMPLE 8

```powershell
$config = Get-ColorScriptConfiguration
$config | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

将当前配置备份到 JSON 文件以进行存档或灾难恢复。

### EXAMPLE 9

```powershell
# 将当前配置与默认配置进行比较
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# 查看 -WhatIf 输出以查看会发生什么变化
```

将当前配置与模块默认值进行比较以识别自定义设置。

### EXAMPLE 10

```powershell
# 监控跨会话的配置更改
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

创建带有时间戳的配置快照，以跟踪一段时间内的更改。

## PARAMETERS

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

返回包含以下结构的嵌套哈希表：

- **Cache** (Hashtable)：缓存相关设置
- **Path**（字符串）：可选的持久缓存路径覆盖
- **EffectivePath**（字符串）：模块当前使用的已解析缓存目录
- **Startup**（哈希表）：启动行为设置
- **AutoShowOnImport** （布尔值）：导入是否调用启动显示行为
- **ProfileAutoShow**（布尔值）：托管配置文件块的默认自动显示选择
- **DefaultScript**（字符串）：可选的命名启动颜色脚本

## NOTES

**模块初始化**：加载 ColorScripts-Enhanced 模块时会自动初始化配置。此 cmdlet 检索当前内存中配置状态。

**无修改**：调用此 cmdlet 是只读的，不会修改任何持久设置或活动配置。

**线程安全**：返回的哈希表是配置的副本，使其可以安全地并发访问和修改，而不会影响模块的内部状态。

**性能**：配置检索是轻量级的，适合频繁调用，因为它返回缓存的内存中配置，而不是从磁盘读取。

**配置文件格式**：持久化配置使用带有 UTF-8 编码的 JSON 格式。支持手动编辑，但不推荐；使用 `Set-ColorScriptConfiguration` 代替。

### 最佳实践

- 查询配置一次并重复使用结果
- 在使用值之前验证配置
- 监控配置随时间的漂移
- 仅在无法暴露计算机特定路径或私有数据的地方保留备份
- 记录对配置进行的任何定制
- 首先在非生产中测试配置更改
- 使用配置审核日志来确保合规性

## RELATED LINKS

- [在线版本](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

