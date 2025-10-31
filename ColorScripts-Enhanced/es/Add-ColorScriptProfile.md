---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://github.com/Nick2bad4u/PS-Color-Scripts-Enhanced/blob/main/ColorScripts-Enhanced/es/Add-ColorScriptProfile.md
Module Name: ColorScripts-Enhanced
ms.date: 10/26/2025
PlatyPS schema version: 2024-05-01
title: Add-ColorScriptProfile
---

# Add-ColorScriptProfile

## SYNOPSIS

Agrega la importación del módulo ColorScripts-Enhanced (y opcionalmente Show-ColorScript) a un archivo de perfil de PowerShell.

## SYNTAX

### __AllParameterSets

```
Add-ColorScriptProfile [[-Scope] <string>] [[-Path] <string>] [-h] [-SkipStartupScript] [-Force]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

Este cmdlet tiene los siguientes alias:
- Ninguno

## DESCRIPTION

Agrega un fragmento de inicio al archivo de perfil de PowerShell especificado. El fragmento siempre importa el módulo ColorScripts-Enhanced y, a menos que se suprima con `-SkipStartupScript`, agrega una llamada a `Show-ColorScript` para que se muestre un colorscript aleatorio al iniciar PowerShell.

El archivo de perfil se crea automáticamente si no existe. Las importaciones duplicadas se evitan a menos que se especifique `-Force`.

El parámetro `-Path` acepta rutas relativas, variables de entorno y expansión de `~`, lo que facilita apuntar a perfiles fuera de las ubicaciones predeterminadas. Si no se proporciona `-Path`, el parámetro `-Scope` determina qué perfil estándar de PowerShell modificar.

## EXAMPLES

### EXAMPLE 1

Agregar al perfil del usuario actual para todos los hosts (comportamiento predeterminado).

```powershell
Add-ColorScriptProfile
```

Esto agrega tanto la importación del módulo como la llamada a `Show-ColorScript` a `$PROFILE.CurrentUserAllHosts`.

### EXAMPLE 2

Agregar al perfil del usuario actual para el host actual únicamente, sin el script de inicio.

```powershell
Add-ColorScriptProfile -Scope CurrentUserCurrentHost -SkipStartupScript
```

Esto agrega solo la línea `Import-Module ColorScripts-Enhanced` al perfil del host actual.

### EXAMPLE 3

Agregar a una ruta de perfil personalizada con expansión de variables de entorno.

```powershell
Add-ColorScriptProfile -Path "$env:USERPROFILE\Documents\CustomProfile.ps1"
```

Esto apunta a un archivo de perfil específico fuera de las ubicaciones estándar de perfiles de PowerShell.

### EXAMPLE 4

Forzar la re-adición del fragmento incluso si ya existe.

```powershell
Add-ColorScriptProfile -Force
```

Esto agrega el fragmento nuevamente, incluso si el perfil ya contiene una declaración de importación para ColorScripts-Enhanced.

### EXAMPLE 5

Configuración en una nueva máquina - crear perfil si es necesario y agregar ColorScripts a todos los hosts.

```powershell
$profileExists = Test-Path $PROFILE.CurrentUserAllHosts
if (-not $profileExists) {
    New-Item -Path $PROFILE.CurrentUserAllHosts -ItemType File -Force | Out-Null
}
Add-ColorScriptProfile -Scope CurrentUserAllHosts -Confirm:$false
Write-Host "¡Perfil configurado! Reinicia tu terminal para ver los colorscripts al inicio."
```

### EXAMPLE 6

Agregar con un colorscript específico para mostrar (agregar manualmente después de este comando):

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Luego editar manualmente $PROFILE para agregar:
# Show-ColorScript -Name mandelbrot-zoom
```

### EXAMPLE 7

Verificar que el perfil se agregó correctamente:

```powershell
Add-ColorScriptProfile
Get-Content $PROFILE.CurrentUserAllHosts | Select-String "ColorScripts-Enhanced"
```

### EXAMPLE 8

Agregar a un alcance de perfil específico apuntando solo al host actual:

```powershell
# Solo para Windows Terminal o ConEmu
Add-ColorScriptProfile -Scope CurrentUserCurrentHost

# Para todos los hosts de PowerShell (ISE, VSCode, Consola)
Add-ColorScriptProfile -Scope CurrentUserAllHosts
```

### EXAMPLE 9

Usando rutas relativas y expansión de tilde:

```powershell
# Usando expansión de tilde para el directorio home
Add-ColorScriptProfile -Path "~/Documents/PowerShell/profile.ps1"

# Usando ruta relativa del directorio actual
Add-ColorScriptProfile -Path ".\my-profile.ps1"
```

### EXAMPLE 10

Mostrar un colorscript diferente diariamente agregando lógica personalizada:

```powershell
Add-ColorScriptProfile -SkipStartupScript
# Luego agregar esto a $PROFILE manualmente:
# $seed = (Get-Date).DayOfYear
# Get-Random -SetSeed $seed
# Show-ColorScript
```

## PARAMETERS

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

Agrega el fragmento incluso si el perfil ya contiene una línea `Import-Module ColorScripts-Enhanced`. Use esto para forzar entradas duplicadas o volver a agregar el fragmento después de la eliminación manual.

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

Muestra información de ayuda para este cmdlet. Equivalente a usar `Get-Help Add-ColorScriptProfile`.

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

### -Path

Ruta explícita del perfil a actualizar. Anula `-Scope` cuando se proporciona. Admite variables de entorno (ej. `$env:USERPROFILE`), rutas relativas y expansión de `~` para el directorio home.

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

### -Scope

Alcance del perfil a actualizar cuando no se proporciona `-Path`. Acepta las propiedades estándar de perfil de PowerShell: `CurrentUserAllHosts`, `CurrentUserCurrentHost`, `AllUsersAllHosts` o `AllUsersCurrentHost`. El valor predeterminado es `CurrentUserAllHosts`.

```yaml
Type: System.String
DefaultValue: 'CurrentUserAllHosts'
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

### -SkipStartupScript

Omitir agregar `Show-ColorScript` al perfil. Solo se agrega la línea `Import-Module ColorScripts-Enhanced`. Use esto si desea controlar manualmente cuándo se muestran los colorscripts.

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

Muestra qué sucedería si se ejecuta el cmdlet. El cmdlet no se ejecuta.

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

Este cmdlet admite los parámetros comunes: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, y -WarningVariable. Para más información, consulte
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

Este cmdlet no acepta entrada de pipeline.

## OUTPUTS

### System.Object

Devuelve un objeto personalizado con las siguientes propiedades:
- **ProfilePath** (string): La ruta completa al archivo de perfil modificado
- **Changed** (bool): Si el perfil fue realmente modificado
- **Message** (string): Un mensaje de estado que describe el resultado de la operación

## NOTES

**Author:** Nick
**Module:** ColorScripts-Enhanced
**Requires:** PowerShell 5.1 o posterior

El archivo de perfil se crea automáticamente si no existe, incluyendo los directorios padre necesarios. Las importaciones duplicadas se detectan y suprimen a menos que se use `-Force`.

Si necesita permisos elevados para modificar un perfil de AllUsers, asegúrese de ejecutar PowerShell como Administrador.

## RELATED LINKS

- [Online Version](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
- [Show-ColorScript](./Show-ColorScript.md)
- [New-ColorScriptCache](./New-ColorScriptCache.md)
- [Clear-ColorScriptCache](./Clear-ColorScriptCache.md)
- [GitHub Repository](https://github.com/Nick2bad4u/ps-color-scripts-enhanced)
