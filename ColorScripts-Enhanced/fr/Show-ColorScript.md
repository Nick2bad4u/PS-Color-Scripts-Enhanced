---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

Affiche un script de couleurs avec mise en cache sélective pour les moteurs de rendu coûteux.

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

Affiche de magnifiques scripts de couleurs ANSI dans votre terminal avec une optimisation intelligente des performances. L'applet de commande fournit quatre modes de fonctionnement principaux :

**Mode aléatoire (par défaut) :** Affiche un script de couleurs sélectionné au hasard dans la collection disponible. Il s'agit du comportement par défaut lorsqu'aucun paramètre n'est spécifié.

**Mode nommé :** Affiche un script de couleurs spécifique par son nom. Prend en charge les modèles génériques pour une correspondance flexible. Lorsque plusieurs scripts correspondent à un modèle, la première correspondance par ordre alphabétique est sélectionnée.

**Mode Liste :** Affiche un tableau compact contenant les noms des scripts de couleurs et leurs catégories principales. Utilisez `Get-ColorScriptList -AsObject` pour obtenir des enregistrements de métadonnées complets.

**Mode Tous :** Parcourt tous les scripts de couleurs disponibles par ordre alphabétique. Ce mode est particulièrement utile pour présenter l'ensemble de la collection ou découvrir de nouveaux scripts.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Affiche un script de couleurs aléatoire. Les scripts groupés déterministes sont rendus en cours ; Les moteurs de rendu informatiques éligibles peuvent réutiliser la sortie validée mise en cache.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Affiche le script de couleurs spécifié par son nom exact. L'extension .ps1 n'est pas requise.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Affiche le premier script de couleurs (par ordre alphabétique) qui correspond au modèle de caractère générique "aurora-\*". Utile lorsque vous vous souvenez d'une partie du nom d'un script.

### EXAMPLE 4

```powershell
scs hearts
```

Utilise l'alias du module 'scs' pour un accès rapide aux cœurs script de couleurs. Les alias fournissent des raccourcis pratiques pour une utilisation fréquente.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Listes disponibles scripts de couleurs par nom et catégorie principale. Utile pour une découverte rapide.

### EXAMPLE 6

```powershell
Show-ColorScript -Name Galaxy -NoCache
```

Affiche le moteur de rendu Galaxy éligible sans lire la sortie mise en cache, forçant un nouveau rendu isolé. Utile pour tester les modifications du moteur de rendu ou enquêter sur la corruption du cache.

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

Affiche un script aléatoire sur le thème de la nature et capture son objet de métadonnées pour une inspection ou un traitement plus approfondi.

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

Rend le script de couleurs et enregistre la sortie dans un fichier texte. Les codes ANSI rendus sont conservés, permettant au fichier d'être affiché ultérieurement avec une coloration appropriée.

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

Affiche tous les scripts de couleurs par ordre alphabétique avec un bref délai automatique entre chacun. Parfait pour une vitrine visuelle de toute la collection.

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

Affiche tous les scripts de couleurs un par un, en faisant une pause après chacun. Appuyez sur la barre d'espace pour passer au script suivant ou appuyez sur 'q' pour quitter la séquence plus tôt.

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

Parcourez tous les scripts de couleurs sur le thème de la nature avec progression manuelle. Combine le filtrage avec la navigation interactive pour une expérience organisée.

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

Affiche un script de couleurs aléatoire comportant la balise "retro" ou "geometric". Plusieurs valeurs de balises utilisent une sémantique de correspondance quelconque.

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Artistic,Abstract
```

Répertorie uniquement les scripts de couleurs classés comme "Art" ou "Abstract", vous aidant ainsi à découvrir des scripts dans des thèmes spécifiques.

### EXAMPLE 14

```powershell
# Inspectez l'éligibilité du cache et l'état de construction pour un moteur de rendu sélectionné par stratégie.
New-ColorScriptCache -Name Galaxy -Force -PassThru |
    Select-Object Name, Status, CacheFile
Show-ColorScript -Name Galaxy
```

Construit et inspecte une entrée de cache pour un moteur de rendu éligible sans réclamer un multiplicateur de performances indépendant de la machine.

### EXAMPLE 15

```powershell
# Mettre en place la rotation quotidienne des différents scripts de couleurs
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

Affiche un script de couleurs cohérent mais différent chaque jour en fonction de la date.

### EXAMPLE 16

```powershell
# Exporter le rendu script de couleurs vers un fichier pour le partage
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Plus tard, affichez le fichier enregistré
Get-Content "./aurora.ansi" -Raw | Write-Host
```

Enregistre un script de couleurs rendu dans un fichier qui peut être affiché ultérieurement ou partagé avec d'autres.

### EXAMPLE 17

```powershell
# Créer un diaporama de scripts de couleurs géométrique
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

Affiche automatiquement une séquence de scripts de couleurs géométriques avec des délais de 3 secondes entre chacun.

### EXAMPLE 18

```powershell
# Exemple de gestion des erreurs
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Script introuvable : $_"
    Show-ColorScript  # Solution de repli : afficher une sélection aléatoire
}
```

Montre la gestion des erreurs lors de la demande d’un script qui n’existe pas.

### EXAMPLE 19

```powershell
# Intégration de l'automatisation du build
if ($env:CI) {
    Show-ColorScript -Name "Galaxy" -NoCache
} else {
    Show-ColorScript  # Affichage aléatoire pour une utilisation interactive
}
```

Montre comment afficher de manière conditionnelle différents scripts de couleurs dans des environnements CI/CD par rapport à des sessions interactives.

### EXAMPLE 20

```powershell
# Tâche planifiée pour l'accueil du terminal
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

Montre l’exécution d’un script de couleurs spécifique dans le cadre d’une tâche planifiée ou d’une automatisation de démarrage.

### EXAMPLE 21

```powershell
Show-ColorScript -IncludePokemon
```

Affiche un script de couleurs aléatoire comprenant des scripts dans la catégorie `Pokemon`. Utile lorsque vous souhaitez que l'art Pokémon soit inclus dans votre sélection aléatoire.

### EXAMPLE 22

```powershell
Show-ColorScript -Random -ExcludeCategory Pokemon,Gaming
```

Affiche un script de couleurs aléatoire tout en excluant les catégories `Pokemon` et `Gaming`. Combinez-le avec `-Category` ou `-Tag` pour affiner davantage la sélection.

## PARAMETERS

### -All

Parcourez tous les scripts de couleurs disponibles par ordre alphabétique. Lorsqu'ils sont spécifiés seuls, les scripts sont affichés en continu avec un court délai automatique. Combinez-le avec `-WaitForInput` pour contrôler manuellement la progression dans la collection. Ce mode est idéal pour présenter la bibliothèque complète ou découvrir de nouveaux favoris.

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

Filtrez la collection de scripts disponible par une ou plusieurs catégories avant toute sélection ou affichage. Les catégories sont généralement des thèmes généraux comme "Nature", "Abstract", "Art", "Retro", etc. Plusieurs catégories peuvent être spécifiées sous forme de tableau. Ce paramètre fonctionne en conjonction avec tous les modes (Aléatoire, Nommé, Liste, Tous) pour restreindre l'ensemble de travail.

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

Excluez les scripts d’une ou plusieurs catégories avant que la sélection ne soit effectuée. Par exemple, utilisez `-ExcludeCategory Pokemon` pour éviter tous les scripts Pokémon, ou spécifiez plusieurs catégories telles que `-ExcludeCategory Pokemon,Gaming`. Fonctionne dans tous les modes (Aléatoire, Nommé, Liste, Tous) et se combine avec les filtres `-Category` et `-Tag`.

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

Affiche une aide détaillée pour cette commande sans effectuer l'opération.

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

Indicateur d'inscription pour inclure Pokémon scripts de couleurs dans la sélection. Lorsqu'ils sont omis, les scripts Pokémon sont automatiquement filtrés (par défaut). Remarque : cela remplace l'ancien paramètre `-ExcludePokemon` – le refactor a inversé la sémantique, vous pouvez donc désormais choisir d'afficher les scripts Pokémon au lieu de vous désinscrire.

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

Affichez une liste formatée de tous les scripts de couleurs disponibles avec leurs métadonnées associées. La sortie inclut le nom du script, la catégorie, les balises et la description. Ceci est utile pour explorer les options disponibles et comprendre l’organisation de la collection. Peut être combiné avec `-Category` ou `-Tag` pour répertorier uniquement les sous-ensembles filtrés.

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

Le nom du script de couleurs à afficher (sans l'extension .ps1). Prend en charge les modèles génériques (\* et ?) pour une correspondance flexible. Lorsque plusieurs scripts correspondent à un modèle générique, la première correspondance par ordre alphabétique est sélectionnée et affichée. Utilisez `-PassThru` pour vérifier quel script a été choisi lors de l'utilisation de caractères génériques.

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

Désactive le style ANSI dans les messages d'information et la sortie rendue pour les environnements de texte brut.

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

Contourne les lectures de cache validées pour les moteurs de rendu sélectionnés par la stratégie et force un nouveau rendu isolé. Cette option est utile pour tester les modifications d'un moteur de rendu ou rechercher une corruption du cache. Les scripts groupés déterministes et les scripts non répertoriés ou personnalisés contournent déjà le cache ; le contenu groupé déterministe continue d'être rendu dans le processus.

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

Lorsqu'il est utilisé avec `-All`, ignorez l'appel automatique `Clear-Host` entre scripts de couleurs afin que chaque script rendu reste visible au-dessus du suivant. Ceci est particulièrement utile lorsque vous souhaitez comparer des scripts côte à côte ou capturer l'intégralité de la présentation dans les transcriptions de session.

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

Renvoyez l'objet de métadonnées du script de couleurs sélectionné au pipeline en plus d'afficher le script de couleurs. L'objet de métadonnées contient des propriétés telles que Name, Path, Category, Tags et Description. Cela permet un accès par programmation aux informations de script pour le filtrage, la journalisation ou un traitement ultérieur tout en continuant à restituer la sortie visuelle.

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

Supprime les messages d'information tout en préservant le résultat des commandes et les erreurs.

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

Demandez explicitement une sélection aléatoire script de couleurs. Il s'agit du comportement par défaut lorsqu'aucun nom n'est spécifié. Ce commutateur est donc principalement utile pour plus de clarté dans les scripts ou lorsque vous souhaitez être explicite sur le mode de sélection. Peut être combiné avec `-Category` ou `-Tag` pour randomiser dans un sous-ensemble filtré.

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

Émettez le script de couleurs rendu en tant que string vers le pipeline PowerShell au lieu d'écrire directement sur l'hôte de la console. Cela permet à la sortie d'être capturée dans une variable, redirigée vers un fichier ou redirigée vers d'autres commandes. La sortie conserve toutes les séquences d'échappement ANSI, elle s'affichera donc avec les couleurs appropriées lors de son écriture ultérieure sur un terminal compatible.

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

Filtrez la collection de scripts disponible par balises de métadonnées (insensible à la casse). Tags sont des descripteurs plus spécifiques que des catégories, tels que "geometric", "retro", "animated", "minimal", etc. Plusieurs balises peuvent être spécifiées sous forme de tableau. Les scripts correspondant à l'une des balises spécifiées seront inclus dans l'ensemble de travail avant la sélection.

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

Actualise le marqueur de métadonnées du cache au niveau du module avant le rendu, y compris lorsque le répertoire de cache a déjà été initialisé dans la session de module en cours. Il ne reconstruit pas les entrées du cache de sortie et ne remplace pas la validation normale par entrée. La définition de `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE` sur `1`, `true` ou `yes` demande la même actualisation lors de l'initialisation du cache.

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

Lorsqu'il est utilisé avec `-All`, faites une pause après l'affichage de chaque script de couleurs et attendez la saisie de l'utilisateur avant de continuer. Appuyez sur la barre d'espace pour passer au script suivant dans la séquence. Appuyez sur 'q' pour quitter la séquence plus tôt et revenir à l'invite. Cela offre une expérience de navigation interactive à travers l’ensemble de la collection.

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

Cette applet de commande prend en charge les paramètres communs :
Pour plus d'informations, consultez
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Cette applet de commande n'accepte pas les entrées de pipeline. Dirigez les enregistrements d’inventaire vers `ForEach-Object` et appelez `Show-ColorScript -Name $_.Name` lors de la composition d’un pipeline.

## OUTPUTS

### System.Object

Lorsque `-PassThru` est spécifié, renvoie l'objet de métadonnées du script de couleurs sélectionné contenant des propriétés telles que Name, Path, Category, Tags et Description.

### System.String (2)

Lorsque `-ReturnText` est spécifié, émet le script de couleurs rendu en tant que string vers le pipeline. Ce string contient toutes les séquences d'échappement ANSI pour un rendu des couleurs correct lorsqu'elles sont affichées dans un terminal compatible.

### None

En fonctionnement par défaut (sans `-PassThru` ou `-ReturnText`), la sortie est écrite directement sur l'hôte de la console et rien n'est renvoyé au pipeline.

## NOTES

**Auteur :** Nick
**Module :** ColorScripts-Enhanced
**Nécessite :** PowerShell 5.1 ou version ultérieure

## RELATED LINKS

- [Version en ligne](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

