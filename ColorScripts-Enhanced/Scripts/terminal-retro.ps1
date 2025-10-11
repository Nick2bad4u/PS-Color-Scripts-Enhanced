# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27

$green = "$esc[32m"
$blackbg = "$esc[40m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon$blackbg
$reset$green████████╗  ███████╗  ██████╗░  ███╗░░░███╗  ██╗  ███╗░░██╗  ░█████╗░  ██╗░░░░░
$reset$green╚══██╔══╝  ██╔════╝  ██╔══██╗  ████╗░████║  ██║  ████╗░██║  ██╔══██╗  ██║░░░░░
$reset$green░░░██║░░░  █████╗░░  ██████╔╝  ██╔████╔██║  ██║  ██╔██╗██║  ███████║  ██║░░░░░
$reset$green░░░██║░░░  ██╔══╝░░  ██╔══██╗  ██║╚██╔╝██║  ██║  ██║╚████║  ██╔══██║  ██║░░░░░
$reset$green░░░██║░░░  ███████╗  ██║░░██║  ██║░╚═╝░██║  ██║  ██║░╚███║  ██║░░██║  ███████╗
$reset$green░░░╚═╝░░░  ╚══════╝  ╚═╝░░╚═╝  ╚═╝░░░░░╚═╝  ╚═╝  ╚═╝░░╚══╝  ╚═╝░░╚═╝  ╚══════╝

"@
