---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/fr/Clear-ColorScriptCache.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Clear-ColorScriptCache

## SYNOPSIS

Supprimer les fichiers de sortie de script de couleur mis en cache.

## SYNTAX

### All

```
Clear-ColorScriptCache [-All] [-Path <String>] [-DryRun] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Named

```
Clear-ColorScriptCache [-Name <String[]>] [-Path <String>] [-DryRun] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### \_\_AllParameterSets

```
Clear-ColorScriptCache [[-Name] <string[]>] [[-Path] <string>] [[-Category] <string[]>]
 [[-Tag] <string[]>] [-All] [-DryRun] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Le cmdlet `Clear-ColorScriptCache` supprime les fichiers de sortie mis en cache générés par le module ColorScripts-Enhanced. Les fichiers cache stockent la sortie de script pré-rendue pour améliorer les performances lors des invocations ultérieures.

Vous pouvez supprimer les fichiers cache de manière sélective en utilisant le paramètre `-Name` avec des modèles de caractères génériques, ou supprimer tous les fichiers cache à la fois avec le paramètre `-All`. Le cmdlet prend également en charge le filtrage par `-Category` et `-Tag` pour cibler des sous-ensembles spécifiques de scripts mis en cache.

Les noms de script non appariés signalent un statut `Missing` dans les résultats. Utilisez `-DryRun` pour prévisualiser les actions de suppression sans modifier le système de fichiers, et `-Path` pour cibler un répertoire cache alternatif (utile pour les configurations cache personnalisées ou les environnements CI/CD).

Les fichiers cache sont automatiquement régénérés la prochaine fois que `Show-ColorScript` exécute le script correspondant.

## EXAMPLES

### EXAMPLE 1

```powershell
Clear-ColorScriptCache -All -Confirm:$false
```

Supprime tous les fichiers cache dans le répertoire cache par défaut sans demander de confirmation. Ceci est utile pour actualiser complètement le cache après les mises à jour du module ou lors du dépannage des problèmes d'affichage.

### EXAMPLE 2

```powershell
Clear-ColorScriptCache -Name 'aurora-*' -DryRun
```

Prévisualise les fichiers cache thématiques aurora qui seraient supprimés sans les supprimer réellement. La sortie montre les fichiers cache qui correspondent au modèle, vous permettant de vérifier la sélection avant de procéder à la suppression.

### EXAMPLE 3

```powershell
Clear-ColorScriptCache -Name bars -Path $env:TEMP -Confirm:$false
```

Efface le fichier cache pour le script 'bars' d'un répertoire cache personnalisé situé dans le dossier TEMP. Ceci est utile lorsque vous travaillez avec la variable d'environnement `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` ou que vous testez des emplacements cache alternatifs.

### EXAMPLE 4

```powershell
Clear-ColorScriptCache -Category Animation -WhatIf
```

Montre ce qui se passerait si tous les fichiers cache pour les scripts de la catégorie Animation étaient supprimés. Le paramètre `-WhatIf` empêche la suppression réelle et affiche les actions prévues.

### EXAMPLE 5

```powershell
Get-ColorScriptList -Tag retro | Clear-ColorScriptCache -DryRun
```

Utilise l'entrée pipeline pour prévisualiser la suppression des fichiers cache pour tous les scripts étiquetés comme 'retro'. Combine le filtrage par étiquette avec une prévisualisation dry-run avant de procéder à la suppression.

### EXAMPLE 6

```powershell
Clear-ColorScriptCache -Name 'test-*', 'demo-*' -Confirm:$false
```

Supprime les fichiers cache pour tous les scripts dont les noms commencent par 'test-' ou 'demo-' sans confirmation. Plusieurs modèles de caractères génériques peuvent être spécifiés sous forme de tableau.

### EXAMPLE 7

```powershell
# Nettoyer le cache et le reconstruire pour l'optimisation
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -PassThru | Measure-Object
Write-Host "Cache reconstruit avec succès"
```

Effectue un rafraîchissement complet du cache en effaçant tout et en reconstruisant, puis affiche les statistiques.

### EXAMPLE 8

```powershell
# Effacer les anciennes entrées de cache datant de plus de 30 jours
$cacheDir = "$env:APPDATA\ColorScripts-Enhanced\cache"
$thirtyDaysAgo = (Get-Date).AddDays(-30)
Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $thirtyDaysAgo } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
Write-Host "Anciens fichiers cache nettoyés"
```

Supprime les fichiers cache qui n'ont pas été mis à jour depuis plus de 30 jours.

### EXAMPLE 9

```powershell
# Rapport de gestion du cache
$cacheDir = "$env:APPDATA\ColorScripts-Enhanced\cache"
$beforeCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Clear-ColorScriptCache -Category Geometric -Confirm:$false
$afterCount = @(Get-ChildItem $cacheDir -Filter "*.cache" -ErrorAction SilentlyContinue).Count
Write-Host "Effacé $($beforeCount - $afterCount) fichiers cache géométriques"
```

Affiche les statistiques sur les opérations de nettoyage du cache.

### EXAMPLE 10

```powershell
# Dépannage - effacer et reconstruire un script spécifique
$scriptName = "mandelbrot-zoom"
Clear-ColorScriptCache -Name $scriptName -Confirm:$false
New-ColorScriptCache -Name $scriptName -Force
Show-ColorScript -Name $scriptName
```

Efface et reconstruit le cache pour un script unique, puis l'affiche pour vérification.

### EXAMPLE 11

```powershell
# Filtrer par plusieurs catégories
Clear-ColorScriptCache -Category Geometric,Abstract -DryRun |
    Select-Object CacheFile |
    Measure-Object
```

Montre combien de fichiers cache seraient supprimés si on filtre par plusieurs catégories.

## PARAMETERS

### -All

Supprime tous les fichiers cache dans le répertoire cible. Ce paramètre est mutuellement exclusif avec `-Name`, `-Category` et `-Tag`. Lorsqu'il est spécifié, tous les paramètres de filtrage sont ignorés et le cache entier est effacé.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -Category

Filtre les scripts cibles par catégorie avant d'évaluer les entrées cache. Seuls les fichiers cache pour les scripts correspondant aux catégories spécifiées seront considérés pour la suppression. Accepte un tableau de noms de catégories et peut être combiné avec `-Tag` pour un filtrage plus précis.

```yaml
Type: System.String[]
DefaultValue: ""
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
HelpMessage: ""
```

### -Confirm

Demande une confirmation avant d'exécuter le cmdlet. Par défaut, ceci est activé pour éviter la suppression accidentelle de fichiers cache. Utilisez `-Confirm:$false` pour contourner l'invite de confirmation.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: True
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

### -DryRun

Prévisualise les actions de suppression sans supprimer aucun fichier. Le cmdlet affichera les fichiers cache qui seraient supprimés mais ne modifiera pas le système de fichiers. Ceci est utile pour vérifier vos critères de sélection avant de procéder à la suppression.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -Name

Noms ou modèles de caractères génériques identifiant les fichiers cache à supprimer. Accepte l'entrée pipeline et la liaison de propriété à partir d'objets avec une propriété `Name`. Les caractères génériques (`*`, `?`) sont pris en charge pour la correspondance de modèles. Mutuellement exclusif avec `-All`.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
Aliases: []
ParameterSets:
 - Name: (All)
   Position: 0
   IsRequired: false
   ValueFromPipeline: true
   ValueFromPipelineByPropertyName: true
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -Path

Répertoire cache alternatif à utiliser. Par défaut, le chemin cache standard du module si non spécifié. Utilisez ce paramètre lorsque vous travaillez avec des emplacements cache personnalisés définis via la variable d'environnement `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`, ou lorsque vous gérez des fichiers cache dans des répertoires alternatifs pour les tests ou les environnements CI/CD.

```yaml
Type: System.String
DefaultValue: None
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

### -Tag

Filtre les scripts cibles par étiquette de métadonnées avant d'évaluer les entrées cache. Seuls les fichiers cache pour les scripts avec des étiquettes correspondantes seront considérés pour la suppression. Accepte un tableau de noms d'étiquettes et peut être combiné avec `-Category` pour un contrôle plus granulaire sur les fichiers cache ciblés.

```yaml
Type: System.String[]
DefaultValue: ""
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
HelpMessage: ""
```

### -WhatIf

Montre ce qui se passerait si le cmdlet s'exécute sans exécuter réellement l'opération. Le cmdlet affiche les actions qu'il effectuerait mais ne modifie pas le système de fichiers. Ceci est un paramètre commun PowerShell standard qui fonctionne de manière similaire à `-DryRun` mais suit les conventions intégrées de PowerShell.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

Ce cmdlet prend en charge les paramètres communs : -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction et -WarningVariable. Pour plus d'informations, voir
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Vous pouvez diriger les noms de script vers ce cmdlet. Chaque nom sera évalué pour la suppression de fichier cache en fonction des paramètres spécifiés.

### System.String[]

Vous pouvez diriger un tableau de noms de script vers ce cmdlet. Ceci est particulièrement utile lorsque vous combinez avec `Get-ColorScriptList` pour filtrer les scripts selon divers critères avant d'effacer leurs caches.

### System.Management.Automation.PSObject

Vous pouvez diriger des objets avec une propriété `Name` vers ce cmdlet. Le cmdlet extraira la valeur de la propriété `Name` et l'utilisera pour identifier les fichiers cache à supprimer.

## OUTPUTS

### System.Object

Retourne des enregistrements de statut pour chaque fichier cache traité. Chaque objet de sortie contient les propriétés suivantes :

- **Status** : Le résultat de l'opération (`Removed`, `Missing`, `DryRun` ou `Error`)
- **CacheFile** : Le chemin complet vers le fichier cache qui a été traité
- **Message** : Texte descriptif expliquant le résultat de l'opération
- **ScriptName** : Le nom du script associé au fichier cache

## ADVANCED USAGE PATTERNS

### Cache Maintenance Strategies

**Full Cache Rebuild**

```powershell
# Actualisation complète du cache
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -Force
Write-Host "Cache reconstruit avec succès"
```

**Targeted Cache Cleaning**

```powershell
# Effacer uniquement les entrées obsolètes
Clear-ColorScriptCache -Name "deprecated-*", "test-*" -Confirm:$false

# Vérifier ce qui serait supprimé d'abord
Clear-ColorScriptCache -Name "draft-*" -DryRun
```

**Age-Based Cleanup**

```powershell
# Effacer les fichiers cache plus anciens que 60 jours
$cacheDir = (Get-ColorScriptConfiguration).Cache.Path
$cutoffDate = (Get-Date).AddDays(-60)

Get-ChildItem $cacheDir -Filter "*.cache" |
    Where-Object { $_.LastWriteTime -lt $cutoffDate } |
    ForEach-Object {
        Clear-ColorScriptCache -Name $_.BaseName -Confirm:$false
    }
```

### Category and Tag Based Cleaning

**Clear by Metadata**

```powershell
# Supprimer les caches pour la catégorie expérimentale
Clear-ColorScriptCache -Category Experimental -Confirm:$false

# Effacer l'étiquette obsolète
Clear-ColorScriptCache -Tag deprecated -Confirm:$false

# Effacer plusieurs catégories à la fois
Clear-ColorScriptCache -Category @("Demo", "Test", "Draft") -Confirm:$false
```

**Selective Preservation**

```powershell
# Garder uniquement les scripts recommandés, effacer tout le reste
$keep = Get-ColorScriptList -Tag Recommended -AsObject | Select-Object -ExpandProperty Name
$all = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$remove = $all | Where-Object { $_ -notin $keep }

$remove | ForEach-Object { Clear-ColorScriptCache -Name $_ -Confirm:$false }
```

### Performance and Reporting

**Cache Usage Analysis**

```powershell
# Analyser le cache avant le nettoyage
$cacheDir = (Get-ColorScriptConfiguration).Cache.Path
$before = (Get-ChildItem $cacheDir -Filter "*.cache" | Measure-Object -Property Length -Sum).Sum

Clear-ColorScriptCache -Category Demo -DryRun
Write-Host "Taille actuelle du cache : $([math]::Round($before / 1MB, 2)) MB"
```

**Cleanup Report**

```powershell
# Générer un rapport des opérations de nettoyage
$report = Clear-ColorScriptCache -Name "test-*", "debug-*" -Confirm:$false
$report | Group-Object Status | ForEach-Object {
    Write-Host "$($_.Name): $($_.Count) éléments"
}
```

**Space Recovery**

```powershell
# Calculer l'espace disque libéré
$before = (Get-ChildItem (Get-ColorScriptConfiguration).Cache.Path -Filter "*.cache" | Measure-Object -Property Length -Sum).Sum
Clear-ColorScriptCache -All -Confirm:$false
$after = (Get-ChildItem (Get-ColorScriptConfiguration).Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum

Write-Host "Libéré : $([math]::Round(($before - $after) / 1MB, 2)) MB"
```

### CI/CD and Deployment

**Pre-Build Cache Cleanup**

```powershell
# Nettoyage de build : effacer tout le cache avant de reconstruire
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache -Tag Recommended -Force
Write-Host "Cache prêt pour le déploiement"
```

**Selective Cache Persistence**

```powershell
# Garder les scripts de production, effacer le développement
Clear-ColorScriptCache -Tag "development,experimental" -Confirm:$false

# Préserver le cache pour les scripts critiques
$critical = @("bars", "arch", "mandelbrot-zoom")
$scripts = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$toRemove = $scripts | Where-Object { $_ -notin $critical }
$toRemove | ForEach-Object { Clear-ColorScriptCache -Name $_ -Confirm:$false }
```

### Troubleshooting

**Verification Workflow**

```powershell
# Vérifier les problèmes de cache et corriger
$problemScripts = Get-ColorScriptList -AsObject |
    Where-Object {
        -not (Test-Path "$env:APPDATA\ColorScripts-Enhanced\cache\$($_.Name).cache")
    }

Write-Host "Scripts sans cache : $($problemScripts.Count)"
$problemScripts | ForEach-Object {
    Write-Host "Reconstruction : $($_.Name)"
    New-ColorScriptCache -Name $_.Name -Force
}
```

## NOTES

**Author** : Nick
**Module** : ColorScripts-Enhanced

Les fichiers cache sont stockés avec une extension `.cache` dans le répertoire cache du module. Chaque fichier cache correspond à un seul colorscript et contient la sortie ANSI pré-rendue.

Les fichiers cache sont automatiquement régénérés la prochaine fois que `Show-ColorScript` exécute le script correspondant. Cette régénération se produit de manière transparente et ne nécessite pas d'intervention manuelle.

Le chemin cache par défaut est exposé via la variable `$CacheDir` du module et peut être remplacé en utilisant la variable d'environnement `COLOR_SCRIPTS_ENHANCED_CACHE_PATH`.

Lorsque vous utilisez `-DryRun` ou `-WhatIf`, le cmdlet validera toujours que le répertoire cache existe et signalera tout problème, mais n'effectuera aucune suppression.

Le filtrage par `-Category` ou `-Tag` nécessite que les scripts aient des métadonnées associées. Les scripts sans métadonnées ne correspondront pas à ces filtres.

### Best Practices

- Utilisez toujours `-DryRun` ou `-WhatIf` avant les opérations destructives
- Utilisez `-Confirm:$false` uniquement lorsque vous êtes certain de l'opération
- Archivez le cache avant les opérations de nettoyage majeures pour la récupération
- Surveillez régulièrement l'espace disque pour la croissance du cache
- Utilisez le nettoyage sélectif plutôt que l'effacement complet lorsque possible
- Gardez une trace des scripts critiques qui ne devraient pas être effacés
- Planifiez des nettoyages automatisés pendant les fenêtres de maintenance
- Testez les opérations de nettoyage en non-production d'abord

### Troubleshooting

- **"Aucun fichier cache trouvé"** : Utilisez `-AsObject` pour vérifier quels scripts ont des caches
- **"Permission refusée"** : Vérifiez l'accès en écriture au répertoire cache
- **"Cache ne se régénère pas"** : Les scripts peuvent avoir des problèmes de rendu ; testez avec `-NoCache`

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
