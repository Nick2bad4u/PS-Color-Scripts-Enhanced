---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/de/New-ColorScript.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScript

## SYNOPSIS

Erstellt ein neues Farbscript mit Metadaten und Vorlagenstruktur.

## SYNTAX

```text
New-ColorScript [-Name] <string> [[-Category] <string>] [[-Tags] <string[]>] [[-Description] <string>]
 [-Path <string>] [-Template <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

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
HelpMessage: ""
```

### -Confirm

Fordert Sie zur Bestätigung auf, bevor das Cmdlet ausgeführt wird.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: false
SupportsWildcards: false
Aliases: cf
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

### -Description

Stellt eine Beschreibung für das Farbscript bereit, die seinen visuellen Inhalt erklärt.

```yaml
Type: System.String
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

### -Name

Der Name des neuen Farbscripts (ohne .ps1-Erweiterung).

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

### -Path

Gibt das Verzeichnis an, in dem das Farbscript erstellt wird.

```yaml
Type: System.String
DefaultValue: None
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

### -Tags

Gibt Tags für das Farbscript an. Tags bieten zusätzliche Kategorisierungs- und Filteroptionen.

```yaml
Type: System.String[]
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

### -Template

Gibt die Vorlage an, die für das neue Farbscript verwendet werden soll. Verfügbare Vorlagen: Basic, Animated, Interactive, Geometric, Nature.

```yaml
Type: System.String
DefaultValue: Basic
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

### -WhatIf

Zeigt, was passieren würde, wenn das Cmdlet ausgeführt wird. Das Cmdlet wird nicht ausgeführt.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: false
SupportsWildcards: false
Aliases: wi
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

Dieses Cmdlet akzeptiert keine Eingabe von der Pipeline.

## OUTPUTS

### System.Object

Gibt ein Objekt mit Informationen über das erstellte Farbscript zurück.

## NOTES

**Autor:** Nick
**Modul:** ColorScripts-Enhanced
**Erfordert:** PowerShell 5.1 oder höher

## Vorlagen

- Basic: Minimale Struktur für benutzerdefinierte Skripte
- Animated: Vorlage mit Zeitsteuerungen
- Interactive: Vorlage mit Benutzereingabebehandlung
- Geometric: Vorlage für geometrische Muster
- Nature: Vorlage für naturinspirierte Designs

## Dateistruktur
Erstellte Skripte folgen der Standardorganisation des Moduls und integrieren sich automatisch in die Caching- und Anzeigesysteme.

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
