---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Restaurer la configuration ColorScripts-Enhanced à ses valeurs par défaut.

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

`Reset-ColorScriptConfiguration` efface toutes les substitutions de configuration persistées et restaure le module à ses paramètres d'usine par défaut. Lors de l'exécution, cette cmdlet :

- Supprime tous les paramètres de configuration personnalisés du fichier de configuration
- Réinitialise le chemin du cache à l'emplacement par défaut spécifique à la plateforme
- Restaure tous les indicateurs de démarrage (RunOnStartup, RandomOnStartup, etc.) à leurs valeurs originales
- Préserve la structure du fichier de configuration tout en effaçant les personnalisations utilisateur

Cette cmdlet prend en charge les paramètres `-WhatIf` et `-Confirm` car elle effectue une opération destructive en écrasant le fichier de configuration. L'opération de réinitialisation ne peut pas être annulée automatiquement, donc les utilisateurs devraient envisager de sauvegarder leur configuration actuelle en utilisant `Get-ColorScriptConfiguration` avant de procéder.

Utilisez le paramètre `-PassThru` pour inspecter immédiatement les nouveaux paramètres par défaut restaurés après la fin de la réinitialisation.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Réinitialise la configuration sans demander de confirmation. Ceci est utile dans les scripts automatisés ou lorsque vous êtes certain de réinitialiser aux valeurs par défaut.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

Réinitialise la configuration et retourne la table de hachage résultante pour inspection, permettant de vérifier les valeurs par défaut.

### EXAMPLE 3

```powershell
# Sauvegarder la configuration actuelle avant de réinitialiser
$backup = Get-ColorScriptConfiguration
Reset-ColorScriptConfiguration -WhatIf
```

Utilise `-WhatIf` pour prévisualiser l'opération de réinitialisation sans l'exécuter réellement, après avoir sauvegardé la configuration actuelle.

### EXAMPLE 4

```powershell
Reset-ColorScriptConfiguration -Verbose
```

Réinitialise la configuration avec une sortie verbeuse pour voir des informations détaillées sur l'opération.

### EXAMPLE 5

```powershell
# Réinitialiser la configuration et effacer le cache pour une réinitialisation complète d'usine
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "Module réinitialisé aux paramètres d'usine par défaut !"
```

Effectue une réinitialisation complète d'usine incluant la configuration, le cache et la reconstruction du cache.

### EXAMPLE 6

```powershell
# Vérifier que la réinitialisation a réussi
$config = Reset-ColorScriptConfiguration -PassThru
if ($config.Cache.Path -match "AppData|\.config") {
    Write-Host "Configuration réinitialisée avec succès aux paramètres par défaut de la plateforme"
} else {
    Write-Host "Configuration réinitialisée mais utilisant un chemin personnalisé : $($config.Cache.Path)"
}
```

Réinitialise et vérifie que la configuration a été restaurée aux valeurs par défaut en vérifiant le chemin du cache.

## PARAMETERS

### -Confirm

Vous invite à confirmer avant d'exécuter la cmdlet.

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

### -PassThru

Retourne l'objet de configuration mis à jour après la fin de la réinitialisation.

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

### -WhatIf

Montre ce qui se passerait si la cmdlet s'exécute sans exécuter réellement l'opération de réinitialisation.

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

Cette cmdlet n'accepte pas d'entrée de pipeline.

## OUTPUTS

### System.Collections.Hashtable

Retourné lorsque `-PassThru` est spécifié.

## NOTES

Le fichier de configuration est stocké sous le répertoire résolu par `Get-ColorScriptConfiguration`. Par défaut, cet emplacement est spécifique à la plateforme :

- **Windows** : `$env:LOCALAPPDATA\ColorScripts-Enhanced`
- **Linux/macOS** : `$HOME/.config/ColorScripts-Enhanced`

La variable d'environnement `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` peut remplacer l'emplacement par défaut si elle est définie avant l'importation du module.

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)

