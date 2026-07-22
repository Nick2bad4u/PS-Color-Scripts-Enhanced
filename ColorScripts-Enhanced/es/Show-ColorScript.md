---
document type: cmdlet
external help file: ColorScripts-Enhanced-help.xml
HelpUri: https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript
Locale: es
Module Name: ColorScripts-Enhanced
ms.date: 07/22/2026
PlatyPS schema version: 2024-05-01
title: Show-ColorScript
---

# Show-ColorScript

## SYNOPSIS

Muestra un script de colores con almacenamiento en caché selectivo para renderizadores costosos.

## SYNTAX

### Random (Default)

```
Show-ColorScript [-Random] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Help

```
Show-ColorScript [-h] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### Named

```
Show-ColorScript [[-Name] <string>] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-PassThru] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### List

```
Show-ColorScript [-List] [-NoCache] [-Category <string[]>] [-Tag <string[]>]
 [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet] [-NoAnsiOutput]
 [-ValidateCache]
```

### All

```
Show-ColorScript [-All] [-WaitForInput] [-NoClear] [-NoCache] [-Category <string[]>]
 [-Tag <string[]>] [-ExcludeCategory <string[]>] [-IncludePokemon] [-ReturnText] [-Quiet]
 [-NoAnsiOutput] [-ValidateCache]
```

## ALIASES

- `scs`

## DESCRIPTION

Renderiza atractivos scripts de colores ANSI en el terminal con una optimización inteligente del rendimiento. El cmdlet proporciona cuatro modos principales de funcionamiento:

**Modo aleatorio (predeterminado):** Muestra un script de colores seleccionado aleatoriamente de la colección disponible. Este es el comportamiento predeterminado cuando no se especifica ningún parámetro.

**Modo con nombre:** Muestra un script de colores específico por nombre. Admite patrones comodín para una coincidencia flexible. Cuando varios scripts coinciden con un patrón, se selecciona la primera coincidencia en orden alfabético.

**Modo de lista:** Muestra una tabla compacta con los nombres de los scripts de colores y sus categorías principales. Utilice `Get-ColorScriptList -AsObject` para obtener registros de metadatos completos.

**Modo Todos:** Recorre todos los scripts de colores disponibles en orden alfabético. Resulta especialmente útil para exhibir toda la colección o descubrir nuevos scripts.

## EXAMPLES

### EXAMPLE 1

```powershell
Show-ColorScript
```

Muestra un script de colores aleatorio. Renderizado determinista scripts en proceso; Los renderizadores computacionales elegibles pueden reutilizar la salida en caché validada.

### EXAMPLE 2

```powershell
Show-ColorScript -Name "mandelbrot-zoom"
```

Muestra el script de colores especificado por nombre exacto. La extensión .ps1 no es necesaria.

### EXAMPLE 3

```powershell
Show-ColorScript -Name "aurora-*"
```

Muestra el primer script de colores (alfabéticamente) que coincide con el patrón comodín "aurora-\*". Útil cuando recuerdas parte del nombre de un script.

### EXAMPLE 4

```powershell
scs hearts
```

Utiliza el alias del módulo 'scs' para un acceso rápido a los corazones script de colores. Los alias proporcionan atajos convenientes para uso frecuente.

### EXAMPLE 5

```powershell
Show-ColorScript -List
```

Muestra los scripts de colores disponibles por nombre y categoría principal. Útil para un descubrimiento rápido.

### EXAMPLE 6

```powershell
Show-ColorScript -Name Galaxy -NoCache
```

Muestra el renderizador Galaxy elegible sin leer la salida en caché, lo que obliga a un renderizado nuevo y aislado. Útil al probar cambios en el renderizador o investigar daños en la caché.

### EXAMPLE 7

```powershell
Show-ColorScript -Category Nature -PassThru | Select-Object Name, Category
```

Muestra un script aleatorio con temática de naturaleza y captura su objeto de metadatos para su posterior inspección o procesamiento.

### EXAMPLE 8

```powershell
Show-ColorScript -Name "bars" -ReturnText | Set-Content bars.txt
```

Representa el script de colores y guarda el resultado en un archivo de texto. Los códigos ANSI renderizados se conservan, lo que permite que el archivo se muestre más tarde con el color adecuado.

### EXAMPLE 9

```powershell
Show-ColorScript -All
```

Muestra todos los scripts de colores en orden alfabético con un breve retraso automático entre cada uno. Perfecto para una exhibición visual de toda la colección.

### EXAMPLE 10

```powershell
Show-ColorScript -All -WaitForInput
```

Muestra todos los scripts de colores uno a la vez, haciendo una pausa después de cada uno. Presione la barra espaciadora para avanzar al siguiente script, o presione 'q' para salir de la secuencia antes.

### EXAMPLE 11

```powershell
Show-ColorScript -All -Category Nature -WaitForInput
```

Recorre todos los scripts de colores con temas de naturaleza con progresión manual. Combina filtrado con navegación interactiva para una experiencia seleccionada.

### EXAMPLE 12

```powershell
Show-ColorScript -Tag retro,geometric -Random
```

Muestra un script de colores aleatorio que tiene la etiqueta "retro" o "geometric". Varios valores de etiquetas utilizan semántica de cualquier coincidencia.

### EXAMPLE 13

```powershell
Show-ColorScript -List -Category Artistic,Abstract
```

Enumera solo scripts de colores categorizado como "Art" o "Abstract", lo que le ayuda a descubrir scripts dentro de temas específicos.

### EXAMPLE 14

```powershell
# Inspeccionar la elegibilidad de la caché y el estado de compilación de un renderizador seleccionado por política.
New-ColorScriptCache -Name Galaxy -Force -PassThru |
    Select-Object Name, Status, CacheFile
Show-ColorScript -Name Galaxy
```

Crea e inspecciona una entrada de caché para un renderizador elegible sin reclamar un multiplicador de rendimiento independiente de la máquina.

### EXAMPLE 15

```powershell
# Configurar la rotación diaria de diferentes scripts de colores
$seed = (Get-Date).DayOfYear
Get-Random -SetSeed $seed
Show-ColorScript -Random -PassThru | Select-Object Name
```

Muestra un script de colores consistente pero diferente cada día según la fecha.

### EXAMPLE 16

```powershell
# Exportar el script de colores renderizado a un archivo para compartir
Show-ColorScript -Name "aurora-waves" -ReturnText |
    Out-File -FilePath "./aurora.ansi" -Encoding UTF8

# Más tarde, muestra el archivo guardado.
Get-Content "./aurora.ansi" -Raw | Write-Host
```

Guarda un script de colores renderizado en un archivo que se puede mostrar más tarde o compartir con otros.

### EXAMPLE 17

```powershell
# Crea una presentación de diapositivas de scripts de colores geométrico
Get-ColorScriptList -Category Geometric -AsObject |
    ForEach-Object {
        Show-ColorScript -Name $_.Name
        Start-Sleep -Seconds 3
    }
```

Muestra automáticamente una secuencia de scripts de colores geométricos con retrasos de 3 segundos entre cada uno.

### EXAMPLE 18

```powershell
# Ejemplo de manejo de errores
try {
    Show-ColorScript -Name "nonexistent-script" -ErrorAction Stop
} catch {
    Write-Warning "Script no encontrado: $_"
    Show-ColorScript  # Alternativa: mostrar una selección aleatoria
}
```

Demuestra el manejo de errores al solicitar un script que no existe.

### EXAMPLE 19

```powershell
# Construir integración de automatización
if ($env:CI) {
    Show-ColorScript -Name "Galaxy" -NoCache
} else {
    Show-ColorScript  # Visualización aleatoria para uso interactivo
}
```

Muestra cómo mostrar condicionalmente diferentes scripts de colores en entornos CI/CD frente a sesiones interactivas.

### EXAMPLE 20

```powershell
# Tarea programada para saludo de terminal
$scriptPath = "$(Get-Module ColorScripts-Enhanced).ModuleBase\Scripts\mandelbrot-zoom.ps1"
if (Test-Path $scriptPath) {
    & $scriptPath
} else {
    Show-ColorScript -Name mandelbrot-zoom
}
```

Demuestra cómo ejecutar un script de colores específico como parte de una tarea programada o automatización de inicio.

### EXAMPLE 21

```powershell
Show-ColorScript -IncludePokemon
```

Muestra un script de colores aleatorio que incluye scripts en la categoría `Pokemon`. Útil cuando quieres incluir arte Pokémon en tu selección aleatoria.

### EXAMPLE 22

```powershell
Show-ColorScript -Random -ExcludeCategory Pokemon,Gaming
```

Muestra un script de colores aleatorio y excluye las categorías `Pokemon` y `Gaming`. Combínelo con `-Category` o `-Tag` para refinar aún más la selección.

## PARAMETERS

### -All

Recorra todos los scripts de colores disponibles en orden alfabético. Cuando se especifica solo, scripts se muestra continuamente con un breve retraso automático. Combínelo con `-WaitForInput` para controlar manualmente la progresión a través de la colección. Este modo es ideal para mostrar la biblioteca completa o descubrir nuevos favoritos.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Category

Filtre la colección script disponible por una o más categorías antes de que se produzca cualquier selección o visualización. Las categorías suelen ser temas amplios como "Nature", "Abstract", "Art", "Retro", etc. Se pueden especificar varias categorías como una matriz. Este parámetro funciona junto con todos los modos (Aleatorio, Con nombre, Lista, Todos) para limitar el conjunto de trabajo.

```yaml
Type: System.String[]
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

### -ExcludeCategory

Excluya scripts de una o más categorías antes de que se produzca la selección. Por ejemplo, use `-ExcludeCategory Pokemon` para evitar todos los Pokémon scripts o especifique varias categorías, como `-ExcludeCategory Pokemon,Gaming`. Funciona en todos los modos (Aleatorio, Con nombre, Lista, Todos) y se combina con los filtros `-Category` y `-Tag`.

```yaml
Type: System.String[]
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

Muestra ayuda detallada para este comando sin realizar la operación.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- help
ParameterSets:
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

### -IncludePokemon

Marca de suscripción para incluir Pokémon scripts de colores en la selección. Cuando se omite, los Pokémon scripts se filtran automáticamente (predeterminado). Nota: esto reemplaza el antiguo parámetro `-ExcludePokemon`: la semántica invertida de refactorización, por lo que ahora puedes optar por mostrar Pokémon scripts en lugar de optar por no participar.

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

### -List

Muestra una lista formateada de todos los scripts de colores disponibles con sus metadatos asociados. El resultado incluye el nombre, la categoría, las etiquetas y la descripción de script. Esto es útil para explorar las opciones disponibles y comprender la organización de la colección. Se puede combinar con `-Category` o `-Tag` para enumerar solo los subconjuntos filtrados.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: List
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

El nombre del script de colores que se mostrará (sin la extensión .ps1). Admite patrones comodín (\* y ?) para una coincidencia flexible. Cuando varios scripts coinciden con un patrón comodín, se selecciona y muestra la primera coincidencia en orden alfabético. Utilice `-PassThru` para verificar qué script se eligió al utilizar comodines.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: true
Aliases: []
ParameterSets:
- Name: Named
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoAnsiOutput

Deshabilita el estilo ANSI en mensajes informativos y resultados renderizados para entornos de texto sin formato.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- NoColor
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

### -NoCache

Omite las lecturas de caché validadas para los renderizadores seleccionados por la política y fuerza un renderizado nuevo y aislado. Resulta útil para probar cambios en un renderizador o investigar daños en la caché. Los scripts empaquetados deterministas y los scripts no incluidos o personalizados ya omiten la caché; el contenido empaquetado determinista continúa renderizándose dentro del proceso.

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

### -NoClear

Cuando se usa con `-All`, omita la llamada automática de `Clear-Host` entre scripts de colores para que cada script renderizado permanezca visible encima del siguiente. Esto es particularmente útil cuando desea comparar scripts uno al lado del otro o capturar la presentación completa en las transcripciones de la sesión.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

Devuelve el objeto de metadatos del script de colores seleccionado a la canalización además de mostrar el script de colores. El objeto de metadatos contiene propiedades como Name, Path, Category, Tags y Description. Esto permite el acceso programático a la información de script para filtrar, registrar o procesar más mientras se sigue representando la salida visual.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Named
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Quiet

Suprime los mensajes informativos y al mismo tiempo preserva los resultados y los errores de los comandos.

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

### -Random

Solicite explícitamente una selección aleatoria de script de colores. Este es el comportamiento predeterminado cuando no se especifica ningún nombre, por lo que este modificador es principalmente útil para mayor claridad en scripts o cuando desea ser explícito sobre el modo de selección. Se puede combinar con `-Category` o `-Tag` para realizar aleatorización dentro de un subconjunto filtrado.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Random
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ReturnText

Emita el script de colores renderizado como string a la canalización PowerShell en lugar de escribir directamente en el host de la consola. Esto permite capturar la salida en una variable, redirigirla a un archivo o canalizarla a otros comandos. La salida conserva todas las secuencias de escape ANSI, por lo que se mostrará con los colores adecuados cuando luego se escriba en un terminal compatible.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases:
- AsString
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

### -Tag

Filtre la colección script disponible por etiquetas de metadatos (no distingue entre mayúsculas y minúsculas). Tags son descriptores más específicos que categorías, como "geometric", "retro", "animated", "minimal", etc. Se pueden especificar varias etiquetas como una matriz. Scripts que coincida con cualquiera de las etiquetas especificadas se incluirá en el conjunto de trabajo antes de que se produzca la selección.

```yaml
Type: System.String[]
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

### -ValidateCache

Actualiza el marcador de metadatos de caché a nivel de módulo antes de renderizar, incluso cuando el directorio de caché ya se inicializó en la sesión actual del módulo. No reconstruye las entradas de la caché de resultados ni reemplaza la validación normal por entrada. Configurar `COLOR_SCRIPTS_ENHANCED_VALIDATE_CACHE` en `1`, `true` o `yes` solicita la misma actualización durante la inicialización de la caché.

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

### -WaitForInput

Cuando se usa con `-All`, haga una pausa después de mostrar cada script de colores y espere la entrada del usuario antes de continuar. Presione la barra espaciadora para avanzar al siguiente script en la secuencia. Presione 'q' para salir de la secuencia antes y volver al mensaje. Esto proporciona una experiencia de navegación interactiva a través de toda la colección.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: All
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

Este cmdlet no acepta entradas de canalización. Canalice registros de inventario a `ForEach-Object` y llame a `Show-ColorScript -Name $_.Name` al componer una canalización.

## OUTPUTS

### System.Object

Cuando se especifica `-PassThru`, devuelve el objeto de metadatos del script de colores seleccionado que contiene propiedades como Name, Path, Category, Tags y Description.

### System.String (2)

Cuando se especifica `-ReturnText`, emite el script de colores renderizado como string a la canalización. Este string contiene todas las secuencias de escape ANSI para una reproducción cromática adecuada cuando se muestra en un terminal compatible.

### None

En la operación predeterminada (sin `-PassThru` o `-ReturnText`), la salida se escribe directamente en el host de la consola y no se devuelve nada a la canalización.

## NOTES

**Autor:** Nick
**Módulo:** ColorScripts-Enhanced
**Requiere:** PowerShell 5.1 o posterior

## RELATED LINKS

- [Versión en línea](https://nick2bad4u.github.io/PS-Color-Scripts-Enhanced/docs/help-redirect.html?cmdlet=Show-ColorScript)

