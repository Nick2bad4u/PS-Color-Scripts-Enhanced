---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Fügt einen verwalteten ColorScripts-Enhanced-Startblock in einer PowerShell-Profildatei hinzu oder aktualisiert ihn.

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

Dieser Befehl hat keine Aliase.

## DESCRIPTION

Fügt dem ausgewählten PowerShell-Profil einen verwalteten Startblock hinzu. Der Block importiert ColorScripts-Enhanced und kann nach dem Import `Show-ColorScript` aufrufen. `-SkipStartupScript` schreibt einen Nur-Import-Block.

Wenn `-ProfilePath` weggelassen wird, bevorzugt der Befehl `$PROFILE.CurrentUserAllHosts` und verwendet ansonsten den ersten definierten Profilpfad. Die Profildatei und fehlende übergeordnete Verzeichnisse werden bei Bedarf erstellt.

Vorhandene verwaltete oder ältere ColorScripts-Enhanced-Blöcke werden ersetzt statt dupliziert. Wenn das Profil das Modul bereits außerhalb eines verwalteten Blocks importiert, lässt der Befehl es unverändert, es sei denn, `-Force` wird angegeben. `-Force` ermöglicht das Ersetzen erkannter Modulinhalte unter Beibehaltung nicht verwandter Profilinhalte.

Das generierte Startverhalten wird anhand expliziter Parameter und der beibehaltenen Konfiguration aufgelöst. `-AutoShow` aktiviert explizit die Anzeige, `-DefaultStartupScript` wählt ein benanntes Skript aus und die Pokémon-Einbindung kann direkt bereitgestellt oder über die interaktive Eingabeaufforderung und ihre dokumentierten Überschreibungen gelöst werden. Sofern `-SkipCacheBuild` nicht verwendet wird, kann der Befehl nach der Aktualisierung des Profils durch Richtlinien ausgewählte Cache-Einträge vorwärmen.

## EXAMPLES

### EXAMPLE 1

Zum Profil des aktuellen Benutzers für alle Hosts hinzufügen (Standardverhalten).

```powershell
Add-ColorScriptProfile
```

Dadurch werden sowohl der Modulimport als auch der `Show-ColorScript`-Aufruf zu `$PROFILE.CurrentUserAllHosts` hinzugefügt.

### EXAMPLE 2

Nur zum Profil des aktuellen Benutzers für den aktuellen Host hinzufügen, ohne das Startskript.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost -SkipStartupScript
```

Dadurch wird dem Profil des aktuellen Hosts ein nur für den Import verwalteter Block hinzugefügt.

### EXAMPLE 3

Zu einem benutzerdefinierten Profilpfad mit Umgebungsvariablenerweiterung hinzufügen.

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

Dies zielt auf eine bestimmte Profildatei außerhalb der standardmäßigen PowerShell-Profilspeicherorte ab.

### EXAMPLE 4

Erzwingen Sie das erneute Hinzufügen des Snippets, auch wenn es bereits vorhanden ist.

```powershell
Add-ColorScriptProfile -Force
```

Dadurch werden erkannte ColorScripts-Enhanced-Profilinhalte aktualisiert, während nicht verwandte Profillinien erhalten bleiben.

### EXAMPLE 5

Einrichtung auf einem neuen Computer – bei Bedarf Profil erstellen und Farbskripte zu allen Hosts hinzufügen.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts -Confirm:$false
Write-Host "Profil konfiguriert! Starten Sie das Terminal neu, um beim Start Farbskripte anzuzeigen."
```

### EXAMPLE 6

Fügen Sie mit einem bestimmten Farbskript für die Startanzeige hinzu:

```powershell
Add-ColorScriptProfile -DefaultStartupScript mandelbrot-zoom -AutoShow
```

### EXAMPLE 7

Überprüfen Sie, ob das Profil korrekt hinzugefügt wurde:

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Zielen Sie explizit auf das Profil „Current-Host“ oder „All-Hosts“:

```powershell
# Nur für Windows Terminal oder ConEmu
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost

# Für alle PowerShell-Hosts (ISE, VSCode, Konsole)
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts
```

### EXAMPLE 9

Verwendung relativer Pfade und Tilde-Erweiterung:

```powershell
# Verwendung der Tilde-Erweiterung für das Home-Verzeichnis
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# Verwendet den relativen Pfad des aktuellen Verzeichnisses
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

Zeigen Sie täglich verschiedene Farbskript an, indem Sie benutzerdefinierte Logik hinzufügen:

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Dann fügen Sie dies manuell zu $PROFILE hinzu:
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

### EXAMPLE 11

Pokémon-Skripte beim Anzeigen von Startbildern automatisch überspringen:

```powershell
Add-ColorScriptProfile -IncludePokemon
```

Dadurch wird `Show-ColorScript -IncludePokemon` (umhüllt in ein schützendes try/catch) an das Profil angehängt, sodass das Startbild möglicherweise Pokémon-Skripte enthält.

## PARAMETERS

### -AutoShow

Steuert, ob der verwaltete Profilblock nach dem Importieren des Moduls einen Farbskript anzeigt.

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

### -DefaultStartupScript

Gibt den Farbskript-Namen an, der zur Startanzeige in den verwalteten Profilblock geschrieben wird.

```yaml
Type: System.String
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

### -Force

Aktualisiert erkannte ColorScripts-Enhanced-Profilinhalte und behält dabei nicht zugehörige Profilzeilen bei. Es werden nicht absichtlich doppelte verwaltete Blöcke angefügt.

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

Zeigt Hilfeinformationen für dieses Cmdlet an. Entspricht der Verwendung von `Get-Help Add-ColorScriptProfile`.

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

### -IncludePokemon

Fügen Sie `-IncludePokemon` zum generierten `Show-ColorScript`-Aufruf hinzu, sodass Pokémon Farbskripte beim Start einbezogen werden, sofern vorhanden. Wird ignoriert, wenn `-SkipStartupScript` verwendet wird.

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

### -PokemonPromptResponse

Beantworten Sie vorab die Aufforderung zur Aufnahme von Pokémon. Akzeptiert Ja/Ja oder N/Nein. Berücksichtigt auch die Umgebungsvariable
`COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE` und die globale Variable
`$Global:ColorScriptsEnhancedPokemonPromptResponse`.

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

### -ProfilePath

Gibt die zu aktualisierende PowerShell-Profildatei an. Der Alias ​​Path wird ebenfalls akzeptiert.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Path
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

### -SkipCacheBuild

Unterdrücken Sie das optionale Cache-Vorwärmen. Ein Vorwärmen wird nur dann versucht, wenn das Problem `ProfileAutoShow` behoben ist
Die Einstellung ist aktiviert, der Cache-Aufbau wurde nicht anderweitig deaktiviert, das Zielprofil liegt außerhalb
System-Temp-Verzeichnis, und der Vorgang wird von `ShouldProcess` genehmigt. Der Befehl respektiert auch die
Umgebungsvariable `COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` und die globale Variable
`$Global:ColorScriptsEnhancedSkipCacheBuild`.

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

### -SkipPokemonPrompt

Überspringen Sie die interaktive Eingabeaufforderung, die beim Start fragt, ob Pokémon Farbskripte einbezogen werden soll.

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

### -SkipStartupScript

Überspringen Sie das Hinzufügen von `Show-ColorScript` zum Profil. Es wird nur die Zeile `Import-Module ColorScripts-Enhanced` angehängt. Verwenden Sie diese Option, wenn Sie manuell steuern möchten, wann Farbskripte angezeigt wird.

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

### -WhatIf

Zeigt, was passieren würde, wenn das Cmdlet ausgeführt würde. Das Cmdlet wird nicht ausgeführt.

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

### System.Object

Gibt ein benutzerdefiniertes Objekt mit den folgenden Eigenschaften zurück:

- **Path** (string): Der vollständige Pfad zur ausgewählten Profildatei
- **Changed** (bool): Ob das Profil tatsächlich geändert wurde
- **Message** (string): Eine Statusmeldung, die das Operationsergebnis beschreibt
- **IncludePokemon** (bool): Die Startup-Wahl für die Pokémon-Inklusion
- **CacheBuilt** (bool): Ob die optionale Cache-Aufwärmphase abgeschlossen ist

## NOTES

**Autor:** Nick

**Modul:** ColorScripts-Enhanced

**Erfordert:** PowerShell 5.1 oder höher

Die Profildatei wird automatisch erstellt, wenn sie nicht vorhanden ist, einschließlich der erforderlichen übergeordneten Verzeichnisse. Der Befehl verwaltet vom Benutzer bereitgestellte Dateipfade. Es wird kein separater Bereichsselektor verfügbar gemacht.

## RELATED LINKS

- [Onlineversion](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)

