---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: en-US
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

Scaffold a new colorscript file and optionally emit metadata guidance.

## SYNTAX

### Scaffold

```
New-ColorScript -Name <string> -OutputPath <string> [-h] [-Force] [-GenerateMetadataSnippet]
 [-Category <string[]>] [-Tag <string[]>] [-OpenInEditor] [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScript [-h] [-Name <string>] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

The `New-ColorScript` cmdlet creates a minimal colorscript scaffold containing a string array and a loop that writes each line. The file is encoded as UTF-8 without a byte-order mark (BOM). Optional metadata guidance can be included as a comment in the generated file and returned in the result object.

Both `-Name` and `-OutputPath` are mandatory when scaffolding. `-OutputPath` identifies a directory; the command creates the directory when needed and writes `<Name>.ps1` within it.

Script names must follow PowerShell naming conventions: they must begin with an alphanumeric character and may include underscores or hyphens. The `.ps1` extension is automatically appended if not provided. Existing files are protected from accidental overwrites unless the `-Force` switch is explicitly specified.

When combined with `-GenerateMetadataSnippet`, the cmdlet returns guidance describing the entry to add to `ScriptMetadata.psd1`. The supplied category and tag values are also returned as arrays on the result object.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -OutputPath ./ColorScripts-Enhanced/Scripts -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

Creates `my-spectrum.ps1` in the requested directory and returns an object containing the file path and metadata guidance.

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

Generates the scaffold under a custom directory (`~/Dev/colorscripts`), creating the directory if it doesn't exist. If a file named `holiday-banner.ps1` already exists in that location, it will be overwritten due to the `-Force` switch.

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -OutputPath ./ColorScripts-Enhanced/Scripts -Category 'Artistic' -Tag '80s','Neon' -GenerateMetadataSnippet
$result.MetadataGuidance | Set-Clipboard
```

Creates a new colorscript and copies the metadata guidance to the clipboard, making it easy to paste into `ScriptMetadata.psd1`.

### EXAMPLE 4

```powershell
New-ColorScript -Name 'test-pattern' -OutputPath '.\temp' -WhatIf
```

Shows what would happen when creating a test pattern script in the `.\temp` directory without actually creating the file. Useful for validating paths and names before execution.

### EXAMPLE 5

```powershell
# Create multiple colorscripts for a project
$scriptNames = @("company-logo", "team-banner", "status-display")
foreach ($name in $scriptNames) {
    New-ColorScript -Name $name -Category "Corporate" -Tag "Custom" -OutputPath ".\src" | Out-Null
}
Write-Host "Created $($scriptNames.Count) colorscript templates"
```

Creates multiple colorscript templates in batch for a project.

### EXAMPLE 6

```powershell
# Create and immediately open in editor
New-ColorScript -Name "my-art" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -GenerateMetadataSnippet -OpenInEditor
```

Creates a colorscript and asks the platform's registered handler to open it.

### EXAMPLE 7

```powershell
# Create with full workflow automation
$newScript = New-ColorScript -Name "interactive-demo" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Custom" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "Created: $($newScript.Name)"
Write-Host "Path: $($newScript.Path)"
Write-Host "Metadata guidance ready in clipboard"
$newScript.MetadataGuidance | Set-Clipboard
```

Creates a colorscript with metadata guidance automatically copied to clipboard.

### EXAMPLE 8

```powershell
# Verify script name conventions
$validName = "123-start"
$invalidNames = @("-invalid", "_underscore-only", "contains space")
foreach ($name in $invalidNames) {
    try {
        New-ColorScript -Name $name -OutputPath ./temp -WhatIf -ErrorAction Stop
    } catch {
        Write-Warning "Invalid name '$name': $_"
    }
}
```

Demonstrates naming convention validation for colorscripts.

### EXAMPLE 9

```powershell
# Create in portable location for distribution
$portableDir = Join-Path $PSScriptRoot "colorscripts"
$scaffold = New-ColorScript -Name "portable-art" -OutputPath $portableDir -GenerateMetadataSnippet
Write-Host "Created portable colorscript at: $($scaffold.Path)"
```

Creates colorscripts in a portable location relative to the current script.

### EXAMPLE 10

```powershell
# Create with category and tag validation
$categories = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Category -Unique
if ("Retro" -in $categories) {
    New-ColorScript -Name "retro-party" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -Tag "Fun","Social"
} else {
    Write-Warning "Retro category not found"
}
```

Validates that a category exists before creating a new colorscript.

## PARAMETERS

### -Category

Specifies one or more categories returned with the scaffold and included in metadata guidance. Values should align with categories already used in `ScriptMetadata.psd1`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

### -Force

Overwrites the destination file if it already exists. Without this switch, the cmdlet will terminate with an error if a file with the same name is found at the target location. Use with caution to avoid data loss.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Overwrite
ParameterSets:
- Name: Scaffold
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

Includes a guidance snippet in the output that demonstrates how to register the new script in `ScriptMetadata.psd1`. The snippet uses the values from `-Category` and `-Tag` parameters if provided. This is particularly useful for maintaining consistent metadata across all colorscripts in the module.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

### -Name

Specifies the name of the new colorscript. The name must begin with an alphanumeric character and can include underscores or hyphens. The `.ps1` extension is appended automatically if not included. This name will be used as the filename and should be descriptive of the script's content or theme.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Help
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OpenInEditor

Opens the generated colorscript with the command configured by the environment when creation succeeds.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputPath

Specifies the mandatory target directory. The command creates <Name>.ps1 within this directory.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Destination
- Path
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

Specifies one or more metadata tags for the colorscript. Tags provide additional classification beyond the primary category and are useful for filtering and searching. Common tags include theme descriptors like 'Minimal', 'Colorful', 'Animated', technology references like 'Matrix', 'ASCII', or contextual markers like 'Holiday', 'Season'. Multiple tags can be specified as a comma-separated array.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

Shows what would happen if the cmdlet runs without actually performing any actions. Displays the file path that would be created and any validation checks that would be performed. The cmdlet does not create any files or directories when this switch is specified.

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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

You cannot pipe objects to this cmdlet.

## OUTPUTS

### System.Management.Automation.PSCustomObject

The cmdlet returns a custom object with the following properties:

- **Name**: The colorscript name without the `.ps1` extension
- **Path**: The full path to the generated file
- **Categories**: The array of category values that was specified (if any)
- **Tags**: The array of tag values that were specified (if any)
- **MetadataGuidance**: The metadata snippet text (only when -GenerateMetadataSnippet is used)

## NOTES

**Encoding**: The scaffold is written with UTF-8 encoding without a byte-order mark (BOM), ensuring compatibility across different platforms and editors.

**Template Structure**: The generated template includes:

- A scaffold comment
- A string array placeholder for the art
- A loop that writes each line with `Write-Host`

**Metadata Integration**: While the cmdlet can generate metadata guidance, you must manually add the snippet to `ScriptMetadata.psd1` to fully integrate the script into the module's discovery and categorization system.

**Development Workflow**:

1. Use `New-ColorScript` to create the scaffold
2. Edit the generated .ps1 file to add your ANSI art
3. If metadata guidance was generated, copy it to `ScriptMetadata.psd1`
4. Test your script with `Show-ColorScript -Name <your-script-name>`

**Best Practices**:

- Choose descriptive, hyphenated names that clearly indicate the script's theme
- Use consistent category values that align with existing scripts
- Apply multiple tags to improve discoverability
- Test scripts in different terminal environments to ensure compatibility

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)

