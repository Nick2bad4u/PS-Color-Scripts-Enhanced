# Converted from: VN-SAC.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/wind0195/raw/VN-SAC.ANS
# Source Revision: archive-sha256:5b43f6b448165807ca10541f72295732684c4ffaba57fa200380cfc1d53164e9
# Source SHA-256: f4e51652752521f795fafe02627a0ec21944d9dd807a9c2808fcebf1d193d0a4
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: VN-SAC.ANS by VEiN (WiND `95); released in wind0195 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: SACRiFiCE
# SAUCE Author: VEiN
# SAUCE Group: WiND `95
# SAUCE Date: 19950101
# SAUCE Dimensions: 80x25
# Lines: 47-89
# Columns: 1-80

Write-Host '
[33m█▓█[0m      [33m▄▀▄▓[0m                                [32m▄██[0m                    [33m▄▀▀▀ ██  █▓▀[0m
[33m█ ██[0m     [33m▄  ▀▄[0m                                [32m██▀[0m           [32m▄█▄█▄  [0;33m▀[0m       [33m███▓█[0m
[33m██████[0m                            [32m▄▄[0m         [32m▄██[0m         [32m▄▄█▀▀▄▀[0m           [33m▀▄▀[0m
[33m▓█ ▓█ ██[0m                      [32m▄██▀█▄▀██▄▄   ▄▄ ██▄[0m     [32m▄█▀ ▄██[0m               [33m▓█[0m
[33m ▒▓█▓▓█[0m            [32m▄[0m           [32m▀██▄▄ ▀▄▀██▄  ▀███▄   ▄▀█ █▄▄█[0m                 [33m▓▓[0m
[33m▒▓█ █[0m            [32m▄▀██[0m            [32m▀█▄█▄ ▀▄▀█▄▄▀▄██   █▐▄ ▄▄██[0m
[33m▓▒▓█[0m           [32m▄█▀▐▀█[0m              [32m▀█▄▀▄▄ ▄▄▄▀ ███▄█▀  ▀▄▄█▀[0m                 [33m▓▓▓[0m
[33m█▓▒[0m           [32m▀[0;33m▄[0;32m▄█▀█▀[0m                 [32m▀█▄█▀▀    █▄█▄▄████▀[0m                   [33m▓[0m
[33m█▓▓▄[0m          [33m█ [0;32m▀█▀[0m                           [32m▄██▄  ▀▀[0m                       [33m▓▓▓[0m
[33m▓  ▓█▀▀▄[0m     [33m▄▀[0m                                [32m██[0m                             [33m█▓[0m
[33m██  ▓ ▄ █ ▄▄▀[0m                                   [32m██[0m
[33m█ █  ▀  ▓█[0m          [32m▄█ ▄ [0;33m▄[0m                       [32m█▀[0m                          [33m▓▓█[0m
[33m▓█[0m       [33m▀█▄   ▄▄▀[0;32m▄█▀▄▌▀█ [0;33m█[0m                     [32m█▄[0m                            [33m█▓[0m
[33m▓▓[0m          [33m█▄▀   [0;32m█▄▀▄▐█▀█ [0;33m▀▄▄[0m                  [32m▄██[0m                          [33m▀██[0m
[33m▓█▓[0m           [33m▀▀▄ [0;32m▀██▌▐▄▀█▌[0m                      [32m█[0m                           [33m▄▄▓[0m
[33m▓█▒▒[0m            [33m█  [0;32m▀██▌██▀[0m                      [32m▀█[0m                            [33m▓▓[0m
[33m█▒█[0m             [33m▄▀   [0;32m▀█▀[0m                        [32m█ ▀[0m                          [33m▓[0m
[33m█ ▒▓[0m            [33m▓█[0m                             [32m▀██[0m                          [33m██▓█[0m
[33m██ █[0m             [33m▀▄[0m                             [32m▄█ ▌[0m                       [33m▀▄▓█▒[0m
[33m█▓█▓█[0m            [33m▓▀[0m                              [32m█ .[0m                       [33m█▄ ▓▓[0m
[33m█▓ █▄▄[0m           [33m█▌[0m                              [32m▌[0m                           [33m▒█░[0m
[33m▄ ▀█▓▄▄[0m           [33m▀▀ ▄[0m                           [32m. .[0m                         [33m▀▒[0m
[33m█ ▄ ▀▀ ▀▄▀▄[0m                                      [32m▌[0m                         [33m▄▀▀▄▓[0m
[33m▄   ▀ ▄▀▄ ▀ ▄[0m                                    [32m.[0m                        [33m▄▄▄▀▀▄[0m
[33m▀  ▀[0m     [33m▄▄▄ ▀▄[0m                                  [32m. ▌[0m                     [33m▄▄▓ ▀▓▓[0m
[33m    ▄▀▄▄▄▄▀▄▄ ▀▀▄▄▄[0m                                                   [33m▄▄▀█▓ █▀▄▀[0m
[33m   ▀[0m         [33m▓▄    ▀[0m                             [32m▌[0m                    [33m▄    ▄▀ ▄▀[0m
[33m ▄[0m             [33m▀[0m                                                   [33m▄▀▄▀ ▄▀▀  █[0m
                                                 [32m.[0m                [33m▄   ▄▀   ▀  ▄▀[0m
                                                   [32m.[0m                 [33m▄▀[0m
                                                                      [1;30m──═[0m■ [1;30mVEiN[0m
                                                 [32m,[0m



     [1;30m█▀▀▀▀▀▀▀▀▀▀ ▀▀ ▀[0m                                    [1;30m▀ ▀▀ ▀▀▀▀▀▀▀▀▀▀█[0m
     [1;30m█ [0;1;30;47m░░▒▓[0m                                                        [1;30;47m▓▒░░[0m [1;30m█[0m
     [1;30m█ [0;1;30;47m░▒▓[0m                  ■ [1;30mS A C R [0mi [1;30mF [0mi [1;30mC E [0m■                   [1;30;47m▓▒░[0m [1;30m█[0m
     [1;30m█ [0;1;30;47m▒▓[0m                  [1;30m2 o 6 [0m. [1;30m3 2 8 [0m. [1;30m5 3 o 9[0m                   [1;30;47m▓▒[0m [1;30m█[0m
     [1;30m█ [0;1;30;47m▓[0m                    [1;30mW[0mi[1;30mND WHQ [0m- [1;30mOBV[0m/[1;30m2 v2[0m.[1;30m25[0m                    [1;30;47m▓[0m [1;30m█[0m
     [1;30m▄[0m                     [1;30mProgramming/Art Support[0m                      [1;30m▄[0m
                               [1;30mNo Phucking NupS[0m
                                  [1;30mSoP: VEiN[0m'
