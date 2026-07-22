---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

高価なレンダラ用に選択的なキャッシュを使用してカラースクリプトを表示します。

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Help

```
Show-ColorScript [-h] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Named

```
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### List

```
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### All

```
Show-ColorScript [-All] [-WaitForInput] [-NoClear] [-NoCache] [-Category <string[]>]
 [-Tag <string[]>] [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

## ALIASES

- `scs`

## DESCRIPTION

端末で ANSI カラースクリプトをレンダリングし、高コストなレンダラーにだけ選択的なパフォーマンス最適化を適用します。このコマンドレットには、次の 4 つの主要な操作モードがあります。

**ランダム モード (デフォルト):** 利用可能なコレクションからランダムに選択されたカラースクリプトを表示します。これは、パラメータが指定されていない場合のデフォルトの動作です。

**名前付きモード:** 特定のカラースクリプトを名前で表示します。柔軟なマッチングのためのワイルドカード パターンをサポートします。複数のスクリプトがパターンに一致する場合、アルファベット順で最初に一致したものが選択されます。

**リスト モード:** カラースクリプト名と主要カテゴリを含むコンパクトなテーブルを表示します。完全なメタデータ レコードには `Get-ColorScriptList -AsObject` を使用します。

**すべてモード:** 使用可能なすべてのカラースクリプトをアルファベット順に循環します。コレクション全体を紹介したり、新しいスクリプトを発見したりする場合に特に役立ちます。

静的に抽出できるバンドル スクリプトは、限定的でフェイルクローズな AST 評価によって、スクリプトを実行せずに出力を取得します。明示的に許可されたバンドル済みの動的スクリプトは、分離されたインプロセス実行空間で実行します。不明なスクリプトまたはカスタム スクリプトは、セッション状態の漏えいを防ぐために子プロセスで実行します。実行空間も子プロセスもセキュリティ サンドボックスではなく、スクリプトは現在のユーザーの権限で実行されます。

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

ランダムなカラースクリプトを表示します。静的に抽出できるバンドル スクリプトは実行せずに出力を取得し、適格な計算レンダラーは検証済みのキャッシュ出力を再利用できます。

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

指定されたカラースクリプトを正確な名前で表示します。 .ps1 拡張子は必要ありません。

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

ワイルドカード パターン「aurora-\*」に一致する最初のカラースクリプトを (アルファベット順に) 表示します。スクリプト名の一部を覚えている場合に役立ちます。

### EXAMPLE 4

```powershell
scs hearts
```

ハートのカラースクリプトに素早くアクセスするには、モジュールのエイリアス「scs」を使用します。エイリアスは、頻繁に使用するための便利なショートカットを提供します。

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

使用可能なカラースクリプトを名前と主カテゴリ別にリストします。素早い発見に役立ちます。

### EXAMPLE 6

```powershell
Show-ColorScript -Name Galaxy -NoCache
```

キャッシュされた出力を読み取らずに対象となる Galaxy レンダラーを表示し、新しい分離されたレンダリングを強制します。レンダラーの変更をテストしたり、キャッシュの破損を調査したりするときに役立ちます。

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

自然をテーマにしたランダムなスクリプトを表示し、さらに検査または処理するためにそのメタデータ オブジェクトをキャプチャします。

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

カラースクリプトをレンダリングし、出力をテキスト ファイルに保存します。レンダリングされた ANSI コードは保存されるため、後でファイルを適切な色で表示できます。

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

すべてのカラースクリプトをアルファベット順に表示し、それぞれの間に短い自動遅延を設けます。コレクション全体を視覚的に紹介するのに最適です。

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

すべてのカラースクリプトを一度に 1 つずつ表示し、それぞれの後に一時停止します。スペースバーを押して次のスクリプトに進むか、「q」を押してシーケンスを早期に終了します。

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

手動で進行しながら、自然をテーマにしたすべてのカラースクリプトを循環します。フィルタリングとインタラクティブなブラウジングを組み合わせて、厳選されたエクスペリエンスを実現します。

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

「レトロ」または「幾何学」タグのいずれかを持つランダムなカラースクリプトを表示します。複数のタグ値は、任意一致セマンティクスを使用します。

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Artistic,Abstract
```

「アート」または「抽象」に分類されたカラースクリプトのみをリストし、特定のテーマ内のスクリプトを見つけるのに役立ちます。

### EXAMPLE 14

```powershell
# ポリシーで選択されたレンダラーのキャッシュ適格性とビルド ステータスを検査します。
New-ColorScriptCache -Name Galaxy -Force -PassThru |
    Select-Object Name, Status, CacheFile
Show-ColorScript -Name Galaxy
```

マシンに依存しないパフォーマンス乗数を要求せずに、対象となるレンダラーのキャッシュ エントリを構築して検査します。

### EXAMPLE 15

```powershell
# さまざまなカラースクリプトの毎日のローテーションを設定する
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

日付に基づいて、一貫性がありながらも異なるカラースクリプトを毎日表示します。

### EXAMPLE 16

```powershell
# レンダリングされたカラースクリプトをファイルにエクスポートして共有します
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# 後で保存したファイルを表示します
Get-Content "./aurora.ansi" -Raw | Write-Host
```

レンダリングされたカラースクリプトをファイルに保存し、後で表示したり、他のユーザーと共有したりできます。

### EXAMPLE 17

```powershell
# 幾何学的なカラースクリプトのスライドショーを作成する
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

一連の幾何学的なカラースクリプトを、それぞれの間に 3 秒の遅延を設けて自動的に表示します。

### EXAMPLE 18

```powershell
# エラー処理例
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "スクリプトが見つかりません: $_"
    Show-ColorScript  # ランダムへのフォールバック
}
```

存在しないスクリプトをリクエストした場合のエラー処理を示します。

### EXAMPLE 19

```powershell
# ビルド自動化の統合
if ($env:CI) {
    Show-ColorScript -Name "Galaxy" -NoCache
} else {
    Show-ColorScript  # インタラクティブな使用のためのランダム表示
}
```

CI/CD 環境と対話型セッションで異なるカラースクリプトを条件付きで表示する方法を示します。

### EXAMPLE 20

```powershell
# ターミナル グリーティングのスケジュールされたタスク
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

スケジュールされたタスクまたは起動自動化の一部として特定のカラースクリプトを実行する方法を示します。

### EXAMPLE 21

```powershell
Show-ColorScript -IncludePokemon
```

`Pokemon` カテゴリのスクリプトを含むランダムなカラースクリプトを表示します。ランダム選択にポケモンのアートを含めたい場合に便利です。

### EXAMPLE 22

```powershell
Show-ColorScript -Random -ExcludeCategory Pokemon,Gaming
```

`Pokemon` と `Gaming` カテゴリの両方を除外して、ランダムなカラースクリプトを表示します。 `-Category` または `-Tag` と組み合わせて、選択をさらに絞り込みます。

## PARAMETERS

### -All

利用可能なすべてのカラースクリプトをアルファベット順に循環します。単独で指定すると、スクリプトは短い自動遅延を伴って継続的に表示されます。 `-WaitForInput` と組み合わせて、コレクションの進行を手動で制御します。このモードは、ライブラリ全体を紹介したり、新しいお気に入りを発見したりするのに最適です。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

選択または表示が行われる前に、使用可能なスクリプト コレクションを 1 つ以上のカテゴリでフィルタリングします。カテゴリは通常、「自然」、「抽象」、「アート」、「レトロ」などの広範なテーマです。複数のカテゴリを配列として指定できます。このパラメータは、すべてのモード (ランダム、名前付き、リスト、すべて) と連動して、作業セットを絞り込みます。

```yaml
Type: System.String[]
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

### -ExcludeCategory

選択が行われる前に、1 つ以上のカテゴリからスクリプトを除外します。たとえば、`-ExcludeCategory Pokemon` を使用してすべての Pokémon スクリプトを回避するか、`-ExcludeCategory Pokemon,Gaming` などの複数のカテゴリを指定します。すべてのモード (ランダム、名前付き、リスト、すべて) で動作し、`-Category` および `-Tag` フィルターと組み合わせます。

```yaml
Type: System.String[]
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
DefaultValue: False
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

ポケモンのカラースクリプトを選択範囲に含めるオプトイン フラグ。省略した場合、ポケモンスクリプトは自動的に除外されます (デフォルト)。注: これは古い `-ExcludePokemon` パラメータを置き換えるもので、リファクタリングのセマンティクスが反転されているため、オプトアウトするのではなく、オプトインしてポケモン スクリプトを表示するようになります。

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

### -List

使用可能なすべてのカラースクリプトの書式設定されたリストを、関連するメタデータとともに表示します。出力には、スクリプト名、カテゴリ、タグ、説明が含まれます。これは、利用可能なオプションを調べたり、コレクションの構成を理解したりするのに役立ちます。 `-Category` または `-Tag` と組み合わせて、フィルターされたサブセットのみを一覧表示できます。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: List
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

表示するカラースクリプトの名前 (拡張子 .ps1 を除く)。柔軟なマッチングのためのワイルドカード パターン (\* および ?) をサポートします。複数のスクリプトがワイルドカード パターンに一致する場合、アルファベット順で最初に一致したものが選択されて表示されます。 `-PassThru` を使用して、ワイルドカードを使用するときにどのスクリプトが選択されたかを確認します。

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Named
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
DefaultValue: False
SupportsWildcards: false
Aliases:
- NoColor
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

### -NoCache

ポリシーで選択されたレンダラーの検証済みキャッシュ読み取りをバイパスし、新しい分離レンダリングを強制します。レンダラーの変更をテストするときや、キャッシュ破損を調査するときに便利です。静的に抽出できるバンドル スクリプトと、ポリシーにないスクリプトまたはカスタム スクリプトは、もともとキャッシュを使用しません。静的に抽出できるバンドル コンテンツは、引き続きスクリプトを実行せずに取得されます。

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

### -NoClear

`-All` とともに使用すると、カラースクリプト間の自動 `Clear-Host` 呼び出しがスキップされ、レンダリングされた各スクリプトが次のスクリプトの上に表示されたままになります。これは、スクリプトを並べて比較したり、セッションのトランスクリプトでショーケース全体をキャプチャしたりする場合に特に便利です。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -PassThru

カラースクリプトを表示するだけでなく、選択したカラースクリプトのメタデータ オブジェクトをパイプラインに返します。メタデータ オブジェクトには、名前、パス、カテゴリ、タグ、説明などのプロパティが含まれます。これにより、視覚的な出力をレンダリングしながら、フィルタリング、ロギング、またはさらなる処理のためのスクリプト情報にプログラムでアクセスできるようになります。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Named
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

### -Random

ランダムなカラースクリプトの選択を明示的にリクエストします。これは、名前が指定されていない場合のデフォルトの動作であるため、このスイッチは主にスクリプトを明確にする場合、または選択モードを明示的にしたい場合に役立ちます。 `-Category` または `-Tag` と組み合わせて、フィルター処理されたサブセット内でランダム化できます。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ReturnText

レンダリングされたカラースクリプトを、コンソール ホストに直接書き込むのではなく、PowerShell パイプラインに文字列として出力します。これにより、出力を変数に取り込んだり、ファイルにリダイレクトしたり、他のコマンドにパイプしたりすることができます。出力にはすべての ANSI エスケープ シーケンスが保持されるため、後で互換性のある端末に書き込むときに適切な色で表示されます。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- AsString
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

利用可能なスクリプト コレクションをメタデータ タグでフィルター処理します (大文字と小文字は区別されません)。タグは、「幾何学的」、「レトロ」、「アニメーション」、「ミニマル」などのカテゴリよりも具体的な記述子です。複数のタグを配列として指定できます。指定されたタグのいずれかに一致するスクリプトは、選択が行われる前に作業セットに組み込まれます。

```yaml
Type: System.String[]
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

### -ValidateCache

キャッシュ ディレクトリが現在のモジュール セッションですでに初期化されている場合を含め、レンダリング前にモジュール レベルのキャッシュ メタデータ マーカーを更新します。出力キャッシュ エントリを再構築したり、通常のエントリごとの検証を置き換えたりすることはありません。 `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE` を `1`、`true`、または `yes` に設定すると、キャッシュの初期化中に同じリフレッシュが要求されます。

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

### -WaitForInput

`-All` とともに使用する場合は、各カラースクリプトを表示した後に一時停止し、続行する前にユーザーの入力を待ちます。スペースバーを押して、シーケンス内の次のスクリプトに進みます。シーケンスを早期に終了してプロンプトに戻るには、「q」を押します。これにより、コレクション全体を通じてインタラクティブな閲覧エクスペリエンスが提供されます。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### CommonParameters

このコマンドレットは、次の共通パラメーターをサポートします:
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
詳細については、次を参照してください:
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

このコマンドレットはパイプライン入力を受け入れません。パイプラインを構成するときに、インベントリ レコードを `ForEach-Object` にパイプし、`Show-ColorScript -Name $_.Name` を呼び出します。

## OUTPUTS

### System.Object

`-PassThru` が指定されている場合、名前、パス、カテゴリ、タグ、説明などのプロパティを含む選択したカラースクリプトのメタデータ オブジェクトを返します。

### System.String (2)

`-ReturnText` が指定されている場合、レンダリングされたカラースクリプトを文字列としてパイプラインに出力します。この文字列には、互換性のある端末で表示するときに適切なカラー レンダリングを行うためのすべての ANSI エスケープ シーケンスが含まれています。

### None

デフォルトの操作 (`-PassThru` または `-ReturnText` なし) では、出力はコンソール ホストに直接書き込まれ、パイプラインには何も返されません。

## NOTES

**著者:** ニック
**モジュール:** ColorScripts-Enhanced
**必要なもの:** PowerShell 5.1 以降

## RELATED LINKS

- [オンライン バージョン](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

