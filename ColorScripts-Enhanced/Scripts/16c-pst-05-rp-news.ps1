# Converted from: RP-NEWS.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/pst-05/raw/RP-NEWS.ANS
# Source Revision: archive-sha256:14f481f943dbbb8808fa1b68b61aa9c5922fc2a7890c1906e8128525fa42d14c
# Source SHA-256: 5e10736b02b78f753f21768886b4738ba8271ce552b85018ea1fe3d53b2adb58
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: RP-NEWS.ANS by rippa (polyester); released in pst-05 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: news file header
# SAUCE Author: rippa
# SAUCE Group: polyester
# SAUCE Date: 19980821
# SAUCE Dimensions: 80x24
# Lines: 1-24
# Columns: 1-80

Write-Host '
                                           [1;30m▄■ ▀ [0;36m  [0;30;46m▓[0m
                                     [36;40m ▄   [0;1;30;40m▐▌ [0;36m [0;1;30m  [0;36m [0;30;46m█▓[0m            [36;40m ▄[0m
            [37;40m          [0;1;30;40m▀[0m [1;30m▄▄▄[0m    [36m▄▄▄■▀   [0;1;30m▄ ▄█▌▄[0;36m  ▄▄▄[0;30;46m░[0;36;40m▄▄▄  ▄▄▄▄■▀      [0m
             [37;40m [0;1;30;46m░ [0;36m▄■▀▀██▄▄[0;37m [0;1;30m▐▀[0;36m ▄██▀ ▄▄▄▌[0;32m▄▄▄[0;36m [0;1;30m ▀▀█▓[0;36m [0;32m▐[0;32;46m▒░[0;30;46m░[0;36;40m██▌ ▀██▄▄▄▄▄▄▄▄▄  [0;1;30;40mrp.[0m
        [1;30m▀ [0m   [1;30m▐[0;1;30;46m▒░[0;36m▌[0;37m [0;1;30m▄[0m [36m▐█[0;30;46m░ [0;36;40m▌[0;1;30;40m  [0;36m▐██▌  ▐█[0;30;46m■[0;32;40m▄[0;32;46m▓[0;1;32;42m░[0;32m▌[0;36m [0;1;32m▐▄▄[0;36m [0;1;30m█▄[0;36m [0;32;46m▒[0;30;46m▄░▄[0;36;40m█  [0;1;37;40m▄▄[0;1;36;40m▄▄▄[0;36m▄▄  ▀[0;37;46m   [0;36;40m [0m
        [1;30;40m ▐▌ [0m [1;30;46m▓▒░[0m [1;30m▄█[0m [1;36;46m░[0;36m█[0;30;46m [0;36;40m██[0;37;40m  [0;36;40m█[0;32;46m ░[0;36;40m▀▀  █[0;32;46m░▒▓[0;32;40m▀[0;36;40m  [0;1;32;40m█[0;1;32;42m▓▓[0;36m [0;1;30m▐▌ [0;32;46m▓▓[0;30;46m▀[0;36;40m██  [0;1;37;40m▐[0;1;36;40m██[0;1;36;46m▓▓░[0;36m▌[0;1;30m ▄[0;36m ██[0;30;46m░[0;36;40m [0;1;30;40m▀█▄[0m
    [1;30m░░░[0m   [1;30m▀■▄[0;1;30;46m▓░ [0m [1;30m▀▀[0m [1;36;46m▒░░░[0;36m▓░ █[0;32;46m░▒[0;36;40m [0;1;30;40m▄▓[0;36m █▀[0;32;46m░[0;32;40m▄[0;1;32;42m░[0;1;30;40m  [0;1;32;40m▐[0;1;32;42m░░[0;32m▌[0;36m [0;1;30m▀ [0;32m▐[0;32;46m▓▓░[0;36;40m▌[0;1;30;40m▄▌ [0;1;36;40m▀[0;1;36;46m▓▓▒░[0;36m [0;1;30m██[0;36m █[0;1;30;46m░[0;36m▓░ [0;1;30m▀▀[0m
             [36m▄█▄[0;37m [0;1;30m▀▀[0m [1;36;46m▒▒[0;36m▀[0;1;36;46m▒▒[0m  [36m▓██  [0;1;30m▀[0;36m ▐[0;32;46m▓▓[0;1;32;42m░▓[0;1;32;40m▄▄■[0;32m▀▀▀■▄▄██▀[0;36m▀ [0;1;30m█[0;36m ░▓[0;1;36;46m░[0;36m▄[0;1;36;46m░[0;36m█ [0;1;30m▀▌[0;36m [0;1;30;46m░▒[0;1;30;40m█[0;36m  [0;1;30m█▓░ ░[0m
                   [1;36m▐[0;1;36;46m▓▓[0;1;36;40m▐█[0;1;36;46m▓[0;1;36;40m▌[0m [36m ▀▀[0;32m▀[0;36m■▄▄[0;32;46m░▒[0;32;40m▀▀[0;36;40m  [0;1;30;40m▄▄█▌▄▄[0;36m [0;1;30m▄▄[0m   [1;30m▀▀▄[0;36m ▐█[0;1;36;46m [0;36m██▌[0;1;30m [0;36m ▐[0;1;30;46m░▓[0;1;30;40m▌[0;36m [0;1;30m▄▄[0m
         [1;36mbbs[0;36mnews[0;1;30m![0;1;31m  [0;1;36m▀▀▀▐▌▀▀[0;1;31m  [0;1;30m▀▀▄[0;1;31m  [0;36m [0m    [1;30m▀▀▀▐▀▀▓▓▀▀▀[0;1;31m [0;1;30m▀[0m      [36m▀▀█▌█▄■▀[0;1;30m▀▀[0;1;31m [0m
                       [1;36m▀■[0;1;31m [0;1;36m▄[0m                 [1;30m░░[0m             [1m [0;36m▌[0m
                                               [1;30m [0m           [36m ▀            [0m


[1;30m──────────────────────────────────────────────────────────────────[ [0;36mcut here[0;1;30m ]─[0m

[36mgreets go to all who i''ve met along the way.. krinkle([0;1;37minsurge[0;36m), [0;1;37mvejita[0;36m, stanna,[0m
[36mrorshack, trippah, black_jack, serial2n, napalm, dark entity, bchrome, palmore,[0m
[1;37mhitek[0;36m, [0;1;37minclusive[0;36m, [0;1;37mdeathstroke[0;36m, and everyone who has joined my polyester. i''d[0m
[36mlike to see my group prosper even more, so if you wanna release an ansi, ascii,[0m
[36mvga or rip every two months (yes, just one), please contact me![0m

[36moh, this ansi is for anyone to use btw, just mail me b4 you use it.[0m'
