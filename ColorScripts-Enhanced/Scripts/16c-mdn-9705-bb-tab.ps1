# Converted from: BB-TAB.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/mdn-9705/raw/BB-TAB.ANS
# Source Revision: archive-sha256:42f41174635a4b9e44304d5d0f48b9b5aa0b6be93e48c5ea196226a31ced9fa8
# Source SHA-256: 49a1ad4daa85e573c1910ecb35bc9e91254a684f40a9868a2089af3fe9c26291
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: BB-TAB.ANS by Bugs Bunny (Maiden Brasil); released in mdn-9705 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: The Avatar Board
# SAUCE Author: Bugs Bunny
# SAUCE Group: Maiden Brasil
# SAUCE Date: 19970403
# SAUCE Dimensions: 80x17
# Lines: 1-16
# Columns: 1-80

Write-Host '
                     [1;33m▄[0m      [1;33m▄ [0m    [1;33m▄[0m
                      [1;33m▀[0m [1;33m■[0m    [1;33m■[0m   [1;33m■[0m   [1;33m [0m [1;33m▄[0m [1;33m▀[0m
           [1;35m▄[0m    [1;33m  ▄ [0m [1;33m [0;34m  [0;1;33m▄▄▄████[0;1;33;47m▄[0;1;33;40m▄▄[0m▄  [1;33m■[0m   [1;33m▄[0m
         [1;35m▀[0m    [1;34m▄▄▄▄▄▄▄[0;1;33m▓[0;1;33;47m▓▓▓▓▓[0;1;33;40m██ █ ███[0;1;33;47m▓░[0m▄[1;34m  ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄[0;35m  [0m    [1;35m▄[0m   [1;35m▀■[0m
       [1;35m■ [0m     [1;34m███████▄▄▄[0;1;33m▀████▄█ ██▀▀[0;1;34m▄▄▄▄▄▄▄▄█████▀███████▄▄▄▄▄▄▄[0;35m  [0;1;35m    ▀[0m
        [1;35m [0m     [1;34;44m▓▓▓▓▓▓▓[0;35m  [0;1;34m▄▄▄▄▄▄▄[0;1;33m▀▀▀[0;1;34m▄[0;1;34;44m▓▓▓▓▓▓[0;1;34;40m▀[0;34m  [0;1;34;44m▓▓▓▓▓▓[0;34m [0;1;34;44m▓▓▓▓▓▓▓[0;35m  [0;1;34m▀[0;1;34;44m▓▓▓▓▓▓[0;1;34;40m▄[0m    [1;35m■[0m
[1;35m▄[0;1;35;45m▓▓▓▓▓▓▓▓▓▓▓▓[0m [1;34;44m▒▒▒▒▒▒▒[0;35m   [0;1;34;44m▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒[0;34m▌[0;35m  [0;34m▓[0;1;34;44m▒▒▒▒▒▒[0m [1;34;44m▒▒▒▒▒▒▒[0;1;30;40m [0;1;35;40m [0;1;30;40m [0;34m▐[0;1;34;44m▒▒▒▒▒▒[0m [1;35;45m▓[0;1;35;40m▄[0;1;35;45m▓▓▓▓▓▓▓▓▓[0m
[1;35;45m▒▒▒▒▒▒▒▒▒▒▒▒▒[0m [1;34;44m░░░░░░░[0;35m   [0;34m▐[0;1;34;44m░░░░░░[0;34m▌▐[0;1;34;44m░░░░░░░[0;35m   [0;1;34;44m░░░░░░░░░░░░░░[0;34m░[0;35m  [0;34m▐[0;1;34;44m░░░░░[0;34m▀[0;37m [0;1;35;45m▒▒▒▒▒▒▒▒▒▒▒[0m
[1;35;45m░░░░░░░░░░░░░[0m [34m███████[0;35m  [0;34m▄██████▀░[0;37m [0;34m▀▀██████▄[0;35m [0;34m██████[0;37m [0;34m███████ [0;35m [0;34m▄███▀▀[0;37m [0;35m▄[0;1;35;45m░░░░░░░░░░░░[0m
[1;35;45m             [0m [34m▀▀▀▀▀▀▀▀▀▀▀▀▀▀[0;37m [0;35m▄▄[0;1;35;45m ░ [0;35m▄▄[0;37m [0;34m▀▀▀▀▀▀▀▀▀▀▀▀[0;37m [0;34m▀▀▀▀▀▀▀▀▀▀▀[0;37m [0;35m▄▄[0;1;35;45m░     [0;30;45m░ [0;1;35;45m      [0;35m▌[0m
[35m▄▄[0;1;35;45m [0;35m▄[0;1;35;45m    [0;30;45m░[0;1;35;45m [0;30;45m...The[0;1;35;45m [0;30;45mAvatar[0;1;35;45m [0;30;45mBoard?![0;35;40m▄[0;1;35;45m                  [0;30;45m░░░[0;1;35;45m   [0;30;45m[Bb?!/Mdn][0;1;35;45m        [0;35m█████[0m

[37m [0;1;37mOp. MinO_ [0m
 [1mBoard. Tab_[0m
 [1m+55-21[0m'
