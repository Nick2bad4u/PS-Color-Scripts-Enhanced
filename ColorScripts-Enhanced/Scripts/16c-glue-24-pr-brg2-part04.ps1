# Converted from: pr-brg2.ans
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/glue-24/raw/pr-brg2.ans
# Source Revision: archive-sha256:4ba1f499e1a6e81bad8d23a49c9f592b52fb39aaf053093edda57035a78ff770
# Source SHA-256: 5d711577bfaa33e6d4a4cc1dbd3d85b9b7511a75e31e8261171951fe096c21ee
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: pr-brg2.ans by propane (glue-24); released in glue-24 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: borgasm #2
# SAUCE Author: propane
# SAUCE Date: 19990730
# SAUCE Dimensions: 80x167
# Lines: 136-166
# Columns: 1-80

Write-Host '
[32m▀▌▀▀[0;1;30m [0;33m [0;5;30m [0m [1;32m [0;31m░░░[0;1;32m [0m [32m░[0;33m  [0;32m▒[0;33m  [0;37m [0;31m ░░[0;1;32m   [0m [1;30m [0;34m▄▄[0;35m [0;1;32m                        [0;31m  [0;1;32m            [0m [32m▐[0;1;32;42m▒▓[0;32m▄░ ▄▌[0;1;30;47m▓[0m
[33m▄[0;5;30m  [0;33m▄▓[0;32m [0;33m▌[0;37m [0;1;32m     [0m [33m     [0;37m [0;1;32m      [0m [33m▄[0;1;30m  [0;34m▀▓▄[0;1;32m    [0;1;33m░[0;1;32m    [0;34m▓▓▌[0;32m ▌▀■[0;1;32m [0;1;33m░[0;1;32m   [0;1;33m░[0;1;32m    [0;32m▐██ ▄▀[0;1;33m [0;1;32m [0;1;33m░[0;1;32m   [0;32m ▄▀[0;1;32;42m▀▄▓[0;32m▀ [0;1;30m▀[0m
[33m▀▌█▀█[0;1;33;43m░[0;33m▌[0;37m [0;1;32m     [0m [1;32m        [0;1;33m░[0;1;32m   [0;33m▐▓█▓▄[0;1;30m  [0;1;32m  [0;1;33m░[0;1;32m   [0;1;33m░[0;1;32m  [0;34m▐▓[0;1;30m [0;32m▀ [0;33m▄[0;37m [0;1;30m [0;1;33m░░░[0;1;32m [0;1;33m░░[0;1;32m [0;1;33m░░[0m [32m▒[0;1;33m [0;32m▓█▌[0;37m [0;1;32m [0;1;30m [0;1;32m    ▐[0;32m ▄▄[0;1;32;42m▒░[0;32m▄█[0m
[33m░[0;1;33;43m░░[0;33m█▀ ▌[0;37m [0;1;33m░░[0;1;32m  [0;1;33m░░ [0;33m▓▄[0;1;33m [0m [1;32m [0;1;33m░░[0;1;30m [0;1;32m [0;1;33m░░[0;1;30m [0;33m▓[0;1;33;43m░[0;33m██▒▒[0;1;30m [0;1;33m▒░░[0;1;32m  [0;1;33m░░[0m [34m▄[0;1;30m  [0;33m▒▀▌[0;1;32m [0;1;33m█▒▒▒░░░░▒▒[0;1;32m  [0;1;33m [0;32m░[0;1;33m  ░░[0;1;32m  [0;1;33m░░[0;1;32m [0;1;32;42m▒[0;32m▀[0;1;32;42m░▒▒[0;32m▀[0;1;32;42m░[0;32m▌[0m
[1;33;43m▄[0;33m████[0;1;33;43m░[0;33m▌[0;37m [0;1;33m▒▒▒▒▒▒ [0;33m▒▒▒[0;1;30m [0;1;33m░▒▒░░▒▒[0m [33m▒▓▒▒▒ [0;37m [0;1;33m▓▒░░░▒▒[0m [36m [0;33m▄████[0;1;32m [0;1;33m▐▓▓▓▒▒▒▒▓▓██▄▄▄██▒░░▒▒ [0;33m  [0;32m▐▄▀[0;1;32;42m░[0;32m▄[0;1;33m [0m
[33m█▀▀▄▀▀[0;37m [0;1;33m ▓▓▓▓▓▓[0m [33m░░[0;37m [0;1;30m [0;1;33m▒▓▓▒▒▓▓[0;1;30m [0;33m░░░░░[0;37m [0;1;33m▐█▓▒▒▓▓▓[0m [33m█[0;1;33;43m░[0;33m█[0;1;33;43m░[0;33m█▌[0;37m [0;1;33m▀▀▀▀▀[0;1;30m [0;1;33m▀▀▀▀[0m     [1;33m▀▓▓▒▒▓▓[0;1;30m [0;33m▐▄[0m   [33m▄[0m
[33m██▓█ [0;37m [0;1;33m▀▀▀█████[0m   [1;33m▄▓███▓▓██▄[0;1;30m  ▀[0m  [1;33m▄███▓▓███[0;33m ▐▀▀▄██▄▄▄▄▄[0;37m [0;1;33m▄▄▄▄▄[0m [1;33;43mc[0m    [1;33m██▓▓██[0m [33m [0;1;33;43m░[0;33m▌[0;1;33;43m░░[0;33m▄█[0m
[33m█▓▒███[0;37m  [0;1;37m█[0;1;33m██████▄█████████████▄███████████[0m [33m██▓▓███▓▓▒▓[0;37m [0;1;33m██[0;1;37m██[0;1;33m█▌[0;1;30m [0m    [1;33m▐████▓[0m [33m▐▓███▀▓█[0m
[33m▓▒░▓▓█▌[0;1;33m ▐████[0;1;37m██[0;1;33m██▓█▒▀ ▀▓████[0;1;37m█[0;1;33m▓██████[0;1;37m█[0;1;33m▓███[0m [33m▓█▒▒▓▓▀▒▒░▒[0;37m [0;1;33m▐██▓████▄▄▄█▓[0;1;37m█[0;1;33m██▒[0m [33m▓▀▓██▓▒▓[0m
[33m▒░[0;37m [0;33m▒▒▓[0;37m  [0;1;33m▀▓▓▒▓▒▓▓▒░[0m [1;33m░[0m [33m░[0;37m [0;1;33m ▒░▀▓▓▒▓▀▀[0;1;30m  [0;1;33m▓▓██▓▓[0m [33m▒▒░░▒▒▒░░▒▒░[0;37m [0;1;33m▀▓▒▓▓█▓▓█▓▒▓▓▀▀▓[0m [33m▒░▒▓▓▒▀░[0m
[33m░░[0;37m [0;33m░░[0;37m [0;33m░░[0;37m [0;1;33m░░[0m  [1;33m░[0m      [33m ░▒[0m    [1;33m▒▒░[0m   [33m░[0;37m  [0;1;33m▒░[0m [1;33m░▒[0m [33m░▒░░░ ░[0;37m  [0;33m░░[0;37m [0;33m░ [0;37m [0;1;33m░▒▒[0m [1;33m▒▒▒▒░[0m   [1;33m░▒░[0m  [33m░ ░[0m
[37m [0;33m░[0;37m  [0;33m░[0;37m  [0;33m░[0m   [33m [0m   [33m░ ░[0;37m  [0;33m▒ ░░[0m   [1;33m░[0m   [33m░░[0;37m [0;33m ░[0m    [1;33m░[0m [33m░[0;37m [0;33m ░[0;37m [0;1;33mborgasm # 2░[0m    [1;33m░░[0m     [1;33m░[0m   [33m░[0m






[37m-------------------------------------[0;1;37m[alt-y][0m------------------------------------

Well, the reason this ansi has turned out so well is because of all the help
i''ve been getting from kitiara, she kicks ass at ansi, and now  she''s trying to
help me get good, so big thank you to kitiara , if you don''t know who she is
your stupid....

[1mbtw this ansi has took longer then anything i''ve EVER drawn, i''ve redid it tons[0m
[1mof times, but i''m happy with the finished product, i dunno how many hours it  [0m
[1mtook exactly, but lets just say i''ve been drawing on it almost every day for[0m
[1mthe last month[0m

                                         propane.glue[0m'
