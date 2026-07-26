---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: New-ColorScript
---

# New-ColorScript

## SYNOPSIS

Cree un nuevo archivo script de colores y, opcionalmente, emita guía de metadatos.

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

Este comando no tiene alias.

## DESCRIPTION

El cmdlet `New-ColorScript` crea un andamio script de colores mínimo que contiene una matriz string y un bucle que escribe cada línea. El archivo está codificado como UTF-8 sin una marca de orden de bytes (BOM). La guía de metadatos opcional se puede incluir como un comentario en el archivo generado y devolverse en el objeto de resultado.

Tanto `-Name` como `-OutputPath` son obligatorios al montar andamios. `-OutputPath` identifica un directorio; el comando crea el directorio cuando es necesario y escribe `<Name>.ps1` dentro de él.

Los nombres Script deben seguir las convenciones de nomenclatura de PowerShell: deben comenzar con un carácter alfanumérico y pueden incluir guiones bajos o guiones. La extensión `.ps1` se agrega automáticamente si no se proporciona. Los archivos existentes están protegidos contra sobrescrituras accidentales a menos que se especifique explícitamente el modificador `-Force`.

Cuando se combina con `-GenerateMetadataSnippet`, el cmdlet devuelve una guía que describe la entrada que se debe agregar a `ScriptMetadata.psd1`. Los valores de categoría y etiqueta proporcionados también se devuelven como matrices en el objeto de resultado.

## EXAMPLES

### EXAMPLE 1

```powershell
New-ColorScript -Name 'my-spectrum' -OutputPath ./ColorScripts-Enhanced/Scripts -GenerateMetadataSnippet -Category 'Artistic' -Tag 'Custom','Demo'
```

Crea `my-spectrum.ps1` en el directorio solicitado y devuelve un objeto que contiene la ruta del archivo y la guía de metadatos.

### EXAMPLE 2

```powershell
New-ColorScript -Name 'holiday-banner' -OutputPath '~/Dev/colorscripts' -Force
```

Genera el scaffold bajo un directorio personalizado (`~/Dev/colorscripts`), creando el directorio si no existe. Si ya existe un archivo llamado `holiday-banner.ps1` en esa ubicación, se sobrescribirá debido al cambio `-Force`.

### EXAMPLE 3

```powershell
$result = New-ColorScript -Name 'retro-wave' -OutputPath ./ColorScripts-Enhanced/Scripts -Category 'Artistic' -Tag '80s','Neon' -GenerateMetadataSnippet
$result.MetadataGuidance | Set-Clipboard
```

Crea un nuevo script de colores y copia la guía de metadatos en el portapapeles, lo que facilita pegarlo en `ScriptMetadata.psd1`.

### EXAMPLE 4

```powershell
New-ColorScript -Name 'test-pattern' -OutputPath '.\temp' -WhatIf
```

Muestra lo que sucedería al crear un patrón de prueba script en el directorio `.\temp` sin crear realmente el archivo. Útil para validar rutas y nombres antes de la ejecución.

### EXAMPLE 5

```powershell
# Crear múltiples scripts de colores para un proyecto
$scriptNames = @("company-logo", "team-banner", "status-display")
foreach ($name in $scriptNames) {
    New-ColorScript -Name $name -Category "Corporate" -Tag "Custom" -OutputPath ".\src" | Out-Null
}
Write-Host "Se crearon $($scriptNames.Count) plantillas de scripts de colores"
```

Crea varias plantillas script de colores por lotes para un proyecto.

### EXAMPLE 6

```powershell
# Crear y abrir inmediatamente en el editor
New-ColorScript -Name "my-art" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -GenerateMetadataSnippet -OpenInEditor
```

Crea un script de colores y solicita al controlador registrado de la plataforma que lo abra.

### EXAMPLE 7

```powershell
# Crear con automatización completa del flujo de trabajo
$newScript = New-ColorScript -Name "interactive-demo" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Custom" -Tag "Interactive","Demo" -GenerateMetadataSnippet
Write-Host "Creado: $($newScript.Name)"
Write-Host "Ruta: $($newScript.Path)"
Write-Host "La guía de metadatos está disponible en el portapapeles"
$newScript.MetadataGuidance | Set-Clipboard
```

Crea un script de colores con guía de metadatos copiada automáticamente al portapapeles.

### EXAMPLE 8

```powershell
# Verificar las convenciones de nombres script
$validName = "123-start"
$invalidNames = @("-invalid", "_underscore-only", "contains space")
foreach ($name in $invalidNames) {
    try {
        New-ColorScript -Name $name -OutputPath ./temp -WhatIf -ErrorAction Stop
    } catch {
        Write-Warning "Nombre no válido '$name': $_"
    }
}
```

Demuestra la validación de la convención de nomenclatura para scripts de colores.

### EXAMPLE 9

```powershell
# Crear en una ubicación portátil para distribución
$portableDir = Join-Path $PSScriptRoot "colorscripts"
$scaffold = New-ColorScript -Name "portable-art" -OutputPath $portableDir -GenerateMetadataSnippet
Write-Host "Script de colores portátil creado en: $($scaffold.Path)"
```

Crea scripts de colores en una ubicación portátil relativa al script actual.

### EXAMPLE 10

```powershell
# Crear con validación de categoría y etiqueta.
$categories = Get-ColorScriptList -AsObject | Select-Object -ExpandProperty Category -Unique
if ("Retro" -in $categories) {
    New-ColorScript -Name "retro-party" -OutputPath ./ColorScripts-Enhanced/Scripts -Category "Artistic" -Tag "Fun","Social"
} else {
    Write-Warning "No se encontró la categoría Retro"
}
```

Valida que exista una categoría antes de crear un nuevo script de colores.

## PARAMETERS

### -Category

Especifica una o más categorías devueltas con el andamio e incluidas en la guía de metadatos. Los valores deben alinearse con las categorías que ya se utilizan en `ScriptMetadata.psd1`.

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

Le solicita confirmación antes de ejecutar el cmdlet.

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

Sobrescribe el archivo de destino si ya existe. Sin este modificador, el cmdlet terminará con un error si se encuentra un archivo con el mismo nombre en la ubicación de destino. Úselo con precaución para evitar la pérdida de datos.

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

Incluye un fragmento de guía en el resultado que demuestra cómo registrar el nuevo script en `ScriptMetadata.psd1`. El fragmento utiliza los valores de los parámetros `-Category` y `-Tag`, si se proporcionan. Esto es particularmente útil para mantener metadatos consistentes en todos los scripts de colores del módulo.

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

Muestra ayuda detallada para este comando sin realizar la operación.

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

Especifica el nombre del nuevo script de colores. El nombre debe comenzar con un carácter alfanumérico y puede incluir guiones bajos o guiones. La extensión `.ps1` se agrega automáticamente si no se incluye. Este nombre se utilizará como nombre de archivo y debe ser descriptivo del contenido o tema del script.

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

Abre el script de colores generado con el comando configurado por el entorno cuando la creación tiene éxito.

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

Especifica el directorio de destino obligatorio. El comando crea <Name>.ps1 dentro de este directorio.

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

Especifica una o más etiquetas de metadatos para el script de colores. Tags proporciona una clasificación adicional más allá de la categoría principal y es útil para filtrar y buscar. Las etiquetas comunes incluyen descriptores de temas como 'Minimal', 'Colorful', 'Animated', referencias tecnológicas como 'Matrix', 'ASCII' o marcadores contextuales como 'Holiday', 'Season'. Se pueden especificar varias etiquetas como una matriz separada por comas.

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

Muestra lo que sucedería si el cmdlet se ejecuta sin realizar ninguna acción. Muestra la ruta del archivo que se crearía y las comprobaciones de validación que se realizarían. El cmdlet no crea ningún archivo ni directorio cuando se especifica este modificador.

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

Este cmdlet admite los parámetros comunes:
Para obtener más información, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

No puede canalizar objetos a este cmdlet.

## OUTPUTS

### System.Management.Automation.PSCustomObject

El cmdlet devuelve un objeto personalizado con las siguientes propiedades:

- **Name**: El nombre script de colores sin la extensión `.ps1`
- **Path**: La ruta completa al archivo generado.
- **Categories**: la matriz de valores de categoría que se especificó (si corresponde)
- **Tags**: la matriz de valores de etiquetas que se especificaron (si corresponde)
- **MetadataGuidance**: el texto del fragmento de metadatos (solo cuando se usa -GenerateMetadataSnippet)

## NOTES

**Codificación**: el andamio está escrito con codificación UTF-8 sin una marca de orden de bytes (BOM), lo que garantiza la compatibilidad entre diferentes plataformas y editores.

**Estructura de la plantilla**: La plantilla generada incluye:

- Un comentario de andamio
- Un marcador de posición de matriz string para el arte
- Un bucle que escribe cada línea con `Write-Host`

**Integración de metadatos**: si bien el cmdlet puede generar orientación de metadatos, debe agregar manualmente el fragmento a `ScriptMetadata.psd1` para integrar completamente el script en el sistema de descubrimiento y categorización del módulo.

**Flujo de trabajo de desarrollo**:

1. Utilice `New-ColorScript` para crear el andamio.
2. Edite el archivo .ps1 generado para agregar su arte ANSI
3. Si se generó una guía de metadatos, cópiela a `ScriptMetadata.psd1`
4. Pruebe su script con `Show-ColorScript -Name <your-script-name>`

**Mejores prácticas**:

- Elija nombres descriptivos con guiones que indiquen claramente el tema del script
- Utilice valores de categoría consistentes que se alineen con el scripts existente
- Aplicar múltiples etiquetas para mejorar la visibilidad
- Pruebe scripts en diferentes entornos de terminales para garantizar la compatibilidad

## RELATED LINKS

- [Versión en línea](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=New-ColorScript)

