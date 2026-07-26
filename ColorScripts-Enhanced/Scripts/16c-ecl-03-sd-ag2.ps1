# Converted from: SD-AG2.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/ecl-03/raw/SD-AG2.ANS
# Source Revision: archive-sha256:8478e7ed47e52d1e07bf55e17a5f105ced4b468c6f56a8b59fd6b8ef8dada5ca
# Source SHA-256: 19840c6f6af222d1de7f11534a5e67d7c21cf21599169dee84b5f3180404d2b9
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: SD-AG2.ANS by sir death (eek_lipz); released in ecl-03 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: ag
# SAUCE Author: sir death
# SAUCE Group: eek_lipz
# SAUCE Date: 19960713
# SAUCE Dimensions: 80x28
# Lines: 1-28
# Columns: 1-80

Write-Host '
                                   ▄▄▄             ▄▄▄
                          [1;35m▀▀▀▀▀▀▀▀[0;1;35;45m▀[0;1;37;47m▓▓[0;1;37;40m▒ [0;35m█[0;1;35m██▀▀▀▀▀▀▀▀[0;1;35;45m▀[0;1;37;40m██▒[0m
                       [1;45m [0;1;35;40m██▀▀▀▀▀▀▀▀[0;1;35;45m▀[0;1;35;40m██▀▀[0;1;35;45m▀[0;1;35;40m██[0m        [35m█[0;1;35m██[0m
                       [1;35;45m [0;1;35;40m██[0m      [35m▄[0;1;35;45m▄[0;1;35;40m█▀[0m AT [35m▀[0;1;35;45m▀[0;1;35;40m█▄[0m      [35m█[0;1;35m██[0m
                       [1;35;45m [0;1;35;40m██[0m     [35m▐[0;1;35;45m▐[0;1;35;40m█▌[0m OMIC [35m▐[0;1;35;45m▐[0;1;35;40m█▌    [0;35m▄[0;1;35;45m▄[0;1;35;40m█▀[0m
                      [35m▀[0;1;35;45m▀[0;1;35;40m█▄[0m     [35m█[0;1;35m██[0m ------ [35m█[0;1;35m██   [0;35m▐[0;1;35;45m▐[0;1;35;40m█▌[0m
                       [35m▐[0;1;35;45m▐[0;1;35;40m█▌    [0;35m█[0;1;35m██[0m GARDEN [1;35;45m░██[0m    [35m▀[0;1;35;45m▓▓[0;1;35;40m▄[0m
                      [35m▄[0;1;35;45m▒▓[0;1;35;40m▀[0m     [35m▀▀[0;1;35m▀[0;1;35;45m▀[0;1;35;40m▀▀▀▀▀▀[0;1;35;45m▀[0;1;35;40m▀▀▀    [0;35m▀[0;1;35;45m░░[0;35m▄[0m
                      [35m▄[0;1;35;45m░░[0;35m▀[0m        [35m█[0;1;35;45m░░[0;35m▀▀██▓[0m        [35m▐[0;35;45m  [0;35;40m▌[0m
             [33;40m       [0;37;40m [0;35;40m▐██▌[0m         [1;31;45m░░▄[0m  [35m██▓[0m       [35m▄[0;1;31;45m░░[0;35m▀[0m
             [33m    [0;37m  [0;33m  [0;37m [0;35m▀[0;1;31;45m░░[0;1;31;40m▄[0m [33m     [0;37m  [0;1;31m▀▀▀  [0;1;31;45m░░▄[0m        [1;31m▀▀▀[0m
 [33m                [0m   [33m   [0;1;31m▀▀▀[0m [33m   [0m         [1;31m▀▀▀[0m                 [33m  [0;37m▄[0;1;37m▄▄[0m▄[1m [0m
             [33m▄▄▄▄▄▄▄▄▄     ▄▄▄░[0;30;43m▓[0;33;40m░[0;37;40m ░[0;1;30;40m [0m░      [33m▄▄▄▄▄▄[0;37m ░ ░ [0;33m█[0;33;47m▓[0;33;40m██[0;37;43m░[0;33;47m▓[0;37;43m▓[0;33;47m░[0;1;37;47m█[0;1;37;40m█[0m▌
             [1;30m█[0;33m████████[0;37m ░[0;1;30m [0m░ [33m███[0;30;43m░░░[0;37;40m ▒░▒[0;1;30;40m  [0m░[1;30m [0m░ [1;30;43m▄[0;33m██[0;33;47m▓▓▓[0;37;40m ░░▒ [0;33;40m▀▀▀▀██[0;33;47m▓[0;37;43m▓[0;33;47m░[0;1;37;47m░[0m
            [1;30m▐[0;1;30;43m▌[0;33m████████[0;37m ▒░▒ [0;1;30m█[0;33m█████[0;37m ▓[0;1;37;47m▐▓[0;1;37;40m░[0;1;30;40m [0;1;30;47m▒[0m░▒ [1;30;43m▌[0;33m█████[0;37m ▓[0;1;37;47m▐[0;1;37;40m▓░░[0m [1m░[0m [33m███[0;33;47m▓[0;37;43m░[0;33;40m▌[0m
            [1;30;40m▐[0;1;30;43m▌[0;43m░░[0;33;47m▓▓[0;37;43m░[0;33;40m█[0;37;43m░[0;33;40m█[0;37;40m [0;1;30;47m▒▒[0m▓ [1;30;43m█▄▄▄[0;33m█[0;1;30;43m▄[0m [1;30;47m░░▒[0;1;30;40m  [0;1;30;47m▓▒░[0m [1;30;43m█▄[0;33m▀▀▀▀[0;37m [0;1;30;47m░[0m▓[1;47m░[0m [33m▄▄▄▄█[0;33;47m▓[0;37;43m░[0;33;47m▓[0;37;43m░[0;37;40m░[0;30;47m▓[0;37;40m░[0;30;47m▓[0;33;40m [0;30;47m▓[0;33;40m  [0m
            [1;30;40m▀▀[0;33m▀▀▀▀▀▀▀ [0;37m [0;1;30;47m▓▓[0;1;30;40m█[0m        [1;30;47m▒▒▓[0;1;30;40m  █[0;1;30;47m▓▓[0m        [1;30;47m▓░░[0m      ░░[30;47m▓[0;37;40m░[0m
            [37;40msirdeath[0m   [1;30;40m▀▀▀▀▀▀▀▀▀[0;1;30;47m▓▓▓[0;1;30;40m▀   ▀▀▀▀▀▀▀▀▀▀▀[0;1;30;47m█▓▓[0m
                               [1;30m▐[0;1;30;47m [0;1;37;47m░[0;1;30;40m▌   ███▀▀▀▀▀▀▀▀▀▀▀▀[0m
                                [1;30m▀▀▀[0m


                yo lagomorph.  man, i remeber you did me a logo, i did you won
                        and it sucked cow nuts.  i tried to do another that
        i''m not really happy with.  i can''t find a style that i like anymore.
                but it say AG for your board atomic garden.  hope jew like it.
      later fellow eclipse member.  :P[0m'
