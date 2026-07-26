---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Clear-ColorScriptCache
---

# Clear-ColorScriptCache

## SYNOPSIS

キャッシュされたカラースクリプト出力ファイルを削除します。

## SYNTAX

### Selection (Default)

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

### Help

```
Clear-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-All] [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

## ALIASES

このコマンドにはエイリアスがありません。

## DESCRIPTION

`Clear-ColorScriptCache` コマンドレットは、ColorScripts-Enhanced モジュールによって生成されたキャッシュされた出力ファイルを削除します。各エントリは、レンダリングされた `<name>.cache` ペイロードと、有効なキャッシュ ディレクトリ内の `<name>.cacheinfo` 検証サイドカーで構成されます。

ワイルドカード パターンを指定した `-Name` パラメーターを使用してキャッシュ エントリを選択的に削除したり、 `-All` パラメーターを使用してすべてのエントリを一度に削除したりできます。 `-All` は、ペイロードが削除された孤立したサイドカーも削除します。このコマンドレットは、キャッシュされたスクリプトの特定のサブセットを対象とする、`-Category` および `-Tag` によるフィルター処理をサポートしています。

一致しないスクリプト名は、結果で `Missing` ステータスを報告します。ファイルシステムを変更せずに削除アクションをプレビューするには `-DryRun` を使用し、代替キャッシュ ディレクトリをターゲットにするには `-Path` を使用します (カスタム キャッシュ構成または CI/CD 環境に役立ちます)。

対象となるキャッシュ エントリは、対応するポリシーで選択されたレンダラーを表示するか、`New-ColorScriptCache` を呼び出すと再生成されます。静的に抽出できるバンドル スクリプトはキャッシュ対象ではなく、キャッシュ エントリを作成しません。

自動化シナリオの場合は、`-PassThru` を組み合わせて構造化された結果をキャプチャし、`-Quiet` を組み合わせて概要メッセージを抑制するか、`-NoAnsiOutput` を組み合わせて ANSI カラー コードのないプレーンテキストの概要を出力します。

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

確認を求めるプロンプトを表示せずに、デフォルトのキャッシュ ディレクトリ内のすべてのキャッシュ ファイルを削除します。これは、モジュールの更新後、または表示の問題のトラブルシューティングを行うときにキャッシュを完全にリフレッシュする場合に役立ちます。

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

実際に削除せずに、どのオーロラをテーマにしたキャッシュ ファイルが削除されるかをプレビューします。出力にはパターンに一致するキャッシュ ファイルが表示されるため、削除をコミットする前に選択内容を確認できます。

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name Galaxy -Path $env:TEMP -Confirm:$false
```

TEMP 下のカスタム ディレクトリから対象となる「Galaxy」レンダラーのキャッシュ ファイルをクリアします。これは、`COLOR_SCRIPTS_ENHANCED_CACHE_PATH` または別の分離されたキャッシュの場所をテストするときに役立ちます。

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Category Mathematical -WhatIf
```

`Mathematical` カテゴリのスクリプトのキャッシュ ファイルが削除された場合に何が起こるかを示します。 `-WhatIf` パラメータは削除を防止します。

### EXAMPLE 5

```powershell
Get-ColorScriptList -Tag retro | Clear-ColorScriptCache -DryRun
```

パイプライン入力を使用して、「レトロ」としてタグ付けされたすべてのスクリプトのキャッシュ ファイルの削除をプレビューします。削除をコミットする前に、タグによるフィルタリングとドライラン プレビューを組み合わせます。

### EXAMPLE 6

```powershell
Clear-ColorScriptCache -Name 'test-*', 'demo-*' -Confirm:$false
```

名前が「test-」または「demo-」で始まるすべてのスクリプトのキャッシュ ファイルを確認なしで削除します。複数のワイルドカード パターンを配列として指定できます。

### EXAMPLE 7

```powershell
# 既存のキャッシュ ファイルを消去し、ポリシーで選択されたエントリを再構築する
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -PassThru | Measure-Object
Write-Host "キャッシュが正常に再構築されました"
```

すべてのキャッシュ ペイロードを消去し、動的キャッシュ ポリシーで選択されたエントリだけを再構築して、その再構築結果の統計を表示します。

### EXAMPLE 8

```powershell
# 30 日以上前の古いキャッシュ エントリをクリアする
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$thirtyDaysAgo = (Get-Date).AddDays(-30)
Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $thirtyDaysAgo } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
Write-Host "古いキャッシュファイルが消去されました"
```

30 日以上更新されていないキャッシュ ファイルを削除します。

### EXAMPLE 9

```powershell
# キャッシュ管理レポート
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$beforeCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Clear-ColorScriptCache -Category Geometric -Confirm:$false
$afterCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Write-Host "$($beforeCount - $afterCount) ジオメトリック キャッシュ ファイルをクリアしました"
```

キャッシュクリア操作に関する統計を表示します。

### EXAMPLE 10

```powershell
# トラブルシューティング - 特定のスクリプトをクリアして再構築する
$scriptName = "Galaxy"
Clear-ColorScriptCache -Name $scriptName -Confirm:$false
New-ColorScriptCache -Name $scriptName -Force
Show-ColorScript -Name $scriptName
```

ポリシー対象のレンダラー 1 つについてキャッシュをクリアして再構築し、確認のために表示します。

### EXAMPLE 11

```powershell
# 複数のカテゴリでフィルタリングする
Clear-ColorScriptCache -Category Geometric,Abstract -DryRun -PassThru |
    Select-Object CacheFile |
    Measure-Object
```

複数のカテゴリでフィルタリングした場合に削除されるキャッシュ ファイルの数を示します。

## PARAMETERS

### -All

ターゲット ディレクトリ内のすべてのキャッシュ エントリを選択します。 `-Category` および `-Tag` は、全選択パラメータ セットをさらに制限できます。 `-Name` は、代わりに選択パラメータ セットに属します。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

キャッシュ エントリを評価する前に、ターゲット スクリプトをカテゴリでフィルタリングします。指定されたカテゴリに一致するスクリプトのキャッシュ ファイルのみが削除の対象となります。カテゴリ名の配列を受け入れ、`-Tag` と組み合わせてより正確なフィルタリングを行うことができます。

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

コマンドレットを実行する前に確認を求めるメッセージが表示されます。デフォルトでは、これはキャッシュ ファイルの誤った削除を防ぐために有効になっています。確認プロンプトをバイパスするには、`-Confirm:$false` を使用します。

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

### -DryRun

ファイルを削除せずに削除アクションをプレビューします。このコマンドレットは、削除されるキャッシュ ファイルを表示しますが、ファイル システムは変更されません。これは、削除を実行する前に選択基準を確認するのに役立ちます。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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
- Name: Help
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

削除するキャッシュ ファイルを識別する名前またはワイルドカード パターン。 `Name` プロパティを持つオブジェクトからのパイプライン入力とプロパティ バインディングを受け入れます。パターン マッチングでは、ワイルドカード文字 (`*`、`?`) がサポートされています。 `-All` とは相互に排他的です。

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAnsiOutput

概要出力で ANSI カラー シーケンスを無効にします。これは、ANSI スタイルを解釈しないコンソールやログ プロセッサに役立ち、概要テキストがプレーン テキストでも読みやすい状態を維持します。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- NoColor
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

処理された各キャッシュ エントリの詳細な結果オブジェクトを返します。このスイッチを使用しない場合、コマンドレットは概要メッセージのみを書き込みます。各パススルー レコードには、スクリプト名、キャッシュ ファイル パス、ステータス、および詳細な検査やレポートに使用できる関連エラー テキストが含まれています。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

操作対象の代替キャッシュ ディレクトリ。指定しない場合、デフォルトはモジュールの標準キャッシュ パスになります。このパラメータは、`COLOR_SCRIPTS_ENHANCED_CACHE_PATH` 環境変数を介して設定されたカスタム キャッシュの場所を操作する場合、またはテストまたは CI/CD の目的で代替ディレクトリでキャッシュ ファイルを管理する場合に使用します。

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

キャッシュの削除が完了した後に出力される概要メッセージを抑制します。このスイッチは、構造化された出力 (`-PassThru` レコード、警告、エラーなど) のみを生成する必要がある静かなオートメーション コンテキストで実行する場合に使用します。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

キャッシュ エントリを評価する前に、メタデータ タグでターゲット スクリプトをフィルタリングします。一致するタグを持つスクリプトのキャッシュ ファイルのみが削除の対象となります。タグ名の配列を受け入れ、`-Category` と組み合わせて、対象となるキャッシュ ファイルをより詳細に制御できます。

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

実際に操作を実行せずにコマンドレットを実行した場合に何が起こるかを示します。このコマンドレットは実行されるアクションを表示しますが、ファイル システムは変更されません。これは標準の PowerShell 共通パラメータであり、`-DryRun` と同様に機能しますが、PowerShell の組み込み規則に従います。

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
詳細については、次を参照してください:
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### System.String

スクリプト名をパイプしてこのコマンドレットに渡すことができます。指定されたパラメーターに基づいて、キャッシュ ファイルの削除について各名前が評価されます。

### System.String[]

スクリプト名の配列をこのコマンドレットにパイプすることができます。これは、`Get-ColorScriptList` と組み合わせて、キャッシュをクリアする前にさまざまな基準でスクリプトをフィルタリングする場合に特に便利です。

### System.Management.Automation.PSObject

`Name` プロパティを持つオブジェクトをこのコマンドレットにパイプすることができます。このコマンドレットは `Name` プロパティ値を抽出し、それを使用して削除するキャッシュ ファイルを識別します。

## OUTPUTS

### System.Object

`-PassThru` を指定すると、処理された各キャッシュ ファイルのステータス レコードを返します。各出力オブジェクトには次のプロパティが含まれます。

- **Status**: 操作の結果 (`Removed`、`Missing`、`DryRun`、`SkippedByUser`、または `Error`)
- **CacheFile**: 処理されたキャッシュ ファイルへのフル パス
- **Message**: 操作の結果を説明する説明文
- **Name**: キャッシュ ファイルに関連付けられたスクリプトの名前

## NOTES

**著者**: ニック
**モジュール**: ColorScripts-Enhanced

キャッシュ ファイルは、拡張子 `.cache` を付けてモジュールのキャッシュ ディレクトリに保存されます。各キャッシュ ファイルは 1 つのカラースクリプトに対応し、事前にレンダリングされた ANSI 出力が含まれています。

対象となるキャッシュ エントリは、対応するポリシーで選択されたレンダラーを表示するか、`New-ColorScriptCache` を呼び出すと再生成されます。静的に抽出できるバンドル スクリプトはキャッシュ対象ではなく、キャッシュ エントリを作成しません。

デフォルトの実効パスについては、`(Get-ColorScriptConfiguration).Cache.EffectivePath` をクエリします。これは、永続化された構成または `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` でオーバーライドできます。 `-Path` は、1 回の呼び出しで異なるディレクトリをターゲットにします。

`-DryRun` または `-WhatIf` を使用する場合、コマンドレットはキャッシュ ディレクトリが存在することを検証し、問題があれば報告しますが、削除は実行しません。

`-Category` または `-Tag` でフィルタリングするには、スクリプトにメタデータが関連付けられている必要があります。メタデータのないスクリプトは、これらのフィルターに一致しません。

### ベスト プラクティス

- 破壊的な操作の前には必ず `-DryRun` または `-WhatIf` を使用してください。
- 操作が確実である場合にのみ `-Confirm:$false` を使用してください
- リカバリのための大規模なクリーンアップ操作の前にキャッシュをアーカイブする
- ディスク容量を定期的に監視してキャッシュの増加を確認する
- 可能な場合は、完全なクリーニングではなく、選択的なクリーニングを使用します。
- クリアすべきではない重要なスクリプトを追跡します
- メンテナンス期間中に自動クリーンアップをスケジュールする
- 最初に非運用環境でクリーンアップ操作をテストします

### トラブルシューティング (2)

- **「キャッシュ ファイルが見つかりません」**: `(Get-ColorScriptConfiguration).Cache.EffectivePath` を検査し、`Export-ColorScriptMetadata -IncludeCacheInfo` を使用してキャッシュの状態を確認します
- **「権限が拒否されました」**: キャッシュ ディレクトリへの書き込みアクセスを確認します
- **「キャッシュが再生成されていません」**: スクリプトにはレンダリングの問題がある可能性があります。 `-NoCache` でテストする

## RELATED LINKS

- [オンライン バージョン](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache)

