---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

Erstellt Cache für die Leistungsoptimierung von ColorScripts vorab.

## SYNTAX

### Selection (Default)

```
New-ColorScriptCache [-Name <string[]>] [-Force] [-PassThru] [-Category <string[]>]
 [-Tag <string[]>] [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon]
 [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Category <string[]>] [-Tag <string[]>]
 [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon] [-WhatIf] [-Confirm]
```

## ALIASES

- `Build-ColorScriptCache`
- `Update-ColorScriptCache`

## DESCRIPTION

Generiert vorab gecachte Ausgaben für rechenintensive ColorScripts, um optimale Leistung bei der ersten Anzeige zu gewährleisten. Nur die in `CachePolicy.psd1` aufgeführten Renderer werden ausgeführt und gespeichert. Statische und nicht aufgeführte Skripte werden mit `SkippedNotRequired` übersprungen; veraltete Cachedateien für diese Skripte werden entfernt.

Das Caching-System speichert nur die in `CachePolicy.psd1` ausgewählten Renderer. Gecachte Inhalte werden automatisch ungültig, wenn Quellskripte geändert werden. `-Force` erstellt nur berechtigte Cacheeinträge neu und überschreibt niemals die Richtlinie. Ein fester Leistungsfaktor wird nicht garantiert.

Verwenden Sie dieses Cmdlet, um:

- Cache für häufig verwendete Skripte vorzubereiten
- Konsistente Leistung über Sitzungen hinweg zu gewährleisten
- Cache nach Modul-Updates vorzuwärmen
- Startleistung zu optimieren

Das Cmdlet unterstützt selektives Caching nach Name, Kategorie oder Tags, was eine gezielte Cache-Vorbereitung ermöglicht.

Standardmäßig wird eine zusammenfassende Statusmeldung ausgegeben. Nutzen Sie `-PassThru`, um detaillierte Ergebnisobjekte zu erhalten, `-Quiet`, um die Zusammenfassung zu unterdrücken, oder `-NoAnsiOutput`, um das Resümee ohne ANSI-Farbcodes für Protokolle oder Headless-Umgebungen anzuzeigen.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Wertet alle verfügbaren ColorScripts aus und erstellt nur für die durch `CachePolicy.psd1` ausgewählten Renderer Cacheeinträge.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name "Galaxy", "rose-curves"
```

Cached bestimmte ColorScripts nach Namen.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Category Nature
```

Wertet alle naturthematischen ColorScripts aus und erstellt Cacheeinträge nur für berechtigte Renderer.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Tag animated
```

Wertet alle als "animated" getaggten ColorScripts aus und cached nur berechtigte Renderer.

### EXAMPLE 5

```powershell
# Cache scripts for startup optimization
New-ColorScriptCache -Category Geometric -Tag minimal
```

Bereitet Cache für leichte geometrische Skripte vor, die ideal für schnelle Startanzeigen sind.

## PARAMETERS

### -All

Wertet alle verfügbaren Skripte gegen die Cache-Richtlinie aus. Nur ausgewählte Skripte werden gecached; statische und nicht aufgeführte Skripte werden übersprungen. Kann nicht zusammen mit `-Name` verwendet werden.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Category

Filtert die zu cachenden Skripte anhand ihrer Kategorien. Mehrere Kategorien können angegeben werden.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Fordert eine Benutzerbestätigung an, bevor die Cache-Erstellung startet.

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

Erzwingt eine Neuerstellung berechtigter Cacheeinträge selbst dann, wenn bestehende Dateien aktuell sind. Die Cache-Richtlinie wird nicht überschrieben.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

### -IncludePokemon

Bezieht alle Pokémon-Skripte (Standard und Shiny) in den Cacheaufbau ein. Standardmäßig werden Pokémon-Skripte ausgeschlossen; verwenden Sie `-IncludePokemon`, um sie einzubeziehen. Hinweis: Dieser Schalter ersetzt das ältere `-ExcludePokemon` — die Bedeutung wurde durch Refactoring umgekehrt (jetzt opt-in).

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Definiert die Skriptnamen oder Wildcard-Muster, die gecached werden sollen. Unterstützt Pipelineeingaben und Objekte mit einer `Name`-Eigenschaft.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAnsiOutput

Deaktiviert ANSI-Farbsequenzen in der Zusammenfassung und liefert reinen Text.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- NoColor
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Parallel

Aktiviert parallele Ausführung mit mehreren Runspaces. In Hosts ohne Unterstützung fällt das Cmdlet automatisch auf sequentielle Verarbeitung zurück.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Gibt detaillierte Ergebnisobjekte für jedes Skript an die Pipeline zurück. Ohne diesen Schalter wird nur eine Zusammenfassung geschrieben.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Quiet

Unterdrückt die abschließende Statusmeldung nach dem Cache-Aufbau.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

Filtert anhand von Tags. Nur Skripte mit passenden Metadaten werden gecached.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ThrottleLimit

Legt die maximale Anzahl paralleler Worker fest. Gültiger Bereich: 1 bis 256. Aliase: `Threads`.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Threads
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Selection
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

Zeigt an, was passieren würde, ohne den Cache tatsächlich zu erstellen.

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

### System.String

Sie können Skriptnamen als Zeichenfolgen per Pipeline übergeben.

### System.String[]

Arrays von Skriptnamen sind ebenfalls erlaubt, z. B. aus `Get-ColorScriptList`.

### System.Management.Automation.PSObject

Objekte mit einer `Name`-Eigenschaft werden automatisch ausgewertet und in die Cache-Warteschlange aufgenommen.

## OUTPUTS

### System.Object

Mit `-PassThru` gibt das Cmdlet strukturierte Objekte mit Status, ExitCode, Cachepfad und Diagnoseinformationen zurück. Ohne den Schalter wird nur eine optionale Zusammenfassung geschrieben.
Vorab-Caching eliminiert die Ausführungszeit bei der ersten Anzeige und bietet sofortiges visuelles Feedback. Besonders vorteilhaft für komplexe oder animierte Skripte.

**Cache-Verwaltung:**
Gecachte Dateien werden in modulverwalteten Verzeichnissen gespeichert und automatisch ungültig gemacht, wenn Quellskripte geändert werden. Verwenden Sie Clear-ColorScriptCache, um veralteten Cache zu entfernen.

**Bewährte Praktiken:**

- Cache häufig verwendete Skripte für optimale Leistung
- Verwenden Sie selektives Caching, um unnötige Verarbeitung zu vermeiden
- Führen Sie nach Modul-Updates aus, um die Cache-Gültigkeit zu gewährleisten

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced

**Aliases:** This cmdlet can also be called using the alias `Update-ColorScriptCache`, which is useful for scripts that refresh existing caches.

Cache files are stored in the directory exposed by the module's `CacheDir` variable (typically within the module's data directory).
A successful build sets the cache file's timestamp to match the script's last write time, enabling subsequent runs to skip unchanged scripts efficiently.

The cmdlet executes each script in an isolated background PowerShell process to capture its output without affecting the current session.
This ensures accurate caching of the exact console output that would be displayed when running the script directly.

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)
