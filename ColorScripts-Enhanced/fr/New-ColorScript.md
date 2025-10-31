---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/fr/New-ColorScript.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScript

## SYNOPSIS

Crée un nouveau fichier colorscript et émet éventuellement des conseils de métadonnées.

## SYNTAX

### Default (Default)

```
New-ColorScript [-Name] <String> [-OutputPath <String>] [-Force] [-Category <String>]
 [-Tag <String[]>] [-GenerateMetadataSnippet] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### __AllParameterSets

```
New-ColorScript [-Name] <string> [[-OutputPath] <string>] [[-Category] <string>] [[-Tag] <string[]>]
 [-Force] [-GenerateMetadataSnippet] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

La cmdlet `New-ColorScript` crée un squelette complet de colorscript qui sert de base pour développer des scripts d'art ANSI personnalisés. Le fichier généré comprend un modèle préformaté avec des exemples de séquences d'échappement ANSI, un encodage UTF-8 approprié sans marque d'ordre d'octet (BOM), et des conseils de métadonnées optionnels pour l'intégration avec le système de métadonnées du module.

Par défaut, le script est écrit dans le répertoire `Scripts` du module, garantissant qu'il peut être automatiquement découvert par les fonctions d'énumération de scripts du module. Cependant, le paramètre `-OutputPath` permet de cibler n'importe quel répertoire personnalisé pour le développement ou les tests.

Les noms de scripts doivent suivre les conventions de nommage PowerShell : ils doivent commencer par un caractère alphanumérique et peuvent inclure des traits de soulignement ou des traits d'union. L'extension `.ps1` est automatiquement ajoutée si elle n'est pas fournie. Les fichiers existants sont protégés contre les écrasements accidentels à moins que le commutateur `-Force` ne soit explicitement spécifié.

Lorsqu'il est combiné avec le paramètre `-GenerateMetadataSnippet`, la cmdlet produit du code PowerShell prêt à l'emploi qui démontre comment enregistrer le nouveau script dans `ScriptMetadata.psd1`. Ces conseils incluent les valeurs de catégorie et de balise spécifiées via les paramètres respectifs, rationalisant le processus d'intégration des scripts personnalisés dans la structure organisationnelle du module.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

Crée `my-spectrum.ps1` dans le répertoire `Scripts` du module et retourne un objet PowerShell contenant le chemin du fichier et un extrait de métadonnées. L'extrait montre comment ajouter une entrée à `ScriptMetadata.psd1` avec la catégorie 'Artistic' et les balises 'Custom' et 'Demo'.

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

Génère le squelette dans un répertoire personnalisé (`~/Dev/colorscripts`), créant le répertoire s'il n'existe pas. Si un fichier nommé `holiday-banner.ps1` existe déjà à cet emplacement, il sera écrasé en raison du commutateur `-Force`.

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -Category 'Retro' -Tag '80s','Neon' -GenerateMetadataSnippet
$result.MetadataGuidance | Set-Clipboard
```

Crée un nouveau colorscript et copie les conseils de métadonnées dans le presse-papiers, facilitant leur collage dans `ScriptMetadata.psd1`.

### EXAMPLE 4

```powershell
New-ColorScript -Name 'test-pattern' -OutputPath '.\temp' -WhatIf
```

Montre ce qui se passerait lors de la création d'un script de motif de test dans le répertoire `.\temp` sans créer réellement le fichier. Utile pour valider les chemins et les noms avant l'exécution.

### EXAMPLE 5

```powershell
# Create multiple colorscripts for a project
$scriptNames = @("company-logo", "team-banner", "status-display")
foreach ($name in $scriptNames) {
    New-ColorScript -Name $name -Category "Corporate" -Tag "Custom" -OutputPath ".\src" | Out-Null
}
Write-Host "Created $($scriptNames.Count) colorscript templates"
```

Crée plusieurs modèles de colorscripts en lot pour un projet.

### EXAMPLE 6

```powershell
# Create and immediately open in editor
$scaffold = New-ColorScript -Name "my-art" -Category "Artistic" -GenerateMetadataSnippet
code $scaffold.Path  # Opens in VS Code
```

Crée un colorscript et l'ouvre immédiatement dans l'éditeur par défaut pour l'édition.

### EXAMPLE 7

```powershell
# Create with full workflow automation
$newScript = New-ColorScript -Name "interactive-demo" -Category "Educational" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "Created: $($newScript.ScriptName)"
Write-Host "Path: $($newScript.Path)"
Write-Host "Metadata guidance ready in clipboard"
$newScript.MetadataGuidance | Set-Clipboard
```

Crée un colorscript avec des conseils de métadonnées automatiquement copiés dans le presse-papiers.

### EXAMPLE 8

```powershell
# Verify script name conventions
$validName = "my-awesome-script"
$invalidNames = @("123start", "-invalid", "_underscore-only")
foreach ($name in $invalidNames) {
    try {
        New-ColorScript -Name $name -WhatIf -ErrorAction Stop
    } catch {
        Write-Warning "Invalid name '$name': $_"
    }
}
```

Démontre la validation des conventions de nommage pour les colorscripts.

### EXAMPLE 9

```powershell
# Create in portable location for distribution
$portableDir = Join-Path $PSScriptRoot "colorscripts"
$scaffold = New-ColorScript -Name "portable-art" -OutputPath $portableDir -GenerateMetadataSnippet
Write-Host "Created portable colorscript at: $($scaffold.Path)"
```

Crée des colorscripts dans un emplacement portable relatif au script actuel.

### EXAMPLE 10

```powershell
# Create with category and tag validation
$categories = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Category -Unique
if ("Retro" -in $categories) {
    New-ColorScript -Name "retro-party" -Category "Retro" -Tag "Fun","Social"
} else {
    Write-Warning "Retro category not found"
}
```

Valide qu'une catégorie existe avant de créer un nouveau colorscript.

## PARAMETERS

### -Category

Spécifie la catégorie principale pour le colorscript lors de la génération des conseils de métadonnées. Ce paramètre n'est significatif que lorsqu'il est utilisé avec `-GenerateMetadataSnippet`. Les catégories communes incluent 'Artistic', 'Geometric', 'Nature', 'Retro', 'Gaming' et 'Abstract'. La valeur doit s'aligner avec les catégories existantes dans `ScriptMetadata.psd1` pour la cohérence.

```yaml
Type: System.String
DefaultValue: None
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

### -Confirm

Vous invite à confirmer avant d'exécuter la cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

Écrase le fichier de destination s'il existe déjà. Sans ce commutateur, la cmdlet se terminera avec une erreur si un fichier du même nom est trouvé à l'emplacement cible. Utilisez avec prudence pour éviter la perte de données.

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

### -GenerateMetadataSnippet

Inclut un extrait de conseils dans la sortie qui démontre comment enregistrer le nouveau script dans `ScriptMetadata.psd1`. L'extrait utilise les valeurs des paramètres `-Category` et `-Tag` si elles sont fournies. Ceci est particulièrement utile pour maintenir des métadonnées cohérentes sur tous les colorscripts du module.

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

### -Name

Spécifie le nom du nouveau colorscript. Le nom doit commencer par un caractère alphanumérique et peut inclure des traits de soulignement ou des traits d'union. L'extension `.ps1` est ajoutée automatiquement si elle n'est pas incluse. Ce nom sera utilisé comme nom de fichier et devrait être descriptif du contenu ou du thème du script.

```yaml
Type: System.String
DefaultValue: None
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutputPath

Spécifie le répertoire de destination pour le squelette. Lorsqu'il n'est pas spécifié, il utilise par défaut le répertoire `Scripts` du module. Le chemin prend en charge l'expansion du tilde (`~`) pour le répertoire personnel de l'utilisateur, les variables d'environnement (par exemple, `$env:USERPROFILE`), et les chemins relatifs et absolus. Le répertoire sera créé s'il n'existe pas.

```yaml
Type: System.String
DefaultValue: (module Scripts directory)
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

### -Tag

Spécifie une ou plusieurs balises de métadonnées pour le colorscript. Les balises fournissent une classification supplémentaire au-delà de la catégorie principale et sont utiles pour le filtrage et la recherche. Les balises communes incluent des descripteurs de thème comme 'Minimal', 'Colorful', 'Animated', des références technologiques comme 'Matrix', 'ASCII', ou des marqueurs contextuels comme 'Holiday', 'Season'. Plusieurs balises peuvent être spécifiées sous forme de tableau séparé par des virgules.

```yaml
Type: System.String[]
DefaultValue: None
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
HelpMessage: ''
```

### -WhatIf

Montre ce qui se passerait si la cmdlet s'exécute sans effectuer réellement d'actions. Affiche le chemin du fichier qui serait créé et toutes les vérifications de validation qui seraient effectuées. La cmdlet ne crée aucun fichier ou répertoire lorsque ce commutateur est spécifié.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
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

Vous ne pouvez pas canaliser d'objets vers cette cmdlet.

## OUTPUTS

### System.Management.Automation.PSCustomObject

La cmdlet retourne un objet personnalisé avec les propriétés suivantes :

- **ScriptName** : Le nom du colorscript créé (y compris l'extension .ps1)
- **Path** : Le chemin complet vers le fichier généré
- **Category** : La valeur de catégorie qui a été spécifiée (le cas échéant)
- **Tags** : Le tableau des valeurs de balise qui ont été spécifiées (le cas échéant)
- **MetadataGuidance** : Le texte de l'extrait de métadonnées (uniquement lorsque -GenerateMetadataSnippet est utilisé)

## NOTES

**Encodage** : Le squelette est écrit avec un encodage UTF-8 sans marque d'ordre d'octet (BOM), assurant la compatibilité sur différentes plateformes et éditeurs.

**Structure du modèle** : Le modèle généré comprend :
- Un bloc d'aide basé sur des commentaires avec des espaces réservés pour la documentation
- Un bloc d'exemple d'art ANSI démontrant les séquences de couleurs et le formatage
- Une structure de script PowerShell appropriée avec des sections claires pour la personnalisation

**Intégration des métadonnées** : Bien que la cmdlet puisse générer des conseils de métadonnées, vous devez ajouter manuellement l'extrait à `ScriptMetadata.psd1` pour intégrer pleinement le script dans le système de découverte et de catégorisation du module.

**Flux de travail de développement** :
1. Utilisez `New-ColorScript` pour créer le squelette
2. Modifiez le fichier .ps1 généré pour ajouter votre art ANSI
3. Si des conseils de métadonnées ont été générés, copiez-les dans `ScriptMetadata.psd1`
4. Exécutez `New-ColorScriptCache` pour reconstruire le cache du module
5. Testez votre script avec `Show-ColorScript -Name <votre-nom-de-script>`

**Meilleures pratiques** :
- Choisissez des noms descriptifs avec des traits d'union qui indiquent clairement le thème du script
- Utilisez des valeurs de catégorie cohérentes qui s'alignent avec les scripts existants
- Appliquez plusieurs balises pour améliorer la découvrabilité
- Testez les scripts dans différents environnements de terminal pour assurer la compatibilité

## RELATED LINKS

- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [ScriptMetadata.psd1](../ScriptMetadata.psd1)
