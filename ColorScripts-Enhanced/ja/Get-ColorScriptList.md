---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

オプションのフィルタリングと豊富なメタデータ出力を備えた利用可能なカラースクリプトをリストします。

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

このコマンドにはエイリアスがありません。

## DESCRIPTION

`Get-ColorScriptList` コマンドレットは、ColorScripts-Enhanced モジュールにパッケージ化されたすべてのカラースクリプトを取得して表示します。さまざまなユースケースに合わせて、柔軟なフィルタリング オプションと複数の出力形式を提供します。

デフォルトでは、コマンドレットはスクリプト名とカテゴリを示す簡潔な形式の表を表示します。 `-Detailed` スイッチを使用すると、このビューが拡張されてタグと説明が含まれるようになり、より多くのコンテキストが一目でわかるようになります。

コマンドレットは常にメタデータ レコードを成功パイプラインに返します。 `-AsObject` を指定しないと、フォーマットされたホスト ビューも書き込まれます。 `-AsObject` は、クリーン オートメーションのためにホストのフォーマットを抑制します。レコードには、名前、パス、カテゴリ、カテゴリ、タグ、説明、および元のメタデータ プロパティが含まれます。

フィルタリング機能を使用すると、次の方法でリストを絞り込むことができます。

- **Name**: 柔軟なマッチングのためのワイルドカード パターン (例: `aurora-*`) をサポートします。
- **Category**: 1 つ以上のカテゴリ名でフィルタリングします (大文字と小文字は区別されません)。
- **Tag**: 「おすすめ」や「アニメーション」などのメタデータ タグでフィルタリングします (大文字と小文字は区別されません)

このコマンドレットはフィルター パターンを検証し、一致しない名前パターンに対して警告を生成するため、潜在的なタイプミスやスクリプトの欠落を特定するのに役立ちます。

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

利用可能なすべてのカラースクリプトをコンパクトな表形式で表示し、各スクリプトの名前とカテゴリを示します。

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed
```

包括的な概要を示すタグや説明を含む追加の列を含むすべてのカラースクリプトを表示します。

### EXAMPLE 3

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

タグや説明を含む完全なメタデータを含む「パターン」カテゴリのスクリプトのみを表示します。

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

名前がワイルドカード パターンに一致するすべてのスクリプトの構造化オブジェクトを返し、表示用に Name プロパティと Tags プロパティのみを選択します。

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

「推奨」としてタグ付けされたすべてのスクリプトを取得し、名前のアルファベット順に並べ替えます。プロファイル統合に適した厳選されたスクリプトを見つけるのに役立ちます。

### EXAMPLE 6

```powershell
Get-ColorScriptList -AsObject -Category Geometric,Abstract | Where-Object { $_.Tags -contains 'Colorful' }
```

カテゴリとタグのフィルタリングを組み合わせて、幾何学的カテゴリまたは抽象カテゴリの両方に属し、カラフルとしてタグ付けされているスクリプトを検索します。

### EXAMPLE 7

```powershell
Get-ColorScriptList -Name blocks,pipes,matrix -AsObject | ForEach-Object { Show-ColorScript -Name $_.Name }
```

特定の名前付きスクリプトを取得し、それぞれを順番に実行し、`Show-ColorScript` とのパイプライン統合を示します。

### EXAMPLE 8

```powershell
# インベントリ目的でカテゴリごとにスクリプトを数える
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending
```

各カテゴリに存在するカラースクリプトの数の概要を提供します。

### EXAMPLE 9

```powershell
# 説明に特定のキーワードが含まれるスクリプトを検索する
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

パターンマッチングを使用して、記述内容に基づいてスクリプトを検索します。

### EXAMPLE 10

```powershell
# 外部ツール処理用に CSV にエクスポート
Get-ColorScriptList -AsObject -Detailed |
    Select-Object Name, Category, Tags, Description |
    Export-Csv -Path "./colorscripts-inventory.csv" -NoTypeInformation
```

スプレッドシート アプリケーションで使用できるように、完全なカラースクリプト インベントリを CSV 形式にエクスポートします。

### EXAMPLE 11

```powershell
# 特定のカテゴリのないスクリプトをチェックする
$allScripts = Get-ColorScriptList -AsObject
$uncategorized = $allScripts | Where-Object { -not $_.Category }
Write-Host "未分類のスクリプト: $($uncategorized.Count)"
$uncategorized | Select-Object Name
```

カテゴリのメタデータが欠落しているスクリプトを特定します。

### EXAMPLE 12

```powershell
# フィルタリングされたスクリプトのキャッシュを構築する
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object {
        New-ColorScriptCache -Name $_.Name -PassThru
    } |
    Format-Table Name, Status
```

`Recommended` のタグが付いたスクリプトを評価します。キャッシュ ポリシーに適格なレンダラーのみが構築され、他のレコードは `SkippedNotRequired` を報告します。

### EXAMPLE 13

```powershell
# すべての幾何学的スクリプトの書式設定されたレポートを作成する
Get-ColorScriptList -Category Geometric -Detailed |
    Out-String |
    Tee-Object -FilePath "./geometric-report.txt"
```

幾何学的カテゴリのカラースクリプトの詳細レポートを生成し、ファイルに保存します。

### EXAMPLE 14

```powershell
# パターンに一致する最初のスクリプトを検索して簡単に表示します
$script = Get-ColorScriptList -Name "aurora-*" -AsObject | Select-Object -First 1
if ($script) {
    Show-ColorScript -Name $script.Name -PassThru
}
```

ワイルドカード パターンに基づいて、最初に一致したスクリプトをすばやく表示します。

### EXAMPLE 15

```powershell
# 自動化を実行する前に、参照されているスクリプトがすべて存在することを確認してください
$requiredScripts = @("bars", "arch", "mandelbrot-zoom")
$available = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$missing = $requiredScripts | Where-Object { $_ -notin $available }
if ($missing) {
    Write-Warning "不足しているスクリプト: $($missing -join ', ')"
} else {
    Write-Host "必要なスクリプトはすべて利用可能です"
}
```

自動化を実行する前に、必要なスクリプトがすべて存在することを検証します。

## PARAMETERS

### -AsObject

フォーマットされたテーブルをホストにレンダリングする代わりに、生のメタデータ レコード オブジェクトを返します。これにより、カラースクリプト メタデータのパイプライン処理とプログラムによる操作が可能になります。

このスイッチを指定すると、`Where-Object`、`Select-Object`、`Sort-Object`、`ForEach-Object` などの標準の PowerShell コマンドレットを使用して、結果をさらに処理できます。

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

### -Category

リストをフィルターして、1 つ以上の指定されたカテゴリに属する​​スクリプトのみを含めます。カテゴリの一致では大文字と小文字が区別されません。

一般的なカテゴリには、パターン、幾何学的、抽象、自然、アニメーション、テキスト、レトロなどが含まれます。複数のカテゴリを指定して検索範囲を広げることができます。

```yaml
Type: System.String[]
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

### -Detailed

書式設定されたテーブル ビューをレンダリングするときに追加の列 (タグと説明) が含まれます。これにより、各スクリプトに関するより包括的な情報が一目でわかります。

このスイッチを使用しないと、名前と主カテゴリのみがテーブル出力に表示されます。

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

### -h

操作を実行せずに、このコマンドの詳細なヘルプを表示します。

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

### -Name

カラースクリプトの一覧を 1 つ以上のスクリプト名でフィルターします。柔軟なパターン マッチングのためのワイルドカード文字 (`*` および `?`) をサポートします。

指定されたパターンがどのスクリプトにも一致しない場合は、潜在的な問題の特定に役立つ警告が生成されます。名前の一致では大文字と小文字が区別されません。

正確な名前を指定するか、`aurora-*` のようなパターンを使用して、複数の関連スクリプトと一致させることができます。

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
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

### -NoAnsiOutput

プレーンテキスト環境の情報メッセージおよびレンダリングされた出力の ANSI スタイルを無効にします。

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

### -Quiet

コマンド出力とエラーを保持しながら、情報メッセージを抑制します。

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

### -Tag

リストをフィルターして、1 つ以上の指定されたメタデータ タグを含むスクリプトのみを含めます。タグのマッチングでは大文字と小文字が区別されません。

一般的なタグには、推奨、アニメーション、カラフル、ミニマル、レトロ、複雑、シンプルなどが含まれます。タグは、視覚的なスタイル、複雑さ、またはユースケースごとにスクリプトを分類するのに役立ちます。

```yaml
Type: System.String[]
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

### System.Object

次のプロパティを持つカラースクリプトのメタデータ レコード オブジェクトを返します。

- **Name**: `Show-ColorScript` で使用されるスクリプト識別子
- **Path**: ソースの完全なパス
- **Category**: スクリプトの主なカテゴリ
- **Categories**: スクリプトが属するすべてのカテゴリの配列
- **Tags**: スクリプトを説明するメタデータ タグの配列
- **Description**: スクリプトの視覚的出力に関する人間が読める形式の説明
- **Metadata**: すべての生のスクリプト情報を含む元のメタデータ オブジェクト

`-AsObject` を指定しない場合、コマンドレットは、潜在的なパイプライン処理のためにレコード オブジェクトを返しながら、フォーマットされたテーブルをホストに書き込みます。

## NOTES

**著者**: ニック
**モジュール**: ColorScripts-Enhanced

返されたメタデータ レコードは、表示と自動化の両方の目的で包括的な情報を提供します。 `Name` プロパティを `Show-ColorScript` コマンドレットで直接使用して、特定のスクリプトを実行できます。

すべてのフィルタリング操作 (名前、カテゴリ、タグ) は大文字と小文字が区別されず、組み合わせて強力なクエリを作成できます。 `-Name` パラメーターでワイルドカードを使用すると、一致しないパターンがあると、トラブルシューティングに役立つ警告が生成されます。

カラースクリプトを PowerShell プロファイルに統合するときに最良の結果を得るには、`-Tag Recommended` フィルターを使用して、起動時の表示に適した厳選されたスクリプトを特定します。

### ベスト プラクティス

- 結果をプログラムでフィルタリングまたは操作する必要がある場合は、常に `-AsObject` を使用してください。
- インタラクティブに探索してタグと説明を確認する場合は、`-Detailed` を使用してください
- 複数のフィルターを組み合わせて正確なクエリを実現
- メタデータを定期的にエクスポートして、経時的な変化を追跡します
- テキスト出力を解析するのではなく、結果オブジェクトを自動化に使用します。
- クエリを繰り返し実行する場合のパフォーマンスを考慮する (可能であれば結果をキャッシュする)
- グループオブジェクトを分析とレポートに活用する
- 複雑なフィルタリング ロジックには Where-Object を使用します

## RELATED LINKS

- [オンライン バージョン](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)

