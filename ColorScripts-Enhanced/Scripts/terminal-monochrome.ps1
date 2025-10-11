# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27

$white = "$esc[38;2;255;255;255m"
$lightGray = "$esc[38;2;224;224;224m"
$gray = "$esc[38;2;192;192;192m"
$mediumGray = "$esc[38;2;160;160;160m"
$darkGray = "$esc[38;2;128;128;128m"
$darkerGray = "$esc[38;2;96;96;96m"
$veryDarkGray = "$esc[38;2;64;64;64m"
$black = "$esc[38;2;32;32;32m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$white████████╗$reset  $lightGray███████╗$reset  $gray██████╗░$reset  $mediumGray███╗░░░███╗$reset  $darkGray██╗$reset  $darkerGray███╗░░██╗$reset  $veryDarkGray░█████╗░$reset  $black██╗░░░░░$reset
$reset$white╚══██╔══╝$reset  $lightGray██╔════╝$reset  $gray██╔══██╗$reset  $mediumGray████╗░████║$reset  $darkGray██║$reset  $darkerGray████╗░██║$reset  $veryDarkGray██╔══██╗$reset  $black██║░░░░░$reset
$reset$white░░░██║░░░$reset  $lightGray█████╗░░$reset  $gray██████╔╝$reset  $mediumGray██╔████╔██║$reset  $darkGray██║$reset  $darkerGray██╔██╗██║$reset  $veryDarkGray███████║$reset  $black██║░░░░░$reset
$reset$white░░░██║░░░$reset  $lightGray██╔══╝░░$reset  $gray██╔══██╗$reset  $mediumGray██║╚██╔╝██║$reset  $darkGray██║$reset  $darkerGray██║╚████║$reset  $veryDarkGray██╔══██║$reset  $black██║░░░░░$reset
$reset$white░░░██║░░░$reset  $lightGray███████╗$reset  $gray██║░░██║$reset  $mediumGray██║░╚═╝░██║$reset  $darkGray██║$reset  $darkerGray██║░╚███║$reset  $veryDarkGray██║░░██║$reset  $black███████╗$reset
$reset$white░░░╚═╝░░░$reset  $lightGray╚══════╝$reset  $gray╚═╝░░╚═╝$reset  $mediumGray╚═╝░░░░░╚═╝$reset  $darkGray╚═╝$reset  $darkerGray╚═╝░░╚══╝$reset  $veryDarkGray╚═╝░░╚═╝$reset  $black╚══════╝$reset

"@
