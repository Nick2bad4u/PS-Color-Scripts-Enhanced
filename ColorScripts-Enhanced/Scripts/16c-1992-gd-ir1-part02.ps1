# Converted from: GD_IR1.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/1992/raw/GD_IR1.ANS
# Source Revision: archive-sha256:408f6102282b4b4f582d319af7c00d0c1a49a9b89d70dc7754d4cd44f475f4fb
# Source SHA-256: 95fdbc29a2ec170e2b897ef90292307c5591a5bcb6627ef0b0f49e0e2d1d0b3c
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: GD_IR1.ANS by Glenn Danzig (1992); released in 1992 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# Lines: 46-89
# Columns: 1-80

Write-Host '
                                                                   [1;37;47m▒[0;1;37;40m▌[0;1;35;40m▐█████████[0m
                                                          [1;35;40m▄▄▄▄▄▄   [0;1;37;40m▀[0;1;35;40m▄██████████[0m
                                                       [1;35;40m▄██████████▄████████████[0m
                                                      [1;35;40m█████████████████████████[0m
                                                     [1;35;40m▐█████████████████████████[0m
                                                     [1;35;40m██████████████████████████[0m
                                                    [1;35;40m▐██████████████████████████[0m
                           [1;30;40m▄[0m                        [1;35;40m▐██████████████████████████[0m
                        [1;30;40m▄█[0;1;30;47m▓[0m  ▄▀                     [1;35m███████████████████████████[0m
                        [1;30m▀▓ ▄[0;1;30;47m▒░[0m  ▄  [1m▄▌[0m              [1;35m▀▀██████████████████████████[0m
                          [1;30m▄[0;1;30;47m▓▒[0m▌ [1;30;47m▓▒[0m▌▐[1;47m▓▒[0;1;40m▌ ▄[0m               [1;40m▄[0;1;35;40m▀██████████████████████[0m
                           [1;30;40m▀ ▄█[0;1;30;47m▒[0m▀ [1;30;47m▒ [0;1;37;47m░[0;1;37;40m▌[0m▐[1;47m▓[0;1;40m▌ [0m▄ [1;47m▓[0;1;40m▄  [0;1;47m▓[0m   [1;40m▄ [0m▄[1;47m▓[0;1;40m▌ [0;1;35;40m█████████████████████[0m
                                 [1;30;40m▀[0;1;30;47m▓[0m█▀ [1;47m░▒[0;1;40m▌[0;1;47m░▒[0m▐[1;47m▒▓[0m▌▐[1;47m▒▓[0m [1;47m▒▓[0;1;40m▌[0m▐[1;47m▒▓[0;1;40m▌[0;1;35;40m▐████████████████████[0m
                                       ▀ ▀  ▀  ▀[1;47m░[0m▀ ▀[1;47m░[0m ▀[1;47m░[0m▀ [1;35m█████████████████████[0m
                                                         [1;35m██████████████████████[0m
                                                        [1;35m▐██████████████████████[0m
                                                        [1;35m███████████████████████[0m
                                                        [1;35m▐██████████████████████[0m
                            [1;35m▄▄▄█████▄▄▄▄▄[0m              [1;35m▄███████████████████████[0m
                         [1;35m▄████████████████████▄▄▄▄▄▄▄██████████████████████████[0m
                        [1;35m███████████████████████████████████████████████████████[0m
                       [1;35m▐███████████████████████████████████████████████████████[0m
                      [1;35m▄████████████████████████████████████████████████████████[0m
                     [1;35m▄[0;1;35;45m███[0;1;35;40m██████████████████████████████████████████████████████[0m
                   [1;35;40m████████████████████████████████████████████████████████████[0m
                  [1;35;45m▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓[0m
                 [35m▐[0;1;35;45m▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒[0m
                 [35m▐[0;1;35;45m░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░[0m
                  [35m▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓[0m
                   [1;30m▐[0;35m▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒[0m
                     [1;30m▀▀[0;35m░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░[0m
                          [1;30m▀▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒[0m
                                [1;30m░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░[0m

[1;30m ░ the  suffering''s  here the  wait is gone  the  streets are  filled with a ░[0m
[1;30m ▒ hollow  song got a new  death it lurks  outside  follows me home  waiting ▒[0m
[1;30m ▓ for me a hum in  the  ear  numbness  comes  feeling  like  you''re  almost ▓[0m
[1;30m █ home the open arms the  tempting  embrace  it''s always  been  waiting the █[0m
[1;30m ▓ suffering''s here the wait is gone the streents are filled with the hollow ▓[0m
[1;30m ▒ souls empty world of listless  light i pray i suffer blind waiting at the ▒[0m
[1;30m ░ end of  time for you  and you''ll be too  lost your soul  doomed  and cold ░[0m


                              [1;30m▄████▄[0m'
