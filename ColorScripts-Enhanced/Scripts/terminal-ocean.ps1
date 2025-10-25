$esc = [char]27

$lightblue = "$esc[94m"
$darkblue = "$esc[34m"
$cyan = "$esc[96m"
$blue = "$esc[38;2;0;0;255m"
$teal = "$esc[38;2;0;128;128m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$lightblue████████╗$reset  $darkblue███████╗$reset  $cyan██████╗░$reset  $blue███╗░░░███╗$reset  $teal██╗$reset  $lightblue███╗░░██╗$reset  $darkblue░█████╗░$reset  $cyan██╗░░░░░$reset
$reset$lightblue╚══██╔══╝$reset  $darkblue██╔════╝$reset  $cyan██╔══██╗$reset  $blue████╗░████║$reset  $teal██║$reset  $lightblue████╗░██║$reset  $darkblue██╔══██╗$reset  $cyan██║░░░░░$reset
$reset$lightblue░░░██║░░░$reset  $darkblue█████╗░░$reset  $cyan██████╔╝$reset  $blue██╔████╔██║$reset  $teal██║$reset  $lightblue██╔██╗██║$reset  $darkblue███████║$reset  $cyan██║░░░░░$reset
$reset$lightblue░░░██║░░░$reset  $darkblue██╔══╝░░$reset  $cyan██╔══██╗$reset  $blue██║╚██╔╝██║$reset  $teal██║$reset  $lightblue██║╚████║$reset  $darkblue██╔══██║$reset  $cyan██║░░░░░$reset
$reset$lightblue░░░██║░░░$reset  $darkblue███████╗$reset  $cyan██║░░██║$reset  $blue██║░╚═╝░██║$reset  $teal██║$reset  $lightblue██║░╚███║$reset  $darkblue██║░░██║$reset  $cyan███████╗$reset
$reset$lightblue░░░╚═╝░░░$reset  $darkblue╚══════╝$reset  $cyan╚═╝░░╚═╝$reset  $blue╚═╝░░░░░╚═╝$reset  $teal╚═╝$reset  $lightblue╚═╝░░╚══╝$reset  $darkblue╚═╝░░╚═╝$reset  $cyan╚══════╝$reset
"@
