---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScriptCache
---

# New-ColorScriptCache

## SYNOPSIS

Pré-construisez ou actualisez les fichiers de cache script de couleurs pour un rendu plus rapide.

## SYNTAX

### Selection (Default)

```
New-ColorScriptCache [-Name <string[]>] [-Force] [-PassThru] [-Category <string[]>]
 [-Tag <string[]>] [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon]
 [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScriptCache [-h] [-WhatIf] [-Confirm]
```

### All

```
New-ColorScriptCache [-All] [-Force] [-PassThru] [-Category <string[]>] [-Tag <string[]>]
 [-Parallel] [-ThrottleLimit <int>] [-Quiet] [-NoAnsiOutput] [-IncludePokemon] [-WhatIf] [-Confirm]
```

## ALIASES

- `Build-ColorScriptCache`
- `Update-ColorScriptCache`

## DESCRIPTION

`New-ColorScriptCache` rend les scripts de couleurs gourmands en calcul sélectionnés par la stratégie et enregistre leur sortie en UTF-8 sans marque d'ordre des octets (BOM). Les moteurs de rendu groupés éligibles utilisent le chemin d'exécution isolé du module ; les travailleurs parallèles sont disponibles à partir de PowerShell 7. Les scripts groupés déterministes sont rendus dans le processus et ne créent jamais de fichiers de cache. Les alias sont `Update-ColorScriptCache` et `Build-ColorScriptCache`.

Vous pouvez cibler les scripts par nom (caractères génériques pris en charge), catégorie ou balise. Lorsqu'aucun paramètre n'est spécifié, l'applet de commande résout directement les noms dans `CachePolicy.psd1` au lieu d'énumérer la collection complète. Les noms groupés exacts utilisent également une recherche directe de fichier. Les requêtes de caractères génériques, de catégories et de balises sont énumérées uniquement lorsque leur sémantique correspondante l'exige. Les scripts explicites non répertoriés sont renvoyés avec le statut `SkippedNotRequired` lorsque `-PassThru` est utilisé, et tous les fichiers de cache obsolètes pour ces scripts sont supprimés.

Par défaut, l'applet de commande affiche la progression ainsi qu'un résumé concis de l'opération de mise en cache et du répertoire de cache effectif. Utilisez `-PassThru` pour renvoyer des objets de résultat détaillés pour chaque script, que vous pouvez inspecter par programme pour connaître l'état, la sortie standard et les flux d'erreurs. Combinez `-Quiet` pour supprimer entièrement la progression et le résumé, ou `-NoAnsiOutput` pour émettre des résumés en texte brut sans codes couleur ANSI pour les environnements qui ne les prennent pas en charge.

L'applet de commande ignore les scripts dont les fichiers de cache sont déjà à jour, sauf si vous spécifiez `-Force`. Les générations répétées valident le petit fichier annexe de métadonnées `<name>.cacheinfo` sans charger la charge utile `<name>.cache` rendue. `-Force` reconstruit les entrées de cache éligibles, mais ne remplace jamais la stratégie de cache.

Les deux fichiers résident dans `(Get-ColorScriptConfiguration).Cache.EffectivePath`. Le fichier `.cache` contient la sortie du terminal rendue ; `.cacheinfo` contient uniquement des métadonnées de validation. Un fichier annexe sans sa charge utile n'est pas une entrée de cache utilisable et sera réparé lors de la prochaine génération. `Clear-ColorScriptCache -All` supprime les entrées complètes et les fichiers annexes orphelins.

Pour des reconstructions plus rapides sur les systèmes multicœurs, utilisez le commutateur `-Parallel` avec le paramètre `-ThrottleLimit` (ou `-Threads`) pour contrôler le nombre de travailleurs. L'applet de commande revient automatiquement à l'exécution séquentielle lorsque les espaces d'exécution parallèles ne peuvent pas être créés sur l'hôte actuel.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScriptCache
```

Résolvez et réchauffez uniquement les moteurs de rendu informatiques sélectionnés par la politique sans énumérer tous les scripts fournis avec le module. Il s'agit du comportement par défaut lorsqu'aucun paramètre n'est spécifié.

### EXAMPLE 2

```powershell
New-ColorScriptCache -Name Galaxy, 'rose-*'
```

Mettez en cache un mélange de correspondances exactes et génériques. Seules les correspondances incluses dans `CachePolicy.psd1` sont créées ; d'autres correspondances rapportent `SkippedNotRequired` avec `-PassThru`.

### EXAMPLE 3

```powershell
New-ColorScriptCache -Name Galaxy -Force -PassThru | Format-List
```

Forcez une reconstruction du cache 'Galaxy' éligible même s'il est à jour et examinez l'objet de résultat détaillé.

### EXAMPLE 4

```powershell
New-ColorScriptCache -Category 'Mathematical' -PassThru
```

Évaluez les scripts de la catégorie `Mathematical`, mettez en cache les moteurs de rendu éligibles et renvoyez des résultats détaillés pour chaque correspondance.

### EXAMPLE 5

```powershell
New-ColorScriptCache -Tag 'geometric', 'colorful' -Force
```

Reconstruisez les caches éligibles pour les scripts balisés avec 'geometric' ou 'colorful', forçant la régénération même si les caches sont à jour.

### EXAMPLE 6

```powershell
Get-ColorScriptList -Category Mathematical -AsObject | New-ColorScriptCache -PassThru
```

Exemple de pipeline : évaluez les scripts de la catégorie `Mathematical`, mettez en cache tous les moteurs de rendu sélectionnés par la stratégie et renvoyez un résultat pour chaque correspondance.

### EXAMPLE 7

```powershell
# Vérifier les statistiques du cache après la construction
$cachePath = (Get-ColorScriptConfiguration).Cache.EffectivePath
$before = @(Get-ChildItem $cachePath -Filter "*.cache" -ErrorAction SilentlyContinue).Count
New-ColorScriptCache
$after = @(Get-ChildItem $cachePath -Filter "*.cache").Count
Write-Host "Scripts mis en cache : $before -> $after"
```

Mesure la croissance du cache en comptant les fichiers de cache sélectionnés par stratégie avant et après l'opération.

### EXAMPLE 8

```powershell
# Créer un cache pour les moteurs de rendu informatiques fréquemment utilisés
$frequentScripts = @('Galaxy', 'rose-curves', 'wave-interference')
New-ColorScriptCache -Name $frequentScripts -PassThru | Format-Table Name, Status, ExitCode
```

Crée des caches pour les scripts répertoriés éligibles sous `CachePolicy.psd1` ; les noms non répertoriés sont ignorés.

### EXAMPLE 9

```powershell
# Utiliser l'affichage de progression intégré au niveau de la politique
New-ColorScriptCache -All
```

Affiche la progression intégrée pour les moteurs de rendu sélectionnés par stratégie sans itérer manuellement tous les scripts disponibles.

### EXAMPLE 10

```powershell
# En option, amorcez les entrées de stratégie manquantes ou obsolètes à partir d'un profil PowerShell.
Import-Module ColorScripts-Enhanced
New-ColorScriptCache -Quiet
```

Vérifie les entrées sélectionnées par la stratégie lorsque le profil se charge et crée uniquement les entrées manquantes ou obsolètes. Omettez cette étape de profil lorsque le travail du cache de démarrage n’est pas souhaité.

### EXAMPLE 11

```powershell
# Reconstruisez chaque entrée sélectionnée par la politique pour le déploiement
New-ColorScriptCache -All -Force -PassThru |
    Select-Object Name, Status |
    Export-Csv "./cache-deployment.csv"
```

Reconstruit chaque entrée de cache sélectionnée par la stratégie et exporte les statuts vers un manifeste de déploiement.

### EXAMPLE 12

```powershell
# Rechercher les échecs de construction du cache
New-ColorScriptCache -Name "Galaxy" -Force -PassThru |
    Where-Object Status -eq 'Failed' |
    Select-Object Name, StdErr
```

Identifie les échecs de mise en cache sans traiter les sauts de stratégie comme des erreurs.

### EXAMPLE 13

```powershell
# Compter les entrées sélectionnées par la stratégie mises à jour par cette exécution
New-ColorScriptCache -All -PassThru |
    Where-Object Status -eq 'Updated' |
    Measure-Object |
    Select-Object @{N='ScriptsCached'; E={$_.Count}}
```

Vérifie chaque entrée sélectionnée par la stratégie et indique combien de charges utiles de cache ont été mises à jour par cette exécution.

### EXAMPLE 14

```powershell
New-ColorScriptCache -All -Parallel -Threads 8
```

Créez tous les caches sélectionnés par la stratégie à l’aide de huit threads de travail. L'applet de commande revient automatiquement à l'exécution séquentielle lorsque les tâches parallèles ne sont pas disponibles sur l'hôte actuel.

## PARAMETERS

### -All

Résolvez directement chaque entrée de stratégie de cache. Seuls les scripts sélectionnés par la stratégie sont traités ; l'inventaire complet script de couleurs n'est pas répertorié.

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

Filtre les scripts évalués par catégorie de métadonnées (insensible à la casse). Plusieurs valeurs sont traitées comme un filtre OU. Seules les correspondances autorisées par `CachePolicy.psd1` sont mises en cache ; d'autres correspondances rapportent `SkippedNotRequired` avec `-PassThru`.

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

Vous demande une confirmation avant d’exécuter l’applet de commande. Utile lors de la mise en cache d'un grand nombre de scripts ou lors de l'utilisation de `-Force` pour empêcher une régénération accidentelle du cache.

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

### -Force

Reconstruisez les entrées de cache éligibles même lorsque leurs métadonnées de validation `.cacheinfo` indiquent qu'elles sont à jour. Cela ne remplace pas `CachePolicy.psd1`.

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

### -IncludePokemon

Commutateur de compatibilité obsolète. Il est accepté silencieusement sans effet pendant une version, car les scripts Pokémon suivent les mêmes règles de `CachePolicy.psd1` que tous les autres scripts.

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

### -Name

Un ou plusieurs noms script de couleurs à évaluer pour la mise en cache. Prend en charge les modèles génériques (par exemple, `aurora-*` et `*-wave`). Les scripts correspondants sont mis en cache uniquement lorsqu'ils sont répertoriés dans `CachePolicy.psd1`. Lorsque ce paramètre et tous les filtres sont omis, seules les entrées de stratégie sont résolues et évaluées.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
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

Désactivez les séquences de couleurs ANSI dans la sortie d’informations. Ceci est utile dans les environnements qui n'affichent pas les codes d'échappement ANSI (tels que certains journaux CI/CD) tout en préservant la sortie colorée lorsque vous le souhaitez.

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

### -Parallel

Activez la création de cache multithread. Lorsqu'elle est spécifiée, l'applet de commande exécute les tâches de cache sur un pool d'espace d'exécution pour une exécution plus rapide sur les systèmes compatibles. À utiliser en combinaison avec `-ThrottleLimit` (ou l'alias `-Threads`) pour contrôler le nombre de travailleurs simultanés. Si le multithread ne peut pas être initialisé, l’applet de commande revient automatiquement à l’exécution séquentielle.

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

### -PassThru

Renvoie des objets de résultat détaillés pour chaque opération de cache. Par défaut, seul un résumé est affiché. Les objets de résultat incluent des propriétés telles que Name, Status, CacheFile, ExitCode, StdOut et StdErr, permettant une inspection programmatique du processus de mise en cache.

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

### -Quiet

Supprimez la progression par script et la sortie récapitulative des informations. Utilisez ce commutateur lorsque vous souhaitez uniquement une sortie structurée (via `-PassThru`) ou lorsque les scénarios d'automatisation doivent faire taire les messages d'information tout en faisant apparaître des avertissements et des erreurs.

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

Filtre les scripts évalués par balise de métadonnées (insensible à la casse). Plusieurs valeurs sont traitées comme un filtre OU. Seules les correspondances autorisées par `CachePolicy.psd1` sont mises en cache ; d'autres correspondances rapportent `SkippedNotRequired` avec `-PassThru`.

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

### -ThrottleLimit

Spécifie le nombre maximum de travailleurs de cache simultanés lorsque `-Parallel` est demandé. Accepte les valeurs de 1 à 256. La valeur par défaut (en cas d'omission) est le nombre de processeurs logiques sur la machine actuelle. L'alias `-Threads` est fourni pour plus de commodité. Les valeurs inférieures ou égales à un reviennent automatiquement à l'exécution séquentielle.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Threads
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

Montre ce qui se passerait si l’applet de commande s’exécutait sans réellement effectuer les opérations de mise en cache. Utile pour prévisualiser les scripts qui seront mis en cache avant de s'engager dans l'opération.

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

### System.String

Vous pouvez rediriger les noms de script vers cette applet de commande. Chaque string est traité comme un nom de script potentiel et prend en charge la correspondance par caractères génériques.

### System.String[]

Vous pouvez rediriger un tableau de noms de script ou d'enregistrements de métadonnées avec une propriété `Name` vers cette applet de commande pour le traitement par lots.

## OUTPUTS

### System.Object

Lorsque `-PassThru` est spécifié, renvoie un objet personnalisé pour chaque script traité contenant les propriétés suivantes :

- **Name** : Le nom script de couleurs
- **ScriptPath** : Chemin complet vers la source script de couleurs
- **CacheFile** : Chemin complet vers le fichier cache généré
- **Status** : `Updated`, `SkippedUpToDate`, `SkippedNotRequired`, `SkippedByUser` ou `Failed`
- **Message** : détails d'état localisés
- **CacheExists** : si un cache de sortie existe après l'opération
- **ExitCode** : Le code de sortie de l'exécution du script (0 indique le succès)
- **StdOut** : sortie standard capturée lors de l'exécution du script
- **StdErr** : sortie d'erreur standard capturée lors de l'exécution du script

Sans `-PassThru`, écrit un résumé d'informations concis contenant les décomptes traités, mis à jour, ignorés et ayant échoué, ainsi que le répertoire de cache effectif.

## NOTES

**Auteur :** Nick
**Module :** ColorScripts-Enhanced

**Alias :** `Update-ColorScriptCache` et `Build-ColorScriptCache`.

Les fichiers cache sont stockés sous `(Get-ColorScriptConfiguration).Cache.EffectivePath`. Les signatures de source et de stratégie dans les métadonnées associées sont utilisées pour déterminer si une entrée reste à jour.

L'applet de commande met en cache uniquement les moteurs de rendu qui nécessitent une exécution et sont autorisés par la stratégie de cache. Les scripts explicites statiques ou non répertoriés sont signalés comme `SkippedNotRequired` et les entrées obsolètes sont supprimées.

## RELATED LINKS

- [Version en ligne](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScriptCache)

