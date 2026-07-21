---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

現在の ColorScripts-Enhanced 構成設定を取得します。

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

ColorScripts-Enhanced の現在の構成設定を表示します。これには、キャッシュ パス、パフォーマンス設定、モジュールの動作に影響するユーザー設定が含まれます。

構成システムは、モジュールの操作をカスタマイズする永続的な設定を提供します。設定はユーザー固有の構成ファイルに保存され、Set-ColorScriptConfiguration を使用して変更できます。

表示される情報には以下が含まれます：

- キャッシュ ディレクトリの場所
- パフォーマンス最適化設定
- デフォルトの表示設定
- モジュールの動作設定

このコマンドレットは、現在のモジュール構成を理解し、構成関連の問題をトラブルシューティングするために不可欠です。

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

すべての現在の構成設定を表示します。

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | Format-List
```

構成をリスト形式で表示し、読みやすさを向上させます。

### EXAMPLE 3

```powershell
# Check cache location
(Get-ColorScriptConfiguration).CachePath
```

キャッシュ パス設定のみを取得します。

### EXAMPLE 4

```powershell
# Verify configuration is loaded
if (Get-ColorScriptConfiguration) {
    Write-Host "Configuration loaded successfully"
}
```

構成が適切に読み込まれているかどうかを確認します。

## PARAMETERS

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

構成プロパティを含むカスタム オブジェクトを返します。

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
