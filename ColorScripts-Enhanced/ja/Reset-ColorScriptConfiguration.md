---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

ColorScripts-Enhanced 構成をデフォルト値に戻します。

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

このコマンドにはエイリアスがありません。

## DESCRIPTION

`Reset-ColorScriptConfiguration` は、永続化された構成を組み込みのデフォルトに置き換え、モジュールのメモリ内キャッシュ状態をリセットします。このコマンドレットを実行すると、次のことが行われます。

- 構成されたキャッシュパスのオーバーライドをクリアして、有効なプラットフォームのデフォルトが使用されるようにします。
- `AutoShowOnImport`、`ProfileAutoShow`、および `DefaultScript` を復元します
- デフォルト設定を `config.json` に書き込みます
- メモリ内のキャッシュ/構成状態をクリアし、後続の操作でリセット値が使用されるようにします。

このコマンドレットは、構成ファイルを上書きすることで破壊的な操作を実行するため、`-WhatIf` パラメーターと `-Confirm` パラメーターをサポートします。リセット操作は自動的に元に戻すことはできないため、続行する前に `Get-ColorScriptConfiguration` を使用して現在の構成をバックアップすることを検討する必要があります。

`-PassThru` パラメータを使用すると、リセットの完了後に新しく復元されたデフォルト設定をすぐに検査できます。

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

確認を求めるプロンプトを表示せずに構成をリセットします。これは、自動スクリプトで使用する場合、またはデフォルトにリセットすることが確実な場合に便利です。

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

構成をリセットし、結果のハッシュテーブルを検査用に返します。これにより、デフォルト値を確認できるようになります。

### EXAMPLE 3

```powershell
# リセットする前に現在の構成をバックアップする
$backup = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
```

現在の構成をバックアップした後、`-WhatIf` を使用して、リセット操作を実際に実行せずにプレビューします。

### EXAMPLE 4

```powershell
Reset-ColorScriptConfiguration -Verbose
```

詳細な出力で構成をリセットし、操作に関する詳細情報を確認します。

### EXAMPLE 5

```powershell
# 設定をリセットし、キャッシュをクリアして完全に出荷時設定にリセットします
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "モジュールが工場出荷時のデフォルトにリセットされました。"
```

構成、キャッシュ、キャッシュの再構築を含む完全な出荷時設定へのリセットを実行します。

### EXAMPLE 6

```powershell
# リセットが成功したことを確認する
$config = Reset-ColorScriptConfiguration -PassThru
if ($null -eq $config.Cache.Path -and $config.Cache.EffectivePath) {
    Write-Host "構成がプラットフォームのデフォルトに正常にリセットされました"
} else {
    Write-Host "構成はリセットされましたが、カスタム パスを使用しました: $($config.Cache.Path)"
}
```

リセットして、永続化キャッシュ オーバーライドが空であり、有効なプラットフォーム パスが使用可能であることを確認します。

## PARAMETERS

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

リセットが完了したら、更新された構成オブジェクトを返します。

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

### -WhatIf

実際にリセット操作を実行せずにコマンドレットを実行した場合に何が起こるかを示します。

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

### System.Collections.Hashtable

`-PassThru` が指定された場合に返されます。

## NOTES

設定ファイルは、`Get-ColorScriptConfiguration` で解決されたディレクトリに保存されます。デフォルトでは、この場所はプラットフォーム固有です。

- **Windows**: `$env:APPDATA\ColorScripts-Enhanced`
- **Linux/macOS**: `$HOME/.config/ColorScripts-Enhanced`

環境変数 `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` は、モジュールのインポート前に設定されている場合、デフォルトの場所をオーバーライドできます。

## RELATED LINKS

- [オンライン バージョン](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)

