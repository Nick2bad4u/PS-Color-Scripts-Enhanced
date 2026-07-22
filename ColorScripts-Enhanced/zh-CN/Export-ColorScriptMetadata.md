---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: zh-CN
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Export-ColorScriptMetadata
---

# Export-ColorScriptMetadata

## SYNOPSIS

将所有颜色脚本的综合元数据导出为 JSON 格式或将结构化对象发送到管道。

## SYNTAX

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-h] [-IncludeFileInfo] [-IncludeCacheInfo]
 [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

此命令没有别名。

## DESCRIPTION

`Export-ColorScriptMetadata` cmdlet 编译模块目录中所有颜色脚本的全面清单，并生成描述每个条目的结构化数据集。此元数据包括基本信息，例如脚本名称、类别、标签和可选的丰富内容。

默认情况下，cmdlet 将 PowerShell 对象返回到管道。当提供 `-Path` 参数时，它将元数据以 JSON 格式写入指定文件，如果父目录不存在，则自动创建父目录。

该 cmdlet 提供两个可选的丰富标志：

- **IncludeFileInfo**：添加文件系统元数据，包括完整路径、文件大小（以字节为单位）和上次修改时间戳
- **IncludeCacheInfo**：附加缓存相关信息，包括缓存文件路径、存在状态和缓存时间戳

此 cmdlet 特别适用于：

- 创建显示所有可用颜色脚本的文档或仪表板
- 报告原始缓存有效负载文件的存在和时间戳
- 将元数据提供给外部工具或自动化管道
- 审核颜色脚本清单和文件系统状态
- 生成有关颜色脚本使用和组织的报告

输出的顺序一致，使其适合导出为 JSON 时的版本控制和 diff 操作。

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

将所有颜色脚本的基本元数据导出到管道，无需文件或缓存信息。

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

返回包含每个颜色脚本的文件系统详细信息（完整路径、大小和上次写入时间）的对象。

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

生成包含基本元数据的 JSON 文件并将其写入 `dist` 目录，如果该文件夹不存在则创建该文件夹。

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

生成一个全面的 JSON 文件，其中包含丰富的元数据，包括文件系统和缓存信息，并将其写入 `dist` 目录。

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeCacheInfo -PassThru | Where-Object { -not $_.CacheExists }
```

写入元数据文件并返回原始 `.cache` 负载不存在的记录。这仅报告文件占用情况，而不报告缓存资格、有效性或当前性。

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

按类别对颜色脚本进行分组并显示计数，这对于分析跨类别的脚本分布很有用。

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property ScriptSizeBytes -Sum).Sum
Write-Host "所有彩色脚本的总大小：$($totalSize / 1KB) KB"
```

计算所有颜色脚本文件使用的总磁盘空间。

### EXAMPLE 8

```powershell
# 生成统计数据并保存报告
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachePayloadFiles = ($metadata | Where-Object CacheExists).Count
    TotalScriptSizeBytes = ($metadata | Measure-Object ScriptSizeBytes -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

生成库存统计信息并计算原始 `.cache` 有效负载文件。有效负载存在不是缓存资格、有效性或当前性检查。

### EXAMPLE 9

```powershell
# 导出并与之前的备份进行比较
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "新脚本：$($new.Count) | 删除的脚本：$($removed.Count)"
```

将当前元数据与先前版本进行比较以识别更改。

### EXAMPLE 10

```powershell
# 为 Web 仪表板构建 API 响应
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

生成包含版本控制和时间戳信息的 API 就绪 JSON。

### EXAMPLE 11

```powershell
# 构建或验证每个策略选择的缓存条目并审查状态。
$results = New-ColorScriptCache -All -PassThru
$results | Group-Object Status | Select-Object Name, Count
```

使用缓存策略作为事实来源，并报告符合条件的条目是否已更新、已为最新、已跳过或失败。

### EXAMPLE 12

```powershell
# 从元数据创建 HTML 画廊
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$html = @"
<html>
<head><title>ColorScripts-Enhanced Gallery</title></head>
<body>
<h1>ColorScripts-Enhanced</h1>
<ul>
"@
foreach ($script in $metadata) {
    $html += "<li><strong>$($script.Name)</strong> [$($script.Category)]</li>`n"
}
$html += "</ul></body></html>"
$html | Out-File "./gallery.html" -Encoding UTF8
```

创建一个 HTML 画廊页面，列出所有可用的颜色脚本。

### EXAMPLE 13

```powershell
# 随着时间的推移监控脚本大小
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object ScriptSizeBytes -Average).Average) bytes avg" }
```

跟踪多个导出过程中各个脚本的文件大小变化。

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
DefaultValue: False
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

### -IncludeCacheInfo

将原始 `.cache` 有效负载路径、文件存在标志和上次写入时间戳添加到每条记录。这些字段不表示缓存策略资格，也不表示 `.cacheinfo` 伴随元数据文件是否存在、是否有效或是否为最新版本。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -IncludeFileInfo

每个记录中包括文件系统详细信息（完整路径、字节大小和上次写入时间）。当无法读取文件元数据（由于权限或丢失文件）时，将通过详细输出记录错误，并将受影响的属性设置为空值。此开关对于审核文件大小和修改日期非常有用。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -PassThru

即使指定了 `-Path` 参数，也会将元数据对象返回到管道。这允许您将元数据保存到文件中，并在单个命令中对对象执行附加处理或过滤。如果没有此开关，指定 `-Path` 将抑制管道输出。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

指定 JSON 导出的目标文件路径。支持相对路径、绝对路径、环境变量（例如 `$env:TEMP\metadata.json`）和波浪号扩展（例如 `~/Documents/metadata.json`）。如果父目录不存在，则会自动创建。当省略此参数时，cmdlet 将直接将对象输出到管道，而不是写入文件。 JSON 输出采用缩进格式以提高可读性。

```yaml
Type: System.String
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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
有关详细信息，请参阅
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

此 cmdlet 不接受管道输入。

## OUTPUTS

### System.Management.Automation.PSCustomObject

当未指定 `-Path` 或使用 `-PassThru` 时，cmdlet 返回自定义对象。每个对象代表一个具有以下基本属性的颜色脚本：

- **Name**：不带扩展名的颜色脚本文件名
- **Category**：主要组织类别
- **Categories**：所有指定的类别
- **Tags**：用于筛选和搜索的描述性标签数组
- **Description**：元数据描述

当指定 `-IncludeFileInfo` 时，将包括以下附加属性：

- **ScriptPath**：脚本文件的完整文件系统路径
- **ScriptSizeBytes**：大小（以字节为单位）（如果文件无法访问则为空）
- **ScriptLastWriteTimeUtc**：上次修改的 UTC 时间戳（如果不可用则为 null）

当指定 `-IncludeCacheInfo` 时，将包括以下附加属性：

- **CachePath**：对应缓存文件的完整路径
- **CacheExists**：指示原始 .cache 有效负载文件是否存在的布尔值；此值不表示策略资格、有效性或是否为最新状态
- **CacheLastWriteTimeUtc**：缓存文件修改的UTC时间戳（如果缓存不存在则为空）

## NOTES

## RELATED LINKS

- [在线版本](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)

