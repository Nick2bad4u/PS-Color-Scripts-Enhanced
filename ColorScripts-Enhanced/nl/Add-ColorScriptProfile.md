---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/nl/Add-ColorScriptProfile.md
Locale: nl-NL
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Voegt de ColorScripts-Enhanced module import toe (en optioneel Show-ColorScript) aan een PowerShell profielbestand.

## SYNTAX

### \_\_AllParameterSets

```text
Add-ColorScriptProfile [[-Scope] <string>] [[-Path] <string>] [-h] [-SkipStartupScript] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

This cmdlet has the following aliases:

- None

## DESCRIPTION

Voegt een opstart snippet toe aan het opgegeven PowerShell profielbestand. De snippet importeert altijd de ColorScripts-Enhanced module en, tenzij onderdrukt met `-SkipStartupScript`, voegt een aanroep toe aan `Show-ColorScript` zodat een willekeurig kleuren script wordt weergegeven bij PowerShell lancering.

Het profielbestand wordt automatisch aangemaakt als het nog niet bestaat. Dubbele imports worden vermeden tenzij `-Force` is opgegeven.

De `-Path` parameter accepteert relatieve paden, omgevingsvariabelen, en `~` uitbreiding, waardoor het gemakkelijk is om profielen buiten de standaard locaties te targeten. Als `-Path` niet wordt opgegeven, bepaalt de `-Scope` parameter welk standaard PowerShell profiel te wijzigen.

## EXAMPLES

### EXAMPLE 1

Voeg toe aan het profiel van de huidige gebruiker voor alle hosts (standaard gedrag).

```powershell
Add-ColorScriptProfile
```

Dit voegt zowel de module import als de `Show-ColorScript` aanroep toe aan `$PROFILE.CurrentUserAllHosts`.

### EXAMPLE 2

Voeg toe aan het profiel van de huidige gebruiker voor alleen de huidige host, zonder het opstart script.

```powershell
Add-ColorScriptProfile -Scope CurrentUserCurrentHost -SkipStartupScript
```

Dit voegt alleen de `Import-Module ColorScripts-Enhanced` regel toe aan het huidige host profiel.

### EXAMPLE 3

Voeg toe aan een aangepast profiel pad met omgevingsvariabele uitbreiding.

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

Dit target een specifiek profielbestand buiten de standaard PowerShell profiel locaties.

### EXAMPLE 4

Forceer het opnieuw toevoegen van de snippet, zelfs als deze al bestaat.

```powershell
Add-ColorScriptProfile -Force
```

Dit voegt de snippet opnieuw toe, zelfs als het profiel al een import statement bevat voor ColorScripts-Enhanced.

### EXAMPLE 5

Setup op een nieuwe machine - maak profiel aan indien nodig en voeg ColorScripts toe aan alle hosts.

```powershell
$profileExists = Test-Path $PROFILE.CurrentUserAllHosts
if (-not $profileExists) {
    New-Item -Path $PROFILE.CurrentUserAllHosts -ItemType File -Force | Out-Null
}
Add-ColorScriptProfile -Scope CurrentUserAllHosts -Confirm:$false
Write-Host "Profile configured! Restart your terminal to see colorscripts on startup."
```

### EXAMPLE 6

Voeg toe met een specifiek kleuren script voor weergave (handmatig toevoegen na deze opdracht):

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Then manually edit $PROFILE to add:
# Show-ColorScript -Name mandelbrot-zoom
```

### EXAMPLE 7

Verificeer dat profiel correct is toegevoegd:

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Voeg toe aan specifiek profiel scope gericht op huidige host alleen:

```powershell
# For Windows Terminal or ConEmu only
Add-ColorScriptProfile -Scope CurrentUserCurrentHost

# For all PowerShell hosts (ISE, VSCode, Console)
Add-ColorScriptProfile -Scope CurrentUserAllHosts
```

### EXAMPLE 9

Relatieve paden en tilde uitbreiding gebruiken:

```powershell
# Using tilde expansion for home directory
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# Using current directory relative path
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

Toon dagelijks verschillend kleuren script door aangepaste logica toe te voegen:

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Then add this to $PROFILE manually:
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

## PARAMETERS

### -Confirm

Vraagt u om bevestiging voordat de cmdlet wordt uitgevoerd.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ""
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
HelpMessage: ""
```

### -Force

Voeg de snippet toe, zelfs als het profiel al een `Import-Module ColorScripts-Enhanced` regel bevat. Gebruik dit om dubbele entries te forceren of de snippet opnieuw toe te voegen na handmatige verwijdering.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ""
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

### -h

Toont hulp informatie voor deze cmdlet. Equivalent aan het gebruik van `Get-Help Add-ColorScriptProfile`.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ""
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
HelpMessage: ""
```

### -Path

Expliciet profiel pad om bij te werken. Overschrijft `-Scope` wanneer opgegeven. Ondersteunt omgevingsvariabelen (bijv. `$env:USERPROFILE`), relatieve paden, en `~` uitbreiding voor de home directory.

```yaml
Type: System.String
DefaultValue: ""
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
HelpMessage: ""
```

### -Scope

Profiel scope om bij te werken wanneer `-Path` niet wordt opgegeven. Accepteert PowerShell's standaard profiel eigenschappen: `CurrentUserAllHosts`, `CurrentUserCurrentHost`, `AllUsersAllHosts`, of `AllUsersCurrentHost`. Standaard naar `CurrentUserAllHosts`.

```yaml
Type: System.String
DefaultValue: "CurrentUserAllHosts"
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
HelpMessage: ""
```

### -SkipStartupScript

Sla het toevoegen van `Show-ColorScript` aan het profiel over. Alleen de `Import-Module ColorScripts-Enhanced` regel wordt toegevoegd. Gebruik dit als u handmatig wilt controleren wanneer kleuren scripts worden weergegeven.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ""
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

### -WhatIf

Toont wat er zou gebeuren als de cmdlet wordt uitgevoerd. De cmdlet wordt niet uitgevoerd.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ""
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
HelpMessage: ""
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Deze cmdlet accepteert geen pipeline invoer.

## OUTPUTS

### System.Object

Retourneert een aangepast object met de volgende eigenschappen:

- **ProfilePath** (string): Het volledige pad naar het gewijzigde profielbestand
- **Changed** (bool): Of het profiel daadwerkelijk is gewijzigd
- **Message** (string): Een status bericht dat het operationele resultaat beschrijft

## NOTES

**Auteur:** Nick
**Module:** ColorScripts-Enhanced
**Vereist:** PowerShell 5.1 of later

Het profielbestand wordt automatisch aangemaakt als het niet bestaat, inclusief eventueel noodzakelijke bovenliggende directories. Dubbele imports worden gedetecteerd en onderdrukt tenzij `-Force` wordt gebruikt.

Als u verhoogde permissies nodig heeft om een AllUsers profiel te wijzigen, zorg ervoor dat u PowerShell als Administrator uitvoert.

## RELATED LINKS

- [Online Version](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
- [Show-ColorScript](./Show-ColorScript.md)
- [New-ColorScriptCache](./New-ColorScriptCache.md)
- [Clear-ColorScriptCache](./Clear-ColorScriptCache.md)
- [GitHub Repository](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
