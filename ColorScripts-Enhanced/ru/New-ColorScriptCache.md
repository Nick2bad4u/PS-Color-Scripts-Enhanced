---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ru/New-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScriptCache

## SYNOPSIS

Pre-build or refresh colorscript cache files for faster rendering.

## DESCRIPTION

`New-ColorScriptCache` executes colorscripts in a background PowerShell instance and saves the rendered output using UTF-8 encoding (without BOM). Cached content dramatically speeds up subsequent calls to `Show-ColorScript` by eliminating the need to re-execute scripts. You can also use the alias `Update-ColorScriptCache` to invoke this cmdlet.

You can target specific scripts by name (wildcards supported) or cache the entire collection. When no parameters are specified, the cmdlet defaults to caching all available scripts. You can also filter scripts by category or tag to cache only those that match specific criteria.

By default, the cmdlet displays a concise summary of the caching operation. Use `-PassThru` to return detailed result objects for each script, which you can inspect programmatically for status, standard output, and error streams.

The cmdlet intelligently skips scripts whose cache files are already up-to-date unless you specify the `-Force` parameter to rebuild all caches regardless of their current state.

## SYNTAX

### All

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Named

```
New-ColorScriptCache [-Name <String[]>] [-Category <String[]>] [-Tag <String[]>] [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Warm the cache for every script that ships with the module. This is the default behavior when no parameters are specified.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name bars, 'aurora-*'
```

Cache a mix of exact and wildcard matches. The cmdlet will process the 'bars' script and all scripts whose names start with 'aurora-'.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name mandelbrot-zoom -Force -PassThru | Format-List
```

Force a rebuild of the 'mandelbrot-zoom' cache even if it's up-to-date, and examine the detailed result object.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Animation' -PassThru
```

Cache all scripts in the 'Animation' category and return detailed results for each operation.

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

Rebuild caches for all scripts tagged with either 'geometric' or 'colorful', forcing regeneration even if caches are current.

### EXAMPLE 6

```powershell
Get-ColorScriptList | Where-Object Category -eq 'Classic' | New-ColorScriptCache -PassThru
```

Pipeline example: retrieve all classic scripts and cache them, returning detailed results.

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
$frequentScripts = @('bars', 'arch', 'mandelbrot-zoom', 'aurora-waves', 'galaxy-spiral')
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
New-ColorScriptCache -Name "mandelbrot-zoom" -Force -PassThru |
    Where-Object { $_.ExitCode -ne 0 } |
    Select-Object Name, StdErr
```

Identifies any caching failures by filtering for non-zero exit codes.

### EXAMPLE 13

```powershell
# Cache all animated scripts
New-ColorScriptCache -Tag Animated -PassThru |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

Caches all scripts tagged as animated and shows the count of cached scripts.

## PARAMETERS

### -All

Cache every available script. When omitted and no names are supplied, all scripts are cached by default. This parameter is useful when you want to be explicit about caching all scripts.

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

Rebuild cache files even when the existing cache is newer than the script source. This is useful when you want to ensure all caches are regenerated, such as after module updates or when troubleshooting rendering issues.

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

One or more colorscript names to cache. Supports wildcard patterns (e.g., 'aurora-_', '_-wave'). When this parameter is omitted and no filtering parameters are specified, the cmdlet caches every available script by default.

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

**Full Production Cache**

```powershell
# Build all caches for production environment
New-ColorScriptCache -Force | Measure-Object
Write-Host "Cache built successfully"

# Verify cache files exist
Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter "*.cache" | Measure-Object
```

**Minimal Production Cache**

```powershell
# Cache only recommended scripts for minimal footprint
New-ColorScriptCache -Tag Recommended -PassThru |
    Select-Object Name, Status, CacheFile
```

**Selective Category Caching**

```powershell
# Cache specific categories based on environment
$categories = if ($env:CI) { @("Simple", "Fast") } else { @("*") }

Get-ColorScriptList -Category $categories -AsObject |
    ForEach-Object { New-ColorScriptCache -Name $_.Name }
```

### Performance Monitoring

**Cache Building Progress**

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

**Performance Comparison Report**

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

**Scheduled Cache Rebuild**

```powershell
# Rebuild cache weekly
$lastRun = Get-Item "$env:APPDATA\ColorScripts-Enhanced\cache" | Select-Object -ExpandProperty LastWriteTime
$daysSince = ((Get-Date) - $lastRun).Days

if ($daysSince -ge 7) {
    Write-Host "Rebuilding cache..."
    New-ColorScriptCache -Force
}
```

**Selective Cache Updates**

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

**Build Cache in Docker**

```powershell
# In Dockerfile or build script
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Force | Out-Null
Write-Host "✓ ColorScripts cache built"
```

**Cache Archive for Deployment**

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

The cmdlet executes each script in an isolated background PowerShell process to capture its output without affecting the current session. This ensures accurate caching of the exact console output that would be displayed when running the script directly.

**Best Practices:**

- Run once after module installation to pre-cache all scripts
- Use `-Force` only when you need to rebuild all caches
- Filter by category or tag for faster targeted cache builds
- Monitor build times to identify slow-rendering scripts
- Schedule periodic rebuilds to keep cache current
- Use `-PassThru` in automation for detailed status reporting
- Consider using `-WhatIf` before large cache operations

**Performance Tip:** Run this cmdlet once after installing or updating the module to pre-cache all scripts for optimal performance.

**Troubleshooting:**

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
