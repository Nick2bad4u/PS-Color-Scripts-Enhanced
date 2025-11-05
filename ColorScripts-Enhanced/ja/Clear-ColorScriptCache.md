---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ja/Clear-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Clear-ColorScriptCache

## SYNOPSIS

キャッシュされたカラースクリプトの出力ファイルをクリアします。

## SYNTAX

```
Clear-ColorScriptCache [[-Name] <string[]>] [-All] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

カラースクリプトのキャッシュされた出力ファイルを削除し、次回の表示時に新しく実行されるようにします。このコマンドレットは、個別のスクリプトまたは一括操作のためのターゲットキャッシュ管理を提供します。

キャッシュシステムは、レンダリングされたANSI出力を保存して、ほぼ瞬時の表示パフォーマンスを提供します。時間が経つにつれて、ソーススクリプトが変更された場合、キャッシュファイルが古くなる可能性があります。また、トラブルシューティングのためにキャッシュをクリアしたい場合もあります。

このコマンドレットを使用する状況：

- ソースカラースクリプトが変更された場合
- キャッシュの破損が疑われる場合
- 新しい実行を確実にしたい場合
- ディスク容量を解放したい場合

このコマンドレットは、ターゲットクリア（特定のスクリプト）と一括操作（すべてのキャッシュファイル）の両方をサポートします。

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -Name "spectrum"
```

"spectrum"という名前の特定のカラースクリプトのキャッシュをクリアします。

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -All
```

すべてのキャッシュされたカラースクリプトファイルをクリアします。

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name "aurora*", "geometric*"
```

指定されたワイルドカードパターンに一致するカラースクリプトのキャッシュをクリアします。

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Name aurora-waves -WhatIf
```

実際に削除せずに、どのキャッシュファイルがクリアされるかを表示します。

### EXAMPLE 5

```powershell
# Clear cache for all scripts in a category
Get-ColorScriptList -Category Nature -AsObject | ForEach-Object {
    Clear-ColorScriptCache -Name $_.Name
}
```

自然テーマのすべてのカラースクリプトのキャッシュをクリアします。

## PARAMETERS

### -All

すべてのキャッシュされたカラースクリプトファイルをクリアします。-Nameパラメータと一緒に使用できません。

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: All
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

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

### -Name

キャッシュからクリアするカラースクリプトの名前を指定します。パターンマッチングのためにワイルドカード（\*と?）をサポートします。

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
 - Name: Name
   Position: 0
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

このコマンドレットは、-Debug、-ErrorAction、-ErrorVariable、-InformationAction、-InformationVariable、-OutBuffer、-OutVariable、-PipelineVariable、-ProgressAction、-Verbose、-WarningAction、および -WarningVariable の共通パラメータをサポートします。詳細については、[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216) を参照してください。

## INPUTS

### None

このコマンドレットは、パイプラインからの入力を受信しません。

## OUTPUTS

### None

このコマンドレットは、パイプラインに出力を返しません。

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

**Cache Location:**
キャッシュファイルは、モジュール管理のディレクトリに保存されます。モジュールディレクトリを見つけるには `(Get-Module ColorScripts-Enhanced).ModuleBase` を使用し、cacheサブディレクトリを探してください。

**When to Clear Cache:**

- ソースカラースクリプトファイルを変更した後
- 表示の問題をトラブルシューティングする場合
- スクリプトの新しい実行を確実にする場合
- パフォーマンスベンチマークの前

**Performance Impact:**
キャッシュをクリアすると、次回の表示時にスクリプトが通常実行され、キャッシュされた実行よりも時間がかかる可能性があります。キャッシュは後続の表示で自動的に再構築されます。

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
