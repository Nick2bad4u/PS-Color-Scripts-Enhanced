$esc = [char]27

$orange = "$esc[38;2;255;165;0m"
$purple = "$esc[38;2;128;0;128m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$orange████████╗$reset  $purple███████╗$reset  $orange██████╗░$reset  $purple███╗░░░███╗$reset  $orange██╗$reset  $purple███╗░░██╗$reset  $orange░█████╗░$reset  $purple██╗░░░░░$reset
$reset$orange╚══██╔══╝$reset  $purple██╔════╝$reset  $orange██╔══██╗$reset  $purple████╗░████║$reset  $orange██║$reset  $purple████╗░██║$reset  $orange██╔══██╗$reset  $purple██║░░░░░$reset
$reset$orange░░░██║░░░$reset  $purple█████╗░░$reset  $orange██████╔╝$reset  $purple██╔████╔██║$reset  $orange██║$reset  $purple██╔██╗██║$reset  $orange███████║$reset  $purple██║░░░░░$reset
$reset$orange░░░██║░░░$reset  $purple██╔══╝░░$reset  $orange██╔══██╗$reset  $purple██║╚██╔╝██║$reset  $orange██║$reset  $purple██║╚████║$reset  $orange██╔══██║$reset  $purple██║░░░░░$reset
$reset$orange░░░██║░░░$reset  $purple███████╗$reset  $orange██║░░██║$reset  $purple██║░╚═╝░██║$reset  $orange██║$reset  $purple██║░╚███║$reset  $orange██║░░██║$reset  $purple███████╗$reset
$reset$orange░░░╚═╝░░░$reset  $purple╚══════╝$reset  $orange╚═╝░░╚═╝$reset  $purple╚═╝░░░░░╚═╝$reset  $orange╚═╝$reset  $purple╚═╝░░╚══╝$reset  $orange╚═╝░░╚═╝$reset  $purple╚══════╝$reset
"@
