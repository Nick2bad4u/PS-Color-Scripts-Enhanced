---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/26/2026
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Agrega o actualiza un bloque de inicio ColorScripts-Enhanced administrado en un archivo de perfil PowerShell.

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-ProfilePath] <string>] [[-DefaultStartupScript] <string>]
 [[-PokemonPromptResponse] <string>] [-h] [-AutoShow] [-SkipStartupScript] [-IncludePokemon]
 [-SkipPokemonPrompt] [-SkipCacheBuild] [-Force] [-WhatIf] [-Confirm]
```

## ALIASES

Este comando no tiene alias.

## DESCRIPTION

Agrega un bloque de inicio administrado al perfil PowerShell seleccionado. El bloque importa ColorScripts-Enhanced y puede llamar a `Show-ColorScript` después de la importación. `-SkipStartupScript` escribe un bloque de solo importación.

Cuando se omite `-ProfilePath`, el comando prefiere `$PROFILE.CurrentUserAllHosts` y, en caso contrario, utiliza la primera ruta de perfil definida. El archivo de perfil y los directorios principales que faltan se crean cuando es necesario.

Los bloques ColorScripts-Enhanced heredados o administrados existentes se reemplazan en lugar de duplicarse. Si el perfil ya importa el módulo fuera de un bloque administrado, el comando lo deja sin cambios a menos que se especifique `-Force`. `-Force` permite reemplazar el contenido del módulo reconocido y al mismo tiempo preservar el contenido del perfil no relacionado.

El comportamiento de inicio generado se resuelve a partir de parámetros explícitos y configuración persistente. `-AutoShow` habilita explícitamente la visualización y `-DefaultStartupScript` selecciona un script con nombre. Los scripts de Pokémon participan normalmente; los perfiles administrados nuevos nunca preguntan por Pokémon ni emiten `-IncludePokemon`. A menos que se utilice `-SkipCacheBuild`, el comando puede precalentar las entradas de caché seleccionadas por políticas después de actualizar el perfil.

## EXAMPLES

### EXAMPLE 1

Agregar al perfil del usuario actual para todos los hosts (comportamiento predeterminado).

```powershell
Add-ColorScriptProfile
```

Esto agrega tanto la importación del módulo como la llamada `Show-ColorScript` a `$PROFILE.CurrentUserAllHosts`.

### EXAMPLE 2

Agregue al perfil del usuario actual solo para el host actual, sin el inicio script.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost -SkipStartupScript
```

Esto agrega un bloque administrado de solo importación al perfil del host actual.

### EXAMPLE 3

Agregar a una ruta de perfil personalizada con expansión de variables de entorno.

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

Esto apunta a un archivo de perfil específico fuera de las ubicaciones de perfil estándar PowerShell.

### EXAMPLE 4

Fuerce la repetición de la adición del fragmento incluso si ya existe.

```powershell
Add-ColorScriptProfile -Force
```

Estas actualizaciones reconocieron el contenido del perfil ColorScripts-Enhanced y al mismo tiempo conservaron las líneas de perfil no relacionadas.

### EXAMPLE 5

Configuración en una máquina nueva: cree un perfil si es necesario y agregue scripts de colores a todos los hosts.

```powershell
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts -Confirm:$false
Write-Host "¡Perfil configurado! Reinicie el terminal para ver scripts de colores al inicio."
```

### EXAMPLE 6

Agregue con un script de colores específico para la visualización de inicio:

```powershell
Add-ColorScriptProfile -DefaultStartupScript mandelbrot-zoom -AutoShow
```

### EXAMPLE 7

Verifique que el perfil se haya agregado correctamente:

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Apunte explícitamente al perfil de host actual o de todos los hosts:

```powershell
# Solo para Windows Terminal o ConEmu
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserCurrentHost

# Para todos los hosts PowerShell (ISE, VSCode, Consola)
Add-ColorScriptProfile -ProfilePath $PROFILE.CurrentUserAllHosts
```

### EXAMPLE 9

Usando rutas relativas y expansión de tilde:

```powershell
# Usando la expansión de tilde para el directorio de inicio
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# Usando la ruta relativa del directorio actual
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

Muestre diariamente diferentes script de colores agregando lógica personalizada:

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Luego agregue esto a $PROFILE manualmente:
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

### EXAMPLE 11

Utilice el modificador de compatibilidad obsoleto en una llamada de automatización existente:

```powershell
Add-ColorScriptProfile -IncludePokemon
```

El modificador se acepta silenciosamente sin efecto durante una versión de compatibilidad. Los scripts de Pokémon ya participan normalmente y el perfil generado llama a `Show-ColorScript` sin el modificador.

## PARAMETERS

### -AutoShow

Controla si el bloque de perfil administrado muestra un script de colores después de importar el módulo.

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

### -DefaultStartupScript

Especifica el nombre script de colores escrito en el bloque de perfil administrado para la visualización de inicio.

```yaml
Type: System.String
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

### -Force

Actualiza el contenido reconocido de ColorScripts-Enhanced en el perfil y conserva las líneas no relacionadas. No agrega deliberadamente bloques administrados duplicados.

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

### -h

Muestra información de ayuda para este cmdlet. Equivale a usar `Get-Help Add-ColorScriptProfile`.

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

### -IncludePokemon

Modificador de compatibilidad obsoleto. Se acepta silenciosamente sin efecto durante una versión; los scripts de colores de Pokémon ya participan normalmente y los perfiles generados nunca emiten este modificador.

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

### -PokemonPromptResponse

Parámetro de compatibilidad obsoleto. Se acepta silenciosamente sin efecto durante una versión porque la generación de perfiles ya no pregunta por Pokémon.

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

### -ProfilePath

Especifica el archivo de perfil PowerShell que se actualizará. También se acepta el alias Path.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Path
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

### -SkipCacheBuild

Suprima el precalentamiento de caché opcional. Se intenta un precalentamiento sólo cuando el `ProfileAutoShow` resuelto
configuración está habilitada, la creación de caché no se ha deshabilitado, el perfil de destino está fuera del
directorio temporal del sistema y la operación es aprobada por `ShouldProcess`. El mando también respeta la
variable de entorno `COLOR_SCRIPTS_ENHANCED_SKIP_CACHE_BUILD` y la variable global
`$Global:ColorScriptsEnhancedSkipCacheBuild`.

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

### -SkipPokemonPrompt

Modificador de compatibilidad obsoleto. Se acepta silenciosamente sin efecto durante una versión porque la generación de perfiles ya no pregunta por Pokémon.

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

### -SkipStartupScript

Omita agregar `Show-ColorScript` al perfil. Sólo se añade la línea `Import-Module ColorScripts-Enhanced`. Utilícelo si desea controlar manualmente cuándo se muestra scripts de colores.

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

Muestra lo que sucedería si se ejecuta el cmdlet. El cmdlet no se ejecuta.

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

Este cmdlet no acepta entradas de canalización.

## OUTPUTS

### System.Object

Devuelve un objeto personalizado con las siguientes propiedades:

- **Path** (string): la ruta completa al archivo de perfil seleccionado
- **Changed** (bool): Si el perfil fue realmente modificado
- **Message** (string): un mensaje de estado que describe el resultado de la operación.
- **IncludePokemon** (bool): Siempre `$true`; se conserva temporalmente por compatibilidad con el objeto de resultado
- **CacheBuilt** (bool): si se completó el calentamiento de caché opcional

## NOTES

**Autor:** Nick

**Módulo:** ColorScripts-Enhanced

**Requiere:** PowerShell 5.1 o posterior

El archivo de perfil se crea automáticamente si no existe, incluidos los directorios principales necesarios. El comando gestiona las rutas de archivos proporcionadas por el usuario; no expone un selector de alcance separado.

## RELATED LINKS

- [Versión en línea](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Add-ColorScriptProfile)

