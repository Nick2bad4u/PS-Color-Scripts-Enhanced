---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Reset-ColorScriptConfiguration
---

# Reset-ColorScriptConfiguration

## SYNOPSIS

Restaurez la configuration ColorScripts-Enhanced à ses valeurs par défaut.

## SYNTAX

### __AllParameterSets

```
Reset-ColorScriptConfiguration [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Cette commande ne possède aucun alias.

## DESCRIPTION

`Reset-ColorScriptConfiguration` remplace la configuration persistante par les valeurs par défaut intégrées et réinitialise l'état du cache en mémoire du module. Une fois exécutée, cette applet de commande :

- Efface le remplacement du chemin de cache configuré afin que la valeur par défaut de la plate-forme effective soit utilisée
- Restaure `AutoShowOnImport`, `ProfileAutoShow` et `DefaultScript`
- Écrit la configuration par défaut sur `config.json`
- Efface le cache en mémoire/l'état de configuration afin que les opérations ultérieures utilisent les valeurs de réinitialisation

Cette applet de commande prend en charge les paramètres `-WhatIf` et `-Confirm` car elle effectue une opération destructrice en écrasant le fichier de configuration. L'opération de réinitialisation ne peut pas être annulée automatiquement, les utilisateurs doivent donc envisager de sauvegarder leur configuration actuelle à l'aide de `Get-ColorScriptConfiguration` avant de continuer.

Utilisez le paramètre `-PassThru` pour inspecter immédiatement les paramètres par défaut nouvellement restaurés une fois la réinitialisation terminée.

## EXAMPLES

### EXAMPLE 1

```powershell
Reset-ColorScriptConfiguration -Confirm:$false
```

Réinitialise la configuration sans demander de confirmation. Ceci est utile dans les scripts automatisés ou lorsque vous êtes certain de réinitialiser les valeurs par défaut.

### EXAMPLE 2

```powershell
Reset-ColorScriptConfiguration -PassThru
```

Réinitialise la configuration et renvoie la table de hachage résultante pour inspection, vous permettant de vérifier les valeurs par défaut.

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

Réinitialise la configuration avec une sortie détaillée pour afficher des informations détaillées sur l'opération.

### EXAMPLE 5

```powershell
# Réinitialiser la configuration et vider le cache pour une réinitialisation complète des paramètres d'usine
Reset-ColorScriptConfiguration -Confirm:$false
Clear-ColorScriptCache -All -Confirm:$false
New-ColorScriptCache
Write-Host "Le module a été réinitialisé aux valeurs d'usine !"
```

Effectue une réinitialisation complète des paramètres d'usine, y compris la configuration, le cache et la reconstruction du cache.

### EXAMPLE 6

```powershell
# Vérifiez que la réinitialisation a réussi
$config = Reset-ColorScriptConfiguration -PassThru
if ($null -eq $config.Cache.Path -and $config.Cache.EffectivePath) {
    Write-Host "La configuration a été réinitialisée à la valeur par défaut de la plateforme"
} else {
    Write-Host "Configuration réinitialisée, mais un chemin personnalisé est utilisé : $($config.Cache.Path)"
}
```

Réinitialise et vérifie que le remplacement du cache persistant est vide et qu'un chemin de plateforme efficace est disponible.

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

Renvoyez l’objet de configuration mis à jour une fois la réinitialisation terminée.

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

Montre ce qui se passerait si l’applet de commande s’exécutait sans réellement exécuter l’opération de réinitialisation.

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

### System.Collections.Hashtable

Renvoyé lorsque `-PassThru` est spécifié.

## NOTES

Le fichier de configuration est stocké dans le répertoire résolu par `Get-ColorScriptConfiguration`. Par défaut, cet emplacement est spécifique à la plateforme :

- **Windows** : `$env:APPDATA\ColorScripts-Enhanced`
- **Linux/macOS** : `$HOME/.config/ColorScripts-Enhanced`

La variable d'environnement `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` peut remplacer l'emplacement par défaut si elle est définie avant l'importation du module.

## RELATED LINKS

- [Version en ligne](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Reset-ColorScriptConfiguration)

