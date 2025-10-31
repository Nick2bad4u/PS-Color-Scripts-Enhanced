---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/zh-CN/Export-ColorScriptMetadata.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Export-ColorScriptMetadata

## SYNOPSIS

将颜色脚本元数据导出到各种格式以供外部使用。

## SYNTAX

```
Export-ColorScriptMetadata [-Path] <string> [[-Format] <string>] [-Category <string[]>] [-Tag <string[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

将颜色脚本的综合元数据导出到外部文件，用于文档、报告或与其他工具的集成。支持多种输出格式，包括 JSON、CSV 和 XML。

导出的元数据包括：
- 脚本名称和文件路径
- 类别和标签
- 描述和元数据
- 文件大小和修改日期
- 缓存状态信息

此 cmdlet 有助于：
- 生成文档
- 创建清单
- 与 CI/CD 系统集成
- 备份和迁移目的
- 分析和报告

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata -Path "colorscripts.json"
```

将所有颜色脚本元数据导出到 JSON 文件。

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -Path "inventory.csv" -Format CSV
```

以 CSV 格式导出元数据，用于电子表格分析。

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path "nature-scripts.xml" -Category Nature -Format XML
```

仅将自然主题的颜色脚本导出到 XML 格式。

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path "geometric.json" -Tag geometric
```

将标记为 "geometric" 的颜色脚本导出到 JSON。

### EXAMPLE 5

```powershell
# Export with timestamp
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
Export-ColorScriptMetadata -Path "backup-$timestamp.json"
```

创建所有元数据的带时间戳的备份。

## PARAMETERS

### -Category

在导出前按一个或多个类别过滤导出的脚本。

```yaml
Type: System.String[]
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

运行 cmdlet 前提示您进行确认。

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

### -Format

指定输出格式。有效值为 JSON、CSV 和 XML。

```yaml
Type: System.String
DefaultValue: JSON
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

### -Path

指定保存导出元数据文件的路径。

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

在导出前按一个或多个标签过滤导出的脚本。

```yaml
Type: System.String[]
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

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 或更高版本

**Output Formats:**
- JSON：用于编程访问的结构化数据
- CSV：电子表格兼容格式
- XML：层次数据结构

**Use Cases:**
- 文档生成
- 清单管理
- CI/CD 集成
- 备份和恢复
- 分析和报告

## RELATED LINKS

- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
