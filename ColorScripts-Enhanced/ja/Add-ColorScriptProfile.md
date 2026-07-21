---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

PowerShell プロファイル ファイルに ColorScripts-Enhanced 統合を追加します。

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

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

### -AutoShow

Controls whether the managed profile block displays a colorscript after importing the module.

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

### -DefaultStartupScript

Specifies the colorscript name written to the managed profile block for startup display.

```yaml
Type: System.String
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

### -Force

Updates the managed profile block without removing unrelated profile content.

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

### -IncludePokemon

Allows Pokemon-themed scripts when the managed profile block displays a random colorscript.

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

### -PokemonPromptResponse

ポケモン プロンプトへの事前回答 (Y/Yes または N/No)。環境変数
`COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE` とグローバル変数
`$Global:ColorScriptsEnhancedPokemonPromptResponse` も参照します。

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

### -ProfilePath

Specifies the PowerShell profile file to update. The Path alias is also accepted.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Path
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

### -SkipCacheBuild

プロファイル追加時のキャッシュ事前構築を抑止します。環境変数
`COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` とグローバル変数
`$Global:ColorScriptsEnhancedSkipCacheBuild` を考慮します。プロファイル パスが Temp 配下の場
合、自動的にスキップされます。

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

### -SkipPokemonPrompt

起動時にポケモンを含めるかどうかのプロンプトをスキップします。

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

### -SkipStartupScript

Adds the module import but omits the startup Show-ColorScript invocation.

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

コマンドレットを実行した場合に何が起こるかを表示します。コマンドレットは実行されません。

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

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)
