---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: ja
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

新しいカラースクリプト ファイルをスキャフォールディングし、必要に応じてメタデータ ガイダンスを出力します。

## SYNTAX

### Scaffold

```
New-ColorScript -Name <string> -OutputPath <string> [-h] [-Force] [-GenerateMetadataSnippet]
 [-Category <string[]>] [-Tag <string[]>] [-OpenInEditor] [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScript [-h] [-Name <string>] [-WhatIf] [-Confirm]
```

## ALIASES

このコマンドにはエイリアスがありません。

## DESCRIPTION

`New-ColorScript` コマンドレットは、文字列配列と各行を書き込むループを含む最小限のカラースクリプト スキャフォールドを作成します。ファイルはバイト オーダー マーク (BOM) のない UTF-8 としてエンコードされます。オプションのメタデータ ガイダンスは、生成されたファイルにコメントとして含めて、結果オブジェクトに返すことができます。

スキャフォールディングを行う場合は、`-Name` と `-OutputPath` の両方が必須です。 `-OutputPath` はディレクトリを識別します。このコマンドは、必要に応じてディレクトリを作成し、その中に `<Name>.ps1` を書き込みます。

スクリプト名は PowerShell の命名規則に従う必要があります。つまり、英数字で始まる必要があり、アンダースコアまたはハイフンを含めることができます。 `.ps1` 拡張子が指定されていない場合は、自動的に追加されます。 `-Force` スイッチが明示的に指定されていない限り、既存のファイルは誤って上書きされないように保護されます。

`-GenerateMetadataSnippet` と組み合わせると、コマンドレットは `ScriptMetadata.psd1` に追加するエントリを説明するガイダンスを返します。指定されたカテゴリとタグの値も、結果オブジェクトの配列として返されます。

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -OutputPath ./ColorScripts-Enhanced/Scripts -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

要求されたディレクトリに `my-spectrum.ps1` を作成し、ファイル パスとメタデータ ガイダンスを含むオブジェクトを返します。

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

カスタム ディレクトリ (`~/Dev/colorscripts`) の下にスキャフォールドを生成し、ディレクトリが存在しない場合は作成します。 `holiday-banner.ps1` という名前のファイルがその場所にすでに存在する場合、`-Force` スイッチによりそのファイルは上書きされます。

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -OutputPath ./ColorScripts-Enhanced/Scripts -Category 'Artistic' -Tag '80s','Neon' -GenerateMetadataSnippet
$result.MetadataGuidance | Set-Clipboard
```

新しいカラースクリプトを作成し、メタデータ ガイダンスをクリップボードにコピーして、`ScriptMetadata.psd1` に簡単に貼り付けることができます。

### EXAMPLE 4

```powershell
New-ColorScript -Name 'test-pattern' -OutputPath '.\temp' -WhatIf
```

実際にファイルを作成せずに、`.\temp` ディレクトリにテスト パターン スクリプトを作成すると何が起こるかを示します。実行前にパスと名前を検証するのに役立ちます。

### EXAMPLE 5

```powershell
# プロジェクトに複数のカラースクリプトを作成する
$scriptNames = @("company-logo", "team-banner", "status-display")
foreach ($name in $scriptNames) {
    New-ColorScript -Name $name -Category "Corporate" -Tag "Custom" -OutputPath ".\src" | Out-Null
}
Write-Host "$($scriptNames.Count) カラースクリプト テンプレートを作成しました"
```

プロジェクトに対して複数のカラースクリプト テンプレートをバッチで作成します。

### EXAMPLE 6

```powershell
# 作成してエディタですぐに開く
New-ColorScript -Name "my-art" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -GenerateMetadataSnippet -OpenInEditor
```

カラースクリプトを作成し、プラットフォームの登録済みハンドラーにそれを開くように要求します。

### EXAMPLE 7

```powershell
# 完全なワークフロー自動化による作成
$newScript = New-ColorScript -Name "interactive-demo" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Custom" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "作成者: $($newScript.Name)"
Write-Host "パス: $($newScript.Path)"
Write-Host "メタデータ ガイダンスをクリップボードに保存可能"
$newScript.MetadataGuidance | Set-Clipboard
```

クリップボードに自動的にコピーされたメタデータ ガイダンスを含むカラースクリプトを作成します。

### EXAMPLE 8

```powershell
# スクリプト名の規則を確認する
$validName = "123-start"
$invalidNames = @("-invalid", "_underscore-only", "contains space")
foreach ($name in $invalidNames) {
    try {
        New-ColorScript -Name $name -OutputPath ./temp -WhatIf -ErrorAction Stop
    } catch {
        Write-Warning "無効な名前「$name」: $_"
    }
}
```

カラースクリプトの命名規則の検証を示します。

### EXAMPLE 9

```powershell
# 配布用にポータブルな場所に作成する
$portableDir = Join-Path $PSScriptRoot "colorscripts"
$scaffold = New-ColorScript -Name "portable-art" -OutputPath $portableDir -GenerateMetadataSnippet
Write-Host "移植可能なカラースクリプトを次の場所に作成しました: $($scaffold.Path)"
```

現在のスクリプトを基準にして移植可能な場所にカラースクリプトを作成します。

### EXAMPLE 10

```powershell
# カテゴリとタグの検証を使用して作成する
$categories = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Category -Unique
if ("Retro" -in $categories) {
    New-ColorScript -Name "retro-party" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -Tag "Fun","Social"
} else {
    Write-Warning "レトロ カテゴリが見つかりません"
}
```

新しいカラースクリプトを作成する前に、カテゴリが存在することを検証します。

## PARAMETERS

### -Category

スキャフォールドとともに返され、メタデータ ガイダンスに含まれる 1 つ以上のカテゴリを指定します。値は、`ScriptMetadata.psd1` ですでに使用されているカテゴリと一致する必要があります。

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

### -Force

宛先ファイルが既に存在する場合は上書きします。このスイッチを使用しないと、ターゲットの場所に同じ名前のファイルが見つかった場合、コマンドレットはエラーで終了します。データの損失を避けるために注意して使用してください。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Overwrite
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GenerateMetadataSnippet

出力には、`ScriptMetadata.psd1` に新しいスクリプトを登録する方法を示すガイダンス スニペットが含まれています。スニペットは、`-Category` および `-Tag` パラメーターが指定されている場合、その値を使用します。これは、モジュール内のすべてのカラースクリプトにわたって一貫したメタデータを維持する場合に特に役立ちます。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Help
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

新しいカラースクリプトの名前を指定します。名前は英数字で始める必要があり、アンダースコアまたはハイフンを含めることができます。 `.ps1` 拡張子が含まれていない場合は、自動的に追加されます。この名前はファイル名として使用され、スクリプトの内容またはテーマを説明するものにする必要があります。

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Help
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OpenInEditor

作成が成功すると、環境によって設定されたコマンドを使用して、生成されたカラースクリプトを開きます。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputPath

必須の出力先ディレクトリを指定します。このコマンドは、そのディレクトリ内に <Name>.ps1 を作成します。

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Destination
- Path
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

カラースクリプトの 1 つ以上のメタデータ タグを指定します。タグは、主要なカテゴリを超えた追加の分類を提供し、フィルタリングや検索に役立ちます。一般的なタグには、「ミニマル」、「カラフル」、「アニメーション」などのテーマ記述子、「マトリックス」、「ASCII」などのテクノロジー参照、または「ホリデー」、「シーズン」などのコンテキスト マーカーが含まれます。複数のタグをカンマ区切りの配列として指定できます。

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

実際にアクションを実行せずにコマンドレットを実行した場合に何が起こるかを示します。作成されるファイル パスと実行される検証チェックが表示されます。このスイッチが指定されている場合、コマンドレットはファイルやディレクトリを作成しません。

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
詳細については、次を参照してください:
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216)。

## INPUTS

### None

オブジェクトをこのコマンドレットにパイプすることはできません。

## OUTPUTS

### System.Management.Automation.PSCustomObject

コマンドレットは、次のプロパティを持つカスタム オブジェクトを返します。

- **Name**: `.ps1` 拡張子を除いたカラースクリプト名
- **Path**: 生成されたファイルへのフルパス
- **Categories**: 指定されたカテゴリ値の配列 (存在する場合)
- **Tags**: 指定されたタグ値の配列 (存在する場合)
- **MetadataGuidance**: メタデータ スニペット テキスト (-GenerateMetadataSnippet が使用されている場合のみ)

## NOTES

**エンコーディング**: スキャフォールドはバイト オーダー マーク (BOM) なしの UTF-8 エンコーディングで書かれており、さまざまなプラットフォームやエディタ間での互換性が確保されています。

**テンプレートの構造**: 生成されたテンプレートには次のものが含まれます。

- 足場のコメント
- アートの文字列配列プレースホルダー
- 各行を`Write-Host`で書き込むループ

**メタデータの統合**: コマンドレットはメタデータ ガイダンスを生成できますが、スクリプトをモジュールの検出および分類システムに完全に統合するには、スニペットを手動で `ScriptMetadata.psd1` に追加する必要があります。

**開発ワークフロー**:

1. `New-ColorScript` を使用して足場を作成します
2. 生成された .ps1 ファイルを編集して ANSI アートを追加します
3. メタデータ ガイダンスが生成された場合は、それを `ScriptMetadata.psd1` にコピーします。
4. `Show-ColorScript -Name <your-script-name>` を使用してスクリプトをテストします。

**ベストプラクティス**:

- スクリプトのテーマを明確に示す、ハイフンでつながれたわかりやすい名前を選択してください
- 既存のスクリプトと一致する一貫したカテゴリ値を使用します。
- 複数のタグを適用して発見しやすさを向上させます
- 互換性を確保するために、さまざまな端末環境でスクリプトをテストします。

## RELATED LINKS

- [オンライン バージョン](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)

