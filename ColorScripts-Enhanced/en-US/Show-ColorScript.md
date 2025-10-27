---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/en-US/Show-ColorScript.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Show-ColorScript

## SYNOPSIS

Displays a colorscript with automatic caching for enhanced performance.

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

## DESCRIPTION

Renders beautiful ANSI colorscripts in your terminal with intelligent performance optimization. The cmdlet provides four primary modes of operation:

**Random Mode (Default):** Displays a randomly selected colorscript from the available collection. This is the default behavior when no parameters are specified.

**Named Mode:** Displays a specific colorscript by name. Supports wildcard patterns for flexible matching. When multiple scripts match a pattern, the first match in alphabetical order is selected.

**List Mode:** Displays a formatted list of all available colorscripts with their metadata, including name, category, tags, and descriptions.

**All Mode:** Cycles through all available colorscripts in alphabetical order. Particularly useful for showcasing the entire collection or discovering new scripts.

**Performance Features:**
The caching system provides 6-19x performance improvements. On first execution, a colorscript runs normally and its output is cached. Subsequent displays use the cached output for near-instant rendering. The cache is automatically invalidated when source scripts are modified, ensuring output accuracy.

**Filtering Capabilities:**
Filter scripts by category or tags before selection occurs. This applies across all modes, allowing you to work with subsets of the collection (e.g., only nature-themed scripts or scripts tagged as "retro").

**Output Options:**
By default, colorscripts are written directly to the console for immediate visual display. Use `-ReturnText` to emit the rendered output to the pipeline for capture, redirection, or further processing. Use `-PassThru` to receive the script's metadata object for programmatic use.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Displays a random colorscript with caching enabled. This is the quickest way to add visual flair to your terminal session.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Displays the specified colorscript by exact name. The .ps1 extension is not required.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Displays the first colorscript (alphabetically) that matches the wildcard pattern "aurora-*". Useful when you remember part of a script's name.

### EXAMPLE 4

```powershell
scs hearts
```

Uses the module's alias 'scs' for quick access to the hearts colorscript. Aliases provide convenient shortcuts for frequent use.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Lists all available colorscripts with their metadata in a formatted table. Helpful for discovering available scripts and their attributes.

### EXAMPLE 6

```powershell
Show-ColorScript -Name arch -NoCache
```

Displays the arch colorscript without using cache, forcing fresh execution. Useful during development or when troubleshooting cache issues.

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

Displays a random nature-themed script and captures its metadata object for further inspection or processing.

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

Renders the colorscript and saves the output to a text file. The rendered ANSI codes are preserved, allowing the file to be displayed later with proper coloring.

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

Displays all colorscripts in alphabetical order with a brief automatic delay between each. Perfect for a visual showcase of the entire collection.

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

Displays all colorscripts one at a time, pausing after each. Press spacebar to advance to the next script, or press 'q' to quit the sequence early.

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

Cycles through all nature-themed colorscripts with manual progression. Combines filtering with interactive browsing for a curated experience.

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

Displays a random colorscript that has both "retro" and "geometric" tags. Tag filtering enables precise subset selection.

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Art,Abstract
```

Lists only colorscripts categorized as "Art" or "Abstract", helping you discover scripts within specific themes.

## PARAMETERS

### -All

Cycle through all available colorscripts in alphabetical order. When specified alone, scripts are displayed continuously with a short automatic delay. Combine with `-WaitForInput` to manually control progression through the collection. This mode is ideal for showcasing the full library or discovering new favorites.

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

Filter the available script collection by one or more categories before any selection or display occurs. Categories are typically broad themes like "Nature", "Abstract", "Art", "Retro", etc. Multiple categories can be specified as an array. This parameter works in conjunction with all modes (Random, Named, List, All) to narrow the working set.

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

Display a formatted list of all available colorscripts with their associated metadata. The output includes script name, category, tags, and description. This is useful for exploring available options and understanding the collection's organization. Can be combined with `-Category` or `-Tag` to list only filtered subsets.

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

The name of the colorscript to display (without the .ps1 extension). Supports wildcard patterns (* and ?) for flexible matching. When multiple scripts match a wildcard pattern, the first match in alphabetical order is selected and displayed. Use `-PassThru` to verify which script was chosen when using wildcards.

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

Bypass the caching system and execute the colorscript directly. This forces fresh execution and can be useful when testing script modifications, debugging, or when cache corruption is suspected. Without this switch, cached output is used when available for optimal performance.

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

Return the selected colorscript's metadata object to the pipeline in addition to displaying the colorscript. The metadata object contains properties like Name, Path, Category, Tags, and Description. This enables programmatic access to script information for filtering, logging, or further processing while still rendering the visual output.

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

Explicitly request a random colorscript selection. This is the default behavior when no name is specified, so this switch is primarily useful for clarity in scripts or when you want to be explicit about the selection mode. Can be combined with `-Category` or `-Tag` to randomize within a filtered subset.

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

Emit the rendered colorscript as a string to the PowerShell pipeline instead of writing directly to the console host. This allows the output to be captured in a variable, redirected to a file, or piped to other commands. The output retains all ANSI escape sequences, so it will display with proper colors when later written to a compatible terminal.

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

Filter the available script collection by metadata tags (case-insensitive). Tags are more specific descriptors than categories, such as "geometric", "retro", "animated", "minimal", etc. Multiple tags can be specified as an array. Scripts matching any of the specified tags will be included in the working set before selection occurs.

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

When used with `-All`, pause after displaying each colorscript and wait for user input before proceeding. Press the spacebar to advance to the next script in the sequence. Press 'q' to quit the sequence early and return to the prompt. This provides an interactive browsing experience through the entire collection.

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

You can pipe colorscript names to Show-ColorScript. This enables pipeline-based workflows where script names are generated or filtered by other commands.

## OUTPUTS

### System.Object

When `-PassThru` is specified, returns the selected colorscript's metadata object containing properties like Name, Path, Category, Tags, and Description.

### System.String

When `-ReturnText` is specified, emits the rendered colorscript as a string to the pipeline. This string contains all ANSI escape sequences for proper color rendering when displayed in a compatible terminal.

### None

In default operation (without `-PassThru` or `-ReturnText`), output is written directly to the console host and nothing is returned to the pipeline.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

**Performance:**
The intelligent caching system provides 6-19x performance improvements over direct execution. Cache files are stored in a module-managed directory and are automatically invalidated when source scripts are modified, ensuring accuracy.

**Cache Management:**
- Cache location: Use `(Get-Module ColorScripts-Enhanced).ModuleBase` and look for the cache directory
- Clear cache: Use `Clear-ColorScriptCache` to rebuild from scratch
- Rebuild cache: Use `Build-ColorScriptCache` to pre-populate cache for all scripts
- Inspect cache: Cache files are plain text and can be viewed directly

**Tips:**
- Add `Show-ColorScript -Random` to your PowerShell profile for a colorful greeting on each session start
- Use the module alias `scs` for quick access: `scs -Random`
- Combine category and tag filters for precise selection
- Use `-List` to discover new scripts and learn about their themes
- The `-All -WaitForInput` combination is perfect for presenting the collection to others

**Compatibility:**
Colorscripts use ANSI escape sequences and display best in terminals with full color support, such as Windows Terminal, ConEmu, or modern Unix terminals.

## RELATED LINKS

- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Build-ColorScriptCache](Build-ColorScriptCache.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
