---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Conserver les modifications apportées au cache ColorScripts-Enhanced et à la configuration de démarrage.

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Cette commande ne possède aucun alias.

## DESCRIPTION

`Set-ColorScriptConfiguration` fournit un moyen persistant de personnaliser le comportement et l'emplacement de stockage du module ColorScripts-Enhanced. Cette applet de commande met à jour le fichier de configuration du module, vous permettant de contrôler divers aspects du rendu et du stockage des scripts.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

Déplace le cache vers `D:/Temp/ColorScriptsCache`, active l'affichage automatique lors de l'importation de module, désactive l'affichage automatique du profil et définit `bars` comme script par défaut.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

Efface le script par défaut et renvoie l'objet de configuration résultant, vous permettant de vérifier que le paramètre a été supprimé.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

Déplace le cache vers le répertoire Windows TEMP et affiche la configuration complète mise à jour sous forme de liste. Utile pour les scénarios de tests temporaires.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

Désactive le rendu automatique script de couleurs lors du chargement du module. Utile si vous préférez un contrôle manuel sur le moment où les scripts sont affichés.

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

Définit un chemin de cache de style Linux/macOS à l'aide de l'extension tilde et configure 'crunch' comme script par défaut pour toutes les opérations.

## PARAMETERS

### -AutoShowOnImport

Activez ou désactivez le rendu automatique d'un script de couleurs lorsque le module est importé. Lorsqu'il est activé (`$true`), un script de couleurs s'affiche immédiatement lors de l'importation du module, fournissant un retour visuel instantané. Lorsqu'ils sont désactivés (`$false`), les scripts s'affichent uniquement lorsqu'ils sont explicitement invoqués. S’il n’est pas spécifié, le paramètre existant reste inchangé.

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

Spécifie le répertoire dans lequel les charges utiles `.cache` rendues et les fichiers annexes de validation `.cacheinfo` sont stockés. Les scripts de couleurs sources et les métadonnées du module restent dans le module installé. Prend en charge les chemins absolus, les chemins relatifs (résolus à partir de l'emplacement actuel), les variables d'environnement (par exemple, `$env:USERPROFILE`) et l'expansion du tilde (`~`).

Si le répertoire spécifié n'existe pas, il sera créé automatiquement avec les autorisations appropriées. Fournissez un string (`''`) vide pour effacer le chemin personnalisé et revenir à l'emplacement par défaut spécifique à la plate-forme. Lorsqu'il n'est pas spécifié, le paramètre de chemin de cache existant est conservé.

**Note** : la modification du chemin du cache ne migre pas automatiquement les fichiers mis en cache existants. Vous devrez peut-être copier manuellement les fichiers ou autoriser leur régénération.

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

### -DefaultScript

Définit ou efface le nom script de couleurs par défaut utilisé par les assistants de profil, les fonctionnalités d'affichage automatique et lorsqu'aucun script n'est explicitement spécifié dans les commandes. Cela doit correspondre au nom de base d'un fichier de script sans extension (par exemple, `'bars'`, et non `'bars.ps1'`).

Fournissez un string (`''`) vide pour supprimer la valeur par défaut stockée, en revenant au comportement par défaut au niveau du module (généralement une sélection aléatoire). Lorsque ce paramètre est omis, le paramètre de script par défaut actuel reste inchangé.

Le script spécifié doit exister dans le répertoire de script du module pour être utilisé avec succès.

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

Affiche une aide détaillée pour cette commande sans effectuer l'opération.

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

Renvoie l'objet de configuration mis à jour après avoir apporté des modifications. Sans ce commutateur, l’applet de commande fonctionne silencieusement (aucune sortie). L'objet renvoyé a la même structure que `Get-ColorScriptConfiguration` et peut être inspecté, stocké ou redirigé vers d'autres applets de commande pour un traitement ultérieur.

Utile pour la vérification, la journalisation ou le chaînage des commandes de configuration.

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

Contrôle si les extraits de profil générés par `Add-ColorScriptProfile` incluent une invocation automatique de `Show-ColorScript`. Lorsque `$true`, le code de profil affichera un script de couleurs à chaque démarrage du shell. Lorsque `$false`, le profil chargera le module mais pas les scripts d'affichage automatique.

Ce paramètre affecte uniquement le code de profil nouvellement généré ; les modifications de profil existantes ne sont pas automatiquement mises à jour. L'omission de ce paramètre laisse le paramètre actuel inchangé.

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

Exécute la commande dans un mode qui rapporte uniquement ce qui se passerait sans effectuer les actions.

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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Pour plus d'informations, consultez
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Cette applet de commande n'accepte pas les entrées de pipeline.

## OUTPUTS

### None (2)

Par défaut, cette applet de commande ne produit aucune sortie.

### System.Collections.Hashtable

Lorsque `-PassThru` est spécifié, renvoie la table de hachage imbriquée produite par `Get-ColorScriptConfiguration` : les valeurs du cache se trouvent sous `Cache` et les valeurs de démarrage sous `Startup`.

## NOTES

La configuration est conservée uniquement après la réussite de la validation et de la confirmation. `-WhatIf` n'effectue aucune écriture sur le système de fichiers. Utilisez `Get-ColorScriptConfiguration` pour inspecter les valeurs effectives et les chemins de stockage après l'opération.

## RELATED LINKS

- [Version en ligne](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)

