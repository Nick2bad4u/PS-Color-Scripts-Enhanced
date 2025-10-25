$esc = [char]27

$orange = "$esc[38;2;255;165;0m"
$pink = "$esc[38;2;255;192;203m"
$purple = "$esc[38;2;128;0;128m"
$red = "$esc[38;2;255;0;0m"
$peach = "$esc[38;2;255;218;185m"
$coral = "$esc[38;2;255;127;80m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$orange████████╗$reset  $pink███████╗$reset  $purple██████╗░$reset  $red███╗░░░███╗$reset  $peach██╗$reset  $coral███╗░░██╗$reset  $orange░█████╗░$reset  $pink██╗░░░░░$reset
$reset$pink╚══██╔══╝$reset  $purple██╔════╝$reset  $red██╔══██╗$reset  $peach████╗░████║$reset  $coral██║$reset  $orange████╗░██║$reset  $pink██╔══██╗$reset  $purple██║░░░░░$reset
$reset$purple░░░██║░░░$reset  $red█████╗░░$reset  $peach██████╔╝$reset  $coral██╔████╔██║$reset  $orange██║$reset  $pink██╔██╗██║$reset  $purple███████║$reset  $red██║░░░░░$reset
$reset$red░░░██║░░░$reset  $peach██╔══╝░░$reset  $coral██╔══██╗$reset  $orange██║╚██╔╝██║$reset  $pink██║$reset  $purple██║╚████║$reset  $red██╔══██║$reset  $peach██║░░░░░$reset
$reset$peach░░░██║░░░$reset  $coral███████╗$reset  $orange██║░░██║$reset  $pink██║░╚═╝░██║$reset  $purple██║$reset  $red██║░╚███║$reset  $peach██║░░██║$reset  $coral███████╗$reset
$reset$coral░░░╚═╝░░░$reset  $orange╚══════╝$reset  $pink╚═╝░░╚═╝$reset  $purple╚═╝░░░░░╚═╝$reset  $red╚═╝$reset  $peach╚═╝░░╚══╝$reset  $coral╚═╝░░╚═╝$reset  $orange╚══════╝$reset
"@
