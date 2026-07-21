---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: ru
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

Pre-build or refresh colorscript cache files for faster rendering.

## SYNTAX

### Selection (Default)

```
New-ColorScriptCache [-Name <string[]>] [-Force] [-PassThru] [-Category <string[]>]
 [-Tag <string[]>] [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon]
 [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Category <string[]>] [-Tag <string[]>]
 [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon] [-WhatIf] [-Confirm]
```

## ALIASES

- `Build-ColorScriptCache`
- `Update-ColorScriptCache`

## DESCRIPTION

`New-ColorScriptCache` executes computationally expensive colorscripts in a background PowerShell instance and saves the rendered output using UTF-8 encoding (without BOM). Static output scripts execute directly and never create cache files. You can also use the alias `Update-ColorScriptCache` to invoke this cmdlet.

You can target scripts by name (wildcards supported), category, or tag. With no selection parameters, the cmdlet resolves `CachePolicy.psd1` entries directly without enumerating the full collection. Unlisted scripts return `SkippedNotRequired` only when selected explicitly.

By default, the cmdlet displays a concise summary of the caching operation. Use `-PassThru` to return detailed result objects for each script, which you can inspect programmatically for status, standard output, and error streams.

Combine `-Quiet` to suppress the summary or `-NoAnsiOutput` to emit plain-text messages when ANSI color codes are not desired.

The cmdlet intelligently skips scripts whose cache files are already up-to-date unless you specify `-Force`. `-Force` rebuilds eligible cache entries but never overrides the cache policy.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Resolve and warm only the policy-selected computational renderers without enumerating every script that ships with the module. This is the default behavior when no parameters are specified.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name Galaxy, 'rose-*'
```

Evaluate a mix of exact and wildcard matches. Only matches included in `CachePolicy.psd1` are built; other matches report `SkippedNotRequired` with `-PassThru`.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name Galaxy -Force -PassThru | Format-List
```

Force a rebuild of the 'Galaxy' cache even if it's up-to-date, and examine the detailed result object.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Animation' -PassThru
```

Evaluate scripts in the 'Animation' category, cache eligible renderers, and return detailed results for every match.

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

Rebuild eligible caches for scripts tagged with either 'geometric' or 'colorful', forcing regeneration even if caches are current.

### EXAMPLE 6

```powershell
Get-ColorScriptList | Where-Object Category -eq 'Classic' | New-ColorScriptCache -PassThru
```

Pipeline example: evaluate all classic scripts, cache any policy-selected renderers, and return a result for every match.

### EXAMPLE 7

```powershell
# Check cache statistics after building
$before = @(Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter "*.cache" -ErrorAction SilentlyContinue).Count
New-ColorScriptCache
$after = @(Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter "*.cache").Count
Write-Host "Cached scripts: $before -> $after"
```

Measures the cache growth by counting cache files before and after the operation.

### EXAMPLE 8

```powershell
# Build cache for frequently used scripts only
$frequentScripts = @('bars', 'arch', 'Galaxy', 'aurora-waves', 'galaxy-spiral')
New-ColorScriptCache -Name $frequentScripts -PassThru | Format-Table Name, Status, ExitCode
```

Caches only the most frequently accessed scripts for faster performance in production.

### EXAMPLE 9

```powershell
# Monitor cache building with progress tracking
$scripts = Get-ColorScriptList -AsObject
$total = $scripts.Count
$current = 0
$scripts | ForEach-Object {
    $current++
    Write-Progress -Activity "Building cache" -Status $_.Name -PercentComplete (($current / $total) * 100)
    New-ColorScriptCache -Name $_.Name | Out-Null
}
Write-Progress -Activity "Building cache" -Completed
```

Provides visual progress feedback while building the cache.

### EXAMPLE 10

```powershell
# Schedule cache rebuild on module load
# Add to PowerShell profile:
Import-Module ColorScripts-Enhanced
if ((Get-Date).Day % 7 -eq 0) {  # Weekly rebuild
    New-ColorScriptCache -Force | Out-Null
}
```

Automatically rebuilds cache weekly when the module loads.

### EXAMPLE 11

```powershell
# Cache specific category for deployment
New-ColorScriptCache -Category 'Recommended' -Force -PassThru |
    Select-Object Name, Status |
    Export-Csv "./cache-deployment.csv"
```

Caches recommended scripts and exports the results to a deployment manifest.

### EXAMPLE 12

```powershell
# Verify cache was built successfully
New-ColorScriptCache -Name "Galaxy" -Force -PassThru |
    Where-Object { $_.ExitCode -ne 0 } |
    Select-Object Name, StdErr
```

Identifies any caching failures by filtering for non-zero exit codes.

### EXAMPLE 13

```powershell
# Cache eligible animated scripts
New-ColorScriptCache -Tag Animated -PassThru |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

Caches eligible scripts tagged as animated and shows the count of updated cache entries.

## PARAMETERS

### -All

Resolve every cache-policy entry directly. Only policy-selected scripts are processed; the full colorscript inventory is not enumerated.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

Limit the selection to scripts that belong to the specified category (case-insensitive). Multiple values are treated as an OR filter, meaning scripts matching any of the specified categories will be cached.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Prompts you for confirmation before running the cmdlet. Useful when caching a large number of scripts or when using `-Force` to prevent accidental cache regeneration.

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

Rebuild eligible cache files even when the existing cache is newer than the script source. This does not override `CachePolicy.psd1`.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Показывает подробную справку по команде, не выполняя операцию.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

Включает все скрипты Pokémon (обычные и shiny) при построении кеша. По умолчанию скрипты Pokémon пропускаются; используйте `-IncludePokemon`, чтобы включить их. Примечание: этот параметр заменяет старый `-ExcludePokemon` — логика была инвертирована при рефакторинге (теперь opt-in).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

One or more colorscript names to evaluate. Supports wildcard patterns (for example, `aurora-*` and `*-wave`). When this parameter and all filters are omitted, only `CachePolicy.psd1` entries are resolved and evaluated.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAnsiOutput

Disable ANSI color in the summary output so that plain text is produced instead.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- NoColor
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Parallel

Builds eligible cache entries concurrently. Unsupported hosts fall back to sequential execution.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Return detailed result objects for each cache operation. By default, only a summary is displayed. The result objects include properties such as Name, Status, CacheFile, ExitCode, StdOut, and StdErr, allowing for programmatic inspection of the caching process.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Suppress the summary message at the end of the cache build.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Limit the selection to scripts containing the specified metadata tags (case-insensitive). Multiple values are treated as an OR filter, caching scripts that match any of the specified tags.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ThrottleLimit

Sets the maximum number of concurrent cache workers. Threads is an alias for this parameter.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Threads
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Shows what would happen if the cmdlet runs without actually performing the caching operations. Useful for previewing which scripts would be cached before committing to the operation.

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

### System.String

You can pipe script names to this cmdlet. Each string is treated as a potential script name and supports wildcard matching.

### System.String[]

You can pipe an array of script names or metadata records with a `Name` property to this cmdlet for batch processing.

## OUTPUTS

### System.Object

When `-PassThru` is specified, returns a custom object for each processed script containing the following properties:

- **Name**: The colorscript name
- **Status**: Success, Skipped, or Failed
- **CacheFile**: Full path to the generated cache file
- **ExitCode**: The exit code from the script execution (0 indicates success)
- **StdOut**: Standard output captured during script execution
- **StdErr**: Standard error output captured during script execution

Without `-PassThru`, displays a concise summary table to the console showing the number of scripts cached, skipped, and failed.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced

**Aliases:** This cmdlet can also be called using the alias `Update-ColorScriptCache`, which is useful for scripts that refresh existing caches.

Cache files are stored in the directory exposed by the module's `CacheDir` variable (typically within the module's data directory). A successful build sets the cache file's timestamp to match the script's last write time, enabling subsequent runs to skip unchanged scripts efficiently.

The cmdlet executes each script in an isolated background PowerShell process to capture its output without affecting the current session. This ensures accurate caching of the exact console output that would be displayed when running the script directly.

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)

