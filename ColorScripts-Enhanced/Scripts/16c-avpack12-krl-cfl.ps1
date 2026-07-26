# Converted from: KRL-CFL.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/avpack12/raw/KRL-CFL.ANS
# Source Revision: archive-sha256:55286e18e28c272f11e63b1c16158d9df2657a21ca3df761a4c27630305acaa1
# Source SHA-256: d962e7ca21439e88b70476ed787167e27e3c3c4517fddeeb3a782251e88a5657
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: KRL-CFL.ANS by Mr Krinkle (Apocalyptic Visions); released in avpack12 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: Cheese Factory Logon
# SAUCE Author: Mr Krinkle
# SAUCE Group: Apocalyptic Visions
# SAUCE Date: 19960527
# SAUCE Dimensions: 80x25
# Lines: 1-22
# Columns: 1-80

Write-Host '

    [37;40m    ▄▄[0m                 [37;40m [0m     [1;33;40m▄▄[0m▄▄▄▄
  [1m  [0;1;47m▒[0;1;33;47m▒[0m▀▀[1;33;47m▓░[0;1;33;40m▄[0m▄ [1;30m░░▒[0;1;33m█[0;1;33;47m▓[0m▄▄  [1;33m█[0;1;33;47m▓[0m▄▄▄▄[1;33;47m▓░[0m▀ [1;30m░▒[0;1;33;47m▓▒[0m▄
    [1;33;47m▓░[0m  ▀▀[1;33;47m▓▒[0m  [1;47m▓[0;1;33;47m▓▒░[0m    [1;33;47m▓░[0m  [1;33m█[0;1;33;47m▒[0m▀▀▀▀[1;33;47m▒░▒░[0m [1;37;40m [0;1;37;47m▓[0;1;33;47m▓[0;36m  [0m
    [1;33;47m░[0m█  [1;33m█[0;1;33;47m▓░[0m█▀▀[1;33;47m▓░░[0;1;37;47m░[0m▀ [1;33;47m░[0m█[1;33;47m░[0m█▀   [1;33m▄▄[0m  [1;33;47m▓▒░[0m▓  [1;33;47m▒░[0;36m        [0m         [1;30m▄[0m
   ▄██▄▄[1;33;47m░[0m███ [1m░[0;1;33;47m░[0;1;37;47m░▒▒[0m▄▄██[1;33;47m░[0m▓[1;30m░[0m █[1;33;47m░▓▒[0m  [1;33;47m░[0m███▄▄[1;33;47m░[0m█▄[36m       [0m   [36m  [0;1;30m▄▄░▓█▀[0m
    ▀▀    ██  ▀▀[1m░░[0m    [1;33;47m▒░[0m▀▀▀▀[1;33;47m░[0m█▀▀▀▀   [36m [0;37m▀▀[0m [37m       [0m   [36m [0;1;30m█[0;1;30;47m▓░[0;1;30;40m█░[0m
                [1m  [0m [36m██▄▄▄▄██▄▄▄▄▓▓███████████████▓▒░ [0;1;30m ▀▀[0m
                [1m░░[0m [36m▓░[0m                            [35m  [0m  [36m ░[0m
                   [36m█[0m [37mname-[0m                       [35m [0m    [36m█[0m
[35m░░░░░░░░░░░░░░░░░░[0m [36m█[0m [37mlocation-[0;35m  [0m                 [35m [0m [36m   █ [0;35m░░░░░░░░░░░░░░░░░░░░░[0m
                   [36m█[0m [37mmagic[0m [37mword- [0m                [35m [0m    [36m█[0m
                   [36m█[0m                             [35m [0m    [36m█[0m
                   [36m█████████▀▀▀▀ [0;37m▄▄[0;36m ██████████▀▀▀▀██▀▀▀[0m    [37m  [0m    [36m  [0m
                            [37m [0;1;37;47m▓[0;1;33;47m▒[0m▀▀[1;33;47m░[0m█▄▄▄▄▄▄      [1;33;47m▓▒[0m▄  [1;33m▄[0;1;37;47m▓[0;1;33;47m▓[0;1;33;40m▄[0m▄▄▄░░    [1;33m▄▄[0m  [1;33;47m▓▒[0m
                             [1;33;47m▓░[0m  [1;33;47m▒░[0m▀▀  [1;33;47m░░▓▒[0m▀▀[1;33;47m░░▒░[0m   [1;30;40m░[0;1;33;47m▓▒[0;1;30;40m▒[0m [1;33;47m▒░[0;1;33;40m█[0;1;33;47m▒[0m▀▀[1;33;47m▒░▓▒[0m  [1;33;47m▓░[0m
                             [1;33;47m░[0m█  ▀▀[1;33m█[0;1;33;47m▓[0m▀▀[1;33;47m▒░▒░[0m  ▀▀[1;33;47m░[0m█ [1;33m █[0;1;33;47m▒░[0m█[1;30m░[0m [1;33m█[0;1;33;47m▒░░[0m  [1;33;47m░[0m█▀▀▀▀[1;33;47m░[0m█
                            ▀██▀   [1;33;47m░▒[0m  [1;33;47m░[0m█[1;33;47m░[0m█  [1;33;47m▓▒░[0m█▄▄[1;33;47m░░[0m██▄▄[1;33;47m░[0m█[1;33;47m░[0m█    ▄▄  [1;33;47m░[0m█
                                   ▀▀▀▀▀▀██▀▀▀▀      ▀▀    ▀▀  ░░[1;33;47m▒░[0m▀▀▀▀▀
                                                                 [36m  [0m
               [37m  [0m'
