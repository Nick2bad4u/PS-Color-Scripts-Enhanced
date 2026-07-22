---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Clear-ColorScriptCache
---

# Clear-ColorScriptCache

## SYNOPSIS

Supprimez les fichiers de sortie script de couleurs mis en cache.

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

Cette commande ne possède aucun alias.

## DESCRIPTION

L'applet de commande `Clear-ColorScriptCache` supprime les fichiers de sortie mis en cache générés par le module ColorScripts-Enhanced. Chaque entrée se compose d'une charge utile `<name>.cache` rendue et d'un fichier annexe de validation `<name>.cacheinfo` dans le répertoire de cache effectif.

Vous pouvez supprimer les entrées du cache de manière sélective à l'aide du paramètre `-Name` avec des modèles de caractères génériques, ou supprimer toutes les entrées en même temps avec le paramètre `-All`. `-All` supprime également les fichiers annexes orphelins dont la charge utile a été supprimée. L'applet de commande prend en charge le filtrage par `-Category` et `-Tag` pour cibler des sous-ensembles spécifiques de scripts mis en cache.

Les noms de script sans correspondance signalent un statut `Missing` dans les résultats. Utilisez `-DryRun` pour prévisualiser les actions de suppression sans modifier le système de fichiers et `-Path` pour cibler un autre répertoire de cache (utile pour les configurations de cache personnalisées ou les environnements CI/CD).

Les entrées de cache éligibles sont régénérées lorsque le moteur de rendu sélectionné par la stratégie correspondante est affiché ou que `New-ColorScriptCache` est invoqué. Les scripts groupés déterministes s'affichent en cours de processus et ne créent pas d'entrées de cache.

Pour les scénarios d'automatisation, combinez `-PassThru` pour capturer des résultats structurés, `-Quiet` pour supprimer le message récapitulatif ou `-NoAnsiOutput` pour émettre des résumés en texte brut sans codes couleur ANSI.

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

Supprime tous les fichiers de cache du répertoire de cache par défaut sans demander de confirmation. Ceci est utile pour actualiser complètement le cache après les mises à jour du module ou lors du dépannage des problèmes d'affichage.

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

Prévisualise les fichiers de cache sur le thème des aurores qui seraient supprimés sans les supprimer réellement. La sortie affiche les fichiers de cache qui correspondent au modèle, vous permettant de vérifier la sélection avant de procéder à la suppression.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name Galaxy -Path $env:TEMP -Confirm:$false
```

Efface le fichier cache du moteur de rendu 'Galaxy' éligible à partir d'un répertoire personnalisé sous TEMP. Ceci est utile lors du test de `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` ou d’un autre emplacement de cache isolé.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Category Mathematical -WhatIf
```

Montre ce qui se passerait si les fichiers de cache des scripts de la catégorie `Mathematical` étaient supprimés. Le paramètre `-WhatIf` empêche la suppression.

### EXAMPLE 5

```powershell
Get-ColorScriptList -Tag retro | Clear-ColorScriptCache -DryRun
```

Utilise l'entrée du pipeline pour prévisualiser la suppression des fichiers de cache pour tous les scripts marqués 'retro'. Combine le filtrage par balise avec un aperçu à sec avant de s'engager dans la suppression.

### EXAMPLE 6

```powershell
Clear-ColorScriptCache -Name 'test-*', 'demo-*' -Confirm:$false
```

Supprime les fichiers cache de tous les scripts dont les noms commencent par 'test-' ou 'demo-' sans confirmation. Plusieurs modèles de caractères génériques peuvent être spécifiés sous forme de tableau.

### EXAMPLE 7

```powershell
# Supprimer les fichiers de cache et reconstruire les entrées sélectionnées par la stratégie
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -PassThru | Measure-Object
Write-Host "Le cache a été reconstruit correctement"
```

Supprime toutes les charges utiles du cache, reconstruit les entrées sélectionnées par la stratégie de cache dynamique, puis affiche des statistiques sur ces entrées reconstruites.

### EXAMPLE 8

```powershell
# Effacer les anciennes entrées de cache datant de plus de 30 jours
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$thirtyDaysAgo = (Get-Date).AddDays(-30)
Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $thirtyDaysAgo } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
Write-Host "Les anciens fichiers de cache ont été nettoyés"
```

Supprime les fichiers de cache qui n'ont pas été mis à jour depuis plus de 30 jours.

### EXAMPLE 9

```powershell
# Rapport de gestion du cache
$cacheDir = (Get-ColorScriptConfiguration).Cache.EffectivePath
$beforeCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Clear-ColorScriptCache -Category Geometric -Confirm:$false
$afterCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Write-Host "$($beforeCount - $afterCount) fichiers de cache géométriques ont été supprimés"
```

Affiche des statistiques sur les opérations de suppression du cache.

### EXAMPLE 10

```powershell
# Dépannage - effacer et reconstruire un script spécifique
$scriptName = "Galaxy"
Clear-ColorScriptCache -Name $scriptName -Confirm:$false
New-ColorScriptCache -Name $scriptName -Force
Show-ColorScript -Name $scriptName
```

Efface et reconstruit le cache d'un moteur de rendu éligible selon la stratégie, puis l'affiche pour vérification.

### EXAMPLE 11

```powershell
# Filtrer par plusieurs catégories
Clear-ColorScriptCache -Category Geometric,Abstract -DryRun -PassThru |
    Select-Object CacheFile |
    Measure-Object
```

Affiche combien de fichiers de cache seraient supprimés en cas de filtrage par plusieurs catégories.

## PARAMETERS

### -All

Sélectionnez chaque entrée de cache dans le répertoire cible. `-Category` et `-Tag` peuvent restreindre davantage le jeu de paramètres de sélection totale ; `-Name` appartient plutôt au jeu de paramètres de sélection.

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

Filtrez les scripts cibles par catégorie avant d'évaluer les entrées du cache. Seuls les fichiers cache des scripts correspondant aux catégories spécifiées seront pris en compte pour la suppression. Accepte un tableau de noms de catégories et peut être combiné avec `-Tag` pour un filtrage plus précis.

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

Vous demande une confirmation avant d’exécuter l’applet de commande. Par défaut, cette option est activée pour empêcher la suppression accidentelle des fichiers de cache. Utilisez `-Confirm:$false` pour contourner l'invite de confirmation.

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

Prévisualisez les actions de suppression sans supprimer aucun fichier. L'applet de commande affichera les fichiers de cache qui seraient supprimés mais ne modifiera pas le système de fichiers. Ceci est utile pour vérifier vos critères de sélection avant de vous engager dans la suppression.

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

Affiche une aide détaillée pour cette commande sans effectuer l'opération.

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

Noms ou modèles génériques identifiant les fichiers de cache à supprimer. Accepte l'entrée de pipeline et la liaison de propriété à partir d'objets avec une propriété `Name`. Les caractères génériques (`*`, `?`) sont pris en charge pour la correspondance de modèles. Mutuellement exclusif avec `-All`.

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

Désactivez les séquences de couleurs ANSI dans la sortie récapitulative. Ceci est utile pour les consoles ou les processeurs de journaux qui n'interprètent pas le style ANSI, garantissant que le texte récapitulatif reste lisible en texte brut.

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

Renvoie des objets de résultat détaillés pour chaque entrée de cache traitée. Sans ce commutateur, l’applet de commande écrit uniquement un message récapitulatif. Chaque enregistrement direct comprend le nom du script, le chemin du fichier cache, l'état et tout texte d'erreur associé pour une inspection ou un rapport plus approfondi.

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

Répertoire de cache alternatif sur lequel opérer. La valeur par défaut est le chemin de cache standard du module s'il n'est pas spécifié. Utilisez ce paramètre lorsque vous travaillez avec des emplacements de cache personnalisés définis via la variable d'environnement `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` ou lors de la gestion des fichiers de cache dans des répertoires alternatifs à des fins de test ou à des fins CI/CD.

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

Supprimez le message récapitulatif émis une fois la suppression du cache terminée. Utilisez ce commutateur lors de l'exécution dans des contextes d'automatisation silencieux où seule une sortie structurée (telle que des enregistrements `-PassThru`, des avertissements ou des erreurs) doit être produite.

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

Filtrez les scripts cibles par balise de métadonnées avant d'évaluer les entrées du cache. Seuls les fichiers cache des scripts avec les balises correspondantes seront pris en compte pour la suppression. Accepte un tableau de noms de balises et peut être combiné avec `-Category` pour un contrôle plus granulaire sur les fichiers de cache ciblés.

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

Montre ce qui se passerait si l’applet de commande s’exécutait sans réellement exécuter l’opération. L'applet de commande affiche les actions qu'elle effectuerait mais ne modifie pas le système de fichiers. Il s'agit d'un paramètre commun standard du PowerShell qui fonctionne de manière similaire au `-DryRun` mais suit les conventions intégrées du PowerShell.

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

### System.String

Vous pouvez rediriger les noms de script vers cette applet de commande. Chaque nom sera évalué pour la suppression du fichier cache en fonction des paramètres spécifiés.

### System.String[]

Vous pouvez rediriger un tableau de noms de script vers cette applet de commande. Ceci est particulièrement utile en combinaison avec `Get-ColorScriptList` pour filtrer les scripts selon divers critères avant de vider leurs caches.

### System.Management.Automation.PSObject

Vous pouvez rediriger des objets avec une propriété `Name` vers cette applet de commande. L'applet de commande extraira la valeur de la propriété `Name` et l'utilisera pour identifier les fichiers de cache à supprimer.

## OUTPUTS

### System.Object

Avec `-PassThru`, renvoie un enregistrement d'état pour chaque fichier de cache traité. Chaque objet de sortie contient les propriétés suivantes :

- **Status** : Le résultat de l'opération (`Removed`, `Missing`, `DryRun`, `SkippedByUser` ou `Error`)
- **CacheFile** : Le chemin complet vers le fichier cache qui a été traité
- **Message** : Texte descriptif expliquant le résultat de l'opération
- **Name** : Le nom du script associé au fichier cache

## NOTES

**Auteur** : Nick
**Module** : ColorScripts-Enhanced

Les fichiers cache sont stockés avec une extension `.cache` dans le répertoire cache du module. Chaque fichier cache correspond à un seul script de couleurs et contient la sortie ANSI pré-rendue.

Les entrées de cache éligibles sont régénérées lorsque le moteur de rendu sélectionné par la stratégie correspondante est affiché ou que `New-ColorScriptCache` est invoqué. Les scripts groupés déterministes s'affichent en cours de processus et ne créent pas d'entrées de cache.

Recherchez `(Get-ColorScriptConfiguration).Cache.EffectivePath` pour connaître le chemin effectif par défaut. Il peut être remplacé par une configuration persistante ou `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` ; `-Path` cible un répertoire différent pour un appel.

Lors de l'utilisation de `-DryRun` ou `-WhatIf`, l'applet de commande validera toujours que le répertoire de cache existe et signalera tout problème, mais n'effectuera aucune suppression.

Le filtrage par `-Category` ou `-Tag` nécessite que les scripts soient associés à des métadonnées. Les scripts sans métadonnées ne correspondront pas à ces filtres.

### Bonnes pratiques

- Utilisez toujours `-DryRun` ou `-WhatIf` avant les opérations destructrices
- Utilisez `-Confirm:$false` uniquement lorsque vous êtes certain du fonctionnement
- Archiver le cache avant les opérations de nettoyage majeures pour la récupération
- Surveillez régulièrement l'espace disque pour la croissance du cache
- Utiliser le nettoyage sélectif au lieu du nettoyage complet lorsque cela est possible
- Gardez une trace des scripts critiques qui ne doivent pas être effacés
- Planifier des nettoyages automatisés pendant les fenêtres de maintenance
- Tester d'abord les opérations de nettoyage en hors-production

### Dépannage (2)

- **"Aucun fichier de cache trouvé"** : Inspectez `(Get-ColorScriptConfiguration).Cache.EffectivePath` et utilisez `Export-ColorScriptMetadata -IncludeCacheInfo` pour vérifier l'état du cache
- **"Autorisation refusée"** : vérifiez l'accès en écriture au répertoire de cache
- **"Le cache ne se régénère pas"** : les scripts peuvent avoir des problèmes de rendu ; testez avec `-NoCache`

## RELATED LINKS

- [Version en ligne](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Clear-ColorScriptCache)

