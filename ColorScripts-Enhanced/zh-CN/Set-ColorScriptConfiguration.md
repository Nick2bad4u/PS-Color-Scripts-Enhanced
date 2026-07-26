---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

保留对 ColorScripts-Enhanced 缓存和启动配置的更改。

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

此命令没有别名。

## DESCRIPTION

`Set-ColorScriptConfiguration` 提供了一种持久的方法来自定义 ColorScripts-Enhanced 模块的行为和存储位置。此 cmdlet 更新模块的配置文件，允许您控制脚本呈现和存储的各个方面。

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

将缓存移至 `D:/Temp/ColorScriptsCache`，启用模块导入时自动显示，禁用配置文件自动显示，并将 `bars` 设置为默认脚本。

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

清除默认脚本并返回生成的配置对象，以便您验证设置是否已删除。

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

将缓存重新定位到 Windows TEMP 目录并以列表格式显示完整更新的配置。对于临时测试场景很有用。

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

模块加载时禁用自动颜色脚本渲染。如果您更喜欢手动控制脚本的显示时间，这很有用。

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

使用波浪号扩展设置 Linux/macOS 样式的缓存路径，并将“crunch”配置为所有操作的默认脚本。

## PARAMETERS

### -AutoShowOnImport

导入模块时启用或禁用颜色脚本的自动渲染。启用后 (`$true`)，模块导入后会立即显示彩色脚本，提供即时视觉反馈。禁用 (`$false`) 时，脚本仅在显式调用时显示。如果未指定，则现有设置保持不变。

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

指定存储渲染后的 `.cache` 有效负载和 `.cacheinfo` 验证伴随元数据文件的目录。源颜色脚本和模块元数据保留在已安装的模块中。支持绝对路径、相对路径（从当前位置解析）、环境变量（例如 `$env:USERPROFILE`）和波形符（`~`）扩展。

如果指定的目录不存在，则会自动创建并具有适当的权限。提供空字符串 (`''`) 以清除自定义路径并恢复到特定于平台的默认位置。如果未指定，则保留现有的缓存路径设置。

**注意**：更改缓存路径不会自动迁移现有的缓存文件。您可能需要手动复制文件或允许重新生成它们。

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

### -DefaultScript

设置或清除配置文件助手、自动显示功能以及命令中未明确指定脚本时使用的默认颜色脚本名称。这应该与不带扩展名的脚本文件的基本名称匹配（例如 `'bars'`，而不是 `'bars.ps1'`）。

提供一个空字符串 (`''`) 以删除存储的默认值，恢复到模块级默认行为（通常是随机选择）。当省略此参数时，当前默认脚本设置不变。

指定的脚本必须存在于模块的脚本目录中才能成功使用。

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

进行更改后返回更新的配置对象。如果没有此开关，cmdlet 将静默运行（无输出）。返回的对象具有与 `Get-ColorScriptConfiguration` 相同的结构，可以检查、存储或通过管道传输到其他 cmdlet 以进行进一步处理。

对于验证、记录或链接配置命令很有用。

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

控制 `Add-ColorScriptProfile` 生成的配置文件片段是否包含自动 `Show-ColorScript` 调用。当 `$true` 时，配置文件代码将在每次 shell 启动时显示彩色脚本。当 `$false` 时，配置文件将加载模块，但不会自动显示脚本。

该设置仅影响新生成的配置文件代码；现有的配置文件修改不会自动更新。省略此参数将使当前设置保持不变。

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

在仅报告将发生的情况而不执行操作的模式下运行命令。

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
有关详细信息，请参阅
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

此 cmdlet 不接受管道输入。

## OUTPUTS

### None (2)

默认情况下，此 cmdlet 不产生输出。

### System.Collections.Hashtable

当指定 `-PassThru` 时，返回由 `Get-ColorScriptConfiguration` 生成的嵌套哈希表：缓存值位于 `Cache` 下，启动值位于 `Startup` 下。

## NOTES

仅当验证和确认成功后，配置才会保留。 `-WhatIf` 不执行文件系统写入操作。使用`Get-ColorScriptConfiguration`查看操作后的有效值和存储路径。

## RELATED LINKS

- [在线版本](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)

