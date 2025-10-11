# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27

$lightblue = "$esc[38;2;173;216;230m"
$cyan = "$esc[38;2;0;255;255m"
$blue = "$esc[38;2;0;0;255m"
$darkblue = "$esc[38;2;0;0;139m"
$teal = "$esc[38;2;0;128;128m"
$deepblue = "$esc[38;2;0;0;100m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$lightblue████████╗$reset  $cyan███████╗$reset  $blue██████╗░$reset  $darkblue███╗░░░███╗$reset  $teal██╗$reset  $deepblue███╗░░██╗$reset  $lightblue░█████╗░$reset  $cyan██╗░░░░░$reset
$reset$cyan╚══██╔══╝$reset  $blue██╔════╝$reset  $darkblue██╔══██╗$reset  $teal████╗░████║$reset  $deepblue██║$reset  $lightblue████╗░██║$reset  $cyan██╔══██╗$reset  $blue██║░░░░░$reset
$reset$blue░░░██║░░░$reset  $darkblue█████╗░░$reset  $teal██████╔╝$reset  $deepblue██╔████╔██║$reset  $lightblue██║$reset  $cyan██╔██╗██║$reset  $blue███████║$reset  $darkblue██║░░░░░$reset
$reset$darkblue░░░██║░░░$reset  $teal██╔══╝░░$reset  $deepblue██╔══██╗$reset  $lightblue██║╚██╔╝██║$reset  $cyan██║$reset  $blue██║╚████║$reset  $darkblue██╔══██║$reset  $teal██║░░░░░$reset
$reset$teal░░░██║░░░$reset  $deepblue███████╗$reset  $lightblue██║░░██║$reset  $cyan██║░╚═╝░██║$reset  $blue██║$reset  $darkblue██║░╚███║$reset  $teal██║░░██║$reset  $deepblue███████╗$reset
$reset$deepblue░░░╚═╝░░░$reset  $lightblue╚══════╝$reset  $cyan╚═╝░░╚═╝$reset  $blue╚═╝░░░░░╚═╝$reset  $darkblue╚═╝$reset  $teal╚═╝░░╚══╝$reset  $deepblue╚═╝░░╚═╝$reset  $lightblue╚══════╝$reset

"@
