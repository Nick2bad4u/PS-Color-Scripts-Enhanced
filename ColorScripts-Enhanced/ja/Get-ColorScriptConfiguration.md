---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ja/Get-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptConfiguration

## SYNOPSIS

現在の ColorScripts-Enhanced 構成設定を取得します。

## SYNTAX

```powershell
Get-ColorScriptConfiguration [<CommonParameters>]
```

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

### CommonParameters

このコマンドレットは共通パラメータをサポートします: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. 詳細については、
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216) を参照してください。

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

## 構成プロパティ

- CachePath: キャッシュされたスクリプト出力が保存される場所
- 最適化のためのパフォーマンス設定
- デフォルト動作の表示設定
- モジュール固有の構成オプション

## 構成の場所
設定はユーザー固有の構成ファイルに保存されます。永続性のために標準の PowerShell 構成メカニズムを使用します。

## RELATED LINKS

- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
