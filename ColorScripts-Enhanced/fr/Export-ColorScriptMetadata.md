---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
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

This command has no aliases.

## DESCRIPTION

La cmdlet `Export-ColorScriptMetadata` compile un inventaire complet de tous les scripts de couleurs dans le catalogue du module et génère un ensemble de données structuré décrivant chaque entrée. Ces métadonnées incluent des informations essentielles telles que les noms des scripts, les catégories, les balises et des enrichissements optionnels.

Par défaut, la cmdlet retourne des objets PowerShell vers le pipeline. Lorsque le paramètre `-Path` est fourni, elle écrit les métadonnées au format JSON formaté dans le fichier spécifié, créant automatiquement les répertoires parents s'ils n'existent pas.

La cmdlet offre deux indicateurs d'enrichissement optionnels :

- **IncludeFileInfo** : Ajoute des métadonnées du système de fichiers incluant les chemins complets, les tailles de fichiers (en octets) et les horodatages de dernière modification
- **IncludeCacheInfo** : Ajoute des informations liées au cache incluant les chemins des fichiers de cache, le statut d'existence et les horodatages du cache

Cette cmdlet est particulièrement utile pour :

- Créer de la documentation ou des tableaux de bord montrant tous les scripts de couleurs disponibles
- Analyser la couverture du cache et identifier les scripts nécessitant une reconstruction du cache
- Alimenter des outils externes ou des pipelines d'automatisation avec des métadonnées
- Auditer l'inventaire des scripts de couleurs et le statut du système de fichiers
- Générer des rapports sur l'utilisation et l'organisation des scripts de couleurs

La sortie est ordonnée de manière cohérente, la rendant adaptée au contrôle de version et aux opérations de diff lors de l'exportation vers JSON.

## EXAMPLES

### EXAMPLE 1

```powershell
Export-ColorScriptMetadata
```

Exporte des métadonnées de base pour tous les scripts de couleurs vers le pipeline sans informations sur les fichiers ou le cache.

### EXAMPLE 2

```powershell
Export-ColorScriptMetadata -IncludeFileInfo
```

Retourne des objets incluant des détails du système de fichiers (chemin complet, taille et heure de dernière écriture) pour chaque script de couleurs.

### EXAMPLE 3

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json'
```

Génère un fichier JSON contenant des métadonnées de base et l'écrit dans le répertoire `dist`, créant le dossier s'il n'existe pas.

### EXAMPLE 4

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -IncludeFileInfo -IncludeCacheInfo
```

Génère un fichier JSON complet avec des métadonnées enrichies incluant à la fois les informations du système de fichiers et du cache, l'écrivant dans le répertoire `dist`.

### EXAMPLE 5

```powershell
Export-ColorScriptMetadata -Path './dist/colorscripts.json' -PassThru | Where-Object { -not $_.CacheExists }
```

Écrit le fichier de métadonnées et retourne également les objets vers le pipeline, permettant des requêtes qui identifient les scripts sans fichiers de cache.

### EXAMPLE 6

```powershell
Export-ColorScriptMetadata -IncludeFileInfo | Group-Object Category | Select-Object Name, Count
```

Groupe les scripts de couleurs par catégorie et affiche les comptages, utile pour analyser la distribution des scripts dans les catégories.

### EXAMPLE 7

```powershell
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$totalSize = ($metadata | Measure-Object -Property FileSize -Sum).Sum
Write-Host "Taille totale de tous les scripts de couleurs : $($totalSize / 1KB) Ko"
```

Calcule l'espace disque total utilisé par tous les fichiers de scripts de couleurs.

### EXAMPLE 8

```powershell
# Générer des statistiques et sauvegarder le rapport
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$stats = @{
    TotalScripts = $metadata.Count
    Categories = ($metadata | Select-Object -ExpandProperty Category -Unique).Count
    CachedScripts = ($metadata | Where-Object CacheExists).Count
    TotalFileSize = ($metadata | Measure-Object FileSize -Sum).Sum
    TotalCacheSize = ($metadata | Where-Object CacheExists |
        Measure-Object CacheFileSize -Sum).Sum
}
$stats | ConvertTo-Json | Out-File "./colorscripts-stats.json"
```

Génère un rapport de statistiques complet incluant la couverture du cache et les tailles.

### EXAMPLE 9

```powershell
# Exporter et comparer avec une sauvegarde précédente
$current = Export-ColorScriptMetadata -Path "./current-metadata.json" -IncludeFileInfo -PassThru
$previous = Get-Content "./previous-metadata.json" | ConvertFrom-Json
$new = $current | Where-Object { $_.Name -notin $previous.Name }
$removed = $previous | Where-Object { $_.Name -notin $current.Name }
Write-Host "Nouveaux scripts : $($new.Count) | Scripts supprimés : $($removed.Count)"
```

Compare les métadonnées actuelles avec une version précédente pour identifier les changements.

### EXAMPLE 10

```powershell
# Construire une réponse API pour un tableau de bord web
$metadata = Export-ColorScriptMetadata -IncludeFileInfo -IncludeCacheInfo
$apiResponse = @{
    version = (Get-Module ColorScripts-Enhanced | Select-Object Version).Version.ToString()
    timestamp = (Get-Date -Format 'o')
    count = $metadata.Count
    scripts = $metadata
} | ConvertTo-Json -Depth 5
$apiResponse | Out-File "./api/colorscripts.json" -Encoding UTF8
```

Génère un JSON prêt pour l'API avec des informations de versionnement et d'horodatage.

### EXAMPLE 11

```powershell
# Trouver des scripts avec cache manquant pour reconstruction par lot
$metadata = Export-ColorScriptMetadata -IncludeCacheInfo -AsObject
$uncached = $metadata | Where-Object { -not $_.CacheExists } | Select-Object -ExpandProperty Name
if ($uncached.Count -gt 0) {
    Write-Host "Reconstruction du cache pour $($uncached.Count) scripts..."
    New-ColorScriptCache -Name $uncached
}
```

Identifie et reconstruit le cache pour les scripts qui n'ont pas de fichiers de cache.

### EXAMPLE 12

```powershell
# Créer une galerie HTML à partir des métadonnées
$metadata = Export-ColorScriptMetadata -IncludeFileInfo
$html = @"
<html>
<head><title>Galerie ColorScripts-Enhanced</title></head>
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

Crée une page de galerie HTML listant tous les scripts de couleurs disponibles.

### EXAMPLE 13

```powershell
# Surveiller les tailles des scripts au fil du temps
Export-ColorScriptMetadata -Path "./logs/metadata-$(Get-Date -Format 'yyyyMMdd').json" -IncludeFileInfo
Get-ChildItem "./logs/metadata-*.json" | Select-Object -Last 5 |
    ForEach-Object { Get-Content $_ | ConvertFrom-Json } |
    Group-Object { $_.Name } |
    ForEach-Object { Write-Host "$($_.Name): $(($_.Group | Measure-Object FileSize -Average).Average) octets en moyenne" }
```

Suit les changements de taille de fichier pour des scripts individuels sur plusieurs exportations.

## PARAMETERS

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

### -h

Affiche l'aide détaillée de cette commande sans effectuer l'opération.

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

Augmente chaque enregistrement avec des métadonnées de cache, incluant le chemin du fichier de cache, si un fichier de cache existe, et son horodatage de dernière modification. Ceci est utile pour identifier les scripts qui peuvent nécessiter une régénération du cache ou analyser la couverture du cache dans la bibliothèque de scripts de couleurs.

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

Inclut des détails du système de fichiers (chemin complet, taille en octets et heure de dernière écriture) dans chaque enregistrement. Lorsque les métadonnées de fichier ne peuvent pas être lues (en raison de permissions ou de fichiers manquants), les erreurs sont enregistrées via la sortie verbose et les propriétés affectées sont définies sur des valeurs nulles. Cet interrupteur est précieux pour auditer les tailles de fichiers et les dates de modification.

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

Retourne les objets de métadonnées vers le pipeline même lorsque le paramètre `-Path` est spécifié. Ceci permet de sauvegarder les métadonnées dans un fichier et d'effectuer un traitement ou un filtrage supplémentaire sur les objets dans une seule commande. Sans cet interrupteur, spécifier `-Path` supprime la sortie du pipeline.

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

Spécifie le chemin du fichier de destination pour l'exportation JSON. Prend en charge les chemins relatifs, absolus, les variables d'environnement (par exemple, `$env:TEMP\metadata.json`) et l'expansion tilde (par exemple, `~/Documents/metadata.json`). Les répertoires parents sont automatiquement créés s'ils n'existent pas. Lorsque ce paramètre est omis, la cmdlet sort les objets directement vers le pipeline au lieu d'écrire dans un fichier. La sortie JSON est formatée avec une indentation pour la lisibilité.

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

### System.Management.Automation.PSCustomObject

Lorsque `-Path` n'est pas spécifié, ou lorsque `-PassThru` est utilisé, la cmdlet retourne des objets personnalisés. Chaque objet représente un seul script de couleurs avec les propriétés de base suivantes :

- **Name** : Le nom du fichier du script de couleurs sans extension
- **Category** : La catégorie organisationnelle (par exemple, "nature", "abstract", "geometric")
- **Tags** : Un tableau de balises descriptives pour le filtrage et la recherche

Lorsque `-IncludeFileInfo` est spécifié, ces propriétés supplémentaires sont incluses :

- **FilePath** : Le chemin complet du système de fichiers vers le fichier de script
- **FileSize** : Taille en octets (null si le fichier est inaccessible)
- **LastWriteTime** : Horodatage de la dernière modification (null si indisponible)

Lorsque `-IncludeCacheInfo` est spécifié, ces propriétés supplémentaires sont incluses :

- **CachePath** : Le chemin complet vers le fichier de cache correspondant
- **CacheExists** : Booléen indiquant si un fichier de cache existe
- **CacheLastWriteTime** : Horodatage de la modification du fichier de cache (null si le cache n'existe pas)

## NOTES

## RELATED LINKS

- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Export-ColorScriptMetadata)
