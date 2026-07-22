---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: fr
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

Créez un nouveau fichier script de couleurs et émettez éventuellement des conseils sur les métadonnées.

## SYNTAX

### Scaffold

```
New-ColorScript -Name <string> -OutputPath <string> [-h] [-Force] [-GenerateMetadataSnippet]
 [-Category <string[]>] [-Tag <string[]>] [-OpenInEditor] [-WhatIf] [-Confirm]
```

### Help

```
New-ColorScript [-h] [-Name <string>] [-WhatIf] [-Confirm]
```

## ALIASES

Cette commande ne possède aucun alias.

## DESCRIPTION

L'applet de commande `New-ColorScript` crée un échafaudage script de couleurs minimal contenant un tableau string et une boucle qui écrit chaque ligne. Le fichier est codé sous la forme UTF-8 sans marque d'ordre d'octet (BOM). Des conseils facultatifs sur les métadonnées peuvent être inclus sous forme de commentaire dans le fichier généré et renvoyés dans l’objet de résultat.

Les `-Name` et `-OutputPath` sont obligatoires pour les échafaudages. `-OutputPath` identifie un répertoire ; la commande crée le répertoire en cas de besoin et y écrit `<Name>.ps1`.

Les noms de script doivent suivre les conventions de dénomination PowerShell : ils doivent commencer par un caractère alphanumérique et peuvent inclure des traits de soulignement ou des traits d'union. L'extension `.ps1` est automatiquement ajoutée si elle n'est pas fournie. Les fichiers existants sont protégés contre les écrasements accidentels, sauf si le commutateur `-Force` est explicitement spécifié.

Lorsqu'elle est combinée avec `-GenerateMetadataSnippet`, l'applet de commande renvoie des instructions décrivant l'entrée à ajouter à `ScriptMetadata.psd1`. Les valeurs de catégorie et de balise fournies sont également renvoyées sous forme de tableaux sur l'objet de résultat.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -OutputPath ./ColorScripts-Enhanced/Scripts -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

Crée `my-spectrum.ps1` dans le répertoire demandé et renvoie un objet contenant le chemin du fichier et des instructions sur les métadonnées.

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

Génère l'échafaudage sous un répertoire personnalisé (`~/Dev/colorscripts`), en créant le répertoire s'il n'existe pas. Si un fichier nommé `holiday-banner.ps1` existe déjà à cet emplacement, il sera écrasé en raison du commutateur `-Force`.

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -OutputPath ./ColorScripts-Enhanced/Scripts -Category 'Artistic' -Tag '80s','Neon' -GenerateMetadataSnippet
$result.MetadataGuidance | Set-Clipboard
```

Crée un nouveau script de couleurs et copie les instructions de métadonnées dans le presse-papiers, ce qui facilite leur collage dans `ScriptMetadata.psd1`.

### EXAMPLE 4

```powershell
New-ColorScript -Name 'test-pattern' -OutputPath '.\temp' -WhatIf
```

Montre ce qui se passerait lors de la création d'un script de modèle de test dans le répertoire `.\temp` sans créer réellement le fichier. Utile pour valider les chemins et les noms avant l'exécution.

### EXAMPLE 5

```powershell
# Créez plusieurs scripts de couleurs pour un projet
$scriptNames = @("company-logo", "team-banner", "status-display")
foreach ($name in $scriptNames) {
    New-ColorScript -Name $name -Category "Corporate" -Tag "Custom" -OutputPath ".\src" | Out-Null
}
Write-Host "$($scriptNames.Count) modèles de scripts de couleurs créés"
```

Crée plusieurs modèles script de couleurs par lots pour un projet.

### EXAMPLE 6

```powershell
# Créer et ouvrir immédiatement dans l'éditeur
New-ColorScript -Name "my-art" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -GenerateMetadataSnippet -OpenInEditor
```

Crée un script de couleurs et demande au gestionnaire enregistré de la plateforme de l'ouvrir.

### EXAMPLE 7

```powershell
# Créez avec une automatisation complète du flux de travail
$newScript = New-ColorScript -Name "interactive-demo" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Custom" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "Créé : $($newScript.Name)"
Write-Host "Chemin : $($newScript.Path)"
Write-Host "Les conseils sur les métadonnées sont disponibles dans le presse-papiers"
$newScript.MetadataGuidance | Set-Clipboard
```

Crée un script de couleurs avec des instructions de métadonnées automatiquement copiées dans le presse-papiers.

### EXAMPLE 8

```powershell
# Vérifier les conventions de nom de script
$validName = "123-start"
$invalidNames = @("-invalid", "_underscore-only", "contains space")
foreach ($name in $invalidNames) {
    try {
        New-ColorScript -Name $name -OutputPath ./temp -WhatIf -ErrorAction Stop
    } catch {
        Write-Warning "Nom non valide '$name' : $_"
    }
}
```

Montre la validation de la convention de dénomination pour scripts de couleurs.

### EXAMPLE 9

```powershell
# Créer dans un emplacement portable pour la distribution
$portableDir = Join-Path $PSScriptRoot "colorscripts"
$scaffold = New-ColorScript -Name "portable-art" -OutputPath $portableDir -GenerateMetadataSnippet
Write-Host "Script de couleurs portable créé à l'emplacement : $($scaffold.Path)"
```

Crée scripts de couleurs dans un emplacement portable par rapport au script actuel.

### EXAMPLE 10

```powershell
# Créer avec validation de catégorie et de balise
$categories = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Category -Unique
if ("Retro" -in $categories) {
    New-ColorScript -Name "retro-party" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -Tag "Fun","Social"
} else {
    Write-Warning "La catégorie Retro est introuvable"
}
```

Valide qu'une catégorie existe avant de créer un nouveau script de couleurs.

## PARAMETERS

### -Category

Spécifie une ou plusieurs catégories renvoyées avec l’échafaudage et incluses dans les instructions de métadonnées. Les valeurs doivent s'aligner sur les catégories déjà utilisées dans `ScriptMetadata.psd1`.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

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

### -Force

Remplace le fichier de destination s'il existe déjà. Sans ce commutateur, l'applet de commande se terminera par une erreur si un fichier portant le même nom est trouvé à l'emplacement cible. À utiliser avec prudence pour éviter la perte de données.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Overwrite
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GenerateMetadataSnippet

Inclut un extrait de conseils dans la sortie qui montre comment enregistrer le nouveau script dans `ScriptMetadata.psd1`. L'extrait utilise les valeurs des paramètres `-Category` et `-Tag` si elles sont fournies. Ceci est particulièrement utile pour maintenir des métadonnées cohérentes sur tous les scripts de couleurs du module.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
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

### -Name

Spécifie le nom du nouveau script de couleurs. Le nom doit commencer par un caractère alphanumérique et peut inclure des traits de soulignement ou des traits d'union. L'extension `.ps1` est ajoutée automatiquement si elle n'est pas incluse. Ce nom sera utilisé comme nom de fichier et doit décrire le contenu ou le thème du script.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Help
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OpenInEditor

Ouvre le script de couleurs généré avec la commande configurée par l'environnement lorsque la création réussit.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputPath

Spécifie le répertoire cible obligatoire. La commande crée <Name>.ps1 dans ce répertoire.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Destination
- Path
ParameterSets:
- Name: Scaffold
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Tag

Spécifie une ou plusieurs balises de métadonnées pour le script de couleurs. Les Tags fournissent une classification supplémentaire au-delà de la catégorie principale et sont utiles pour le filtrage et la recherche. Les balises courantes incluent des descripteurs de thème comme 'Minimal', 'Colorful', 'Animated', des références technologiques comme 'Matrix', 'ASCII' ou des marqueurs contextuels comme 'Holiday', 'Season'. Plusieurs balises peuvent être spécifiées sous forme de tableau séparé par des virgules.

```yaml
Type: System.String[]
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Scaffold
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

Montre ce qui se passerait si l’applet de commande s’exécutait sans réellement effectuer aucune action. Affiche le chemin du fichier qui serait créé et les contrôles de validation qui seraient effectués. L'applet de commande ne crée aucun fichier ou répertoire lorsque ce commutateur est spécifié.

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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Pour plus d'informations, consultez
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Vous ne pouvez pas rediriger des objets vers cette applet de commande.

## OUTPUTS

### System.Management.Automation.PSCustomObject

L'applet de commande renvoie un objet personnalisé avec les propriétés suivantes :

- **Name** : Le nom script de couleurs sans l'extension `.ps1`
- **Path** : Le chemin complet du fichier généré
- **Categories** : le tableau de valeurs de catégorie spécifié (le cas échéant)
- **Tags** : le tableau de valeurs de balises spécifiées (le cas échéant)
- **MetadataGuidance** : le texte de l'extrait de métadonnées (uniquement lorsque -GenerateMetadataSnippet est utilisé)

## NOTES

**Encodage** : l'échafaudage est écrit avec l'encodage UTF-8 sans marque d'ordre d'octet (BOM), garantissant la compatibilité entre différentes plates-formes et éditeurs.

**Structure du modèle** : le modèle généré comprend :

- Un commentaire d'échafaudage
- Un espace réservé au tableau string pour l'art
- Une boucle qui écrit chaque ligne avec `Write-Host`

**Intégration des métadonnées** : bien que l'applet de commande puisse générer des instructions sur les métadonnées, vous devez ajouter manuellement l'extrait de code à `ScriptMetadata.psd1` pour intégrer pleinement le script dans le système de découverte et de catégorisation du module.

**Flux de travail de développement** :

1. Utilisez `New-ColorScript` pour créer l'échafaudage
2. Modifiez le fichier .ps1 généré pour ajouter votre art ANSI
3. Si des instructions de métadonnées ont été générées, copiez-les dans `ScriptMetadata.psd1`.
4. Testez votre script avec `Show-ColorScript -Name <your-script-name>`

**Meilleures pratiques** :

- Choisissez des noms descriptifs avec trait d'union qui indiquent clairement le thème du script
- Utilisez des valeurs de catégorie cohérentes qui correspondent aux scripts existants
- Appliquer plusieurs balises pour améliorer la visibilité
- Tester les scripts dans différents environnements de terminaux pour assurer la compatibilité

## RELATED LINKS

- [Version en ligne](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)

