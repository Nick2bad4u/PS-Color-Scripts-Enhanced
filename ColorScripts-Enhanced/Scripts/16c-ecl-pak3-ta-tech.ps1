# Converted from: TA-TECH.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/ecl-pak3/raw/TA-TECH.ANS
# Source Revision: archive-sha256:cde4af7e840865f437fedba26bbfb806e858a9b477c723c01bd9d080434c75bd
# Source SHA-256: 146207bad9ccfd206a4dee210b2451602938b6ce406feec3871308d6803da65c
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: TA-TECH.ANS by the avenger (ecolove); released in ecl-pak3 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: tech login
# SAUCE Author: the avenger
# SAUCE Group: ecolove
# SAUCE Date: 19980125
# SAUCE Dimensions: 80x28
# Lines: 1-28
# Columns: 1-80

Write-Host '
                                     [31m▄▄▄▄▄▄▄[0m
    [1;30m▓▀▀ ▀[0m  [1;30m▀[0m                     [31m▄[0;31;41m▓▓░░[0;31;40m▀  ▀[0;31;41m░░[0;31;40m█▄[0m
[1;30;40m  [0;31m  [0;1;30m▄[0;31m ▄█[0;31;41m░[0;1;30;41m░░[0;31m▀[0m         [31m▄▄▄█[0;1;30;41m░░[0;31m▄▄▄  ▐[0;31;41m█[0;1;30;41m░░[0;31m█▌    ▐[0;1;30;41m░░[0;31;41m▄[0;31;40m▌[0m
[1;30;40m▄▀▀▀▀[0;31m▐[0;1;31;41m▄▌  [0;31m▌[0m       [31m▄[0;1;31;41m▄[0;31m██[0;31;41m▀[0;31;40m▀   ▀[0;1;31;41m▐▄[0;31;41m▌▀[0;31;40m▄▐[0;31;41m░[0;31;40m█[0;31;41m▀[0;31;40m     ▀▀▀▀▄[0m     [34;40m░░[0m
[34;40m ▄[0;1;34;44m▄▄[0;1;34;40m▌[0;1;31;40m███[0;1;31;41m▄[0;1;31;40m█▄ [0;1;34;44m▄▄ ▄▄[0;1;31;40m▐██[0;1;31;41m▄█[0;1;31;40m▌[0;1;34;40m▄[0;1;34;44m▄░▄[0;1;34;40m▌[0;31m▐[0;1;31;41m██▄[0;1;31;40m█▌█[0;1;31;41m▄▐[0;1;31;40m▌[0;1;34;44m▄░▓[0;1;34;40m▌[0;1;31;40m▄▄▄▄▐ [0;34m▀▀[0;1;34;44m▄▄▓▓▄▄▄ ▄▄[0;34m▄[0m   [37mwelcome to :[0m
[34m▐[0;1;34;44m ▄▓[0;1;34;40m▌[0;1;31;40m█[0;1;31;41m▓▓▀[0;1;31;40m█ [0;1;34;40m▄[0;1;34;44m▌▄▓[0;1;34;40m▌[0;1;31;40m▄▄▄▄▄▐▄▄▄▄▄▄█[0;1;31;41m▓▓[0;1;31;40m█▀▐[0;1;31;41m▓▓[0;1;31;40m██▄ [0;1;34;40m▀[0;1;31;40m▐[0;1;31;41m▄█▄[0;1;31;40m▌█▀▀[0;1;31;41m▓[0;1;31;40m▄▄▄▄ [0;1;34;40m▀▀[0;1;34;44m▌▓▀ [0;34m▌[0m     [1;37mtech [0mbbs.  [1;30m▄[0m
[34m [0;1;34;44m░░▌▀[0;31m▐[0;1;31;41m▀█ ▀[0;1;31;40m▌[0;1;34;44m▀ ▀ [0;1;31;40m▐█[0;1;31;41m▀▓▓[0;1;31;40m▌█▌[0;34m▄▄▄▄▄[0;1;30m [0;1;31m▄[0;31m▄[0;1;31m▄▄ [0;34m▄▄[0;1;30m [0;1;31m▀▀▀▀[0;1;31;41m▓▓[0;1;31;40m▀▀▐█ [0;34m▄▄[0;1;30m [0;1;31m▀[0;1;31;41m▀▓▀[0;1;31;40m█▄[0;1;34;40m [0;1;34;44m▀░░[0;34m▌[0m
[37m [0;34m░░[0;1;30m   [0;31m▀█[0;1;31;41m [0;31m██▄  ▄[0;1;31;41m▀▌[0;31;41m█▄[0;31;40m▀▄[0;31;41m░░[0;31;40m▄    ▐█[0;1;31;41m░░[0;31m▌[0m        [31m░░█[0;1;31;41m▀[0;31;41m▀[0;1;31;41m▀[0;31m▌    ▐[0;1;31;41m▐[0;31;41m█[0;1;31;41m▓▌[0;31m▌[0;37m [0;34m■▀[0m                 [1;30m [0m
        [31m▀▀▀▀▀▀▀▀▀▀   ▀▀█[0;1;30;41m░░[0;31m▄▄█[0;31;41m░░[0;31;40m▀[0m           [31;41m░[0;1;31;41m░░[0;31m█▌    ▐█[0;1;31;41m ░░[0;31m▌[0m                    [1;30m▀ [0m
                                           [31m████▌   ▄█[0;1;30;41mta![0;31m▀[0m                     [1;30m▄ [0m
                                                                              [1;30m▀[0m
         [1mhandle: [0mrebel coder                                          [1;30m [0m       [1;30m▓[0m
[1m       password:[0m ···········                                                  [1;30m█[0m
                                                                  [1;30m▀[0m  [1;30m [0m [1;30m▀[0m [1;30m ▀▀ ▀▀[0m







[1;30m──--- -  -      -[0m             [1;30m-[0m   [1;30m      ·[0m
comment :

[1;30mi made this ansi voor a guy called rebel coder, it''s a loginscreen for his[0m
[1;30mboard. well, i guess it''s not too bad, but i won''t hang it in my hall of fame[0m
[1;30meither. :)[0m'
