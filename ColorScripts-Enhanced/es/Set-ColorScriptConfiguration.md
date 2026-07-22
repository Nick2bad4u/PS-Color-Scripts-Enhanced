---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Conserve los cambios en la configuración de inicio y caché del ColorScripts-Enhanced.

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

Este comando no tiene alias.

## DESCRIPTION

`Set-ColorScriptConfiguration` proporciona una forma persistente de personalizar el comportamiento y la ubicación de almacenamiento del módulo ColorScripts-Enhanced. Este cmdlet actualiza el archivo de configuración del módulo, lo que le permite controlar varios aspectos de la representación y el almacenamiento de script.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

Mueve el caché a `D:/Temp/ColorScriptsCache`, habilita la visualización automática al importar el módulo, deshabilita la presentación automática del perfil y establece `bars` como el script predeterminado.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

Borra el script predeterminado y devuelve el objeto de configuración resultante, lo que le permite verificar que se eliminó la configuración.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

Reubica el caché en el directorio TEMP de Windows y muestra la configuración actualizada completa en formato de lista. Útil para escenarios de prueba temporales.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

Desactiva el renderizado automático de script de colores cuando se carga el módulo. Útil si prefiere el control manual sobre cuándo se muestra scripts.

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

Establece una ruta de caché estilo Linux/macOS mediante expansión de tilde y configura 'crunch' como el script predeterminado para todas las operaciones.

## PARAMETERS

### -AutoShowOnImport

Habilite o deshabilite la representación automática de un script de colores cuando se importa el módulo. Cuando está habilitado (`$true`), un script de colores se muestra inmediatamente después de la importación del módulo, lo que proporciona información visual instantánea. Cuando está deshabilitado (`$false`), scripts solo se muestra cuando se invoca explícitamente. Si no se especifica, la configuración existente permanece sin cambios.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
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
HelpMessage: ''
```

### -CachePath

Especifica el directorio donde se almacenan las cargas útiles `.cache` renderizadas y los sidecars de validación `.cacheinfo`. La fuente scripts de colores y los metadatos del módulo permanecen en el módulo instalado. Admite rutas absolutas, rutas relativas (resueltas desde la ubicación actual), variables de entorno (por ejemplo, `$env:USERPROFILE`) y expansión de tilde (`~`).

Si el directorio especificado no existe, se creará automáticamente con los permisos adecuados. Proporcione un string (`''`) vacío para borrar la ruta personalizada y volver a la ubicación predeterminada específica de la plataforma. Cuando no se especifica, se conserva la configuración de ruta de caché existente.

**Note**: Cambiar la ruta de la caché no migra automáticamente los archivos almacenados en caché existentes. Es posible que necesite copiar archivos manualmente o permitir que se regeneren.

```yaml
Type: System.String
DefaultValue: ''
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

### -DefaultScript

Establece o borra el nombre predeterminado script de colores utilizado por los asistentes de perfil, las funciones de presentación automática y cuando no se especifica explícitamente ningún script en los comandos. Esto debe coincidir con el nombre base de un archivo script sin extensión (por ejemplo, `'bars'`, no `'bars.ps1'`).

Proporcione un string (`''`) vacío para eliminar el valor predeterminado almacenado y volver al comportamiento predeterminado a nivel de módulo (normalmente selección aleatoria). Cuando se omite este parámetro, la configuración predeterminada actual script no cambia.

El script especificado debe existir en el directorio script del módulo para poder utilizarlo correctamente.

```yaml
Type: System.String
DefaultValue: ''
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

### -h

Muestra ayuda detallada para este comando sin realizar la operación.

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

Devuelve el objeto de configuración actualizado después de realizar cambios. Sin este modificador, el cmdlet funciona de forma silenciosa (sin salida). El objeto devuelto tiene la misma estructura que `Get-ColorScriptConfiguration` y se puede inspeccionar, almacenar o canalizar a otros cmdlets para su posterior procesamiento.

Útil para verificación, registro o encadenamiento de comandos de configuración.

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

### -ProfileAutoShow

Controla si los fragmentos de perfil generados por `Add-ColorScriptProfile` incluyen una invocación automática de `Show-ColorScript`. Cuando `$true`, el código de perfil mostrará un script de colores en cada inicio del shell. Cuando `$false`, el perfil cargará el módulo pero no mostrará automáticamente scripts.

Esta configuración sólo afecta al código de perfil recién generado; Las modificaciones de perfil existentes no se actualizan automáticamente. Omitir este parámetro deja la configuración actual sin cambios.

```yaml
Type: System.Nullable`1[System.Boolean]
DefaultValue: ''
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

### -WhatIf

Ejecuta el comando en un modo que solo informa lo que sucedería sin realizar las acciones.

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
-Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, -WarningVariable
Para obtener más información, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet no acepta entradas de canalización.

## OUTPUTS

### None (2)

De forma predeterminada, este cmdlet no produce ningún resultado.

### System.Collections.Hashtable

Cuando se especifica `-PassThru`, devuelve la tabla hash anidada producida por `Get-ColorScriptConfiguration`: los valores de caché están en `Cache` y los valores de inicio están en `Startup`.

## NOTES

La configuración persiste solo después de que la validación y la confirmación sean exitosas. `-WhatIf` no realiza escrituras en el sistema de archivos. Utilice `Get-ColorScriptConfiguration` para inspeccionar los valores efectivos y las rutas de almacenamiento después de la operación.

## RELATED LINKS

- [Versión en línea](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)

