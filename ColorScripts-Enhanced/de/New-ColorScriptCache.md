---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

Erstellen oder aktualisieren Sie Farbskript-Cache-Dateien vorab, um das Rendern zu beschleunigen.

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

`New-ColorScriptCache` rendert die von der Richtlinie ausgewählten rechenintensiven Farbskripte und speichert ihre Ausgabe als UTF-8 ohne Byte Order Mark (BOM). Berechtigte gebündelte Renderer verwenden den isolierten Ausführungspfad des Moduls; parallele Worker sind ab PowerShell 7 verfügbar. Deterministische gebündelte Skripte werden prozessintern gerendert und erstellen keine Cache-Dateien. Die Aliase sind `Update-ColorScriptCache` und `Build-ColorScriptCache`.

Sie können Skripte nach Namen (Platzhalter werden unterstützt), Kategorie oder Tag gezielt ansprechen. Wenn keine Parameter angegeben werden, löst das Cmdlet die Namen in `CachePolicy.psd1` direkt auf, anstatt die gesamte Sammlung aufzulisten. Genaue gebündelte Namen verwenden auch eine direkte Dateisuche. Platzhalter-, Kategorie- und Tag-Anfragen werden nur dann aufgelistet, wenn ihre übereinstimmende Semantik dies erfordert. Explizite nicht aufgelistete Skripte werden mit dem Status `SkippedNotRequired` zurückgegeben, wenn `-PassThru` verwendet wird, und alle veralteten Cache-Dateien für diese Skripte werden entfernt.

Standardmäßig zeigt das Cmdlet den Fortschritt sowie eine kurze Zusammenfassung des Caching-Vorgangs und des effektiven Cache-Verzeichnisses an. Verwenden Sie `-PassThru`, um detaillierte Ergebnisobjekte für jedes Skript zurückzugeben, die Sie programmgesteuert auf Status, Standardausgabe und Fehlerströme untersuchen können. Kombinieren Sie `-Quiet`, um den Fortschritt und die Zusammenfassung vollständig zu unterdrücken, oder `-NoAnsiOutput`, um Nur-Text-Zusammenfassungen ohne ANSI-Farbcodes für Umgebungen auszugeben, die diese nicht unterstützen.

Das Cmdlet überspringt Skripts, deren Cachedateien bereits aktuell sind, sofern Sie nicht `-Force` angeben. Wiederholte Durchläufe validieren die kleine `<name>.cacheinfo`-Begleitmetadatendatei, ohne die gerenderte `<name>.cache`-Nutzlast zu laden. `-Force` erstellt berechtigte Cache-Einträge neu, überschreibt jedoch niemals die Cache-Richtlinie.

Beide Dateien befinden sich in `(Get-ColorScriptConfiguration).Cache.EffectivePath`. Die `.cache`-Datei enthält gerenderte Terminalausgaben; `.cacheinfo` enthält nur Validierungsmetadaten. Eine Begleitmetadatendatei ohne zugehörige Nutzlast ist kein verwendbarer Cache-Eintrag und wird beim nächsten Durchlauf repariert. `Clear-ColorScriptCache -All` entfernt vollständige Einträge und verwaiste Begleitdateien.

Für schnellere Neuerstellungen auf Mehrkernsystemen verwenden Sie den Schalter `-Parallel` zusammen mit dem Parameter `-ThrottleLimit` (oder `-Threads`), um die Worker-Anzahl zu steuern. Das Cmdlet kehrt automatisch zur sequenziellen Ausführung zurück, wenn auf dem aktuellen Host keine parallelen Runspaces erstellt werden können.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Lösen und erwärmen Sie nur die durch die Richtlinie ausgewählten rechnerischen Renderer, ohne jedes Skript aufzulisten, das mit dem Modul geliefert wird. Dies ist das Standardverhalten, wenn keine Parameter angegeben werden.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name Galaxy, 'rose-*'
```

Zwischenspeichern Sie eine Mischung aus exakten Übereinstimmungen und Wildcard-Übereinstimmungen. Es werden nur Übereinstimmungen erstellt, die in `CachePolicy.psd1` enthalten sind. Andere Übereinstimmungen melden `SkippedNotRequired` mit `-PassThru`.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name Galaxy -Force -PassThru | Format-List
```

Erzwingen Sie eine Neuerstellung des geeigneten 'Galaxy'-Cache, auch wenn dieser aktuell ist, und untersuchen Sie das detaillierte Ergebnisobjekt.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Mathematical' -PassThru
```

Bewerten Sie Skripte in der Kategorie `Mathematical`, speichern Sie geeignete Renderer im Cache und geben Sie detaillierte Ergebnisse für jede Übereinstimmung zurück.

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

Erstellen Sie geeignete Caches für Skripte, die entweder mit 'geometric' oder 'colorful' gekennzeichnet sind, neu und erzwingen Sie die Neugenerierung, selbst wenn die Caches aktuell sind.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Mathematical -AsObject | New-ColorScriptCache -PassThru
```

Pipeline-Beispiel: Skripte in der Kategorie `Mathematical` auswerten, alle durch Richtlinien ausgewählten Renderer zwischenspeichern und für jede Übereinstimmung ein Ergebnis zurückgeben.

### EXAMPLE 7

```powershell
# Überprüfen Sie die Cache-Statistiken nach dem Erstellen
$cachePath = (Get-ColorScriptConfiguration).Cache.EffectivePath
$before = @(Get-ChildItem $cachePath -Filter "*.cache" -ErrorAction SilentlyContinue).Count
New-ColorScriptCache
$after = @(Get-ChildItem $cachePath -Filter "*.cache").Count
Write-Host "Zwischengespeicherte Skripte: $before -> $after"
```

Misst das Cache-Wachstum durch Zählen der durch Richtlinien ausgewählten Cache-Dateien vor und nach dem Vorgang.

### EXAMPLE 8

```powershell
# Erstellen Sie einen Cache für häufig verwendete Computer-Renderer
$frequentScripts = @('Galaxy', 'rose-curves', 'wave-interference')
New-ColorScriptCache -Name $frequentScripts -PassThru | Format-Table Name, Status, ExitCode
```

Erstellt Caches für die aufgelisteten Skripte, die unter `CachePolicy.psd1` berechtigt sind; Nicht aufgeführte Namen werden übersprungen.

### EXAMPLE 9

```powershell
# Verwenden Sie die integrierte richtlinienbezogene Fortschrittsanzeige
New-ColorScriptCache -All
```

Zeigt den integrierten Fortschritt für durch Richtlinien ausgewählte Renderer an, ohne alle verfügbaren Skripte manuell zu iterieren.

### EXAMPLE 10

```powershell
# Fehlende oder veraltete Richtlinieneinträge optional aus einem PowerShell-Profil vorwärmen
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Quiet
```

Überprüft durch Richtlinien ausgewählte Einträge, wenn das Profil geladen wird, und erstellt nur fehlende oder veraltete Einträge. Lassen Sie diesen Profilschritt aus, wenn keine Arbeit am Startcache erwünscht ist.

### EXAMPLE 11

```powershell
# Erstellen Sie jeden von der Richtlinie ausgewählten Eintrag für die Bereitstellung neu
New-ColorScriptCache -All -Force -PassThru |
    Select-Object Name, Status |
    Export-Csv "./cache-deployment.csv"
```

Erstellt jeden durch die Richtlinie ausgewählten Cache-Eintrag neu und exportiert die Status in ein Bereitstellungsmanifest.

### EXAMPLE 12

```powershell
# Cache-Build-Fehler finden
New-ColorScriptCache -Name "Galaxy" -Force -PassThru |
    Where-Object Status -eq 'Failed' |
    Select-Object Name, StdErr
```

Identifiziert Caching-Fehler, ohne Richtlinienüberspringungen als Fehler zu behandeln.

### EXAMPLE 13

```powershell
# Zählt die von der Richtlinie ausgewählten Einträge, die durch diesen Lauf aktualisiert wurden
New-ColorScriptCache -All -PassThru |
    Where-Object Status -eq 'Updated' |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

Überprüft jeden durch die Richtlinie ausgewählten Eintrag und zeigt an, wie viele Cache-Nutzlasten durch diesen Lauf aktualisiert wurden.

### EXAMPLE 14

```powershell
New-ColorScriptCache -All -Parallel -Threads 8
```

Erstellen Sie alle von der Richtlinie ausgewählten Caches mithilfe von acht Arbeitsthreads. Das Cmdlet greift automatisch auf die sequenzielle Ausführung zurück, wenn auf dem aktuellen Host keine parallelen Jobs verfügbar sind.

## PARAMETERS

### -All

Lösen Sie jeden Cache-Richtlinieneintrag direkt auf. Es werden nur durch Richtlinien ausgewählte Skripts verarbeitet. Der vollständige Farbskript-Bestand ist nicht aufgeführt.

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

Filtert ausgewertete Skripte nach Metadatenkategorie (ohne Berücksichtigung der Groß- und Kleinschreibung). Mehrere Werte werden als ODER-Filter behandelt. Nur von `CachePolicy.psd1` zugelassene Übereinstimmungen werden zwischengespeichert. Andere Übereinstimmungen melden `SkippedNotRequired` mit `-PassThru`.

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

Fordert Sie zur Bestätigung auf, bevor Sie das Cmdlet ausführen. Nützlich beim Zwischenspeichern einer großen Anzahl von Skripten oder bei Verwendung von `-Force`, um eine versehentliche Cache-Neugenerierung zu verhindern.

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

Erstellen Sie geeignete Cache-Einträge neu, selbst wenn ihre `.cacheinfo`-Validierungsmetadaten angeben, dass sie aktuell sind. `CachePolicy.psd1` wird dadurch nicht überschrieben.

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

Zeigt detaillierte Hilfe für diesen Befehl an, ohne den Vorgang auszuführen.

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

Erweitert die Auswahl zur Bewertung von Pokémon-Skripten. `CachePolicy.psd1` wird dadurch nicht überschrieben. Es können nur in `CacheablePokemonScripts` aufgeführte Pokémon-Namen zwischengespeichert werden, und diese Liste ist derzeit leer.

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

Ein oder mehrere Farbskript-Namen, die für die Zwischenspeicherung ausgewertet werden sollen. Unterstützt Platzhaltermuster (z. B. `aurora-*` und `*-wave`). Übereinstimmende Skripte werden nur zwischengespeichert, wenn sie in `CachePolicy.psd1` aufgeführt sind. Wenn dieser Parameter und alle Filter weggelassen werden, werden nur Richtlinieneinträge aufgelöst und ausgewertet.

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

Deaktivieren Sie die ANSI-Farbsequenzen in der Informationsausgabe. Dies ist in Umgebungen nützlich, in denen keine ANSI-Escape-Codes gerendert werden (z. B. einige CI/CD-Protokolle), während bei Bedarf dennoch die farbige Ausgabe beibehalten wird.

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

Aktivieren Sie den Multithread-Cache-Aufbau. Wenn es angegeben wird, führt das Cmdlet Cache-Jobs über einen Runspace-Pool aus, um die Fertigstellung auf fähigen Systemen zu beschleunigen. In Kombination mit `-ThrottleLimit` (oder dem Alias ​​`-Threads`) verwenden, um die Anzahl gleichzeitiger Worker zu steuern. Wenn Multithreading nicht initialisiert werden kann, greift das Cmdlet automatisch auf die sequenzielle Ausführung zurück.

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

Geben Sie detaillierte Ergebnisobjekte für jeden Cache-Vorgang zurück. Standardmäßig wird nur eine Zusammenfassung angezeigt. Die Ergebnisobjekte umfassen Eigenschaften wie Name, Status, CacheFile, ExitCode, StdOut und StdErr, die eine programmgesteuerte Überprüfung des Caching-Prozesses ermöglichen.

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

Unterdrücken Sie den Fortschritt pro Skript und die Informationszusammenfassungsausgabe. Verwenden Sie diesen Schalter, wenn Sie nur eine strukturierte Ausgabe wünschen (über `-PassThru`) oder wenn Automatisierungsszenarien Informationsmeldungen unterdrücken und dennoch Warnungen und Fehler anzeigen sollen.

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

Filtert ausgewertete Skripte nach Metadaten-Tag (ohne Berücksichtigung der Groß- und Kleinschreibung). Mehrere Werte werden als ODER-Filter behandelt. Nur von `CachePolicy.psd1` zugelassene Übereinstimmungen werden zwischengespeichert. Andere Übereinstimmungen melden `SkippedNotRequired` mit `-PassThru`.

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

Gibt die maximale Anzahl gleichzeitiger Cache-Worker an, wenn `-Parallel` angefordert wird. Akzeptiert Werte von 1 bis 256. Der Standardwert (wenn weggelassen) ist die Anzahl der logischen Prozessoren auf dem aktuellen Computer. Der Einfachheit halber wird der Alias ​​`-Threads` bereitgestellt. Werte kleiner oder gleich eins kehren automatisch zur sequenziellen Ausführung zurück.

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

Zeigt, was passieren würde, wenn das Cmdlet ausgeführt würde, ohne die Caching-Vorgänge tatsächlich auszuführen. Nützlich für die Vorschau, welche Skripte zwischengespeichert werden, bevor der Vorgang ausgeführt wird.

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
Weitere Informationen finden Sie unter
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Sie können Skriptnamen an dieses Cmdlet weiterleiten. Jeder string wird als potenzieller Skriptname behandelt und unterstützt den Platzhalterabgleich.

### System.String[]

Sie können ein Array von Skriptnamen oder Metadatendatensätzen mit einer `Name`-Eigenschaft zur Stapelverarbeitung an dieses Cmdlet weiterleiten.

## OUTPUTS

### System.Object

Wenn `-PassThru` angegeben ist, wird für jedes verarbeitete Skript ein benutzerdefiniertes Objekt zurückgegeben, das die folgenden Eigenschaften enthält:

- **Name**: Der Name Farbskript
- **ScriptPath**: Vollständiger Pfad zur Quelle Farbskript
- **CacheFile**: Vollständiger Pfad zur generierten Cache-Datei
- **Status**: `Updated`, `SkippedUpToDate`, `SkippedNotRequired`, `SkippedByUser` oder `Failed`
- **Message**: Lokalisierte Statusdetails
- **CacheExists**: Ob nach dem Vorgang ein Ausgabecache vorhanden ist
- **ExitCode**: Der Exit-Code der Skriptausführung (0 zeigt Erfolg an)
- **StdOut**: Standardausgabe, die während der Skriptausführung erfasst wird
- **StdErr**: Standardfehlerausgabe, die während der Skriptausführung erfasst wird

Ohne `-PassThru` wird eine kurze Informationszusammenfassung geschrieben, die verarbeitete, aktualisierte, übersprungene und fehlgeschlagene Zählungen sowie das effektive Cache-Verzeichnis enthält.

## NOTES

**Autor:** Nick
**Modul:** ColorScripts-Enhanced

**Aliase:** `Update-ColorScriptCache` und `Build-ColorScriptCache`.

Cache-Dateien werden unter `(Get-ColorScriptConfiguration).Cache.EffectivePath` gespeichert. Quell- und Richtliniensignaturen in Begleitmetadaten werden verwendet, um zu bestimmen, ob ein Eintrag aktuell bleibt.

Das Cmdlet speichert nur Renderer zwischen, die eine Ausführung erfordern und von der Cache-Richtlinie zugelassen werden. Explizite statische oder nicht aufgeführte Skripte werden als `SkippedNotRequired` gemeldet und veraltete Einträge werden entfernt.

## RELATED LINKS

- [Onlineversion](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)

