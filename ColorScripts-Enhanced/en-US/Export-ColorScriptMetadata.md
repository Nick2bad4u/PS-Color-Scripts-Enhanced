---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/en-US/Export-ColorScriptMetadata.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Export-ColorScriptMetadata

## SYNOPSIS

Exports comprehensive metadata for all colorscripts to JSON format or emits structured objects to the pipeline.

## SYNTAX

### Default (Default)

```text
Export-ColorScriptMetadata [-Path <String>] [-IncludeFileInfo] [-IncludeCacheInfo] [-PassThru]
 [<CommonParameters>]
```

### \_\_AllParameterSets

```text
Export-ColorScriptMetadata [[-Path] <string>] [-IncludeFileInfo] [-IncludeCacheInfo] [-PassThru]
 [<CommonParameters>]
```

## DESCRIPTION

The `Export-ColorScriptMetadata` cmdlet compiles a comprehensive inventory of all colorscripts in the module's catalog and generates a structured dataset describing each entry. This metadata includes essential information such as script names, categories, tags, and optional enrichments.

By default, the cmdlet returns PowerShell objects to the pipeline. When the `-Path` parameter is provided, it writes the metadata as formatted JSON to the specified file, automatically creating parent directories if they don't exist.

The cmdlet offers two optional enrichment flags:

- **IncludeFileInfo**: Adds file system metadata including full paths, file sizes (in bytes), and last modification timestamps
- **IncludeCacheInfo**: Appends cache-related information including cache file paths, existence status, and cache timestamps

This cmdlet is particularly useful for:

- Creating documentation or dashboards showing all available colorscripts
- Analyzing cache coverage and identifying scripts needing cache rebuilds
- Feeding metadata to external tools or automation pipelines
- Auditing colorscript inventory and file system status
- Generating reports on colorscript usage and organization

The output is ordered consistently, making it suitable for version control and diff operations when exported to JSON.

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

Exports basic metadata for all colorscripts to the pipeline without file or cache information.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

Returns objects that include file system details (full path, size, and last write time) for each colorscript.

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

Generates a JSON file containing basic metadata and writes it to the `dist` directory, creating the folder if it doesn't exist.

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

Generates a comprehensive JSON file with enriched metadata including both file system and cache information, writing it to the `dist` directory.

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -PassThru | Where-Object { -not $_.CacheExists }
```

Writes the metadata file and also returns the objects to the pipeline, enabling queries that identify scripts without cache files.

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

Groups colorscripts by category and displays counts, useful for analyzing the distribution of scripts across categories.

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property FileSize -Sum).Sum
Write-Host "Total size of all colorscripts: $($totalSize / 1KB) KB"
```

Calculates the total disk space used by all colorscript files.

### EXAMPLE 8

```powershell
# Generate statistics and save report
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachedScripts = ($metadata | Where-Object CacheExists).Count
    TotalFileSize = ($metadata | Measure-Object FileSize -Sum).Sum
    TotalCacheSize = ($metadata | Where-Object CacheExists |
        Measure-Object CacheFileSize -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

Generates a comprehensive statistics report including cache coverage and sizes.

### EXAMPLE 9

```powershell
# Export and compare with previous backup
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "New scripts: $($new.Count) | Removed scripts: $($removed.Count)"
```

Compares current metadata with a previous version to identify changes.

### EXAMPLE 10

```powershell
# Build API response for web dashboard
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

Generates API-ready JSON with versioning and timestamp information.

### EXAMPLE 11

```powershell
# Find scripts with missing cache for batch rebuild
$metadata = Export-ColorScriptMetadata -IncludeCacheInfo -AsObject
$uncached = $metadata | Where-Object { -not $_.CacheExists } | Select-Object -ExpandProperty Name
if ($uncached.Count -gt 0) {
    Write-Host "Rebuilding cache for $($uncached.Count) scripts..."
    New-ColorScriptCache -Name $uncached
}
```

Identifies and rebuilds cache for scripts that don't have cache files.

### EXAMPLE 12

```powershell
# Create HTML gallery from metadata
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$html = @"
<html>
<head><title>ColorScripts-Enhanced Gallery</title></head>
<body>
<h1>ColorScripts-Enhanced</h1>
<ul>
"@
foreach ($script in $metadata) {
    $html += "<li><strong>$($script.Name)</strong> [$($script.Category)]</li>`n"
}
$html += "</ul></body></html>"
$html | Out-File "./gallery.html" -Encoding UTF8
```

Creates an HTML gallery page listing all available colorscripts.

### EXAMPLE 13

```powershell
# Monitor script sizes over time
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object FileSize -Average).Average) bytes avg" }
```

Tracks file size changes for individual scripts over multiple exports.

## PARAMETERS

### -IncludeCacheInfo

Augments each record with cache metadata, including the cache file path, whether a cache file exists, and its last modification timestamp. This is useful for identifying scripts that may need cache regeneration or analyzing cache coverage across the colorscript library.

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

### -IncludeFileInfo

Includes file system details (full path, size in bytes, and last write time) in each record. When file metadata cannot be read (due to permissions or missing files), errors are logged via verbose output and the affected properties are set to null values. This switch is valuable for auditing file sizes and modification dates.

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

### -PassThru

Returns the metadata objects to the pipeline even when the `-Path` parameter is specified. This allows you to both save the metadata to a file and perform additional processing or filtering on the objects in a single command. Without this switch, specifying `-Path` suppresses pipeline output.

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

### -Path

Specifies the destination file path for the JSON export. Supports relative paths, absolute paths, environment variables (e.g., `$env:TEMP\metadata.json`), and tilde expansion (e.g., `~/Documents/metadata.json`). Parent directories are automatically created if they don't exist. When this parameter is omitted, the cmdlet outputs objects directly to the pipeline instead of writing to a file. The JSON output is formatted with indentation for readability.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: (All)
   Position: 0
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

### None

This cmdlet does not accept pipeline input.

## OUTPUTS

### System.Management.Automation.PSCustomObject

When `-Path` is not specified, or when `-PassThru` is used, the cmdlet returns custom objects. Each object represents a single colorscript with the following base properties:

- **Name**: The colorscript's filename without extension
- **Category**: The organizational category (e.g., "nature", "abstract", "geometric")
- **Tags**: An array of descriptive tags for filtering and searching

When `-IncludeFileInfo` is specified, these additional properties are included:

- **FilePath**: The full filesystem path to the script file
- **FileSize**: Size in bytes (null if file is inaccessible)
- **LastWriteTime**: Timestamp of last modification (null if unavailable)

When `-IncludeCacheInfo` is specified, these additional properties are included:

- **CachePath**: The full path to the corresponding cache file
- **CacheExists**: Boolean indicating whether a cache file exists
- **CacheLastWriteTime**: Timestamp of cache file modification (null if cache doesn't exist)

## ADVANCED USAGE PATTERNS

### Data Analysis and Reporting

## Comprehensive Inventory Report

```powershell
# Generate complete inventory with all metadata
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo -PassThru

$report = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    TotalFileSize = ($metadata | Measure-Object -Property FileSize -Sum).Sum
    CachedScripts = ($metadata | Where-Object { $_.CacheExists }).Count
    CacheSize = ($metadata | Where-Object { $_.CacheExists } | Measure-Object -Property CacheFileSize -Sum).Sum
}

$report | ConvertTo-Json | Out-File "./inventory-report.json"
```

## Category Distribution Analysis

```powershell
# Analyze distribution across categories
$metadata = Export-ColorScriptMetadata -IncludeFileInfo

$categories = $metadata | Group-Object Category | ForEach-Object {
    [PSCustomObject]@{
        Category = $_.Name
        Count = $_.Count
        TotalSize = ($_.Group | Measure-Object FileSize -Sum).Sum
        AverageSize = [math]::Round(($_.Group | Measure-Object FileSize -Average).Average, 0)
    }
}

$categories | Sort-Object Count -Descending | Format-Table
```

## Cache Coverage Analysis

```powershell
# Identify cache gaps
$metadata = Export-ColorScriptMetadata -IncludeCacheInfo -PassThru

$uncached = $metadata | Where-Object { -not $_.CacheExists }
$cached = $metadata | Where-Object { $_.CacheExists }

Write-Host "Cache coverage: $([math]::Round($cached.Count / $metadata.Count * 100, 1))%"
Write-Host "Scripts without cache: $($uncached.Count)"

$uncached | Select-Object Name, Category | Format-Table
```

### Integration Workflows

## API Response Generation

```powershell
# Build versioned API response
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object -ExpandProperty Version).ToString()
    timestamp = (Get-Date -Format 'o')
    scriptCount = $metadata.Count
    scripts = $metadata | Select-Object Name, Category, Tags, Description
    cacheStats = @{
        cached = ($metadata | Where-Object CacheExists).Count
        total = $metadata.Count
    }
} | ConvertTo-Json -Depth 5

$apiResponse | Out-File "./api/colorscripts-v1.json" -Encoding UTF8
```

## Web Gallery Generation

```powershell
# Create interactive HTML gallery
$metadata = Export-ColorScriptMetadata -Detailed

$html = @"
<!DOCTYPE html>
<html>
<head>
    <title>ColorScripts-Enhanced Gallery</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .script { border: 1px solid #ccc; padding: 10px; margin: 10px 0; }
    </style>
</head>
<body>
<h1>ColorScripts-Enhanced - $($metadata.Count) Scripts</h1>
"@

$metadata | ForEach-Object {
    $html += "<div class='script'><strong>$($_.Name)</strong> [$($_.Category)]<br/>Tags: $(($_.Tags -join ', '))</div>`n"
}

$html += "</body></html>"
$html | Out-File "./gallery.html" -Encoding UTF8
```

## Change Tracking

```powershell
# Compare current state with previous export
Export-ColorScriptMetadata -Path "./metadata-current.json" -IncludeFileInfo

$current = Get-Content "./metadata-current.json" | ConvertFrom-Json
$previous = Get-Content "./metadata-previous.json" -ErrorAction SilentlyContinue | ConvertFrom-Json

if ($previous) {
    $added = $current | Where-Object { $_.Name -notin $previous.Name }
    $removed = $previous | Where-Object { $_.Name -notin $current.Name }

    Write-Host "Added: $($added.Count) scripts"
    Write-Host "Removed: $($removed.Count) scripts"
}
```

### Maintenance and Validation

## Health Check Automation

```powershell
# Validate all scripts and cache status
$metadata = Export-ColorScriptMetadata -IncludeCacheInfo -IncludeFileInfo -PassThru

$health = $metadata | ForEach-Object {
    @{
        Name = $_.Name
        FileExists = Test-Path $_.FilePath
        Cached = $_.CacheExists
        FileAge = if (Test-Path $_.FilePath) { (Get-Date) - (Get-Item $_.FilePath).LastWriteTime } else { $null }
    }
}

$health | Where-Object { -not $_.FileExists -or -not $_.Cached } | Format-Table
```

## Performance Metrics

```powershell
# Export with performance data
$startTime = Get-Date
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo

$metrics = @{
    ExportTime = ((Get-Date) - $startTime).TotalMilliseconds
    ScriptCount = $metadata.Count
    TotalFileSize = ($metadata | Measure-Object FileSize -Sum).Sum
    CacheHitRate = ($metadata | Where-Object CacheExists).Count / $metadata.Count
}

$metrics | ConvertTo-Json | Out-File "./performance.json"
```

### Backup and Disaster Recovery

## Metadata Backup

```powershell
# Create timestamped metadata backup
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
Export-ColorScriptMetadata -Path "./backups/metadata-$timestamp.json" -IncludeFileInfo -IncludeCacheInfo

# Keep only last 5 backups
Get-ChildItem "./backups/metadata-*.json" | Sort-Object Name -Descending | Select-Object -Skip 5 | Remove-Item
```

## Recovery Validation

```powershell
# Validate backed-up metadata against current state
$backup = Get-Content "./backups/metadata-latest.json" | ConvertFrom-Json
$current = Export-ColorScriptMetadata -PassThru

$missing = $backup | Where-Object { $_.Name -notin $current.Name }
if ($missing.Count -gt 0) {
    Write-Warning "Missing from current: $($missing.Count) scripts"
}
```

## NOTES

## Performance Considerations

- Adding `-IncludeFileInfo` or `-IncludeCacheInfo` requires filesystem I/O operations and may impact performance when processing large colorscript libraries.
- For large exports, consider using `-PassThru` with pipeline filtering rather than loading all in memory
- Export operations scale linearly with script count

## Cache Directory Management

- Cache metadata collection ensures the cache directory exists before attempting to read cache files.
- When cache files are missing or unavailable, the `CacheExists` property is set to `false` and `CacheLastWriteTime` is set to null.

## Error Handling

- File metadata read errors are reported via verbose output (`-Verbose`) rather than terminating the cmdlet.
- Individual file errors result in null values for the affected properties while allowing the cmdlet to continue processing remaining colorscripts.

## JSON Output Format

- JSON files are written with indentation (depth 2) for human readability.
- The output encoding is UTF-8 for maximum compatibility.
- Existing files at the target path are overwritten without prompting.

## Best Practices

- Schedule regular metadata exports for auditing
- Version your metadata exports with timestamps
- Use `-PassThru` for both file export and pipeline processing
- Store backups in version control or backup systems
- Monitor export file size growth over time

## Use Cases

- Integrating with CI/CD pipelines for documentation generation
- Building web dashboards or API endpoints serving colorscript metadata
- Creating inventory reports for large colorscript collections
- Identifying scripts requiring cache regeneration
- Tracking changes and maintaining audit logs

## RELATED LINKS

- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
