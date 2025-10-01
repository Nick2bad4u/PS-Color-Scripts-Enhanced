# Check cache first for instant output
if (. "$PSScriptRoot\..\ColorScriptCache.ps1") { return }

$esc = [char]27

$pastelRed = "$esc[38;2;255;179;186m"
$pastelOrange = "$esc[38;2;255;223;186m"
$pastelYellow = "$esc[38;2;255;255;186m"
$pastelGreen = "$esc[38;2;186;255;201m"
$pastelBlue = "$esc[38;2;186;225;255m"
$pastelPurple = "$esc[38;2;223;186;255m"
$pastelPink = "$esc[38;2;255;186;225m"
$pastelCyan = "$esc[38;2;186;255;255m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$pastelRed████████╗$reset  $pastelOrange███████╗$reset  $pastelYellow██████╗░$reset  $pastelGreen███╗░░░███╗$reset  $pastelBlue██╗$reset  $pastelPurple███╗░░██╗$reset  $pastelPink░█████╗░$reset  $pastelCyan██╗░░░░░$reset
$reset$pastelRed╚══██╔══╝$reset  $pastelOrange██╔════╝$reset  $pastelYellow██╔══██╗$reset  $pastelGreen████╗░████║$reset  $pastelBlue██║$reset  $pastelPurple████╗░██║$reset  $pastelPink██╔══██╗$reset  $pastelCyan██║░░░░░$reset
$reset$pastelRed░░░██║░░░$reset  $pastelOrange█████╗░░$reset  $pastelYellow██████╔╝$reset  $pastelGreen██╔████╔██║$reset  $pastelBlue██║$reset  $pastelPurple██╔██╗██║$reset  $pastelPink███████║$reset  $pastelCyan██║░░░░░$reset
$reset$pastelRed░░░██║░░░$reset  $pastelOrange██╔══╝░░$reset  $pastelYellow██╔══██╗$reset  $pastelGreen██║╚██╔╝██║$reset  $pastelBlue██║$reset  $pastelPurple██║╚████║$reset  $pastelPink██╔══██║$reset  $pastelCyan██║░░░░░$reset
$reset$pastelRed░░░██║░░░$reset  $pastelOrange███████╗$reset  $pastelYellow██║░░██║$reset  $pastelGreen██║░╚═╝░██║$reset  $pastelBlue██║$reset  $pastelPurple██║░╚███║$reset  $pastelPink██║░░██║$reset  $pastelCyan███████╗$reset
$reset$pastelRed░░░╚═╝░░░$reset  $pastelOrange╚══════╝$reset  $pastelYellow╚═╝░░╚═╝$reset  $pastelGreen╚═╝░░░░░╚═╝$reset  $pastelBlue╚═╝$reset  $pastelPurple╚═╝░░╚══╝$reset  $pastelPink╚═╝░░╚═╝$reset  $pastelCyan╚══════╝$reset

"@
