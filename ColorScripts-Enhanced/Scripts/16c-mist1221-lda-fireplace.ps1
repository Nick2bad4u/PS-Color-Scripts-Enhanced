# Converted from: LDA-FIREPLACE.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/mist1221/raw/LDA-FIREPLACE.ANS
# Source Revision: archive-sha256:5e9313825592ee844db1dbb5f288429b09b14a6176d448c30ff1c2ee32395d09
# Source SHA-256: 125309b96b487ba371e4314c0382b75adc4cd043df683ad1171453f35ce8b09d
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: LDA-FIREPLACE.ANS by LDA (Mistigris); released in mist1221 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: Fireplace
# SAUCE Author: LDA
# SAUCE Group: Mistigris
# SAUCE Date: 20211221
# SAUCE Dimensions: 80x25
# SAUCE Font: IBM VGA
# SAUCE Comments: 100% home-grown textiness. No preservatives or artificial charac | ters.
# Lines: 1-25
# Columns: 1-80

Write-Host '


                                    [31m░[0;37m        [0;31m░[0m
[37m                  [0;31m░       ▒▒▒▓▓▓▓▓▓▓▓[0;37m        [0;31m▒▓▓▓▓▄░[0;37m      [0;31m▒░░[0m
[37m               [0;31m░░▓▓       ░▓▓▓▓▓▓▓██▌[0;37m        [0;31m▓█████▌[0;37m      [0;31m████▒▒░[0m
[37m               [0;31m▒▒██▌[0;37m       [0;31m██████████[0;37m         [0;31m▀█████[0;37m      [0;31m█████▓▒[0m
[37m               [0;31m▓███▌[0;37m        [0;31m▀████████[0;37m           [0;31m▀███[0;37m       [0;31m▀▀██▓▓[0m
[37m               [0;31m▓████[0;37m           [0;31m▀██████[0;37m           [0;31m███[0;37m          [0;31m██▓[0m
[37m               [0;31m▓████▄[0;37m           [0;31m████████▄▄▄[0;37m    [0;31m▄█████▄[0;37m        [0;31m██▓[0m
[37m               [0;31m███████▄▄[0;37m      [0;31m▄█████[0;1;31;41m░[0;31m██████[0;1;33m░[0;33;41m░[0;31;40m███████████▄▄▄▄█████[0m
[37;40m               [0;31;40m███████████████[0;1;33;41m▒[0;33;41m▄[0;31;40m▀[0;37;40m [0;31;40m░▀[0;1;31;40m▀▀[0;1;31;41m▒▄▄[0;1;33;41m░[0;31m█[0;33;41m▄[0;1;33;40m█[0;33;41m▌[0;31;40m▓▓█████████████████[0m
[37;40m               [0;31;40m▓█████████████[0;1;31;41m▄[0;1;37;43m▓[0;1;33;40m█[0;1;31;40m▄[0m    [31m░░[0;37m [0;1;31m▄▄█[0;1;37;43m▒▓[0;1;33;40m█[0;1;31;41m▄[0;31m▒▒▒▀▀  [0;1;31m▓▀[0;1;33;41m░[0;31m███████▓[0m
[37m               [0;31m▓███████████[0;1;31;41m▀▀[0;1;33;40m█[0;1;37;43m█[0;1;33;43m▀[0;1;31;41m▄[0;1;33;41m░[0;1;31;40m▀▀[0;31m▀▀▒▒▀[0;37m   [0;31m░░▀[0;1;33;41m░[0;1;31;40m▄■▀[0;31m [0;1;31m░░[0m  [1;33;41m▒[0;1;31;41m▓[0;31m██████▓[0m
[37m               [0;31m▓█████[0;1;31;41m    [0;31m▄▄[0;1;31m▄▄[0m  [1;31m▄[0;1;33;41m▒[0;1;31;40m░[0m [1;31m▄■░[0m [1;31m▄[0;1;33;41m░[0;1;31;41m▀[0;31m▄[0;37m   [0;31m░░[0;1;31m▄[0;1;33;41m▒[0;1;31;40m■▄▄[0;31m▄[0;1;31m▄▄[0;31m▄[0;1;31;41m▀[0;31m█████▀▓[0m
[37m               [0;31m██[0;37m  [0;31m██▀▀██▀▒███[0;1;31;41m▀▒▒■▄[0;31m█[0;1;31;41m▀▀░░[0;31m█▄[0;1;31m▄[0;31m▄▄▄▄[0;1;31;41m░▀▀[0;31m████▀▀███[0;37m  [0;31m█▓[0m
[37m                [0;31m▀[0;37m  [0;31m▓█[0;37m  [0;31m██[0;37m  [0;31m██[0;37m [0;31m░███[0;37m [0;31m`███"[0;37m [0;31m███[0;37m  [0;31m███[0;37m  [0;31m███[0;37m  [0;31m███[0;37m  [0;31m█░[0m
[37m               [0;31m░  ░░░[0;37m  [0;31m░▀[0;37m  [0;31m██[0;37m  [0;31m███[0;37m  [0;31m███[0;37m  [0;31m███[0;37m  [0;31m███[0;37m  [0;31m█▓▓[0;37m  [0;31m▀▀░░[0;37m    [0;31m░[0m
[37m               [0;31m▒▒▒▒▓▓▄▄▄▄[0;37m       [0;31m░░[0;37m  [0;31m░░░[0;37m  [0;31m░░░░[0;37m  [0;31m░░░[0;37m    [0;31m░░[0;37m [0;31m▄▄▄▄▒▒▒▒[0m
[37m             [0;31m░░░░▀▀▀▀▓▓▓▓▓▓▓▓▓██▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓▓▓▓▓▓██▓▓▓▀▀φlda[0m
[37m                         [0;31m▀▀▀▀▀▓▓▓▓▓▓▓▓▓▓███████████▀▀▀▀▀▀▀[0m



[37m                       [0;30madded at the last minute for textiness...  ilu burpy[0m'
