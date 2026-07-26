# Converted from: IP-PIPE3.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/laz09aug/raw/IP-PIPE3.ANS
# Source Revision: archive-sha256:3e0bd3039fe877b3970f71e80b4456ee60793f2295ae127a50a6587b17c2d6a2
# Source SHA-256: 0cd7dbd9b8321814f9a4cd4b92e59a498e2266ed6e5f7e2c2fad736225dded33
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: IP-PIPE3.ANS by impulse (lazarus, force); released in laz09aug and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: Another Pipe Font
# SAUCE Author: impulse
# SAUCE Group: lazarus, force
# Lines: 1-22
# Columns: 1-80

Write-Host '

                                   [1m▀▀▄▄[0m▄
                             [1;34m▄[0m       ▄ [1m▀█[0;1;47m▄[0;1;40m▄[0m▄
                         [1m░[0m  [1;34m▀[0;1;34;47m▓[0;1;34;40m▀[0m   [1m▄[0m  [33m   [0;37m [0;1;36m█[0;1;37m▀▀▀[0;1;37;47m▄[0;1;37;40m▄[0m
                         [1m▒[0m    [1m▄▄▀[0m [33m   [0;1;37m░░[0;33m [0;37m [0;1;37m▐[0m▌[1;32m▀▄[0;32m▄[0;37m [0;1;37m▀▄[0m
                         [1m▓▄▄█▀█[0m [33m    [0m      [1;37;47m▓[0;32m [0;1;32m▐[0;1;37;42m█[0;1;32;42m▄[0;1;32;40m▄[0m ▀▄[1m [0m ▄▓▄
                      [1m▄▄█▀[0m▀ [1;32m▄[0;1;37m▐▌[0;33m   ▄▓▄[0m     [1;37m▄[0;32m [0;1;32;42m██▄▓[0;1;32;40m█▄[0m [1;30;47m▄[0m  ▀ ▄
                   [1m▀[0m   [1m▀▄[0m [1;32;42m██[0;1;32;40m▌[0;1;37;40m▐[0;1;37;47m▌[0m   [33m ▀ [0m    [37m [0;1;37;47m█[0;32m░[0;1;32;42m▓▓[0;1;32;40m▀[0m [1;32m▀▀[0;33m░[0;1;30m▐▌[0m
                        [1m▐[0m▌[1;32m▀[0;1;32;42m▓▀[0m [1;47m▓[0;1;40m▀[0m    [33m   [0;37m  [0;1;37m▄[0;1;37;47m▓[0m [1;32;42m▒▒▒[0m [1;30m▀▄▄[0;1;30;47m▓▓[0;1;30;40m▄[0m
                        [1m▐▌[0;32m▐[0;1;32;42m▒▒[0m [1;47m▀[0m    [33m      [0;37m [0;1;37;47m▒[0;32m ▄[0;1;32;42m░░░[0;32m [0;1;30m▐██▀[0m
                        [1m▀▀[0m [1;32;42m░░[0;32m [0;37m▄ [0;33m     [0;36m░[0;33m   [0;37m [0;1;37;47m░[0m [1;32;42m░[0;32m▀▀[0;37m [0;1;30m▄▓▀[0m
                       [36m [0;37m [0;1;37;47m░[0;32m ▀[0;1;32;42m [0;32m▌[0;37m▐▌▄ [0;33m   [0;36m▒[0;33m   [0;37m▐▌ [0;1;30m▄▄▀▀[0m [1;30mip[0m
                   [36m     [0;37m ▐▓[0;32m▐[0;1;32;42m░[0;32m▄[0;37m▀█▌ [0;33m [0;36m▄▄▓▀[0;37m [0;1;30m▄[0;1;30;47m▓[0;1;30;40m ▀[0;36m  [0;37m [0;1;34m▀ [0m [1;34m [0m
                [36m [0;37m [0;36m     [0;37m  ▐▌[0;32m▀▀▓[0;37m █ [0;33m [0;37m  [0;1;30m▄[0m  [1;30m▀[0m [36m▄[0;37m [0;36m ░░[0;37m           [0m
            [36m     [0;37m [0;36m ▄[0;1;36;46m░[0;36m▄ [0;37m [0;1;30m▀▀[0;1;30;46m▓[0;1;30;47m▄[0;1;30;40m▄▄[0;32m [0;1;30m▐█▀[0m [36m ▄▄█▀[0;33m [0;37m          [0m
               [36m  [0;37m [0;36m  ▓  ▀  ▄▄ [0;1;30m▀▀▄▓[0m [36m▐█[0;1;36;46m░░[0;33m [0;37m [0;1;37m p i[0m [1mp e[0m [1m![0m
                     [36m    [0;37m [0;36m █[0;1;36;46m░░[0;36m▄ [0;1;30m▀▄[0;36m ▀█▌[0;33m [0m
                           [36m▐█[0;1;36;46m▄[0;36m▀▀[0;37m [0;33m▄[0;37m [0;1;30m■[0m [36m▀[0;37m  [0;36m▄[0m
                         [36m▄ ▀[0;37m   [0;33m▀█▓▀[0;37m  [0;1;30m▀[0m  [36m [0;37m  [0;1;36m▀[0;36m [0m
                    [36m░░[0;37m [0;36m▀[0m         [33m▒[0m
                                 [33m░[0m'
