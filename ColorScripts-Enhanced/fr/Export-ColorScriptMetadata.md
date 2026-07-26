---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Export-ColorScriptMetadata
---

# Export-ColorScriptMetadata

## SYNOPSIS

Exporte des métadonnées complètes pour tous les scripts de couleurs au format JSON ou émet des objets structurés vers le pipeline.

## SYNTAX

### __AllParameterSets

```
Export-ColorScriptMetadata [[-Path] <string>] [-h] [-IncludeFileInfo] [-IncludeCacheInfo]
 [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Cette commande ne possède aucun alias.

## DESCRIPTION

L'applet de commande `Export-ColorScriptMetadata` compile un inventaire complet de tous les scripts de couleurs dans le catalogue du module et génère un ensemble de données structuré décrivant chaque entrée. Ces métadonnées incluent des informations essentielles telles que les noms de scripts, les catégories, les balises et les enrichissements facultatifs.

Par défaut, l'applet de commande renvoie les objets PowerShell au pipeline. Lorsque le paramètre `-Path` est fourni, il écrit les métadonnées au format JSON dans le fichier spécifié, créant automatiquement des répertoires parents s'ils n'existent pas.

L'applet de commande propose deux indicateurs d'enrichissement facultatifs :

- **IncludeFileInfo** : ajoute des métadonnées du système de fichiers, notamment les chemins complets, la taille des fichiers (en octets) et les horodatages de la dernière modification.
- **IncludeCacheInfo** : ajoute des informations relatives au cache, notamment les chemins d'accès aux fichiers de cache, l'état d'existence et les horodatages du cache.

Cette applet de commande est particulièrement utile pour :

- Création de documentation ou de tableaux de bord montrant tous les scripts de couleurs disponibles
- Signalement de la présence et des horodatages des fichiers de charge utile du cache brut
- Alimentation des métadonnées vers des outils externes ou des pipelines d'automatisation
- Audit de l'inventaire script de couleurs et de l'état du système de fichiers
- Génération de rapports sur l'utilisation et l'organisation du script de couleurs

La sortie est ordonnée de manière cohérente, ce qui la rend adaptée au contrôle de version et aux opérations de comparaison lors de l'exportation vers JSON.

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

Exporte les métadonnées de base de tous les scripts de couleurs vers le pipeline sans informations de fichier ou de cache.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

Renvoie les objets qui incluent les détails du système de fichiers (chemin complet, taille et heure de la dernière écriture) pour chaque script de couleurs.

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

Génère un fichier JSON contenant des métadonnées de base et l'écrit dans le répertoire `dist`, créant le dossier s'il n'existe pas.

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

Génère un fichier JSON complet avec des métadonnées enrichies comprenant à la fois des informations sur le système de fichiers et le cache, en l'écrivant dans le répertoire `dist`.

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeCacheInfo -PassThru | Where-Object { -not $_.CacheExists }
```

Écrit le fichier de métadonnées et renvoie les enregistrements dont la charge utile brute `.cache` est absente. Cela signale uniquement l'occupation des fichiers, et non l'éligibilité, la validité ou l'actualité du cache.

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

Regroupe scripts de couleurs par catégorie et affiche les décomptes, utile pour analyser la répartition des scripts entre les catégories.

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property ScriptSizeBytes -Sum).Sum
Write-Host "Taille totale de tous les scripts de couleurs : $($totalSize / 1KB) Ko"
```

Calcule l'espace disque total utilisé par tous les fichiers script de couleurs.

### EXAMPLE 8

```powershell
# Générer des statistiques et enregistrer le rapport
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachePayloadFiles = ($metadata | Where-Object CacheExists).Count
    TotalScriptSizeBytes = ($metadata | Measure-Object ScriptSizeBytes -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

Génère des statistiques d'inventaire et compte les fichiers de charge utile bruts `.cache`. La présence de la charge utile ne constitue pas une vérification de l'éligibilité, de la validité ou de l'actualité du cache.

### EXAMPLE 9

```powershell
# Exporter et comparer avec la sauvegarde précédente
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "Nouveaux scripts : $($new.Count) | Scripts supprimés : $($removed.Count)"
```

Compare les métadonnées actuelles avec une version précédente pour identifier les modifications.

### EXAMPLE 10

```powershell
# Créer une réponse API pour le tableau de bord Web
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

Génère un JSON prêt pour l'API avec des informations de version et d'horodatage.

### EXAMPLE 11

```powershell
# Créez ou validez chaque entrée de cache sélectionnée par la politique et examinez les statuts.
$results = New-ColorScriptCache -All -PassThru
$results | Group-Object Status | Select-Object Name, Count
```

Utilise la stratégie de cache comme source de vérité et indique si les entrées éligibles ont été mises à jour, déjà actuelles, ignorées ou ayant échoué.

### EXAMPLE 12

```powershell
# Créer une galerie HTML à partir de métadonnées
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$html = @"
<html>
<head><title>ColorScripts-Enhanced Gallery</title></head>
<body>
<h1>ColorScripts-Enhanced</h1>
<ul>
"@
foreach ($script in $metadata) {
    $html += "<li><strong>$($script.Name)</strong> [$($script.Category)]</li>`n"
}
$html += "</ul></body></html>"
$html | Out-File "./gallery.html" -Encoding UTF8
```

Crée une page de galerie HTML répertoriant tous les scripts de couleurs disponibles.

### EXAMPLE 13

```powershell
# Surveiller la taille des scripts au fil du temps
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object ScriptSizeBytes -Average).Average) bytes avg" }
```

Suit les modifications de taille de fichier pour des scripts individuels sur plusieurs exportations.

## PARAMETERS

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

### -h

Affiche une aide détaillée pour cette commande sans effectuer l'opération.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -IncludeCacheInfo

Ajoute le chemin de charge utile brut `.cache`, l'indicateur de présence de fichier et l'horodatage de la dernière écriture à chaque enregistrement. Ces champs ne signalent pas l’éligibilité à la stratégie de cache, la présence du fichier annexe `.cacheinfo`, la validité ou l’actualité.

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
HelpMessage: ''
```

### -IncludeFileInfo

Inclut les détails du système de fichiers (chemin complet, taille en octets et heure de la dernière écriture) dans chaque enregistrement. Lorsque les métadonnées du fichier ne peuvent pas être lues (en raison d'autorisations ou de fichiers manquants), les erreurs sont enregistrées via une sortie détaillée et les propriétés affectées sont définies sur des valeurs nulles. Ce commutateur est utile pour auditer la taille des fichiers et les dates de modification.

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
HelpMessage: ''
```

### -PassThru

Renvoie les objets de métadonnées au pipeline même lorsque le paramètre `-Path` est spécifié. Cela vous permet à la fois d'enregistrer les métadonnées dans un fichier et d'effectuer un traitement ou un filtrage supplémentaire sur les objets en une seule commande. Sans ce commutateur, la spécification de `-Path` supprime la sortie du pipeline.

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
HelpMessage: ''
```

### -Path

Spécifie le chemin du fichier de destination pour l'exportation JSON. Prend en charge les chemins relatifs, les chemins absolus, les variables d'environnement (par exemple, `$env:TEMP\metadata.json`) et l'expansion des tildes (par exemple, `~/Documents/metadata.json`). Les répertoires parents sont automatiquement créés s'ils n'existent pas. Lorsque ce paramètre est omis, l'applet de commande génère les objets directement dans le pipeline au lieu d'écrire dans un fichier. La sortie JSON est formatée avec une indentation pour plus de lisibilité.

```yaml
Type: System.String
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
Pour plus d'informations, consultez
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Cette applet de commande n'accepte pas les entrées de pipeline.

## OUTPUTS

### System.Management.Automation.PSCustomObject

Lorsque `-Path` n’est pas spécifié ou lorsque `-PassThru` est utilisé, l’applet de commande renvoie des objets personnalisés. Chaque objet représente un seul script de couleurs avec les propriétés de base suivantes :

- **Name** : Le nom de fichier du script de couleurs sans extension
- **Category** : catégorie organisationnelle principale
- **Categories** : toutes les catégories attribuées
- **Tags** : Un tableau de balises descriptives pour le filtrage et la recherche
- **Description** : La description des métadonnées

Lorsque `-IncludeFileInfo` est spécifié, ces propriétés supplémentaires sont incluses :

- **ScriptPath** : le chemin complet du système de fichiers vers le fichier de script
- **ScriptSizeBytes** : Taille en octets (nul si fichier inaccessible)
- **ScriptLastWriteTimeUtc** : horodatage UTC de la dernière modification (nul si indisponible)

Lorsque `-IncludeCacheInfo` est spécifié, ces propriétés supplémentaires sont incluses :

- **CachePath** : Le chemin complet vers le fichier cache correspondant
- **CacheExists** : Booléen indiquant si un fichier cache existe
- **CacheLastWriteTimeUtc** : horodatage UTC de modification du fichier cache (nul si le cache n'existe pas)

## NOTES

Aucune.

## RELATED LINKS

- [Version en ligne](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)

