# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27
Write-Host
for ($f = 0; $f -le 6; $f++) {
    Write-Host -NoNewline "$esc[$(($f+41))m$esc[$(($f+30))m██▓▒░"
}
Write-Host "$esc[37m██$esc[0m"
Write-Host
for ($f = 0; $f -le 6; $f++) {
    Write-Host -NoNewline "$esc[$(($f+41))m$esc[1;$(($f+90))m██▓▒░"
}
Write-Host "$esc[1;37m██$esc[0m"
Write-Host
