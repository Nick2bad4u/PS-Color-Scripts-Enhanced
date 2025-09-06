$esc = [char]27

$red = "$esc[38;2;255;0;0m"
$orange = "$esc[38;2;255;165;0m"
$yellow = "$esc[38;2;255;255;0m"
$darkorange = "$esc[38;2;255;140;0m"
$crimson = "$esc[38;2;220;20;60m"
$gold = "$esc[38;2;255;215;0m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$red████████╗$reset  $orange███████╗$reset  $yellow██████╗░$reset  $darkorange███╗░░░███╗$reset  $crimson██╗$reset  $gold███╗░░██╗$reset  $red░█████╗░$reset  $orange██╗░░░░░$reset
$reset$orange╚══██╔══╝$reset  $yellow██╔════╝$reset  $darkorange██╔══██╗$reset  $crimson████╗░████║$reset  $gold██║$reset  $red████╗░██║$reset  $orange██╔══██╗$reset  $yellow██║░░░░░$reset
$reset$yellow░░░██║░░░$reset  $darkorange█████╗░░$reset  $crimson██████╔╝$reset  $gold██╔████╔██║$reset  $red██║$reset  $orange██╔██╗██║$reset  $yellow███████║$reset  $darkorange██║░░░░░$reset
$reset$darkorange░░░██║░░░$reset  $crimson██╔══╝░░$reset  $gold██╔══██╗$reset  $red██║╚██╔╝██║$reset  $orange██║$reset  $yellow██║╚████║$reset  $darkorange██╔══██║$reset  $crimson██║░░░░░$reset
$reset$crimson░░░██║░░░$reset  $gold███████╗$reset  $red██║░░██║$reset  $orange██║░╚═╝░██║$reset  $yellow██║$reset  $darkorange██║░╚███║$reset  $crimson██║░░██║$reset  $gold███████╗$reset
$reset$gold░░░╚═╝░░░$reset  $red╚══════╝$reset  $orange╚═╝░░╚═╝$reset  $yellow╚═╝░░░░░╚═╝$reset  $darkorange╚═╝$reset  $crimson╚═╝░░╚══╝$reset  $gold╚═╝░░╚═╝$reset  $red╚══════╝$reset

"@
