$esc = [char]27

$darkblue = "$esc[38;2;0;0;50m"
$purple = "$esc[38;2;50;0;50m"
$black = "$esc[38;2;0;0;0m"
$gray = "$esc[38;2;50;50;50m"
$navy = "$esc[38;2;0;0;25m"
$indigo = "$esc[38;2;25;0;50m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$darkblue████████╗$reset  $purple███████╗$reset  $black██████╗░$reset  $gray███╗░░░███╗$reset  $navy██╗$reset  $indigo███╗░░██╗$reset  $darkblue░█████╗░$reset  $purple██╗░░░░░$reset
$reset$purple╚══██╔══╝$reset  $black██╔════╝$reset  $gray██╔══██╗$reset  $navy████╗░████║$reset  $indigo██║$reset  $darkblue████╗░██║$reset  $purple██╔══██╗$reset  $black██║░░░░░$reset
$reset$black░░░██║░░░$reset  $gray█████╗░░$reset  $navy██████╔╝$reset  $indigo██╔████╔██║$reset  $darkblue██║$reset  $purple██╔██╗██║$reset  $black███████║$reset  $gray██║░░░░░$reset
$reset$gray░░░██║░░░$reset  $navy██╔══╝░░$reset  $indigo██╔══██╗$reset  $darkblue██║╚██╔╝██║$reset  $purple██║$reset  $black██║╚████║$reset  $gray██╔══██║$reset  $navy██║░░░░░$reset
$reset$navy░░░██║░░░$reset  $indigo███████╗$reset  $darkblue██║░░██║$reset  $purple██║░╚═╝░██║$reset  $black██║$reset  $gray██║░╚███║$reset  $navy██║░░██║$reset  $indigo███████╗$reset
$reset$indigo░░░╚═╝░░░$reset  $darkblue╚══════╝$reset  $purple╚═╝░░╚═╝$reset  $black╚═╝░░░░░╚═╝$reset  $gray╚═╝$reset  $navy╚═╝░░╚══╝$reset  $indigo╚═╝░░╚═╝$reset  $darkblue╚══════╝$reset
"@
