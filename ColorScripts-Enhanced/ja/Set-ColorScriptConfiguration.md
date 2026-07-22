---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

ColorScripts-Enhanced キャッシュおよび起動設定への変更を保持します。

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

このコマンドにはエイリアスがありません。

## DESCRIPTION

`Set-ColorScriptConfiguration` は、ColorScripts-Enhanced モジュールの動作と保存場所をカスタマイズする永続的な方法を提供します。このコマンドレットはモジュールの構成ファイルを更新し、スクリプトのレンダリングと保存のさまざまな側面を制御できるようにします。

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

キャッシュを `D:/Temp/ColorScriptsCache` に移動し、モジュールのインポート時の自動表示を有効にし、プロファイルの自動表示を無効にして、`bars` をデフォルトのスクリプトとして設定します。

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

デフォルトのスクリプトをクリアし、結果の構成オブジェクトを返すことで、設定が削除されたことを確認できます。

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

キャッシュを Windows TEMP ディレクトリに再配置し、更新された完全な構成をリスト形式で表示します。一時的なテスト シナリオに役立ちます。

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

モジュールのロード時に自動カラースクリプト レンダリングを無効にします。スクリプトを表示するタイミングを手動で制御したい場合に便利です。

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

チルダ展開を使用して Linux/macOS スタイルのキャッシュ パスを設定し、すべての操作のデフォルト スクリプトとして「crunch」を構成します。

## PARAMETERS

### -AutoShowOnImport

モジュールのインポート時のカラースクリプトの自動レンダリングを有効または無効にします。有効にすると (`$true`)、モジュールのインポート時にカラースクリプトがすぐに表示され、即座に視覚的なフィードバックが提供されます。無効にすると (`$false`)、スクリプトは明示的に呼び出された場合にのみ表示されます。指定しない場合、既存の設定は変更されません。

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
SupportsWildcards: false
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

### -CachePath

レンダリングされた `.cache` ペイロードと `.cacheinfo` 検証サイドカーが保存されるディレクトリを指定します。ソースのカラースクリプトとモジュールのメタデータは、インストールされたモジュールに残ります。絶対パス、相対パス (現在の場所から解決)、環境変数 (`$env:USERPROFILE` など)、チルダ (`~`) の展開をサポートします。

指定したディレクトリが存在しない場合は、適切なアクセス許可を使用して自動的に作成されます。空の文字列 (`''`) を指定すると、カスタム パスがクリアされ、プラットフォーム固有のデフォルトの場所に戻ります。指定しない場合、既存のキャッシュ パス設定が保持されます。

**注意**: キャッシュ パスを変更しても、既存のキャッシュ ファイルは自動的に移行されません。ファイルを手動でコピーするか、再生成できるようにする必要がある場合があります。

```yaml
Type: System.String
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

### -Confirm

コマンドレットを実行する前に確認を求めるメッセージが表示されます。

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

### -DefaultScript

プロファイル ヘルパー、自動表示機能、およびコマンドでスクリプトを明示的に指定しない場合に使用する既定のカラースクリプト名を設定またはクリアします。拡張子を除いたスクリプト ファイルのベース名と一致する必要があります (例: `'bars'`。`'bars.ps1'` ではありません)。

空の文字列 (`''`) を指定すると、保存されているデフォルトが削除され、モジュール レベルのデフォルトの動作 (通常はランダムな選択) に戻ります。このパラメータを省略した場合、現在のデフォルトのスクリプト設定は変更されません。

指定したスクリプトを正常に使用するには、モジュールのスクリプト ディレクトリに存在する必要があります。

```yaml
Type: System.String
DefaultValue: ''
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

### -PassThru

変更を加えた後、更新された構成オブジェクトを返します。このスイッチを使用しないと、コマンドレットはサイレントに動作します (出力はありません)。返されたオブジェクトは `Get-ColorScriptConfiguration` と同じ構造を持ち、検査、保存、または他のコマンドレットにパイプしてさらに処理することができます。

構成コマンドの検証、ロギング、または連鎖に役立ちます。

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

### -ProfileAutoShow

`Add-ColorScriptProfile` によって生成されたプロファイル スニペットに自動 `Show-ColorScript` 呼び出しが含まれるかどうかを制御します。 `$true` の場合、プロファイル コードはシェルの起動ごとにカラースクリプトを表示します。 `$false` の場合、プロファイルはモジュールをロードしますが、自動表示スクリプトはロードしません。

この設定は、新しく生成されたプロファイル コードにのみ影響します。既存のプロファイルの変更は自動的には更新されません。このパラメータを省略すると、現在の設定は変更されません。

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -WhatIf

アクションを実行せずに、何が起こるかを報告するだけのモードでコマンドを実行します。

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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
詳細については、次を参照してください:
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

このコマンドレットはパイプライン入力を受け入れません。

## OUTPUTS

### None (2)

デフォルトでは、このコマンドレットは出力を生成しません。

### System.Collections.Hashtable

`-PassThru` が指定されている場合、`Get-ColorScriptConfiguration` によって生成されたネストされたハッシュテーブルが返されます。キャッシュ値は `Cache` の下にあり、起動値は `Startup` の下にあります。

## NOTES

構成は、検証と確認が成功した場合にのみ保持されます。 `-WhatIf` はファイルシステムへの書き込みを実行しません。 `Get-ColorScriptConfiguration` を使用して、操作後の有効な値とストレージ パスを検査します。

## RELATED LINKS

- [オンライン バージョン](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)

