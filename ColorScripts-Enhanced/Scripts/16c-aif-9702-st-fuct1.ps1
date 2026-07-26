# Converted from: ST!FUCT1.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/aif-9702/raw/ST!FUCT1.ANS
# Source Revision: archive-sha256:3b9f61860c22d001c6e381a5b94c16d8789cd57ba721bbd4a78c247058aafa2b
# Source SHA-256: 3dd3212e6e2ea71cf619d7f073d63d580cae6b8dbb367d9b231a8cab44154576
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: ST!FUCT1.ANS by sterac (aif); released in aif-9702 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: fuct menu
# SAUCE Author: sterac
# SAUCE Group: aif
# SAUCE Date: 19970111
# SAUCE Dimensions: 80x25
# Lines: 1-22
# Columns: 1-80

Write-Host '
[34m               ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄          ▄▄▄▄▄▄▄          ▄▄▄▄▄▄▄               [0m
[34m      ███████▀▀█[0;1;37;44m F[0;34m██[0;1;37;44m [0;34m█ █████[0;1;37;44mU[0;34m█  ███████ █████[0;1;37;44mC[0;34m█▀▀███████ █████[0;1;37;44mT[0;34m█▄▄▄▄▄ ▄        [0m
[34m      ███▀ ▀█  ███████ ███████  ███████ ███████  ███████ █▀ ▀███  ▄▄▄▄▄▄▄       [0m
[34m      ████▄██  █[0;1;34;44m [0;34m█████ ██▀▓▀██  ███████ ███████  ▀▀▀▀▀▀▀ ██▄████  ███████      █[0m
[34m█[0;1;34;44m [0;34m████  ███████ ███▄███  ███████ ███████  ███████ ███████  ███████[0m
      [34m▀     ▀  ▀     ▀ ▀     ▀  ▀     ▀ ▀     ▀  ▀     ▀ ▀     ▀  ▀     ▀[0m
      [1;30m ░░░░░    ░░░░░   ░░░░░    ░░░░░   ░░░░░    ░░░░░   ░░░░░    ░░░░░ [0m
      [1;30m▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒ ▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒ ▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒ ▒▒▒▒▒▒▒  ▒▒▒▒▒▒▒[0m
      [1;30m▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓[0m
      [1;30m███████  ███████ ███████  ███████ ███████  ███▀███ ███████  ███████[0m
      [1;30m███████▄▄▄▄▄ ▄   ███████  ███████ ███████  ██▄▀▄██ ███████  ███████[0m
 [1;30m▓[0m    [1;30m███████          ▀▀▀▀▀▀▀▀▀███████ ▀▀▀▀▀▀▀▀▀███████ ▀▀▀▀▀▀▀▀▀███████[0m     [1;30m▓[0m
 [1;30m▒[0m                                                                       [1;32m [0m    [1;30m▒[0m
 [1;30m░[0m      [1;30m([0;1;37mJ[0;1;30m)[0m Join conferance   [1;30m([0;1;37mC[0;1;30m)[0m Comment to sysop   [1;30m([0;1;37mG[0;1;30m)[0;1;37m [0mPhree philes         [1;30m░[0m
[34m [0;1;30m·[0m      [1;30m([0;1;37mA[0;1;30m)[0m Area change       [1;30m([0;1;37mE[0;1;30m)[0;1;37m [0mEnter a message    [1;30m([0;1;37m#[0;1;30m)[0;1;37m [0mChange settings      [1;30m·[0m
[34m [0;1;30m░ [0m     [1;30m([0;1;37mU[0;1;30m)[0m Upload philes     [1;30m([0;1;37mR[0;1;30m)[0;1;37m [0mRead messages      [1;30m([0;1;37m=[0;1;30m)[0;1;37m [0mUser status          [1;30m░[0m
[34m [0;1;30m▒ [0m     [1;30m([0;1;37mD[0;1;30m)[0m Download philes   [1;30m([0;1;37mT[0;1;30m)[0;1;37m [0mTagged philes      [1;30m([0;1;37mY[0;1;30m)[0m Yell for sysop       [1;30m▒[0m
[34m [0;1;30m▓ [0m     [1;30m([0;1;37mN[0;1;30m)[0m New phile scan    [1;30m([0;1;37mS[0;1;30m)[0m Search 4 philes    [1;30m([0;1;37mB[0;1;30m)[0m Bulletins           [1;30m ▓[0m
[34m [0;1;30m█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█[0m
 [1;30;47m█[0;33;47m░[0;1;30;47m [0;30;47m P h u c t  [0;33;47m░[0;1;30;40m█[0;33;47m░[0;30;47m [0;37;40m█[0;31;47mShade[0;34;47m [0;31;47mmember[0;34;47m [0;31;47mb0ard[0;1;34;47m [0;34;47m [0;33;47m░[0;1;30;40m█[0;33;47m░[0;34;47m  Mainstream w0rld headQuarters[0;37;40m█[0;34;47m [0;33;47m░[0;1;30;40m█[0m
 [1;30m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀[0m'
