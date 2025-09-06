$esc = [char]27

$neonGreen = "$esc[38;2;57;255;20m"
$neonBlue = "$esc[38;2;0;191;255m"
$neonPink = "$esc[38;2;255;20;147m"
$neonOrange = "$esc[38;2;255;69;0m"
$neonYellow = "$esc[38;2;255;255;0m"
$neonPurple = "$esc[38;2;186;85;211m"
$neonRed = "$esc[38;2;255;0;0m"
$neonCyan = "$esc[38;2;0;255;255m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$neonGreen████████╗$reset  $neonBlue███████╗$reset  $neonPink██████╗░$reset  $neonOrange███╗░░░███╗$reset  $neonYellow██╗$reset  $neonPurple███╗░░██╗$reset  $neonRed░█████╗░$reset  $neonCyan██╗░░░░░$reset
$reset$neonGreen╚══██╔══╝$reset  $neonBlue██╔════╝$reset  $neonPink██╔══██╗$reset  $neonOrange████╗░████║$reset  $neonYellow██║$reset  $neonPurple████╗░██║$reset  $neonRed██╔══██╗$reset  $neonCyan██║░░░░░$reset
$reset$neonGreen░░░██║░░░$reset  $neonBlue█████╗░░$reset  $neonPink██████╔╝$reset  $neonOrange██╔████╔██║$reset  $neonYellow██║$reset  $neonPurple██╔██╗██║$reset  $neonRed███████║$reset  $neonCyan██║░░░░░$reset
$reset$neonGreen░░░██║░░░$reset  $neonBlue██╔══╝░░$reset  $neonPink██╔══██╗$reset  $neonOrange██║╚██╔╝██║$reset  $neonYellow██║$reset  $neonPurple██║╚████║$reset  $neonRed██╔══██║$reset  $neonCyan██║░░░░░$reset
$reset$neonGreen░░░██║░░░$reset  $neonBlue███████╗$reset  $neonPink██║░░██║$reset  $neonOrange██║░╚═╝░██║$reset  $neonYellow██║$reset  $neonPurple██║░╚███║$reset  $neonRed██║░░██║$reset  $neonCyan███████╗$reset
$reset$neonGreen░░░╚═╝░░░$reset  $neonBlue╚══════╝$reset  $neonPink╚═╝░░╚═╝$reset  $neonOrange╚═╝░░░░░╚═╝$reset  $neonYellow╚═╝$reset  $neonPurple╚═╝░░╚══╝$reset  $neonRed╚═╝░░╚═╝$reset  $neonCyan╚══════╝$reset

"@
