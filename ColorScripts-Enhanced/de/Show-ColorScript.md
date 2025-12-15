---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/de/Show-ColorScript.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Show-ColorScript

## SYNOPSIS

Zeigt ein Farbskript mit automatischem Caching für verbesserte Leistung an.

## SYNTAX

### Random (Default)

```text
Show-ColorScript [-Random] [-NoCache] [-Category <String[]>] [-Tag <String[]>]
 [-ExcludeCategory <String[]>] [-IncludePokemon] [-PassThru]
 [-ReturnText] [<CommonParameters>]
```

### Named

```text
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <String[]>] [-IncludePokemon] [-PassThru]
 [-ReturnText] [<CommonParameters>]
```

### List

```text
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <String[]>] [-IncludePokemon] [-ReturnText]
 [<CommonParameters>]
```

### All

```text
Show-ColorScript [-All] [-WaitForInput] [-NoCache] [-Category <String[]>] [-Tag <String[]>]
 [-ExcludeCategory <String[]>] [-IncludePokemon]
 [<CommonParameters>]
```

## DESCRIPTION

Rendert schöne ANSI-Farbskripte in Ihrem Terminal mit intelligenter Leistungsoptimierung. Das Cmdlet bietet vier primäre Betriebsmodi:

**Random Mode (Default):** Zeigt ein zufällig ausgewähltes Farbskript aus der verfügbaren Sammlung an. Dies ist das Standardverhalten, wenn keine Parameter angegeben werden.

**Named Mode:** Zeigt ein bestimmtes Farbskript nach Namen an. Unterstützt Platzhaltermuster für flexible Übereinstimmung. Wenn mehrere Skripte einem Muster entsprechen, wird die erste Übereinstimmung in alphabetischer Reihenfolge ausgewählt.

**List Mode:** Zeigt eine formatierte Liste aller verfügbaren Farbskripte mit ihren Metadaten an, einschließlich Name, Kategorie, Tags und Beschreibungen.

**All Mode:** Durchläuft alle verfügbaren Farbskripte in alphabetischer Reihenfolge. Besonders nützlich, um die gesamte Sammlung zu präsentieren oder neue Skripte zu entdecken.

## Performance Features
Das Caching-System bietet 6-19x Leistungsverbesserungen. Bei der ersten Ausführung läuft ein Farbskript normal und seine Ausgabe wird zwischengespeichert. Nachfolgende Anzeigen verwenden die zwischengespeicherte Ausgabe für nahezu sofortiges Rendering. Der Cache wird automatisch ungültig, wenn Quellskripte geändert werden, um Ausgabegenauigkeit zu gewährleisten.

## Filtering Capabilities
Filtern Sie Skripte nach Kategorie oder Tags vor der Auswahl. Dies gilt für alle Modi und ermöglicht die Arbeit mit Teilmengen der Sammlung (z. B. nur naturthematische Skripte oder Skripte, die als "retro" getaggt sind).

## Output Options
Standardmäßig werden Farbskripte direkt in die Konsole geschrieben für sofortige visuelle Anzeige. Verwenden Sie `-ReturnText`, um die gerenderte Ausgabe an die Pipeline zu senden, um sie zu erfassen, umzuleiten oder weiterzuverarbeiten. Verwenden Sie `-PassThru`, um das Metadatenobjekt des Skripts für programmatische Verwendung zu erhalten.

## NERD FONT GLYPHS

Einige Skripte zeigen Nerd Font-Symbole an (Entwicklerglyphen, Powerline-Trennzeichen, Häkchen). Installieren Sie eine gepatchte Schriftart, damit diese Zeichen korrekt dargestellt werden:

1. Laden Sie eine Schriftart von https://www.nerdfonts.com/ herunter (beliebte Auswahl: Cascadia Code, JetBrainsMono, FiraCode).

2. Windows: Extrahieren Sie die `.zip`, wählen Sie die `.ttf`-Dateien aus, Rechtsklick → **Für alle Benutzer installieren**.

   macOS: `brew install --cask font-caskaydia-cove-nerd-font` oder über Font Book hinzufügen.

   Linux: Kopieren Sie `.ttf`-Dateien nach `~/.local/share/fonts` (oder `/usr/local/share/fonts`) und führen Sie `fc-cache -fv` aus.

3. Stellen Sie Ihr Terminalprofil so ein, dass es die installierte Nerd Font verwendet.

4. Überprüfen Sie Glyphen mit:

```powershell
Show-ColorScript -Name nerd-font-test
```

## EXAMPLES

#### Beispiel 1: Zufälliges Farbskript beim Start

```powershell
# In Ihrer $PROFILE-Datei:
Import-Module ColorScripts-Enhanced
Show-ColorScript
```

#### Beispiel 2: Tägliches anderes Farbskript

```powershell
# Verwenden Sie das Datum als Seed für konsistentes tägliches Skript
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript
```

#### Beispiel 3: Cache für bevorzugte Skripte erstellen

```powershell
New-ColorScriptCache -Name hearts,mandelbrot-zoom,galaxy-spiral
```

#### Beispiel 4: Cache-Neuerstellung erzwingen

```powershell
New-ColorScriptCache -Force
```

## PARAMETERS

### -All

Durchläuft alle verfügbaren Farbskripte in alphabetischer Reihenfolge. Wenn allein angegeben, werden Skripte kontinuierlich mit einer kurzen automatischen Verzögerung angezeigt. Kombinieren Sie mit `-WaitForInput`, um die Fortsetzung durch die Sammlung manuell zu steuern. Dieser Modus ist ideal, um die gesamte Bibliothek zu präsentieren oder neue Favoriten zu entdecken.

```yaml
Type: SwitchParameter
DefaultValue: False
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
HelpMessage: ""
```

### -Category

Filtert die verfügbare Skriptsammlung nach einer oder mehreren Kategorien, bevor eine Auswahl oder Anzeige erfolgt. Kategorien sind typischerweise breite Themen wie "Nature", "Abstract", "Art", "Retro" usw. Mehrere Kategorien können als Array angegeben werden. Dieser Parameter funktioniert in Verbindung mit allen Modi (Random, Named, List, All), um den Arbeitsbereich einzugrenzen.

```yaml
Type: System.String[]
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

### -List

Zeigt eine formatierte Liste aller verfügbaren Farbskripte mit ihren zugehörigen Metadaten an. Die Ausgabe enthält Skriptname, Kategorie, Tags und Beschreibung. Dies ist nützlich, um verfügbare Optionen zu erkunden und die Organisation der Sammlung zu verstehen. Kann mit `-Category` oder `-Tag` kombiniert werden, um nur gefilterte Teilmengen aufzulisten.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: List
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Name

Der Name des anzuzeigenden Farbskripts (ohne die .ps1-Erweiterung). Unterstützt Platzhaltermuster (\* und ?) für flexible Übereinstimmung. Wenn mehrere Skripte einem Platzhaltermuster entsprechen, wird die erste Übereinstimmung in alphabetischer Reihenfolge ausgewählt und angezeigt. Verwenden Sie `-PassThru`, um zu überprüfen, welches Skript bei Verwendung von Platzhaltern ausgewählt wurde.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
 - Name: Named
   Position: 0
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -NoCache

Umgeht das Caching-System und führt das Farbskript direkt aus. Dies erzwingt eine frische Ausführung und kann nützlich sein, wenn Skriptänderungen getestet, Fehler behoben oder Cache-Korruption vermutet wird. Ohne diesen Schalter wird zwischengespeicherte Ausgabe verwendet, wenn verfügbar, für optimale Leistung.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -PassThru

Gibt das Metadatenobjekt des ausgewählten Farbskripts zusätzlich zur Anzeige des Farbskripts an die Pipeline zurück. Das Metadatenobjekt enthält Eigenschaften wie Name, Pfad, Kategorie, Tags und Beschreibung. Dies ermöglicht programmatischen Zugriff auf Skriptinformationen für Filterung, Protokollierung oder weitere Verarbeitung, während die visuelle Ausgabe weiterhin gerendert wird.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Random
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
 - Name: Named
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Random

Fordert explizit eine zufällige Farbskriptauswahl an. Dies ist das Standardverhalten, wenn kein Name angegeben wird, daher ist dieser Schalter hauptsächlich nützlich für Klarheit in Skripten oder wenn Sie explizit über den Auswahlmodus sein möchten. Kann mit `-Category` oder `-Tag` kombiniert werden, um innerhalb einer gefilterten Teilmenge zu randomisieren.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: Random
   Position: Named
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -ReturnText

Gibt das gerenderte Farbskript als Zeichenfolge an die PowerShell-Pipeline aus, anstatt direkt in den Konsolenhost zu schreiben. Dies ermöglicht das Erfassen der Ausgabe in einer Variablen, die Umleitung in eine Datei oder die Weiterleitung an andere Befehle. Die Ausgabe behält alle ANSI-Escape-Sequenzen bei, sodass sie bei späterer Ausgabe in einem kompatiblen Terminal mit richtigen Farben angezeigt wird.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
 - AsString
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

### -Tag

Filtert die verfügbare Skriptsammlung nach Metadaten-Tags (Groß-/Kleinschreibung wird nicht beachtet). Tags sind spezifischere Deskriptoren als Kategorien, wie "geometric", "retro", "animated", "minimal" usw. Mehrere Tags können als Array angegeben werden. Skripte, die einem der angegebenen Tags entsprechen, werden in den Arbeitsbereich aufgenommen, bevor die Auswahl erfolgt.

```yaml
Type: System.String[]
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

### -WaitForInput

Bei Verwendung mit `-All` wird nach der Anzeige jedes Farbskripts angehalten und auf Benutzereingabe gewartet, bevor fortgefahren wird. Drücken Sie die Leertaste, um zum nächsten Skript in der Sequenz zu gelangen. Drücken Sie 'q', um die Sequenz frühzeitig zu beenden und zur Eingabeaufforderung zurückzukehren. Dies bietet eine interaktive Browsing-Erfahrung durch die gesamte Sammlung.

```yaml
Type: SwitchParameter
DefaultValue: False
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
HelpMessage: ""
```

### CommonParameters

Dieses Cmdlet unterstützt die allgemeinen Parameter: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. Weitere Informationen finden Sie unter
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Sie können Farbskriptnamen an Show-ColorScript weiterleiten. Dies ermöglicht pipelinebasierte Workflows, bei denen Skriptnamen von anderen Befehlen generiert oder gefiltert werden.

## OUTPUTS

### System.Object

Wenn `-PassThru` angegeben ist, wird das Metadatenobjekt des ausgewählten Farbskripts zurückgegeben, das Eigenschaften wie Name, Pfad, Kategorie, Tags und Beschreibung enthält.

### System.String (2)

Wenn `-ReturnText` angegeben ist, wird das gerenderte Farbskript als Zeichenfolge an die Pipeline ausgegeben. Diese Zeichenfolge enthält alle ANSI-Escape-Sequenzen für korrekte Farbdarstellung bei Anzeige in einem kompatiblen Terminal.

### None

Bei Standardbetrieb (ohne `-PassThru` oder `-ReturnText`) wird die Ausgabe direkt in den Konsolenhost geschrieben und nichts an die Pipeline zurückgegeben.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## Performance
Das intelligente Caching-System bietet 6-19x Leistungsverbesserungen gegenüber direkter Ausführung. Cache-Dateien werden in einem modulverwalteten Verzeichnis gespeichert und werden automatisch ungültig, wenn Quellskripte geändert werden, um Genauigkeit zu gewährleisten.

## Cache Management

- Cache-Speicherort: Verwenden Sie `(Get-Module ColorScripts-Enhanced).ModuleBase` und suchen Sie nach dem Cache-Verzeichnis
- Cache löschen: Verwenden Sie `Clear-ColorScriptCache`, um von Grund auf neu zu erstellen
- Cache neu erstellen: Verwenden Sie `New-ColorScriptCache`, um den Cache für alle Skripte vorab zu füllen
- Cache überprüfen: Cache-Dateien sind Klartext und können direkt angezeigt werden

## Tips

- Fügen Sie `Show-ColorScript -Random` zu Ihrem PowerShell-Profil hinzu, um bei jedem Sitzungsstart einen farbenfrohen Gruß zu erhalten
- Verwenden Sie den Modulalias 'scs' für schnellen Zugriff: `scs -Random`
- Kombinieren Sie Kategorie- und Tag-Filter für präzise Auswahl
- Verwenden Sie `-List`, um neue Skripte zu entdecken und mehr über ihre Themen zu erfahren
- Die Kombination `-All -WaitForInput` ist perfekt, um die Sammlung anderen zu präsentieren

## Compatibility
Farbskripte verwenden ANSI-Escape-Sequenzen und werden am besten in Terminals mit voller Farbuntersützung angezeigt, wie Windows Terminal, ConEmu oder moderne Unix-Terminals.

## ADVANCED USAGE

#### Building Cache for Specific Categories

Alle Skripte in der Geometric-Kategorie für optimale Leistung cachen:

```powershell
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object { New-ColorScriptCache -Name $_.Name }
```

#### Performance Measurement

Messen Sie die Leistungsverbesserung durch Caching:

```powershell
# Ungecachte Leistung (Kaltstart)
Remove-Module ColorScripts-Enhanced -ErrorAction SilentlyContinue
$uncached = Measure-Command {
    Import-Module ColorScripts-Enhanced
    Show-ColorScript -Name "mandelbrot-zoom" -NoCache
}

# Gecachte Leistung (Warmstart)
$cached = Measure-Command {
    Show-ColorScript -Name "mandelbrot-zoom"
}

Write-Host "Uncached: $($uncached.TotalMilliseconds)ms"
Write-Host "Cached: $($cached.TotalMilliseconds)ms"
Write-Host "Speedup: $([math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 1))x"
```

#### Automation: Display Different Script Daily

Richten Sie Ihr Profil ein, um täglich ein anderes Skript anzuzeigen:

```powershell
# In Ihrer $PROFILE-Datei:
$seed = (Get-Date).DayOfYear
[System.Random]::new($seed).Next()
Get-Random -SetSeed $seed
Show-ColorScript
```

#### Pipeline Operations with Metadata

Exportieren Sie ColorScript-Metadaten zur Verwendung in anderen Tools:

```powershell
# Export nach JSON für Web-Dashboard
Export-ColorScriptMetadata -Path ./dist/colorscripts.json -IncludeFileInfo

# Skripte nach Kategorie zählen
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending

# Skripte mit bestimmten Schlüsselwörtern finden
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

#### Cache Management for CI/CD Environments

Konfigurieren und verwalten Sie Cache für automatisierte Bereitstellungen:

```powershell
# Temporären Cache-Speicherort für CI/CD festlegen
Set-ColorScriptConfiguration -CachePath $env:TEMP\colorscripts-cache

# Cache für Bereitstellung vorab erstellen
$productionScripts = @('bars', 'arch', 'ubuntu', 'windows', 'rainbow-waves')
New-ColorScriptCache -Name $productionScripts -Force

# Cache-Gesundheit überprüfen
$cacheDir = (Get-ColorScriptConfiguration).Cache.Path
Get-ChildItem $cacheDir -Filter "*.cache" | Measure-Object -Sum Length
```

#### Filtering and Display Workflows

Erweiterte Filterung für angepasste Anzeigen:

```powershell
# Alle empfohlenen Skripte mit Details anzeigen
Get-ColorScriptList -Tag Recommended -Detailed

# Geometrische Skripte mit deaktiviertem Caching für Tests anzeigen
Get-ColorScriptList -Category Geometric -Name "aurora-*" -AsObject |
    ForEach-Object { Show-ColorScript -Name $_.Name -NoCache }

# Metadaten nach Kategorie gefiltert exportieren
Export-ColorScriptMetadata -IncludeFileInfo |
    Where-Object { $_.Category -eq 'Animated' } |
    ConvertTo-Json |
    Out-File "./animated-scripts.json"
```

## NOTES (2)

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 or later

## Performance (2)
Das intelligente Caching-System bietet 6-19x Leistungsverbesserungen gegenüber direkter Ausführung. Cache-Dateien werden in einem modulverwalteten Verzeichnis gespeichert und werden automatisch ungültig, wenn Quellskripte geändert werden, um Genauigkeit zu gewährleisten.

## Cache Management (2)

- Cache-Speicherort: Verwenden Sie `(Get-Module ColorScripts-Enhanced).ModuleBase` und suchen Sie nach dem Cache-Verzeichnis
- Cache löschen: Verwenden Sie `Clear-ColorScriptCache`, um von Grund auf neu zu erstellen
- Cache neu erstellen: Verwenden Sie `New-ColorScriptCache`, um den Cache für alle Skripte vorab zu füllen
- Cache überprüfen: Cache-Dateien sind Klartext und können direkt angezeigt werden

## Advanced Tips

- Verwenden Sie `-PassThru`, um Metadaten während der Anzeige für Nachbearbeitung zu erhalten
- Kombinieren Sie `-ReturnText` mit Pipeline-Befehlen für erweiterte Textmanipulation
- Verwenden Sie `-NoCache` während der Entwicklung benutzerdefinierter Farbskripte für sofortiges Feedback
- Filtern Sie nach mehreren Kategorien/Tags für präzisere Auswahl
- Speichern Sie häufig verwendete Skripte in Variablen für schnellen Zugriff
- Verwenden Sie `-List` mit `-Category` und `-Tag`, um verfügbare Inhalte zu erkunden
- Überwachen Sie Cache-Treffer mit Leistungsmessungen
- Berücksichtigen Sie Terminalfunktionen bei der Skriptauswahl
- Verwenden Sie Umgebungsvariablen, um das Verhalten pro Umgebung anzuzupassen
- Implementieren Sie Fehlerbehandlung für automatisierte Anzeigeszenarien

## Terminal Compatibility Matrix

| Terminal           | ANSI Support | UTF-8     | Performance | Notes                      |
| ------------------ | ------------ | --------- | ----------- | -------------------------- |
| Windows Terminal   | ✓ Excellent  | ✓ Full    | Excellent   | Recommended                |
| ConEmu             | ✓ Good       | ✓ Full    | Good        | Legacy but reliable        |
| VS Code            | ✓ Good       | ✓ Full    | Very Good   | Slight rendering delay     |
| PowerShell ISE     | ✗ Limited    | ✗ Limited | N/A         | Not recommended            |
| SSH Terminal       | ✓ Varies     | ✓ Depends | Varies      | Network latency may affect |
| Windows 10 Console | ✗ No         | ✓ Yes     | N/A         | Not recommended            |

### TROUBLESHOOTING

#### Scripts not displaying correctly

Stellen Sie sicher, dass Ihr Terminal UTF-8 und ANSI-Escape-Codes unterstützt:

```powershell
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
```

#### Cache not working

Cache leeren und neu aufbauen:

```powershell
Clear-ColorScriptCache -All
New-ColorScriptCache
```

#### Performance issues

Der erste Lauf jedes Skripts wird langsamer sein, da es den Cache aufbaut. Alle Caches vorab aufbauen:

```powershell
New-ColorScriptCache
```

### PERFORMANCE (3)

Typische Leistungsverbesserungen mit Caching:

| Script Type | Without Cache | With Cache | Speedup |
| ----------- | ------------- | ---------- | ------- |
| Simple      | ~50ms         | ~8ms       | 6x      |
| Medium      | ~150ms        | ~12ms      | 12x     |
| Complex     | ~300ms        | ~16ms      | 19x     |

### SCRIPT CATEGORIES

Das Modul enthält Skripte in verschiedenen Kategorien:

- **Geometric**: mandelbrot-zoom, apollonian-circles, sierpinski-carpet
- **Nature**: galaxy-spiral, aurora-bands, crystal-drift
- **Artistic**: kaleidoscope, rainbow-waves, prismatic-rain
- **Gaming**: doom, pacman, space-invaders
- **System**: colortest, nerd-font-test, terminal-benchmark
- **Logos**: arch, debian, ubuntu, windows

### ENVIRONMENT VARIABLES

Das Modul berücksichtigt die folgenden Umgebungsvariablen:

- **COLORSCRIPTS_CACHE**: Überschreibt den Standard-Cache-Speicherort
- **PSModulePath**: Beeinflusst, wo das Modul gefunden wird

### PERFORMANCE TUNING

#### Typische Leistungsmetriken

| Skriptkomplexität   | Ohne Cache | Mit Cache | Verbesserung  |
| ------------------- | ---------- | --------- | ------------- |
| Einfach (50-100ms)  | ~50ms      | ~8ms      | 6x schneller  |
| Mittel (100-200ms)  | ~150ms     | ~12ms     | 12x schneller |
| Komplex (200-300ms) | ~300ms     | ~16ms     | 19x schneller |

#### Cache-Größeninformationen

- Durchschnittliche Cache-Dateigröße: 2-50KB pro Skript
- Gesamt-Cache-Größe für alle Skripte: ~2-5MB
- Cache-Speicherort: Verwendet betriebssystemgerechte Pfade für minimalen Fußabdruck

### TROUBLESHOOTING ADVANCED ISSUES

#### Modul nicht gefunden Fehler

```powershell
# Überprüfen, ob das Modul in PSModulePath ist
Get-Module ColorScripts-Enhanced -ListAvailable

# Verfügbare Modulpfade auflisten
$env:PSModulePath -split ';'

# Bei Bedarf von explizitem Pfad importieren
Import-Module "C:\Path\To\ColorScripts-Enhanced\ColorScripts-Enhanced.psd1"
```

#### Cache-Korruption

Vollständig löschen und neu aufbauen:

```powershell
# Modul aus Sitzung entfernen
Remove-Module ColorScripts-Enhanced -Force

# Alle Cache-Dateien löschen
Clear-ColorScriptCache -All -Confirm:$false

# Erneut importieren und Cache neu aufbauen
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Force
```

#### Leistungsverschlechterung

Wenn die Leistung im Laufe der Zeit schlechter wird:

```powershell
# Cache-Verzeichnisgröße überprüfen
$cacheDir = (Get-ColorScriptConfiguration).Cache.Path
$size = (Get-ChildItem $cacheDir -Filter "*.cache" |
    Measure-Object -Sum Length).Sum
Write-Host "Cache-Größe: $([math]::Round($size / 1MB, 2)) MB"

# Alten Cache löschen und neu aufbauen
Clear-ColorScriptCache -All
New-ColorScriptCache
```

### INTEGRATION SCENARIOS

#### Scenario 1: Terminal Welcome Screen

```powershell
# Im Profil:
$hour = (Get-Date).Hour
if ($hour -ge 6 -and $hour -lt 12) {
    Show-ColorScript -Tag "bright,morning" -Random
} elseif ($hour -ge 12 -and $hour -lt 18) {
    Show-ColorScript -Category Geometric -Random
} else {
    Show-ColorScript -Tag "night,dark" -Random
}
```

#### Scenario 2: CI/CD Pipeline

```powershell
# Build-Phase-Dekoration
Show-ColorScript -Name "bars" -NoCache  # Schnelle Anzeige ohne Cache
New-ColorScriptCache -Category "Build" -Force  # Für nächsten Lauf vorbereiten

# In CI/CD-Kontext:
$env:CI = $true
if ($env:CI) {
    Show-ColorScript -NoCache  # Cache in kurzlebigen Umgebungen vermeiden
}
```

#### Scenario 3: Administrative Dashboards

```powershell
# Systemthematische Farbskripte anzeigen
$os = if ($PSVersionTable.PSVersion.Major -ge 7) { "pwsh" } else { "powershell" }
Show-ColorScript -Name $os -PassThru | Out-Null

# Statusinformationen anzeigen
Get-ColorScriptList -Tag "system" -AsObject |
    ForEach-Object { Write-Host "Verfügbar: $($_.Name)" }
```

#### Scenario 4: Educational Presentations

```powershell
# Interaktive Farbskript-Schau
Show-ColorScript -All -WaitForInput
# Benutzer können Leertaste drücken, um fortzufahren, q um zu beenden

# Oder mit spezifischer Kategorie
Show-ColorScript -All -Category Abstract -WaitForInput
```

#### Scenario 5: Multi-User Environment

```powershell
# Pro-Benutzer-Konfiguration
Set-ColorScriptConfiguration -CachePath "\\shared\cache\$env:USERNAME"
Set-ColorScriptConfiguration -DefaultScript "team-logo"

# Gemeinsame Skripte mit Benutzeranpassung
Get-ColorScriptList -AsObject |
    Where-Object { $_.Tags -contains "shared" } |
    ForEach-Object { Show-ColorScript -Name $_.Name }
```

### ADVANCED TOPICS

#### Topic 1: Cache Strategy Selection

Verschiedene Caching-Strategien für verschiedene Szenarien:

**Full Cache Strategy** (Optimal for Workstations)

```powershell
New-ColorScriptCache              # Cache alle 450++ Skripte
# Vorteile: Maximale Leistung, sofortige Anzeige
# Nachteile: Verwendet 2-5MB Festplattenspeicher
```

**Selective Cache Strategy** (Optimal for Portable/CI)

```powershell
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object { New-ColorScriptCache -Name $_.Name }
# Vorteile: Ausgewogene Leistung und Speicher
# Nachteile: Erfordert mehr Einrichtung
```

**No Cache Strategy** (Optimal for Development)

```powershell
Show-ColorScript -NoCache
# Vorteile: Siehe Skriptänderungen sofort
# Nachteile: Langsamere Anzeige, mehr Ressourcenverbrauch
```

#### Topic 2: Metadata Organization

Verständnis und Organisation von Farbskripten nach Metadaten:

**Categories** - Breite organisatorische Gruppierungen:

- Geometric: Fraktale, mathematische Muster
- Nature: Landschaften, organische Themen
- Artistic: Kreative, abstrakte Designs
- Gaming: Spielbezogene Themen
- System: OS/Technologie thematisiert

**Tags** - Spezifische Deskriptoren:

- Recommended: Für allgemeine Verwendung kuratiert
- Animated: Bewegende/verändernde Muster
- Colorful: Mehrfarbige Paletten
- Minimal: Einfach, saubere Designs
- Retro: Klassische 80er/90er Ästhetik

#### Topic 3: Performance Optimization Tips

```powershell
# Tipp 1: Häufig verwendete Skripte vorab laden
New-ColorScriptCache -Name bars,arch,mandelbrot-zoom,aurora-waves

# Tipp 2: Cache-Alter überwachen
$old = Get-ChildItem "$env:APPDATA\ColorScripts-Enhanced\cache" -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddMonths(-1) }

# Tipp 3: Kategoriefilterung für schnellere Auswahl verwenden
Show-ColorScript -Category Geometric  # Schneller als voller Satz

# Tipp 4: Ausführliche Ausgabe für Debugging aktivieren
Show-ColorScript -Name aurora -Verbose
```

#### Topic 4: Cross-Platform Considerations

```powershell
# Windows Terminal spezifisch
if ($env:WT_SESSION) {
    Show-ColorScript  # Volle Farbuntersützung
}

# VS Code integriertes Terminal
if ($env:TERM_PROGRAM -eq "vscode") {
    Show-ColorScript -Name nerd-font-test  # Schriftunterstützung
}

# SSH-Sitzung
if ($env:SSH_CONNECTION) {
    Show-ColorScript -NoCache  # Langsame Netzwerk-Cache-I/O vermeiden
}

# Linux/macOS Terminal
if ($PSVersionTable.PSVersion.Major -ge 7) {
    Show-ColorScript -Category Nature  # Unix-freundliche Skripte verwenden
}
```

#### Topic 5: Scripting and Automation

```powershell
# Erstellen einer wiederverwendbaren Funktion für tägliche Begrüßung
function Show-DailyColorScript {
    $seed = (Get-Date).DayOfYear
    Get-Random -SetSeed $seed
    Show-ColorScript -Random -Category @("Geometric", "Nature") -Random
}

# In Profil verwenden
Show-DailyColorScript

# Skript-Rotationsfunktion erstellen
function Invoke-ColorScriptSlideshow {
    param(
        [int]$Interval = 3,
        [string[]]$Category,
        [int]$Count
    )

    $scripts = if ($Category) {
        Get-ColorScriptList -Category $Category -AsObject
    } else {
        Get-ColorScriptList -AsObject
    }

    $scripts | Select-Object -First $Count | ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds $Interval
    }
}

# Verwendung
Invoke-ColorScriptSlideshow -Interval 2 -Category Geometric -Count 5
```

### TROUBLESHOOTING GUIDE

#### Issue 1: Scripts Not Displaying Correctly

**Symptome**: Verzerrte Zeichen oder fehlende Farben
**Lösungen**:

```powershell
# UTF-8-Kodierung festlegen
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Überprüfen, ob Terminal UTF-8 unterstützt
Write-Host "Test: ✓ ✗ ◆ ○" -ForegroundColor Green

# Nerd-Font-Test verwenden
Show-ColorScript -Name nerd-font-test

# Wenn immer noch kaputt, Cache deaktivieren
Show-ColorScript -Name yourscript -NoCache
```

#### Issue 2: Module Import Failures

**Symptome**: "Modul nicht gefunden" oder Importfehler
**Lösungen**:

```powershell
# Überprüfen, ob Modul existiert
Get-Module -ListAvailable | Where-Object Name -like "*Color*"

# PSModulePath überprüfen
$env:PSModulePath -split [System.IO.Path]::PathSeparator

# Modul neu installieren
Remove-Module ColorScripts-Enhanced
Uninstall-Module ColorScripts-Enhanced
Install-Module -Name ColorScripts-Enhanced -Force
```

#### Issue 3: Cache Not Being Used

**Symptome**: Skripte laufen jedes Mal langsam
**Lösungen**:

```powershell
# Überprüfen, ob Cache existiert
$cacheDir = (Get-ColorScriptConfiguration).Cache.Path
Get-ChildItem $cacheDir -Filter "*.cache" | Measure-Object

# Cache neu erstellen
Remove-Item "$cacheDir\*" -Confirm:$false
New-ColorScriptCache -Force

# Cache-Pfad-Probleme überprüfen
Get-ColorScriptConfiguration | Select-Object -ExpandProperty Cache
```

#### Issue 4: Profile Not Running

**Symptome**: Farbskript wird beim PowerShell-Start nicht angezeigt
**Lösungen**:

```powershell
# Überprüfen, ob Profil existiert
Test-Path $PROFILE

# Profilinhalt überprüfen
Get-Content $PROFILE | Select-String "ColorScripts"

# Profil reparieren
Add-ColorScriptProfile -Force

# Profil manuell testen
. $PROFILE
```

### FAQ

## Q: Wie viele Farbskripte sind verfügbar
A: 450++ eingebaute Skripte über mehrere Kategorien und Tags

## Q: Wie viel Festplattenspeicher verwendet das Caching
A: Ungefähr 2-5MB insgesamt für alle Skripte, etwa 2-50KB pro Skript

## Q: Kann ich Farbskripte in Skripten/Automatisierung verwenden
A: Ja, verwenden Sie `-ReturnText`, um Ausgabe zu erfassen oder `-PassThru` für Metadaten

## Q: Wie erstelle ich benutzerdefinierte Farbskripte
A: Verwenden Sie `New-ColorScript`, um eine Vorlage zu scaffolden, dann fügen Sie Ihre ANSI-Kunst hinzu

## Q: Was, wenn ich beim Start keine Farben möchte
A: Verwenden Sie `Add-ColorScriptProfile -SkipStartupScript`, um zu importieren ohne automatische Anzeige

## Q: Kann ich das auf macOS/Linux verwenden
A: Ja, mit PowerShell 7+ das plattformübergreifend läuft

## Q: Wie teile ich Farbskripte mit Kollegen
A: Exportieren Sie Metadaten mit `Export-ColorScriptMetadata` oder teilen Sie Skriptdateien

## Q: Ist Caching immer aktiviert
A: Nein, verwenden Sie `-NoCache`, um Caching für Entwicklung/Tests zu deaktivieren

### BEST PRACTICES

1. **Installieren von PowerShell Gallery**: Verwenden Sie `Install-Module` für automatische Updates
2. **Zum Profil hinzufügen**: Verwenden Sie `Add-ColorScriptProfile` für automatische Startup-Integration
3. **Cache vorab erstellen**: Führen Sie `New-ColorScriptCache` nach der Installation für optimale Leistung aus
4. **Bedeutungsvolle Benennung verwenden**: Verwenden Sie bei der Erstellung benutzerdefinierter Skripte beschreibende Namen
5. **Metadaten aktualisiert halten**: Aktualisieren Sie ScriptMetadata.psd1 beim Hinzufügen von Skripten
6. **In verschiedenen Terminals testen**: Überprüfen Sie, ob Skripte in Ihren Umgebungen korrekt angezeigt werden
7. **Cache-Größe überwachen**: Überprüfen Sie regelmäßig die Cache-Verzeichnisgröße und reinigen Sie bei Bedarf
8. **Kategorien/Tags verwenden**: Nutzen Sie Filterung für schnellere Skriptentdeckung
9. **Benutzerdefinierte Skripte dokumentieren**: Fügen Sie Beschreibungen und Tags zu benutzerdefinierten Farbskripten hinzu
10. **Konfiguration sichern**: Exportieren Sie Konfiguration vor größeren Änderungen

### VERSION HISTORY

#### Version 2025.10.09

- Verbessertes Caching-System mit OS-weitem Cache
- 6-19x Leistungsverbesserung
- Zentralisierter Cache-Speicherort in AppData
- 450++ Farbskripte enthalten
- Vollständige kommentarbasierte Hilfedokumentation
- Modulmanifest-Verbesserungen
- Erweiterte Konfigurationsverwaltung
- Metadaten-Exportfunktionen
- Profil-Integrationshelfer

### COPYRIGHT

Copyright (c) 2025. Alle Rechte vorbehalten.

### LICENSE

Lizenziert unter Unlicense-Lizenz. Siehe LICENSE-Datei für Details.

## RELATED LINKS

- [Get-ColorScriptList](Get-ColorScriptList.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Clear-ColorScriptCache](Clear-ColorScriptCache.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
