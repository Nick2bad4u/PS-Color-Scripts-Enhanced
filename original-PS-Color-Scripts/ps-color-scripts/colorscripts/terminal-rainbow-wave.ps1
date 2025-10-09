# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27

$red = "$esc[38;2;255;0;0m"
$orange = "$esc[38;2;255;165;0m"
$yellow = "$esc[38;2;255;255;0m"
$green = "$esc[38;2;0;255;0m"
$blue = "$esc[38;2;0;0;255m"
$indigo = "$esc[38;2;75;0;130m"
$violet = "$esc[38;2;238;130;238m"
$cyan = "$esc[38;2;0;255;255m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$red████████╗$reset  $orange███████╗$reset  $yellow██████╗░$reset  $green███╗░░░███╗$reset  $blue██╗$reset  $indigo███╗░░██╗$reset  $violet░█████╗░$reset  $cyan██╗░░░░░$reset
$reset$orange╚══██╔══╝$reset  $yellow██╔════╝$reset  $green██╔══██╗$reset  $blue████╗░████║$reset  $indigo██║$reset  $violet████╗░██║$reset  $cyan██╔══██╗$reset  $red██║░░░░░$reset
$reset$yellow░░░██║░░░$reset  $green█████╗░░$reset  $blue██████╔╝$reset  $indigo██╔████╔██║$reset  $violet██║$reset  $cyan██╔██╗██║$reset  $red███████║$reset  $orange██║░░░░░$reset
$reset$green░░░██║░░░$reset  $blue██╔══╝░░$reset  $indigo██╔══██╗$reset  $violet██║╚██╔╝██║$reset  $cyan██║$reset  $red██║╚████║$reset  $orange██╔══██║$reset  $yellow██║░░░░░$reset
$reset$blue░░░██║░░░$reset  $indigo███████╗$reset  $violet██║░░██║$reset  $cyan██║░╚═╝░██║$reset  $red██║$reset  $orange██║░╚███║$reset  $yellow██║░░██║$reset  $green███████╗$reset
$reset$indigo░░░╚═╝░░░$reset  $violet╚══════╝$reset  $cyan╚═╝░░╚═╝$reset  $red╚═╝░░░░░╚═╝$reset  $orange╚═╝$reset  $yellow╚═╝░░╚══╝$reset  $green╚═╝░░╚═╝$reset  $blue╚══════╝$reset

"@
