---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/en-US/New-ColorScript.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScript

## SYNOPSIS

Scaffold a new colorscript file and optionally emit metadata guidance.

## SYNTAX

### Default (Default)

```text
New-ColorScript [-Name] <String> [-OutputPath <String>] [-Force] [-Category <String>]
 [-Tag <String[]>] [-GenerateMetadataSnippet] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### \_\_AllParameterSets

```text
New-ColorScript [-Name] <string> [[-OutputPath] <string>] [[-Category] <string>] [[-Tag] <string[]>]
 [-Force] [-GenerateMetadataSnippet] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The `New-ColorScript` cmdlet creates a complete colorscript skeleton that serves as a foundation for developing custom ANSI art scripts. The generated file includes a pre-formatted template with ANSI escape sequence examples, proper UTF-8 encoding without a byte-order mark (BOM), and optional metadata guidance for integration with the module's metadata system.

By default, the script is written into the module's `Scripts` directory, ensuring it can be automatically discovered by the module's script enumeration functions. However, the `-OutputPath` parameter allows targeting any custom directory for development or testing purposes.

Script names must follow PowerShell naming conventions: they must begin with an alphanumeric character and may include underscores or hyphens. The `.ps1` extension is automatically appended if not provided. Existing files are protected from accidental overwrites unless the `-Force` switch is explicitly specified.

When combined with the `-GenerateMetadataSnippet` parameter, the cmdlet produces ready-to-use PowerShell code that demonstrates how to register the new script in `ScriptMetadata.psd1`. This guidance includes the category and tag values specified through the respective parameters, streamlining the process of integrating custom scripts into the module's organizational structure.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

Creates `my-spectrum.ps1` in the module's `Scripts` directory and returns a PowerShell object containing the file path and a metadata snippet. The snippet shows how to add an entry to `ScriptMetadata.psd1` with the 'Artistic' category and tags 'Custom' and 'Demo'.

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

Generates the scaffold under a custom directory (`~/Dev/colorscripts`), creating the directory if it doesn't exist. If a file named `holiday-banner.ps1` already exists in that location, it will be overwritten due to the `-Force` switch.

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -Category 'Retro' -Tag '80s','Neon' -GenerateMetadataSnippet
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
$scaffold = New-ColorScript -Name "my-art" -Category "Artistic" -GenerateMetadataSnippet
code $scaffold.Path  # Opens in VS Code
```

Creates a colorscript and opens it immediately in the default editor for editing.

### EXAMPLE 7

```powershell
# Create with full workflow automation
$newScript = New-ColorScript -Name "interactive-demo" -Category "Educational" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "Created: $($newScript.ScriptName)"
Write-Host "Path: $($newScript.Path)"
Write-Host "Metadata guidance ready in clipboard"
$newScript.MetadataGuidance | Set-Clipboard
```

Creates a colorscript with metadata guidance automatically copied to clipboard.

### EXAMPLE 8

```powershell
# Verify script name conventions
$validName = "my-awesome-script"
$invalidNames = @("123start", "-invalid", "_underscore-only")
foreach ($name in $invalidNames) {
    try {
        New-ColorScript -Name $name -WhatIf -ErrorAction Stop
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
    New-ColorScript -Name "retro-party" -Category "Retro" -Tag "Fun","Social"
} else {
    Write-Warning "Retro category not found"
}
```

Validates that a category exists before creating a new colorscript.

## PARAMETERS

### -Category

Specifies the primary category for the colorscript when generating metadata guidance. This parameter is only meaningful when used with `-GenerateMetadataSnippet`. Common categories include 'Artistic', 'Geometric', 'Nature', 'Retro', 'Gaming', and 'Abstract'. The value should align with existing categories in `ScriptMetadata.psd1` for consistency.

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
HelpMessage: ""
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
HelpMessage: ""
```

### -Force

Overwrites the destination file if it already exists. Without this switch, the cmdlet will terminate with an error if a file with the same name is found at the target location. Use with caution to avoid data loss.

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

### -GenerateMetadataSnippet

Includes a guidance snippet in the output that demonstrates how to register the new script in `ScriptMetadata.psd1`. The snippet uses the values from `-Category` and `-Tag` parameters if provided. This is particularly useful for maintaining consistent metadata across all colorscripts in the module.

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

Specifies the name of the new colorscript. The name must begin with an alphanumeric character and can include underscores or hyphens. The `.ps1` extension is appended automatically if not included. This name will be used as the filename and should be descriptive of the script's content or theme.

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
HelpMessage: ""
```

### -OutputPath

Specifies the destination directory for the scaffold. When not specified, defaults to the module's `Scripts` directory. The path supports tilde (`~`) expansion for the user's home directory, environment variables (e.g., `$env:USERPROFILE`), and both relative and absolute paths. The directory will be created if it doesn't exist.

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
HelpMessage: ""
```

### -Tag

Specifies one or more metadata tags for the colorscript. Tags provide additional classification beyond the primary category and are useful for filtering and searching. Common tags include theme descriptors like 'Minimal', 'Colorful', 'Animated', technology references like 'Matrix', 'ASCII', or contextual markers like 'Holiday', 'Season'. Multiple tags can be specified as a comma-separated array.

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
HelpMessage: ""
```

### -WhatIf

Shows what would happen if the cmdlet runs without actually performing any actions. Displays the file path that would be created and any validation checks that would be performed. The cmdlet does not create any files or directories when this switch is specified.

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
HelpMessage: ""
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

The cmdlet returns a custom object with the following properties:

- **ScriptName**: The name of the created colorscript (including .ps1 extension)
- **Path**: The full path to the generated file
- **Category**: The category value that was specified (if any)
- **Tags**: The array of tag values that were specified (if any)
- **MetadataGuidance**: The metadata snippet text (only when -GenerateMetadataSnippet is used)

## NOTES

**Encoding**: The scaffold is written with UTF-8 encoding without a byte-order mark (BOM), ensuring compatibility across different platforms and editors.

**Template Structure**: The generated template includes:

- A comment-based help block with placeholders for documentation
- An ANSI art sample block demonstrating color sequences and formatting
- Proper PowerShell script structure with clear sections for customization

**Metadata Integration**: While the cmdlet can generate metadata guidance, you must manually add the snippet to `ScriptMetadata.psd1` to fully integrate the script into the module's discovery and categorization system.

**Development Workflow**:

1. Use `New-ColorScript` to create the scaffold
2. Edit the generated .ps1 file to add your ANSI art
3. If metadata guidance was generated, copy it to `ScriptMetadata.psd1`
4. Run `New-ColorScriptCache` to rebuild the module's cache
5. Test your script with `Show-ColorScript -Name <your-script-name>`

**Best Practices**:

- Choose descriptive, hyphenated names that clearly indicate the script's theme
- Use consistent category values that align with existing scripts
- Apply multiple tags to improve discoverability
- Test scripts in different terminal environments to ensure compatibility

## RELATED LINKS

- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [ScriptMetadata.psd1](../ScriptMetadata.psd1)
