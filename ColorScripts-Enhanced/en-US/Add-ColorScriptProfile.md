---
external help file: ColorScripts-Enhanced-help.xml
Module Name: ColorScripts-Enhanced
online version: https://github.com/Nick2bad4u/ps-color-scripts-enhanced
schema: 2.0.0
---

# Add-ColorScriptProfile

## SYNOPSIS
Appends the ColorScripts-Enhanced module import (and optionally Show-ColorScript) to a PowerShell profile file.

## SYNTAX

### Scope (Default)
```
Add-ColorScriptProfile [-Scope <String>] [-SkipStartupScript] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Path
```
Add-ColorScriptProfile [-Path <String>] [-SkipStartupScript] [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds a startup snippet to the specified PowerShell profile file. The snippet always imports the ColorScripts-Enhanced module and, unless suppressed, adds a call to `Show-ColorScript` so that a random colorscript is displayed on launch. The profile file is created if it does not already exist, and duplicate imports are avoided unless `-Force` is specified.

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
Add-ColorScriptProfile -Path .\profiles\example.ps1 -Force
```
Appends the snippet to a custom profile path, even if the import line already exists.

## PARAMETERS

### -Force
Append the snippet even if the profile already contains an `Import-Module ColorScripts-Enhanced` line.

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
Explicit profile path to update. Overrides `-Scope` when provided.

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Scope
Profile scope to update when `-Path` is not supplied. Accepts PowerShell's standard profile properties (e.g., `CurrentUserAllHosts`, `CurrentUserCurrentHost`). Defaults to `CurrentUserAllHosts`.

```yaml
Type: String
Parameter Sets: Scope
Aliases:

Required: False
Position: Named
Default value: CurrentUserAllHosts
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipStartupScript
Skip adding `Show-ColorScript` to the profile. Only the import line is appended.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

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

[Show-ColorScript](Show-ColorScript.md)
[Build-ColorScriptCache](Build-ColorScriptCache.md)
[Clear-ColorScriptCache](Clear-ColorScriptCache.md)
[Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
