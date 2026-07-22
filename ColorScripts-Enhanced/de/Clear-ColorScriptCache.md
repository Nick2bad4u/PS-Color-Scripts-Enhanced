---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Clear-ColorScriptCache
---

# Clear-ColorScriptCache

## SYNOPSIS

Entfernen Sie zwischengespeicherte Farbskript-Ausgabedateien.

## SYNTAX

### Selection (Default)

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

### Help

```
Clear-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
Clear-ColorScriptCache [-Name <string[]>] [-Category <string[]>] [-Tag <string[]>] [-Path <string>]
 [-All] [-DryRun] [-PassThru] [-Quiet] [-NoAnsiOutput] [-WhatIf] [-Confirm]
```

## ALIASES

Dieser Befehl hat keine Aliase.

## DESCRIPTION

Das Cmdlet `Clear-ColorScriptCache` entfernt zwischengespeicherte Ausgabedateien, die vom Modul ColorScripts-Enhanced generiert wurden. Jeder Eintrag besteht aus einer gerenderten `<name>.cache`-Nutzlast und einem `<name>.cacheinfo`-Validierungs-Sidecar im effektiven Cache-Verzeichnis.

Sie können Cache-Einträge selektiv löschen, indem Sie den Parameter `-Name` mit Platzhaltermustern verwenden, oder alle Einträge auf einmal mit dem Parameter `-All` entfernen. `-All` entfernt auch verwaiste Sidecars, deren Nutzlast gelöscht wurde. Das Cmdlet unterstützt die Filterung nach `-Category` und `-Tag`, um auf bestimmte Teilmengen zwischengespeicherter Skripts abzuzielen.

Nicht übereinstimmende Skriptnamen melden in den Ergebnissen den Status `Missing`. Verwenden Sie `-DryRun`, um eine Vorschau der Entfernungsaktionen anzuzeigen, ohne das Dateisystem zu ändern, und `-Path`, um ein alternatives Cache-Verzeichnis als Ziel festzulegen (nützlich für benutzerdefinierte Cache-Konfigurationen oder CI/CD-Umgebungen).

Berechtigte Cache-Einträge werden neu generiert, wenn der entsprechende durch die Richtlinie ausgewählte Renderer angezeigt oder `New-ColorScriptCache` aufgerufen wird. Deterministische gebündelte Skripte werden prozessintern gerendert und erstellen keine Cache-Einträge.

Kombinieren Sie für Automatisierungsszenarien `-PassThru`, um strukturierte Ergebnisse zu erfassen, `-Quiet`, um die Zusammenfassungsmeldung zu unterdrücken, oder `-NoAnsiOutput`, um Klartextzusammenfassungen ohne ANSI-Farbcodes auszugeben.

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

Entfernt jede Cache-Datei im Standard-Cache-Verzeichnis, ohne eine Bestätigung anzufordern. Dies ist nützlich, um den Cache nach Modulaktualisierungen vollständig zu aktualisieren oder bei der Fehlerbehebung bei Anzeigeproblemen.

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

Zeigt eine Vorschau an, welche Cache-Dateien mit Aurora-Thema entfernt würden, ohne sie tatsächlich zu löschen. Die Ausgabe zeigt die Cache-Dateien, die dem Muster entsprechen, sodass Sie die Auswahl überprüfen können, bevor Sie den Löschvorgang durchführen.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name Galaxy -Path $env:TEMP -Confirm:$false
```

Löscht die Cache-Datei für den geeigneten 'Galaxy'-Renderer aus einem benutzerdefinierten Verzeichnis unter TEMP. Dies ist nützlich, wenn Sie `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` oder einen anderen isolierten Cache-Speicherort testen.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Category Mathematical -WhatIf
```

Zeigt, was passieren würde, wenn Cache-Dateien für Skripte in der Kategorie `Mathematical` entfernt würden. Der Parameter `-WhatIf` verhindert das Löschen.

### EXAMPLE 5

```powershell
Get-ColorScriptList -Tag retro | Clear-ColorScriptCache -DryRun
```

Verwendet Pipeline-Eingaben, um eine Vorschau der Entfernung von Cache-Dateien für alle als 'retro' gekennzeichneten Skripte anzuzeigen. Kombiniert das Filtern nach Tag mit einer Probevorschau, bevor der Löschvorgang ausgeführt wird.

### EXAMPLE 6

```powershell
Clear-ColorScriptCache -Name 'test-*', 'demo-*' -Confirm:$false
```

Entfernt Cache-Dateien für alle Skripte, deren Namen mit 'test-' oder 'demo-' beginnen, ohne Bestätigung. Als Array können mehrere Platzhaltermuster angegeben werden.

### EXAMPLE 7

```powershell
# Vorhandene Cache-Dateien löschen und richtliniengesteuerte Einträge neu erstellen
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -PassThru | Measure-Object
Write-Host "Der Cache wurde erfolgreich neu erstellt"
```

Löscht alle Cache-Nutzdaten, erstellt die von der dynamischen Cache-Richtlinie ausgewählten Einträge neu und zeigt anschließend Statistiken für diese neu erstellten Einträge an.

### EXAMPLE 8

```powershell
# Alte Cache-Einträge löschen, die älter als 30 Tage sind
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$thirtyDaysAgo = (Get-Date).AddDays(-30)
Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $thirtyDaysAgo } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
Write-Host "Alte Cachedateien wurden bereinigt"
```

Entfernt Cache-Dateien, die seit mehr als 30 Tagen nicht aktualisiert wurden.

### EXAMPLE 9

```powershell
# Cache-Verwaltungsbericht
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$beforeCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Clear-ColorScriptCache -Category Geometric -Confirm:$false
$afterCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Write-Host "$($beforeCount - $afterCount) geometrische Cachedateien wurden gelöscht"
```

Zeigt Statistiken zu Cache-Löschvorgängen an.

### EXAMPLE 10

```powershell
# Fehlerbehebung – spezifisches Skript löschen und neu erstellen
$scriptName = "Galaxy"
Clear-ColorScriptCache -Name $scriptName -Confirm:$false
New-ColorScriptCache -Name $scriptName -Force
Show-ColorScript -Name $scriptName
```

Löscht den Cache für einen richtlinienberechtigten Renderer, erstellt ihn neu und zeigt ihn anschließend zur Überprüfung an.

### EXAMPLE 11

```powershell
# Nach mehreren Kategorien filtern
Clear-ColorScriptCache -Category Geometric,Abstract -DryRun -PassThru |
    Select-Object CacheFile |
    Measure-Object
```

Zeigt an, wie viele Cache-Dateien gelöscht würden, wenn nach mehreren Kategorien gefiltert würde.

## PARAMETERS

### -All

Wählen Sie jeden Cache-Eintrag im Zielverzeichnis aus. `-Category` und `-Tag` können den All-Selection-Parametersatz weiter einschränken; Stattdessen gehört `-Name` zum Auswahlparametersatz.

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

Filtern Sie die Zielskripte nach Kategorie, bevor Sie Cache-Einträge auswerten. Nur Cache-Dateien für Skripte, die den angegebenen Kategorien entsprechen, werden zum Entfernen berücksichtigt. Akzeptiert eine Reihe von Kategorienamen und kann für eine präzisere Filterung mit `-Tag` kombiniert werden.

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

Fordert Sie zur Bestätigung auf, bevor Sie das Cmdlet ausführen. Standardmäßig ist dies aktiviert, um ein versehentliches Löschen von Cache-Dateien zu verhindern. Verwenden Sie `-Confirm:$false`, um die Bestätigungsaufforderung zu umgehen.

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

### -DryRun

Sehen Sie sich Entfernungsaktionen in der Vorschau an, ohne Dateien zu löschen. Das Cmdlet zeigt an, welche Cache-Dateien entfernt werden würden, ändert jedoch nicht das Dateisystem. Dies ist nützlich, um Ihre Auswahlkriterien zu überprüfen, bevor Sie den Löschvorgang durchführen.

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

### -Name

Namen oder Platzhaltermuster, die die zu entfernenden Cache-Dateien identifizieren. Akzeptiert Pipeline-Eingaben und Eigenschaftsbindungen von Objekten mit einer `Name`-Eigenschaft. Platzhalterzeichen (`*`, `?`) werden für den Mustervergleich unterstützt. Gegenseitig ausschließend mit `-All`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
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

Deaktivieren Sie die ANSI-Farbsequenzen in der Zusammenfassungsausgabe. Dies ist hilfreich für Konsolen oder Protokollprozessoren, die den ANSI-Stil nicht interpretieren, um sicherzustellen, dass der Zusammenfassungstext im Klartext lesbar bleibt.

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

### -PassThru

Gibt detaillierte Ergebnisobjekte für jeden verarbeiteten Cache-Eintrag zurück. Ohne diesen Schalter schreibt das Cmdlet nur eine zusammenfassende Nachricht. Jeder Pass-Through-Datensatz enthält den Skriptnamen, den Cache-Dateipfad, den Status und alle zugehörigen Fehlertexte zur weiteren Überprüfung oder Berichterstellung.

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

### -Path

Alternatives Cache-Verzeichnis, gegen das gearbeitet werden soll. Wenn nicht angegeben, wird standardmäßig der Standard-Cache-Pfad des Moduls verwendet. Verwenden Sie diesen Parameter, wenn Sie mit benutzerdefinierten Cache-Speicherorten arbeiten, die über die Umgebungsvariable `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` festgelegt wurden, oder wenn Sie Cache-Dateien in alternativen Verzeichnissen zu Test- oder CI/CD-Zwecken verwalten.

```yaml
Type: System.String
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

Unterdrücken Sie die zusammenfassende Meldung, die nach Abschluss der Cache-Entfernung ausgegeben wird. Verwenden Sie diesen Schalter, wenn Sie in stillen Automatisierungskontexten ausgeführt werden, in denen nur strukturierte Ausgaben (z. B. `-PassThru`-Datensätze, Warnungen oder Fehler) erzeugt werden sollen.

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

Filtern Sie die Zielskripts nach Metadaten-Tags, bevor Sie Cache-Einträge auswerten. Nur Cache-Dateien für Skripte mit passenden Tags werden zum Entfernen berücksichtigt. Akzeptiert eine Reihe von Tag-Namen und kann mit `-Category` kombiniert werden, um eine detailliertere Kontrolle darüber zu erhalten, welche Cache-Dateien als Ziel verwendet werden.

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

### -WhatIf

Zeigt, was passieren würde, wenn das Cmdlet ausgeführt würde, ohne dass der Vorgang tatsächlich ausgeführt wird. Das Cmdlet zeigt die Aktionen an, die es ausführen würde, ändert jedoch nicht das Dateisystem. Dies ist ein allgemeiner Standardparameter von PowerShell, der ähnlich wie `-DryRun` funktioniert, jedoch den integrierten Konventionen von PowerShell folgt.

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

### System.String

Sie können Skriptnamen an dieses Cmdlet weiterleiten. Jeder Name wird anhand der angegebenen Parameter für die Entfernung der Cache-Datei ausgewertet.

### System.String[]

Sie können ein Array von Skriptnamen an dieses Cmdlet weiterleiten. Dies ist besonders nützlich in Kombination mit `Get-ColorScriptList`, um Skripte nach verschiedenen Kriterien zu filtern, bevor ihre Caches geleert werden.

### System.Management.Automation.PSObject

Sie können Objekte mit einer `Name`-Eigenschaft an dieses Cmdlet weiterleiten. Das Cmdlet extrahiert den Eigenschaftswert `Name` und verwendet ihn, um Cachedateien zum Entfernen zu identifizieren.

## OUTPUTS

### System.Object

Gibt mit `-PassThru` einen Statusdatensatz für jede verarbeitete Cache-Datei zurück. Jedes Ausgabeobjekt enthält die folgenden Eigenschaften:

- **Status**: Das Ergebnis der Operation (`Removed`, `Missing`, `DryRun`, `SkippedByUser` oder `Error`)
- **CacheFile**: Der vollständige Pfad zur verarbeiteten Cache-Datei
- **Message**: Beschreibender Text, der das Ergebnis der Operation erläutert
- **Name**: Der Name des Skripts, das mit der Cache-Datei verknüpft ist

## NOTES

**Autor**: Nick
**Modul**: ColorScripts-Enhanced

Cache-Dateien werden mit der Erweiterung `.cache` im Cache-Verzeichnis des Moduls gespeichert. Jede Cache-Datei entspricht einem einzelnen Farbskript und enthält die vorgerenderte ANSI-Ausgabe.

Berechtigte Cache-Einträge werden neu generiert, wenn der entsprechende durch die Richtlinie ausgewählte Renderer angezeigt oder `New-ColorScriptCache` aufgerufen wird. Deterministische gebündelte Skripte werden prozessintern gerendert und erstellen keine Cache-Einträge.

Fragen Sie `(Get-ColorScriptConfiguration).Cache.EffectivePath` nach dem standardmäßigen effektiven Pfad ab. Es kann mit der persistenten Konfiguration oder `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` überschrieben werden; `-Path` zielt für einen Aufruf auf ein anderes Verzeichnis ab.

Bei Verwendung von `-DryRun` oder `-WhatIf` überprüft das Cmdlet weiterhin, ob das Cache-Verzeichnis vorhanden ist, und meldet etwaige Probleme, führt jedoch keine Löschungen durch.

Das Filtern nach `-Category` oder `-Tag` erfordert, dass die Skripte über zugehörige Metadaten verfügen. Skripte ohne Metadaten entsprechen diesen Filtern nicht.

### Bewährte Verfahren

- Vor zerstörerischen Eingriffen immer `-DryRun` oder `-WhatIf` verwenden
- Verwenden Sie `-Confirm:$false` nur, wenn Sie sich über den Vorgang sicher sind
- Archivcache vor größeren Bereinigungsvorgängen zur Wiederherstellung
- Überwachen Sie den Speicherplatz regelmäßig auf Cache-Wachstum
- Verwenden Sie nach Möglichkeit eine selektive Reinigung anstelle einer vollständigen Reinigung
- Behalten Sie den Überblick über kritische Skripte, die nicht gelöscht werden sollten
- Planen Sie automatische Bereinigungen während der Wartungsfenster
- Testen Sie die Bereinigungsvorgänge zunächst außerhalb der Produktion

### Fehlerbehebung (2)

- **"Keine Cachedateien gefunden"**: Überprüfen Sie `(Get-ColorScriptConfiguration).Cache.EffectivePath` und verwenden Sie `Export-ColorScriptMetadata -IncludeCacheInfo`, um den Cache-Status zu überprüfen
- **"Zugriff verweigert"**: Überprüfen Sie den Schreibzugriff auf das Cache-Verzeichnis
- **"Cache wird nicht neu erstellt"**: Skripte können Rendering-Probleme haben; testen Sie mit `-NoCache`

## RELATED LINKS

- [Onlineversion](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache)

