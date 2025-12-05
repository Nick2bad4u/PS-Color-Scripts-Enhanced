---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ja/New-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 11/14/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScriptCache

## SYNOPSIS

カラースクリプトのパフォーマンス最適化のためのキャッシュを事前構築します。

## SYNTAX

### すべて

```text
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### 名前指定

```text
New-ColorScriptCache [-Name <String[]>] [-Category <String[]>] [-Tag <String[]>] [-Force] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

初回表示時の最適なパフォーマンスを確保するために、colorscripts のキャッシュ出力を事前生成します。このコマンドレットは colorscripts を事前に実行し、レンダリングされた出力を保存して即時取得できるようにします。

キャッシュシステムは 6-19 倍のパフォーマンス向上を提供します。初回実行時には colorscript が通常通り実行され、その出力がキャッシュされます。以降の表示ではキャッシュされた出力を使用してほぼ瞬時にレンダリングされます。ソーススクリプトが変更されるとキャッシュは自動的に無効化され、出力の正確性が確保されます。


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

利用可能なすべての colorscripts のキャッシュを事前構築します。

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name "spectrum", "aurora-waves"
```

名前で特定の colorscripts をキャッシュします。

### EXAMPLE 3

```powershell
New-ColorScriptCache -Category Nature
```

自然テーマのすべての colorscripts のキャッシュを事前構築します。

### EXAMPLE 4

```powershell
New-ColorScriptCache -Tag animated
```

"animated" としてタグ付けされたすべての colorscripts をキャッシュします。

### EXAMPLE 5

```powershell
# Cache scripts for startup optimization
New-ColorScriptCache -Category Geometric -Tag minimal
```

クイックスタートアップ表示に適した軽量の幾何学スクリプトのキャッシュを準備します。

## PARAMETERS

### -Category

キャッシュするスクリプトを 1 つ以上のカテゴリでフィルタリングします。

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
HelpMessage: ""
```

### -Confirm

コマンドレットを実行する前に確認を求めます。

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
HelpMessage: ""
```

### -Force

既存のキャッシュが最新でも再生成を強制します。

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

### -PassThru

各スクリプトの結果オブジェクトを返します。指定しない場合は要約のみ表示されます。

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

### -Name

キャッシュする colorscript の名前を指定します。ワイルドカード (\* と ?) をサポートします。

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
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

### -Tag

キャッシュするスクリプトを 1 つ以上のタグでフィルタリングします。

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
HelpMessage: ""
```

### -WhatIf

コマンドレットを実行した場合に何が起こるかを表示します。コマンドレットは実行されません。

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
HelpMessage: ""
```

### CommonParameters

このコマンドレットは、-Debug、-ErrorAction、-ErrorVariable、-InformationAction、-InformationVariable、-OutBuffer、-OutVariable、-PipelineVariable、-ProgressAction、-Verbose、-WarningAction、-WarningVariable の共通パラメータをサポートします。詳細については、[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216) を参照してください。

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

## Performance Impact
事前キャッシュにより、初回表示時の実行時間が排除され、即時の視覚フィードバックが提供されます。特に複雑またはアニメーションスクリプトに有益です。

## Cache Management
キャッシュファイルはモジュール管理ディレクトリに保存され、ソーススクリプトが変更されると自動的に無効化されます。古いキャッシュを削除するには Clear-ColorScriptCache を使用します。

## Best Practices

- 最適なパフォーマンスのために頻繁に使用するスクリプトをキャッシュ
- 不必要な処理を避けるために選択的なキャッシュを使用
- モジュール更新後に実行してキャッシュの有効性を確保

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
