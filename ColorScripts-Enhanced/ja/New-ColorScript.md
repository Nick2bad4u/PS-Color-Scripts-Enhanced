---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ja/New-ColorScript.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScript

## SYNOPSIS

新しいカラースクリプトをメタデータとテンプレート構造で作成します。

## SYNTAX

```text
New-ColorScript [-Name] <string> [[-Category] <string>] [[-Tags] <string[]>] [[-Description] <string>]
 [-Path <string>] [-Template <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

適切なメタデータ構造とオプションのテンプレートコンテンツを持つ新しいカラースクリプトファイルを作成します。このコマンドレットは、ColorScripts-Enhancedエコシステムにシームレスに統合する新しいカラースクリプトを作成するための標準化された方法を提供します。

このコマンドレットは以下を生成します：

- 基本構造を持つ新しい.ps1ファイル
- 分類のための関連メタデータ
- 選択されたスタイルに基づくテンプレートコンテンツ
- 適切なファイル組織

利用可能なテンプレートには以下が含まれます：

- Basic: カスタムスクリプトのための最小構造
- Animated: タイミングコントロールを持つテンプレート
- Interactive: ユーザー入力処理を持つテンプレート
- Geometric: 幾何学パターンのためのテンプレート
- Nature: 自然に着想を得たデザインのためのテンプレート

作成されたスクリプトは、モジュールのキャッシュおよび表示システムに自動的に統合されます。

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name "MyScript"
```

基本テンプレートで新しいカラースクリプトを作成します。

### EXAMPLE 2

```powershell
New-ColorScript -Name "Sunset" -Category Nature -Tags "animated", "colorful" -Description "Beautiful sunset animation"
```

メタデータを持つ自然テーマのアニメーションカラースクリプトを作成します。

### EXAMPLE 3

```powershell
New-ColorScript -Name "GeometricPattern" -Template Geometric -Path "./custom-scripts/"
```

カスタムディレクトリに幾何学カラースクリプトを作成します。

### EXAMPLE 4

```powershell
New-ColorScript -Name "InteractiveDemo" -Template Interactive -WhatIf
```

実際にファイルを作成せずに何が作成されるかを表示します。

### EXAMPLE 5

```powershell
# Create multiple related scripts
$themes = @("Forest", "Ocean", "Mountain")
foreach ($theme in $themes) {
    New-ColorScript -Name $theme -Category Nature -Tags "landscape"
}
```

複数の自然テーマのカラースクリプトを作成します。

## PARAMETERS

### -Category

新しいカラースクリプトのカテゴリを指定します。カテゴリはスクリプトをテーマ別に整理するのに役立ちます。

```yaml
Type: System.String
DefaultValue: None
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

### -Description

カラースクリプトの視覚コンテンツを説明する説明を提供します。

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: (All)
   Position: 3
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Name

新しいカラースクリプトの名前（.ps1拡張子なし）。

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: (All)
   Position: 0
   IsRequired: true
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Path

カラースクリプトが作成されるディレクトリを指定します。

```yaml
Type: System.String
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

### -Tags

カラースクリプトのタグを指定します。タグは追加のカテゴリ化とフィルタリングオプションを提供します。

```yaml
Type: System.String[]
DefaultValue: None
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
HelpMessage: ""
```

### -Template

新しいカラースクリプトに使用するテンプレートを指定します。利用可能なテンプレート: Basic, Animated, Interactive, Geometric, Nature。

```yaml
Type: System.String
DefaultValue: Basic
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

コマンドレットが実行された場合に何が起こるかを表示します。コマンドレットは実行されません。

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

このコマンドレットは共通パラメータをサポートします: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable。詳細については、
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)を参照してください。

## INPUTS

### None

このコマンドレットはパイプラインからの入力を許可しません。

## OUTPUTS

### System.Object

作成されたカラースクリプトに関する情報を持つオブジェクトを返します。

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 以降

## Templates

- Basic: カスタムスクリプトのための最小構造
- Animated: タイミングコントロールを持つテンプレート
- Interactive: ユーザー入力処理を持つテンプレート
- Geometric: 幾何学パターンのためのテンプレート
- Nature: 自然に着想を得たデザインのためのテンプレート

## File Structure
作成されたスクリプトはモジュールの標準組織に従い、キャッシュおよび表示システムに自動的に統合されます。

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
