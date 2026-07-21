---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

利用可能なカラースクリプトとそのメタデータのリストを取得します。

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

ColorScripts-Enhanced コレクションで利用可能なカラースクリプトに関する情報を返します。デフォルトでは、スクリプト名、カテゴリ、説明を表示したフォーマットされたテーブルを表示します。プログラムによるアクセス用に構造化されたオブジェクトを返すには `-AsObject` を使用します。

このコマンドレットは、各カラースクリプトに関する包括的なメタデータを提供します：

- Name: スクリプト識別子（.ps1 拡張子なし）
- Category: テーマ別のグループ化（Nature、Abstract、Geometric など）
- Tags: フィルタリングと発見のための追加記述子
- Description: スクリプトの視覚コンテンツの簡単な説明

このコマンドレットは、コレクションを探索し、`Show-ColorScript` のような他のコマンドレットを使用する前に利用可能なオプションを理解するために不可欠です。

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

すべての利用可能なカラースクリプトとそのメタデータをフォーマットされたテーブルで表示します。

### EXAMPLE 2

```powershell
Get-ColorScriptList -Category Nature
```

"Nature" カテゴリに分類されたカラースクリプトのみをリストします。

### EXAMPLE 3

```powershell
Get-ColorScriptList -Tag geometric -AsObject
```

"geometric" としてタグ付けされたカラースクリプトをオブジェクトとして返し、さらに処理します。

### EXAMPLE 4

```powershell
Get-ColorScriptList -Name "aurora*" | Format-Table Name, Category, Tags
```

ワイルドカードパターンに一致するカラースクリプトをリストし、選択したプロパティを表示します。

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject | Where-Object { $_.Tags -contains 'animated' }
```

オブジェクトフィルタリングを使用してすべてのアニメーションカラースクリプトを検索します。

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Abstract,Geometric | Measure-Object
```

Abstract または Geometric カテゴリのカラースクリプトをカウントします。

### EXAMPLE 7

```powershell
Get-ColorScriptList -Tag retro | Select-Object Name, Description
```

レトロスタイルのカラースクリプトの名前と説明を表示します。

### EXAMPLE 8

```powershell
# Get random script from specific category
Get-ColorScriptList -Category Nature -AsObject | Get-Random | Select-Object -ExpandProperty Name
```

特定の Nature カテゴリからランダムなカラースクリプト名を選択します。

### EXAMPLE 9

```powershell
# Export script inventory to CSV
Get-ColorScriptList -AsObject | Export-Csv -Path "colorscripts.csv" -NoTypeInformation
```

完全なスクリプトメタデータを CSV ファイルにエクスポートします。

### EXAMPLE 10

```powershell
# Find scripts by multiple criteria
Get-ColorScriptList -AsObject | Where-Object {
    $_.Category -eq 'Geometric' -and $_.Tags -contains 'colorful'
}
```

色鮮やかな Geometric カラースクリプトを検索します。

## PARAMETERS

### -AsObject

カラースクリプト情報をフォーマットされたテーブルではなく構造化されたオブジェクトとして返します。オブジェクトには Name、Category、Tags、Description プロパティが含まれ、プログラムによるアクセスが可能です。

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

結果を 1 つ以上の指定されたカテゴリに属するカラースクリプトにフィルタリングします。カテゴリは "Nature"、"Abstract"、"Art"、"Retro" などの広範なテーマ別グループです。

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

Displays an expanded formatted view that includes descriptions and additional metadata.

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

結果を 1 つ以上の名前パターンに一致するカラースクリプトにフィルタリングします。柔軟なマッチングのためにワイルドカード（\* と ?）をサポートします。

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

プレーンテキスト環境向けに、情報メッセージと描画出力の ANSI 装飾を無効にします。

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

コマンドの出力やエラーを維持したまま、情報メッセージを抑制します。

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

結果を 1 つ以上の指定されたタグでタグ付けされたカラースクリプトにフィルタリングします。タグは "geometric"、"retro"、"animated"、"minimal" などのより具体的な記述子です。

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

このコマンドレットはパイプラインからの入力を受信しません。

## OUTPUTS

### System.Object

`-AsObject` が指定された場合、Name、Category、Tags、Description プロパティを持つカスタムオブジェクトを返します。

### None (2)

`-AsObject` が指定されていない場合、出力はコンソールホストに直接書き込まれます。

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 以降

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)
