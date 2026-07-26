# Converted from: WS-BSTY.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/odium-04/raw/WS-BSTY.ANS
# Source Revision: archive-sha256:8dc8586a37ce2081b7e99529b7087f421e6ff8d5ba2d146ef1d30bd490016720
# Source SHA-256: e29121094abd351754936a64577f48722ceb1a1b07ceb51e00331bab7b1cb222
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: WS-BSTY.ANS by whitesnake (odium); released in odium-04 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: beasty board main menu
# SAUCE Author: whitesnake
# SAUCE Group: odium
# SAUCE Date: 19960216
# SAUCE Dimensions: 80x25
# Lines: 1-22
# Columns: 1-80

Write-Host '
[1;34m▐▓ [0;36m███▀ ▀██[0;36;47m▄▓▄█[0;36m█[0;36;47m▀[0;36m█▄░▄█▀██▄ [0;1;34m▄ [0;36m▐███▀██▄████▓▀ ▀[0;36;47m▓[0;36m▌▀░▀▀  ▀▀ ▀▀▀▓▀▀█▀░ ▀▀▀▀▓▌ [0;1;30m■▄[0m
[1;30m [0;1;34m█▌ [0;36m▀▓█▄█▀█▓▀▀▀▀▀▀[0;36;47m▓[0;36m█▄██▓▀▀ [0;1;34m▐[0;1;34;47m▓[0m [36;47m▓[0;36m█▄▓ ▀▀▀██▀ [0;1;34m▄ [0;36m█▓▀■[0m             [36m▐▌[0m       [36m▐█ [0;1;30m██▓▄■[0m
[36m▌[0;1;34m▐█▀■▄▄ [0;36m▀▀ [0;1;34m▄■▀▀█▌■▄ [0;36m▀█▀ [0;1;34m▄■▀▀█▌ [0;36m▀▀▀ [0;1;34m█▌[0;36m▐█▓ [0;1;34m█▌[0;36m▐█[0m               [36m■▀[0m         [36;47m░[0;36m▌[0;1;30m▐██▌[0m
[36m█ [0;1;34m▓▌  ▐█  [0;1;34;47m▓[0;1;34m▌  ▐█  ▐▓ [0;36m▓ [0;1;34m█▌  ▐▓ ▀▀▀▀ ▐▓ [0;36m▀▌[0;1;34m▐▓ [0;36m█▐▌   [0;1;34m<[0mc[1;34m> [0;36mcomment to sysop  ▐█ [0;1;30m███▄[0m
[36m▓▌[0;1;34m▐█   ▓▌▐█   ▓▌▄■▀█▌ ▐[0;1;34;47m▓[0m   [1;34m▀ ░▌[0m     [1;34m▀▀■▄█▌[0;36m▐▌ ▀■[0m                         [36m▓▌[0;1;30m▐█▓[0m
[36m██ [0;1;34m█▌  ▐█░▌  ▐█░▌  ▐▓  ▀▀■▄  ▐█[0m        [1;34m▐[0;1;34;47m▓[0m [36m█[0m         [1;34m<[0mo[1;34m> [0;36moperate sysop   ▐█ [0;1;30m█▌[0m
[1;36;46m■▄[0;36m▌[0;1;34m▐[0;1;34;47m▓[0m   [1;34m█▌   ▓▌▐[0;1;34;47m▓[0m   [1;34m█▌    █▌  ▓▌   █▌  █▌[0;36m▐▓▄    ▀■▄[0m                      [36;47m▓[0;36m▌[0;1;30m▐▀[0m
[1;36;46m▐▓[0;36m█ [0;1;34m█▌  ▐▓ ▀▀▀ws█▌  ▐█   ▐[0;1;34;47m▓[0m   [1;34m▐█   ▐█ ▐▓ [0;36m▀[0;36;47m▓[0;36m▀▀  ▀▀▀▓▌[0m                     [36m▐█ [0;1;30m▀■[0m
[1;36;46m▀[0;36m▀[0;1;36;46m [0;36m▓ [0;1;34m▀▀▀▀ ▀▀▀▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀ ▀▀▓▀▀ ■▀ ▀▀■ board  [0;36m▀■▄[0m                 [36m▄▄■▀▓ [0;1;30m░[0m
[36m▄░▄▄█▀▓▀▀▀ ▀▀▀░▀  ░▄▀    ▀[0m       [1;34m▐[0m                    [36m▐▀■  ▄▄  ▄░▄■▀ ▀▀▓▌  ▐▌[0m
[36m█▓▌   ▐▌[0m                         [1;34m▐[0m                   [36m■▀[0m         [36m█[0m       [36m▀■  ▓ [0;1;30m░[0m
[1;30m [0;36m▐▀■   ▀■[0m                       [1;34m■▀[0m                              [36m▐▌[0m          [36m▐▌[0m
[36m ▐  [0;1;34m<[0mf[1;34m> [0;36mfile list[0m          [1;34m<[0mn[1;34m> [0;36mnew file list[0m      [1;34m<[0mr[1;34m> [0;36mread a msg ▀■[0m        [36m▄■[0m
[36m■▀  [0;1;34m<[0md[1;34m> [0;36mdownload[0m           [1;34m<[0ml[1;34m> [0;36mlocate a file[0m      [1;34m<[0me[1;34m> [0;36mwrite a msg[0m         [36m▐▌[0m
[36m [0;36;47m▓[0;36m▌ [0;1;34m<[0mu[1;34m> [0;36mupload[0m             [1;34m<[0mz[1;34m> [0;36mzippy search[0m       [1;34m<[0mbbs[1;34m> [0;36mbbs list[0m          [36m▓ [0;1;30m▄■[0m
[1;30m  [0;36m▀■[0;1;34m<[0mj[1;34m> [0;36mjoin conference    [0;1;34m<[0mw[1;34m> [0;36mchange your config [0;1;34m<[0muser[1;34m> [0;36muser list[0m       [36m▐▌[0;1;30m▐▌[0m
[1;30m [0;36m░▄ [0;1;34m<[0mt[1;34m> [0;36mtransfer protocols [0;1;34m<[0me[1;34m> [0;36mexpert mode[0m        [1;34m<[0mb[1;34m> [0;36mbulletins[0m         [36m▄█ [0;1;30m█ ░[0m
[1;30m [0;36m▐▌ [0;1;34m<[0mv[1;34m> [0;36mview your stats    [0;1;34m<[0mm[1;34m> [0;36mgraphics mode[0m      [1;34m<[0mwho[1;34m> [0;36mwho is online  ▀[0;36;47m▓[0;36m▌[0;1;30m▐█▌[0m
[1;30m  [0;36m▌[0m                                                                     [36m▐ [0;1;30m▓█▀■[0m
[1;30m  [0;36m▌[0m                           [1;34m<[0mg[1;34m> [0;36mgoodbye[0m                               [36m▓[0;1;30m▐▀▓[0m
[1;30m  [0;36m▀■▄░[0m                                                                [36m▄■▀  [0;1;30m▀■[0m
                                                                    [36m▀▓▀  [0;1;30m░[0m'
