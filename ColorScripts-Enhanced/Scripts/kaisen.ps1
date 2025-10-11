# Check cache first for instant output
if (. (Join-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -ChildPath 'ColorScriptCache.ps1')) { return }

$esc = [char]27
$redfbright = "$esc[91m"
$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"

$boldon$redfbright                                          ░▓▓
$boldon$redfbright                                       ▓▓▓▓▓▓▓▓▓
$boldon$redfbright                                ▓░  ▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright                              ▓▓▓  ▓▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright                        ▓    ▓▓▓   ▓▒      ░▓▓▓▓▓
$boldon$redfbright                      ▒▓▓   ▓▓▓▓          ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒
$boldon$redfbright                      ▓▓▓  ▓▓▓▓▓   ▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright                      ▓▓▓▓▒▓▓▓▓▓ ▓▓▓▓▒   ▓▓░      ▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright                     ▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                   ▒▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright                     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ░▓▓▓▓     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright                     ▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    ▓▓▓▓▓▓▓▓▓▓          ▓
$boldon$redfbright                     ▓▓▓▓▓ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▒▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright                    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ░▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright                   ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright            ▓     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   ▓▓▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright           ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░   ▓▓▓▓▓▓▓▓▓▒           ▓▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright            ▓▓▓▓▓▓▓▓▓▓▓▓▓▓     ▓▓▓▓▓▓▓     ▓▓▓▓▓▓▓▓▓▓ ░▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright            ▓▓▓▓▓▓▓▓▓▓▓▓       ▓▓▓▓▓░    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright             ▓▓▓▓▓ ▓▓  ▒     ▓▓▓▓▓▓▓         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒
$boldon$redfbright               ▓▓▓       ▓▓▓▓▓▓▓▓▓▓            ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright                       ▓▓▓▓▓▓▓  ▒▓▓            ▓▓▓▓▓▓▓▓▓▓▓▓      ▓▓
$boldon$redfbright                    ▓▓▓▓▓▓▓▓                  ▓▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright                      ▓▓▓▓▓▓                ▓▓▓▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright                         ▓▓▓▓▓          ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
$boldon$redfbright                                   ░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓       $reset

"@
