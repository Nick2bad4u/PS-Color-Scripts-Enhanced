---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ja/Add-ColorScriptProfile.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Add-ColorScriptProfile

## SYNOPSIS

PowerShell プロファイル ファイルに ColorScripts-Enhanced 統合を追加します。

## SYNTAX

```
Add-ColorScriptProfile [[-Scope] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

PowerShell プロファイルに ColorScripts-Enhanced のスタートアップ統合を自動的に追加します。このコマンドレットは、プロファイル ファイルを変更して ColorScripts-Enhanced モジュールをインポートし、オプションでセッション起動時にカラースクリプトを表示します。

このコマンドレットは、すべての標準 PowerShell プロファイル スコープをサポートします：

- CurrentUserCurrentHost: 現在のユーザーと現在のホストのプロファイル
- CurrentUserAllHosts: すべてのホストで現在のユーザーのプロファイル
- AllUsersCurrentHost: 現在のホスト上のすべてのユーザーのプロファイル (管理者権限が必要)
- AllUsersAllHosts: すべてのホストですべてのユーザーのプロファイル (管理者権限が必要)

実行すると、次のスニペットを追加します：

1. ColorScripts-Enhanced モジュールをインポート
2. オプションで起動時にランダムなカラースクリプトを表示
3. クイック アクセス用の便利なエイリアスを提供

統合は非侵襲的で設計されており、プロファイル ファイルを直接編集することで簡単に削除できます。

## EXAMPLES

### EXAMPLE 1

```powershell
Add-ColorScriptProfile
```

デフォルトのプロファイル (CurrentUserCurrentHost) に ColorScripts-Enhanced 統合を追加します。

### EXAMPLE 2

```powershell
Add-ColorScriptProfile -Scope CurrentUserAllHosts
```

現在のユーザーのすべての PowerShell ホストに適用されるプロファイルに統合を追加します。

### EXAMPLE 3

```powershell
Add-ColorScriptProfile -Scope AllUsersCurrentHost
```

現在のホスト上のすべてのユーザーのプロファイルに統合を追加します (管理者権限が必要です)。

### EXAMPLE 4

```powershell
Add-ColorScriptProfile -WhatIf
```

実際に適用せずにプロファイルにどのような変更が加えられるかを表示します。

### EXAMPLE 5

```powershell
Add-ColorScriptProfile -Confirm
```

プロファイルを変更する前に確認を求めます。

## PARAMETERS

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

### -Scope

変更するプロファイル スコープを指定します。有効な値は次のとおりです：

- CurrentUserCurrentHost (デフォルト)
- CurrentUserAllHosts
- AllUsersCurrentHost
- AllUsersAllHosts

```yaml
Type: System.String
DefaultValue: CurrentUserCurrentHost
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

コマンドレットを実行した場合に何が起こるかを表示します。コマンドレットは実行されません。

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

このコマンドレットは、共通パラメーター -Debug、-ErrorAction、-ErrorVariable、-InformationAction、-InformationVariable、-OutBuffer、-OutVariable、-PipelineVariable、-ProgressAction、-Verbose、-WarningAction、および -WarningVariable をサポートします。詳細については、[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216) を参照してください。

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

**プロファイル統合:**
このコマンドレットは、ColorScripts-Enhanced をインポートし、便利なアクセスを提供するスタートアップ スニペットを追加します。統合は軽量で非破壊的です。

**スコープの考慮事項:**

- CurrentUser スコープは、ユーザー プロファイル ディレクトリのファイルを変更します
- AllUsers スコープは管理者権限を必要とし、すべてのユーザーに影響します
- 変更は新しい PowerShell セッションで有効になります

**安全機能:**

- 重複を避けるために既存の統合を確認します
- 標準の PowerShell プロファイル メカニズムを使用します
- 安全な操作のための WhatIf および Confirm オプションを提供します

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Show-ColorScript](Show-ColorScript.md)
- [オンライン ドキュメント](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
