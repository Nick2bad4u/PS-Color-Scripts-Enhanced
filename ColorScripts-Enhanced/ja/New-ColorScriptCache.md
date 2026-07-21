---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

カラースクリプトのパフォーマンス最適化のためのキャッシュを事前構築します。

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

計算コストの高い colorscripts のキャッシュ出力を事前生成します。`CachePolicy.psd1` に記載されたレンダラーだけが実行および保存されます。静的または未登録のスクリプトは `SkippedNotRequired` としてスキップされ、それらの古いキャッシュは削除されます。

キャッシュシステムは選択されたレンダラーに 6-19 倍のパフォーマンス向上を提供します。ソーススクリプトが変更されるとキャッシュは自動的に無効化されます。`-Force` を指定してもキャッシュポリシーは上書きされません。


### -IncludePokemon

キャッシュのビルドにポケモン（通常および色違い）を含めます。デフォルトではポケモンのスクリプトは除外されています。ポケモンを含めるには `-IncludePokemon` を使用してください。注: このパラメーターは以前の `-ExcludePokemon` を置き換え、リファクタにより意味が反転しています（現在はオプトイン）。

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
HelpMessage: ""
```
### -Quiet

完了時のサマリーメッセージを抑制します。

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
HelpMessage: ""
```

### -NoAnsiOutput

サマリー出力の ANSI カラーを無効にし、プレーンテキストにします。

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
HelpMessage: ""
```
このコマンドレットを使用して：


このコマンドレットは、名前、カテゴリ、またはタグによる選択的なキャッシュをサポートし、ターゲットを絞ったキャッシュ準備を可能にします。

既定では要約メッセージを表示します。`-PassThru` を指定すると詳細な結果が取得でき、`-Quiet` で要約を抑制し、`-NoAnsiOutput` でANSIカラーを含まないテキストを出力できます。

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

利用可能なすべての colorscripts を評価し、`CachePolicy.psd1` で選択されたレンダラーだけをキャッシュします。

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name "Galaxy", "rose-curves"
```

名前で特定の colorscripts をキャッシュします。

### EXAMPLE 3

```powershell
New-ColorScriptCache -Category Nature
```

自然テーマのすべての colorscripts を評価し、対象となるレンダラーだけをキャッシュします。

### EXAMPLE 4

```powershell
New-ColorScriptCache -Tag animated
```

"animated" としてタグ付けされたすべての colorscripts を評価し、対象となるレンダラーだけをキャッシュします。

### EXAMPLE 5

```powershell
# Cache scripts for startup optimization
New-ColorScriptCache -Category Geometric -Tag minimal
```

クイックスタートアップ表示に適した軽量の幾何学スクリプトのキャッシュを準備します。

## PARAMETERS

### -All

Processes every renderer selected by CachePolicy.psd1 without enumerating the full static script inventory.

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

キャッシュするスクリプトを 1 つ以上のカテゴリでフィルタリングします。

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

コマンドレットを実行する前に確認を求めます。

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

既存のキャッシュが最新でも対象となるキャッシュの再生成を強制します。キャッシュポリシーは上書きされません。

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

キャッシュのビルドにポケモン（通常および色違い）を含めます。デフォルトではポケモンのスクリプトは除外されています。ポケモンを含めるには `-IncludePokemon` を使用してください。注: このパラメーターは以前の `-ExcludePokemon` を置き換え、リファクタにより意味が反転しています（現在はオプトイン）。

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

キャッシュする colorscript の名前を指定します。ワイルドカード (\* と ?) をサポートします。

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

サマリー出力の ANSI カラーを無効にし、プレーンテキストにします。

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

Builds eligible cache entries concurrently. Unsupported hosts fall back to sequential execution.

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

各スクリプトの結果オブジェクトを返します。指定しない場合は要約のみ表示されます。

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

完了時のサマリーメッセージを抑制します。

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

キャッシュするスクリプトを 1 つ以上のタグでフィルタリングします。

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

Sets the maximum number of concurrent cache workers. Threads is an alias for this parameter.

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

コマンドレットを実行した場合に何が起こるかを表示します。コマンドレットは実行されません。

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

このコマンドレットはパイプラインからの入力を受信しません。

## OUTPUTS

### System.Object

各スクリプトの成功/失敗ステータスを含むキャッシュ構築結果を返します。

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 以降

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
