---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ja/Reset-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

ColorScripts-Enhanced の構成をデフォルト値にリセットします。

## SYNTAX

```
Reset-ColorScriptConfiguration [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

ColorScripts-Enhanced の構成設定をデフォルト値に復元します。このコマンドレットは、すべてのユーザー カスタマイズを削除し、モジュールを元の構成状態に戻します。

リセット操作には以下が含まれます：
- キャッシュ パス設定
- パフォーマンス設定
- 表示オプション
- モジュール動作設定

このコマンドレットは以下の状況で役立ちます：
- 構成が破損した場合
- デフォルト設定で新しく開始したい場合
- 構成関連の問題のトラブルシューティング
- クリーンなモジュールテストの準備

リセット操作は、デフォルトで確認を必要とし、誤ったデータ損失を防ぎます。

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration
```

確認プロンプト付きで、すべての構成設定をデフォルトにリセットします。

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

確認プロンプトなしで構成をリセットします。

### EXAMPLE 3

```powershell
Reset-ColorScriptConfiguration -WhatIf
```

適用せずに、どのような構成変更が行われるかを表示します。

### EXAMPLE 4

```powershell
# リセットして確認
Reset-ColorScriptConfiguration
Get-ColorScriptConfiguration
```

構成をリセットし、新しいデフォルト設定を表示します。

## PARAMETERS

### -Confirm

コマンドレットを実行する前に確認を求めます。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: true
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
HelpMessage: ''
```

### -WhatIf

コマンドレットが実行された場合の動作を表示します。コマンドレットは実行されません。

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
HelpMessage: ''
```

### CommonParameters

このコマンドレットは、-Debug、-ErrorAction、-ErrorVariable、-InformationAction、-InformationVariable、-OutBuffer、-OutVariable、-PipelineVariable、-ProgressAction、-Verbose、-WarningAction、-WarningVariable の共通パラメーターをサポートします。詳細については、[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216) を参照してください。

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

**リセット範囲:**
すべてのユーザー構成可能な設定をモジュールのデフォルトにリセットします。これには、キャッシュ パス、パフォーマンス設定、表示設定が含まれます。

**データ安全性:**
構成のリセットは、キャッシュされたスクリプト出力やユーザー作成の colorscripts に影響しません。構成設定のみが影響を受けます。

**回復:**
リセット後、必要に応じて Set-ColorScriptConfiguration を使用してカスタム設定を再適用します。

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
