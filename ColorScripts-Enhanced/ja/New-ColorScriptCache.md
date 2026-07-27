---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

CachePolicy.psd1 で選択された高コストなレンダラーのキャッシュだけを事前構築または更新します。

## SYNTAX

### Selection (Default)

```
New-ColorScriptCache [-Name <string[]>] [-Force] [-PassThru] [-Category <string[]>]
 [-Tag <string[]>] [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon]
 [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Category <string[]>] [-Tag <string[]>]
 [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon] [-WhatIf] [-Confirm]
```

## ALIASES

- `Build-ColorScriptCache`
- `Update-ColorScriptCache`

## DESCRIPTION

`New-ColorScriptCache` は、ポリシーで選択された計算カラースクリプトをレンダリングし、その出力を BOM なしの UTF-8 として保存します。適格なバンドル レンダラーは、モジュールの分離された実行パスを使用します。並列ワーカーは PowerShell 7 以降で利用できます。静的に抽出できるバンドル スクリプトはキャッシュ対象ではなく、キャッシュ ファイルを作成しません。エイリアスは `Update-ColorScriptCache` および `Build-ColorScriptCache` です。

名前 (ワイルドカードをサポート)、カテゴリ、またはタグによってスクリプトを対象にできます。パラメーターを指定しない場合、コマンドレットはコレクション全体を列挙せず、`CachePolicy.psd1` 内の名前を直接解決します。完全一致するバンドル名もファイルを直接検索します。ワイルドカード、カテゴリ、およびタグの要求は、その照合セマンティクスで必要な場合にだけ列挙します。明示的に指定したポリシー外のスクリプトは `SkippedNotRequired` ステータスになり、`-PassThru` を使用すると結果として返されます。また、そのスクリプトの古いキャッシュ ファイルは削除されます。

デフォルトでは、コマンドレットは進行状況に加えて、キャッシュ操作と有効なキャッシュ ディレクトリの簡潔な概要を表示します。 `-PassThru` を使用すると、各スクリプトの詳細な結果オブジェクトが返されます。ステータス、標準出力、エラー ストリームをプログラムで検査できます。 `-Quiet` を組み合わせて進行状況と概要を完全に抑制するか、`-NoAnsiOutput` を組み合わせて、ANSI カラー コードをサポートしていない環境向けに ANSI カラー コードなしのプレーンテキストの概要を出力します。

このコマンドレットは、`-Force` パラメーターを指定しない限り、キャッシュ ファイルが最新のスクリプトをスキップします。ビルドを繰り返すと、小さな `<name>.cacheinfo` サイドカーを検証し、レンダリング済みの `<name>.cache` ペイロードはロードしません。`-Force` は適格なキャッシュ エントリを再構築しますが、キャッシュ ポリシーをオーバーライドしません。

どちらのファイルも `(Get-ColorScriptConfiguration).Cache.EffectivePath` にあります。 `.cache` ファイルには、レンダリングされた端末出力が含まれています。 `.cacheinfo` には検証メタデータのみが含まれます。ペイロードのないサイドカーは使用可能なキャッシュ エントリではないため、次のビルドで修復されます。 `Clear-ColorScriptCache -All` は、完全なエントリと孤立したサイドカーを削除します。

マルチコア システムでの再構築を高速化するには、`-Parallel` スイッチを `-ThrottleLimit` (または `-Threads`) パラメーターとともに使用して、ワーカー数を制御します。現在のホストで並列実行空間を作成できない場合、コマンドレットは自動的に順次実行に戻ります。

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

モジュールに同梱されているすべてのスクリプトを列挙することなく、ポリシーで選択された計算レンダラーのみを解決してウォームします。これは、パラメータが指定されていない場合のデフォルトの動作です。

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name Galaxy, 'rose-*'
```

完全一致とワイルドカード一致を組み合わせてキャッシュします。 `CachePolicy.psd1` に含まれる一致のみが構築されます。他の一致では、`SkippedNotRequired` と `-PassThru` が報告されます。

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name Galaxy -Force -PassThru | Format-List
```

対象となる「Galaxy」キャッシュが最新であっても再構築を強制し、詳細な結果オブジェクトを調べます。

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Mathematical' -PassThru
```

`Mathematical` カテゴリのスクリプトを評価し、対象となるレンダラーをキャッシュし、一致するすべての詳細な結果を返します。

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

「幾何学的」または「カラフル」のいずれかのタグが付けられたスクリプトの対象となるキャッシュを再構築し、キャッシュが最新であっても再生成を強制します。

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Mathematical -AsObject | New-ColorScriptCache -PassThru
```

パイプラインの例: `Mathematical` カテゴリのスクリプトを評価し、ポリシーで選択されたレンダラーをキャッシュし、一致するすべての結果を返します。

### EXAMPLE 7

```powershell
# ビルド後にキャッシュ統計を確認する
$cachePath = (Get-ColorScriptConfiguration).Cache.EffectivePath
$before = @(Get-ChildItem $cachePath -Filter "*.cache" -ErrorAction SilentlyContinue).Count
New-ColorScriptCache
$after = @(Get-ChildItem $cachePath -Filter "*.cache").Count
Write-Host "キャッシュされたスクリプト: $before -> $after"
```

操作の前後でポリシーで選択されたキャッシュ ファイルをカウントすることで、キャッシュの増加を測定します。

### EXAMPLE 8

```powershell
# 頻繁に使用される計算レンダラーのキャッシュを構築する
$frequentScripts = @('Galaxy', 'rose-curves', 'wave-interference')
New-ColorScriptCache -Name $frequentScripts -PassThru | Format-Table Name, Status, ExitCode
```

`CachePolicy.psd1` に該当するリストされたスクリプトのキャッシュを構築します。リストされていない名前はスキップされます。

### EXAMPLE 9

```powershell
# 組み込みのポリシースコープの進行状況表示を使用する
New-ColorScriptCache -All
```

利用可能なすべてのスクリプトを手動で反復することなく、ポリシーで選択されたレンダラーの組み込みの進行状況を表示します。

### EXAMPLE 10

```powershell
# 必要に応じて、PowerShell プロファイルから欠落しているポリシー エントリまたは古いポリシー エントリをプライムします。
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Quiet
```

プロファイルのロード時にポリシーで選択されたエントリをチェックし、欠落しているエントリまたは古いエントリのみを構築します。起動時のキャッシュ作業が不要な場合は、このプロファイル手順を省略してください。

### EXAMPLE 11

```powershell
# ポリシーで選択されたすべてのエントリを展開用に再構築します
New-ColorScriptCache -All -Force -PassThru |
    Select-Object Name, Status |
    Export-Csv "./cache-deployment.csv"
```

ポリシーで選択されたすべてのキャッシュ エントリを再構築し、ステータスを展開マニフェストにエクスポートします。

### EXAMPLE 12

```powershell
# キャッシュ構築の失敗を見つける
New-ColorScriptCache -Name "Galaxy" -Force -PassThru |
    Where-Object Status -eq 'Failed' |
    Select-Object Name, StdErr
```

ポリシーのスキップをエラーとして処理せずに、キャッシュの失敗を特定します。

### EXAMPLE 13

```powershell
# この実行によって更新されたポリシーで選択されたエントリの数
New-ColorScriptCache -All -PassThru |
    Where-Object Status -eq 'Updated' |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

ポリシーで選択されたすべてのエントリをチェックし、この実行によって更新されたキャッシュ ペイロードの数を表示します。

### EXAMPLE 14

```powershell
New-ColorScriptCache -All -Parallel -Threads 8
```

8 つのワーカー スレッドを使用して、ポリシーで選択されたすべてのキャッシュを構築します。現在のホストで並列ジョブが使用できない場合、コマンドレットは自動的に順次実行に戻ります。

## PARAMETERS

### -All

すべてのキャッシュ ポリシー エントリを直接解決します。ポリシーで選択されたスクリプトのみが処理されます。完全なカラースクリプトのインベントリは列挙されません。

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

評価されたスクリプトをメタデータ カテゴリでフィルタリングします (大文字と小文字は区別されません)。複数の値は OR フィルターとして扱われます。 `CachePolicy.psd1` によって許可された一致のみがキャッシュされます。他の一致では、`SkippedNotRequired` と `-PassThru` が報告されます。

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

コマンドレットを実行する前に確認を求めるメッセージが表示されます。多数のスクリプトをキャッシュする場合、または誤ってキャッシュが再生成されるのを防ぐために `-Force` を使用する場合に便利です。

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

### -Force

`.cacheinfo` 検証メタデータが最新であると示している場合でも、適格なキャッシュ エントリを再構築します。これは `CachePolicy.psd1` をオーバーライドしません。

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

### -IncludePokemon

非推奨の互換性スイッチ。ポケモン スクリプトは他のすべてのスクリプトと同じ `CachePolicy.psd1` の規則に従うため、1 リリースの間、何も行わないサイレント スイッチとして受け付けられます。

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

### -Name

キャッシュ用に評価する 1 つ以上のカラースクリプト名。ワイルドカード パターン (`aurora-*` や `*-wave` など) をサポートします。一致するスクリプトは、`CachePolicy.psd1` にリストされている場合にのみキャッシュされます。このパラメータとすべてのフィルタを省略すると、ポリシー エントリのみが解決および評価されます。

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
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

情報出力で ANSI カラー シーケンスを無効にします。これは、必要に応じてカラー出力を保持しながら、ANSI エスケープ コードをレンダリングしない環境 (一部の CI/CD ログなど) で役立ちます。

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

### -Parallel

マルチスレッドのキャッシュ構築を有効にします。指定すると、コマンドレットは実行空間プール全体でキャッシュ ジョブを実行し、対応するシステムでの完了を高速化します。 `-ThrottleLimit` (または `-Threads` エイリアス) と組み合わせて使用​​して、同時ワーカーの数を制御します。マルチスレッドを初期化できない場合、コマンドレットは自動的に順次実行に戻ります。

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

### -PassThru

各キャッシュ操作の詳細な結果オブジェクトを返します。デフォルトでは、概要のみが表示されます。結果オブジェクトには、Name、Status、CacheFile、ExitCode、StdOut、StdErr などのプロパティが含まれており、プログラムによるキャッシュ プロセスの検査が可能です。

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

### -Quiet

スクリプトごとの進行状況と情報概要の出力を抑制します。このスイッチは、構造化された出力 (`-PassThru` 経由) のみが必要な場合、または自動化シナリオで警告やエラーが表示される一方で情報メッセージを沈黙させる必要がある場合に使用します。

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

評価されたスクリプトをメタデータ タグでフィルタリングします (大文字と小文字は区別されません)。複数の値は OR フィルターとして扱われます。 `CachePolicy.psd1` によって許可された一致のみがキャッシュされます。他の一致では、`SkippedNotRequired` と `-PassThru` が報告されます。

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

### -ThrottleLimit

`-Parallel` が要求された場合の同時キャッシュ ワーカーの最大数を指定します。 1 ～ 256 の値を受け入れます。デフォルト (省略した場合) は、現在のマシン上の論理プロセッサの数です。エイリアス `-Threads` は便宜上提供されています。 1 以下の値を指定すると、自動的に順次実行に戻ります。

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Threads
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

実際にキャッシュ操作を実行せずにコマンドレットを実行した場合に何が起こるかを示します。操作をコミットする前に、どのスクリプトがキャッシュされるかをプレビューするのに役立ちます。

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

スクリプト名をパイプしてこのコマンドレットに渡すことができます。各文字列は潜在的なスクリプト名として扱われ、ワイルドカードの一致をサポートします。

### System.String[]

スクリプト名またはメタデータ レコードの配列を `Name` プロパティとともにこのコマンドレットにパイプして、バッチ処理を行うことができます。

## OUTPUTS

### System.Object

`-PassThru` が指定されている場合、次のプロパティを含む、処理された各スクリプトのカスタム オブジェクトを返します。

- **Name**: カラースクリプトの名前
- **ScriptPath**: ソース カラースクリプトへのフルパス
- **CacheFile**: 生成されたキャッシュ ファイルへのフル パス
- **Status**: `Updated`、`SkippedUpToDate`、`SkippedNotRequired`、`SkippedByUser`、または `Failed`
- **Message**: ローカライズされたステータスの詳細
- **CacheExists**: 操作後に生の .cache ペイロードが存在するかどうか。ポリシー上の適格性、有効性、最新性を示す値ではありません
- **ExitCode**: スクリプト実行の終了コード (0 は成功を示します)
- **StdOut**: スクリプトの実行中にキャプチャされた標準出力
- **StdErr**: スクリプトの実行中に取得された標準エラー出力

`-PassThru` を指定しないと、処理済み、更新済み、スキップ済み、および失敗した件数と有効なキャッシュ ディレクトリを含む簡潔な情報概要が書き込まれます。

## NOTES

**著者:** ニック
**モジュール:** ColorScripts-Enhanced

**エイリアス:** `Update-ColorScriptCache` および `Build-ColorScriptCache`。

キャッシュ ファイルは `(Get-ColorScriptConfiguration).Cache.EffectivePath` の下に保存されます。コンパニオン メタデータのソース署名とポリシー署名は、エントリが最新のままであるかどうかを判断するために使用されます。

このコマンドレットは、実行が必要で、キャッシュ ポリシーによって許可されているレンダラーのみをキャッシュします。明示的な静的スクリプトまたはリストにないスクリプトは `SkippedNotRequired` として報告され、古いエントリは削除されます。

## RELATED LINKS

- [オンライン バージョン](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)

