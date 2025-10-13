---
external help file: ColorScripts-Enhanced-help.xml
Module Name: ColorScripts-Enhanced
online version: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
schema: 2.0.0
---

# New-ColorScript

## SYNOPSIS

Scaffold a new colorscript file and optionally emit metadata guidance.

## SYNTAX

```
New-ColorScript [-Name] <String> [-OutputPath <String>] [-Force] [-Category <String>] [-Tag <String[]>] [-GenerateMetadataSnippet] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

`New-ColorScript` creates a UTF-8 colorscript skeleton containing an ANSI template and returns information about the generated file. By default the script is written into the module's `Scripts` directory, but `-OutputPath` can target any folder. Names must begin with an alphanumeric character and can include underscores or hyphens. Existing files are protected unless `-Force` is specified.

When `-GenerateMetadataSnippet` is supplied the cmdlet produces a guidance block that can be copied into `ScriptMetadata.psd1`, using the category and tag hints provided.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

Creates `my-spectrum.ps1` in the module's `Scripts` directory and returns metadata guidance for updating `ScriptMetadata.psd1`.

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

Generates the scaffold under a custom directory, overwriting any existing file with the same name.

## PARAMETERS

### -Category

Optional category hint included in the metadata guidance output when `-GenerateMetadataSnippet` is used.

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

### -Force

Overwrite the destination file if it already exists.

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

### -GenerateMetadataSnippet

Include a guidance snippet that shows how to register the new script in `ScriptMetadata.psd1`.

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

### -Name

Name of the colorscript (used for the output file). Must begin with an alphanumeric character and can include underscores or hyphens.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputPath

Destination directory for the scaffold. Defaults to the module's `Scripts` folder when not specified. Supports relative paths, environment variables, and `~` expansion.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (module Scripts directory)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag

One or more metadata tags suggested for inclusion in `ScriptMetadata.psd1`.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, and -WarningAction. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

You cannot pipe objects to this cmdlet.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Contains the script name, generated path, category and tag suggestions, and metadata guidance text (when requested).

## NOTES

The scaffold is written with UTF-8 encoding without a byte-order mark. The generated template includes an ANSI sample block that can be replaced with the final artwork.

## RELATED LINKS

[Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
[Build-ColorScriptCache](Build-ColorScriptCache.md)
[ScriptMetadata.psd1](../ScriptMetadata.psd1)
