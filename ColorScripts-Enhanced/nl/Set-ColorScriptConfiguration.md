---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: nl
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Houd wijzigingen in de ColorScripts-Enhanced-cache en opstartconfiguratie vol.

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Deze opdracht heeft geen aliassen.

## DESCRIPTION

`Set-ColorScriptConfiguration` biedt een permanente manier om het gedrag en de opslaglocatie van de ColorScripts-Enhanced-module aan te passen. Met deze cmdlet wordt het configuratiebestand van de module bijgewerkt, zodat u verschillende aspecten van scriptweergave en -opslag kunt beheren.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

Verplaatst de cache naar `D:/Temp/ColorScriptsCache`, schakelt automatische weergave in bij het importeren van modules, schakelt automatisch weergeven van profielen uit en stelt `bars` in als het standaardscript.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

Wist het standaardscript en retourneert het resulterende configuratieobject, zodat u kunt verifiëren dat de instelling is verwijderd.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

Verplaatst de cache naar de Windows TEMP-map en geeft de volledige bijgewerkte configuratie weer in lijstindeling. Handig voor tijdelijke testscenario's.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

Schakelt de automatische weergave van colorscript uit wanneer de module wordt geladen. Handig als u liever handmatige controle heeft dan wanneer scripts worden weergegeven.

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

Stelt een cachepad in Linux/macOS-stijl in met behulp van tilde-uitbreiding en configureert 'crunch' als het standaardscript voor alle bewerkingen.

## PARAMETERS

### -AutoShowOnImport

Schakel de automatische weergave van een colorscript in of uit wanneer de module wordt geïmporteerd. Indien ingeschakeld (`$true`), wordt er onmiddellijk na het importeren van de module een colorscript weergegeven, waardoor direct visuele feedback wordt gegeven. Indien uitgeschakeld (`$false`), worden scripts alleen weergegeven als ze expliciet worden aangeroepen. Indien niet gespecificeerd, blijft de bestaande instelling ongewijzigd.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
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
HelpMessage: ''
```

### -CachePath

Specificeert de map waar de weergegeven `.cache`-payloads en begeleidende `.cacheinfo`-validatiemetadatabestanden worden opgeslagen. Broncolorscripts en modulemetadata blijven in de geïnstalleerde module. Ondersteunt absolute paden, relatieve paden (opgelost vanaf de huidige locatie), omgevingsvariabelen (bijvoorbeeld `$env:USERPROFILE`) en tilde-uitbreiding (`~`).

Als de opgegeven map niet bestaat, wordt deze automatisch aangemaakt met de juiste machtigingen. Geef een lege string (`''`) op om het aangepaste pad te wissen en terug te keren naar de platformspecifieke standaardlocatie. Als u dit niet opgeeft, blijft de bestaande cachepadinstelling behouden.

**Note**: Als u het cachepad wijzigt, worden bestaande bestanden in de cache niet automatisch gemigreerd. Mogelijk moet u bestanden handmatig kopiëren of toestaan ​​dat ze opnieuw worden gegenereerd.

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

### -DefaultScript

Stelt de standaard colorscript-naam in of wist deze die wordt gebruikt door profielhelpers, functies voor automatisch weergeven en wanneer er geen script expliciet is opgegeven in opdrachten. Dit moet overeenkomen met de basisnaam van een scriptbestand zonder extensie (bijvoorbeeld `'bars'`, niet `'bars.ps1'`).

Geef een lege string (`''`) op om de opgeslagen standaard te verwijderen en terug te keren naar het standaardgedrag op moduleniveau (doorgaans willekeurige selectie). Wanneer deze parameter wordt weggelaten, blijft de huidige standaardscriptinstelling ongewijzigd.

Om succesvol te kunnen worden gebruikt, moet het opgegeven script in de scriptdirectory van de module voorkomen.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -h

Geeft gedetailleerde hulp weer voor deze opdracht zonder de bewerking uit te voeren.

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

### -PassThru

Retourneert het bijgewerkte configuratieobject na het aanbrengen van wijzigingen. Zonder deze schakeloptie werkt de cmdlet op de achtergrond (geen uitvoer). Het geretourneerde object heeft dezelfde structuur als `Get-ColorScriptConfiguration` en kan worden geïnspecteerd, opgeslagen of doorgesluisd naar andere cmdlets voor verdere verwerking.

Handig voor verificatie, logboekregistratie of het koppelen van configuratieopdrachten.

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

### -ProfileAutoShow

Bepaalt of profielfragmenten die door `Add-ColorScriptProfile` worden gegenereerd, een automatische `Show-ColorScript`-aanroep bevatten. Wanneer `$true` wordt weergegeven, geeft de profielcode bij elke shell-start een colorscript weer. Wanneer `$false` wordt geladen, laadt het profiel de module, maar worden de scripts niet automatisch weergegeven.

Deze instelling heeft alleen invloed op de nieuw gegenereerde profielcode; bestaande profielwijzigingen worden niet automatisch bijgewerkt. Als u deze parameter weglaat, blijft de huidige instelling ongewijzigd.

```yaml
Type: System.Nullable`1[System.Boolean]
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

### -WhatIf

Voert de opdracht uit in een modus die alleen rapporteert wat er zou gebeuren zonder de acties uit te voeren.

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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Zie voor meer informatie
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Deze cmdlet accepteert geen pijplijninvoer.

## OUTPUTS

### None (2)

Standaard produceert deze cmdlet geen uitvoer.

### System.Collections.Hashtable

Wanneer `-PassThru` is opgegeven, wordt de geneste hashtabel geretourneerd die is geproduceerd door `Get-ColorScriptConfiguration`: cachewaarden bevinden zich onder `Cache` en opstartwaarden bevinden zich onder `Startup`.

## NOTES

De configuratie blijft alleen behouden nadat de validatie en bevestiging zijn geslaagd. `-WhatIf` voert geen bestandssysteemschrijfbewerkingen uit. Gebruik `Get-ColorScriptConfiguration` om na de bewerking de effectieve waarden en opslagpaden te inspecteren.

## RELATED LINKS

- [Onlineversie](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)

