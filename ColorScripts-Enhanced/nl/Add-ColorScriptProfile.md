---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Voegt een beheerd ColorScripts-Enhanced-opstartblok toe of werkt dit bij in een PowerShell-profielbestand.

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

Deze opdracht heeft geen aliassen.

## DESCRIPTION

Voegt een beheerd opstartblok toe aan het geselecteerde PowerShell-profiel. Het blok importeert ColorScripts-Enhanced en kan na het importeren `Show-ColorScript` aanroepen. `-SkipStartupScript` schrijft een alleen-importblok.

Wanneer `-ProfilePath` wordt weggelaten, geeft de opdracht de voorkeur aan `$PROFILE.CurrentUserAllHosts` en wordt anders het eerste gedefinieerde profielpad gebruikt. Het profielbestand en de ontbrekende bovenliggende mappen worden indien nodig gemaakt.

Bestaande beheerde of verouderde ColorScripts-Enhanced-blokken worden vervangen in plaats van gedupliceerd. Als het profiel de module al buiten een beheerd blok importeert, laat de opdracht deze ongewijzigd, tenzij `-Force` wordt opgegeven. `-Force` maakt het vervangen van herkende module-inhoud mogelijk, terwijl niet-gerelateerde profielinhoud behouden blijft.

Het gegenereerde opstartgedrag wordt opgelost op basis van expliciete parameters en aanhoudende configuratie. `-AutoShow` maakt weergave expliciet mogelijk, `-DefaultStartupScript` selecteert een benoemd script en de opname van Pokémon kan direct worden geleverd of opgelost via de interactieve prompt en de gedocumenteerde overschrijvingen. Tenzij `-SkipCacheBuild` wordt gebruikt, kan de opdracht door beleid geselecteerde cache-items vooraf opwarmen nadat het profiel is bijgewerkt.

## EXAMPLES

### EXAMPLE 1

Toevoegen aan het huidige gebruikersprofiel voor alle hosts (standaardgedrag).

```powershell
Add-ColorScriptProfile
```

Hiermee worden zowel de module-import als de `Show-ColorScript`-aanroep toegevoegd aan `$PROFILE.CurrentUserAllHosts`.

### EXAMPLE 2

Voeg alleen toe aan het huidige gebruikersprofiel voor de huidige host, zonder het opstartscript.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost -SkipStartupScript
```

Hiermee wordt een beheerd blok voor alleen importeren toegevoegd aan het huidige hostprofiel.

### EXAMPLE 3

Voeg toe aan een aangepast profielpad met uitbreiding van omgevingsvariabelen.

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

Dit is gericht op een specifiek profielbestand buiten de standaard PowerShell-profiellocaties.

### EXAMPLE 4

Forceer het opnieuw toevoegen van het fragment, zelfs als het al bestaat.

```powershell
Add-ColorScriptProfile -Force
```

Hiermee wordt de herkende ColorScripts-Enhanced-profielinhoud bijgewerkt, terwijl niet-gerelateerde profiellijnen behouden blijven.

### EXAMPLE 5

Installatie op een nieuwe machine - maak indien nodig een profiel aan en voeg ColorScripts toe aan alle hosts.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts -Confirm:$false
Write-Host "Profiel geconfigureerd. Start de terminal opnieuw om colorscripts bij het opstarten weer te geven."
```

### EXAMPLE 6

Voeg toe met een specifieke colorscript voor opstartweergave:

```powershell
Add-ColorScriptProfile -DefaultStartupScript mandelbrot-zoom -AutoShow
```

### EXAMPLE 7

Controleer of het profiel correct is toegevoegd:

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Target expliciet het huidige host- of all-hosts-profiel:

```powershell
# Alleen voor Windows Terminal of ConEmu
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost

# Voor alle PowerShell-hosts (ISE, VSCode, Console)
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts
```

### EXAMPLE 9

Relatieve paden en tilde-uitbreiding gebruiken:

```powershell
# Tilde-uitbreiding gebruiken voor de thuismap
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# Het relatieve pad van de huidige map gebruiken
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

Geef dagelijks verschillende colorscript weer door aangepaste logica toe te voegen:

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Voeg het volgende vervolgens handmatig toe aan $PROFILE
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

### EXAMPLE 11

Automatisch Pokémon-scripts overslaan bij het tonen van opstartkunst:

```powershell
Add-ColorScriptProfile -IncludePokemon
```

Hiermee wordt `Show-ColorScript -IncludePokemon` (verpakt in een beschermende try/catch) aan het profiel toegevoegd, zodat de lanceerkunst Pokémon-scripts kan bevatten.

## PARAMETERS

### -AutoShow

Bepaalt of het beheerde profielblok een colorscript weergeeft na het importeren van de module.

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

Vraagt u om bevestiging voordat u de cmdlet uitvoert.

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

Specificeert de colorscript-naam die naar het beheerde profielblok wordt geschreven voor opstartweergave.

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

Werkt herkende ColorScripts-Enhanced-profielinhoud bij en behoudt niet-gerelateerde profielregels. Er worden niet opzettelijk dubbele beheerde blokken toegevoegd.

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

Geeft Help-informatie voor deze cmdlet weer. Gelijk aan het gebruik van `Get-Help Add-ColorScriptProfile`.

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

Voeg `-IncludePokemon` toe aan de gegenereerde `Show-ColorScript`-oproep, zodat Pokémon colorscripts bij het opstarten wordt opgenomen, indien aanwezig. Genegeerd wanneer `-SkipStartupScript` wordt gebruikt.

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

Beantwoord vooraf de vraag om Pokémon op te nemen. Accepteert J/Ja of N/Nee. Houdt ook rekening met de omgevingsvariabele
`COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE` en de globale variabele
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

Specificeert het PowerShell-profielbestand dat moet worden bijgewerkt. De alias Path wordt ook geaccepteerd.

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

Onderdruk het optionele voorverwarmen van de cache. Er wordt alleen geprobeerd voor te verwarmen als de opgeloste `ProfileAutoShow`
instelling is ingeschakeld, het maken van cache is op geen enkele andere manier uitgeschakeld, het doelprofiel bevindt zich buiten de
systeemtemperatuurmap en de bewerking is goedgekeurd door `ShouldProcess`. Het commando respecteert ook de
omgevingsvariabele `COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` en de globale variabele
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

Sla de interactieve prompt over die vraagt of Pokémon colorscripts bij het opstarten moet worden toegevoegd.

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

Sla het toevoegen van `Show-ColorScript` aan het profiel over. Alleen de regel `Import-Module ColorScripts-Enhanced` is toegevoegd. Gebruik dit als u handmatig wilt bepalen wanneer colorscripts wordt weergegeven.

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

Laat zien wat er zou gebeuren als de cmdlet wordt uitgevoerd. De cmdlet wordt niet uitgevoerd.

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

Deze cmdlet ondersteunt de algemene parameters:
Zie voor meer informatie
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Deze cmdlet accepteert geen pijplijninvoer.

## OUTPUTS

### System.Object

Retourneert een aangepast object met de volgende eigenschappen:

- **Path** (string): het volledige pad naar het geselecteerde profielbestand
- **Changed** (bool): Of het profiel daadwerkelijk is gewijzigd
- **Message** (string): een statusbericht dat het resultaat van de bewerking beschrijft
- **IncludePokemon** (bool): de keuze voor startup-Pokémon-opname
- **CacheBuilt** (bool): of de optionele cache-opwarming is voltooid

## NOTES

**Auteur:** Nick

**Module:** ColorScripts-Enhanced

**Vereist:** PowerShell 5.1 of hoger

Het profielbestand wordt automatisch aangemaakt als het niet bestaat, inclusief de noodzakelijke bovenliggende mappen. De opdracht beheert door de gebruiker opgegeven bestandspaden; er is geen aparte bereikselector beschikbaar.

## RELATED LINKS

- [Onlineversie](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)

