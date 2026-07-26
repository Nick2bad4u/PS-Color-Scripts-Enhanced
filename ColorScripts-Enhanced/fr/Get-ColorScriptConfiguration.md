---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Get-ColorScriptConfiguration
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Récupère les paramètres de configuration actuels du module ColorScripts-Enhanced.

## SYNTAX

### __AllParameterSets

```
Get-ColorScriptConfiguration [-h]
```

## ALIASES

Cette commande ne possède aucun alias.

## DESCRIPTION

`Get-ColorScriptConfiguration` renvoie une copie de la configuration effective du module. Le schéma actuel contient :

- **Paramètres du cache** : Le remplacement configuré et le répertoire de cache effectif résolu
- **Comportement de démarrage** : `AutoShowOnImport`, `ProfileAutoShow` et `DefaultScript`

La configuration est assemblée à partir de plusieurs sources par ordre de priorité :

1. Paramètres par défaut du module intégré (priorité la plus basse)
2. Remplacements d'utilisateur persistants à partir du fichier de configuration
3. `COLOR_SCRIPTS_ENHANCED_CACHE_PATH` pour le chemin de cache effectif renvoyé

Le fichier de configuration se trouve généralement sous `%APPDATA%\ColorScripts-Enhanced\config.json` sous Windows ou `~/.config/ColorScripts-Enhanced/config.json` sur les systèmes de type Unix.

La table de hachage renvoyée est un instantané de l'état de configuration actuel et peut être inspectée, clonée ou sérialisée en toute sécurité sans affecter la configuration active.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Affiche la configuration actuelle à l'aide de la vue tableau par défaut, affichant tous les paramètres de cache et de démarrage.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Sérialise la configuration au format JSON pour la journalisation, le débogage ou l'exportation vers d'autres outils.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.EffectivePath
```

Récupère le répertoire de cache résolu. `Cache.Path` reste le remplacement facultatif configuré par l'utilisateur ;
`Cache.EffectivePath` affiche le répertoire que le module utilise réellement après les valeurs par défaut de la plateforme et
les remplacements d’environnement sont appliqués.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.AutoShowOnImport) {
    Write-Host "Les scripts de démarrage sont activés"
}
```

Vérifie si les scripts de démarrage sont activés dans la configuration actuelle.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Affiche toutes les propriétés de configuration dans un format de liste détaillée pour une inspection complète.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Chemin du cache : $($config.Cache.Path)"
Write-Host "Affichage automatique du profil : $($config.Startup.ProfileAutoShow)"
Write-Host "Script par défaut : $($config.Startup.DefaultScript)"
```

Extrait et affiche des propriétés de configuration spécifiques à des fins d'audit ou de script.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Chemin de cache personnalisé configuré : $($config.Cache.Path)"
} else {
    Write-Host "Le chemin de cache par défaut est utilisé"
}

Write-Host "Chemin de cache effectif : $($config.Cache.EffectivePath)"
```

Détermine si un chemin de cache personnalisé est configuré ou non en utilisant les valeurs par défaut du module.

### EXAMPLE 8

```powershell
$config = Get-ColorScriptConfiguration
$config | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Sauvegarde la configuration actuelle dans un fichier JSON à des fins d'archivage ou de récupération après sinistre.

### EXAMPLE 9

```powershell
# Comparez la configuration actuelle avec les valeurs par défaut
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Examinez la sortie -WhatIf pour voir ce qui changerait
```

Compare la configuration actuelle avec les valeurs par défaut du module pour identifier les paramètres personnalisés.

### EXAMPLE 10

```powershell
# Surveiller les changements de configuration au fil des sessions
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Crée des instantanés horodatés de la configuration pour suivre les modifications au fil du temps.

## PARAMETERS

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

### CommonParameters

Cette applet de commande prend en charge les paramètres communs :
Pour plus d'informations, consultez
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Cette applet de commande n'accepte pas les entrées de pipeline.

## OUTPUTS

### System.Collections.Hashtable

Renvoie une table de hachage imbriquée contenant la structure suivante :

- **Cache** (Hashtable) : paramètres liés au cache
  - **Path** (String) : remplacement facultatif du chemin du cache persistant
  - **EffectivePath** (String) : Répertoire de cache résolu actuellement utilisé par le module
- **Startup** (Hashtable) : paramètres de comportement de démarrage
  - **AutoShowOnImport** (booléen) : indique si l'importation invoque le comportement d'affichage au démarrage
  - **ProfileAutoShow** (booléen) : choix d'affichage automatique par défaut pour les blocs de profil gérés
- **DefaultScript** (String) : Démarrage nommé facultatif script de couleurs

## NOTES

**Initialisation du module** : La configuration est initialisée automatiquement lors du chargement du module ColorScripts-Enhanced. Cette applet de commande récupère l’état actuel de la configuration en mémoire.

**Aucune modification** : l'appel de cette applet de commande est en lecture seule et ne modifie aucun paramètre persistant ni la configuration active.

**Thread Safety** : la table de hachage renvoyée est une copie de la configuration, ce qui la rend sûre pour les accès et les modifications simultanés sans affecter l'état interne du module.

**Performance** : la récupération de configuration est légère et adaptée aux appels fréquents, car elle renvoie la configuration en mémoire mise en cache plutôt que de la lire à partir du disque.

**Format de fichier de configuration** : la configuration persistante utilise le format JSON avec l'encodage UTF-8. L'édition manuelle est prise en charge mais n'est pas recommandée ; utilisez plutôt `Set-ColorScriptConfiguration`.

### Bonnes pratiques

- Interroger la configuration une fois et réutiliser le résultat
- Valider la configuration avant d'utiliser les valeurs
- Surveiller la configuration pour la dérive au fil du temps
- Conservez les sauvegardes uniquement là où elles ne peuvent pas exposer des chemins spécifiques à la machine ou des données privées
- Documenter toutes les personnalisations apportées à la configuration
- Testez d'abord les modifications de configuration en dehors de la production
- Utiliser les journaux d'audit de configuration pour la conformité

## RELATED LINKS

- [Version en ligne](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)

