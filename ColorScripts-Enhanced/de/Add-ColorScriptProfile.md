---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: de
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Hängt den Import des ColorScripts-Enhanced-Moduls (und optional Show-ColorScript) an eine PowerShell-Profil-Datei an.

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

Fügt einen Startup-Snippet zur angegebenen PowerShell-Profil-Datei hinzu. Der Snippet importiert immer das ColorScripts-Enhanced-Modul und fügt, sofern nicht mit `-SkipStartupScript` unterdrückt, einen Aufruf zu `Show-ColorScript` hinzu, sodass ein zufälliges Colorscript beim PowerShell-Start angezeigt wird.

Die Profil-Datei wird automatisch erstellt, falls sie noch nicht existiert. Doppelte Importe werden vermieden, es sei denn, `-Force` wird angegeben.

Der `-Path`-Parameter akzeptiert relative Pfade, Umgebungsvariablen und `~`-Erweiterung, wodurch es einfach ist, Profile außerhalb der Standardorte anzusprechen. Wenn `-Path` nicht angegeben wird, bestimmt der `-Scope`-Parameter, welches standardmäßige PowerShell-Profil modifiziert wird.

## EXAMPLES

### EXAMPLE 1

Hinzufügen zum Profil des aktuellen Benutzers für alle Hosts (Standardverhalten).

```powershell
Add-ColorScriptProfile
```

Dies fügt sowohl den Modul-Import als auch den `Show-ColorScript`-Aufruf zu `$PROFILE.CurrentUserAllHosts` hinzu.

### EXAMPLE 2

Hinzufügen zum Profil des aktuellen Benutzers nur für den aktuellen Host, ohne das Startup-Script.

```powershell
Add-ColorScriptProfile -Scope CurrentUserCurrentHost -SkipStartupScript
```

Dies fügt nur die `Import-Module ColorScripts-Enhanced`-Zeile zum aktuellen Host-Profil hinzu.

### EXAMPLE 3

Hinzufügen zu einem benutzerdefinierten Profil-Pfad mit Umgebungsvariablen-Erweiterung.

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

Dies zielt auf eine spezifische Profil-Datei außerhalb der standardmäßigen PowerShell-Profil-Orte ab.

### EXAMPLE 4

Erzwungenes erneutes Hinzufügen des Snippets, auch wenn es bereits existiert.

```powershell
Add-ColorScriptProfile -Force
```

Dies hängt den Snippet erneut an, auch wenn das Profil bereits eine Import-Anweisung für ColorScripts-Enhanced enthält.

### EXAMPLE 5

Einrichtung auf einem neuen Computer - Profil erstellen, falls nötig, und ColorScripts zu allen Hosts hinzufügen.

```powershell
$profileExists = Test-Path $PROFILE.CurrentUserAllHosts
if (-not $profileExists) {
    New-Item -Path $PROFILE.CurrentUserAllHosts -ItemType File -Force | Out-Null
}
Add-ColorScriptProfile -Scope CurrentUserAllHosts -Confirm:$false
Write-Host "Profil konfiguriert! Starten Sie Ihr Terminal neu, um Colorscripts beim Start zu sehen."
```

### EXAMPLE 6

Hinzufügen mit einem spezifischen Colorscript für die Anzeige (manuell nach diesem Befehl hinzufügen):

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Dann manuell $PROFILE bearbeiten, um hinzuzufügen:
# Show-ColorScript -Name mandelbrot-zoom
```

### EXAMPLE 7

Überprüfen, ob das Profil korrekt hinzugefügt wurde:

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Hinzufügen zu einem spezifischen Profil-Bereich, der nur den aktuellen Host anspricht:

```powershell
# Nur für Windows Terminal oder ConEmu
Add-ColorScriptProfile -Scope CurrentUserCurrentHost

# Für alle PowerShell-Hosts (ISE, VSCode, Konsole)
Add-ColorScriptProfile -Scope CurrentUserAllHosts
```

### EXAMPLE 9

Verwendung relativer Pfade und Tilde-Erweiterung:

```powershell
# Verwendung der Tilde-Erweiterung für das Home-Verzeichnis
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# Verwendung des aktuellen Verzeichnis-relativen Pfads
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

Tägliche Anzeige eines anderen Colorscripts durch Hinzufügen benutzerdefinierter Logik:

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Dann manuell zu $PROFILE hinzufügen:
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

### EXAMPLE 11

Pokémon beim Start automatisch ausschließen:

```powershell
Add-ColorScriptProfile -IncludePokemon
```

Dadurch wird `Show-ColorScript -IncludePokemon` (in einem try/catch) zum Profil hinzugefügt, sodass beim Start Pokémon-Skripte angezeigt werden können.

## PARAMETERS

### -AutoShow

Controls whether the managed profile block displays a colorscript after importing the module.

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

Fordert Sie zur Bestätigung auf, bevor das Cmdlet ausgeführt wird.

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

Specifies the colorscript name written to the managed profile block for startup display.

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

Hängt den Snippet an, auch wenn das Profil bereits eine `Import-Module ColorScripts-Enhanced`-Zeile enthält. Verwenden Sie dies, um doppelte Einträge zu erzwingen oder den Snippet nach manueller Entfernung erneut hinzuzufügen.

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

Fügt dem generierten `Show-ColorScript`-Aufruf den Schalter `-IncludePokemon` hinzu, damit beim Start Pokémon-Colorscripts angezeigt werden können. Wird ignoriert, wenn `-SkipStartupScript` verwendet wird.

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

Vorb eantwortet die Pokémon-Abfrage (Y/Yes oder N/No). Unterstützt auch die Umgebungsvariable
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

Specifies the PowerShell profile file to update. The Path alias is also accepted.

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

Unterdrückt das Aufwärmen des Caches, wenn das Profil aktualisiert wird. Respektiert auch die
Umgebungsvariable `COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` und die globale Variable
`$Global:ColorScriptsEnhancedSkipCacheBuild`. Wird automatisch übersprungen, wenn der Profilpfad unter
dem temporären Verzeichnis liegt.

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

Skippt die Rückfrage, ob Pokémon-Colorscripts beim Start eingeschlossen werden sollen.

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

Überspringt das Hinzufügen von `Show-ColorScript` zum Profil. Nur die `Import-Module ColorScripts-Enhanced`-Zeile wird angehängt. Verwenden Sie dies, wenn Sie manuell steuern möchten, wann Colorscripts angezeigt werden.

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

Zeigt, was passieren würde, wenn das Cmdlet ausgeführt wird. Das Cmdlet wird nicht ausgeführt.

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

### None

Dieses Cmdlet akzeptiert keine Pipeline-Eingabe.

## OUTPUTS

### System.Object

Gibt ein benutzerdefiniertes Objekt mit den folgenden Eigenschaften zurück:

- **ProfilePath** (string): Der vollständige Pfad zur modifizierten Profil-Datei
- **Changed** (bool): Ob das Profil tatsächlich modifiziert wurde
- **Message** (string): Eine Statusnachricht, die das Operationsergebnis beschreibt

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 oder höher

Die Profil-Datei wird automatisch erstellt, falls sie nicht existiert, einschließlich aller notwendigen übergeordneten Verzeichnisse. Doppelte Importe werden erkannt und unterdrückt, es sei denn, `-Force` wird verwendet.

Wenn Sie erhöhte Berechtigungen benötigen, um ein AllUsers-Profil zu modifizieren, stellen Sie sicher, dass Sie PowerShell als Administrator ausführen.

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)

