---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Show-ColorScript

## SYNOPSIS

Displays a colorscript with automatic caching.

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <String[]>] [-Tag <String[]>] [-PassThru]
 [-ReturnText] [<CommonParameters>]
```

### Named

```
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>] [-PassThru]
 [-ReturnText] [<CommonParameters>]
```

### List

```
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>] [-ReturnText]
 [<CommonParameters>]
```

### All

```
Show-ColorScript [-All] [-WaitForInput] [-NoCache] [-Category <String[]>] [-Tag <String[]>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Shows a beautiful ANSI colorscript in your terminal. If no name is specified, displays a random script. Uses intelligent caching for 6-19x faster performance.

The first time a colorscript is displayed, it executes normally and the output is cached. Subsequent displays use the cached output for near-instant rendering. Cache is automatically invalidated when the source script is modified.

When multiple scripts match a wildcard pattern, the first match in alphabetical order is displayed. Use `-PassThru` to inspect the selected record when needed.

Use `-All` to cycle through all colorscripts in alphabetical order. Combine with `-WaitForInput` to pause between each script and press spacebar to continue.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Displays a random colorscript with caching enabled.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Displays the specified colorscript.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Displays the first (alphabetically) colorscript that matches the wildcard pattern.

### EXAMPLE 4

```powershell
scs hearts
```

Uses the alias to display the hearts colorscript.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Lists all available colorscripts.

### EXAMPLE 6

```powershell
Show-ColorScript -Name arch -NoCache
```

Displays the arch colorscript without using cache.

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

Display a random nature-themed script and capture the metadata for further use.

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

Emit the rendered colorscript as plain text so it can be redirected or saved.

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

Displays all colorscripts in alphabetical order continuously with a short delay between each.

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

Displays all colorscripts one at a time, waiting for spacebar press between each. Press 'q' to quit early.

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

Cycles through all nature-themed colorscripts with manual progression using spacebar.

## PARAMETERS

### -All

Cycle through all available colorscripts in alphabetical order. Use with `-WaitForInput` to pause between each script.

```yaml
Type: SwitchParameter
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
HelpMessage: ''
```

### -Category

Filter the available script set by one or more categories before selection occurs.

```yaml
Type: System.String[]
DefaultValue: None
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

### -List

Lists all available colorscripts instead of displaying one.
Lists all available colorscripts.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: List
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

The name of the colorscript to display (without .ps1 extension).
The name of the colorscript to display (without .ps1 extension).
Supports wildcards for partial matches.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Named
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoCache

Bypass cache and execute script directly. Useful for testing or when cache is corrupted.
Bypass cache and execute script directly.

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

### -PassThru

Return the selected script metadata object in addition to displaying output.
Return the selected script metadata in addition to rendering output.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Named
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Random

Explicitly request a random colorscript (default behavior).
Display a random colorscript (default behavior).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ReturnText

Emit the rendered colorscript as pipeline output instead of writing directly to the console. This is useful when you want to capture the rendered text or redirect it to another command.
Emit the rendered colorscript as pipeline output instead of writing directly to the console.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- AsString
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

### -Tag

Filter scripts by metadata tags (case-insensitive) before selection occurs.
Filter the available script set by tag metadata (case-insensitive).

```yaml
Type: System.String[]
DefaultValue: None
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

### -WaitForInput

When used with `-All`, pause after each colorscript and wait for spacebar to continue. Press 'q' to quit early.

```yaml
Type: SwitchParameter
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
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

You can pipe script names to Show-ColorScript.

## OUTPUTS

### System.Object

Returns the selected script record when `-PassThru` is specified. When `-ReturnText` is used, the rendered colorscript is emitted to the pipeline; otherwise it is written directly to the console.

## NOTES

Author: Nick
Module: ColorScripts-Enhanced
Requires: PowerShell 5.1 or later

The caching system provides 6-19x performance improvements for colorscripts.
Cache location: determined by the module (see `Get-Module ColorScripts-Enhanced` and inspect the `CacheDir` variable).

## RELATED LINKS

- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Build-ColorScriptCache](Build-ColorScriptCache.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
