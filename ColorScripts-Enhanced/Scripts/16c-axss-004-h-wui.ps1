# Converted from: $H-WUI.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/axss-004/raw/%24H-WUI.ANS
# Source Revision: archive-sha256:cc7ca8d7dcd1abdb52246b5cbdcd77ccd4fb36bf9ad0e41c6e03ec1642d8a422
# Source SHA-256: dc85d5ca444f0041ab892211f71119cf99bd9339c3c395d24edbffdfa007939d
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: $H-WUI.ANS by Shinigami (.%.AXss.%. -97); released in axss-004 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: Write User Info for RB !
# SAUCE Author: Shinigami
# SAUCE Group: .%.AXss.%. -97
# SAUCE Date: 19970617
# SAUCE Dimensions: 80x35
# Lines: 1-34
# Columns: 1-80

Write-Host '
[1;34;44m                                          ▄                               ▄    [0m
[1;34;44m       ▀         ▄█▀█▄                 ▄      ▀  ▄  [0;1;37;44m<[0;44mwRitE UsER inFo[0;1;44m>[0;1;34;44m  ▀    ▄  [0m
[1;34;44m        ▀  ▄▄    █▄ ▄█    ▄█▄ [0;30;44m▄[0;1;37;40m [0m▄▄[1m [0;30;44m▄[0;1;34;44m  ▄[0;30;44m                                        [0m
[1;34;44m   ▄▓▄      ▀█    ▀▀▀     ▀ ▓ [0;1;37;40m [0;44m█[0;1;47m▄▓[0;1;40m█ [0;1;34;44m    ▄[0;30;44m                                      [0m
[1;34;44m    ▀      ▄█▀ [0;30;44m▄▄[0;37;40m [0;1;33;40m▄▄▄[0m [30;44m▄▄    [0;1;34;44m▒[0;30;44m ▀[0;1;37;40m ▀▀ [0;30;44m▀ ▄▄▄                                       [0m
[1;34;44m         ▄ ▓  [0m [33m▄[0;1;33;43m▓[0;1;33;40m██████▄[0m [30;44m▄  [0;1;34;44m░[0;30;44m       █[0;37;40m▄[0;1;37;47m░[0;1;37;40m▄ [0;30;44m                                      [0m
[1;34;44m  ▄        ▒  [0;30;44m▀[0;37;40m [0;33;40m▀▀[0;1;33;43m▀▓[0;1;33;40m████▀[0m [30;44m▄▄▄▄ ▄▄▄  ▀[0;1;37;40m ▀ [0;30;44m▀                                      [0m
[1;34;44m    ▀  ▀   ░     [0m [33m▀[0;1;33m▀▀▀▀[0m ▄[1;47m░▄[0;1;40m██▄[0m ▄[1;47m▄[0m▄ [30;44m▄   ▄▄▄                                     [0m
[30;44m   ▄▄▄▄▄▄      ▄[0;37;40m [0;33;40m▄▄[0;1;33;43m▓[0;1;33;40m███[0m █[1;47m█[0;1;40m█▀ ▀[0m [1m▀ ▐[0;1;47m▒[0m [30;44m   █[0;1;37;40m▀[0;30;44m█                                     [0m
[30;44m▄[0;37;40m [0;1;33;40m▄▄████▄▄[0m [30;44m▄▄ [0;37;40m [0;33;40m▄[0;1;33;43m░▓[0;1;33;40m█████[0m █[1;47m▓[0;1;40m█▄  ▄[0m [1m█[0;1;47m▓[0m▀ [1;33m▄[0m [30;44m▄                                        [0m
[1;33;40m▄███████████▄[0m [33m▄[0;1;33;43m░[0;1;33;40m██[0;1;33;43m▀░▀[0;1;33;40m██▄[0m █[1;47m▀██[0;1;40m█▀[0m [1;33m▄▄▄███▄[0m [30;44m                                       [0m
[33;40m▀▀▀▀▀[0;1;33;43m ▀▀[0;1;33;40m█████▄[0;1;33;43m░[0;1;33;40m████[0;1;33;43m▄[0;1;33;40m████▄[0m ▀▀[1m▀[0m [1;33m▄███████▀[0m [30;44m                                       [0m
[30;44m    ▀▀[0;37;40m [0;33;40m▀[0;1;33;43m ▓[0;1;33;40m██████████████████████▀▀▀[0m [1;33m▄▄▄▌[0;30;44m▌                                      [0m
[1;34;44m ▄█▀[0;30;44m   [0;37;40m [0;33;40m▀[0;1;33;43m░[0;1;33;40m█████████████████████████████[0m [30;44m                                       [0m
[1;34;44m ▓[0;30;44m     ▄[0;37;40m [0;1;33;43m▐[0;1;33;40m███████████████████████████▀[0m [30;44m▀                                       [0m
[1;34;44m ▒[0;30;44m    ▄[0;37;40m [0;1;33;40m██████████████▀████████████▀[0m [30;44m▀                                         [0m
[1;34;44m ░[0;30;44m ▄▄[0;37;40m [0;1;33;40m▄████████[0;33m▀[0;1;33;43m▀▓[0;1;33;40m███[0m [1;33;43m ▐[0;1;33;40m█████[0m [1;33m██▀▀[0m [30;44m▀ [0;1;34;44m▄█▀█▄[0;30;44m                                     [0m
[30;44m  [0;37;40m [0;1;33;40m▄████[0;1;33;43m▀░▀[0;1;33;40m███▀[0m  [33m▀▀[0;1;33;43m▀▀▀[0m [1;33;43m [0;1;33;40m█████[0m [30;44m▀▀▀    [0;1;34;44m▓   ▀[0;30;44m                                     [0m
[30;44m  [0;37;40m [0;1;33;40m▀▀████[0;1;33;43m▄[0;1;33;40m█▀▀[0m [30;44m▀   ▀▀[0;37;40m  [0;33;40m▄[0;1;33;43m░[0;1;33;40m████[0m [30;44m▀ [0;1;34;44m▄     ▒       [0;1;37;44m([0;44m▲[0;1;44m/[0;44m▼[0;1;44m/[0;44mREtURn[0;1;44m)[0;44m To MovE AnD sElEct [0;1;34;44m▀ [0m
[30;44m    ▀▀▀▀▀▀▀▀   [0;1;34;44m▄▓▄[0;30;44m  [0;37;40m [0;33;40m▀[0;1;33;43m ▀▀[0;1;33;40m█▀[0m [30;44m▀     [0;1;34;44m▀  ░              [0;1;37;44m([0;44mESc[0;1;44m)[0;44m To qUit AnD sAvE  [0;1;34;44m▄  [0m
[1;34;44m$h              ▀[0;30;44m    ▀▀▀▀▀▀     [0;1;34;44m▀   [0;1;37;44m<[0;44mstAtUs[0;1;44m>[0;44m                                   [0m

[1;30;40m─-─-░─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-─-░─-─-─-─-─-─-─-[0m
  [30;44mN[0;1;34;40mame[0;34m: [0;30;44mW[0;1;34;40mrite User Info for RB ![0m        [30;44mB[0;1;34;40my[0;34m: [0;30;44mS[0;1;34;40mhinigami//AXss[0m              [30;44m1[0;1;34;40m997[0;1;5;34;40m_[0m
[1;30m─-─-─-─-─-─-─-─-─-─-─-─-─-─-░─-─-─-─-─-─-─-─-─-─-─-─-░─-─-─-─-─-─-─-─-─-─-─-─-─-[0m
  [1;34mThis Ansi is a Write User Info Ansi for RaveBase. Ordered by Maverick sumtime[0m
  [1;34mago in the beginning of ninety-seven... Anywayz, you know the score, please[0m
  [1;34mdon''t rip my pics (although I do admit that the fish may resemble work from[0m
  [1;34mseveral other people (like Dirt Bags work), BUT it is NOT a rip... I DO NOT[0m
  [1;34mDO RIPS... I did it completely out of my head, so c u then.[0m

                                                            [1;34m$ h í ∩ í Ç /┤ m ì[0m

                             [1;30mI[0m [1;30mcommand[0m [1;30mthe[0m [1;30mDevil...[0m'
