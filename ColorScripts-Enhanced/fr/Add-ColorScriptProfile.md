---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/fr/Add-ColorScriptProfile.md
Locale: fr-FR
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Ajoute l'importation du module ColorScripts-Enhanced (et éventuellement Show-ColorScript) à un fichier de profil PowerShell.

## SYNTAX

### \_\_AllParameterSets

```text
Add-ColorScriptProfile [[-Scope] <string>] [[-Path] <string>] [-h] [-SkipStartupScript] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

Cet applet de commande a les alias suivants :

- Aucun

## DESCRIPTION

Ajoute un extrait de démarrage au fichier de profil PowerShell spécifié. L'extrait importe toujours le module ColorScripts-Enhanced et, sauf si supprimé avec `-SkipStartupScript`, ajoute un appel à `Show-ColorScript` afin qu'un colorscript aléatoire soit affiché au lancement de PowerShell.

Le fichier de profil est créé automatiquement s'il n'existe pas déjà. Les importations dupliquées sont évitées sauf si `-Force` est spécifié.

Le paramètre `-Path` accepte les chemins relatifs, les variables d'environnement et l'expansion `~`, facilitant le ciblage de profils en dehors des emplacements par défaut. Si `-Path` n'est pas fourni, le paramètre `-Scope` détermine quel profil PowerShell standard modifier.

## EXAMPLES

### EXAMPLE 1

Ajouter au profil de l'utilisateur actuel pour tous les hôtes (comportement par défaut).

```powershell
Add-ColorScriptProfile
```

Cela ajoute à la fois l'importation du module et l'appel `Show-ColorScript` à `$PROFILE.CurrentUserAllHosts`.

### EXAMPLE 2

Ajouter au profil de l'utilisateur actuel pour l'hôte actuel uniquement, sans le script de démarrage.

```powershell
Add-ColorScriptProfile -Scope CurrentUserCurrentHost -SkipStartupScript
```

Cela ajoute uniquement la ligne `Import-Module ColorScripts-Enhanced` au profil de l'hôte actuel.

### EXAMPLE 3

Ajouter à un chemin de profil personnalisé avec expansion de variable d'environnement.

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

Cela cible un fichier de profil spécifique en dehors des emplacements de profil PowerShell standard.

### EXAMPLE 4

Forcer la ré-ajout de l'extrait même s'il existe déjà.

```powershell
Add-ColorScriptProfile -Force
```

Cela ajoute à nouveau l'extrait, même si le profil contient déjà une instruction d'importation pour ColorScripts-Enhanced.

### EXAMPLE 5

Configuration sur une nouvelle machine - créer le profil si nécessaire et ajouter ColorScripts à tous les hôtes.

```powershell
$profileExists = Test-Path $PROFILE.CurrentUserAllHosts
if (-not $profileExists) {
    New-Item -Path $PROFILE.CurrentUserAllHosts -ItemType File -Force | Out-Null
}
Add-ColorScriptProfile -Scope CurrentUserAllHosts -Confirm:$false
Write-Host "Profil configuré ! Redémarrez votre terminal pour voir les colorscripts au démarrage."
```

### EXAMPLE 6

Ajouter avec un colorscript spécifique pour l'affichage (ajouter manuellement après cette commande) :

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Puis modifier manuellement $PROFILE pour ajouter :
# Show-ColorScript -Name mandelbrot-zoom
```

### EXAMPLE 7

Vérifier que le profil a été ajouté correctement :

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Ajouter à une portée de profil spécifique ciblant l'hôte actuel uniquement :

```powershell
# Pour Windows Terminal ou ConEmu uniquement
Add-ColorScriptProfile -Scope CurrentUserCurrentHost

# Pour tous les hôtes PowerShell (ISE, VSCode, Console)
Add-ColorScriptProfile -Scope CurrentUserAllHosts
```

### EXAMPLE 9

Utilisation de chemins relatifs et d'expansion tilde :

```powershell
# Utilisation de l'expansion tilde pour le répertoire d'accueil
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# Utilisation du chemin relatif du répertoire actuel
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

Afficher un colorscript différent quotidiennement en ajoutant une logique personnalisée :

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Puis ajouter ceci à $PROFILE manuellement :
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

## PARAMETERS

### -Confirm

Invite à confirmer avant d'exécuter l'applet de commande.

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

Ajoute l'extrait même si le profil contient déjà une ligne `Import-Module ColorScripts-Enhanced`. Utilisez ceci pour forcer des entrées dupliquées ou ré-ajouter l'extrait après suppression manuelle.

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

Affiche les informations d'aide pour cette applet de commande. Équivalent à utiliser `Get-Help Add-ColorScriptProfile`.

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

Chemin explicite du profil à mettre à jour. Remplace `-Scope` lorsqu'il est fourni. Prend en charge les variables d'environnement (par exemple, `$env:USERPROFILE`), les chemins relatifs et l'expansion `~` pour le répertoire d'accueil.

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

Portée du profil à mettre à jour lorsque `-Path` n'est pas fourni. Accepte les propriétés de profil PowerShell standard : `CurrentUserAllHosts`, `CurrentUserCurrentHost`, `AllUsersAllHosts` ou `AllUsersCurrentHost`. Par défaut à `CurrentUserAllHosts`.

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

Ignore l'ajout de `Show-ColorScript` au profil. Seule la ligne `Import-Module ColorScripts-Enhanced` est ajoutée. Utilisez ceci si vous souhaitez contrôler manuellement quand les colorscripts sont affichés.

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

Montre ce qui se passerait si l'applet de commande s'exécute. L'applet de commande n'est pas exécutée.

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

Cette applet de commande prend en charge les paramètres communs : -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction et -WarningVariable. Pour plus d'informations, voir
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Cette applet de commande n'accepte pas d'entrée de pipeline.

## OUTPUTS

### System.Object

Retourne un objet personnalisé avec les propriétés suivantes :

- **ProfilePath** (string) : Le chemin complet vers le fichier de profil modifié
- **Changed** (bool) : Si le profil a été réellement modifié
- **Message** (string) : Un message de statut décrivant le résultat de l'opération

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 ou version ultérieure

Le fichier de profil est créé automatiquement s'il n'existe pas, y compris tous les répertoires parents nécessaires. Les importations dupliquées sont détectées et supprimées sauf si `-Force` est utilisé.

Si vous avez besoin d'autorisations élevées pour modifier un profil AllUsers, assurez-vous d'exécuter PowerShell en tant qu'Administrateur.

## RELATED LINKS

- [Online Version](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
- [Show-ColorScript](./Show-ColorScript.md)
- [New-ColorScriptCache](./New-ColorScriptCache.md)
- [Clear-ColorScriptCache](./Clear-ColorScriptCache.md)
- [GitHub Repository](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
