---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/es/New-ColorScript.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# New-ColorScript

## SYNOPSIS

Crea un nuevo archivo de colorscript y opcionalmente emite guía de metadatos.

## SYNTAX

### Default (Default)

```
New-ColorScript [-Name] <String> [-OutputPath <String>] [-Force] [-Category <String>]
 [-Tag <String[]>] [-GenerateMetadataSnippet] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### \_\_AllParameterSets

```
New-ColorScript [-Name] <string> [[-OutputPath] <string>] [[-Category] <string>] [[-Tag] <string[]>]
 [-Force] [-GenerateMetadataSnippet] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

El cmdlet `New-ColorScript` crea un esqueleto completo de colorscript que sirve como base para desarrollar scripts de arte ANSI personalizados. El archivo generado incluye una plantilla preformateada con ejemplos de secuencias de escape ANSI, codificación UTF-8 adecuada sin marca de orden de bytes (BOM), y guía de metadatos opcional para la integración con el sistema de metadatos del módulo.

Por defecto, el script se escribe en el directorio `Scripts` del módulo, asegurando que pueda ser descubierto automáticamente por las funciones de enumeración de scripts del módulo. Sin embargo, el parámetro `-OutputPath` permite apuntar a cualquier directorio personalizado para desarrollo o pruebas.

Los nombres de script deben seguir las convenciones de nomenclatura de PowerShell: deben comenzar con un carácter alfanumérico y pueden incluir guiones bajos o guiones. La extensión `.ps1` se agrega automáticamente si no se proporciona. Los archivos existentes están protegidos contra sobrescrituras accidentales a menos que se especifique explícitamente el interruptor `-Force`.

Cuando se combina con el parámetro `-GenerateMetadataSnippet`, el cmdlet produce código PowerShell listo para usar que demuestra cómo registrar el nuevo script en `ScriptMetadata.psd1`. Esta guía incluye los valores de categoría y etiqueta especificados a través de los parámetros respectivos, agilizando el proceso de integración de scripts personalizados en la estructura organizacional del módulo.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

Crea `my-spectrum.ps1` en el directorio `Scripts` del módulo y devuelve un objeto PowerShell que contiene la ruta del archivo y un fragmento de metadatos. El fragmento muestra cómo agregar una entrada a `ScriptMetadata.psd1` con la categoría 'Artistic' y las etiquetas 'Custom' y 'Demo'.

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

Genera el andamiaje en un directorio personalizado (`~/Dev/colorscripts`), creando el directorio si no existe. Si un archivo llamado `holiday-banner.ps1` ya existe en esa ubicación, se sobrescribirá debido al interruptor `-Force`.

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -Category 'Retro' -Tag '80s','Neon' -GenerateMetadataSnippet
$result.MetadataGuidance | Set-Clipboard
```

Crea un nuevo colorscript y copia la guía de metadatos al portapapeles, facilitando pegarla en `ScriptMetadata.psd1`.

### EXAMPLE 4

```powershell
New-ColorScript -Name 'test-pattern' -OutputPath '.\temp' -WhatIf
```

Muestra qué sucedería al crear un script de patrón de prueba en el directorio `.\temp` sin crear realmente el archivo. Útil para validar rutas y nombres antes de la ejecución.

### EXAMPLE 5

```powershell
# Crear múltiples colorscripts para un proyecto
$scriptNames = @("company-logo", "team-banner", "status-display")
foreach ($name in $scriptNames) {
    New-ColorScript -Name $name -Category "Corporate" -Tag "Custom" -OutputPath ".\src" | Out-Null
}
Write-Host "Created $($scriptNames.Count) colorscript templates"
```

Crea múltiples plantillas de colorscript por lotes para un proyecto.

### EXAMPLE 6

```powershell
# Crear y abrir inmediatamente en el editor
$scaffold = New-ColorScript -Name "my-art" -Category "Artistic" -GenerateMetadataSnippet
code $scaffold.Path  # Abre en VS Code
```

Crea un colorscript y lo abre inmediatamente en el editor predeterminado para editarlo.

### EXAMPLE 7

```powershell
# Crear con automatización completa del flujo de trabajo
$newScript = New-ColorScript -Name "interactive-demo" -Category "Educational" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "Created: $($newScript.ScriptName)"
Write-Host "Path: $($newScript.Path)"
Write-Host "Metadata guidance ready in clipboard"
$newScript.MetadataGuidance | Set-Clipboard
```

Crea un colorscript con guía de metadatos copiada automáticamente al portapapeles.

### EXAMPLE 8

```powershell
# Verificar convenciones de nombres de script
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

Demuestra la validación de convenciones de nomenclatura para colorscripts.

### EXAMPLE 9

```powershell
# Crear en ubicación portable para distribución
$portableDir = Join-Path $PSScriptRoot "colorscripts"
$scaffold = New-ColorScript -Name "portable-art" -OutputPath $portableDir -GenerateMetadataSnippet
Write-Host "Created portable colorscript at: $($scaffold.Path)"
```

Crea colorscripts en una ubicación portable relativa al script actual.

### EXAMPLE 10

```powershell
# Crear con validación de categoría y etiqueta
$categories = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Category -Unique
if ("Retro" -in $categories) {
    New-ColorScript -Name "retro-party" -Category "Retro" -Tag "Fun","Social"
} else {
    Write-Warning "Retro category not found"
}
```

Valida que una categoría exista antes de crear un nuevo colorscript.

## PARAMETERS

### -Category

Especifica la categoría principal para el colorscript al generar guía de metadatos. Este parámetro solo tiene sentido cuando se usa con `-GenerateMetadataSnippet`. Las categorías comunes incluyen 'Artistic', 'Geometric', 'Nature', 'Retro', 'Gaming' y 'Abstract'. El valor debe alinearse con las categorías existentes en `ScriptMetadata.psd1` para consistencia.

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
HelpMessage: ""
```

### -Confirm

Solicita confirmación antes de ejecutar el cmdlet.

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
HelpMessage: ""
```

### -Force

Sobrescribe el archivo de destino si ya existe. Sin este interruptor, el cmdlet terminará con un error si se encuentra un archivo con el mismo nombre en la ubicación de destino. Úselo con precaución para evitar pérdida de datos.

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

### -GenerateMetadataSnippet

Incluye un fragmento de guía en la salida que demuestra cómo registrar el nuevo script en `ScriptMetadata.psd1`. El fragmento usa los valores de los parámetros `-Category` y `-Tag` si se proporcionan. Esto es particularmente útil para mantener metadatos consistentes en todos los colorscripts del módulo.

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

### -Name

Especifica el nombre del nuevo colorscript. El nombre debe comenzar con un carácter alfanumérico y puede incluir guiones bajos o guiones. La extensión `.ps1` se agrega automáticamente si no se incluye. Este nombre se usará como nombre de archivo y debe ser descriptivo del contenido o tema del script.

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
HelpMessage: ""
```

### -OutputPath

Especifica el directorio de destino para el andamiaje. Cuando no se especifica, por defecto es el directorio `Scripts` del módulo. La ruta admite expansión de tilde (`~`) para el directorio de inicio del usuario, variables de entorno (ej. `$env:USERPROFILE`), y rutas tanto relativas como absolutas. El directorio se creará si no existe.

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
HelpMessage: ""
```

### -Tag

Especifica una o más etiquetas de metadatos para el colorscript. Las etiquetas proporcionan clasificación adicional más allá de la categoría principal y son útiles para filtrar y buscar. Las etiquetas comunes incluyen descriptores de tema como 'Minimal', 'Colorful', 'Animated', referencias tecnológicas como 'Matrix', 'ASCII', o marcadores contextuales como 'Holiday', 'Season'. Se pueden especificar múltiples etiquetas como una matriz separada por comas.

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
HelpMessage: ""
```

### -WhatIf

Muestra qué sucedería si el cmdlet se ejecuta sin realizar ninguna acción. Muestra la ruta del archivo que se crearía y cualquier verificación de validación que se realizaría. El cmdlet no crea ningún archivo o directorio cuando se especifica este interruptor.

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
HelpMessage: ""
```

### CommonParameters

Este cmdlet admite los parámetros comunes: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, y -WarningVariable. Para más información, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

No puede canalizar objetos a este cmdlet.

## OUTPUTS

### System.Management.Automation.PSCustomObject

El cmdlet devuelve un objeto personalizado con las siguientes propiedades:

- **ScriptName**: El nombre del colorscript creado (incluyendo la extensión .ps1)
- **Path**: La ruta completa al archivo generado
- **Category**: El valor de categoría que se especificó (si existe)
- **Tags**: La matriz de valores de etiqueta que se especificaron (si existen)
- **MetadataGuidance**: El texto del fragmento de metadatos (solo cuando se usa -GenerateMetadataSnippet)

## NOTES

**Codificación**: El andamiaje se escribe con codificación UTF-8 sin marca de orden de bytes (BOM), asegurando compatibilidad en diferentes plataformas y editores.

**Estructura de plantilla**: La plantilla generada incluye:

- Un bloque de ayuda basado en comentarios con marcadores de posición para documentación
- Un bloque de muestra de arte ANSI demostrando secuencias de color y formato
- Estructura de script de PowerShell adecuada con secciones claras para personalización

**Integración de metadatos**: Aunque el cmdlet puede generar guía de metadatos, debe agregar manualmente el fragmento a `ScriptMetadata.psd1` para integrar completamente el script en el sistema de descubrimiento y categorización del módulo.

**Flujo de trabajo de desarrollo**:

1. Use `New-ColorScript` para crear el andamiaje
2. Edite el archivo .ps1 generado para agregar su arte ANSI
3. Si se generó guía de metadatos, cópiela a `ScriptMetadata.psd1`
4. Ejecute `New-ColorScriptCache` para reconstruir la caché del módulo
5. Pruebe su script con `Show-ColorScript -Name <su-nombre-de-script>`

**Mejores prácticas**:

- Elija nombres descriptivos con guiones que indiquen claramente el tema del script
- Use valores de categoría consistentes que se alineen con scripts existentes
- Aplique múltiples etiquetas para mejorar la capacidad de descubrimiento
- Pruebe scripts en diferentes entornos de terminal para asegurar compatibilidad

## RELATED LINKS

- [Export-ColorScriptMetadata](Export-ColorScriptMetadata.md)
- [New-ColorScriptCache](New-ColorScriptCache.md)
- [Show-ColorScript](Show-ColorScript.md)
- [Get-ColorScriptList](Get-ColorScriptList.md)
- [ScriptMetadata.psd1](../ScriptMetadata.psd1)
