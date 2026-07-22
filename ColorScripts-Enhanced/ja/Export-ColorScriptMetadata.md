---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Export-ColorScriptMetadata
---

# Export-ColorScriptMetadata

## SYNOPSIS

すべてのカラースクリプトの包括的なメタデータを JSON 形式でエクスポートするか、構造化オブジェクトをパイプラインに出力します。

## SYNTAX

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-h] [-IncludeFileInfo] [-IncludeCacheInfo]
 [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

このコマンドにはエイリアスがありません。

## DESCRIPTION

`Export-ColorScriptMetadata` コマンドレットは、モジュールのカタログ内のすべてのカラースクリプトの包括的なインベントリをコンパイルし、各エントリを説明する構造化データセットを生成します。このメタデータには、スクリプト名、カテゴリ、タグ、オプションのエンリッチメントなどの重要な情報が含まれています。

デフォルトでは、コマンドレットは PowerShell オブジェクトをパイプラインに返します。 `-Path` パラメーターを指定すると、メタデータがフォーマットされた JSON として指定されたファイルに書き込まれ、親ディレクトリが存在しない場合は自動的に作成されます。

このコマンドレットには、次の 2 つのオプションのエンリッチメント フラグが用意されています。

- **IncludeFileInfo**: フル パス、ファイル サイズ (バイト単位)、最終変更タイムスタンプなどのファイル システム メタデータを追加します。
- **IncludeCacheInfo**: キャッシュ ファイル パス、存在ステータス、キャッシュ タイムスタンプなどのキャッシュ関連情報を追加します。

このコマンドレットは、以下の場合に特に役立ちます。

- 利用可能なすべてのカラースクリプトを示すドキュメントまたはダッシュボードを作成する
- 未処理のキャッシュ ペイロード ファイルの存在とタイムスタンプのレポート
- メタデータを外部ツールまたは自動化パイプラインにフィードする
- カラースクリプトのインベントリとファイル システムのステータスを監査する
- カラースクリプトの使用法と構成に関するレポートの生成

出力の順序は一貫しているため、JSON にエクスポートするときのバージョン管理や diff 操作に適しています。

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

すべてのカラースクリプトの基本メタデータを、ファイルまたはキャッシュ情報なしでパイプラインにエクスポートします。

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

各カラースクリプトのファイル システムの詳細 (フル パス、サイズ、最終書き込み時刻) を含むオブジェクトを返します。

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

基本的なメタデータを含む JSON ファイルを生成し、それを `dist` ディレクトリに書き込み、フォルダーが存在しない場合は作成します。

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

ファイル システムとキャッシュ情報の両方を含む強化されたメタデータを含む包括的な JSON ファイルを生成し、`dist` ディレクトリに書き込みます。

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeCacheInfo -PassThru | Where-Object { -not $_.CacheExists }
```

メタデータ ファイルを書き込み、生の `.cache` ペイロードが存在しないレコードを返します。これはファイルの占有のみを報告し、キャッシュの適格性、有効性、または最新性は報告しません。

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

カラースクリプトをカテゴリ別にグループ化し、数を表示します。これは、カテゴリ間のスクリプトの分布を分析するのに役立ちます。

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property ScriptSizeBytes -Sum).Sum
Write-Host "すべてのカラースクリプトの合計サイズ: $($totalSize / 1KB) KB"
```

すべてのカラースクリプト ファイルによって使用される合計ディスク容量を計算します。

### EXAMPLE 8

```powershell
# 統計を生成してレポートを保存する
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachePayloadFiles = ($metadata | Where-Object CacheExists).Count
    TotalScriptSizeBytes = ($metadata | Measure-Object ScriptSizeBytes -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

インベントリ統計を生成し、生の `.cache` ペイロード ファイルをカウントします。ペイロードの存在は、キャッシュの適格性、有効性、最新性のチェックではありません。

### EXAMPLE 9

```powershell
# エクスポートして以前のバックアップと比較する
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "新しいスクリプト: $($new.Count) | 削除されたスクリプト: $($removed.Count)"
```

現在のメタデータを以前のバージョンと比較して、変更を特定します。

### EXAMPLE 10

```powershell
# Web ダッシュボードの API レスポンスを構築する
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

バージョン管理とタイムスタンプ情報を含む API 対応の JSON を生成します。

### EXAMPLE 11

```powershell
# ポリシーで選択されたすべてのキャッシュ エントリを構築または検証し、ステータスを確認します。
$results = New-ColorScriptCache -All -PassThru
$results | Group-Object Status | Select-Object Name, Count
```

キャッシュ ポリシーを信頼できる情報源として使用し、対象となるエントリが更新されたか、すでに最新であるか、スキップされたか、失敗したかを報告します。

### EXAMPLE 12

```powershell
# メタデータから HTML ギャラリーを作成する
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

利用可能なすべてのカラースクリプトをリストする HTML ギャラリー ページを作成します。

### EXAMPLE 13

```powershell
# スクリプトのサイズを経時的に監視する
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object ScriptSizeBytes -Average).Average) bytes avg" }
```

複数のエクスポートにわたる個々のスクリプトのファイル サイズの変更を追跡します。

## PARAMETERS

### -Confirm

コマンドレットを実行する前に確認を求めるメッセージが表示されます。

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

操作を実行せずに、このコマンドの詳細なヘルプを表示します。

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

生の `.cache` ペイロード パス、ファイル存在フラグ、および最終書き込みタイムスタンプを各レコードに追加します。これらのフィールドは、キャッシュ ポリシーの適格性、`.cacheinfo` サイドカーの存在、有効性、または最新性を報告しません。

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

各レコードにファイル システムの詳細 (フル パス、バイト単位のサイズ、最終書き込み時刻) が含まれます。ファイルのメタデータを読み取れない場合 (権限またはファイルの欠落により)、詳細出力を介してエラーが記録され、影響を受けるプロパティは null 値に設定されます。このスイッチは、ファイル サイズと変更日を監査する場合に役立ちます。

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

`-Path` パラメーターが指定されている場合でも、メタデータ オブジェクトをパイプラインに返します。これにより、メタデータをファイルに保存することと、オブジェクトに対して追加の処理やフィルタリングを 1 つのコマンドで実行することができます。このスイッチを使用しない場合、`-Path` を指定するとパイプライン出力が抑制されます。

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

JSON エクスポートの宛先ファイル パスを指定します。相対パス、絶対パス、環境変数 (例: `$env:TEMP\metadata.json`)、およびチルダ展開 (例: `~/Documents/metadata.json`) をサポートします。親ディレクトリが存在しない場合は、自動的に作成されます。このパラメーターを省略すると、コマンドレットはオブジェクトをファイルに書き込む代わりにパイプラインに直接出力します。 JSON 出力は、読みやすくするためにインデントを使用してフォーマットされています。

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

アクションを実行せずに、何が起こるかを報告するだけのモードでコマンドを実行します。

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

このコマンドレットは、次の共通パラメーターをサポートします:
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
詳細については、次を参照してください:
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

このコマンドレットはパイプライン入力を受け入れません。

## OUTPUTS

### System.Management.Automation.PSCustomObject

`-Path` が指定されていない場合、または `-PassThru` が使用されている場合、コマンドレットはカスタム オブジェクトを返します。各オブジェクトは、次の基本プロパティを持つ単一のカラースクリプトを表します。

- **Name**: 拡張子を除いたカラースクリプトのファイル名
- **Category**: 主要な組織カテゴリ
- **Categories**: 割り当てられたすべてのカテゴリ
- **Tags**: フィルタリングと検索のための説明的なタグの配列
- **Description**: メタデータの説明

`-IncludeFileInfo` を指定すると、次の追加プロパティが含まれます。

- **ScriptPath**: スクリプト ファイルへの完全なファイルシステム パス
- **ScriptSizeBytes**: バイト単位のサイズ (ファイルにアクセスできない場合は null)
- **ScriptLastWriteTimeUtc**: 最終変更の UTC タイムスタンプ (使用できない場合は null)

`-IncludeCacheInfo` を指定すると、次の追加プロパティが含まれます。

- **CachePath**: 対応するキャッシュ ファイルへのフル パス
- **CacheExists**: 生の .cache ペイロード ファイルが存在するかどうかを示すブール値。ポリシー上の適格性、有効性、最新性を示す値ではありません
- **CacheLastWriteTimeUtc**: キャッシュ ファイル変更の UTC タイムスタンプ (キャッシュが存在しない場合は null)

## NOTES

## RELATED LINKS

- [オンライン バージョン](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)

