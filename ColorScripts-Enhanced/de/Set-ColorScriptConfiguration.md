---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/de/Set-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Ändert die Konfigurationseinstellungen von ColorScripts-Enhanced.

## SYNTAX

```
Set-ColorScriptConfiguration [-CachePath <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Aktualisiert die Konfigurationseinstellungen von ColorScripts-Enhanced mit persistentem Speicher. Dieses Cmdlet ermöglicht die Anpassung des Modulverhaltens durch benutzerkonfigurierbare Optionen.

Konfigurierbare Einstellungen umfassen:

- Cache-Verzeichnis-Standort
- Leistungsoptimierungseinstellungen
- Standard-Anzeigeverhalten
- Modul-Betriebseinstellungen

Änderungen werden automatisch in benutzerspezifischen Konfigurationsdateien gespeichert und bleiben über PowerShell-Sitzungen hinweg erhalten. Verwenden Sie Get-ColorScriptConfiguration, um die aktuellen Einstellungen anzuzeigen.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath "C:\MyCache"
```

Legt einen benutzerdefinierten Cache-Verzeichnispfad fest.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -CachePath $env:TEMP
```

Verwendet das System-Temp-Verzeichnis für die Cache-Speicherung.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "~/.colorscript-cache"
```

Legt den Cache-Pfad mit Unix-Style-Home-Verzeichnis-Notation fest.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -WhatIf
```

Zeigt, welche Konfigurationsänderungen vorgenommen würden, ohne sie anzuwenden.

### EXAMPLE 5

```powershell
# Backup current config, modify, then restore if needed
$currentConfig = Get-ColorScriptConfiguration
Set-ColorScriptConfiguration -CachePath "D:\Cache"
# ... test new configuration ...
# Set-ColorScriptConfiguration -CachePath $currentConfig.CachePath
```

Demonstriert die Sicherung und Wiederherstellung der Konfiguration.

## PARAMETERS

### -CachePath

Gibt den Verzeichnispfad an, in dem die Cache-Dateien von ColorScripts gespeichert werden.

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

Dieses Cmdlet unterstützt die allgemeinen Parameter: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, und -WarningVariable. Weitere Informationen finden Sie unter
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Dieses Cmdlet akzeptiert keine Eingabe aus der Pipeline.

## OUTPUTS

### None

Dieses Cmdlet gibt keine Ausgabe an die Pipeline zurück.

## NOTES

**Autor:** Nick
**Modul:** ColorScripts-Enhanced
**Erfordert:** PowerShell 5.1 oder höher

**Konfigurationspersistenz:**
Einstellungen werden automatisch in benutzerspezifischen Konfigurationsdateien gespeichert und bleiben über PowerShell-Sitzungen hinweg erhalten.

**Pfadauflösung:**
Cache-Pfade unterstützen Umgebungsvariablen, relative Pfade und standardmäßige PowerShell-Pfadnotation.

**Validierung:**
Konfigurationsänderungen werden vor der Anwendung validiert, um ungültige Einstellungen zu verhindern.

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
