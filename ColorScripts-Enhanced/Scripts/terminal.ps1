# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27

$redfbright = "$esc[91m"
$greenfbright = "$esc[92m"
$yellowfbright = "$esc[93m"
$bluefbright = "$esc[94m"
$purplefbright = "$esc[95m"
$cyanfbright = "$esc[96m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$redfbright████████╗$reset  $greenfbright███████╗$reset  $yellowfbright██████╗░$reset  $bluefbright███╗░░░███╗$reset  $purplefbright██╗$reset  $cyanfbright███╗░░██╗$reset  $redfbright░█████╗░$reset  $greenfbright██╗░░░░░$reset
$reset$redfbright╚══██╔══╝$reset  $greenfbright██╔════╝$reset  $yellowfbright██╔══██╗$reset  $bluefbright████╗░████║$reset  $purplefbright██║$reset  $cyanfbright████╗░██║$reset  $redfbright██╔══██╗$reset  $greenfbright██║░░░░░$reset
$reset$redfbright░░░██║░░░$reset  $greenfbright█████╗░░$reset  $yellowfbright██████╔╝$reset  $bluefbright██╔████╔██║$reset  $purplefbright██║$reset  $cyanfbright██╔██╗██║$reset  $redfbright███████║$reset  $greenfbright██║░░░░░$reset
$reset$redfbright░░░██║░░░$reset  $greenfbright██╔══╝░░$reset  $yellowfbright██╔══██╗$reset  $bluefbright██║╚██╔╝██║$reset  $purplefbright██║$reset  $cyanfbright██║╚████║$reset  $redfbright██╔══██║$reset  $greenfbright██║░░░░░$reset
$reset$redfbright░░░██║░░░$reset  $greenfbright███████╗$reset  $yellowfbright██║░░██║$reset  $bluefbright██║░╚═╝░██║$reset  $purplefbright██║$reset  $cyanfbright██║░╚███║$reset  $redfbright██║░░██║$reset  $greenfbright███████╗$reset
$reset$redfbright░░░╚═╝░░░$reset  $greenfbright╚══════╝$reset  $yellowfbright╚═╝░░╚═╝$reset  $bluefbright╚═╝░░░░░╚═╝$reset  $purplefbright╚═╝$reset  $cyanfbright╚═╝░░╚══╝$reset  $redfbright╚═╝░░╚═╝$reset  $greenfbright╚══════╝$reset

"@
