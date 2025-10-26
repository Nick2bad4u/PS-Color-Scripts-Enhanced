---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Add-ColorScriptProfile

## SYNOPSIS

Appends the ColorScripts-Enhanced module import (and optionally Show-ColorScript) to a PowerShell profile file.

## SYNTAX

### Scope (Default)

```
Add-ColorScriptProfile [-Scope <String>] [-SkipStartupScript] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Path

```
Add-ColorScriptProfile [-Path <String>] [-SkipStartupScript] [-Force] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### __AllParameterSets

```
Add-ColorScriptProfile [[-Scope] <string>] [[-Path] <string>] [-SkipStartupScript] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Adds a startup snippet to the specified PowerShell profile file. The snippet always imports the ColorScripts-Enhanced module and, unless suppressed, adds a call to `Show-ColorScript` so that a random colorscript is displayed on launch. The profile file is created if it does not already exist, and duplicate imports are avoided unless `-Force` is specified.

The `-Path` parameter accepts relative paths, environment variables, and `~` expansion, making it easy to target profiles outside the default locations.

## EXAMPLES

### EXAMPLE 1

```powershell
Add-ColorScriptProfile
```

Updates the CurrentUserAllHosts profile to import the module and show a random colorscript at startup.

### EXAMPLE 2

```powershell
Add-ColorScriptProfile -SkipStartupScript
```

Appends only the `Import-Module ColorScripts-Enhanced` line without calling `Show-ColorScript`.

### EXAMPLE 3

```powershell
Add-ColorScriptProfile -Scope CurrentUserCurrentHost
```

Targets the profile for the current host (e.g., Windows Terminal, VS Code) instead of all hosts.

### EXAMPLE 4

```powershell
Add-ColorScriptProfile -Path "~/PowerShell/Profiles/Example.ps1" -Force
```

Appends the snippet to a custom profile path (resolved from `~`), even if the import line already exists.

## PARAMETERS

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

Append the snippet even if the profile already contains an `Import-Module ColorScripts-Enhanced` line.

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

Explicit profile path to update. Overrides `-Scope` when provided. Supports environment variables, relative paths, and `~` expansion.
Explicit profile path to update.
Overrides `-Scope` when provided.
Supports environment variables, relative paths, and `~` expansion.

```yaml
Type: System.String
DefaultValue: None
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

Profile scope to update when `-Path` is not supplied. Accepts PowerShell's standard profile properties (e.g., `CurrentUserAllHosts`, `CurrentUserCurrentHost`). Defaults to `CurrentUserAllHosts`.
Profile scope to update when `-Path` is not supplied.
Accepts PowerShell's standard profile properties (e.g., `CurrentUserAllHosts`, `CurrentUserCurrentHost`).
Defaults to `CurrentUserAllHosts`.

```yaml
Type: System.String
DefaultValue: CurrentUserAllHosts
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

Skip adding `Show-ColorScript` to the profile. Only the import line is appended.
Skip adding `Show-ColorScript` to the profile.
Only the import line is appended.

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

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

### System.Object

Returns an object containing the profile path, whether a change was made, and a status message.

## NOTES

Author: Nick
Module: ColorScripts-Enhanced
Requires: PowerShell 5.1 or later

The profile file is created automatically if it does not exist. Duplicate imports are suppressed unless `-Force` is used.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Build-ColorScriptCache](Build-ColorScriptCache.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
