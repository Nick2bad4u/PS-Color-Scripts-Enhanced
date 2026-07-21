---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: en-US
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Export-ColorScriptMetadata
---

# Export-ColorScriptMetadata

## SYNOPSIS

Exports comprehensive metadata for all colorscripts to JSON format or emits structured objects to the pipeline.

## SYNTAX

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-h] [-IncludeFileInfo] [-IncludeCacheInfo]
 [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

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

### -Confirm

Prompts you for confirmation before running the cmdlet.

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

### -h

Displays detailed help for this command without performing the operation.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- help
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
HelpMessage: ''
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
HelpMessage: ''
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
HelpMessage: ''
```

### -Path

Specifies the destination file path for the JSON export. Supports relative paths, absolute paths, environment variables (e.g., `$env:TEMP\metadata.json`), and tilde expansion (e.g., `~/Documents/metadata.json`). Parent directories are automatically created if they don't exist. When this parameter is omitted, the cmdlet outputs objects directly to the pipeline instead of writing to a file. The JSON output is formatted with indentation for readability.

```yaml
Type: System.String
DefaultValue: ''
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
HelpMessage: ''
```

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

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

## NOTES

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)

