---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

Erstellt ein neues Farbscript mit Metadaten und Vorlagenstruktur.

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

Erstellt eine neue Farbscript-Datei mit ordnungsgemäßer Metadatenstruktur und optionalem Vorlageninhalt. Dieses Cmdlet bietet eine standardisierte Möglichkeit, neue Farbscripts zu erstellen, die nahtlos in das ColorScripts-Enhanced-Ökosystem integrieren.

Das Cmdlet generiert:

- Eine neue .ps1-Datei mit grundlegender Struktur
- Zugehörige Metadaten für die Kategorisierung
- Vorlageninhalt basierend auf dem ausgewählten Stil
- Ordentliche Dateiorganisation

Verfügbare Vorlagen umfassen:

- Basic: Minimale Struktur für benutzerdefinierte Skripte
- Animated: Vorlage mit Zeitsteuerungen
- Interactive: Vorlage mit Benutzereingabebehandlung
- Geometric: Vorlage für geometrische Muster
- Nature: Vorlage für naturinspirierte Designs

Erstellte Skripte integrieren sich automatisch in die Caching- und Anzeigesysteme des Moduls.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name "MyScript"
```

Erstellt ein neues Farbscript mit grundlegender Vorlage.

### EXAMPLE 2

```powershell
New-ColorScript -Name "Sunset" -Category Nature -Tags "animated", "colorful" -Description "Beautiful sunset animation"
```

Erstellt ein naturthematisches animiertes Farbscript mit Metadaten.

### EXAMPLE 3

```powershell
New-ColorScript -Name "GeometricPattern" -Template Geometric -Path "./custom-scripts/"
```

Erstellt ein geometrisches Farbscript in einem benutzerdefinierten Verzeichnis.

### EXAMPLE 4

```powershell
New-ColorScript -Name "InteractiveDemo" -Template Interactive -WhatIf
```

Zeigt, was erstellt werden würde, ohne tatsächlich Dateien zu erstellen.

### EXAMPLE 5

```powershell
# Create multiple related scripts
$themes = @("Forest", "Ocean", "Mountain")
foreach ($theme in $themes) {
    New-ColorScript -Name $theme -Category Nature -Tags "landscape"
}
```

Erstellt mehrere naturthematische Farbscripts.

## PARAMETERS

### -Category

Gibt die Kategorie für das neue Farbscript an. Kategorien helfen dabei, Skripte thematisch zu organisieren.

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

Fordert Sie zur Bestätigung auf, bevor das Cmdlet ausgeführt wird.

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

Overwrites the destination file if it already exists.
Without this switch, the cmdlet will terminate with an error if a file with the same name is found at the target location.
Use with caution to avoid data loss.

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

Includes a guidance snippet in the output that demonstrates how to register the new script in `ScriptMetadata.psd1`.
The snippet uses the values from `-Category` and `-Tag` parameters if provided.
This is particularly useful for maintaining consistent metadata across all colorscripts in the module.

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

Zeigt die ausführliche Hilfe für diesen Befehl an, ohne den Vorgang auszuführen.

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

Der Name des neuen Farbscripts (ohne .ps1-Erweiterung).

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

Specifies the destination directory for the scaffold.
When not specified, defaults to the module's `Scripts` directory.
The path supports tilde (`~`) expansion for the user's home directory, environment variables (e.g., `$env:USERPROFILE`), and both relative and absolute paths.
The directory will be created if it doesn't exist.

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

Specifies one or more metadata tags for the colorscript.
Tags provide additional classification beyond the primary category and are useful for filtering and searching.
Common tags include theme descriptors like 'Minimal', 'Colorful', 'Animated', technology references like 'Matrix', 'ASCII', or contextual markers like 'Holiday', 'Season'.
Multiple tags can be specified as a comma-separated array.

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

Zeigt, was passieren würde, wenn das Cmdlet ausgeführt wird. Das Cmdlet wird nicht ausgeführt.

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

Dieses Cmdlet akzeptiert keine Eingabe von der Pipeline.

## OUTPUTS

### System.Object

Gibt ein Objekt mit Informationen über das erstellte Farbscript zurück.

## NOTES

**Autor:** Nick
**Modul:** ColorScripts-Enhanced
**Erfordert:** PowerShell 5.1 oder höher

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)
