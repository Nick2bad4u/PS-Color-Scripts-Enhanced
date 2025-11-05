---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ja/Set-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Set-ColorScriptConfiguration

## SYNOPSIS

ColorScripts-Enhanced の構成設定を変更します。

## SYNTAX

```
Set-ColorScriptConfiguration [-CachePath <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

ColorScripts-Enhanced の構成設定を永続ストレージで更新します。このコマンドレットは、ユーザーが設定可能なオプションを通じてモジュールの動作をカスタマイズできます。

設定可能な項目には以下が含まれます：

- キャッシュディレクトリの場所
- パフォーマンス最適化の設定
- デフォルトの表示動作
- モジュールの操作設定

変更は自動的にユーザー固有の構成ファイルに保存され、PowerShell セッション間で保持されます。現在の設定を表示するには Get-ColorScriptConfiguration を使用してください。

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath "C:\MyCache"
```

カスタムのキャッシュディレクトリパスを設定します。

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -CachePath $env:TEMP
```

キャッシュストレージにシステムの一時ディレクトリを使用します。

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "~/.colorscript-cache"
```

Unix スタイルのホームディレクトリ表記を使用してキャッシュパスを設定します。

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -WhatIf
```

変更を適用せずに、どのような構成変更が行われるかを表示します。

### EXAMPLE 5

```powershell
# 現在の構成をバックアップし、変更してから必要に応じて復元
$currentConfig = Get-ColorScriptConfiguration
Set-ColorScriptConfiguration -CachePath "D:\Cache"
# ... 新しい構成をテスト ...
# Set-ColorScriptConfiguration -CachePath $currentConfig.CachePath
```

構成のバックアップと復元を示します。

## PARAMETERS

### -CachePath

colorscript キャッシュファイルが保存されるディレクトリパスを指定します。

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

このコマンドレットは、-Debug、-ErrorAction、-ErrorVariable、-InformationAction、-InformationVariable、-OutBuffer、-OutVariable、-PipelineVariable、-ProgressAction、-Verbose、-WarningAction、-WarningVariable の共通パラメータをサポートします。詳細については、[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216) を参照してください。

## INPUTS

### None

このコマンドレットは、パイプラインからの入力を許可しません。

## OUTPUTS

### None

このコマンドレットは、パイプラインに出力を返しません。

## NOTES

**作成者:** Nick
**モジュール:** ColorScripts-Enhanced
**要件:** PowerShell 5.1 以降

**構成の永続性:**
設定は自動的にユーザー固有の構成ファイルに保存され、PowerShell セッション間で保持されます。

**パスの解決:**
キャッシュパスは環境変数、相対パス、標準の PowerShell パス表記をサポートします。

**検証:**
無効な設定を防ぐために、構成変更は適用前に検証されます。

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
