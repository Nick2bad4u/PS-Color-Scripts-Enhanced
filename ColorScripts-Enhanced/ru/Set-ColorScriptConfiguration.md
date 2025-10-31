---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ru/Set-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Persist changes to the ColorScripts-Enhanced cache and startup configuration.

## SYNTAX

### Default (Default)

```
Set-ColorScriptConfiguration [-AutoShowOnImport <Boolean>] [-ProfileAutoShow <Boolean>]
 [-CachePath <String>] [-DefaultScript <String>] [-PassThru] [<CommonParameters>]
```

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

`Set-ColorScriptConfiguration` provides a persistent way to customize the behavior and storage location of the ColorScripts-Enhanced module. This cmdlet updates the module's configuration file, allowing you to control various aspects of script rendering and storage.

**Key capabilities:**

- **Cache relocation**: Move the colorscript cache to a custom directory, useful for network shares, faster drives, or centralized storage locations.
- **Auto-import behavior**: Control whether a colorscript automatically displays when the module is first imported into your PowerShell session.
- **Profile integration**: Configure default settings for `Add-ColorScriptProfile` to streamline profile setup.
- **Default script selection**: Set a preferred colorscript that will be used when no specific script is requested.

Any directory path supplied for `-CachePath` is automatically created if it does not already exist. The cmdlet supports environment variable expansion, tilde (`~`) home directory expansion, and both absolute and relative paths. Supplying an empty string (`''`) to `-CachePath` or `-DefaultScript` clears the stored value and reverts to module defaults.

Changes made with this cmdlet take effect immediately for new operations but may not affect already-loaded cache data until the module is reimported or PowerShell is restarted.

When `-PassThru` is specified, the cmdlet returns the updated configuration object, making it easy to verify changes or chain additional operations.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

Moves the cache to `D:/Temp/ColorScriptsCache`, enables automatic display on module import, disables profile auto-show, and sets `bars` as the default script.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

Clears the default script and returns the resulting configuration object, allowing you to verify that the setting was removed.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

Relocates the cache to the Windows TEMP directory and displays the full updated configuration in list format. Useful for temporary testing scenarios.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

Disables automatic colorscript rendering when the module loads. Useful if you prefer manual control over when scripts are displayed.

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

Sets a Linux/macOS-style cache path using tilde expansion and configures 'crunch' as the default script for all operations.

## PARAMETERS

### -AutoShowOnImport

Enable or disable automatic rendering of a colorscript when the module is imported. When enabled (`$true`), a colorscript displays immediately upon module import, providing instant visual feedback. When disabled (`$false`), scripts only display when explicitly invoked. If not specified, the existing setting remains unchanged.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: (no change)
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

### -CachePath

Specifies the directory where colorscript files and metadata are stored. Supports absolute paths, relative paths (resolved from the current location), environment variables (e.g., `$env:USERPROFILE`), and tilde (`~`) expansion for the home directory.

If the specified directory does not exist, it will be created automatically with appropriate permissions. Provide an empty string (`''`) to clear the custom path and revert to the platform-specific default location. When left unspecified, the existing cache path setting is preserved.

**Note**: Changing the cache path does not automatically migrate existing cached files. You may need to manually copy files or allow them to be regenerated.

```yaml
Type: System.String
DefaultValue: (no change)
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

### -DefaultScript

Sets or clears the default colorscript name used by profile helpers, auto-show features, and when no script is explicitly specified in commands. This should match the base name of a script file without extension (e.g., `'bars'`, not `'bars.ps1'`).

Provide an empty string (`''`) to remove the stored default, reverting to module-level default behavior (typically random selection). When this parameter is omitted, the current default script setting is unchanged.

The specified script must exist in the module's script directory to be used successfully.

```yaml
Type: System.String
DefaultValue: (no change)
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

### -PassThru

Returns the updated configuration object after making changes. Without this switch, the cmdlet operates silently (no output). The returned object has the same structure as `Get-ColorScriptConfiguration` and can be inspected, stored, or piped to other cmdlets for further processing.

Useful for verification, logging, or chaining configuration commands.

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

### -ProfileAutoShow

Controls whether profile snippets generated by `Add-ColorScriptProfile` include an automatic `Show-ColorScript` invocation. When `$true`, the profile code will display a colorscript on every shell startup. When `$false`, the profile will load the module but not auto-display scripts.

This setting only affects newly generated profile code; existing profile modifications are not automatically updated. Omitting this parameter leaves the current setting unchanged.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: (no change)
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

This cmdlet does not accept pipeline input.

## OUTPUTS

### None

By default, this cmdlet produces no output.

### System.Collections.Hashtable

When `-PassThru` is specified, returns a hashtable containing the complete updated configuration. The structure matches the output of `Get-ColorScriptConfiguration`, with keys such as `CachePath`, `AutoShowOnImport`, `ProfileAutoShow`, and `DefaultScript`.

## NOTES

**Configuration file location:**

Configuration changes are persisted to a JSON or XML file stored in a platform-specific application data directory. Use `Get-ColorScriptConfiguration` to view the current configuration root path. The environment variable `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` can override the default configuration directory location if set before module import.

**Platform defaults:**

- **Windows**: `$env:LOCALAPPDATA\ColorScripts-Enhanced`
- **Linux/macOS**: `~/.config/ColorScripts-Enhanced` or `$XDG_CONFIG_HOME/ColorScripts-Enhanced`

**Best practices:**

- Test cache path changes in a non-production environment first, especially when using network locations.
- Use `-PassThru` when scripting to validate configuration updates programmatically.
- Consider setting `AutoShowOnImport:$false` in automated scripts or CI/CD pipelines to avoid unexpected visual output.
- Document custom configurations in team environments to ensure consistent behavior across users.

**Permissions:**

Ensure you have write permissions to the configuration directory. On shared systems, configuration changes affect only the current user's profile unless overridden with environment variables pointing to shared locations.

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Show-ColorScript](Show-ColorScript.md)

