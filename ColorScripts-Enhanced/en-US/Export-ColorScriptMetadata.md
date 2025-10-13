---
external help file: ColorScripts-Enhanced-help.xml
Module Name: ColorScripts-Enhanced
online version: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
schema: 2.0.0
---

# Export-ColorScriptMetadata

## SYNOPSIS

Export metadata for every colorscript to JSON or emit it directly to the pipeline.

## SYNTAX

```
Export-ColorScriptMetadata [-Path <String>] [-IncludeFileInfo] [-IncludeCacheInfo] [-PassThru] [<CommonParameters>]
```

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

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeFileInfo

Include file system details (full path, size, and last write time) in each record. Errors encountered while reading file metadata are reported via verbose output and result in null values.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru

Return the metadata objects even when `-Path` is specified.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

Destination path for the JSON export. Supports relative paths, environment variables, and `~` expansion. When omitted, the cmdlet outputs objects to the pipeline.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, and -WarningAction. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

This cmdlet does not accept pipeline input.

## OUTPUTS

### System.Object[]

Each object describes a colorscript, its tag and category metadata, and optional file or cache details.

## NOTES

Cache metadata is collected after ensuring the cache directory exists. When cache files are missing or unavailable, the returned properties are populated with default values.

## RELATED LINKS

[Build-ColorScriptCache](Build-ColorScriptCache.md)
[Get-ColorScriptList](Get-ColorScriptList.md)
[Clear-ColorScriptCache](Clear-ColorScriptCache.md)
