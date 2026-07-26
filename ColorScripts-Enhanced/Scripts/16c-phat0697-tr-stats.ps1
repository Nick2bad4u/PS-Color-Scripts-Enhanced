# Converted from: TR!STATS.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/phat0697/raw/TR!STATS.ANS
# Source Revision: archive-sha256:08e18940bca34b3567a75953ae0590b0f85d3fbc4d879deb49d9733793875e53
# Source SHA-256: ed48ef37fa2ab5cf40784921e29c7dcbcaf9ea40e28decac2d9af15d47af1b99
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: TR!STATS.ANS by trinity (Phat Studios '97); released in phat0697 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: status ansi
# SAUCE Author: trinity
# SAUCE Group: Phat Studios '97
# SAUCE Date: 19970527
# SAUCE Dimensions: 80x25
# SAUCE Comments: today is my birthday. 27.o5 remember this day!
# Lines: 1-31
# Columns: 1-80

Write-Host '
    [33m░░[0;37m [0;33m▄[0;37m              [0m                     [33m█▌[0m   [1;30mboard stats[0m    [33m█[0;1;35;43m░[0m
[33m▄▄▄▄[0;1;35;43m▄▄▄▄[0;33m▄▄[0m        [36m▄▄▄▄▄▀▀▀▀[0m              [33m▄█▀[0m    [1;30mpers[0m [1;30mstats[0m     [33m█[0;1;35;43m▓[0;33m▌[0m         [33m░░░░░[0m
[37m  [0;33m▀▀█[0;1;35;43m▓▓▀[0;33m▌[0;36m▄▄[0;1;33;46m░░[0;36m█▀▀▀▀▀[0m    [33m▄▄▄[0;32;43m░░[0;33;40m▓▓[0;37;40m [0;33;40mtr[0;37;40m  [0;33;40m▄▄▄▄█▀▀[0m      [1;30;40moverall[0m        [33m▐[0;1;35;43m░[0;33m█[0m         [33m▓▓▓▓▓[0m
[33m░░░░[0;37m [0;1;35;43m░░[0;33m█[0;37m  [0;36m▐[0;1;33;46m▓▓▄[0;36m█[0m      [33m▀▀▀▀█[0;32;43m▓▓▄▄▄[0;33;40m███▀▀▀[0;37;40m                [0m           [33;40m▀██▄[0;37;40m [0m      [33;40m█[0;1;35;43m░▒░[0;33m█[0m
[33m▓▓▓▓[0;37m [0;33m▐█▓░[0;36m▄[0;1;33;46m▄███▌[0;36m▌[0m   [36m▄[0;31;46m░[0;36;40m▄[0;37;40m    [0;32;43m▀██[0;32;40m▌[0;37;40m [0;33;40m        [0;37;40m                        [0m   [33;40m▀▀███▄▄▄[0;37;40m [0;33;40m▀▀▀▀▀[0m
[1;33;43m░[0;33m███▄[0;37m [0;33m░[0;37m [0;1;34;46m░░[0;36m▀▀[0;1;33m▀▀▀[0;36m▀▀▀█[0;31;46m░▓░[0;36;40m██▄▄[0;37;40m [0;32;43m▀█[0;32;40m█ [0;37;40m  [0m         [37;40m   [0m                         [33;40m▀▀▀███[0;1;33;43m░▒░[0;33m█[0m
[31;43m▄▄▄███[0;33;40m█▄[0m   [36;40m▄▄▄▓▓[0m    [31;46m░[0;1;33;46m░░░[0m   [33m▐[0;32;43m▐▓██[0;33;40m▄▄▄[0m        [37;40m   [0m                             [33;40m▄▄▄▄▄[0m
[33;40m█[0;31;43m█[0;1;33;41m░░[0;31;43m█[0;33;40m▀▀[0m    [36;40m▄[0;1;31;46m░░[0;1;36;46m░▒[0m  [36m▄▄█[0;1;33;46m▓▓▓[0;36m▌[0m   [33m█[0;32;43m░[0;33;40m▀▀▀▀▀▀▀[0m                                    [33;40m▀▀██[0;35;43m░░░[0m
[33;40m█[0;31;43m███[0;33;40m▌[0m   [36;40m▄▄[0;1;36;46m░[0;1;31;46m▓▓▓[0;36m▀[0m    [36m▀[0;1;33;46m▀███░[0m   [33m▓▓[0;37m  [0;33m░░[0m                                          [33m▀[0;35;43m▓▓▓[0m
[33;40m██[0;31;43m▓▓[0;37;40m [0;36;40m▄▄█[0;1;31;46m▄▄[0;1;31;47m░▓[0;1;31;46m▌[0;36m▌[0m      [36m▐[0;1;33;46m▐[0;1;37;40m██[0;1;33;46m▌[0;36m▌[0;37m  [0;33m░░[0;37m  [0;33m▓▓[0m                                           [33m▐[0;35;43m▀[0;1;35;45m░[0m
[33m▀▀[0;31;43m░░[0;33;40m▌[0;37;40m [0;1;36;46m░[0;1;31;46m▀█[0;1;31;47m▓░▓[0;36m█[0m     [37m [0;36m▄█[0;1;33;46m▀▀▀▓▓[0;36m▄ [0m   [33m▐[0;1;31;43m░░[0;33m▌[0m                                           [33m█▐[0m
[33m▌[0;36m▀▀▀█[0;1;31;46m▀▀▀▓░[0;36m▄▄███▀▀[0m   [36m▀▀▀▀[0;37m  [0;33m▄[0;1;31;43m ▓▓[0;33m█[0m                                           [33m▐[0m    [1;35;45m░[0m
[1;35;43m░[0;33m█▄█▌▄▄▄[0m    [36m▀▀▀▀[0m      [33m░░[0;37m [0;33m▄▄▄▄[0;1;31;43m▄▄██▀[0;33m█▌[0m                                          [33m▐[0;35;43m▓[0m
[1;35;43m▒▀[0;1;33;43m░▄▄██▄   ▄▄▄▄[0;33m▀▀██[0;31;43m░░[0;1;31;43m     ▄██[0;1;31;47m▓░▓[0;1;31;43m▀[0;33m█▀[0m                                            [35;43m▒[0m
[33;40m▀▀██[0;1;37;40m██[0;1;33;43m▀███▓▓▀ ▀[0;33m▌[0;37m  [0;33m█[0;31;43m▒▒[0;33;40m███[0;1;31;43m▄█▀▀▀[0;33m████████▄▄▄[0m                                       [1;33;40m▀[0m
[1;33;40m▀[0;33m▀██[0;1;33;43m ░░[0;33m██▀[0m   [33m▐[0;31;43m░░[0;33;40m█▀▀▀▀▀[0m       [33;40m░░[0;37;40m [0;33;40m▀▀▀█▄[0m   [33;40msome phukking stats![0m              [33;40m▓[0m    [33;40m▀[0m
[33;40m▀[0m       [33;40m▐▀[0m                                                          [33;40m░[0m







[1;30;40m--------------------------------------------------------------------------------[0m
[1;30;40myes, there are only 3 ansis from me in the pack but i really got  lack of time.[0m
[1;30mi hope to do some more for the next pack. i''ll draw requests as fast as possible[0m
[1;30mbut i already said, that i don''t have much time at the moment. but hey!? it''s [0m
[1;30msummer! who the hell needs ansis? =)[0m [1;30mgreets 2 all my friends and dewds who know [0m
[1;30mme. _try_ to reqeust an ansi by email [0;31mtrinity@shelter.tnet.de[0;37m [0;1;30mp.s. the ansi is[0m
[1;30malso for everybody![0m'
