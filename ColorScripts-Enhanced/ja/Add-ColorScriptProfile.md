---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

PowerShell プロファイル ファイル内のマネージド ColorScripts-Enhanced スタートアップ ブロックを追加または更新します。

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

このコマンドにはエイリアスがありません。

## DESCRIPTION

選択した PowerShell プロファイルにマネージド スタートアップ ブロックを追加します。このブロックは ColorScripts-Enhanced をインポートし、インポート後に `Show-ColorScript` を呼び出すことができます。 `-SkipStartupScript` はインポート専用ブロックを書き込みます。

`-ProfilePath` が省略された場合、コマンドは `$PROFILE.CurrentUserAllHosts` を優先し、それ以外の場合は最初に定義されたプロファイル パスを使用します。プロファイル ファイルと不足している親ディレクトリは、必要に応じて作成されます。

既存のマネージド ブロックまたは従来の ColorScripts-Enhanced ブロックは、複製されるのではなく置き換えられます。プロファイルがすでに管理ブロックの外にモジュールをインポートしている場合、`-Force` が指定されない限り、コマンドはモジュールを変更しないままにします。 `-Force` では、無関係なプロファイル コンテンツを保持しながら、認識されたモジュール コンテンツを置き換えることができます。

生成された起動動作は、明示的なパラメーターと永続的な構成から解決されます。 `-AutoShow` は表示を明示的に有効にし、`-DefaultStartupScript` は名前付きスクリプトを選択します。ポケモンの追加は直接指定することも、対話型プロンプトとその文書化されたオーバーライドを通じて解決することもできます。 `-SkipCacheBuild` が使用されない限り、コマンドはプロファイルの更新後にポリシーで選択されたキャッシュ エントリを事前にウォームアップできます。

## EXAMPLES

### EXAMPLE 1

すべてのホストの現在のユーザーのプロファイルに追加します (デフォルトの動作)。

```powershell
Add-ColorScriptProfile
```

これにより、モジュールのインポートと `Show-ColorScript` 呼び出しの両方が `$PROFILE.CurrentUserAllHosts` に追加されます。

### EXAMPLE 2

起動スクリプトを使用せずに、現在のホストの現在のユーザーのプロファイルにのみ追加します。

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost -SkipStartupScript
```

これにより、インポート専用の管理ブロックが現在のホスト プロファイルに追加されます。

### EXAMPLE 3

環境変数展開を使用してカスタム プロファイル パスに追加します。

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

これは、標準の PowerShell プロファイルの場所以外の特定のプロファイル ファイルをターゲットとします。

### EXAMPLE 4

スニペットがすでに存在する場合でも、強制的に再追加します。

```powershell
Add-ColorScriptProfile -Force
```

これにより、無関係なプロファイル行を維持しながら、認識された ColorScripts-Enhanced プロファイル コンテンツが更新されます。

### EXAMPLE 5

新しいマシンでのセットアップ - 必要に応じてプロファイルを作成し、すべてのホストに ColorScript を追加します。

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts -Confirm:$false
Write-Host "プロファイルが設定されました!端末を再起動すると、起動時にカラースクリプトが表示されます。"
```

### EXAMPLE 6

起動時の表示に特定のカラースクリプトを追加します。

```powershell
Add-ColorScriptProfile -DefaultStartupScript mandelbrot-zoom -AutoShow
```

### EXAMPLE 7

プロファイルが正しく追加されたことを確認します。

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

現在のホストまたはすべてのホストのプロファイルを明示的にターゲットにします。

```powershell
# Windows ターミナルまたは ConEmu のみ
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost

# すべての PowerShell ホスト (ISE、VSCode、コンソール) の場合
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts
```

### EXAMPLE 9

相対パスとチルダ展開を使用する:

```powershell
# ホームディレクトリにチルダ展開を使用する
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# 現在のディレクトリの相対パスを使用する
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

カスタム ロジックを追加して、毎日異なるカラースクリプトを表示します。

```powershell
Add-ColorScriptProfile -SkipStartupScript
# 次に、これを手動で $PROFILE に追加します。
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

### EXAMPLE 11

スタートアップアートを表示するときにポケモンスクリプトを自動的にスキップします。

```powershell
Add-ColorScriptProfile -IncludePokemon
```

これにより、`Show-ColorScript -IncludePokemon` (保護用の try/catch ブロックでラップされたもの) がプロファイルに追加されるため、起動アートにポケモン スクリプトが含まれる可能性があります。

## PARAMETERS

### -AutoShow

モジュールのインポート後に管理プロファイル ブロックがカラースクリプトを表示するかどうかを制御します。

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

### -DefaultStartupScript

起動表示用に管理プロファイル ブロックに書き込まれるカラースクリプト名を指定します。

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

関連のないプロファイル行を保持しながら、認識された ColorScripts-Enhanced のプロファイル内容を更新します。管理対象ブロックを意図的に重複して追加することはありません。

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

このコマンドレットのヘルプ情報を表示します。 `Get-Help Add-ColorScriptProfile` を使用するのと同じです。

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

`-IncludePokemon` を生成される `Show-ColorScript` 呼び出しに追加し、ポケモンのカラースクリプトが存在する場合に起動時の候補へ含めます。`-SkipStartupScript` を使用した場合は無視されます。

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

ポケモンを含めるプロンプトに事前に答えてください。 Y/はいまたはN/いいえを受け入れます。環境変数も尊重します
`COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE` とグローバル変数
`$Global:ColorScriptsEnhancedPokemonPromptResponse`。

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

更新する PowerShell プロファイル ファイルを指定します。パス エイリアスも受け入れられます。

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

オプションのキャッシュの事前ウォームを抑制します。プリウォームは、`ProfileAutoShow` が解決された場合にのみ試行されます。
設定が有効になっている、キャッシュ構築が無効になっていない、ターゲット プロファイルが範囲外にある
システムの一時ディレクトリに保存されており、操作は `ShouldProcess` によって承認されています。このコマンドは、
環境変数 `COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` とグローバル変数
`$Global:ColorScriptsEnhancedSkipCacheBuild`。

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

起動時にポケモンのカラースクリプトを含めるかどうかを尋ねる対話型プロンプトをスキップします。

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

プロファイルへの `Show-ColorScript` の追加をスキップします。 `Import-Module ColorScripts-Enhanced` 行のみが追加されます。カラースクリプトが表示されるタイミングを手動で制御する場合は、これを使用します。

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

コマンドレットを実行すると何が起こるかを示します。コマンドレットは実行されません。

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

### System.Object

次のプロパティを持つカスタム オブジェクトを返します。

- **Path** (文字列): 選択したプロファイル ファイルへのフル パス
- **Changed** (ブール値): プロファイルが実際に変更されたかどうか
- **Message** (文字列): 操作結果を説明するステータス メッセージ
- **IncludePokemon** (ブール値): 起動時にポケモンを含める選択肢
- **CacheBuilt** (ブール値): オプションのキャッシュのウォームアップが完了したかどうか

## NOTES

**著者:** ニック

**モジュール:** ColorScripts-Enhanced

**必要なもの:** PowerShell 5.1 以降

プロファイル ファイルが存在しない場合は、必要な親ディレクトリも含めて自動的に作成されます。このコマンドは、ユーザーが指定したファイル パスを管理します。個別のスコープ セレクターは公開されません。

## RELATED LINKS

- [オンライン バージョン](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)

