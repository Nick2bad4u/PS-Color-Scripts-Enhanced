---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScript

## SYNOPSIS

Scaffold a new colorscript file and optionally emit metadata guidance.

## SYNTAX

### Default (Default)

```
New-ColorScript [-Name] <String> [-OutputPath <String>] [-Force] [-Category <String>]
 [-Tag <String[]>] [-GenerateMetadataSnippet] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### __AllParameterSets

```
New-ColorScript [-Name] <string> [[-OutputPath] <string>] [[-Category] <string>] [[-Tag] <string[]>]
 [-Force] [-GenerateMetadataSnippet] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

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
Suggested primary category for metadata guidance.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

Overwrite the destination file if it already exists.
Overwrite an existing file with the same name.

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

### -GenerateMetadataSnippet

Include a guidance snippet that shows how to register the new script in `ScriptMetadata.psd1`.
Emit a guidance snippet describing how to update ScriptMetadata.psd1.

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

### -Name

Name of the colorscript (used for the output file). Must begin with an alphanumeric character and can include underscores or hyphens.
Name of the new colorscript.
A `.ps1` extension is appended automatically.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputPath

Destination directory for the scaffold. Defaults to the module's `Scripts` folder when not specified. Supports relative paths, environment variables, and `~` expansion.
Destination directory for the new script.
Defaults to the module's Scripts directory.

```yaml
Type: System.String
DefaultValue: (module Scripts directory)
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

One or more metadata tags suggested for inclusion in `ScriptMetadata.psd1`.
Suggested metadata tags for the new script.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.
Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

You cannot pipe objects to this cmdlet.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Contains the script name, generated path, category and tag suggestions, and metadata guidance text (when requested).

## NOTES

The scaffold is written with UTF-8 encoding without a byte-order mark. The generated template includes an ANSI sample block that can be replaced with the final artwork.

## RELATED LINKS

- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [Build-ColorScriptCache](Build-ColorScriptCache.md)
- [ScriptMetadata.psd1](../ScriptMetadata.psd1)
