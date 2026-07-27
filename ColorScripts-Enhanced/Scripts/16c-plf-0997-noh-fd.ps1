# Converted from: NOH-FD.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/plf-0997/raw/NOH-FD.ANS
# Source Revision: archive-sha256:d6ce507ee095ab9c7ce1d91178b57bff0c61babde42a3957415461a430e18407
# Source SHA-256: f95f08a633026641720b5cf85b93a2aa6584a1581697ff465357ad366c7a4340
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: NOH-FD.ANS by nOah? (poffelipoff); released in plf-0997 and preserved by 16colors.
# Source Modification: Decoded from the attributed archive source and serialized from the rendered terminal cell matrix; project curation removes trailing rendered-blank rows plus standalone written-text and policy-ineligible display cells when present, while preserving retained ANSI controls, terminal-art glyphs, row geometry, and source coordinates.
# SAUCE Title: fd main! ;)
# SAUCE Author: nOah?
# SAUCE Group: poffelipoff
# SAUCE Date: 19970916
# SAUCE Dimensions: 80x21
# Lines: 1-21
# Columns: 1-80

Write-Host '
                 [1;30m      [0m
               [1;30m       [0m        [1;30m░░░░░[0m
               [1;30m     [0m    [1;30m░░▒▒▓▓████▌[0m                [31m▀[0;33;41m▀[0;1;31;43m▓▓░░[0;33;41m██▓░[0;31;40m█▀     ▀[0;33;41m▀██▀[0;31;40m▀ [0m
                      [1;30;40m░░▒▒▓▓█████▀[0m                  [31m▐[0;33;41m▐[0;1;31;43m▒[0;31m▌▄[0m      [31m▄▐[0;33;41m▄[0;1;31;43m▓▓░░[0;33;41m█▌[0;31;40m▌[0m
                      [1;30;40m  ▓▓██▀▀[0m                   [1;30m░░░[0;31m █[0;1;31;43m▒░[0;33;41m▄[0;33;40m▄[0;31;40m▄▄  █[0;33;41m█▀[0;31;40m▀   █[0;33;41m█▌[0;31;40m [0;1;30;40m░░░[0m
               [1;30m [0m        [1;30m██▌[0m         [1;30m ▄▄▄[0m             [31m█[0;1;31;43m░[0;33;41m▓░[0;31;40m█[0m   [31;40m▐[0;33;41m█[0;1;31;43m░[0;33;41m▄[0;31;40m▄   █[0;33;41m█[0;31;40m█[0m
        [1;30;40m▄[0;1;30;47m▓[0;1;30;40m▄▄ ▄█▓▒  [0m     [1;30m████▄[0m        [1;30m     ▄▄    [0m     [31m▀▐[0;33;41m▒░[0m     [31;40m ▀▀[0;33;41m▀███[0;31;40m█▌▀[0m
     [1;30;40m██▄▄▄▀▀▀▄▄▄▄████▄ ▐█████[0m      [1;30m▄▄███████████▄▄▄[0m
    [1;30m██[0;1;30;47m████[0;1;30;40m████████████ █████▌[0m       [1;30m█[0;1;30;47m▓▓[0;1;30;40m███████▓▓░░ [0m [31mf[0;1;31mf[0;31mfo[0;1;31mo[0;31mor[0;1;31mr[0;31mrb[0;1;31mb[0;31mbi[0;1;31mi[0;31mid[0;1;31md[0;31mde[0;1;31me[0;31men[0;1;31mn[0;31mn[0m
   [1;30m▐██[0;1;30;47m▒▒▓▓[0;1;30;40m██████████▀▄[0;1;30;47m█[0;1;30;40m████▓▓░░[0m     [1;30m███████▓▓░░[0m        [31md[0;1;31md[0;31mdr[0;1;31mr[0;31mre[0;1;31me[0;31mea[0;1;31ma[0;31mam[0;1;31mm[0;31mms[0;1;31ms[0;31ms[0m
   [1;30m▐██[0;1;30;47m▓▓[0;1;30;40m███████████▌▐█[0;1;30;47m▓▓[0;1;30;40m█████[0m        [1;30m▀█████░░[0m
   [1;30m███████████████▓▓░▀███████[0m       [1;30m▀████▄[0m
   [1;30m▐█████████████▀▄██▀██████▌[0m        [1;30m█▓▓▒▒░░  [0m/[1;30m command[0m   / [1;30mcommand[0m   / [1;30mcommand[0m
    [1;30m▐███████████▌▐█▀  ▀▀███▀[0m       [1;30m██▓▒▒░░[0m    /[1;30m command[0m   / [1;30mcommand[0m   / [1;30mcommand[0m
     [1;30m▀███████████▄▄ ▄█▄[0m         [1;30m  ██▓▒░░[0m      /[1;30m command[0m   / [1;30mcommand[0m   / [1;30mcommand[0m
       [1;30m▀▀██████████▐███▄   ▄[0;1;30;47m█[0;1;30;40m▄▄[0m    [1;30m▀▒▒░░[0m      /[1;30m command[0m   / [1;30mcommand[0m   / [1;30mcommand[0m
           [1;30m▀▀███████████████████▄[0m   [1;30m░░[0m        /[1;30m command[0m   / [1;30mcommand[0m   / [1;30mcommand[0m
               [1;30m▀██▀▀▀  ▀▀▀█▀▀    ▀▄▄ ▄ [0m       /[1;30m command[0m   / [1;30mcommand[0m   / [1;30mcommand[0m
    [1;30m      [0m         [1;30m▄▄██▄ [0m     [1;30m ▄▄[0m   [1;30m [0m          [1;30m        [0m     [1;30m       [0m     [1;30m       [0m
                 [1;30m████▄████▄▄██████▀▀[0m          /[1;30m command[0m   / [1;30mcommand[0m   / [1;30mcommand[0m
                [1;30m▀▀[0m    [1;30m▀▀▀███▓▓▒░░[0m'
