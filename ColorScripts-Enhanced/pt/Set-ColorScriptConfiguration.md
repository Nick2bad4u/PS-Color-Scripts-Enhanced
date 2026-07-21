---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: pt
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Persist changes to the ColorScripts-Enhanced cache and startup configuration.

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

`Set-ColorScriptConfiguration` provides a persistent way to customize the behavior and storage location of the ColorScripts-Enhanced module. This cmdlet updates the module's configuration file, allowing you to control various aspects of script rendering and storage.

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

Controls whether importing the module automatically displays a colorscript.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
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

Especifica o caminho do diretório onde os arquivos de cache do colorscript serão armazenados.

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

### -Confirm

Solicita confirmação antes de executar o cmdlet.

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

### -DefaultScript

Specifies the default colorscript used by startup and profile integration.

```yaml
Type: System.String
DefaultValue: ''
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

### -h

Exibe a ajuda detalhada deste comando sem executar a operação.

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

### -PassThru

Returns the effective configuration after the requested changes succeed.

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

### -ProfileAutoShow

Controls whether profile integration displays a colorscript after importing the module.

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -WhatIf

Mostra o que aconteceria se o cmdlet fosse executado. O cmdlet não é executado.

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

### None (2)

By default, this cmdlet produces no output.

### System.Collections.Hashtable

When `-PassThru` is specified, returns a hashtable containing the complete updated configuration. The structure matches the output of `Get-ColorScriptConfiguration`, with keys such as `CachePath`, `AutoShowOnImport`, `ProfileAutoShow`, and `DefaultScript`.

## NOTES

Configuration is persisted only after validation and confirmation succeed. `-WhatIf` performs no filesystem writes. Use `Get-ColorScriptConfiguration` to inspect the effective values and storage paths after the operation.

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)

