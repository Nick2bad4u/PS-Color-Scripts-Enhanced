---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: en-US
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
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

`New-ColorScriptCache` renders policy-selected computational colorscripts and saves their output as UTF-8 without BOM. Eligible bundled renderers use the module's isolated execution path; parallel workers are available on PowerShell 7+. Deterministic bundled scripts render in-process and never create cache files. The aliases are `Update-ColorScriptCache` and `Build-ColorScriptCache`.

You can target scripts by name (wildcards supported), category, or tag. When no parameters are specified, the cmdlet resolves the names in `CachePolicy.psd1` directly instead of enumerating the full collection. Exact bundled names also use a direct file lookup. Wildcard, category, and tag requests enumerate only when their matching semantics require it. Explicit unlisted scripts are returned with the `SkippedNotRequired` status when `-PassThru` is used, and any obsolete cache files for those scripts are removed.

By default, the cmdlet displays progress plus a concise summary of the caching operation and the effective cache directory. Use `-PassThru` to return detailed result objects for each script, which you can inspect programmatically for status, standard output, and error streams. Combine `-Quiet` to suppress progress and the summary entirely, or `-NoAnsiOutput` to emit plain-text summaries without ANSI color codes for environments that do not support them.

The cmdlet intelligently skips scripts whose cache files are already up-to-date unless you specify the `-Force` parameter. Repeat builds validate the small `<name>.cacheinfo` sidecar without loading the rendered `<name>.cache` payload. `-Force` rebuilds eligible cache entries but never overrides the cache policy.

Both files live in `(Get-ColorScriptConfiguration).Cache.EffectivePath`. The `.cache` file contains rendered terminal output; `.cacheinfo` contains only validation metadata. A sidecar without its payload is not a usable cache entry and is repaired by the next build. `Clear-ColorScriptCache -All` removes complete entries and orphaned sidecars.

For faster rebuilds on multi-core systems, use the `-Parallel` switch together with the `-ThrottleLimit` (or `-Threads`) parameter to control the worker count. The cmdlet automatically reverts to sequential execution when parallel runspaces cannot be created on the current host.

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

Cache a mix of exact and wildcard matches. Only matches included in `CachePolicy.psd1` are built; other matches report `SkippedNotRequired` with `-PassThru`.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name Galaxy -Force -PassThru | Format-List
```

Force a rebuild of the eligible 'Galaxy' cache even if it is up to date, and examine the detailed result object.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Mathematical' -PassThru
```

Evaluate scripts in the `Mathematical` category, cache eligible renderers, and return detailed results for every match.

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

Rebuild eligible caches for scripts tagged with either 'geometric' or 'colorful', forcing regeneration even if caches are current.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Mathematical -AsObject | New-ColorScriptCache -PassThru
```

Pipeline example: evaluate scripts in the `Mathematical` category, cache any policy-selected renderers, and return a result for every match.

### EXAMPLE 7

```powershell
# Check cache statistics after building
$cachePath = (Get-ColorScriptConfiguration).Cache.EffectivePath
$before = @(Get-ChildItem $cachePath -Filter "*.cache" -ErrorAction SilentlyContinue).Count
New-ColorScriptCache
$after = @(Get-ChildItem $cachePath -Filter "*.cache").Count
Write-Host "Cached scripts: $before -> $after"
```

Measures cache growth by counting policy-selected cache files before and after the operation.

### EXAMPLE 8

```powershell
# Build cache for frequently used computational renderers
$frequentScripts = @('Galaxy', 'rose-curves', 'wave-interference')
New-ColorScriptCache -Name $frequentScripts -PassThru | Format-Table Name, Status, ExitCode
```

Builds caches for the listed scripts that are eligible under `CachePolicy.psd1`; unlisted names are skipped.

### EXAMPLE 9

```powershell
# Use the built-in policy-scoped progress display
New-ColorScriptCache -All
```

Shows built-in progress for policy-selected renderers without manually iterating all available scripts.

### EXAMPLE 10

```powershell
# Optionally prime missing or stale policy entries from a PowerShell profile.
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Quiet
```

Checks policy-selected entries when the profile loads and builds only missing or stale entries. Omit this profile step when startup cache work is not wanted.

### EXAMPLE 11

```powershell
# Rebuild every policy-selected entry for deployment
New-ColorScriptCache -All -Force -PassThru |
    Select-Object Name, Status |
    Export-Csv "./cache-deployment.csv"
```

Rebuilds every policy-selected cache entry and exports the statuses to a deployment manifest.

### EXAMPLE 12

```powershell
# Find cache build failures
New-ColorScriptCache -Name "Galaxy" -Force -PassThru |
    Where-Object Status -eq 'Failed' |
    Select-Object Name, StdErr
```

Identifies caching failures without treating policy skips as errors.

### EXAMPLE 13

```powershell
# Count policy-selected entries updated by this run
New-ColorScriptCache -All -PassThru |
    Where-Object Status -eq 'Updated' |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

Checks every policy-selected entry and shows how many cache payloads were updated by this run.

### EXAMPLE 14

```powershell
New-ColorScriptCache -All -Parallel -Threads 8
```

Build all policy-selected caches using eight worker threads. The cmdlet automatically falls back to sequential execution when parallel jobs are not available on the current host.

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

Filters evaluated scripts by metadata category (case-insensitive). Multiple values are treated as an OR filter. Only matches allowed by `CachePolicy.psd1` are cached; other matches report `SkippedNotRequired` with `-PassThru`.

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

Rebuild eligible cache entries even when their `.cacheinfo` validation metadata says they are current. This does not override `CachePolicy.psd1`.

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

Displays detailed help for this command without performing the operation.

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

Deprecated compatibility switch. It is accepted as a silent no-op for one release because Pokémon scripts follow the same `CachePolicy.psd1` rules as every other script.

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

One or more colorscript names to evaluate for caching. Supports wildcard patterns (for example, `aurora-*` and `*-wave`). Matching scripts are cached only when listed in `CachePolicy.psd1`. When this parameter and all filters are omitted, only policy entries are resolved and evaluated.

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

Disable ANSI color sequences in informational output. This is useful in environments that do not render ANSI escape codes (such as some CI/CD logs) while still preserving colored output when desired.

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

Enable multi-threaded cache building. When specified, the cmdlet executes cache jobs across a runspace pool for faster completion on capable systems. Use in combination with `-ThrottleLimit` (or the `-Threads` alias) to control the number of concurrent workers. If multi-threading cannot be initialized, the cmdlet falls back to sequential execution automatically.

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

Suppress per-script progress and informational summary output. Use this switch when you only want structured output (via `-PassThru`) or when automation scenarios should silence informational messages while still surfacing warnings and errors.

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

Filters evaluated scripts by metadata tag (case-insensitive). Multiple values are treated as an OR filter. Only matches allowed by `CachePolicy.psd1` are cached; other matches report `SkippedNotRequired` with `-PassThru`.

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

Specifies the maximum number of concurrent cache workers when `-Parallel` is requested. Accepts values from 1 to 256. The default (when omitted) is the number of logical processors on the current machine. The alias `-Threads` is provided for convenience. Values less than or equal to one automatically revert to sequential execution.

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

This cmdlet supports the common parameters:
For more information, see
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
- **ScriptPath**: Full path to the source colorscript
- **CacheFile**: Full path to the generated cache file
- **Status**: `Updated`, `SkippedUpToDate`, `SkippedNotRequired`, `SkippedByUser`, or `Failed`
- **Message**: Localized status detail
- **CacheExists**: Whether an output cache exists after the operation
- **ExitCode**: The exit code from the script execution (0 indicates success)
- **StdOut**: Standard output captured during script execution
- **StdErr**: Standard error output captured during script execution

Without `-PassThru`, writes a concise informational summary containing processed, updated, skipped, and failed counts plus the effective cache directory.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced

**Aliases:** `Update-ColorScriptCache` and `Build-ColorScriptCache`.

Cache files are stored under `(Get-ColorScriptConfiguration).Cache.EffectivePath`. Source and policy signatures in companion metadata are used to determine whether an entry remains current.

The cmdlet caches only renderers that require execution and are allowed by the cache policy. Explicit static or unlisted scripts are reported as `SkippedNotRequired` and obsolete entries are removed.

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)

