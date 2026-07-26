---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Ajoute ou met à jour un bloc de démarrage ColorScripts-Enhanced géré dans un fichier de profil PowerShell.

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

Cette commande ne possède aucun alias.

## DESCRIPTION

Ajoute un bloc de démarrage géré au profil PowerShell sélectionné. Le bloc importe ColorScripts-Enhanced et peut appeler `Show-ColorScript` après l'importation. `-SkipStartupScript` écrit un bloc d'importation uniquement.

Lorsque `-ProfilePath` est omis, la commande préfère `$PROFILE.CurrentUserAllHosts` et utilise sinon le premier chemin de profil défini. Le fichier de profil et les répertoires parents manquants sont créés si nécessaire.

Les blocs ColorScripts-Enhanced gérés ou hérités existants sont remplacés au lieu d'être dupliqués. Si le profil importe déjà le module en dehors d'un bloc géré, la commande le laisse inchangé sauf si `-Force` est spécifié. `-Force` permet de remplacer le contenu du module reconnu tout en préservant le contenu du profil sans rapport.

Le comportement de démarrage généré est résolu à partir de paramètres explicites et d'une configuration persistante. `-AutoShow` active explicitement l'affichage, `-DefaultStartupScript` sélectionne un script nommé et l'inclusion de Pokémon peut être fournie directement ou résolue via l'invite interactive et ses remplacements documentés. À moins que `-SkipCacheBuild` ne soit utilisé, la commande peut préchauffer les entrées de cache sélectionnées par la stratégie après la mise à jour du profil.

## EXAMPLES

### EXAMPLE 1

Ajouter au profil de l'utilisateur actuel pour tous les hôtes (comportement par défaut).

```powershell
Add-ColorScriptProfile
```

Cela ajoute à la fois l'importation de module et l'appel `Show-ColorScript` à `$PROFILE.CurrentUserAllHosts`.

### EXAMPLE 2

Ajouter au profil de l'utilisateur actuel pour l'hôte actuel uniquement, sans le script de démarrage.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost -SkipStartupScript
```

Cela ajoute un bloc géré d'importation uniquement au profil d'hôte actuel.

### EXAMPLE 3

Ajoutez à un chemin de profil personnalisé avec l’expansion des variables d’environnement.

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

Cela cible un fichier de profil spécifique en dehors des emplacements de profil PowerShell standard.

### EXAMPLE 4

Forcez le réajout de l'extrait même s'il existe déjà.

```powershell
Add-ColorScriptProfile -Force
```

Cela met à jour le contenu du profil ColorScripts-Enhanced reconnu tout en préservant les lignes de profil sans rapport.

### EXAMPLE 5

Configuration sur une nouvelle machine - créez un profil si nécessaire et ajoutez des scripts de couleurs à tous les hôtes.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts -Confirm:$false
Write-Host "Profil configuré ! Redémarrez le terminal pour afficher des scripts de couleurs au démarrage."
```

### EXAMPLE 6

Ajoutez avec un script de couleurs spécifique pour l'affichage de démarrage :

```powershell
Add-ColorScriptProfile -DefaultStartupScript mandelbrot-zoom -AutoShow
```

### EXAMPLE 7

Vérifiez que le profil a été ajouté correctement :

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Ciblez explicitement le profil de l'hôte actuel ou de tous les hôtes :

```powershell
# Pour Windows Terminal ou ConEmu uniquement
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost

# Pour tous les hôtes PowerShell (ISE, VSCode, Console)
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts
```

### EXAMPLE 9

Utilisation de chemins relatifs et d'expansion de tilde :

```powershell
# Utilisation de l'extension tilde pour le répertoire personnel
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# Utilisation du chemin relatif du répertoire actuel
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

Affichez quotidiennement différents script de couleurs en ajoutant une logique personnalisée :

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Ajoutez ensuite ceci manuellement à $PROFILE :
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

### EXAMPLE 11

Ignorer automatiquement les scripts Pokémon lors de l'affichage de l'illustration de démarrage :

```powershell
Add-ColorScriptProfile -IncludePokemon
```

Cela ajoute `Show-ColorScript -IncludePokemon` (enveloppé dans un étui de protection try/catch) au profil afin que l'illustration de lancement puisse inclure des scripts Pokémon.

## PARAMETERS

### -AutoShow

Contrôle si le bloc de profil géré affiche un script de couleurs après l'importation du module.

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

Vous demande une confirmation avant d’exécuter l’applet de commande.

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

Spécifie le nom script de couleurs écrit dans le bloc de profil géré pour l'affichage au démarrage.

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

Met à jour le contenu ColorScripts-Enhanced reconnu dans le profil tout en conservant les lignes sans rapport. Il ne crée pas volontairement de blocs gérés en double.

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

Affiche des informations d’aide pour cette applet de commande. Équivalent à l'utilisation de `Get-Help Add-ColorScriptProfile`.

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

Ajoutez `-IncludePokemon` à l'appel `Show-ColorScript` généré afin que les Pokémon scripts de couleurs soient inclus au démarrage lorsqu'ils sont présents. Ignoré lorsque `-SkipStartupScript` est utilisé.

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

Pré-répondez à l'invite d'inclusion de Pokémon. Accepte O/Oui ou N/Non. Honore également la variable d'environnement
`COLOR_SCRIPTS_ENHANCED_POKEMON_PROMPT_RESPONSE` et la variable globale
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

Spécifie le fichier de profil PowerShell à mettre à jour. L'alias Path est également accepté.

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

Supprimez le préchauffage du cache facultatif. Un préchauffage est tenté uniquement lorsque le problème `ProfileAutoShow` résolu
Le paramètre est activé, la création de cache n'a pas été désactivée, le profil cible est en dehors du
répertoire temporaire du système et l'opération est approuvée par `ShouldProcess`. Le commandement respecte également les
variable d'environnement `COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` et la variable globale
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

Ignorez l'invite interactive qui demande s'il faut inclure Pokémon scripts de couleurs au démarrage.

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

Ignorez l’ajout de `Show-ColorScript` au profil. Seule la ligne `Import-Module ColorScripts-Enhanced` est ajoutée. Utilisez-le si vous souhaitez contrôler manuellement le moment où les scripts de couleurs sont affichés.

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

Montre ce qui se passerait si l’applet de commande s’exécutait. L'applet de commande n'est pas exécutée.

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

Cette applet de commande prend en charge les paramètres communs :
Pour plus d'informations, consultez
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Cette applet de commande n'accepte pas les entrées de pipeline.

## OUTPUTS

### System.Object

Renvoie un objet personnalisé avec les propriétés suivantes :

- **Path** (string) : Le chemin complet vers le fichier de profil sélectionné
- **Changed** (bool) : indique si le profil a été réellement modifié
- **Message** (string) : Un message d'état décrivant le résultat de l'opération
- **IncludePokemon** (bool) : Le choix d'inclusion Pokémon de démarrage
- **CacheBuilt** (bool) : indique si le préchauffage du cache facultatif est terminé

## NOTES

**Auteur :** Nick

**Module :** ColorScripts-Enhanced

**Nécessite :** PowerShell 5.1 ou version ultérieure

Le fichier de profil est créé automatiquement s'il n'existe pas, y compris les répertoires parents nécessaires. La commande gère les chemins de fichiers fournis par l'utilisateur ; il n'expose pas de sélecteur de portée distinct.

## RELATED LINKS

- [Version en ligne](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)

