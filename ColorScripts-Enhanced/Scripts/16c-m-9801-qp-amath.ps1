# Converted from: QP-AMATH.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/m-9801/raw/QP-AMATH.ANS
# Source Revision: archive-sha256:68027b949f7edfef662f12aa514dfc21e6e156e3984f9866a81997534ce6ce87
# Source SHA-256: 288754f163c2afafd92632b3d26e4958f041bb69ad694cb666a95e09286a25c0
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: QP-AMATH.ANS by quip (mistigris); released in m-9801 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: aftermath
# SAUCE Author: quip
# SAUCE Group: mistigris
# SAUCE Date: 19980111
# SAUCE Dimensions: 80x25
# Lines: 1-15
# Columns: 1-80

Write-Host '
          [34m░░░[0m
[37m [0;1;30m▄▄▄░░[0m  [34m░░[0;1;34;44m [0;1;34;40m▒[0;34m▓▓▒▒[0;35m  [0;37m▄▄▄▄▄  [0;34m          [0;37m  ▄▄[0m
   [1;30m▀▀█▄▄[0m [34m▀▀[0;37m  ▄▄▄▄▄[0;1;30;47m ░[0m▀▀[1m▀[0;1;47m▀▒[0m▄▄ [34m   [0;37m  ▄▄█[0;1;37m▒▒[0m█
 [1;30m ░░[0m  [1;30m▀[0m ▄▄█▀▀▀  [33m░░[0;1;30;47m░▒[0;1;30;40m▌ [0m░  ▀[1;47m▀▄[0m▄▄▄█[1;47m░[0m▀▀ ░[1;30;47m░[0m█ [34m░[0m   [1;37m   [0m
 [35m▄▄▒[0;37m ░▄█▀[0m   [37m▄▄█▀▀▀▀[0;1;30;47m▓[0;1;30;40m█░[0;1;37;40m [0m█[1m [0;34m  [0;37m▀[0;1;37;47m░[0m▀▀  [34m   [0;37m [0;1;30;47m▒░[0m [34m▒[0m      [1;37maftermath - op: subsonic[0m
 [34m ░[0;35m▀[0;1;37m [0m██  ▄[1;47m░[0m▀▀[1;30m  ▄▄  ▐█▒[0m ▐[1;47m░[0;1;40m▄▄  [0;1;30;40m░░[0m▄[1m▄[0;1;47m▄[0m [34m [0;1;30m▐[0;1;30;47m▓[0;1;30;40m▌[0;34m▐▓[0;1;34m░░[0m
 [34m█[0;1;34;44m▒[0m [1;47m [0m█  █[1m▒[0m░[35m▄▄[0;34m [0;1;30m  ▀█▄▐[0;1;30;47m▓[0;1;30;40m▓[0m ▐[1;47m░[0;1;40m▌[0m▀[1m▀▀▀▀[0;1;47m▀▓[0;1;40m▌[0;34m  [0;1;30m▐▓▌[0;34m▐[0;37;44m▄[0;1;34;44m░░[0;34m░░[0;37m  ansi by quip[0m
[37m [0;34m▒▒[0;37m▐[0;1;37;47m░[0m▌ ▐[1;47m░[0m▓[1;30m░[0m [35m▀▀[0;1;35;45m░[0;35m▄[0;1;30m ▐[0;1;30;47m▓[0;1;30;40m▌[0;1;30;47m▓▓[0m░ █[1;47m▒[0;1;40m [0;34m█[0;1;34;44m▄░[0;1;37;40m [0m▐[1;43m▓[0;1;40m▌[0;34m  [0;1;30m▐█▌[0;34m▐[0;1;34;44m▒[0;34m▓▓░░[0m
   [1;37m▐[0;1;37;47m▒[0m▌ [1;47m░▒[0m░  [1;34;44m▄[0;34m▄[0;1;37m [0;1;35m▒▒[0;1;30m [0;1;30;47m▒▓▒▒[0m░ █[1;47m▒[0m [34m▒▒▓[0;37m █[0;1;37;43m▓[0;1;37;40m [0;34m [0;37m [0;1;30m█[0m▒ [44m░ [0;34;40m▒▒[0m
[37;40m  [0;1;37;40m░█[0;1;37;47m▓[0m  [1;47m▒[0;1;40m▓[0;1;30;40m░[0m [34m▒▓▓[0;37m [0;1;35m▐[0;1;35;47m▓[0;1;35;40m▌[0;1;37;47m░[0;1;30;47m░[0;1;37;40m▓▓▄▄[0;1;37;47m▄[0;1;37;40m█[0m [34m░░[0;1;37m  [0;1;37;43m▒▒[0;1;33;40m [0;34m [0;37m [0;1;30m█[0m▒ [34m░░░[0m
[37m  [0;1;37m░██[0m [1m▐[0;1;47m▓[0;1;40m▌[0m   [34m░░[0;1;37m [0;1;35m▐[0;1;35;47m▒[0;1;35;40m▌[0;1;37;47m▒▒[0;1;37;40m░░░[0m    [1m   [0;33m▐[0;1;37;43m░░[0;1;33;40m [0m [1m [0;1;30m▒▒[0m
  ░[1m▒▒ ▐█▌[0m     [1m [0;1;35;47m░▒[0m [1;47m▓▓[0m [34m        [0;37m [0;33m▐██[0;1;33m [0;1;37m    [0m
  [1;30m ░░[0m  [1m ▀ [0m  [1m [0m▄▓▀  [1m▓▓[0m [34m     [0m     [33m░░[0;37m [0;1;30m-quip(MIST)[0m
      ░░▄▄▄█▀▀[0m'
