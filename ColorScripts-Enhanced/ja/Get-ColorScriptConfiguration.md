---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

現在の ColorScripts-Enhanced モジュール構成設定を取得します。

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

このコマンドにはエイリアスがありません。

## DESCRIPTION

`Get-ColorScriptConfiguration` は、有効なモジュール構成のコピーを返します。現在のスキーマには次のものが含まれます。

- **キャッシュ設定**: 構成されたオーバーライドおよび解決された有効なキャッシュ ディレクトリ
- **起動動作**: `AutoShowOnImport`、`ProfileAutoShow`、および `DefaultScript`

構成は、複数のソースから優先順位に従って組み立てられます。

1. 内蔵モジュールのデフォルト (優先度が最も低い)
2. 構成ファイルからの永続的なユーザーの上書き
3. `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` 返された有効なキャッシュ パス

構成ファイルは通常、Windows では `%APPDATA%\ColorScripts-Enhanced\config.json`、Unix 系システムでは `~/.config/ColorScripts-Enhanced/config.json` にあります。

返されたハッシュテーブルは現在の構成状態のスナップショットであり、アクティブな構成に影響を与えることなく、安全に検査、複製、またはシリアル化できます。

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

デフォルトのテーブルビューを使用して現在の構成を表示し、すべてのキャッシュと起動設定を示します。

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

ログ記録、デバッグ、または他のツールへのエクスポートのために、構成を JSON 形式にシリアル化します。

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.EffectivePath
```

解決されたキャッシュ ディレクトリを取得します。 `Cache.Path` は、オプションのユーザー構成オーバーライドのままです。
`Cache.EffectivePath` は、プラットフォームのデフォルト設定後にモジュールが実際に使用するディレクトリを示します。
環境オーバーライドが適用されます。

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.AutoShowOnImport) {
    Write-Host "起動スクリプトが有効になっています"
}
```

現在の構成で起動スクリプトが有効になっているかどうかを確認します。

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

包括的な検査のために、すべての構成プロパティを詳細なリスト形式で表示します。

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "キャッシュ パス: $($config.Cache.Path)"
Write-Host "プロファイルの自動表示: $($config.Startup.ProfileAutoShow)"
Write-Host "デフォルトのスクリプト: $($config.Startup.DefaultScript)"
```

監査またはスクリプト作成の目的で、特定の構成プロパティを抽出して表示します。

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "設定されたカスタム キャッシュ パス: $($config.Cache.Path)"
} else {
    Write-Host "デフォルトのキャッシュパスの使用"
}

Write-Host "有効なキャッシュ パス: $($config.Cache.EffectivePath)"
```

カスタム キャッシュ パスが構成されているか、モジュールのデフォルトを使用しているかを決定します。

### EXAMPLE 8

```powershell
$config = Get-ColorScriptConfiguration
$config | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

アーカイブまたは災害復旧のために、現在の構成を JSON ファイルにバックアップします。

### EXAMPLE 9

```powershell
# 現在の設定とデフォルト設定を比較する
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# -WhatIf 出力を確認して、何が変更されるかを確認します。
```

現在の構成とモジュールのデフォルトを比較して、カスタム設定を特定します。

### EXAMPLE 10

```powershell
# セッション間の構成変更を監視する
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

時間の経過に伴う変更を追跡するために、タイムスタンプ付きの構成のスナップショットを作成します。

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

次の構造を含むネストされたハッシュテーブルを返します。

- **Cache** (ハッシュテーブル): キャッシュ関連の設定
- **Path** (文字列): オプションの永続化キャッシュ パスのオーバーライド
- **EffectivePath** (文字列): モジュールによって現在使用されている解決されたキャッシュ ディレクトリ
- **Startup** (ハッシュテーブル): 起動時の動作設定
- **AutoShowOnImport** (ブール値): インポートで起動時の表示動作を呼び出すかどうか
- **ProfileAutoShow** (ブール値): 管理されたプロファイル ブロックのデフォルトの自動表示の選択
- **DefaultScript** (文字列): オプションの名前付き起動カラースクリプト

## NOTES

**モジュールの初期化**: ColorScripts-Enhanced モジュールがロードされると、構成は自動的に初期化されます。このコマンドレットは、現在のメモリ内の構成状態を取得します。

**変更なし**: このコマンドレットの呼び出しは読み取り専用であり、永続化された設定やアクティブな構成は変更されません。

**スレッド セーフティ**: 返されたハッシュテーブルは構成のコピーであるため、モジュールの内部状態に影響を与えることなく、同時アクセスや変更が安全になります。

**パフォーマンス**: 構成の取得は軽量であり、ディスクから読み取るのではなく、キャッシュされたメモリ内の構成を返すため、頻繁な呼び出しに適しています。

**構成ファイル形式**: 永続化された構成では、UTF-8 エンコーディングの JSON 形式が使用されます。手動編集はサポートされていますが、推奨されません。代わりに `Set-ColorScriptConfiguration` を使用してください。

### ベスト プラクティス

- 構成を一度クエリし、結果を再利用します
- 値を使用する前に構成を検証する
- 時間の経過とともに変化する構成を監視します
- マシン固有のパスやプライベート データを公開できない場所にのみバックアップを保存します。
- 構成に対して行われたカスタマイズを文書化します。
- 最初に非運用環境で構成の変更をテストします
- コンプライアンスのために構成監査ログを使用する

## RELATED LINKS

- [オンライン バージョン](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

