---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Export-ColorScriptMetadata

## SYNOPSIS

Export metadata for every colorscript to JSON or emit it directly to the pipeline.

## SYNTAX

### Default (Default)

```
Export-ColorScriptMetadata [-Path <String>] [-IncludeFileInfo] [-IncludeCacheInfo] [-PassThru]
 [<CommonParameters>]
```

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-IncludeFileInfo] [-IncludeCacheInfo] [-PassThru]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

`Export-ColorScriptMetadata` gathers the module's catalog of colorscripts and returns an ordered data set describing each entry. Optional switches enrich the output with file metadata (size, timestamps, and full paths) and cache information (cache location, existence flag, and last write time). When `-Path` is supplied the metadata is written as pretty-printed JSON; otherwise the cmdlet produces objects on the pipeline.

Use this cmdlet to build dashboards, feed external tooling, or analyse cache coverage.

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

Returns objects that include file system details for each colorscript.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

Generates a JSON file containing enriched metadata and writes it to the `dist` directory (creating the folder if required).

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -PassThru | Where-Object { -not $_.CacheExists }
```

Writes the metadata file and also returns the objects to the pipeline, enabling queries that identify scripts without cache files.

## PARAMETERS

### -IncludeCacheInfo

Augment each record with cache metadata, including the cache file path, whether it exists, and its last modification time.
Attach cache metadata including the cache location, whether a cache file exists, and its timestamp.

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

Include file system details (full path, size, and last write time) in each record. Errors encountered while reading file metadata are reported via verbose output and result in null values.
Attach file system information (full path, file size, and last write time) for each colorscript.

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

Return the metadata objects even when `-Path` is specified.
Return the in-memory objects even when writing to a file.

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

Destination path for the JSON export. Supports relative paths, environment variables, and `~` expansion. When omitted, the cmdlet outputs objects to the pipeline.
Destination file path for the JSON output.
When omitted, objects are emitted to the pipeline.

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

### System.Object

Each object describes a colorscript, its tag and category metadata, and optional file or cache details.

## NOTES

Cache metadata is collected after ensuring the cache directory exists. When cache files are missing or unavailable, the returned properties are populated with default values.

## RELATED LINKS

- [Build-ColorScriptCache](Build-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
