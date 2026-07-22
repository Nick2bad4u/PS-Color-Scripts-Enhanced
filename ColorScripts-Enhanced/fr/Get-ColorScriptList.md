---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptList
---

# Get-ColorScriptList

## SYNOPSIS

Listes disponibles scripts de couleurs avec filtrage en option et sortie de métadonnées riches.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptList [[-Name] <string[]>] [[-Category] <string[]>] [[-Tag] <string[]>] [-h]
 [-AsObject] [-Detailed] [-Quiet] [-NoAnsiOutput]
```

## ALIASES

Cette commande ne possède aucun alias.

## DESCRIPTION

L'applet de commande `Get-ColorScriptList` récupère et affiche tous les scripts de couleurs fournis avec le module ColorScripts-Enhanced. Il fournit des options de filtrage flexibles et plusieurs formats de sortie pour s'adapter à différents cas d'utilisation.

Par défaut, l'applet de commande affiche un tableau formaté concis affichant les noms et catégories de script. Le commutateur `-Detailed` étend cette vue pour inclure des balises et des descriptions, fournissant ainsi plus de contexte en un coup d'œil.

L'applet de commande renvoie toujours les enregistrements de métadonnées au pipeline de réussite. Sans `-AsObject`, il écrit également une vue hôte formatée ; `-AsObject` supprime le formatage de cet hôte pour une automatisation propre. Les enregistrements incluent le nom, le chemin, la catégorie, les catégories, les balises, la description et la propriété de métadonnées d'origine.

Les capacités de filtrage vous permettent d'affiner la liste par :

- **Name** : prend en charge les modèles génériques (par exemple, `aurora-*`) pour une correspondance flexible
- **Category** : Filtrer par un ou plusieurs noms de catégorie (insensible à la casse)
- **Tag** : filtrer par balises de métadonnées telles que "Recommended" ou "Animated" (insensible à la casse)

L'applet de commande valide les modèles de filtre et génère des avertissements pour tout modèle de nom sans correspondance, vous aidant ainsi à identifier les fautes de frappe potentielles ou les scripts manquants.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptList
```

Affiche tous les scripts de couleurs disponibles dans un format de tableau compact indiquant le nom et la catégorie de chaque script.

### EXAMPLE 2

```powershell
Get-ColorScriptList -Detailed
```

Affiche tous les scripts de couleurs avec des colonnes supplémentaires comprenant des balises et des descriptions pour un aperçu complet.

### EXAMPLE 3

```powershell
Get-ColorScriptList -Detailed -Category Patterns
```

Affiche uniquement les scripts de la catégorie "Patterns" avec des métadonnées complètes, y compris des balises et des descriptions.

### EXAMPLE 4

```powershell
Get-ColorScriptList -AsObject -Name 'aurora-*' | Select-Object Name, Tags
```

Renvoie des objets structurés pour chaque script dont le nom correspond au modèle de caractère générique, puis sélectionne uniquement les propriétés Name et Tags à afficher.

### EXAMPLE 5

```powershell
Get-ColorScriptList -AsObject -Tag Recommended | Sort-Object Name
```

Récupère tous les scripts étiquetés "Recommended" et les trie par ordre alphabétique par nom. Utile pour trouver des scripts sélectionnés adaptés à l'intégration de profil.

### EXAMPLE 6

```powershell
Get-ColorScriptList -AsObject -Category Geometric,Abstract | Where-Object { $_.Tags -contains 'Colorful' }
```

Combine le filtrage des catégories et des balises pour rechercher des scripts appartenant à la fois aux catégories Géométrique ou Abstrait et étiquetés comme Colorés.

### EXAMPLE 7

```powershell
Get-ColorScriptList -Name blocks,pipes,matrix -AsObject | ForEach-Object { Show-ColorScript -Name $_.Name }
```

Récupère des scripts nommés spécifiques et exécute chacun d'entre eux dans l'ordre, démontrant l'intégration du pipeline avec `Show-ColorScript`.

### EXAMPLE 8

```powershell
# Compter les scripts par catégorie à des fins d'inventaire
Get-ColorScriptList -AsObject |
    Group-Object Category |
    Select-Object Name, Count |
    Sort-Object Count -Descending
```

Fournit un résumé du nombre de scripts de couleurs existant dans chaque catégorie.

### EXAMPLE 9

```powershell
# Rechercher des scripts avec des mots-clés spécifiques dans la description
$scripts = Get-ColorScriptList -AsObject
$scripts |
    Where-Object { $_.Description -match 'fractal|mandelbrot' } |
    Select-Object Name, Category, Description
```

Recherche des scripts en fonction de leur contenu de description à l'aide de la correspondance de modèles.

### EXAMPLE 10

```powershell
# Exporter vers CSV pour le traitement d'outils externes
Get-ColorScriptList -AsObject -Detailed |
    Select-Object Name, Category, Tags, Description |
    Export-Csv -Path "./colorscripts-inventory.csv" -NoTypeInformation
```

Exporte l'inventaire complet script de couleurs au format CSV pour une utilisation dans des applications de feuille de calcul.

### EXAMPLE 11

```powershell
# Vérifiez les scripts sans catégorie spécifique
$allScripts = Get-ColorScriptList -AsObject
$uncategorized = $allScripts | Where-Object { -not $_.Category }
Write-Host "Scripts sans catégorie : $($uncategorized.Count)"
$uncategorized | Select-Object Name
```

Identifie les scripts pour lesquels il manque des métadonnées de catégorie.

### EXAMPLE 12

```powershell
# Créer un cache pour les scripts filtrés
Get-ColorScriptList -Tag Recommended -AsObject |
    ForEach-Object {
        New-ColorScriptCache -Name $_.Name -PassThru
    } |
    Format-Table Name, Status
```

Évalue les scripts étiquetés `Recommended` ; seuls les moteurs de rendu éligibles à la politique de cache sont créés et d'autres enregistrements signalent `SkippedNotRequired`.

### EXAMPLE 13

```powershell
# Créer un rapport formaté de tous les scripts géométriques
Get-ColorScriptList -Category Geometric -Detailed |
    Out-String |
    Tee-Object -FilePath "./geometric-report.txt"
```

Génère et enregistre un rapport détaillé de la catégorie géométrique scripts de couleurs dans un fichier.

### EXAMPLE 14

```powershell
# Trouvez le premier script correspondant à un modèle pour un affichage rapide
$script = Get-ColorScriptList -Name "aurora-*" -AsObject | Select-Object -First 1
if ($script) {
    Show-ColorScript -Name $script.Name -PassThru
}
```

Affiche rapidement le premier script correspondant basé sur un modèle générique.

### EXAMPLE 15

```powershell
# Vérifiez que tous les scripts référencés existent avant d'exécuter l'automatisation
$requiredScripts = @("bars", "arch", "mandelbrot-zoom")
$available = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Name
$missing = $requiredScripts | Where-Object { $_ -notin $available }
if ($missing) {
    Write-Warning "Scripts manquants : $($missing -join ', ')"
} else {
    Write-Host "Tous les scripts requis sont disponibles"
}
```

Valide que tous les scripts requis existent avant l’exécution de l’automatisation.

## PARAMETERS

### -AsObject

Renvoie les objets d'enregistrement de métadonnées brutes au lieu de restituer un tableau formaté à l'hôte. Cela permet le traitement du pipeline et la manipulation programmatique des métadonnées script de couleurs.

Lorsque ce commutateur est spécifié, vous pouvez utiliser les applets de commande PowerShell standard telles que `Where-Object`, `Select-Object`, `Sort-Object` et `ForEach-Object` pour poursuivre le traitement des résultats.

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

### -Category

Filtre la liste pour inclure uniquement les scripts appartenant à une ou plusieurs catégories spécifiées. La correspondance Category ne respecte pas la casse.

Les catégories courantes incluent : motifs, géométriques, abstraits, nature, animés, texte, rétro, etc. Vous pouvez spécifier plusieurs catégories pour élargir votre recherche.

```yaml
Type: System.String[]
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

### -Detailed

Inclut des colonnes supplémentaires (balises et description) lors du rendu de la vue tableau formatée. Cela fournit des informations plus complètes sur chaque script en un coup d'œil.

Sans ce commutateur, seuls le nom et la catégorie principale sont affichés dans la sortie du tableau.

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

### -Name

Filtre la liste script de couleurs par un ou plusieurs noms de script. Prend en charge les caractères génériques (`*` et `?`) pour une correspondance de modèles flexible.

Si un modèle spécifié ne correspond à aucun script, un avertissement est généré pour aider à identifier les problèmes potentiels. La correspondance Name ne respecte pas la casse.

Vous pouvez spécifier des noms exacts ou utiliser des modèles tels que `aurora-*` pour faire correspondre plusieurs scripts associés.

```yaml
Type: System.String[]
DefaultValue: ''
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
HelpMessage: ''
```

### -NoAnsiOutput

Désactive le style ANSI dans les messages d'information et la sortie rendue pour les environnements de texte brut.

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

### -Quiet

Supprime les messages d'information tout en préservant le résultat des commandes et les erreurs.

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

### -Tag

Filtre la liste pour inclure uniquement les scripts contenant une ou plusieurs balises de métadonnées spécifiées. La correspondance des balises ne respecte pas la casse.

Les balises courantes incluent : Recommandé, Animé, Coloré, Minimal, Rétro, Complexe, Simple et plus encore. Tags aide à classer les scripts par style visuel, complexité ou cas d'utilisation.

```yaml
Type: System.String[]
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

### System.Object

Renvoie les objets d'enregistrement de métadonnées script de couleurs avec les propriétés suivantes :

- **Name** : L'identifiant du script utilisé avec `Show-ColorScript`
- **Path** : Le chemin source complet
- **Category** : La catégorie principale du script
- **Categories** : un tableau de toutes les catégories auxquelles le script appartient
- **Tags** : un tableau de balises de métadonnées décrivant le script
- **Description** : une description lisible par l'homme de la sortie visuelle du script
- **Metadata** : l'objet de métadonnées d'origine contenant toutes les informations brutes du script

Sans `-AsObject`, la cmdlet écrit une table formatée sur l'hôte tout en renvoyant les objets d'enregistrement pour un traitement potentiel du pipeline.

## NOTES

**Auteur** : Nick
**Module** : ColorScripts-Enhanced

Les enregistrements de métadonnées renvoyés fournissent des informations complètes à des fins d'affichage et d'automatisation. La propriété `Name` peut être utilisée directement avec l'applet de commande `Show-ColorScript` pour exécuter des scripts spécifiques.

Toutes les opérations de filtrage (Name, Category, Tag) ne sont pas sensibles à la casse et peuvent être combinées pour créer des requêtes puissantes. Lors de l'utilisation de caractères génériques dans le paramètre `-Name`, les modèles sans correspondance génèrent des avertissements pour faciliter le dépannage.

Pour de meilleurs résultats lors de l'intégration de scripts de couleurs dans votre profil PowerShell, utilisez le filtre `-Tag Recommended` pour identifier les scripts sélectionnés adaptés à l'affichage au démarrage.

### Bonnes pratiques

- Utilisez toujours `-AsObject` lorsque vous devez filtrer ou manipuler les résultats par programme
- Utilisez `-Detailed` lors de l'exploration interactive pour voir les balises et les descriptions
- Combinez plusieurs filtres pour des requêtes précises
- Exportez périodiquement les métadonnées pour suivre les changements au fil du temps
- Utilisez des objets de résultat pour l'automatisation plutôt que pour analyser la sortie de texte
- Tenir compte des performances lors de l'exécution répétée de requêtes (mettre en cache les résultats si possible)
- Tirer parti du Group-Object pour l'analyse et le reporting
- Utilisez Where-Object pour une logique de filtrage complexe

## RELATED LINKS

- [Version en ligne](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptList)

