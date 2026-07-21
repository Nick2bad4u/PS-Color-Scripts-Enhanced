---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/20/2026
PlatyPS schema version: 2024-05-01
title: Set-ColorScriptConfiguration
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Persistir cambios en la caché y configuración de inicio de ColorScripts-Enhanced.

## SYNTAX

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-h] [-PassThru] [-WhatIf] [-Confirm]
```

## ALIASES

This command has no aliases.

## DESCRIPTION

`Set-ColorScriptConfiguration` proporciona una forma persistente de personalizar el comportamiento y la ubicación de almacenamiento del módulo ColorScripts-Enhanced. Este cmdlet actualiza el archivo de configuración del módulo, permitiéndole controlar varios aspectos de la representación y almacenamiento de scripts.

## EXAMPLES

### EXAMPLE 1

```powershell
Set-ColorScriptConfiguration -CachePath 'D:/Temp/ColorScriptsCache' -AutoShowOnImport:$true -ProfileAutoShow:$false -DefaultScript 'bars'
```

Mueve la caché a `D:/Temp/ColorScriptsCache`, habilita la visualización automática al importar el módulo, deshabilita el auto-show del perfil y establece `bars` como el script predeterminado.

### EXAMPLE 2

```powershell
Set-ColorScriptConfiguration -DefaultScript '' -PassThru
```

Borra el script predeterminado y devuelve el objeto de configuración resultante, permitiéndole verificar que la configuración se eliminó.

### EXAMPLE 3

```powershell
Set-ColorScriptConfiguration -CachePath "$env:TEMP\ColorScripts" -PassThru | Format-List
```

Reubica la caché al directorio TEMP de Windows y muestra la configuración completa actualizada en formato de lista. Útil para escenarios de prueba temporales.

### EXAMPLE 4

```powershell
Set-ColorScriptConfiguration -AutoShowOnImport:$false
```

Deshabilita la representación automática de colorscript cuando se carga el módulo. Útil si prefiere control manual sobre cuándo se muestran los scripts.

### EXAMPLE 5

```powershell
Set-ColorScriptConfiguration -CachePath '~/.local/share/colorscripts' -DefaultScript 'crunch'
```

Establece una ruta de caché estilo Linux/macOS usando expansión de tilde y configura 'crunch' como el script predeterminado para todas las operaciones.

## PARAMETERS

### -AutoShowOnImport

Habilitar o deshabilitar la representación automática de un colorscript cuando se importa el módulo. Cuando está habilitado (`$true`), un colorscript se muestra inmediatamente al importar el módulo, proporcionando retroalimentación visual instantánea. Cuando está deshabilitado (`$false`), los scripts solo se muestran cuando se invocan explícitamente. Si no se especifica, la configuración existente permanece sin cambios.

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

Especifica el directorio donde se almacenan los archivos y metadatos de colorscript. Admite rutas absolutas, rutas relativas (resueltas desde la ubicación actual), variables de entorno (por ejemplo, `$env:USERPROFILE`), y expansión de tilde (`~`) para el directorio de inicio.

Si el directorio especificado no existe, se creará automáticamente con permisos apropiados. Proporcione una cadena vacía (`''`) para borrar la ruta personalizada y revertir a la ubicación predeterminada específica de la plataforma. Cuando se deja sin especificar, se preserva la configuración de ruta de caché existente.

**Nota**: Cambiar la ruta de caché no migra automáticamente los archivos en caché existentes. Puede necesitar copiar archivos manualmente o permitir que se regeneren.

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

Prompts you for confirmation before running the cmdlet.

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

Establece o borra el nombre de colorscript predeterminado utilizado por los ayudantes de perfil, características de auto-show, y cuando no se especifica un script en comandos. Esto debe coincidir con el nombre base de un archivo de script sin extensión (por ejemplo, `'bars'`, no `'bars.ps1'`).

Proporcione una cadena vacía (`''`) para eliminar el predeterminado almacenado, revirtiendo al comportamiento predeterminado a nivel de módulo (típicamente selección aleatoria). Cuando se omite este parámetro, la configuración de script predeterminado actual permanece sin cambios.

El script especificado debe existir en el directorio de scripts del módulo para usarse exitosamente.

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

Muestra la ayuda detallada de este comando sin realizar la operación.

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

Devuelve el objeto de configuración actualizado después de realizar cambios. Sin este interruptor, el cmdlet opera silenciosamente (sin salida). El objeto devuelto tiene la misma estructura que `Get-ColorScriptConfiguration` y puede inspeccionarse, almacenarse o canalizarse a otros cmdlets para procesamiento adicional.

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

Controla si los fragmentos de perfil generados por `Add-ColorScriptProfile` incluyen una invocación automática de `Show-ColorScript`. Cuando `$true`, el código de perfil mostrará un colorscript en cada inicio de shell. Cuando `$false`, el perfil cargará el módulo pero no mostrará scripts automáticamente.

Esta configuración solo afecta el código de perfil recién generado; las modificaciones de perfil existentes no se actualizan automáticamente. Omitir este parámetro deja la configuración actual sin cambios.

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

Runs the command in a mode that only reports what would happen without performing the actions.

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

Este cmdlet no acepta entrada de canalización.

## OUTPUTS

### None (2)

Por defecto, este cmdlet no produce salida.

### System.Collections.Hashtable

Cuando se especifica `-PassThru`, devuelve una hashtable que contiene la configuración completa actualizada. La estructura coincide con la salida de `Get-ColorScriptConfiguration`, con claves como `CachePath`, `AutoShowOnImport`, `ProfileAutoShow`, y `DefaultScript`.

## NOTES

Configuration is persisted only after validation and confirmation succeed.
`-WhatIf` performs no filesystem writes.
Use `Get-ColorScriptConfiguration` to inspect the effective values and storage paths after the operation.

## RELATED LINKS

- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [Online Version](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
- [](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Set-ColorScriptConfiguration)
