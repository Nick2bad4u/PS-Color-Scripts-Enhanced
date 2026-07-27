---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: en-US
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Adds or updates a managed ColorScripts-Enhanced startup block in a PowerShell profile file.

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

Adds a managed startup block to the selected PowerShell profile. The block imports ColorScripts-Enhanced and can call `Show-ColorScript` after import. `-SkipStartupScript` writes an import-only block.

When `-ProfilePath` is omitted, the command prefers `$PROFILE.CurrentUserAllHosts` and otherwise uses the first defined profile path. The profile file and missing parent directories are created when needed.

Existing managed or legacy ColorScripts-Enhanced blocks are replaced instead of duplicated. If the profile already imports the module outside a managed block, the command leaves it unchanged unless `-Force` is specified. `-Force` permits replacing recognized module content while preserving unrelated profile content.

The generated startup behavior is resolved from explicit parameters and persisted configuration. `-AutoShow` explicitly enables display and `-DefaultStartupScript` selects a named script. Pokémon scripts participate normally; new managed profiles never prompt about them or emit `-IncludePokemon`. Unless `-SkipCacheBuild` is used, the command can pre-warm policy-selected cache entries after updating the profile.

## EXAMPLES

### EXAMPLE 1

Add to the current user's profile for all hosts (default behavior).

```powershell
Add-ColorScriptProfile
```

This adds both the module import and `Show-ColorScript` call to `$PROFILE.CurrentUserAllHosts`.

### EXAMPLE 2

Add to the current user's profile for the current host only, without the startup script.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost -SkipStartupScript
```

This adds an import-only managed block to the current-host profile.

### EXAMPLE 3

Add to a custom profile path with environment variable expansion.

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

This targets a specific profile file outside the standard PowerShell profile locations.

### EXAMPLE 4

Force re-add the snippet even if it already exists.

```powershell
Add-ColorScriptProfile -Force
```

This updates recognized ColorScripts-Enhanced profile content while preserving unrelated profile lines.

### EXAMPLE 5

Setup on a new machine - create profile if needed and add ColorScripts to all hosts.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts -Confirm:$false
Write-Host "Profile configured! Restart your terminal to see colorscripts on startup."
```

### EXAMPLE 6

Add with a specific colorscript for startup display:

```powershell
Add-ColorScriptProfile -DefaultStartupScript mandelbrot-zoom -AutoShow
```

### EXAMPLE 7

Verify profile was added correctly:

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Target the current-host or all-hosts profile explicitly:

```powershell
# For Windows Terminal or ConEmu only
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost

# For all PowerShell hosts (ISE, VSCode, Console)
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts
```

### EXAMPLE 9

Using relative paths and tilde expansion:

```powershell
# Using tilde expansion for home directory
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# Using current directory relative path
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

Display daily different colorscript by adding custom logic:

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Then add this to $PROFILE manually:
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

### EXAMPLE 11

Use the deprecated compatibility switch with an existing automation call:

```powershell
Add-ColorScriptProfile -IncludePokemon
```

The switch is accepted as a silent no-op for one compatibility release. Pokémon scripts already participate normally, and the generated profile calls plain `Show-ColorScript`.

## PARAMETERS

### -AutoShow

Controls whether the managed profile block displays a colorscript after importing the module.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -DefaultStartupScript

Specifies the colorscript name written to the managed profile block for startup display.

```yaml
Type: System.String
DefaultValue: ''
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

### -Force

Updates recognized ColorScripts-Enhanced profile content while preserving unrelated profile lines. It does not deliberately append duplicate managed blocks.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -h

Displays help information for this cmdlet. Equivalent to using `Get-Help Add-ColorScriptProfile`.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -IncludePokemon

Deprecated compatibility switch. It is accepted as a silent no-op for one release; Pokémon colorscripts already participate normally, and generated profiles never emit this switch.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -PokemonPromptResponse

Deprecated compatibility parameter. It is accepted as a silent no-op for one release because profile generation no longer prompts about Pokémon.

```yaml
Type: System.String
DefaultValue: ''
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

### -ProfilePath

Specifies the PowerShell profile file to update. The Path alias is also accepted.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Path
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

### -SkipCacheBuild

Suppress the optional cache pre-warm. A pre-warm is attempted only when the resolved `ProfileAutoShow`
setting is enabled, cache building has not otherwise been disabled, the target profile is outside the
system temp directory, and the operation is approved by `ShouldProcess`. The command also respects the
environment variable `COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` and the global variable
`$Global:ColorScriptsEnhancedSkipCacheBuild`.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -SkipPokemonPrompt

Deprecated compatibility switch. It is accepted as a silent no-op for one release because profile generation no longer prompts about Pokémon.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -SkipStartupScript

Skip adding `Show-ColorScript` to the profile. Only the `Import-Module ColorScripts-Enhanced` line is appended. Use this if you want to manually control when colorscripts are displayed.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
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

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

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
For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

This cmdlet does not accept pipeline input.

## OUTPUTS

### System.Object

Returns a custom object with the following properties:

- **Path** (string): The full path to the selected profile file
- **Changed** (bool): Whether the profile was actually modified
- **Message** (string): A status message describing the operation result
- **IncludePokemon** (bool): Always `$true`; retained temporarily for result-object compatibility
- **CacheBuilt** (bool): Whether the optional cache warm-up completed

## NOTES

**Author:** Nick

**Module:** ColorScripts-Enhanced

**Requires:** PowerShell 5.1 or later

The profile file is created automatically if it does not exist, including necessary parent directories. The command manages user-supplied file paths; it does not expose a separate scope selector.

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)

