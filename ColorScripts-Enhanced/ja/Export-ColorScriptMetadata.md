---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ja/Export-ColorScriptMetadata.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Export-ColorScriptMetadata

## SYNOPSIS

すべてのカラースクリプトの包括的なメタデータをJSON形式でエクスポートするか、パイプラインに構造化されたオブジェクトを出力します。

## SYNTAX

### Default (Default)

```
Export-ColorScriptMetadata [-Path <String>] [-IncludeFileInfo] [-IncludeCacheInfo] [-PassThru]
 [<CommonParameters>]
```

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-IncludeFileInfo] [-IncludeCacheInfo] [-PassThru]
 [<CommonParameters>]
```

## DESCRIPTION

`Export-ColorScriptMetadata` コマンドレットは、モジュールのカタログ内のすべてのカラースクリプトの包括的なインベントリをコンパイルし、各エントリを記述する構造化されたデータセットを生成します。このメタデータには、スクリプト名、カテゴリ、タグ、およびオプションのエンリッチメントなどの重要な情報が含まれます。

デフォルトでは、コマンドレットはPowerShellオブジェクトをパイプラインに返します。`-Path` パラメータが指定されると、メタデータをフォーマットされたJSONとして指定されたファイルに書き込み、親ディレクトリが存在しない場合は自動的に作成します。

コマンドレットは2つのオプションのエンリッチメントフラグを提供します：
- **IncludeFileInfo**: フルパス、ファイルサイズ（バイト単位）、最終変更タイムスタンプなどのファイルシステムメタデータを追加します
- **IncludeCacheInfo**: キャッシュファイルパス、存在ステータス、キャッシュタイムスタンプなどのキャッシュ関連情報を追加します

このコマンドレットは特に以下の用途に役立ちます：
- 利用可能なすべてのカラースクリプトを表示するドキュメントまたはダッシュボードの作成
- キャッシュカバレッジの分析とキャッシュ再構築が必要なスクリプトの特定
- 外部ツールまたは自動化パイプラインへのメタデータのフィード
- カラースクリプトインベントリとファイルシステムステータスの監査
- カラースクリプトの使用と組織に関するレポートの生成

出力は一貫して順序付けられているため、JSONにエクスポートされた場合、バージョン管理と差分操作に適しています。

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

ファイルまたはキャッシュ情報なしで、すべてのカラースクリプトの基本メタデータをパイプラインにエクスポートします。

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

各カラースクリプトのファイルシステム詳細（フルパス、サイズ、最終書き込み時間）を含むオブジェクトを返します。

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

基本メタデータを含むJSONファイルを生成し、`dist` ディレクトリに書き込み、フォルダが存在しない場合は作成します。

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

ファイルシステムとキャッシュ情報の両方を含む包括的なメタデータを含むJSONファイルを生成し、`dist` ディレクトリに書き込みます。

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -PassThru | Where-Object { -not $_.CacheExists }
```

メタデータファイルを書き込み、オブジェクトもパイプラインに返し、キャッシュファイルのないスクリプトを特定するクエリを有効にします。

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

カラースクリプトをカテゴリでグループ化し、カウントを表示します。スクリプトのカテゴリ間分布を分析するのに役立ちます。

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property FileSize -Sum).Sum
Write-Host "Total size of all colorscripts: $($totalSize / 1KB) KB"
```

すべてのカラースクリプトファイルが使用する合計ディスク容量を計算します。

### EXAMPLE 8

```powershell
# Generate statistics and save report
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachedScripts = ($metadata | Where-Object CacheExists).Count
    TotalFileSize = ($metadata | Measure-Object FileSize -Sum).Sum
    TotalCacheSize = ($metadata | Where-Object CacheExists |
        Measure-Object CacheFileSize -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

キャッシュカバレッジとサイズを含む包括的な統計レポートを生成します。

### EXAMPLE 9

```powershell
# Export and compare with previous backup
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "New scripts: $($new.Count) | Removed scripts: $($removed.Count)"
```

現在のメタデータを以前のバージョンと比較して変更を特定します。

### EXAMPLE 10

```powershell
# Build API response for web dashboard
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

バージョン情報とタイムスタンプを含むAPI対応のJSONを生成します。

### EXAMPLE 11

```powershell
# Find scripts with missing cache for batch rebuild
$metadata = Export-ColorScriptMetadata -IncludeCacheInfo -AsObject
$uncached = $metadata | Where-Object { -not $_.CacheExists } | Select-Object -ExpandProperty Name
if ($uncached.Count -gt 0) {
    Write-Host "Rebuilding cache for $($uncached.Count) scripts..."
    New-ColorScriptCache -Name $uncached
}
```

キャッシュファイルのないスクリプトを特定し、バッチで再構築します。

### EXAMPLE 12

```powershell
# Create HTML gallery from metadata
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

利用可能なすべてのカラースクリプトをリストしたHTMLギャラリーページを作成します。

### EXAMPLE 13

```powershell
# Monitor script sizes over time
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object FileSize -Average).Average) bytes avg" }
```

複数のエクスポートにわたって個々のスクリプトのファイルサイズの変化を追跡します。

## PARAMETERS

### -IncludeCacheInfo

各レコードにキャッシュメタデータを追加します。これにはキャッシュファイルパス、キャッシュファイルが存在するかどうか、および最終変更タイムスタンプが含まれます。これは、キャッシュ再生成が必要なスクリプトを特定したり、カラースクリプトライブラリ全体のキャッシュカバレッジを分析したりするのに役立ちます。

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

各レコードにファイルシステム詳細（フルパス、バイト単位のサイズ、最終書き込み時間）を追加します。ファイルメタデータを読み取れない場合（権限や欠落ファイルによる）、エラーは詳細出力経由でログされ、影響を受けるプロパティはnull値に設定されます。このスイッチは、ファイルサイズと変更日付を監査するのに役立ちます。

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

`-Path` パラメータが指定された場合でも、メタデータオブジェクトをパイプラインに返します。これにより、ファイルを保存し、単一のコマンドでオブジェクトに対して追加の処理やフィルタリングを実行できます。このスイッチがない場合、`-Path` を指定するとパイプライン出力が抑制されます。

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

JSONエクスポートの宛先ファイルパスを指定します。相対パス、絶対パス、環境変数（例: `$env:TEMP\metadata.json`）、チルダ展開（例: `~/Documents/metadata.json`）をサポートします。親ディレクトリは存在しない場合に自動的に作成されます。このパラメータを省略すると、コマンドレットはファイルを書き込まずにオブジェクトをパイプラインに直接出力します。JSON出力は読みやすさのためにインデント付きでフォーマットされます。

```yaml
Type: System.String
DefaultValue: None
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

このコマンドレットはパイプラインからの入力を許可しません。

## OUTPUTS

### System.Management.Automation.PSCustomObject

`-Path` が指定されていない場合、または `-PassThru` が使用されている場合、コマンドレットは各カラースクリプトを表すカスタムオブジェクトを返します。各オブジェクトには以下の基本プロパティがあります：

- **Name**: 拡張子なしのカラースクリプトのファイル名
- **Category**: 組織化カテゴリ（例: "nature", "abstract", "geometric"）
- **Tags**: フィルタリングと検索のための記述タグの配列

`-IncludeFileInfo` が指定されている場合、以下の追加プロパティが含まれます：

- **FilePath**: スクリプトファイルへのフルファイルシステムパス
- **FileSize**: バイト単位のサイズ（ファイルにアクセスできない場合はnull）
- **LastWriteTime**: 最終変更のタイムスタンプ（利用できない場合はnull）

`-IncludeCacheInfo` が指定されている場合、以下の追加プロパティが含まれます：

- **CachePath**: 対応するキャッシュファイルへのフルパス
- **CacheExists**: キャッシュファイルが存在するかどうかを示すブール値
- **CacheLastWriteTime**: キャッシュファイルの変更タイムスタンプ（キャッシュが存在しない場合はnull）

## ADVANCED USAGE PATTERNS

### Data Analysis and Reporting

**包括的なインベントリレポート**
```powershell
# Generate complete inventory with all metadata
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo -PassThru

$report = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    TotalFileSize = ($metadata | Measure-Object -Property FileSize -Sum).Sum
    CachedScripts = ($metadata | Where-Object { $_.CacheExists }).Count
    CacheSize = ($metadata | Where-Object { $_.CacheExists } | Measure-Object -Property CacheFileSize -Sum).Sum
}

$report | ConvertTo-Json | Out-File "./inventory-report.json"
```

**カテゴリ分布分析**
```powershell
# Analyze distribution across categories
$metadata = Export-ColorScriptMetadata -IncludeFileInfo

$categories = $metadata | Group-Object Category | ForEach-Object {
    [PSCustomObject]@{
        Category = $_.Name
        Count = $_.Count
        TotalSize = ($_.Group | Measure-Object FileSize -Sum).Sum
        AverageSize = [math]::Round(($_.Group | Measure-Object FileSize -Average).Average, 0)
    }
}

$categories | Sort-Object Count -Descending | Format-Table
```

**キャッシュカバレッジ分析**
```powershell
# Identify cache gaps
$metadata = Export-ColorScriptMetadata -IncludeCacheInfo -PassThru

$uncached = $metadata | Where-Object { -not $_.CacheExists }
$cached = $metadata | Where-Object { $_.CacheExists }

Write-Host "Cache coverage: $([math]::Round($cached.Count / $metadata.Count * 100, 1))%"
Write-Host "Scripts without cache: $($uncached.Count)"

$uncached | Select-Object Name, Category | Format-Table
```

### Integration Workflows

**API Response Generation**
```powershell
# Build versioned API response
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object -ExpandProperty Version).ToString()
    timestamp = (Get-Date -Format 'o')
    scriptCount = $metadata.Count
    scripts = $metadata | Select-Object Name, Category, Tags, Description
    cacheStats = @{
        cached = ($metadata | Where-Object CacheExists).Count
        total = $metadata.Count
    }
} | ConvertTo-Json -Depth 5

$apiResponse | Out-File "./api/colorscripts-v1.json" -Encoding UTF8
```

**Web Gallery Generation**
```powershell
# Create interactive HTML gallery
$metadata = Export-ColorScriptMetadata -Detailed

$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>ColorScripts-Enhanced Gallery</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .script { border: 1px solid #ccc; padding: 10px; margin: 10px 0; }
    </style>
</head>
<body>
<h1>ColorScripts-Enhanced - $($metadata.Count) Scripts</h1>
"@

$metadata | ForEach-Object {
    $html += "<div class='script'><strong>$($_.Name)</strong> [$($_.Category)]<br/>Tags: $(($_.Tags -join ', '))</div>`n"
}

$html += "</body></html>"
$html | Out-File "./gallery.html" -Encoding UTF8
```

**Change Tracking**
```powershell
# Compare current state with previous export
Export-ColorScriptMetadata -Path "./metadata-current.json" -IncludeFileInfo

$current = Get-Content "./metadata-current.json" | ConvertFrom-Json
$previous = Get-Content "./metadata-previous.json" -ErrorAction SilentlyContinue | ConvertFrom-Json

if ($previous) {
    $added = $current | Where-Object { $_.Name -notin $previous.Name }
    $removed = $previous | Where-Object { $_.Name -notin $current.Name }

    Write-Host "Added: $($added.Count) scripts"
    Write-Host "Removed: $($removed.Count) scripts"
}
```

### Maintenance and Validation

**Health Check Automation**
```powershell
# Validate all scripts and cache status
$metadata = Export-ColorScriptMetadata -IncludeCacheInfo -IncludeFileInfo -PassThru

$health = $metadata | ForEach-Object {
    @{
        Name = $_.Name
        FileExists = Test-Path $_.FilePath
        Cached = $_.CacheExists
        FileAge = if (Test-Path $_.FilePath) { (Get-Date) - (Get-Item $_.FilePath).LastWriteTime } else { $null }
    }
}

$health | Where-Object { -not $_.FileExists -or -not $_.Cached } | Format-Table
```

**Performance Metrics**
```powershell
# Export with performance data
$startTime = Get-Date
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo

$metrics = @{
    ExportTime = ((Get-Date) - $startTime).TotalMilliseconds
    ScriptCount = $metadata.Count
    TotalFileSize = ($metadata | Measure-Object FileSize -Sum).Sum
    CacheHitRate = ($metadata | Where-Object CacheExists).Count / $metadata.Count
}

$metrics | ConvertTo-Json | Out-File "./performance.json"
```

### Backup and Disaster Recovery

**Metadata Backup**
```powershell
# Create timestamped metadata backup
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
Export-ColorScriptMetadata -Path "./backups/metadata-$timestamp.json" -IncludeFileInfo -IncludeCacheInfo

# Keep only last 5 backups
Get-ChildItem "./backups/metadata-*.json" | Sort-Object Name -Descending | Select-Object -Skip 5 | Remove-Item
```

**Recovery Validation**
```powershell
# Validate backed-up metadata against current state
$backup = Get-Content "./backups/metadata-latest.json" | ConvertFrom-Json
$current = Export-ColorScriptMetadata -PassThru

$missing = $backup | Where-Object { $_.Name -notin $current.Name }
if ($missing.Count -gt 0) {
    Write-Warning "Missing from current: $($missing.Count) scripts"
}
```

## NOTES

**Performance Considerations:**
- Adding `-IncludeFileInfo` or `-IncludeCacheInfo` requires filesystem I/O operations and may impact performance when processing large colorscript libraries.
- For large exports, consider using `-PassThru` with pipeline filtering rather than loading all in memory
- Export operations scale linearly with script count

**Cache Directory Management:**
- Cache metadata collection ensures the cache directory exists before attempting to read cache files.
- When cache files are missing or unavailable, the `CacheExists` property is set to `false` and `CacheLastWriteTime` is set to null.

**Error Handling:**
- File metadata read errors are reported via verbose output (`-Verbose`) rather than terminating the cmdlet.
- Individual file errors result in null values for the affected properties while allowing the cmdlet to continue processing remaining colorscripts.

**JSON Output Format:**
- JSON files are written with indentation (depth 2) for human readability.
- The output encoding is UTF-8 for maximum compatibility.
- Existing files at the target path are overwritten without prompting.

**Best Practices:**
- Schedule regular metadata exports for auditing
- Version your metadata exports with timestamps
- Use `-PassThru` for both file export and pipeline processing
- Store backups in version control or backup systems
- Monitor export file size growth over time

**Use Cases:**
- Integrating with CI/CD pipelines for documentation generation
- Building web dashboards or API endpoints serving colorscript metadata
- Creating inventory reports for large colorscript collections
- Identifying scripts requiring cache regeneration
- Tracking changes and maintaining audit logs

## RELATED LINKS

- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
