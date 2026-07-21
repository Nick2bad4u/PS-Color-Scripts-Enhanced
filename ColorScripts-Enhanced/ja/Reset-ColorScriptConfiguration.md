---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

ColorScripts-Enhanced の構成をデフォルト値にリセットします。

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

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

Returns the effective default configuration after the reset succeeds.

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

コマンドレットが実行された場合の動作を表示します。コマンドレットは実行されません。

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

このコマンドレットは、パイプラインからの入力を許可しません。

## OUTPUTS

### None (2)

このコマンドレットは、パイプラインに出力を返しません。

## NOTES

**作成者:** Nick
**モジュール:** ColorScripts-Enhanced
**要件:** PowerShell 5.1 以降

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)

