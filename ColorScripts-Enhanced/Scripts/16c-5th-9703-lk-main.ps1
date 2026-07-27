# Converted from: LK-MAIN.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/5th-9703/raw/LK-MAIN.ANS
# Source Revision: archive-sha256:fffb2c785ea5bb00b22bc525df88c9cca2a7e3ac70af213df8cc76a82e190c3a
# Source SHA-256: 3844c5e82958012149ab3ea8985b302d9e39984cc42b9c5841b98cefdca54c7b
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: LK-MAIN.ANS by lightning knight ((the 5th..)); released in 5th-9703 and preserved by 16colors.
# Source Modification: Decoded from the attributed archive source and serialized from the rendered terminal cell matrix; project curation removes trailing rendered-blank rows plus standalone written-text and policy-ineligible display cells when present, while preserving retained ANSI controls, terminal-art glyphs, row geometry, and source coordinates.
# SAUCE Title: the electric cube main menu
# SAUCE Author: lightning knight
# SAUCE Group: (the 5th..)
# SAUCE Date: 19970618
# SAUCE Dimensions: 80x22
# Lines: 1-22
# Columns: 1-80

Write-Host '
▄▀████████▀███████████████████▄
[36;47m  [0;37;40m▀[0;1;30;40m ▄[0m▓[1;30m▄▄▄▄▄▄▄▄▄▄▄▄[0m ▀[1;30m▄▄▄▄▄▄[0m ▀███                             [36m▒▒ [0m
[36;47m [0;37;40m [0;1;30;40m▄▀[0;36m ▄▄▄▄▄▄[0;1;34m [0;36m ▄▄▄▄[0;1;34m [0;1;30m▀▀[0;1;34m [0;36m▄▄▄▄[0;1;34m [0;1;30m▀▄[0m ██     [36m░░ [0m         [36m%MP[0;37m [0;36mm[0;1;32men[0;1;30mu[0m
[36;47m [0;37;40m [0;1;30;40m█[0;1;34;40m [0;36m▀ ▐[0;1;34;46m░░[0;36m▌[0;1;34m [0;36m▄[0;1;34;46m░░[0;1;34;40m  [0;36m▀[0;1;34;46m░[0;1;34;40m [0;36m▄[0;1;34;46m░░[0;36m▀ ▀[0;1;34;46m░[0m [1;30m█[0m ▀█
[36;47m [0;37;40m▄ [0;1;30;40m▀▄[0m [1;34m▐[0;1;34;46m▒▒[0;1;34;40m▌ [0;1;34;46m▒▒▒[0;1;34;40m█▄▄  [0;1;34;46m▒▒[0m [1;34m    [0;1;30m▐▌[0m ██
[36;47m  [0;37;40m█ [0;1;30;40m█[0m [1;34m▐[0;1;34;46m▓▓[0;1;34;40m▌ [0;1;34;46m▓▓▓[0;1;34;40m▀  ▄ [0;1;34;46m▓▓▓[0;1;34;40m   ▄[0;1;30;40m █[0m ▀█                                             [36m░░[0m
[36;47m  [0;37;40m█ [0;1;30;40m█[0m [34m [0;1;34m█[0;1;34;46m█[0;1;34;40m▌[0m [34m [0;1;34m▀█▄▄█▀[0m [34m [0;1;34m▀██▄█▀[0m [1;30m█[0m ██         [1;30m([0;36ma[0;1;30m)[0;32m  [0;1;32mautomessage [0m    [1;30m([0;36mq[0;1;30m)[0;32m  [0;1;32mqwk mail[0m
[36;47m  [0;37;40m█▄ [0;1;30;40m▀▄▄▄▄▀▀▄▄▄▄▄▄▀▀▄▄▄▄▄▄▀[0m ▄██   [36m▒▒[0m    [1;30m([0;36mm[0;1;30m)[0;32m  [0;1;32mmessages    [0m    [1;30m([0;36ms[0;1;30m)[0;32m  [0;1;32mautosig    [0m
[36;47m  [0;37;40m███▓▄▄▄▄█▄▄▄▄▄▄▄▄█▄▓▄▄▄▄▄████  [0m       [1;30;40m([0;36md[0;1;30m)[0;32m  [0;1;32mdoors[0;32m [0;1;32m    [0m [1;32m [0m    [1;30m([0;36mc[0;1;30m)[0;32m  [0;1;32muser config[0m
▀[36;47m  ░[0;37;40m█[0;36;47m░[0;37;40m█████▓███[0;36;47m░[0;37;40m▓█████[0;36;47m░[0;37;40m██[0;36;47m░[0;37;40m███[0;36;47m░[0;37;40m▀  [0m       [1;30;40m([0;36me[0;1;30m)[0;32m  [0;1;32memail       [0m    [1;30m([0;36mf[0;1;30m)[0;32m  [0;1;32mfiles    [0m
[36mt[0;37m [0;1;32mh[0m [1;30me[0m  [36me[0;37m [0;1;32ml e c t r i[0m [1;30mc[0m  [36mc[0;37m [0;1;32mu b[0m [1;30me[0m

[1;30m   [0;36m [0;1;30m [0m [1;32m            [0m [1;30m [0;36m [0;1;30m [0m [1;32m                 [0;1;30m [0;36m [0;1;30m [0m  [1;32m          [0m      [1;30m [0;36m  [0;1;30m [0m [1;32m            [0m
[1;30m   [0;36m [0;1;30m [0m [1;32m       [0m      [1;30m [0;36m [0;1;30m [0m [1;32m         [0m      [1;32m  [0;1;30m [0;36m [0;1;30m [0m  [1;32m            [0m    [1;30m [0;36m  [0;1;30m [0m [1;32m            [0m
[1;30m   [0;36m [0;1;30m [0m [1;32m         [0m    [1;30m [0;36m [0;1;30m [0m [1;32m           [0m    [1;32m  [0;1;30m [0;36m [0;1;30m [0m  [1;32m          [0m      [1;30m [0;36m  [0;1;30m [0m [1;32m             [0m
[1;30m   [0;36m [0;1;30m [0m [1;32m            [0m [1;30m [0;36m [0;1;30m [0m [1;32m              [0m [1;32m  [0;1;30m [0;36m [0;1;30m [0m  [1;32m               [0m [1;30m [0;36m  [0;1;30m [0m [1;32m            [0m

                                        [36m▒▒[0m
      [36m░░[0m
[36m        y [0;1;32mo u [0;1;30mr[0;36m  [0;1;32mo p e r a t o [0;1;30mr[0;36m  i [0;1;32ms[0;36m  l [0;1;32mi g h t n i n[0;36m [0;1;30mg[0;36m  k[0;1;32m n i g h[0;36m [0;1;30mt[0m'
