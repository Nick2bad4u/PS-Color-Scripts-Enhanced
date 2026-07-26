---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

Listet die verfügbaren Farbskripte mit optionaler Filterung und umfangreicher Metadatenausgabe auf.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

Dieser Befehl hat keine Aliase.

## DESCRIPTION

Das Cmdlet `Get-ColorScriptList` ruft alle mit dem Modul ColorScripts-Enhanced gepackten Farbskripte ab und zeigt sie an. Es bietet flexible Filteroptionen und mehrere Ausgabeformate für unterschiedliche Anwendungsfälle.

Standardmäßig zeigt das Cmdlet eine übersichtliche formatierte Tabelle mit Skriptnamen und -kategorien an. Der `-Detailed`-Switch erweitert diese Ansicht um Tags und Beschreibungen und bietet so mehr Kontext auf einen Blick.

Das Cmdlet gibt immer Metadatensätze an die Erfolgspipeline zurück. Ohne `-AsObject` wird auch eine formatierte Hostansicht geschrieben; `-AsObject` unterdrückt die Hostformatierung für eine saubere Automatisierung. Zu den Datensätzen gehören Name, Pfad, Kategorie, Kategorien, Tags, Beschreibung und die ursprüngliche Metadateneigenschaft.

Mithilfe der Filterfunktionen können Sie die Liste eingrenzen nach:

- **Name**: Unterstützt Platzhaltermuster (z. B. `aurora-*`) für flexiblen Abgleich
- **Category**: Filtern nach einem oder mehreren Kategorienamen (ohne Berücksichtigung der Groß-/Kleinschreibung)
- **Tag**: Filtern nach Metadaten-Tags wie "Recommended" oder "Animated" (ohne Berücksichtigung der Groß-/Kleinschreibung)

Das Cmdlet validiert Filtermuster und generiert Warnungen für nicht übereinstimmende Namensmuster, sodass Sie potenzielle Tippfehler oder fehlende Skripte erkennen können.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Zeigt alle verfügbaren Farbskripte in einem kompakten Tabellenformat mit dem Namen und der Kategorie jedes Skripts an.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed
```

Zeigt alle Farbskripte mit zusätzlichen Spalten einschließlich Tags und Beschreibungen für einen umfassenden Überblick.

### EXAMPLE 3

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

Zeigt nur Skripte in der Kategorie "Patterns" mit vollständigen Metadaten einschließlich Tags und Beschreibungen an.

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

Gibt strukturierte Objekte für jedes Skript zurück, dessen Name mit dem Platzhaltermuster übereinstimmt, und wählt dann nur die Eigenschaften Name und Tags zur Anzeige aus.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

Ruft alle als "Recommended" gekennzeichneten Skripte ab und sortiert sie alphabetisch nach Namen. Nützlich, um kuratierte Skripte zu finden, die für die Profilintegration geeignet sind.

### EXAMPLE 6

```powershell
Get-ColorScriptList -AsObject -Category Geometric,Abstract | Where-Object { $_.Tags -contains 'Colorful' }
```

Kombiniert Kategorie- und Tag-Filterung, um Skripte zu finden, die sowohl der Kategorie „Geometrisch“ als auch „Abstrakt“ angehören und als „Bunt“ gekennzeichnet sind.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Name blocks,pipes,matrix -AsObject | ForEach-Object { Show-ColorScript -Name $_.Name }
```

Ruft bestimmte benannte Skripts ab und führt sie nacheinander aus, um die Pipeline-Integration mit `Show-ColorScript` zu demonstrieren.

### EXAMPLE 8

```powershell
# Zählen Sie Skripte zu Inventarzwecken nach Kategorie
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending
```

Bietet eine Zusammenfassung darüber, wie viele Farbskripte in jeder Kategorie vorhanden sind.

### EXAMPLE 9

```powershell
# Finden Sie Skripte mit bestimmten Schlüsselwörtern in der Beschreibung
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

Sucht nach Skripten basierend auf ihrem Beschreibungsinhalt mithilfe von Mustervergleichen.

### EXAMPLE 10

```powershell
# Export nach CSV zur externen Werkzeugverarbeitung
Get-ColorScriptList -AsObject -Detailed |
    Select-Object Name, Category, Tags, Description |
    Export-Csv -Path "./colorscripts-inventory.csv" -NoTypeInformation
```

Exportiert den gesamten Farbskript-Bestand in das CSV-Format zur Verwendung in Tabellenkalkulationsanwendungen.

### EXAMPLE 11

```powershell
# Suchen Sie nach Skripten ohne bestimmte Kategorie
$allScripts = Get-ColorScriptList -AsObject
$uncategorized = $allScripts | Where-Object { -not $_.Category }
Write-Host "Nicht kategorisierte Skripte: $($uncategorized.Count)"
$uncategorized | Select-Object Name
```

Identifiziert Skripte, denen Kategoriemetadaten fehlen.

### EXAMPLE 12

```powershell
# Cache für gefilterte Skripte erstellen
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object {
        New-ColorScriptCache -Name $_.Name -PassThru
    } |
    Format-Table Name, Status
```

Wertet Skripte mit dem Tag `Recommended` aus; Es werden nur Renderer erstellt, die für die Cache-Richtlinie geeignet sind, und andere Datensätze melden `SkippedNotRequired`.

### EXAMPLE 13

```powershell
# Erstellen Sie einen formatierten Bericht aller geometrischen Schriften
Get-ColorScriptList -Category Geometric -Detailed |
    Out-String |
    Tee-Object -FilePath "./geometric-report.txt"
```

Erstellt und speichert einen detaillierten Bericht der geometrischen Kategorie Farbskripte in einer Datei.

### EXAMPLE 14

```powershell
# Finden Sie das erste Skript, das einem Muster entspricht, um es schnell anzuzeigen
$script = Get-ColorScriptList -Name "aurora-*" -AsObject | Select-Object -First 1
if ($script) {
    Show-ColorScript -Name $script.Name -PassThru
}
```

Zeigt schnell das erste passende Skript basierend auf einem Platzhaltermuster an.

### EXAMPLE 15

```powershell
# Überprüfen Sie, ob alle referenzierten Skripte vorhanden sind, bevor Sie die Automatisierung ausführen
$requiredScripts = @("bars", "arch", "mandelbrot-zoom")
$available = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$missing = $requiredScripts | Where-Object { $_ -notin $available }
if ($missing) {
    Write-Warning "Fehlende Skripte: $($missing -join ', ')"
} else {
    Write-Host "Alle erforderlichen Skripte sind verfügbar"
}
```

Überprüft, ob alle erforderlichen Skripts vorhanden sind, bevor die Automatisierung ausgeführt wird.

## PARAMETERS

### -AsObject

Gibt rohe Metadatensatzobjekte zurück, anstatt eine formatierte Tabelle an den Host zu rendern. Dies ermöglicht die Pipeline-Verarbeitung und die programmgesteuerte Bearbeitung der Farbskript-Metadaten.

Wenn dieser Schalter angegeben ist, können Sie Standard-Cmdlets PowerShell wie `Where-Object`, `Select-Object`, `Sort-Object` und `ForEach-Object` verwenden, um die Ergebnisse weiter zu verarbeiten.

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

### -Category

Filtert die Liste so, dass nur Skripte enthalten sind, die zu einer oder mehreren angegebenen Kategorien gehören. Beim Category-Abgleich wird die Groß-/Kleinschreibung nicht beachtet.

Zu den gängigen Kategorien gehören: Muster, Geometrisch, Abstrakt, Natur, Animiert, Text, Retro und mehr. Sie können mehrere Kategorien angeben, um Ihre Suche zu erweitern.

```yaml
Type: System.String[]
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

### -Detailed

Schließt beim Rendern der formatierten Tabellenansicht zusätzliche Spalten (Tags und Beschreibung) ein. Dadurch erhalten Sie umfassendere Informationen zu jedem Skript auf einen Blick.

Ohne diesen Schalter werden in der Tabellenausgabe nur der Name und die primäre Kategorie angezeigt.

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

### -Name

Filtert die Farbskript-Liste nach einem oder mehreren Skriptnamen. Unterstützt Platzhalterzeichen (`*` und `?`) für einen flexiblen Mustervergleich.

Wenn ein angegebenes Muster mit keinem Skript übereinstimmt, wird eine Warnung generiert, um potenzielle Probleme zu identifizieren. Beim Name-Abgleich wird die Groß-/Kleinschreibung nicht beachtet.

Sie können genaue Namen angeben oder Muster wie `aurora-*` verwenden, um mehrere verwandte Skripte abzugleichen.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
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

### -NoAnsiOutput

Deaktiviert das ANSI-Format in Informationsmeldungen und gerenderten Ausgaben für Nur-Text-Umgebungen.

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

### -Quiet

Unterdrückt Informationsmeldungen und behält gleichzeitig Befehlsausgaben und Fehler bei.

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

### -Tag

Filtert die Liste so, dass nur Skripts enthalten sind, die ein oder mehrere angegebene Metadaten-Tags enthalten. Beim Tag-Abgleich wird die Groß-/Kleinschreibung nicht beachtet.

Zu den gängigen Tags gehören: Empfohlen, Animiert, Bunt, Minimal, Retro, Komplex, Einfach und mehr. Tags hilft bei der Kategorisierung von Skripten nach visuellem Stil, Komplexität oder Anwendungsfall.

```yaml
Type: System.String[]
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

### CommonParameters

Dieses Cmdlet unterstützt die allgemeinen Parameter:
Weitere Informationen finden Sie unter
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Dieses Cmdlet akzeptiert keine Pipeline-Eingaben.

## OUTPUTS

### System.Object

Gibt Farbskript-Metadatensatzobjekte mit den folgenden Eigenschaften zurück:

- **Name**: Die mit `Show-ColorScript` verwendete Skript-ID
- **Path**: Der vollständige Quellpfad
- **Category**: Die primäre Kategorie des Skripts
- **Categories**: Ein Array aller Kategorien, zu denen das Skript gehört
- **Tags**: Ein Array von Metadaten-Tags, die das Skript beschreiben
- **Description**: Eine für Menschen lesbare Beschreibung der visuellen Ausgabe des Skripts
- **Metadata**: Das ursprüngliche Metadatenobjekt, das alle Rohskriptinformationen enthält

Ohne `-AsObject` schreibt das Cmdlet eine formatierte Tabelle auf den Host und gibt gleichzeitig die Datensatzobjekte für eine mögliche Pipelineverarbeitung zurück.

## NOTES

**Autor**: Nick
**Modul**: ColorScripts-Enhanced

Die zurückgegebenen Metadatensätze stellen umfassende Informationen sowohl für Anzeige- als auch für Automatisierungszwecke bereit. Die Eigenschaft `Name` kann direkt mit dem Cmdlet `Show-ColorScript` verwendet werden, um bestimmte Skripts auszuführen.

Bei allen Filtervorgängen (Name, Category, Tag) wird die Groß-/Kleinschreibung nicht beachtet und sie können kombiniert werden, um leistungsstarke Abfragen zu erstellen. Bei Verwendung von Platzhaltern im Parameter `-Name` generieren nicht übereinstimmende Muster Warnungen, die bei der Fehlerbehebung helfen.

Um optimale Ergebnisse bei der Integration von Farbskripte in Ihr PowerShell-Profil zu erzielen, verwenden Sie den `-Tag Recommended`-Filter, um kuratierte Skripte zu identifizieren, die für die Startanzeige geeignet sind.

### Bewährte Verfahren

- Verwenden Sie immer `-AsObject`, wenn Sie Ergebnisse programmgesteuert filtern oder bearbeiten müssen
- Verwenden Sie `-Detailed` beim interaktiven Erkunden, um Tags und Beschreibungen anzuzeigen
- Kombinieren Sie mehrere Filter für präzise Abfragen
- Exportieren Sie Metadaten regelmäßig, um Änderungen im Laufe der Zeit zu verfolgen
- Verwenden Sie Ergebnisobjekte zur Automatisierung, anstatt die Textausgabe zu analysieren
– Berücksichtigen Sie die Leistung, wenn Sie Abfragen wiederholt ausführen (Ergebnisse nach Möglichkeit zwischenspeichern)
- Nutzen Sie Group-Object für Analysen und Berichte
- Verwenden Sie Where-Object für komplexe Filterlogik

## RELATED LINKS

- [Onlineversion](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)

