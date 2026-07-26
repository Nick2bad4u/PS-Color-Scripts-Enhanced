# Converted from: JR_FSSTZ.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/bl-gong/raw/JR_FSSTZ.ANS
# Source Revision: archive-sha256:c90e04c94a395e53e928512945d220d1fff4c215b177bbe4ea888b6b9ab8350e
# Source SHA-256: 2cde12c9dfd4277b531fd4d545cf062565abe8021079963a3e060410d503ba60
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: JR_FSSTZ.ANS by jerusalem (boil); released in bl-gong and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: FS shizo userstatz
# SAUCE Author: jerusalem
# SAUCE Group: boil
# SAUCE Date: 19970405
# SAUCE Dimensions: 80x27
# Lines: 1-27
# Columns: 1-80

Write-Host '
            [33m░░░[0m                         [1;30m  [0m       [1;30m▄▄█[0;1;30;47m▓▓▓▓[0;1;30;40m▀▀▀[0;33m░░░░░░░[0;1;30m▀▀▀█▄▄[0m
           [33m░░░[0m                        [1;30m░░[0m       [1;30m▄[0;1;30;47m  ▓[0;33m░░░░░[0m          [33m░░░░[0;37m  [0;1;30m▀[0m
                                     [1;30m░░[0m   [1;30m  [0m [1;30m▄[0;1;30;47m▄▄[0;1;30;40m▀[0;33m░[0m                    [33m░░[0;37m  [0;1;30m■[0m
         [1;30m▐[0;1;30;47m [0;1;33;47m░[0;1;30;47m▀[0;1;30;40m█▄▄▄▄▄[0m                      [1;30m  ■[0;1;30;47m▓[0;33m░░[0m    [33m▄▄▄▄███[0;35;43m░░[0;33;40m███████▄▄[0m   [33;40m░[0m
          [1;30;40m█[0;1;30;47m▓[0;1;30;40m▀▀▀▀▀▀▀▀█[0;1;30;47m▄▄▓[0;1;30;40m▄▄▄[0m              [1;30m▄[0;1;30;47m▀[0;33m░░[0;37m  [0;33m▄▄[0;35;43m░[0;33;40m██▀▀▀[0;37;40m  ▄▄▄▄▄▄▄▄▄▄  [0;33;40m▀■[0m
          [1;30;40m▐▌[0;33m░░░[0m    [1;30m   [0;33m░░░[0;37m [0;1;30m▀▀▀■[0m  [1;30m░░░[0m     [1;30m■ [0;33m░░[0;37m [0;33m▄█▀[0;37m [0;1;37m [0m▄▄▄[1;47m▄▄▄▄███▓▓▒▓█▒░[0;1;33;47m░░[0m▄[1mj[0mR[33m▒[0m
           [1;30m■[0;33m■▄▄▄▄▄▄[0m     [33m░░▓▓▓▓  [0;1;30m■[0m   [33m░░░░░[0;1;30m [0;33m░[0;37m [0;33m▓▀[0;37m ▄[0;1;37;47m  ░▒▓▓████████▓███▒▓▒░[0m█[1m [0m
            [33m▐▀▀▀▀▀▀▀▀▄▄▄▄[0;37m  [0;33m▒▒▒█░[0;37m  [0;33m░░░░▓▓▓░[0;37m [0;33m░░[0;37m [0;1;37;47m ▄▒▓[0;1;37;40m▀ [0;1;30;40m░[0;1;37;40m▄▄▀███████[0;1;37;47m███▓▓▓░░[0m▌
          [1m   [0m▄[1;47m  ▒▄██[0;1;40m▄▄▄▄[0m [33m▀▀▀░[0;37m [0;33m░█▓[0m     [33m░░░[0m   [37m▄[0;37;47m▄[0;1;33;47m░[0m█[1m█[0;1;31m▐[0;31m▓░ [0;1;30m [0;31m▐[0;1;37m [0;1;37;47m▓▓[0;1;37;40m██████[0;1;37;47m▀▀▀[0m▀▀▀▀▀  [33m  [0m
         [1;37m   [0m▐[1;47m [0;35;47m░[0;1;37;47m░▒▓▓[0;1;37;40m██▀█▀▀██[0m▄   [33m░[0;35;43m░[0;33;40m█▓▄▄[0m    [33;40m░░[0;1;31;41m▀[0m▀ [33m▄▄[0;37m [0;31m [0;1;31m▀[0;31m▀■  [0;1;37m■▀[0m▀▀▀  [33m▄▄▄▄▄▄██░░░  [0m
           [1;37m  [0m▀▀[1;47m ░▓▓▓[0;1;40m▌[0;31m▌░[0;1;30m [0;31m▐[0;1;37m ██[0m█▄   [33m▀▀░[0m    [33m░▓░░[0;37m [0;33m░▒▀▀▀▓▓▓░░░░░░▒▒░░░░░[0m    [33m  ░░[0m
        [33m░░[0m   [35;43m░[0;33;40m▄▄▄[0;1;37;40m [0m▀▀ [1;31m▀[0;31m■ ▀[0;1;37m■▀▀[0m▀▀[1;31;41m■[0m  [33m░░░░[0m    [33m░▓░░[0;37m [0;1;30m [0;33m░░[0m                      [33m░░    [0m
            [33m▐▓▓▓▀▀▀▀[0m            [33m░░░[0m             [1;30m [0;33m░░[0m
            [33m░░░[0m
      [1;37mu[0ms[1;30mer.........:[0m                      [1;30m  [0;1;37mb[0ma[1;30mud rate....:[0m
[33m░░░[0;37m [0;33m░ [0;1;37ml[0mo[1;30mcation.....:[0m                        [1my[0mo[1;30mur upload..:[0m
      [1ms[0me[1;30mcurity.....:[0m                        [1my[0mo[1;30mur ul kb...:[0m
      [1mb[0mi[1;30mrthday.....:[0m                        [1my[0mo[1;30mur download:[0m
      [1mt[0mo[1;30mtal calls..:[0m                        [1my[0mo[1;30mur dl kb...:[0m
      [1mf[0mi[1;30mrst call...:[0m                        [1mb[0my[1;30mte ratio...:[0m
      [1mm[0ms[1;30mg posted...:[0m                        [1mf[0mi[1;30mle ratio...:[0m




[1;30m-------░░------------------------------░----------------------------------------[0m
[1;30mthe FS userstats. schizo eyes lookin'' at yar fuckin'' personality![0m'
