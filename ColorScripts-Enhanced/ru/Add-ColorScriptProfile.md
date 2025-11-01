---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/ru/Add-ColorScriptProfile.md
Locale: en-US
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Appends the ColorScripts-Enhanced module import (and optionally Show-ColorScript) to a PowerShell profile file.

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-Scope] <string>] [[-Path] <string>] [-h] [-SkipStartupScript] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:
- None

## DESCRIPTION

Adds a startup snippet to the specified PowerShell profile file. The snippet always imports the ColorScripts-Enhanced module and, unless suppressed with `-SkipStartupScript`, adds a call to `Show-ColorScript` so that a random colorscript is displayed on PowerShell launch.

The profile file is created automatically if it does not already exist. Duplicate imports are avoided unless `-Force` is specified.

The `-Path` parameter accepts relative paths, environment variables, and `~` expansion, making it easy to target profiles outside the default locations. If `-Path` is not provided, the `-Scope` parameter determines which standard PowerShell profile to modify.

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
Add-ColorScriptProfile -Scope CurrentUserCurrentHost -SkipStartupScript
```

This adds only the `Import-Module ColorScripts-Enhanced` line to the current host profile.

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

This appends the snippet again, even if the profile already contains an import statement for ColorScripts-Enhanced.

### EXAMPLE 5

Setup on a new machine - create profile if needed and add ColorScripts to all hosts.

```powershell
$profileExists = Test-Path $PROFILE.CurrentUserAllHosts
if (-not $profileExists) {
    New-Item -Path $PROFILE.CurrentUserAllHosts -ItemType File -Force | Out-Null
}
Add-ColorScriptProfile -Scope CurrentUserAllHosts -Confirm:$false
Write-Host "Profile configured! Restart your terminal to see colorscripts on startup."
```

### EXAMPLE 6

Add with a specific colorscript for display (add manually after this command):

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Then manually edit $PROFILE to add:
# Show-ColorScript -Name mandelbrot-zoom
```

### EXAMPLE 7

Verify profile was added correctly:

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Add to specific profile scope targeting current host only:

```powershell
# For Windows Terminal or ConEmu only
Add-ColorScriptProfile -Scope CurrentUserCurrentHost

# For all PowerShell hosts (ISE, VSCode, Console)
Add-ColorScriptProfile -Scope CurrentUserAllHosts
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

### -Force

Append the snippet even if the profile already contains an `Import-Module ColorScripts-Enhanced` line. Use this to force duplicate entries or re-add the snippet after manual removal.

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

### -Path

Explicit profile path to update. Overrides `-Scope` when provided. Supports environment variables (e.g., `$env:USERPROFILE`), relative paths, and `~` expansion for the home directory.

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

### -Scope

Profile scope to update when `-Path` is not supplied. Accepts PowerShell's standard profile properties: `CurrentUserAllHosts`, `CurrentUserCurrentHost`, `AllUsersAllHosts`, or `AllUsersCurrentHost`. Defaults to `CurrentUserAllHosts`.

```yaml
Type: System.String
DefaultValue: 'CurrentUserAllHosts'
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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

This cmdlet does not accept pipeline input.

## OUTPUTS

### System.Object

Returns a custom object with the following properties:
- **ProfilePath** (string): The full path to the modified profile file
- **Changed** (bool): Whether the profile was actually modified
- **Message** (string): A status message describing the operation result

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

The profile file is created automatically if it does not exist, including any necessary parent directories. Duplicate imports are detected and suppressed unless `-Force` is used.

If you need elevated permissions to modify an AllUsers profile, ensure you run PowerShell as Administrator.

## RELATED LINKS

- [Online Version](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
- [Show-ColorScript](./Show-ColorScript.md)
- [New-ColorScriptCache](./New-ColorScriptCache.md)
- [Clear-ColorScriptCache](./Clear-ColorScriptCache.md)
- [GitHub Repository](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)

