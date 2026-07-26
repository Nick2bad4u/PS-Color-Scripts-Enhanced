# Converted from: SR-BS2.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/uni-0195/raw/SR-BS2.ANS
# Source Revision: archive-sha256:874f19df1d2975eb4a251b4e9722be66f88a94e2778db4593e3b6fbe57329d35
# Source SHA-256: 5afaa42aa40670cff10adfcc02a0ee148e62454703d01e2c5518d4f498b8c469
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: SR-BS2.ANS by Silver Rat (Union); released in uni-0195 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: Blood Shot 2
# SAUCE Author: Silver Rat
# SAUCE Group: Union
# SAUCE Date: 19950101
# SAUCE Dimensions: 80x25
# Lines: 1-25
# Columns: 1-80

Write-Host '
                  [36m  [0m    [36m     ▄ ▄████████████▄▄▄   [0m
                        [36m ▄▄███▌▐███████[0;36;44m▓[0;36;40m██████[0;1;30;46m░[0;36m███▄ [0m
                       [36m▄███▀▀▀▄██████████████████[0;37;46m░[0;36;40m██▄ [0m
                      [36m██▀ ▄███[0;36;45m▓[0;36;40m█████▀▀▀████[0m [36;40m ██[0;37;46m░[0;36;40m█████▄[0m
                     [36m██[0;1;36;46m [0;36m ▐██████▀▀▀■[0;1;30m▐█▄▄[0m [36m▀[0m [1;30m▄▌[0;36m▐█[0;37;46m▒[0;36;40m█[0;1;37;46m [0;36m████▌ [0m
                     [36m███▌ ▀██▀[0;1;30m▄▄██[0;1;30;46m█[0;1;30;40m▄▄▀█▀████▀[0m [36m█[0;37;46m░[0;36;40m████[0;1;30;46m░[0;36m██ [0m
                     [36m██[0;1;36;46m░[0;36m█▄[0m [36m■[0;1;30m▄███[0;1;30;46m█▓██[0;1;30;40m▌████▌■▐█[0m [36m█[0;37;46m [0;36;40m█████▀█ [0m
                     [1;36;46m░[0;36m█[0;1;36;46m▒[0;36m█ [0;1;30m▄▌▓█[0;1;30;46m█[0;1;30;40m▌███[0;1;30;46m██[0;1;30;40m▀████▀█▀[0m [1;30;40m■[0m [1;30;40m▄ ▄■[0;36m ▐█ [0m
                     [1;36;46m▒░▓░[0;36m▌[0;1;30m▐▌▒███▒█▓███▄▀▀▀[0m  [36m▄▄▄▄▄▄▄▄ ▄█ [0m
                      [1;36;46m▓▓▒[0;1;30;40m■▓ ░ ▀▀░▀▐▀▒▐▀■▀[0m [36m▄█[0;1;36;46m░[0;36m██████[0;1;37;46m [0;36m██▌[0m
[1;30m   [0m                    [1;36;46m█[0;1;36;40m▄[0;36m■[0;1;30m░[0;36m▐[0;1;36;46m░▒▓░░[0;36m█▄[0;1;30m ░[0m [36m▄▄▄[0;1;36;46m░░[0;36m█[0;1;36;46m▒[0;36m█[0;1;36;46m░[0;36m███[0;1;36;46m░[0;36m██▀[0m
                        [1;36m▀█[0;36m [0;1;36m▄[0;1;36;46m▓▒▓░▒░[0;36m█[0m [1;30m▒ [0;1;36;46m░▒░░▒░▒▒░▒░[0;36m██▀[0m
                        [1;30m  [0;1;36m▀▀[0;1;36;46m██▓▒▓▒[0;36m▀[0;1;30m ▓▀[0;1;36m▐[0;1;36;46m▒▓░▒▓█▓[0;36m▀▀▀[0m
                              [1;36m ▀▀▀▀▀▀▀▀▀▀▀▀[0m               [35m [0m
            [1;30m   ▄▄▓  ▄▓ [0m [1;30m ░▄▄▄[0;35m■[0;1;30m▄░ [0m [1;30m ▄▄▓[0m   [1;30m░▄▄▄[0;35m■[0;1;30m▓▄▄[0m   [1;30m░▄▄▄[0;35m■[0;1;30m▄░[0m
              [1;30m [0;1;30;47m█▓[0;1;30;40m█  ▐█ [0m [1;30;40m █[0;1;30;47m▓[0;1;30;40m█  ▐█ [0m [1;30;40m █[0;1;30;47m▓[0;1;30;40m█[0m   [1;30;40m█[0;1;30;47m▓[0;1;30;40m█  █[0;1;30;47m▓█[0m   [1;30;40m█[0;1;30;47m▓[0;1;30;40m█  ▐█[0m
               [1;30;40m░▀▀▀[0;35m■[0;1;30m▀░ [0m [1;30m ▀▀▓  ▀▓ [0m [1;30m ░▀▀ [0m  [1;30m▀▀▒[0;35m■[0;1;30m▀▀▀░[0m   [1;30m▀▀▒  ▀▓[0m
             [1;30m        [0m     [1;30m  [0m  [1;30m  [0m  [1;30m   [0m     [1;30m  [0m         [1;30m  [0m  [1;30m [0m
                     [1;30mlook beavis.. fire fire! huhuhu [0m
                       [1;30m [0myea.. where? where? huhuhu
[1;30m [0m                    [1;30mlike scroll down and stuff dude[0m


'
