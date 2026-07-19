---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/en-US/New-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 11/14/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScriptCache

## SYNOPSIS

Pre-build or refresh colorscript cache files for faster rendering.

## DESCRIPTION

`New-ColorScriptCache` executes computationally expensive colorscripts in a background PowerShell instance and saves the rendered output using UTF-8 encoding (without BOM). Cached content dramatically speeds up subsequent calls to `Show-ColorScript` by eliminating repeated rendering work. Static output scripts execute directly and never create cache files. You can also use the alias `Update-ColorScriptCache` to invoke this cmdlet.

You can target scripts by name (wildcards supported), category, or tag. When no parameters are specified, the cmdlet resolves the names in `CachePolicy.psd1` directly instead of enumerating the full collection. Exact bundled names also use a direct file lookup. Wildcard, category, and tag requests enumerate only when their matching semantics require it. Explicit unlisted scripts are returned with the `SkippedNotRequired` status when `-PassThru` is used, and any obsolete cache files for those scripts are removed.

By default, the cmdlet displays progress plus a concise summary of the caching operation and the effective cache directory. Use `-PassThru` to return detailed result objects for each script, which you can inspect programmatically for status, standard output, and error streams. Combine `-Quiet` to suppress progress and the summary entirely, or `-NoAnsiOutput` to emit plain-text summaries without ANSI color codes for environments that do not support them.

The cmdlet intelligently skips scripts whose cache files are already up-to-date unless you specify the `-Force` parameter. Repeat builds validate the small `<name>.cacheinfo` sidecar without loading the rendered `<name>.cache` payload. `-Force` rebuilds eligible cache entries but never overrides the cache policy.

Both files live in `(Get-ColorScriptConfiguration).Cache.EffectivePath`. The `.cache` file contains rendered terminal output; `.cacheinfo` contains only validation metadata. A sidecar without its payload is not a usable cache entry and is repaired by the next build. `Clear-ColorScriptCache -All` removes complete entries and orphaned sidecars.

For faster rebuilds on multi-core systems, use the `-Parallel` switch together with the `-ThrottleLimit` (or `-Threads`) parameter to control the worker count. The cmdlet automatically reverts to sequential execution when parallel runspaces cannot be created on the current host.

## SYNTAX

### All

```text
New-ColorScriptCache [-All] [-IncludePokemon] [-Force] [-PassThru] [-Parallel] [-ThrottleLimit <Int32>] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Named

```text
New-ColorScriptCache [-Name <String[]>] [-Category <String[]>] [-Tag <String[]>] [-IncludePokemon] [-Force] [-PassThru] [-Parallel] [-ThrottleLimit <Int32>] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Resolve and warm only the policy-selected computational renderers without enumerating every script that ships with the module. This is the default behavior when no parameters are specified.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name penrose-quasicrystal, 'aurora-*'
```

Cache a mix of exact and wildcard matches. Only matches included in `CachePolicy.psd1` are built; other matches report `SkippedNotRequired` with `-PassThru`.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name mandelbrot-zoom -Force -PassThru | Format-List
```

Force a rebuild of the 'mandelbrot-zoom' cache even if it's up-to-date, and examine the detailed result object.

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
$frequentScripts = @('mandelbrot-zoom', 'penrose-quasicrystal', 'aurora-waves', 'galaxy-spiral')
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
# Find cache build failures
New-ColorScriptCache -Name "mandelbrot-zoom" -Force -PassThru |
    Where-Object Status -eq 'Failed' |
    Select-Object Name, StdErr
```

Identifies caching failures without treating policy skips as errors.

### EXAMPLE 13

```powershell
# Cache eligible animated scripts
New-ColorScriptCache -Tag Animated -PassThru |
    Where-Object Status -in 'Created', 'Updated' |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

Caches eligible scripts tagged as animated and shows the count of updated cache entries.

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

### -Category

Limit the selection to scripts that belong to the specified category (case-insensitive). Multiple values are treated as an OR filter, meaning scripts matching any of the specified categories will be cached.

```yaml
Type: System.String[]
DefaultValue: ""
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Named
   Position: 1
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Confirm

Prompts you for confirmation before running the cmdlet. Useful when caching a large number of scripts or when using `-Force` to prevent accidental cache regeneration.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ""
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
HelpMessage: ""
```

### -Force

Rebuild eligible cache files even when the existing cache is newer than the script source. This does not override cache eligibility for static or unlisted scripts.

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
HelpMessage: ""
```

### -Name

One or more colorscript names to evaluate for caching. Supports wildcard patterns (for example, `aurora-*` and `*-wave`). Matching scripts are cached only when listed in `CachePolicy.psd1`. When this parameter and all filters are omitted, only policy entries are resolved and evaluated.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
 - Name: Named
   Position: 0
   IsRequired: false
   ValueFromPipeline: true
   ValueFromPipelineByPropertyName: true
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -PassThru

Return detailed result objects for each cache operation. By default, only a summary is displayed. The result objects include properties such as Name, Status, CacheFile, ExitCode, StdOut, and StdErr, allowing for programmatic inspection of the caching process.

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
HelpMessage: ""
```

### -Parallel

Enable multi-threaded cache building. When specified, the cmdlet executes cache jobs across a runspace pool for faster completion on capable systems. Use in combination with `-ThrottleLimit` (or the `-Threads` alias) to control the number of concurrent workers. If multi-threading cannot be initialized, the cmdlet falls back to sequential execution automatically.

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
HelpMessage: ""
```

### -ThrottleLimit

Specifies the maximum number of concurrent cache workers when `-Parallel` is requested. Accepts values from 1 to 256. The default (when omitted) is the number of logical processors on the current machine. The alias `-Threads` is provided for convenience. Values less than or equal to one automatically revert to sequential execution.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases:
 - Threads
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

### -Quiet

Suppress per-script progress and informational summary output. Use this switch when you only want structured output (via `-PassThru`) or when automation scenarios should silence informational messages while still surfacing warnings and errors.

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
HelpMessage: ""
```

### -NoAnsiOutput

Disable ANSI color sequences in informational output. This is useful in environments that do not render ANSI escape codes (such as some CI/CD logs) while still preserving colored output when desired.

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
HelpMessage: ""
```

### -IncludePokemon

Include Pokémon (regular and shiny) in the evaluated selection. Pokémon scripts that are not present in `CachePolicy.psd1` report `SkippedNotRequired` and are not cached.

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
HelpMessage: ""
```

### -Tag

Limit the selection to scripts containing the specified metadata tags (case-insensitive). Multiple values are treated as an OR filter, caching scripts that match any of the specified tags.

```yaml
Type: System.String[]
DefaultValue: ""
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Named
   Position: 2
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -WhatIf

Shows what would happen if the cmdlet runs without actually performing the caching operations. Useful for previewing which scripts would be cached before committing to the operation.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ""
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
HelpMessage: ""
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

## ADVANCED USAGE PATTERNS

### Cache Building Strategies

## Full Production Cache

```powershell
# Build all policy-selected caches for a production environment
New-ColorScriptCache -Force | Measure-Object
Write-Host "Cache built successfully"

# Verify cache files exist
Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter "*.cache" | Measure-Object
```

## Minimal Production Cache

```powershell
# Cache only recommended scripts for minimal footprint
New-ColorScriptCache -Tag Recommended -PassThru |
    Select-Object Name, Status, CacheFile
```

## Selective Category Caching

```powershell
# Cache specific categories based on environment
$categories = if ($env:CI) { @("Simple", "Fast") } else { @("*") }

Get-ColorScriptList -Category $categories -AsObject |
    ForEach-Object { New-ColorScriptCache -Name $_.Name }
```

### Performance Monitoring

## Cache Building Progress

```powershell
# Monitor cache building with progress
$scripts = Get-ColorScriptList -AsObject
$total = $scripts.Count
$counter = 0

$scripts | ForEach-Object {
    $counter++
    Write-Progress -Activity "Building Cache" `
                   -Status $_.Name `
                   -PercentComplete (($counter / $total) * 100)
    New-ColorScriptCache -Name $_.Name | Out-Null
}
Write-Progress -Activity "Building Cache" -Completed
```

## Performance Comparison Report

```powershell
# Compare cache building times
$results = @()
Get-ColorScriptList -Category Geometric -AsObject | ForEach-Object {
    $time = Measure-Command { New-ColorScriptCache -Name $_.Name -Force } | Select-Object -ExpandProperty TotalMilliseconds
    $results += [PSCustomObject]@{
        Script = $_.Name
        BuildTime = [math]::Round($time, 2)
    }
}
$results | Sort-Object BuildTime -Descending | Format-Table
```

### Maintenance and Cleanup

## Scheduled Cache Rebuild

```powershell
# Rebuild cache weekly
$lastRun = Get-Item "$env:APPDATA\ColorScripts-Enhanced\cache" | Select-Object -ExpandProperty LastWriteTime
$daysSince = ((Get-Date) - $lastRun).Days

if ($daysSince -ge 7) {
    Write-Host "Rebuilding cache..."
    New-ColorScriptCache -Force
}
```

## Selective Cache Updates

```powershell
# Update only stale caches
$scripts = Get-ColorScriptList -AsObject
$scripts | ForEach-Object {
    $cacheFile = "$env:APPDATA\ColorScripts-Enhanced\cache\$($_.Name).cache"
    if (-not (Test-Path $cacheFile) -or (Get-Item $cacheFile).LastWriteTime -lt (Get-Date).AddDays(-30)) {
        New-ColorScriptCache -Name $_.Name -PassThru
    }
}
```

### CI/CD Integration

## Build Cache in Docker

```powershell
# In Dockerfile or build script
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Force | Out-Null
Write-Host "✓ ColorScripts cache built"
```

## Cache Archive for Deployment

```powershell
# Archive cache for deployment
$cacheDir = "$env:APPDATA\ColorScripts-Enhanced\cache"
$archive = "./colorscripts-cache.zip"

Compress-Archive -Path "$cacheDir\*" -DestinationPath $archive -Force
Write-Host "Cache archived: $archive"
```

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced

**Aliases:** This cmdlet can also be called using the alias `Update-ColorScriptCache`, which is useful for scripts that refresh existing caches.

Cache files are stored in the directory exposed by the module's `CacheDir` variable (typically within the module's data directory). A successful build sets the cache file's timestamp to match the script's last write time, enabling subsequent runs to skip unchanged scripts efficiently.

The cmdlet executes each eligible script in an isolated background PowerShell process to capture its output without affecting the current session. Static and unlisted scripts are not executed by this cmdlet.

## Best Practices

- Run once after module installation to pre-cache computational renderers
- Use `-Force` only when you need to rebuild all eligible caches
- Filter by category or tag for faster targeted cache builds
- Monitor build times to identify slow-rendering scripts
- Schedule periodic rebuilds to keep cache current
- Use `-PassThru` in automation for detailed status reporting
- Consider using `-WhatIf` before large cache operations

**Performance Tip:** Run this cmdlet once after installing or updating the module to pre-cache the computational renderers selected by `CachePolicy.psd1`.

## Troubleshooting

- If cache build fails, check script syntax with `Show-ColorScript -Name scriptname -NoCache`
- Monitor disk space for cache directory growth
- Use `-PassThru` to identify which scripts failed building
- Clear and rebuild if cache becomes corrupted: `Clear-ColorScriptCache -All; New-ColorScriptCache`

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
