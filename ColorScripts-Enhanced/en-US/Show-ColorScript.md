---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: en-US
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

Displays a colorscript with selective caching for expensive renderers.

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-ShowInfo] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

### Help

```
Show-ColorScript [-h] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Named

```
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-ShowInfo] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

### List

```
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### All

```
Show-ColorScript [-All] [-WaitForInput] [-NoClear] [-NoCache] [-Category <string[]>]
 [-Tag <string[]>] [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-ShowInfo]
 [-Quiet] [-NoAnsiOutput] [-ValidateCache]
```

## ALIASES

- `scs`

## DESCRIPTION

Renders beautiful ANSI colorscripts in your terminal with intelligent performance optimization. The cmdlet provides four primary modes of operation:

**Random Mode (Default):** Displays a randomly selected colorscript from the available collection. This is the default behavior when no parameters are specified.

**Named Mode:** Displays a specific colorscript by name. Supports wildcard patterns for flexible matching. When multiple scripts match a pattern, the first match in alphabetical order is selected.

**List Mode:** Displays a compact table containing colorscript names and primary categories. Use `Get-ColorScriptList -AsObject` for complete metadata records.

**All Mode:** Cycles through all available colorscripts in alphabetical order. Particularly useful for showcasing the entire collection or discovering new scripts.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Displays a random colorscript. Deterministic bundled scripts render in-process; eligible computational renderers can reuse validated cached output.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Displays the specified colorscript by exact name. The .ps1 extension is not required.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Displays the first colorscript (alphabetically) that matches the wildcard pattern "aurora-\*". Useful when you remember part of a script's name.

### EXAMPLE 4

```powershell
scs hearts
```

Uses the module's alias 'scs' for quick access to the hearts colorscript. Aliases provide convenient shortcuts for frequent use.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Lists available colorscripts by name and primary category. Helpful for quick discovery.

### EXAMPLE 6

```powershell
Show-ColorScript -Name Galaxy -NoCache
```

Displays the eligible Galaxy renderer without reading cached output, forcing a fresh isolated render. Useful when testing renderer changes or investigating cache corruption.

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

Displays a random colorscript that has either the "retro" or "geometric" tag. Multiple tag values use any-match semantics.

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Artistic,Abstract
```

Lists only colorscripts categorized as "Art" or "Abstract", helping you discover scripts within specific themes.

### EXAMPLE 14

```powershell
# Inspect cache eligibility and build status for a policy-selected renderer.
New-ColorScriptCache -Name Galaxy -Force -PassThru |
    Select-Object Name, Status, CacheFile
Show-ColorScript -Name Galaxy
```

Builds and inspects a cache entry for an eligible renderer without claiming a machine-independent performance multiplier.

### EXAMPLE 15

```powershell
# Set up daily rotation of different colorscripts
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

Displays a consistent but different colorscript each day based on the date.

### EXAMPLE 16

```powershell
# Export rendered colorscript to file for sharing
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Later, display the saved file
Get-Content "./aurora.ansi" -Raw | Write-Host
```

Saves a rendered colorscript to a file that can be displayed later or shared with others.

### EXAMPLE 17

```powershell
# Create a slideshow of geometric colorscripts
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

Automatically displays a sequence of geometric colorscripts with 3-second delays between each.

### EXAMPLE 18

```powershell
# Error handling example
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Script not found: $_"
    Show-ColorScript  # Fallback to random
}
```

Demonstrates error handling when requesting a script that doesn't exist.

### EXAMPLE 19

```powershell
# Build automation integration
if ($env:CI) {
    Show-ColorScript -Name "Galaxy" -NoCache
} else {
    Show-ColorScript  # Random display for interactive use
}
```

Shows how to conditionally display different colorscripts in CI/CD environments vs. interactive sessions.

### EXAMPLE 20

```powershell
# Scheduled task for terminal greeting
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

Demonstrates running a specific colorscript as part of scheduled task or startup automation.

### EXAMPLE 21

```powershell
Show-ColorScript -IncludePokemon
```

Demonstrates the deprecated compatibility switch. It is a silent no-op for one release because Pokémon and shiny-Pokémon scripts already participate in normal selection.

### EXAMPLE 22

```powershell
Show-ColorScript -Random -ExcludeCategory Pokemon,ShinyPokemon
```

Displays a random colorscript while excluding both Pokémon categories. Combine with `-Category` or `-Tag` to further refine the selection.

### EXAMPLE 23

```powershell
Show-ColorScript -Random -ShowInfo
```

Displays a random colorscript, then writes its script name and full path to the information stream. Use `-Quiet` to suppress the identification line.

## PARAMETERS

### -All

Cycle through all available colorscripts in alphabetical order. When specified alone, scripts are displayed continuously with a short automatic delay. Combine with `-WaitForInput` to manually control progression through the collection. This mode is ideal for showcasing the full library or discovering new favorites.

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
HelpMessage: ''
```

### -Category

Filter the available script collection by one or more categories before any selection or display occurs. Categories are typically broad themes like "Nature", "Abstract", "Art", "Retro", etc. Multiple categories can be specified as an array. This parameter works in conjunction with all modes (Random, Named, List, All) to narrow the working set.

```yaml
Type: System.String[]
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

### -ExcludeCategory

Exclude scripts from one or more categories before selection occurs. For example, use `-ExcludeCategory Pokemon,ShinyPokemon` to avoid all Pokémon scripts, or specify any other category combination. Works in all modes (Random, Named, List, All) and combines with `-Category` and `-Tag` filters.

```yaml
Type: System.String[]
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

Displays detailed help for this command without performing the operation.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- help
ParameterSets:
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

### -IncludePokemon

Deprecated compatibility switch. It is accepted as a silent no-op for one release because Pokémon and shiny-Pokémon colorscripts already participate in normal selection. Use `-ExcludeCategory Pokemon,ShinyPokemon` to opt out.

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

The name of the colorscript to display (without the .ps1 extension). Supports wildcard patterns (\* and ?) for flexible matching. When multiple scripts match a wildcard pattern, the first match in alphabetical order is selected and displayed. Use `-PassThru` to verify which script was chosen when using wildcards.

```yaml
Type: System.String
DefaultValue: ''
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

### -NoAnsiOutput

Disables ANSI styling in informational messages and rendered output for plain-text environments.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- NoColor
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

### -NoCache

Bypasses validated cache reads for policy-selected renderers and forces a fresh isolated render. This is useful when testing renderer changes or investigating cache corruption. Deterministic bundled scripts and unlisted or custom scripts already bypass the cache; bundled deterministic content still renders in-process.

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

### -NoClear

When used with `-All`, skip the automatic `Clear-Host` call between colorscripts so that each rendered script remains visible above the next one. This is particularly useful when you want to compare scripts side-by-side or capture the entire showcase in session transcripts.

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

### -Quiet

Suppresses informational messages while preserving command output and errors.

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

### -ShowInfo

After each selected colorscript is rendered, writes one concise information-stream line containing its script name and full path. `-Quiet` suppresses this line. `-ReturnText` does not include it, and `-PassThru` continues to return structured metadata.

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

### -Tag

Filter the available script collection by metadata tags (case-insensitive). Tags are more specific descriptors than categories, such as "geometric", "retro", "animated", "minimal", etc. Multiple tags can be specified as an array. Scripts matching any of the specified tags will be included in the working set before selection occurs.

```yaml
Type: System.String[]
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

### -ValidateCache

Refreshes the module-level cache metadata marker before rendering, including when the cache directory was already initialized in the current module session. It does not rebuild output cache entries or replace normal per-entry validation. Setting `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE` to `1`, `true`, or `yes` requests the same refresh during cache initialization.

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

### -WaitForInput

When used with `-All`, pause after displaying each colorscript and wait for user input before proceeding. Press the spacebar to advance to the next script in the sequence. Press 'q' to quit the sequence early and return to the prompt. This provides an interactive browsing experience through the entire collection.

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
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters:
For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

This cmdlet does not accept pipeline input. Pipe inventory records into `ForEach-Object` and call `Show-ColorScript -Name $_.Name` when composing a pipeline.

## OUTPUTS

### System.Object

When `-PassThru` is specified, returns the selected colorscript's metadata object containing properties like Name, Path, Category, Tags, and Description.

### System.String (2)

When `-ReturnText` is specified, emits the rendered colorscript as a string to the pipeline. This string contains all ANSI escape sequences for proper color rendering when displayed in a compatible terminal.

### None

In default operation (without `-PassThru` or `-ReturnText`), output is written directly to the console host and nothing is returned to the pipeline.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

