---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/es/Set-ColorScriptConfiguration.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
---

# Set-ColorScriptConfiguration

## SYNOPSIS

Persistir cambios en la caché y configuración de inicio de ColorScripts-Enhanced.

## SYNTAX

### Default (Default)

```
Set-ColorScriptConfiguration [-AutoShowOnImport <Boolean>] [-ProfileAutoShow <Boolean>]
 [-CachePath <String>] [-DefaultScript <String>] [-PassThru] [<CommonParameters>]
```

### __AllParameterSets

```
Set-ColorScriptConfiguration [[-AutoShowOnImport] <bool>] [[-ProfileAutoShow] <bool>]
 [[-CachePath] <string>] [[-DefaultScript] <string>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION

`Set-ColorScriptConfiguration` proporciona una forma persistente de personalizar el comportamiento y la ubicación de almacenamiento del módulo ColorScripts-Enhanced. Este cmdlet actualiza el archivo de configuración del módulo, permitiéndole controlar varios aspectos de la representación y almacenamiento de scripts.

**Capacidades clave:**

- **Reubicación de caché**: Mueva la caché de colorscript a un directorio personalizado, útil para acciones compartidas de red, unidades más rápidas o ubicaciones de almacenamiento centralizadas.
- **Comportamiento de autoimportación**: Controle si un colorscript se muestra automáticamente cuando el módulo se importa por primera vez en su sesión de PowerShell.
- **Integración de perfil**: Configure ajustes predeterminados para `Add-ColorScriptProfile` para simplificar la configuración del perfil.
- **Selección de script predeterminado**: Establezca un colorscript preferido que se utilizará cuando no se solicite un script específico.

Cualquier ruta de directorio proporcionada para `-CachePath` se crea automáticamente si no existe. El cmdlet admite expansión de variables de entorno, expansión de directorio de inicio tilde (`~`), y rutas absolutas y relativas. Proporcionar una cadena vacía (`''`) a `-CachePath` o `-DefaultScript` borra el valor almacenado y revierte a los valores predeterminados del módulo.

Los cambios realizados con este cmdlet surten efecto inmediatamente para nuevas operaciones, pero pueden no afectar los datos de caché ya cargados hasta que el módulo se reimporte o PowerShell se reinicie.

Cuando se especifica `-PassThru`, el cmdlet devuelve el objeto de configuración actualizado, facilitando la verificación de cambios o el encadenamiento de operaciones adicionales.

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
HelpMessage: ''
```

### -CachePath

Especifica el directorio donde se almacenan los archivos y metadatos de colorscript. Admite rutas absolutas, rutas relativas (resueltas desde la ubicación actual), variables de entorno (por ejemplo, `$env:USERPROFILE`), y expansión de tilde (`~`) para el directorio de inicio.

Si el directorio especificado no existe, se creará automáticamente con permisos apropiados. Proporcione una cadena vacía (`''`) para borrar la ruta personalizada y revertir a la ubicación predeterminada específica de la plataforma. Cuando se deja sin especificar, se preserva la configuración de ruta de caché existente.

**Nota**: Cambiar la ruta de caché no migra automáticamente los archivos en caché existentes. Puede necesitar copiar archivos manualmente o permitir que se regeneren.

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
HelpMessage: ''
```

### -DefaultScript

Establece o borra el nombre de colorscript predeterminado utilizado por los ayudantes de perfil, características de auto-show, y cuando no se especifica un script en comandos. Esto debe coincidir con el nombre base de un archivo de script sin extensión (por ejemplo, `'bars'`, no `'bars.ps1'`).

Proporcione una cadena vacía (`''`) para eliminar el predeterminado almacenado, revirtiendo al comportamiento predeterminado a nivel de módulo (típicamente selección aleatoria). Cuando se omite este parámetro, la configuración de script predeterminado actual permanece sin cambios.

El script especificado debe existir en el directorio de scripts del módulo para usarse exitosamente.

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
HelpMessage: ''
```

### -PassThru

Devuelve el objeto de configuración actualizado después de realizar cambios. Sin este interruptor, el cmdlet opera silenciosamente (sin salida). El objeto devuelto tiene la misma estructura que `Get-ColorScriptConfiguration` y puede inspeccionarse, almacenarse o canalizarse a otros cmdlets para procesamiento adicional.

Útil para verificación, registro o encadenamiento de comandos de configuración.

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

### -ProfileAutoShow

Controla si los fragmentos de perfil generados por `Add-ColorScriptProfile` incluyen una invocación automática de `Show-ColorScript`. Cuando `$true`, el código de perfil mostrará un colorscript en cada inicio de shell. Cuando `$false`, el perfil cargará el módulo pero no mostrará scripts automáticamente.

Esta configuración solo afecta el código de perfil recién generado; las modificaciones de perfil existentes no se actualizan automáticamente. Omitir este parámetro deja la configuración actual sin cambios.

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
HelpMessage: ''
```

### CommonParameters

Este cmdlet admite los parámetros comunes: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, y -WarningVariable. Para más información, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet no acepta entrada de canalización.

## OUTPUTS

### None

Por defecto, este cmdlet no produce salida.

### System.Collections.Hashtable

Cuando se especifica `-PassThru`, devuelve una hashtable que contiene la configuración completa actualizada. La estructura coincide con la salida de `Get-ColorScriptConfiguration`, con claves como `CachePath`, `AutoShowOnImport`, `ProfileAutoShow`, y `DefaultScript`.

## NOTES

**Ubicación del archivo de configuración:**

Los cambios de configuración se persisten en un archivo JSON o XML almacenado en un directorio de datos de aplicación específico de la plataforma. Use `Get-ColorScriptConfiguration` para ver la ruta raíz de configuración actual. La variable de entorno `COLOR_SCRIPTS_ENHANCED_CONFIG_ROOT` puede anular la ubicación predeterminada del directorio de configuración si se establece antes de importar el módulo.

**Valores predeterminados de plataforma:**

- **Windows**: `$env:LOCALAPPDATA\ColorScripts-Enhanced`
- **Linux/macOS**: `~/.config/ColorScripts-Enhanced` o `$XDG_CONFIG_HOME/ColorScripts-Enhanced`

**Mejores prácticas:**

- Pruebe cambios de ruta de caché en un entorno no productivo primero, especialmente cuando use ubicaciones de red.
- Use `-PassThru` al escribir scripts para validar actualizaciones de configuración programáticamente.
- Considere establecer `AutoShowOnImport:$false` en scripts automatizados o canalizaciones CI/CD para evitar salida visual inesperada.
- Documente configuraciones personalizadas en entornos de equipo para asegurar comportamiento consistente entre usuarios.

**Permisos:**

Asegúrese de tener permisos de escritura en el directorio de configuración. En sistemas compartidos, los cambios de configuración afectan solo el perfil del usuario actual a menos que se anulen con variables de entorno que apunten a ubicaciones compartidas.

## RELATED LINKS

- [Get-ColorScriptConfiguration](Get-ColorScriptConfiguration.md)
- [Reset-ColorScriptConfiguration](Reset-ColorScriptConfiguration.md)
- [Add-ColorScriptProfile](Add-ColorScriptProfile.md)
- [Show-ColorScript](Show-ColorScript.md)
