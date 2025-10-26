---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Clear-ColorScriptCache

## SYNOPSIS

Remove cached colorscript output files.

## SYNTAX

### All

```
Clear-ColorScriptCache [-All] [-Path <String>] [-DryRun] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Named

```
Clear-ColorScriptCache [-Name <String[]>] [-Path <String>] [-DryRun] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### __AllParameterSets

```
Clear-ColorScriptCache [[-Name] <string[]>] [[-Path] <string>] [[-Category] <string[]>]
 [[-Tag] <string[]>] [-All] [-DryRun] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

`Clear-ColorScriptCache` deletes cached output either selectively (`-Name`) or wholesale (`-All`). Wildcard patterns are supported and unmatched names report a `Missing` status in the results. Use `-DryRun` to preview the actions without touching the filesystem, or `-Path` to target an alternate cache directory (useful for CI or custom cache roots).

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

Remove every cache file without prompting.

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

Preview which aurora-themed caches would be removed.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name bars -Path $env:TEMP -Confirm:$false
```

Clean a custom cache directory (for example when using `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`).

## PARAMETERS

### -All

Remove every cache file in the target directory.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -Category

Filter the target scripts by category before evaluating cache entries.

```yaml
Type: System.String[]
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

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: True
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

### -DryRun

Emit the actions that would be taken without deleting any files.
Preview removal actions without deleting files.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -Name

Script names (wildcards supported) whose caches should be cleared. Mutually exclusive with `-All`.
Names or wildcard patterns identifying cache files to remove.
Accepts pipeline input and property binding.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Path

Custom cache directory to operate on. Defaults to the module's cache path.
Alternate cache directory to operate against.

```yaml
Type: System.String
DefaultValue: None
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

### -Tag

Filter the target scripts by metadata tag before evaluating cache entries.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.
Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### System.String

You can pipe script names or objects with a `Name` property to this cmdlet.

### System.String[]

{{ Fill in the Description }}

## OUTPUTS

### System.Object

Returns status records for each processed cache file, including the `Status`, `CacheFile`, and message text.

## NOTES

Author: Nick
Module: ColorScripts-Enhanced

Cache files are regenerated automatically the next time `Show-ColorScript` runs. The default cache path is exposed via the module's `CacheDir` variable.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Build-ColorScriptCache](Build-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
