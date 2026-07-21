---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

カラースクリプトを表示し、高コストなレンダラーにのみ選択的キャッシュを使用します。

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

インテリジェントなパフォーマンス最適化により、ターミナルで美しいANSIカラースクリプトをレンダリングします。このコマンドレットは、4つの主要な操作モードを提供します：

**Random Mode (Default):** 利用可能なコレクションからランダムに選択されたカラースクリプトを表示します。これは、パラメータが指定されていない場合のデフォルト動作です。

**Named Mode:** 名前で特定のカラースクリプトを表示します。柔軟なマッチングのためのワイルドカードパターンをサポートします。複数のスクリプトがパターンに一致する場合、アルファベット順で最初の一致が選択されます。

**List Mode:** 名前、カテゴリ、タグ、説明などのメタデータを含む、利用可能なすべてのカラースクリプトのフォーマットされたリストを表示します。

**All Mode:** アルファベット順ですべての利用可能なカラースクリプトを循環します。特に、コレクション全体を展示したり、新しいスクリプトを発見したりするのに便利です。

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

キャッシングが有効なランダムなカラースクリプトを表示します。これはターミナルセッションに視覚的な魅力を追加する最も速い方法です。

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

正確な名前で指定されたカラースクリプトを表示します。 .ps1拡張子は必要ありません。

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

ワイルドカードパターン「aurora-\*」に一致する最初のカラースクリプト（アルファベット順）を表示します。スクリプトの名前の部分を覚えている場合に便利です。

### EXAMPLE 4

```powershell
scs hearts
```

モジュールのエイリアス 'scs' を使用してheartsカラースクリプトに素早くアクセスします。エイリアスは頻繁な使用のための便利なショートカットを提供します。

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

利用可能なすべてのカラースクリプトをメタデータとともにフォーマットされたテーブルでリストします。利用可能なスクリプトを発見し、その属性を理解するのに役立ちます。

### EXAMPLE 6

```powershell
Show-ColorScript -Name arch -NoCache
```

キャッシュを使用せずにarchカラースクリプトを表示し、新鮮な実行を強制します。開発中やキャッシュの問題のトラブルシューティング時に便利です。

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

ランダムな自然テーマのスクリプトを表示し、そのメタデータオブジェクトをさらに検査または処理するためにキャプチャします。

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

カラースクリプトをレンダリングし、出力をテキストファイルに保存します。レンダリングされたANSIコードが保持され、後で適切な色付けでファイルを表示できます。

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

すべてのカラースクリプトをアルファベット順に表示し、各間に短い自動遅延を設けます。コレクション全体の視覚的なショーケースに最適です。

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

すべてのカラースクリプトを一度に一つずつ表示し、各後に一時停止します。各スクリプトに進むためにスペースバーを押すか、シーケンスを早期に終了するために 'q' を押します。

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

すべての自然テーマのカラースクリプトを循環し、手動進行で表示します。フィルタリングとインタラクティブなブラウジングを組み合わせたキュレートされた体験を提供します。

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

「retro」と「geometric」の両方のタグを持つランダムなカラースクリプトを表示します。タグフィルタリングにより、正確なサブセット選択が可能になります。

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Art,Abstract
```

「Art」または「Abstract」として分類されたカラースクリプトのみをリストし、特定のテーマ内のスクリプトを発見するのに役立ちます。

### EXAMPLE 14

```powershell
# Measure performance improvement from caching
$uncached = Measure-Command { Show-ColorScript -Name spectrum -NoCache }
$cached = Measure-Command { Show-ColorScript -Name spectrum }
Write-Host "Uncached: $($uncached.TotalMilliseconds)ms | Cached: $($cached.TotalMilliseconds)ms | Speedup: $([math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 1))x"
```

キャッシングが提供するパフォーマンス向上を測定することで実証します。

### EXAMPLE 15

```powershell
# Set up daily rotation of different colorscripts
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

日付に基づいて一貫性がありながら異なるカラースクリプトを毎日表示します。

### EXAMPLE 16

```powershell
# Export rendered colorscript to file for sharing
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Later, display the saved file
Get-Content "./aurora.ansi" -Raw | Write-Host
```

レンダリングされたカラースクリプトを後で表示したり共有したりできるファイルに保存します。

### EXAMPLE 17

```powershell
# Create a slideshow of geometric colorscripts
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

各間に3秒の遅延を設けて、幾何学的なカラースクリプトのシーケンスを自動的に表示します。

### EXAMPLE 18

```powershell
# Error handling example
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Script not found: $_"
    Show-ColorScript  # Fallback to random
}
```

存在しないスクリプトを要求した場合のエラー処理を実証します。

### EXAMPLE 19

```powershell
# Build automation integration
if ($env:CI) {
    Show-ColorScript -Name "nerd-font-test" -NoCache
} else {
    Show-ColorScript  # Random display for interactive use
}
```

CI/CD環境とインタラクティブセッションで異なるカラースクリプトを条件付きで表示する方法を示します。

### EXAMPLE 20

```powershell
# Scheduled task for terminal greeting
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

スケジュールされたタスクやスタートアップ自動化の一部として特定のカラースクリプトを実行する方法を実証します。

## PARAMETERS

### -All

利用可能なすべてのカラースクリプトをアルファベット順に循環します。単独で指定すると、スクリプトは短い自動遅延で連続して表示されます。`-WaitForInput` と組み合わせることで、コレクションを通じた進行を手動で制御できます。このモードは、完全なライブラリを展示したり、新しいお気に入りを見つけるのに理想的です。

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

選択または表示が発生する前に、1つ以上のカテゴリで利用可能なスクリプトコレクションをフィルタリングします。カテゴリは通常、「Nature」、「Abstract」、「Art」、「Retro」などの広範なテーマです。複数のカテゴリを配列として指定できます。このパラメータは、すべてのモード（Random、Named、List、All）と連携して作業セットを絞り込みます。

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

Exclude scripts from one or more categories.
Use this to filter out large collections like Pokemon scripts.

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

Opt-in flag to include Pokemon colorscripts in the random selection.
When omitted, Pokemon scripts are filtered out automatically.

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

関連するメタデータとともに、利用可能なすべてのカラースクリプトのフォーマットされたリストを表示します。出力にはスクリプト名、カテゴリ、タグ、説明が含まれます。これは利用可能なオプションを探索し、コレクションの組織を理解するのに役立ちます。`-Category` または `-Tag` と組み合わせることで、フィルタリングされたサブセットのみをリストできます。

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

表示するカラースクリプトの名前（.ps1拡張子なし）。柔軟なマッチングのためのワイルドカードパターン（\* と ?）をサポートします。複数のスクリプトがワイルドカードパターンに一致する場合、アルファベット順で最初の一致が選択されて表示されます。ワイルドカードを使用する場合、`-PassThru` を使用してどのスクリプトが選択されたかを確認してください。

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

プレーンテキスト環境向けに、情報メッセージと描画出力の ANSI 装飾を無効にします。

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

キャッシングシステムをバイパスし、カラースクリプトを直接実行します。これにより、新鮮な実行が強制され、スクリプトの変更をテストしたり、デバッグしたり、キャッシュの破損が疑われる場合に役立ちます。このスイッチがない場合、最適なパフォーマンスのために利用可能なキャッシュされた出力が使用されます。

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

When cycling through scripts with -All, skip clearing the host between displays so prior output remains visible.

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

カラースクリプトを表示するだけでなく、選択されたカラースクリプトのメタデータオブジェクトをパイプラインに返します。メタデータオブジェクトには、Name、Path、Category、Tags、Description などのプロパティが含まれます。これにより、視覚出力をレンダリングしながら、スクリプト情報をフィルタリング、ロギング、またはさらなる処理のためにプログラムでアクセスできます。

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

コマンドの出力やエラーを維持したまま、情報メッセージを抑制します。

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

ランダムなカラースクリプトの選択を明示的に要求します。これは名前が指定されていない場合のデフォルト動作なので、このスイッチは主にスクリプトでの明確さや、選択モードを明示的にしたい場合に役立ちます。`-Category` または `-Tag` と組み合わせることで、フィルタリングされたサブセット内でランダマイズできます。

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

レンダリングされたカラースクリプトをコンソールホストに直接書き込む代わりに、文字列として PowerShell パイプラインに送信します。これにより、出力を変数にキャプチャしたり、ファイルにリダイレクトしたり、他のコマンドにパイプしたりできます。出力はすべての ANSI エスケープシーケンスを保持するので、後で互換性のあるターミナルに書き込まれたときに適切な色で表示されます。

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

メタデータタグ（大文字小文字を区別しない）で利用可能なスクリプトコレクションをフィルタリングします。タグはカテゴリよりも具体的な記述子で、「geometric」、「retro」、「animated」、「minimal」などが含まれます。複数のタグを配列として指定できます。指定されたタグのいずれかに一致するスクリプトが、選択が発生する前に作業セットに含まれます。

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

Forces cache validation before rendering.
Use when you need to rebuild cached colorscript output manually.

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

`-All` と一緒に使用すると、各カラースクリプトを表示した後に一時停止し、続行する前にユーザー入力待ちます。スペースバーを押すとシーケンスの次のスクリプトに進みます。'q' を押すとシーケンスを早期に終了し、プロンプトに戻ります。これにより、コレクション全体を通じたインタラクティブなブラウジング体験が提供されます。

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Show-ColorScript にカラースクリプト名をパイプできます。これにより、スクリプト名が他のコマンドによって生成またはフィルタリングされるパイプラインベースのワークフローが可能になります。

## OUTPUTS

### System.Object

`-PassThru` が指定された場合、選択されたカラースクリプトのメタデータオブジェクトを返します。このオブジェクトには、Name、Path、Category、Tags、Description などのプロパティが含まれます。

### System.String (2)

`-ReturnText` が指定された場合、レンダリングされたカラースクリプトを文字列としてパイプラインに送信します。この文字列には、互換性のあるターミナルで表示されたときに適切な色でレンダリングするためのすべての ANSI エスケープシーケンスが含まれます。

### None

デフォルト操作（`-PassThru` または `-ReturnText` なし）では、出力はコンソールホストに直接書き込まれ、パイプラインには何も返されません。

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

