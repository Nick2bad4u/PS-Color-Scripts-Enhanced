---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

Affiche un colorscript et utilise un cache sélectif uniquement pour les moteurs de rendu coûteux.

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Help

```
Show-ColorScript [-h] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Named

```
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### List

```
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### All

```
Show-ColorScript [-All] [-WaitForInput] [-NoClear] [-NoCache] [-Category <string[]>]
 [-Tag <string[]>] [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

## ALIASES

- `scs`

## DESCRIPTION

Affiche de beaux scripts de couleur ANSI dans votre terminal avec optimisation intelligente des performances. L'applet de commande fournit quatre modes d'opération principaux :

**Mode Aléatoire (Par Défaut) :** Affiche un script de couleur sélectionné aléatoirement dans la collection disponible. C'est le comportement par défaut lorsqu'aucun paramètre n'est spécifié.

**Mode Nommé :** Affiche un script de couleur spécifique par nom. Prend en charge les modèles de caractères génériques pour une correspondance flexible. Lorsque plusieurs scripts correspondent à un modèle, le premier match dans l'ordre alphabétique est sélectionné.

**Mode Liste :** Affiche une liste formatée de tous les scripts de couleur disponibles avec leurs métadonnées, incluant le nom, la catégorie, les balises et les descriptions.

**Mode Tout :** Parcourt tous les scripts de couleur disponibles dans l'ordre alphabétique. Particulièrement utile pour présenter l'ensemble de la collection ou découvrir de nouveaux scripts.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Affiche un script de couleur aléatoire avec mise en cache activée. C'est le moyen le plus rapide d'ajouter une touche visuelle à votre session terminal.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Affiche le script de couleur spécifié par nom exact. L'extension .ps1 n'est pas requise.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Affiche le premier script de couleur (alphabétiquement) qui correspond au modèle de caractères génériques "aurora-\*". Utile lorsque vous vous souvenez d'une partie du nom d'un script.

### EXAMPLE 4

```powershell
scs hearts
```

Utilise l'alias du module 'scs' pour un accès rapide au script de couleur hearts. Les alias fournissent des raccourcis pratiques pour une utilisation fréquente.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Liste tous les scripts de couleur disponibles avec leurs métadonnées dans un tableau formaté. Utile pour découvrir les scripts disponibles et leurs attributs.

### EXAMPLE 6

```powershell
Show-ColorScript -Name arch -NoCache
```

Affiche le script de couleur arch sans utiliser le cache, forçant une exécution fraîche. Utile pendant le développement ou lors du dépannage des problèmes de cache.

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

Affiche un script thématique sur la nature aléatoire et capture son objet de métadonnées pour une inspection ou un traitement ultérieur.

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

Rend le script de couleur et sauvegarde la sortie dans un fichier texte. Les codes ANSI rendus sont préservés, permettant au fichier d'être affiché plus tard avec une coloration appropriée.

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

Affiche tous les scripts de couleur dans l'ordre alphabétique avec un court délai automatique entre chacun. Parfait pour une démonstration visuelle de l'ensemble de la collection.

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

Affiche tous les scripts de couleur un par un, en faisant une pause après chacun. Appuyez sur la barre d'espace pour avancer vers le script suivant, ou appuyez sur 'q' pour quitter la séquence tôt.

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

Parcourt tous les scripts de couleur thématiques sur la nature avec progression manuelle. Combine le filtrage avec la navigation interactive pour une expérience curatée.

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

Affiche un script de couleur aléatoire qui a à la fois les balises "retro" et "geometric". Le filtrage par balises permet une sélection précise de sous-ensemble.

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Art,Abstract
```

Liste seulement les scripts de couleur catégorisés comme "Art" ou "Abstract", vous aidant à découvrir les scripts dans des thèmes spécifiques.

### EXAMPLE 14

```powershell
# Measure performance improvement from caching
$uncached = Measure-Command { Show-ColorScript -Name spectrum -NoCache }
$cached = Measure-Command { Show-ColorScript -Name spectrum }
Write-Host "Uncached: $($uncached.TotalMilliseconds)ms | Cached: $($cached.TotalMilliseconds)ms | Speedup: $([math]::Round($uncached.TotalMilliseconds / $cached.TotalMilliseconds, 1))x"
```

Démontre l'amélioration de performance que la mise en cache fournit en mesurant le temps d'exécution.

### EXAMPLE 15

```powershell
# Set up daily rotation of different colorscripts
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

Affiche un script de couleur cohérent mais différent chaque jour basé sur la date.

### EXAMPLE 16

```powershell
# Export rendered colorscript to file for sharing
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Later, display the saved file
Get-Content "./aurora.ansi" -Raw | Write-Host
```

Sauvegarde un script de couleur rendu dans un fichier qui peut être affiché plus tard ou partagé avec d'autres.

### EXAMPLE 17

```powershell
# Create a slideshow of geometric colorscripts
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

Affiche automatiquement une séquence de scripts de couleur géométriques avec des délais de 3 secondes entre chacun.

### EXAMPLE 18

```powershell
# Error handling example
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Script not found: $_"
    Show-ColorScript  # Fallback to random
}
```

Démontre la gestion d'erreur lorsqu'on demande un script qui n'existe pas.

### EXAMPLE 19

```powershell
# Build automation integration
if ($env:CI) {
    Show-ColorScript -Name "nerd-font-test" -NoCache
} else {
    Show-ColorScript  # Random display for interactive use
}
```

Montre comment afficher conditionnellement différents scripts de couleur dans les environnements CI/CD vs. sessions interactives.

### EXAMPLE 20

```powershell
# Scheduled task for terminal greeting
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

Démontre l'exécution d'un script de couleur spécifique dans le cadre d'une tâche planifiée ou d'automatisation de démarrage.

## PARAMETERS

### -All

Parcourt tous les scripts de couleur disponibles dans l'ordre alphabétique. Lorsqu'il est spécifié seul, les scripts sont affichés en continu avec un court délai automatique. Combinez avec `-WaitForInput` pour contrôler manuellement la progression dans la collection. Ce mode est idéal pour présenter la bibliothèque complète ou découvrir de nouveaux favoris.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

Filtre la collection de scripts disponibles par une ou plusieurs catégories avant que toute sélection ou affichage ne se produise. Les catégories sont généralement des thèmes larges comme "Nature", "Abstract", "Art", "Retro", etc. Plusieurs catégories peuvent être spécifiées comme un tableau. Ce paramètre fonctionne en conjonction avec tous les modes (Random, Named, List, All) pour réduire l'ensemble de travail.

```yaml
Type: System.String[]
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

### -ExcludeCategory

Exclude scripts from one or more categories.
Use this to filter out large collections like Pokemon scripts.

```yaml
Type: System.String[]
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

Affiche l'aide détaillée de cette commande sans effectuer l'opération.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

Opt-in flag to include Pokemon colorscripts in the random selection.
When omitted, Pokemon scripts are filtered out automatically.

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

### -List

Affiche une liste formatée de tous les scripts de couleur disponibles avec leurs métadonnées associées. La sortie inclut le nom du script, la catégorie, les balises et la description. Ceci est utile pour explorer les options disponibles et comprendre l'organisation de la collection. Peut être combiné avec `-Category` ou `-Tag` pour lister seulement les sous-ensembles filtrés.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: List
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

Le nom du script de couleur à afficher (sans l'extension .ps1). Prend en charge les modèles de caractères génériques (\* et ?) pour une correspondance flexible. Lorsque plusieurs scripts correspondent à un modèle de caractères génériques, le premier match dans l'ordre alphabétique est sélectionné et affiché. Utilisez `-PassThru` pour vérifier quel script a été choisi lors de l'utilisation de caractères génériques.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Named
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

Désactive la mise en forme ANSI dans les messages d'information et la sortie rendue pour les environnements en texte brut.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- NoColor
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

### -NoCache

Contourne le système de mise en cache et exécute le script de couleur directement. Cela force une exécution fraîche et peut être utile lors du test des modifications de script, du débogage, ou lorsque la corruption du cache est suspectée. Sans ce commutateur, la sortie mise en cache est utilisée lorsqu'elle est disponible pour des performances optimales.

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

### -NoClear

When cycling through scripts with -All, skip clearing the host between displays so prior output remains visible.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### -PassThru

Retourne l'objet de métadonnées du script de couleur sélectionné vers le pipeline en plus d'afficher le script de couleur. L'objet de métadonnées contient des propriétés comme Name, Path, Category, Tags et Description. Cela permet l'accès programmatique aux informations du script pour le filtrage, la journalisation ou le traitement ultérieur tout en rendant la sortie visuelle.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Named
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

Supprime les messages d'information sans masquer la sortie de la commande ni les erreurs.

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

### -Random

Demande explicitement une sélection de script de couleur aléatoire. C'est le comportement par défaut lorsqu'aucun nom n'est spécifié, donc ce commutateur est principalement utile pour la clarté dans les scripts ou lorsque vous voulez être explicite sur le mode de sélection. Peut être combiné avec `-Category` ou `-Tag` pour randomiser dans un sous-ensemble filtré.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ReturnText

Émet le script de couleur rendu comme une chaîne vers le pipeline PowerShell au lieu d'écrire directement dans l'hôte console. Cela permet à la sortie d'être capturée dans une variable, redirigée vers un fichier ou canalisée vers d'autres commandes. La sortie conserve toutes les séquences d'échappement ANSI, donc elle s'affichera avec les couleurs appropriées lorsqu'elle sera écrite plus tard dans un terminal compatible.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- AsString
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

Filtre la collection de scripts disponibles par balises de métadonnées (insensible à la casse). Les balises sont des descripteurs plus spécifiques que les catégories, tels que "geometric", "retro", "animated", "minimal", etc. Plusieurs balises peuvent être spécifiées comme un tableau. Les scripts correspondant à l'une des balises spécifiées seront inclus dans l'ensemble de travail avant que la sélection ne se produise.

```yaml
Type: System.String[]
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

### -ValidateCache

Forces cache validation before rendering.
Use when you need to rebuild cached colorscript output manually.

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

### -WaitForInput

Lorsqu'il est utilisé avec `-All`, fait une pause après l'affichage de chaque script de couleur et attend une entrée utilisateur avant de procéder. Appuyez sur la barre d'espace pour avancer vers le script suivant dans la séquence. Appuyez sur 'q' pour quitter la séquence tôt et retourner à l'invite. Cela fournit une expérience de navigation interactive à travers l'ensemble de la collection.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

Vous pouvez canaliser les noms de scripts de couleur vers Show-ColorScript. Cela permet des workflows basés sur le pipeline où les noms de scripts sont générés ou filtrés par d'autres commandes.

## OUTPUTS

### System.Object

Lorsque `-PassThru` est spécifié, retourne l'objet de métadonnées du script de couleur sélectionné contenant des propriétés comme Name, Path, Category, Tags et Description.

### System.String (2)

Lorsque `-ReturnText` est spécifié, émet le script de couleur rendu comme une chaîne vers le pipeline. Cette chaîne contient toutes les séquences d'échappement ANSI pour un rendu coloré approprié lorsqu'elle est affichée dans un terminal compatible.

### None

En opération par défaut (sans `-PassThru` ou `-ReturnText`), la sortie est écrite directement dans l'hôte console et rien n'est retourné vers le pipeline.

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 ou ultérieur

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

