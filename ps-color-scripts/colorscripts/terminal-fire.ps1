$esc = [char]27

$deepRed = "$esc[38;2;139;0;0m"
$red = "$esc[38;2;255;0;0m"
$orangeRed = "$esc[38;2;255;69;0m"
$orange = "$esc[38;2;255;140;0m"
$darkOrange = "$esc[38;2;255;165;0m"
$yellow = "$esc[38;2;255;255;0m"
$lightYellow = "$esc[38;2;255;255;102m"
$fireRed = "$esc[38;2;178;34;34m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$deepRed████████╗$reset  $red███████╗$reset  $orangeRed██████╗░$reset  $orange███╗░░░███╗$reset  $darkOrange██╗$reset  $yellow███╗░░██╗$reset  $lightYellow░█████╗░$reset  $fireRed██╗░░░░░$reset
$reset$deepRed╚══██╔══╝$reset  $red██╔════╝$reset  $orangeRed██╔══██╗$reset  $orange████╗░████║$reset  $darkOrange██║$reset  $yellow████╗░██║$reset  $lightYellow██╔══██╗$reset  $fireRed██║░░░░░$reset
$reset$deepRed░░░██║░░░$reset  $red█████╗░░$reset  $orangeRed██████╔╝$reset  $orange██╔████╔██║$reset  $darkOrange██║$reset  $yellow██╔██╗██║$reset  $lightYellow███████║$reset  $fireRed██║░░░░░$reset
$reset$deepRed░░░██║░░░$reset  $red██╔══╝░░$reset  $orangeRed██╔══██╗$reset  $orange██║╚██╔╝██║$reset  $darkOrange██║$reset  $yellow██║╚████║$reset  $lightYellow██╔══██║$reset  $fireRed██║░░░░░$reset
$reset$deepRed░░░██║░░░$reset  $red███████╗$reset  $orangeRed██║░░██║$reset  $orange██║░╚═╝░██║$reset  $darkOrange██║$reset  $yellow██║░╚███║$reset  $lightYellow██║░░██║$reset  $fireRed███████╗$reset
$reset$deepRed░░░╚═╝░░░$reset  $red╚══════╝$reset  $orangeRed╚═╝░░╚═╝$reset  $orange╚═╝░░░░░╚═╝$reset  $darkOrange╚═╝$reset  $yellow╚═╝░░╚══╝$reset  $lightYellow╚═╝░░╚═╝$reset  $fireRed╚══════╝$reset

"@
