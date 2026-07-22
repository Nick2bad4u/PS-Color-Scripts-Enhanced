---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Behalten Sie Änderungen am ColorScripts-Enhanced-Cache und der Startkonfiguration bei.

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Dieser Befehl hat keine Aliase.

## DESCRIPTION

`Set-ColorScriptConfiguration` bietet eine dauerhafte Möglichkeit, das Verhalten und den Speicherort des ColorScripts-Enhanced-Moduls anzupassen. Dieses Cmdlet aktualisiert die Konfigurationsdatei des Moduls und ermöglicht Ihnen die Steuerung verschiedener Aspekte der Skriptwiedergabe und -speicherung.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

Verschiebt den Cache nach `D:/Temp/ColorScriptsCache`, aktiviert die automatische Anzeige beim Modulimport, deaktiviert die automatische Profilanzeige und legt `bars` als Standardskript fest.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

Löscht das Standardskript und gibt das resultierende Konfigurationsobjekt zurück, sodass Sie überprüfen können, ob die Einstellung entfernt wurde.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

Verschiebt den Cache in das Windows-TEMP-Verzeichnis und zeigt die vollständige aktualisierte Konfiguration im Listenformat an. Nützlich für temporäre Testszenarien.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

Deaktiviert das automatische Farbskript-Rendering, wenn das Modul geladen wird. Nützlich, wenn Sie die Anzeige von Skripten lieber manuell steuern möchten.

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

Legt einen Cache-Pfad im Linux/macOS-Stil mithilfe der Tilde-Erweiterung fest und konfiguriert 'crunch' als Standardskript für alle Vorgänge.

## PARAMETERS

### -AutoShowOnImport

Aktivieren oder deaktivieren Sie das automatische Rendern eines Farbskript, wenn das Modul importiert wird. Wenn aktiviert (`$true`), wird beim Modulimport sofort ein Farbskript angezeigt und bietet sofortiges visuelles Feedback. Wenn deaktiviert (`$false`), werden Skripte nur angezeigt, wenn sie explizit aufgerufen werden. Wenn nicht angegeben, bleibt die bestehende Einstellung unverändert.

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

Gibt das Verzeichnis an, in dem gerenderte `.cache`-Nutzlasten und `.cacheinfo`-Validierungs-Sidecars gespeichert werden. Quell-Farbskripte und Modulmetadaten bleiben im installierten Modul. Unterstützt absolute Pfade, relative Pfade (aufgelöst vom aktuellen Speicherort), Umgebungsvariablen (z. B. `$env:USERPROFILE`) und Tilde-Erweiterung (`~`).

Wenn das angegebene Verzeichnis nicht existiert, wird es automatisch mit den entsprechenden Berechtigungen erstellt. Geben Sie ein leeres string (`''`) an, um den benutzerdefinierten Pfad zu löschen und zum plattformspezifischen Standardspeicherort zurückzukehren. Wenn keine Angabe erfolgt, bleibt die vorhandene Cache-Pfadeinstellung erhalten.

**Note**: Durch das Ändern des Cache-Pfads werden vorhandene zwischengespeicherte Dateien nicht automatisch migriert. Möglicherweise müssen Sie Dateien manuell kopieren oder zulassen, dass sie neu generiert werden.

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

Fordert Sie zur Bestätigung auf, bevor Sie das Cmdlet ausführen.

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

Legt den Standardnamen Farbskript fest oder löscht ihn, der von Profilhilfsprogrammen, Funktionen zur automatischen Anzeige und wenn in Befehlen kein Skript explizit angegeben wird, verwendet wird. Dieser sollte mit dem Basisnamen einer Skriptdatei ohne Erweiterung übereinstimmen (z. B. `'bars'`, nicht `'bars.ps1'`).

Geben Sie ein leeres string (`''`) an, um den gespeicherten Standard zu entfernen und zum Standardverhalten auf Modulebene zurückzukehren (normalerweise zufällige Auswahl). Wenn dieser Parameter weggelassen wird, bleibt die aktuelle Standardskripteinstellung unverändert.

Das angegebene Skript muss im Skriptverzeichnis des Moduls vorhanden sein, um erfolgreich verwendet zu werden.

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

Zeigt detaillierte Hilfe für diesen Befehl an, ohne den Vorgang auszuführen.

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

Gibt das aktualisierte Konfigurationsobjekt zurück, nachdem Änderungen vorgenommen wurden. Ohne diesen Schalter arbeitet das Cmdlet im Hintergrund (keine Ausgabe). Das zurückgegebene Objekt hat die gleiche Struktur wie `Get-ColorScriptConfiguration` und kann zur weiteren Verarbeitung überprüft, gespeichert oder an andere Cmdlets weitergeleitet werden.

Nützlich für die Überprüfung, Protokollierung oder Verkettung von Konfigurationsbefehlen.

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

Steuert, ob von `Add-ColorScriptProfile` generierte Profilausschnitte einen automatischen `Show-ColorScript`-Aufruf enthalten. Bei `$true` zeigt der Profilcode bei jedem Shell-Start einen Farbskript an. Bei `$false` lädt das Profil das Modul, zeigt jedoch keine Skripts automatisch an.

Diese Einstellung betrifft nur neu generierten Profilcode; Vorhandene Profiländerungen werden nicht automatisch aktualisiert. Wenn Sie diesen Parameter weglassen, bleibt die aktuelle Einstellung unverändert.

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

Führt den Befehl in einem Modus aus, der nur meldet, was passieren würde, ohne die Aktionen auszuführen.

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

Dieses Cmdlet unterstützt die allgemeinen Parameter:
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Weitere Informationen finden Sie unter
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Dieses Cmdlet akzeptiert keine Pipeline-Eingaben.

## OUTPUTS

### None (2)

Standardmäßig erzeugt dieses Cmdlet keine Ausgabe.

### System.Collections.Hashtable

Wenn `-PassThru` angegeben ist, wird die von `Get-ColorScriptConfiguration` erzeugte verschachtelte Hashtabelle zurückgegeben: Cache-Werte liegen unter `Cache` und Startwerte liegen unter `Startup`.

## NOTES

Die Konfiguration wird erst nach erfolgreicher Validierung und Bestätigung beibehalten. `-WhatIf` führt keine Dateisystem-Schreibvorgänge durch. Verwenden Sie `Get-ColorScriptConfiguration`, um die effektiven Werte und Speicherpfade nach dem Vorgang zu überprüfen.

## RELATED LINKS

- [Onlineversion](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)

