---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ja/Get-ColorScriptList.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptList

## SYNOPSIS

利用可能なカラースクリプトとそのメタデータのリストを取得します。

## SYNTAX

```
Get-ColorScriptList [[-Name] <string[]>] [-Category <string[]>] [-Tag <string[]>] [-AsObject]
 [<CommonParameters>]
```

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

### -Category

結果を 1 つ以上の指定されたカテゴリに属するカラースクリプトにフィルタリングします。カテゴリは "Nature"、"Abstract"、"Art"、"Retro" などの広範なテーマ別グループです。

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

### -Name

結果を 1 つ以上の名前パターンに一致するカラースクリプトにフィルタリングします。柔軟なマッチングのためにワイルドカード（\* と ?）をサポートします。

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

結果を 1 つ以上の指定されたタグでタグ付けされたカラースクリプトにフィルタリングします。タグは "geometric"、"retro"、"animated"、"minimal" などのより具体的な記述子です。

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

### CommonParameters

このコマンドレットは共通パラメータをサポートします：-Debug、-ErrorAction、-ErrorVariable、-InformationAction、-InformationVariable、-OutBuffer、-OutVariable、-PipelineVariable、-ProgressAction、-Verbose、-WarningAction、-WarningVariable。詳細については、[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216) を参照してください。

## INPUTS

### None

このコマンドレットはパイプラインからの入力を受信しません。

## OUTPUTS

### System.Object

`-AsObject` が指定された場合、Name、Category、Tags、Description プロパティを持つカスタムオブジェクトを返します。

### None

`-AsObject` が指定されていない場合、出力はコンソールホストに直接書き込まれます。

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 以降

**Metadata Properties:**

- Name: Show-ColorScript で使用されるスクリプト識別子
- Category: 組織化のためのテーマ別グループ
- Tags: フィルタリングのための記述キーワードの配列
- Description: コンテンツの人間が読める説明

**Usage Patterns:**

- Discovery: 選択前に利用可能なスクリプトを探索
- Filtering: カテゴリとタグを使用してオプションを絞り込む
- Automation: プログラムによるスクリプト選択のために -AsObject を使用
- Inventory: ドキュメントまたはレポートのためのメタデータをエクスポート

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
