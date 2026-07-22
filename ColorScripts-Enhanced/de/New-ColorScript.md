---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

Erstellen Sie ein Gerüst für eine neue Farbskript-Datei und geben Sie optional Metadatenanweisungen aus.

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

Dieser Befehl hat keine Aliase.

## DESCRIPTION

Das Cmdlet `New-ColorScript` erstellt ein minimales Farbskript-Gerüst, das ein string-Array und eine Schleife enthält, die jede Zeile schreibt. Die Datei ist als UTF-8 ohne Byte-Order-Markierung (BOM) codiert. Optionale Metadatenhinweise können als Kommentar in die generierte Datei eingefügt und im Ergebnisobjekt zurückgegeben werden.

Sowohl `-Name` als auch `-OutputPath` sind beim Gerüstbau zwingend erforderlich. `-OutputPath` identifiziert ein Verzeichnis; Der Befehl erstellt bei Bedarf das Verzeichnis und schreibt darin `<Name>.ps1`.

Skriptnamen müssen den PowerShell-Namenskonventionen entsprechen: Sie müssen mit einem alphanumerischen Zeichen beginnen und dürfen Unterstriche oder Bindestriche enthalten. Die Erweiterung `.ps1` wird automatisch angehängt, wenn sie nicht angegeben wird. Vorhandene Dateien sind vor versehentlichem Überschreiben geschützt, es sei denn, der Schalter `-Force` wird explizit angegeben.

In Kombination mit `-GenerateMetadataSnippet` gibt das Cmdlet eine Anleitung zurück, die den Eintrag beschreibt, der zu `ScriptMetadata.psd1` hinzugefügt werden soll. Die bereitgestellten Kategorie- und Tagwerte werden auch als Arrays für das Ergebnisobjekt zurückgegeben.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -OutputPath ./ColorScripts-Enhanced/Scripts -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

Erstellt `my-spectrum.ps1` im angeforderten Verzeichnis und gibt ein Objekt zurück, das den Dateipfad und die Metadatenanleitung enthält.

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

Erstellt das Gerüst unter einem benutzerdefinierten Verzeichnis (`~/Dev/colorscripts`) und erstellt das Verzeichnis, wenn es nicht vorhanden ist. Wenn an diesem Speicherort bereits eine Datei mit dem Namen `holiday-banner.ps1` vorhanden ist, wird sie aufgrund des Schalters `-Force` überschrieben.

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -OutputPath ./ColorScripts-Enhanced/Scripts -Category 'Artistic' -Tag '80s','Neon' -GenerateMetadataSnippet
$result.MetadataGuidance | Set-Clipboard
```

Erstellt ein neues Farbskript und kopiert die Metadatenführung in die Zwischenablage, sodass sie einfach in `ScriptMetadata.psd1` eingefügt werden kann.

### EXAMPLE 4

```powershell
New-ColorScript -Name 'test-pattern' -OutputPath '.\temp' -WhatIf
```

Zeigt, was passieren würde, wenn ein Testmusterskript im Verzeichnis `.\temp` erstellt würde, ohne die Datei tatsächlich zu erstellen. Nützlich zum Überprüfen von Pfaden und Namen vor der Ausführung.

### EXAMPLE 5

```powershell
# Erstellen Sie mehrere Farbskripte für ein Projekt
$scriptNames = @("company-logo", "team-banner", "status-display")
foreach ($name in $scriptNames) {
    New-ColorScript -Name $name -Category "Corporate" -Tag "Custom" -OutputPath ".\src" | Out-Null
}
Write-Host "$($scriptNames.Count) Farbskriptvorlagen erstellt"
```

Erstellt mehrere Farbskript-Vorlagen im Stapel für ein Projekt.

### EXAMPLE 6

```powershell
# Erstellen und sofort im Editor öffnen
New-ColorScript -Name "my-art" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -GenerateMetadataSnippet -OpenInEditor
```

Erstellt ein Farbskript und fordert den registrierten Handler der Plattform auf, es zu öffnen.

### EXAMPLE 7

```powershell
# Erstellen Sie mit vollständiger Workflow-Automatisierung
$newScript = New-ColorScript -Name "interactive-demo" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Custom" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "Erstellt: $($newScript.Name)"
Write-Host "Pfad: $($newScript.Path)"
Write-Host "Die Metadatenanleitung ist in der Zwischenablage verfügbar"
$newScript.MetadataGuidance | Set-Clipboard
```

Erstellt ein Farbskript mit automatisch in die Zwischenablage kopierter Metadatenführung.

### EXAMPLE 8

```powershell
# Überprüfen Sie die Konventionen für Skriptnamen
$validName = "123-start"
$invalidNames = @("-invalid", "_underscore-only", "contains space")
foreach ($name in $invalidNames) {
    try {
        New-ColorScript -Name $name -OutputPath ./temp -WhatIf -ErrorAction Stop
    } catch {
        Write-Warning "Ungültiger Name '$name': $_"
    }
}
```

Demonstriert die Validierung der Namenskonvention für Farbskripte.

### EXAMPLE 9

```powershell
# An einem tragbaren Ort zur Verteilung erstellen
$portableDir = Join-Path $PSScriptRoot "colorscripts"
$scaffold = New-ColorScript -Name "portable-art" -OutputPath $portableDir -GenerateMetadataSnippet
Write-Host "Portables Farbskript erstellt unter: $($scaffold.Path)"
```

Erstellt Farbskripte an einem tragbaren Speicherort relativ zum aktuellen Skript.

### EXAMPLE 10

```powershell
# Erstellen Sie mit Kategorie- und Tag-Validierung
$categories = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Category -Unique
if ("Retro" -in $categories) {
    New-ColorScript -Name "retro-party" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -Tag "Fun","Social"
} else {
    Write-Warning "Die Kategorie Retro wurde nicht gefunden"
}
```

Überprüft, ob eine Kategorie vorhanden ist, bevor ein neues Farbskript erstellt wird.

## PARAMETERS

### -Category

Gibt eine oder mehrere Kategorien an, die mit dem Gerüst zurückgegeben und in die Metadatenanleitung einbezogen werden. Die Werte sollten mit den bereits in `ScriptMetadata.psd1` verwendeten Kategorien übereinstimmen.

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

### -Force

Überschreibt die Zieldatei, falls diese bereits vorhanden ist. Ohne diesen Schalter wird das Cmdlet mit einem Fehler beendet, wenn am Zielspeicherort eine Datei mit demselben Namen gefunden wird. Gehen Sie vorsichtig vor, um Datenverlust zu vermeiden.

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

Enthält einen Anleitungsausschnitt in der Ausgabe, der zeigt, wie das neue Skript in `ScriptMetadata.psd1` registriert wird. Das Snippet verwendet die Werte der Parameter `-Category` und `-Tag`, sofern angegeben. Dies ist besonders nützlich, um konsistente Metadaten für alle Farbskripte im Modul aufrechtzuerhalten.

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

Zeigt detaillierte Hilfe für diesen Befehl an, ohne den Vorgang auszuführen.

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

Gibt den Namen des neuen Farbskript an. Der Name muss mit einem alphanumerischen Zeichen beginnen und kann Unterstriche oder Bindestriche enthalten. Die Erweiterung `.ps1` wird automatisch angehängt, wenn sie nicht enthalten ist. Dieser Name wird als Dateiname verwendet und sollte den Inhalt oder das Thema des Skripts beschreiben.

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

Öffnet das generierte Farbskript mit dem von der Umgebung konfigurierten Befehl, wenn die Erstellung erfolgreich ist.

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

Gibt das obligatorische Zielverzeichnis an. Der Befehl erstellt in diesem Verzeichnis <Name>.ps1.

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

Gibt ein oder mehrere Metadaten-Tags für Farbskript an. Tags bieten zusätzliche Klassifizierungen über die primäre Kategorie hinaus und sind nützlich zum Filtern und Suchen. Zu den gängigen Tags gehören Themenbeschreibungen wie 'Minimal', 'Colorful', 'Animated', Technologiereferenzen wie 'Matrix', 'ASCII' oder kontextbezogene Markierungen wie 'Holiday', 'Season'. Mehrere Tags können als durch Kommas getrenntes Array angegeben werden.

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

Zeigt, was passieren würde, wenn das Cmdlet ausgeführt würde, ohne tatsächlich Aktionen auszuführen. Zeigt den zu erstellenden Dateipfad und alle durchzuführenden Validierungsprüfungen an. Das Cmdlet erstellt keine Dateien oder Verzeichnisse, wenn dieser Schalter angegeben ist.

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

Sie können keine Objekte an dieses Cmdlet weiterleiten.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Das Cmdlet gibt ein benutzerdefiniertes Objekt mit den folgenden Eigenschaften zurück:

- **Name**: Der Name Farbskript ohne die Erweiterung `.ps1`
- **Path**: Der vollständige Pfad zur generierten Datei
- **Categories**: Das angegebene Array von Kategoriewerten (falls vorhanden)
- **Tags**: Das Array der angegebenen Tag-Werte (falls vorhanden)
- **MetadataGuidance**: Der Metadaten-Snippet-Text (nur wenn -GenerateMetadataSnippet verwendet wird)

## NOTES

**Kodierung**: Das Gerüst ist mit der UTF-8-Kodierung ohne Byte-Order-Mark (BOM) geschrieben, um die Kompatibilität zwischen verschiedenen Plattformen und Editoren sicherzustellen.

**Vorlagenstruktur**: Die generierte Vorlage enthält:

- Ein Gerüstkommentar
– Ein string-Array-Platzhalter für die Grafik
- Eine Schleife, die jede Zeile mit `Write-Host` schreibt

**Metadaten-Integration**: Während das Cmdlet Metadaten-Anleitungen generieren kann, müssen Sie das Snippet manuell zu `ScriptMetadata.psd1` hinzufügen, um das Skript vollständig in das Erkennungs- und Kategorisierungssystem des Moduls zu integrieren.

**Entwicklungsworkflow**:

1. Verwenden Sie `New-ColorScript`, um das Gerüst zu erstellen
2. Bearbeiten Sie die generierte .ps1-Datei, um Ihr ANSI-Kunstwerk hinzuzufügen
3. Wenn eine Metadatenanleitung generiert wurde, kopieren Sie sie nach `ScriptMetadata.psd1`
4. Testen Sie Ihr Skript mit `Show-ColorScript -Name <your-script-name>`

**Bewährte Verfahren**:

- Wählen Sie aussagekräftige Namen mit Bindestrich, die das Thema des Drehbuchs klar verdeutlichen
- Verwenden Sie konsistente Kategoriewerte, die mit vorhandenen Skripten übereinstimmen
- Wenden Sie mehrere Tags an, um die Auffindbarkeit zu verbessern
- Testen Sie Skripte in verschiedenen Terminalumgebungen, um die Kompatibilität sicherzustellen

## RELATED LINKS

- [Onlineversion](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)

