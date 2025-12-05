---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/de/Reset-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Setzt die ColorScripts-Enhanced-Konfiguration auf Standardwerte zurück.

## SYNTAX

```text
Reset-ColorScriptConfiguration [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Stellt die ColorScripts-Enhanced-Konfigurationssettings auf ihre Standardwerte wieder her. Dieses Cmdlet entfernt alle Benutzeranpassungen und bringt das Modul in seinen ursprünglichen Konfigurationszustand zurück.

Zurücksetzungen umfassen:

- Cache-Pfad-Einstellungen
- Leistungspräferenzen
- Anzeigeoptionen
- Modulverhalten-Einstellungen

Dieses Cmdlet ist nützlich, wenn:

- Die Konfiguration beschädigt wird
- Sie mit Standardeinstellungen neu beginnen möchten
- Probleme im Zusammenhang mit der Konfiguration behoben werden
- Das Modul für saubere Tests vorbereitet wird

Die Zurücksetzungsoperation erfordert standardmäßig eine Bestätigung, um versehentlichen Datenverlust zu verhindern.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration
```

Setzt alle Konfigurationseinstellungen mit Bestätigungsaufforderung auf Standardwerte zurück.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Setzt die Konfiguration ohne Bestätigungsaufforderung zurück.

### EXAMPLE 3

```powershell
Reset-ColorScriptConfiguration -WhatIf
```

Zeigt, welche Konfigurationsänderungen vorgenommen würden, ohne sie anzuwenden.

### EXAMPLE 4

```powershell
# Zurücksetzen und überprüfen
Reset-ColorScriptConfiguration
Get-ColorScriptConfiguration
```

Setzt die Konfiguration zurück und zeigt die neuen Standardeinstellungen an.

## PARAMETERS

### -Confirm

Fordert Sie zur Bestätigung auf, bevor das Cmdlet ausgeführt wird.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: true
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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Dieses Cmdlet akzeptiert keine Eingabe aus der Pipeline.

## OUTPUTS

### None (2)

Dieses Cmdlet gibt keine Ausgabe an die Pipeline zurück.

## NOTES

**Autor:** Nick
**Modul:** ColorScripts-Enhanced
**Erfordert:** PowerShell 5.1 oder höher

## Zurücksetzungsbereich
Setzt alle benutzerkonfigurierbaren Einstellungen auf Modulstandards zurück. Dies umfasst Cache-Pfade, Leistungseinstellungen und Anzeigepräferenzen.

## Datensicherheit
Die Konfigurationszurücksetzung wirkt sich nicht auf zwischengespeicherte Skriptausgaben oder benutzererstellte Farbskripte aus. Nur Konfigurationseinstellungen sind betroffen.

## Wiederherstellung
Nach der Zurücksetzung verwenden Sie Set-ColorScriptConfiguration, um benutzerdefinierte Einstellungen bei Bedarf erneut anzuwenden.

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
