---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/fr/Get-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Get-ColorScriptConfiguration

## SYNOPSIS

Récupère les paramètres de configuration actuels du module ColorScripts-Enhanced.

## SYNTAX

```powershell
Get-ColorScriptConfiguration [<CommonParameters>]
```

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

### CommonParameters

Cette cmdlet prend en charge les paramètres communs : -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, et -WarningVariable. Pour plus d'informations, voir
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

## ADVANCED USAGE PATTERNS

### Analyse et audit de configuration

## Audit complet de configuration

```powershell
# Revue complète de la configuration
$config = Get-ColorScriptConfiguration

[PSCustomObject]@{
    CachePath = $config.Cache.Path
    CacheEnabled = $config.Cache.Enabled
    CacheSize = (Get-ChildItem $config.Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    StartupEnabled = $config.Startup.ProfileAutoShow
    DefaultScript = $config.DefaultScript
} | Format-List
```

## Comparaison avec les valeurs par défaut

```powershell
# Identifier les personnalisations par rapport aux valeurs par défaut
$current = Get-ColorScriptConfiguration | ConvertTo-Json

# Exporter pour comparaison
$current | Out-File "./current-config.json"

# Vérifier les personnalisations
if ($current -ne (Get-Content "./default-config.json")) {
    Write-Host "✓ Configuration personnalisée détectée"
}
```

### Configuration spécifique à l'environnement

## Détection d'environnement

```powershell
# Détecter l'environnement et rapporter la configuration appropriée
$config = Get-ColorScriptConfiguration

$environment = switch ($true) {
    ($env:CI) { "CI/CD" }
    ($env:SSH_CONNECTION) { "Session SSH" }
    ($env:WT_SESSION) { "Windows Terminal" }
    ($env:TERM_PROGRAM) { "$env:TERM_PROGRAM" }
    default { "Local" }
}

Write-Host "Environnement : $environment"
Write-Host "Cache : $($config.Cache.Path)"
Write-Host "Démarrage : $($config.Startup.ProfileAutoShow)"
```

## Gestion multi-environnements

```powershell
# Suivre la configuration dans plusieurs environnements
@(
    [PSCustomObject]@{ Environment = "Local"; Config = Get-ColorScriptConfiguration }
    [PSCustomObject]@{ Environment = "CI"; Config = Invoke-Command -ComputerName ci-server { Get-ColorScriptConfiguration } }
) | ForEach-Object {
    Write-Host "=== $($_.Environment) ==="
    $_.Config | Select-Object -ExpandProperty Cache | Format-Table
}
```

### Validation de configuration

## Vérification de santé

```powershell
# Valider l'intégrité de la configuration
$config = Get-ColorScriptConfiguration

$checks = @{
    CachePathExists = Test-Path $config.Cache.Path
    CachePathWritable = Test-Path $config.Cache.Path -PathType Container
    CacheFilesPresent = (Get-ChildItem $config.Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue).Count -gt 0
}

$checks | ConvertTo-Json | Write-Host
```

## Cohérence de configuration

```powershell
# Vérifier que les paramètres de configuration sont cohérents
$config = Get-ColorScriptConfiguration

$validSettings = @{
    CacheEnabled = $config.Cache.Enabled -is [bool]
    PathIsString = $config.Cache.Path -is [string]
    CachePathNotEmpty = -not [string]::IsNullOrEmpty($config.Cache.Path)
}

if ($validSettings.Values -notcontains $false) {
    Write-Host "✓ Configuration valide"
}
```

### Sauvegarde et récupération de configuration

## Sauvegarder la configuration actuelle

```powershell
# Créer une sauvegarde de configuration
$config = Get-ColorScriptConfiguration
$backup = @{
    Timestamp = Get-Date
    Configuration = $config
    ModuleVersion = (Get-Module ColorScripts-Enhanced | Select-Object -ExpandProperty Version)
}

$backup | ConvertTo-Json | Out-File "./config-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
```

## Migration de configuration

```powershell
# Exporter la configuration pour migration vers un nouveau système
$config = Get-ColorScriptConfiguration

$exportConfig = @{
    CachePath = $config.Cache.Path
    Startup = $config.Startup
    Customizations = @{
        # Ajouter des paramètres personnalisés
    }
}

$exportConfig | ConvertTo-Json | Out-File "./export-config.json" -Encoding UTF8
```

### Rapport de configuration

## Rapport de configuration (2)

```powershell
# Générer un rapport complet de configuration
$config = Get-ColorScriptConfiguration

$report = @"
# Rapport de configuration ColorScripts-Enhanced
Généré : $(Get-Date)

## Paramètres de cache
- Chemin : $($config.Cache.Path)
- Activé : $($config.Cache.Enabled)
- Taille : $([math]::Round((Get-ChildItem $($config.Cache.Path) -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB, 2)) MB
- Fichiers : $(Get-ChildItem $($config.Cache.Path) -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object | Select-Object -ExpandProperty Count)

## Paramètres de démarrage
- Affichage automatique du profil : $($config.Startup.ProfileAutoShow)
- Script par défaut : $($config.DefaultScript)

## Environnement
- Version du module : $(Get-Module ColorScripts-Enhanced | Select-Object -ExpandProperty Version)
- Version PowerShell : $($PSVersionTable.PSVersion)
- OS : $(if ($PSVersionTable.Platform) { $PSVersionTable.Platform } else { "Windows" })
"@

$report | Out-File "./config-report.md" -Encoding UTF8
```

### Surveillance et détection de dérive

## Détection de dérive de configuration

```powershell
# Surveiller les changements inattendus de configuration
$configFile = "$env:APPDATA\ColorScripts-Enhanced\config.json"
$current = Get-ColorScriptConfiguration
$lastKnown = Get-Content $configFile -ErrorAction SilentlyContinue | ConvertFrom-Json

if ($current.Cache.Path -ne $lastKnown.Cache.Path) {
    Write-Warning "Le chemin de cache a changé : $($lastKnown.Cache.Path) -> $($current.Cache.Path)"
}
```

## Audit de configuration programmé

```powershell
# Créer un journal d'audit périodique
$config = Get-ColorScriptConfiguration
$snapshot = @{
    Timestamp = Get-Date -Format 'o'
    CachePath = $config.Cache.Path
    CacheSize = (Get-ChildItem $config.Cache.Path -Filter "*.cache" -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    ScriptCount = (Get-ColorScriptList -AsObject).Count
}

$snapshot | ConvertTo-Json | Out-File "./audit-log-$(Get-Date -Format 'yyyyMMdd').json" -Append -Encoding UTF8
```

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

- [Set-ColorScriptConfiguration](Set-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
