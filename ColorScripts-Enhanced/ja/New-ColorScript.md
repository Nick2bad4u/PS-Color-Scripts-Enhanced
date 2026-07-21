---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

新しいカラースクリプトをメタデータとテンプレート構造で作成します。

## SYNTAX

### Scaffold

```
New-ColorScript -Name <string> -OutputPath <string> [-h] [-Force] [-GenerateMetadataSnippet]
 [-Category <string[]>] [-Tag <string[]>] [-OpenInEditor] [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScript [-h] [-Name <string>] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

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
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

Overwrites an existing colorscript file at the resolved output path.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Overwrite
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GenerateMetadataSnippet

Includes metadata guidance for adding the new script to ScriptMetadata.psd1.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

新しいカラースクリプトの名前（.ps1拡張子なし）。

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Help
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OpenInEditor

Opens the generated colorscript with the command configured by the environment when creation succeeds.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputPath

Specifies the target directory or .ps1 file path for the generated colorscript.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Destination
- Path
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

Specifies metadata tags to include in the generated metadata guidance.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

コマンドレットが実行された場合に何が起こるかを表示します。コマンドレットは実行されません。

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

このコマンドレットはパイプラインからの入力を許可しません。

## OUTPUTS

### System.Object

作成されたカラースクリプトに関する情報を持つオブジェクトを返します。

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 以降

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
