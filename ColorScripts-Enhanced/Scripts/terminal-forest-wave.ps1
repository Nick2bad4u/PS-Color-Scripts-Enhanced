# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27

$lime = "$esc[38;2;0;255;0m"
$green = "$esc[38;2;0;128;0m"
$darkgreen = "$esc[38;2;0;100;0m"
$olive = "$esc[38;2;128;128;0m"
$forestgreen = "$esc[38;2;34;139;34m"
$seagreen = "$esc[38;2;46;139;87m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$lime████████╗$reset  $green███████╗$reset  $darkgreen██████╗░$reset  $olive███╗░░░███╗$reset  $forestgreen██╗$reset  $seagreen███╗░░██╗$reset  $lime░█████╗░$reset  $green██╗░░░░░$reset
$reset$green╚══██╔══╝$reset  $darkgreen██╔════╝$reset  $olive██╔══██╗$reset  $forestgreen████╗░████║$reset  $seagreen██║$reset  $lime████╗░██║$reset  $green██╔══██╗$reset  $darkgreen██║░░░░░$reset
$reset$darkgreen░░░██║░░░$reset  $olive█████╗░░$reset  $forestgreen██████╔╝$reset  $seagreen██╔████╔██║$reset  $lime██║$reset  $green██╔██╗██║$reset  $darkgreen███████║$reset  $olive██║░░░░░$reset
$reset$olive░░░██║░░░$reset  $forestgreen██╔══╝░░$reset  $seagreen██╔══██╗$reset  $lime██║╚██╔╝██║$reset  $green██║$reset  $darkgreen██║╚████║$reset  $olive██╔══██║$reset  $forestgreen██║░░░░░$reset
$reset$forestgreen░░░██║░░░$reset  $seagreen███████╗$reset  $lime██║░░██║$reset  $green██║░╚═╝░██║$reset  $darkgreen██║$reset  $olive██║░╚███║$reset  $forestgreen██║░░██║$reset  $seagreen███████╗$reset
$reset$seagreen░░░╚═╝░░░$reset  $lime╚══════╝$reset  $green╚═╝░░╚═╝$reset  $darkgreen╚═╝░░░░░╚═╝$reset  $olive╚═╝$reset  $forestgreen╚═╝░░╚══╝$reset  $seagreen╚═╝░░╚═╝$reset  $lime╚══════╝$reset

"@
