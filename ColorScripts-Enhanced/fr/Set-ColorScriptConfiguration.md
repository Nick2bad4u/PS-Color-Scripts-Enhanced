---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/fr/Set-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Persiste les modifications apportées au cache et à la configuration de démarrage de ColorScripts-Enhanced.

## SYNTAX

### Default (Default)

```text
Set-ColorScriptConfiguration [-AutoShowOnImport <Boolean>] [-ProfileAutoShow <Boolean>]
 [-CachePath <String>] [-DefaultScript <String>] [-PassThru] [<CommonParameters>]
```

### \_\_AllParameterSets

```text
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

`Set-ColorScriptConfiguration` fournit un moyen persistant de personnaliser le comportement et l'emplacement de stockage du module ColorScripts-Enhanced. Cette cmdlet met à jour le fichier de configuration du module, vous permettant de contrôler divers aspects du rendu et du stockage des scripts.

## Capacités clés 

- **Relocalisation du cache** : Déplacez le cache des couleurscripts vers un répertoire personnalisé, utile pour les partages réseau, les lecteurs plus rapides ou les emplacements de stockage centralisés.
- **Comportement d'auto-import** : Contrôlez si un couleurscript s'affiche automatiquement lorsque le module est importé pour la première fois dans votre session PowerShell.
- **Intégration de profil** : Configurez les paramètres par défaut pour `Add-ColorScriptProfile` afin de rationaliser la configuration du profil.
- **Sélection du script par défaut** : Définissez un couleurscript préféré qui sera utilisé lorsqu'aucun script spécifique n'est demandé.

Tout chemin de répertoire fourni pour `-CachePath` est automatiquement créé s'il n'existe pas déjà. La cmdlet prend en charge l'expansion des variables d'environnement, l'expansion du répertoire d'accueil tilde (`~`), et les chemins absolus et relatifs. Fournir une chaîne vide (`''`) à `-CachePath` ou `-DefaultScript` efface la valeur stockée et revient aux valeurs par défaut du module.

Les modifications apportées avec cette cmdlet prennent effet immédiatement pour les nouvelles opérations, mais peuvent ne pas affecter les données de cache déjà chargées jusqu'à ce que le module soit réimporté ou PowerShell redémarré.

Lorsque `-PassThru` est spécifié, la cmdlet retourne l'objet de configuration mis à jour, facilitant la vérification des modifications ou l'enchaînement d'opérations supplémentaires.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

Déplace le cache vers `D:/Temp/ColorScriptsCache`, active l'affichage automatique lors de l'import du module, désactive l'auto-affichage du profil, et définit `bars` comme script par défaut.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

Efface le script par défaut et retourne l'objet de configuration résultant, vous permettant de vérifier que le paramètre a été supprimé.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

Relocalise le cache vers le répertoire TEMP de Windows et affiche la configuration mise à jour complète en format liste. Utile pour les scénarios de test temporaires.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

Désactive le rendu automatique des couleurscripts lors du chargement du module. Utile si vous préférez un contrôle manuel sur le moment où les scripts sont affichés.

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

Définit un chemin de cache de style Linux/macOS en utilisant l'expansion tilde et configure 'crunch' comme script par défaut pour toutes les opérations.

## PARAMETERS

### -AutoShowOnImport

Active ou désactive le rendu automatique d'un couleurscript lorsque le module est importé. Lorsqu'il est activé (`$true`), un couleurscript s'affiche immédiatement lors de l'import du module, fournissant un retour visuel instantané. Lorsqu'il est désactivé (`$false`), les scripts ne s'affichent que lorsqu'ils sont explicitement invoqués. Si non spécifié, le paramètre existant reste inchangé.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: (no change)
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
HelpMessage: ""
```

### -CachePath

Spécifie le répertoire où les fichiers et métadonnées des couleurscripts sont stockés. Prend en charge les chemins absolus, les chemins relatifs (résolus à partir de l'emplacement actuel), les variables d'environnement (par exemple, `$env:USERPROFILE`), et l'expansion tilde (`~`) pour le répertoire d'accueil.

Si le répertoire spécifié n'existe pas, il sera créé automatiquement avec les permissions appropriées. Fournissez une chaîne vide (`''`) pour effacer le chemin personnalisé et revenir à l'emplacement par défaut spécifique à la plateforme. Lorsqu'il n'est pas spécifié, le paramètre de chemin de cache existant est préservé.

**Note** : Changer le chemin de cache ne migre pas automatiquement les fichiers mis en cache existants. Vous devrez peut-être copier manuellement les fichiers ou les laisser se régénérer.

```yaml
Type: System.String
DefaultValue: (no change)
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

### -DefaultScript

Définit ou efface le nom du couleurscript par défaut utilisé par les assistants de profil, les fonctionnalités d'auto-affichage, et lorsqu'aucun script n'est explicitement spécifié dans les commandes. Cela doit correspondre au nom de base d'un fichier script sans extension (par exemple, `'bars'`, pas `'bars.ps1'`).

Fournissez une chaîne vide (`''`) pour supprimer le défaut stocké, revenant au comportement par défaut du module (généralement une sélection aléatoire). Lorsque ce paramètre est omis, le paramètre de script par défaut actuel reste inchangé.

Le script spécifié doit exister dans le répertoire des scripts du module pour être utilisé avec succès.

```yaml
Type: System.String
DefaultValue: (no change)
SupportsWildcards: false
Aliases: []
ParameterSets:
 - Name: (All)
   Position: 3
   IsRequired: false
   ValueFromPipeline: false
   ValueFromPipelineByPropertyName: false
   ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ""
```

### -PassThru

Retourne l'objet de configuration mis à jour après avoir effectué les modifications. Sans ce commutateur, la cmdlet fonctionne silencieusement (aucune sortie). L'objet retourné a la même structure que `Get-ColorScriptConfiguration` et peut être inspecté, stocké ou redirigé vers d'autres cmdlets pour un traitement supplémentaire.

Utile pour la vérification, la journalisation ou l'enchaînement de commandes de configuration.

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

### -ProfileAutoShow

Contrôle si les extraits de profil générés par `Add-ColorScriptProfile` incluent une invocation automatique de `Show-ColorScript`. Lorsque `$true`, le code de profil affichera un couleurscript à chaque démarrage du shell. Lorsque `$false`, le profil chargera le module mais n'affichera pas automatiquement les scripts.

Ce paramètre n'affecte que le code de profil nouvellement généré ; les modifications de profil existantes ne sont pas automatiquement mises à jour. Omettre ce paramètre laisse le paramètre actuel inchangé.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: (no change)
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

### CommonParameters

Cette cmdlet prend en charge les paramètres communs : -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, et -WarningVariable. Pour plus d'informations, voir
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Cette cmdlet n'accepte pas d'entrée pipeline.

## OUTPUTS

### None (2)

Par défaut, cette cmdlet ne produit aucune sortie.

### System.Collections.Hashtable

Lorsque `-PassThru` est spécifié, retourne une hashtable contenant la configuration complète mise à jour. La structure correspond à la sortie de `Get-ColorScriptConfiguration`, avec des clés telles que `CachePath`, `AutoShowOnImport`, `ProfileAutoShow`, et `DefaultScript`.

## NOTES

## Emplacement du fichier de configuration 

Les modifications de configuration sont persistées dans un fichier JSON ou XML stocké dans un répertoire de données d'application spécifique à la plateforme. Utilisez `Get-ColorScriptConfiguration` pour afficher le chemin racine de configuration actuel. La variable d'environnement `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` peut remplacer l'emplacement par défaut du répertoire de configuration si elle est définie avant l'import du module.

## Valeurs par défaut de la plateforme 

- **Windows** : `$env:LOCALAPPDATA\ColorScripts-Enhanced`
- **Linux/macOS** : `~/.config/ColorScripts-Enhanced` ou `$XDG_CONFIG_HOME/ColorScripts-Enhanced`

## Meilleures pratiques 

- Testez les modifications de chemin de cache dans un environnement non-production d'abord, surtout lors de l'utilisation d'emplacements réseau.
- Utilisez `-PassThru` lors du scripting pour valider les mises à jour de configuration par programme.
- Envisagez de définir `AutoShowOnImport:$false` dans les scripts automatisés ou les pipelines CI/CD pour éviter une sortie visuelle inattendue.
- Documentez les configurations personnalisées dans les environnements d'équipe pour assurer un comportement cohérent entre les utilisateurs.

## Permissions 

Assurez-vous d'avoir des permissions d'écriture sur le répertoire de configuration. Sur les systèmes partagés, les modifications de configuration n'affectent que le profil de l'utilisateur actuel, sauf si elles sont remplacées par des variables d'environnement pointant vers des emplacements partagés.

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Show-ColorScript](Show-ColorScript.md)
