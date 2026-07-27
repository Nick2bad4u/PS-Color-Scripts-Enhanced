# Converted from: GERONIMOE-ALIEN.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/mist0222/raw/GERONIMOE-ALIEN.ANS
# Source Revision: archive-sha256:298b44b8b7049e43debc6d372a2843121b005521ff5ef92f5442efdcf0a21843
# Source SHA-256: 244ec50509ed68857a8602a965b3fb0793a2833be819af83ebff07d4edf57996
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: GERONIMOE-ALIEN.ANS by geronimoe (Mistigris); released in mist0222 and preserved by 16colors.
# Source Modification: Decoded from the attributed archive source and serialized from the rendered terminal cell matrix; project curation removes trailing rendered-blank rows plus standalone written-text and policy-ineligible display cells when present, while preserving retained ANSI controls, terminal-art glyphs, row geometry, and source coordinates.
# SAUCE Title: alien love
# SAUCE Author: geronimoe
# SAUCE Group: Mistigris
# SAUCE Date: 20220226
# SAUCE Dimensions: 80x210
# SAUCE Font: IBM VGA
# Lines: 199-209
# Columns: 1-80

Write-Host '
              [31m▄███▀▀▓▓▓▄[0;37m  [0;31m▓▓▓[0;37m         [0;31m▓▓▓ ▀███▀▀▀▓▓▓▄ ▄▓▓▓▄▄▄▄▄[0m
[37m              [0;31m▓▓▓▓[0;37m   [0;31m███[0;37m  [0;31m███[0;37m         [0;31m▄▄▄[0;37m  [0;31m███[0;37m   [0;31m████  ███[0;37m  [0;31m▀▓▓▓▄[0m
[37m                     [0;31m█[0;1;35;41m░[0;31m█[0;37m  [0;31m█[0;1;35;41m░[0;31;46m▓[0;37;40m         [0;31;40m█[0;1;35;41m░[0;31;46m▓[0;37;40m  [0;31;40m█[0;1;35;41m░[0;31;46m▓[0;37;40m   [0;31;40m▀▀▀▀  █[0;1;35;41m░[0;31m█[0;37m    [0;31m█[0;1;35;41m░[0;31;46m▓[0m
[37;40m             [0;31;40m▄[0;1;35;41m ░░[0;31m▀▀▀▀█[0;1;35;41m▒[0;31m█▀[0;37m [0;31;46m▓[0;1;35;41m▒[0;31;46m▒[0;37;40m         [0;31;46m▓[0;1;35;41m▒[0;31;46m▒[0;37;40m  [0;31;46m▓[0;1;35;41m▒[0;31;46m▒[0;31;40m▄▄       █[0;1;35;41m▒[0;31;46m▓[0;37;40m    [0;31;40m█[0;1;35;41m▒[0;31;46m▒[0m
[37;40m             [0;31;46m▓[0;1;35;41m░▒▒[0;1;30;40m    [0;31;46m▓[0;1;35;41m▓[0;31;46m▓[0;37;40m  [0;31;46m▒[0;1;35;41m▓[0;31;46m░[0;37;40m    [0;1;35;46m░░░ [0m [31;46m▒[0;1;35;41m▓[0;31;46m░[0;31;40m  [0;31;46m▒[0;1;35;41m▓[0;31;46m░[0;31;40m▀▀       [0;31;46m▓[0;1;35;41m▓[0;31;46m▒[0;37;40m    [0;31;46m▓[0;1;35;41m▓[0;31;46m░[0m
[37;40m             [0;31;46m░[0;1;35;41m▒▓▓[0;1;30;40m    [0;31;46m░[0;1;35;41m█[0;31;46m▒[0;37;40m  [0;31;46m░[0;1;35;41m█[0;31;46m [0;37;40m    [0;1;35;46m▓▓▓ [0m [31;46m░[0;1;35;41m█[0;31;46m [0;37;40m  [0;31;46m░[0;1;35;41m█[0;31;46m [0;37;40m    [0;1;35;46m▓▓▓[0;36;41m█[0;37;40m [0;31;46m▒[0;1;35;41m█[0;31;46m░[0;37;40m    [0;31;46m▒[0;1;35;41m█[0;31;46m [0m
[37;40m             [0;36;40m▀[0;1;35;46m▀██▄[0;36m▄[0;37m  [0;1;35;46m [0;1;35;41m█[0;31;46m░[0;37;40m  [0;31;46m [0;1;35;41m█[0;31;46m [0;37;40m  [0;36;40m▄[0;1;35;46m▄██▀[0;36m▀[0;37m [0;31;46m [0;1;35;41m█[0;31;46m [0;37;40m  [0;31;46m [0;1;35;41m█[0;31;46m [0;37;40m  [0;36;40m▄[0;1;35;46m▄██▀[0;36m▀[0;37m [0;31;46m░[0;1;35;41m█[0;31;46m [0;37;40m    [0;31;46m░[0;1;35;41m█[0;31;46m [0m
[37;40m               [0;36;40m▀▀▀▀▀▀[0;1;35;46m ▀ [0;36m▀[0;31m [0;31;46m [0;1;35;46m▀[0;31;46m [0;36;40m▀[0;1;35;40m▀▀▀▀[0;36m▀[0;37m   [0;31;46m [0;1;35;46m▀[0;31;46m [0;37;40m [0;36;40m▀[0;31;46m [0;1;35;46m▀[0;31;46m [0;36;40m▀[0;1;35;40m▀▀▀▀[0;36m▀[0;37m   [0;31;46m [0;1;35;46m▀ [0m    [31;46m [0;1;35;46m▀[0;31;46m [0m'
