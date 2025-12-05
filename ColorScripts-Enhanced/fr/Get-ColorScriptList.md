---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/fr/Get-ColorScriptList.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptList

## SYNOPSIS

Liste les scripts de couleurs disponibles avec filtrage optionnel et sortie de métadonnées riches.

## SYNTAX

### Default (Default)

```powershell
Get-ColorScriptList [-AsObject] [-Detailed] [-Name <String[]>] [-Category <String[]>]
 [-Tag <String[]>] [<CommonParameters>]
```

### \_\_AllParameterSets

```powershell
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-AsObject]
 [-Detailed] [<CommonParameters>]
```

## DESCRIPTION

L'applet de commande `Get-ColorScriptList` récupère et affiche tous les scripts de couleurs inclus dans le module ColorScripts-Enhanced. Elle offre des options de filtrage flexibles et plusieurs formats de sortie pour s'adapter à différents cas d'usage.

Par défaut, l'applet de commande affiche un tableau formaté concis montrant les noms des scripts et leurs catégories. Le commutateur `-Detailed` étend cette vue pour inclure les balises et les descriptions, fournissant plus de contexte d'un coup d'œil.

Pour les scénarios d'automatisation et programmatiques, le paramètre `-AsObject` retourne les enregistrements de métadonnées brutes en tant qu'objets PowerShell, permettant un traitement supplémentaire via le pipeline. Ces enregistrements incluent des informations complètes telles que le nom, la catégorie, les catégories, les balises, la description et la propriété de métadonnées originale.

Les capacités de filtrage vous permettent de réduire la liste par :

- **Name** : Prend en charge les modèles de caractères génériques (par exemple, `aurora-*`) pour une correspondance flexible
- **Category** : Filtre par un ou plusieurs noms de catégories (insensible à la casse)
- **Tag** : Filtre par balises de métadonnées telles que "Recommended" ou "Animated" (insensible à la casse)

L'applet de commande valide les modèles de filtre et génère des avertissements pour tout modèle de nom non apparié, vous aidant à identifier les erreurs potentielles ou les scripts manquants.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Affiche tous les scripts de couleurs disponibles dans un format de tableau compact montrant le nom et la catégorie de chaque script.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed
```

Affiche tous les scripts de couleurs avec des colonnes supplémentaires incluant les balises et les descriptions pour un aperçu complet.

### EXAMPLE 3

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

Affiche uniquement les scripts de la catégorie "Patterns" avec toutes les métadonnées incluant les balises et les descriptions.

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

Retourne des objets structurés pour chaque script dont le nom correspond au modèle de caractères génériques, puis sélectionne uniquement les propriétés Name et Tags pour l'affichage.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

Récupère tous les scripts étiquetés comme "Recommended" et les trie par ordre alphabétique par nom. Utile pour trouver des scripts curatés adaptés à l'intégration dans le profil.

### EXAMPLE 6

```powershell
Get-ColorScriptList -AsObject -Category Geometric,Abstract | Where-Object { $_.Tags -contains 'Colorful' }
```

Combine le filtrage par catégorie et par balise pour trouver des scripts qui sont à la fois dans les catégories Geometric ou Abstract et étiquetés comme Colorful.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Name blocks,pipes,matrix -AsObject | ForEach-Object { Show-ColorScript -Name $_.Name }
```

Récupère des scripts nommés spécifiques et les exécute chacun en séquence, démontrant l'intégration du pipeline avec `Show-ColorScript`.

### EXAMPLE 8

```powershell
# Count scripts by category for inventory purposes
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending
```

Fournit un résumé du nombre de scripts de couleurs existant dans chaque catégorie.

### EXAMPLE 9

```powershell
# Find scripts with specific keywords in description
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

Recherche des scripts basés sur le contenu de leur description en utilisant la correspondance de modèles.

### EXAMPLE 10

```powershell
# Export to CSV for external tool processing
Get-ColorScriptList -AsObject -Detailed |
    Select-Object Name, Category, Tags, Description |
    Export-Csv -Path "./colorscripts-inventory.csv" -NoTypeInformation
```

Exporte l'inventaire complet des scripts de couleurs au format CSV pour une utilisation dans des applications de tableur.

### EXAMPLE 11

```powershell
# Check for scripts without specific category
$allScripts = Get-ColorScriptList -AsObject
$uncategorized = $allScripts | Where-Object { -not $_.Category }
Write-Host "Uncategorized scripts: $($uncategorized.Count)"
$uncategorized | Select-Object Name
```

Identifie les scripts qui sont manquants de métadonnées de catégorie.

### EXAMPLE 12

```powershell
# Build cache for filtered scripts
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object {
        New-ColorScriptCache -Name $_.Name -PassThru
    } |
    Format-Table Name, Status
```

Met en cache uniquement les scripts recommandés et affiche les résultats de l'opération de mise en cache.

### EXAMPLE 13

```powershell
# Create a formatted report of all geometric scripts
Get-ColorScriptList -Category Geometric -Detailed |
    Out-String |
    Tee-Object -FilePath "./geometric-report.txt"
```

Génère et sauvegarde un rapport détaillé des scripts de couleurs de la catégorie géométrique dans un fichier.

### EXAMPLE 14

```powershell
# Find the first script matching a pattern for quick display
$script = Get-ColorScriptList -Name "aurora-*" -AsObject | Select-Object -First 1
if ($script) {
    Show-ColorScript -Name $script.Name -PassThru
}
```

Affiche rapidement le premier script correspondant basé sur un modèle de caractères génériques.

### EXAMPLE 15

```powershell
# Verify all referenced scripts exist before running automation
$requiredScripts = @("bars", "arch", "mandelbrot-zoom")
$available = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$missing = $requiredScripts | Where-Object { $_ -notin $available }
if ($missing) {
    Write-Warning "Missing scripts: $($missing -join ', ')"
} else {
    Write-Host "All required scripts are available"
}
```

Valide que tous les scripts requis existent avant l'exécution de l'automatisation.

## PARAMETERS

### -AsObject

Retourne des objets d'enregistrement de métadonnées brutes au lieu de rendre un tableau formaté à l'hôte. Cela permet le traitement du pipeline et la manipulation programmatique des métadonnées des scripts de couleurs.

Lorsque ce commutateur est spécifié, vous pouvez utiliser des applets de commande PowerShell standard comme `Where-Object`, `Select-Object`, `Sort-Object` et `ForEach-Object` pour traiter davantage les résultats.

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

Filtre la liste pour inclure uniquement les scripts appartenant à une ou plusieurs catégories spécifiées. La correspondance de catégories est insensible à la casse.

Les catégories communes incluent : Patterns, Geometric, Abstract, Nature, Animated, Text, Retro, et plus. Vous pouvez spécifier plusieurs catégories pour élargir votre recherche.

```yaml
Type: System.String[]
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

### -Detailed

Inclut des colonnes supplémentaires (balises et description) lors du rendu de la vue de tableau formaté. Cela fournit des informations plus complètes sur chaque script d'un coup d'œil.

Sans ce commutateur, seuls le nom et la catégorie primaire sont affichés dans la sortie du tableau.

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

Filtre la liste des scripts de couleurs par un ou plusieurs noms de scripts. Prend en charge les caractères génériques (`*` et `?`) pour une correspondance de modèles flexible.

Si un modèle spécifié ne correspond à aucun script, un avertissement est généré pour vous aider à identifier les problèmes potentiels. La correspondance de noms est insensible à la casse.

Vous pouvez spécifier des noms exacts ou utiliser des modèles comme `aurora-*` pour correspondre à plusieurs scripts liés.

```yaml
Type: System.String[]
DefaultValue: None
SupportsWildcards: true
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

### -Tag

Filtre la liste pour inclure uniquement les scripts contenant une ou plusieurs balises de métadonnées spécifiées. La correspondance de balises est insensible à la casse.

Les balises communes incluent : Recommended, Animated, Colorful, Minimal, Retro, Complex, Simple, et plus. Les balises aident à catégoriser les scripts par style visuel, complexité ou cas d'usage.

```yaml
Type: System.String[]
DefaultValue: None
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Cette applet de commande n'accepte pas d'entrée de pipeline.

## OUTPUTS

### System.Object

Lorsque `-AsObject` est spécifié, retourne des objets d'enregistrement de métadonnées de scripts de couleurs avec les propriétés suivantes :

- **Name** : L'identifiant du script utilisé avec `Show-ColorScript`
- **Category** : La catégorie primaire du script
- **Categories** : Un tableau de toutes les catégories auxquelles le script appartient
- **Tags** : Un tableau de balises de métadonnées décrivant le script
- **Description** : Une description lisible par l'homme de la sortie visuelle du script
- **Metadata** : L'objet de métadonnées original contenant toutes les informations de script brutes

Sans `-AsObject`, l'applet de commande écrit un tableau formaté à l'hôte tout en retournant les objets d'enregistrement pour un traitement de pipeline potentiel.

## ADVANCED USAGE PATTERNS

### Dynamic Filtering

## Multi-Criteria Filtering

```powershell
# Find animated scripts that are colorful
Get-ColorScriptList -AsObject |
    Where-Object {
        $_.Tags -contains 'Animated' -and
        $_.Tags -contains 'Colorful'
    }

# Find scripts in Nature category but exclude simple ones
Get-ColorScriptList -Category Nature -AsObject |
    Where-Object { $_.Tags -notcontains 'Simple' }
```

## Fuzzy Matching

```powershell
# Find scripts similar to a name pattern
$search = "wave"
Get-ColorScriptList -AsObject |
    Where-Object { $_.Name -like "*$search*" } |
    Select-Object Name, Category
```

### Data Analysis

## Category Distribution

```powershell
# Analyze how scripts are distributed across categories
$analysis = Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object @{N='Category'; E={$_.Name}}, @{N='Count'; E={$_.Count}}, @{N='Percentage'; E={[math]::Round($_.Count / (Get-ColorScriptList -AsObject).Count * 100)}}

$analysis | Sort-Object Count -Descending | Format-Table
```

## Tag Frequency Analysis

```powershell
# Determine most common tags
Get-ColorScriptList -AsObject |
    ForEach-Object { $_.Tags } |
    Group-Object |
    Sort-Object Count -Descending |
    Format-Table Name, Count
```

### Integration Workflows

## Playlist Creation

```powershell
# Create a "favorite" playlist
$playlist = Get-ColorScriptList -AsObject |
    Where-Object { $_.Tags -contains 'Recommended' } |
    Select-Object -ExpandProperty Name

# Display playlist
$playlist | ForEach-Object {
    Write-Host "Showing: $_"
    Show-ColorScript -Name $_
    Start-Sleep -Seconds 2
}
```

## Metadata Export for Web

```powershell
# Export detailed metadata
$web = Get-ColorScriptList -AsObject |
    Select-Object Name, Category, Tags, Description |
    ConvertTo-Json

$web | Out-File "./scripts.json" -Encoding UTF8
```

## Validation and Health Check

```powershell
# Health check on all scripts
$health = Get-ColorScriptList -AsObject |
    ForEach-Object {
        $cached = Test-Path "$env:APPDATA\ColorScripts-Enhanced\cache\$($_.Name).cache"
        [PSCustomObject]@{
            Name = $_.Name
            Category = $_.Category
            Cached = $cached
            TagCount = $_.Tags.Count
        }
    }

$uncached = @($health | Where-Object { -not $_.Cached })
Write-Host "Scripts without cache: $($uncached.Count)"
$uncached | Format-Table Name, Category
```

## PERFORMANCE CONSIDERATIONS

### Query Optimization

## Filter Early

```powershell
# Faster: Filter by category first
Get-ColorScriptList -Category Geometric -AsObject |
    Where-Object { $_.Name -like "*spiral*" }

# Slower: Get all then filter
Get-ColorScriptList -AsObject |
    Where-Object { $_.Category -eq "Geometric" -and $_.Name -like "*spiral*" }
```

## Use Appropriate Output Format

```powershell
# For exploration: Detailed display
Get-ColorScriptList -Detailed

# For automation: Object format
Get-ColorScriptList -AsObject

# For piping: AsObject to pipeline
Get-ColorScriptList -AsObject | ForEach-Object { ... }
```

## NOTES

**Author** : Nick
**Module** : ColorScripts-Enhanced
**Version** : 1.0

Les enregistrements de métadonnées retournés fournissent des informations complètes pour l'affichage et l'automatisation. La propriété `Name` peut être utilisée directement avec l'applet de commande `Show-ColorScript` pour exécuter des scripts spécifiques.

Toutes les opérations de filtrage (Name, Category, Tag) sont insensibles à la casse et peuvent être combinées pour créer des requêtes puissantes. Lorsque vous utilisez des caractères génériques dans le paramètre `-Name`, des modèles non appariés génèrent des avertissements pour aider au dépannage.

Pour de meilleurs résultats lors de l'intégration de scripts de couleurs dans votre profil PowerShell, utilisez le filtre `-Tag Recommended` pour identifier des scripts curatés adaptés à l'affichage au démarrage.

### Best Practices

- Utilisez toujours `-AsObject` lorsque vous devez filtrer ou manipuler les résultats de manière programmatique
- Utilisez `-Detailed` lors de l'exploration interactive pour voir les balises et les descriptions
- Combinez plusieurs filtres pour des requêtes précises
- Exportez les métadonnées périodiquement pour suivre les changements au fil du temps
- Utilisez les objets de résultats pour l'automatisation plutôt que d'analyser la sortie texte
- Considérez les performances lors de l'exécution répétée de requêtes (mettez en cache les résultats si possible)
- Tirez parti de Group-Object pour l'analyse et les rapports
- Utilisez Where-Object pour une logique de filtrage complexe

## RELATED LINKS

- [Show-ColorScript](Show-ColorScript.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [Online Documentation](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
- [Module Repository](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
