---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
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

This command has no aliases.

## DESCRIPTION

`Get-ColorScriptConfiguration` récupère la configuration effective du module, qui contrôle divers aspects du comportement de ColorScripts-Enhanced. Cela inclut :

- **Paramètres de cache** : Emplacement où les métadonnées et les index des scripts sont stockés pour l'optimisation des performances
- **Comportement de démarrage** : Indicateurs qui contrôlent si les scripts s'exécutent automatiquement au démarrage des sessions PowerShell
- **Configuration des chemins** : Répertoires de scripts personnalisés et chemins de recherche
- **Préférences d'affichage** : Options de formatage et de sortie par défaut

La configuration est assemblée à partir de plusieurs sources par ordre de priorité :

1. Valeurs par défaut intégrées du module (priorité la plus basse)
2. Substitutions utilisateur persistées depuis le fichier de configuration
3. Modifications spécifiques à la session (priorité la plus haute)

Le fichier de configuration est généralement situé à `%APPDATA%\ColorScripts-Enhanced\config.json` sur Windows ou `~/.config/ColorScripts-Enhanced/config.json` sur les systèmes de type Unix.

La hashtable retournée est un instantané de l'état actuel de la configuration et peut être inspectée, clonée ou sérialisée en toute sécurité sans affecter la configuration active.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-ColorScriptConfiguration
```

Affiche la configuration actuelle en utilisant la vue tableau par défaut, montrant tous les paramètres de cache et de démarrage.

### EXAMPLE 2

```powershell
Get-ColorScriptConfiguration | ConvertTo-Json -Depth 4
```

Sérialise la configuration au format JSON pour la journalisation, le débogage ou l'exportation vers d'autres outils.

### EXAMPLE 3

```powershell
$config = Get-ColorScriptConfiguration
$config.Cache.Location
```

Récupère la configuration et accède directement au chemin d'emplacement du cache depuis la hashtable.

### EXAMPLE 4

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Startup.Enabled) {
    Write-Host "Startup scripts are enabled"
}
```

Vérifie si les scripts de démarrage sont activés dans la configuration actuelle.

### EXAMPLE 5

```powershell
Get-ColorScriptConfiguration | Format-List *
```

Affiche toutes les propriétés de configuration dans un format de liste détaillé pour une inspection complète.

### EXAMPLE 6

```powershell
$config = Get-ColorScriptConfiguration
Write-Host "Cache Path: $($config.Cache.Path)"
Write-Host "Profile Auto-Show: $($config.Startup.ProfileAutoShow)"
Write-Host "Default Script: $($config.Startup.DefaultScript)"
```

Extrait et affiche des propriétés de configuration spécifiques pour l'audit ou les scripts.

### EXAMPLE 7

```powershell
$config = Get-ColorScriptConfiguration
if ($config.Cache.Path) {
    Write-Host "Custom cache path configured: $($config.Cache.Path)"
} else {
    Write-Host "Using default cache path"
}
```

Détermine si un chemin de cache personnalisé est configuré par rapport aux valeurs par défaut du module.

### EXAMPLE 8

```powershell
Export-ColorScriptMetadata | ConvertTo-Json -Depth 5 |
    Out-File -FilePath "./backup-config.json" -Encoding UTF8
```

Sauvegarde la configuration actuelle dans un fichier JSON pour l'archivage ou la récupération après sinistre.

### EXAMPLE 9

```powershell
# Compare current config with defaults
$current = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
# Review the -WhatIf output to see what would change
```

Compare la configuration actuelle avec les valeurs par défaut du module pour identifier les paramètres personnalisés.

### EXAMPLE 10

```powershell
# Monitor configuration changes across sessions
Get-ColorScriptConfiguration |
    Select-Object Cache, Startup |
    Format-List |
    Out-File "./config-snapshot.txt" -Append
```

Crée des instantanés horodatés de la configuration pour suivre les changements au fil du temps.

## PARAMETERS

### -h

Affiche l'aide détaillée de cette commande sans effectuer l'opération.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Cette cmdlet n'accepte pas d'entrée pipeline.

## OUTPUTS

### System.Collections.Hashtable

Retourne une hashtable imbriquée contenant la structure suivante :

- **Cache** (Hashtable) : Paramètres liés au cache
  - **Location** (String) : Chemin vers le répertoire de cache
  - **Enabled** (Boolean) : Si le cache est actif
- **Startup** (Hashtable) : Paramètres de comportement de démarrage
  - **Enabled** (Boolean) : Si les scripts s'exécutent au démarrage de la session
  - **ScriptName** (String) : Nom du script de démarrage par défaut
- **Paths** (Array) : Chemins de recherche de scripts supplémentaires
- **Display** (Hashtable) : Préférences de formatage de sortie

## NOTES

**Initialisation du module** : La configuration est initialisée automatiquement lorsque le module ColorScripts-Enhanced se charge. Cette cmdlet récupère l'état de configuration en mémoire actuel.

**Aucune modification** : L'appel de cette cmdlet est en lecture seule et ne modifie aucun paramètre persistant ou la configuration active.

**Sécurité des threads** : La hashtable retournée est une copie de la configuration, la rendant sûre pour l'accès concurrent et la modification sans affecter l'état interne du module.

**Performance** : La récupération de configuration est légère et adaptée aux appels fréquents, car elle retourne la configuration en mémoire mise en cache plutôt que de lire sur le disque.

**Format du fichier de configuration** : La configuration persistée utilise le format JSON avec encodage UTF-8. L'édition manuelle est prise en charge mais non recommandée ; utilisez `Set-ColorScriptConfiguration` à la place.

### Meilleures pratiques

- Interroger la configuration une fois et réutiliser le résultat
- Valider la configuration avant d'utiliser les valeurs
- Surveiller la configuration pour la dérive au fil du temps
- Garder les sauvegardes de configuration dans le contrôle de version
- Documenter toute personnalisation apportée à la configuration
- Tester les changements de configuration en non-production d'abord
- Utiliser les journaux d'audit de configuration pour la conformité

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Get-ColorScriptConfiguration)
