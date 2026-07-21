---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Persiste les modifications apportées au cache et à la configuration de démarrage de ColorScripts-Enhanced.

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

`Set-ColorScriptConfiguration` fournit un moyen persistant de personnaliser le comportement et l'emplacement de stockage du module ColorScripts-Enhanced. Cette cmdlet met à jour le fichier de configuration du module, vous permettant de contrôler divers aspects du rendu et du stockage des scripts.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

Déplace le cache vers `D:/Temp/ColorScriptsCache`, active l'affichage automatique lors de l'import du module, désactive l'auto-affichage du profil, et définit `bars` comme script par défaut.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

Efface le script par défaut et retourne l'objet de configuration résultant, vous permettant de vérifier que le paramètre a été supprimé.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

Relocalise le cache vers le répertoire TEMP de Windows et affiche la configuration mise à jour complète en format liste. Utile pour les scénarios de test temporaires.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

Désactive le rendu automatique des couleurscripts lors du chargement du module. Utile si vous préférez un contrôle manuel sur le moment où les scripts sont affichés.

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

Définit un chemin de cache de style Linux/macOS en utilisant l'expansion tilde et configure 'crunch' comme script par défaut pour toutes les opérations.

## PARAMETERS

### -AutoShowOnImport

Active ou désactive le rendu automatique d'un couleurscript lorsque le module est importé. Lorsqu'il est activé (`$true`), un couleurscript s'affiche immédiatement lors de l'import du module, fournissant un retour visuel instantané. Lorsqu'il est désactivé (`$false`), les scripts ne s'affichent que lorsqu'ils sont explicitement invoqués. Si non spécifié, le paramètre existant reste inchangé.

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

Spécifie le répertoire où les fichiers et métadonnées des couleurscripts sont stockés. Prend en charge les chemins absolus, les chemins relatifs (résolus à partir de l'emplacement actuel), les variables d'environnement (par exemple, `$env:USERPROFILE`), et l'expansion tilde (`~`) pour le répertoire d'accueil.

Si le répertoire spécifié n'existe pas, il sera créé automatiquement avec les permissions appropriées. Fournissez une chaîne vide (`''`) pour effacer le chemin personnalisé et revenir à l'emplacement par défaut spécifique à la plateforme. Lorsqu'il n'est pas spécifié, le paramètre de chemin de cache existant est préservé.

**Note** : Changer le chemin de cache ne migre pas automatiquement les fichiers mis en cache existants. Vous devrez peut-être copier manuellement les fichiers ou les laisser se régénérer.

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

Prompts you for confirmation before running the cmdlet.

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

Définit ou efface le nom du couleurscript par défaut utilisé par les assistants de profil, les fonctionnalités d'auto-affichage, et lorsqu'aucun script n'est explicitement spécifié dans les commandes. Cela doit correspondre au nom de base d'un fichier script sans extension (par exemple, `'bars'`, pas `'bars.ps1'`).

Fournissez une chaîne vide (`''`) pour supprimer le défaut stocké, revenant au comportement par défaut du module (généralement une sélection aléatoire). Lorsque ce paramètre est omis, le paramètre de script par défaut actuel reste inchangé.

Le script spécifié doit exister dans le répertoire des scripts du module pour être utilisé avec succès.

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

Affiche l'aide détaillée de cette commande sans effectuer l'opération.

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

Retourne l'objet de configuration mis à jour après avoir effectué les modifications. Sans ce commutateur, la cmdlet fonctionne silencieusement (aucune sortie). L'objet retourné a la même structure que `Get-ColorScriptConfiguration` et peut être inspecté, stocké ou redirigé vers d'autres cmdlets pour un traitement supplémentaire.

Utile pour la vérification, la journalisation ou l'enchaînement de commandes de configuration.

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

Contrôle si les extraits de profil générés par `Add-ColorScriptProfile` incluent une invocation automatique de `Show-ColorScript`. Lorsque `$true`, le code de profil affichera un couleurscript à chaque démarrage du shell. Lorsque `$false`, le profil chargera le module mais n'affichera pas automatiquement les scripts.

Ce paramètre n'affecte que le code de profil nouvellement généré ; les modifications de profil existantes ne sont pas automatiquement mises à jour. Omettre ce paramètre laisse le paramètre actuel inchangé.

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

Runs the command in a mode that only reports what would happen without performing the actions.

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

Cette cmdlet n'accepte pas d'entrée pipeline.

## OUTPUTS

### None (2)

Par défaut, cette cmdlet ne produit aucune sortie.

### System.Collections.Hashtable

Lorsque `-PassThru` est spécifié, retourne une hashtable contenant la configuration complète mise à jour. La structure correspond à la sortie de `Get-ColorScriptConfiguration`, avec des clés telles que `CachePath`, `AutoShowOnImport`, `ProfileAutoShow`, et `DefaultScript`.

## NOTES

Configuration is persisted only after validation and confirmation succeed.
`-WhatIf` performs no filesystem writes.
Use `Get-ColorScriptConfiguration` to inspect the effective values and storage paths after the operation.

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
