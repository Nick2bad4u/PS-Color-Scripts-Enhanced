# Converted from: FD-ADC.ICE
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/ice-9402/raw/FD-ADC.ICE
# Source Revision: archive-sha256:542a55b371fcf2e1b6ce730207fe668cc74b9fc898d3341dc11812e6d7a4ac5c
# Source SHA-256: 62e537b96d2f7efba99945454e59106759e355cd3de07224e3cf4469ae20d2b2
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: FD-ADC.ICE by Final Descendant (ice-9402); released in ice-9402 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# Lines: 50-98
# Columns: 1-80

Write-Host '
      [31m█[0m      [31m█▀ [0;34m█▓▒░░░░░░░░░░ [0;31m▄█▀ [0;34m░░░░░[0m      [31m█▄▌[0m        [1;37m░▒▓██████▄▄▄▄[0m        [1;37m▓[0m
     [31m▀[0m      [31m█ [0;32;47m▓[0m [34;40m█▓▒░░░░░░░░░ [0;31;40m▄▌ [0;34;40m░░░░░░░░░░  [0;31;40m▄▀ █[0m            [37;40m▀[0;1;37;40m░[0m█      [1m▀▀▀▄▄   ▓[0m
         [31m▄▄▀  [0;32;47m▒[0m [34;40m█▓▒▒▒░░░░░░ [0;31;40m▄▀ [0;34;40m░░░░░░░ [0;31;40m▄▄▀▀▀   ▄▀[0m             [1;37;40m▒[0m█          [1m▀▄ ▒[0m
[1m   [0;31m▄▄▀▀▀▀[0m      [32;47m▒[0m [34;40m▓▓▒▒▒░░░ [0;31;40m▀▀ [0;34;40m░░░░░░░ [0;31;40m▄▀[0m     [31;40m▄▄▀ [0;34;40m░░[0m             [1;37;40m▓[0m            [1;37;40m▓▒[0m
[31m▄▀▀[0m             [37m▀▄[0;34m▀▓▒▒░▄█▓▒░ ▒░░░░ [0;31m▄▀  ▄▄▀▀▀ [0;34m░░░░░░░[0m           [1;37m█▌[0m            [1;37m▒[0m
                [32;47m░[0m [34;40m▄▓▒▒ [0;1;37;44m▒░[0;34m█▓▒ ▓▒░ [0;31m▄█▄▀▀▀ [0;34m░░░░░░░░░░░░░░[0m      [1;37m░  ▓▒░[0m░          [1m░[0m
               ▀▄[34m▀█▓▒▒▒ [0;1;37;44m▓▒░ [0m [31m▄▄▀▀  [0;34m░░░░░░░░░░░░░░░░░░[0m       [1;37m▒  █▀[0m
                 ▀ [34m▀ [0;31m▄▄▄▄▄▀█▀ [0;1;37;44m░[0;34m█▓▒░░░░░░░░░░░░░░░░░░[0m      [1;37m▄▀▓[0m▌ [1m▓[0m             [1m░[0m
               [31m▄▄▀▀▀▀ [0;34m▒▒▒ [0;31m█ [0;34m░ [0;1;37m▐[0;1;37;44m▒░[0;34m█▓▒░▄░░░░░░░░░░░░░[0m         [1;37m▐█▄▒[0m            [1;37m█▒[0m
                   [32;47m░[0m [34;40m█ [0;31;40m▄▄▀[0;34;40m░░░░ [0;1;37;44m▓▒░[0;34m█▓▒ ▓▒░░░░░░░░░[0m            [1;37m▀█░[0m          [1;37m▄██▓ [0;34;40m█[0m
[34;40m ▒▒▒▒[0m                       [34;40m░ [0;1;37;40m▐[0;1;37;44m▒░[0;34m█▓▒ █▓▒▒▒▒░░░░░[0m                     [1;37m▄▄▄████▓▓[0m
                     [32;47m▒[0m [34;40m█▓▒▒▒▒▒ [0;1;37;44m░[0;34m█▓▒░ █▓▒▒▒▒▒▒▒░░[0m              [1;37m▄▄▄▀▀▀▀[0m       [1;37m▀▒[0m
[1;37m ▀█▀▀▀▀▄[0m              [32;47m▓[0m [34;40m█▓▒▒▒▒ [0;1;37;44m░ [0;34m▒▒░░ █▓▒▒▒▒░░[0m             [1;37m▄▀▀[0m               [1;37m░[0m
[1;37m  [0m▐▀ ▐  [1m█ of[0m           [32m▌[0;34m▐▓▒▒▒▒ █▓▒▒░░ ▐▓▓▒░░[0m             [1;37m▄█[0m
[1;37m  [0;1;30m▀  ▀▀[0m▀▀              [32m▐ [0;34m█▓▒▒▒▒ █▓▒▒░ ▀▀[0m                [1;37m▐█▌[0m                  [1;37m░[0m
[1;37m ▀ ▄▀▀▄ ▄▀▀▄[0m           [32m▐▌[0;34m▐█▓▒▒░ █▓▒▒░░[0m                  [1;37m▐▓▒░[0m░                [1m▒[0m
[1m [0;1;47m▀[0m [1;40m▀[0m▄   [1;47m▀[0;1;40m═[0m            [32m▄██[0;34m▐▓▓▒▒░ █▓▒░░[0m                   [1;37m▐█▌[0m                  [1;37m▓[0m
[1;37m [0;1;30m▀   [0m▀[1;30m▀  [0m▀[1;30m▀▀[0m       [32m░▒▓███ [0;34m▀▓▒░░░▀░░[0m                      [1;37m▀█[0m                 [1;37m▐█[0m
[1;37ms [0mt [1;30mu d i [0mo [1ms[0m                                              [1m▀▄▄[0m            [1m▄▄[0;1;47m▀[0;1;40m▀▀[0m
                                                              [1;40m▀▀▀▄▄▄▄▄▄▄▀▀[0m▀    [1m█[0m
[1m▀▀[0m▀▀[1;30m▀[0m▀[1;30m▀▀[0m▀                  [1;30m▀▀▀▀▀▀[0m▀[1;30m▀▀▀▀▀▀▀▀ ▀▀ ▀▀▀▀▀▀ ▀▀ ▀ ░[0m
                 [1;37;47m▀[0m                                  [1;30;40m░[0m     [1;30;40m▒[0m
                 [1;30;47m▄[0m        [1;30;40m█[0m     [1;37;40m▄[0m▄[1;30m▄▄▄▄[0m            [1;30m▄▄▒[0m     [1;30m▓[0m
                 [1;30;47m▄[0m      ▄[1;30m▀█[0m       [1;30m▀▄  ▀▄[0m       ▄[1;30m▀▀ ▀[0m      [1;30;47m▄[0m
                 [1;30;47m▀[0m [1;30;40m▐▄▄[0m▀[1m▀ [0m▄[1;30m▓ ft[0me[1mr [0;1;30m░ ▐▌   ▒ a[0mr[1mk [0;1;30m▓▒░   [0m▐ [1;30ml[0mu[1mb [0;1;30;47m▀[0m
                 [1;30;40m▓[0m        [1;30;40m▒[0m      [1;30;40m▀▄▓ ▄▄[0m▄▀      [1;30m▀▄▄▄[0m▄[1m▀[0m     [1;30;47m▀[0m
                 [1;30;40m▒[0m        [1;30;40m░[0m                               [1;37;47m▄[0m
                 [1;30;40m░ ▄ ▄▄▄ ▄▄ ▄▄▄▄▄ ▄▄▄▄▄▄▄[0m▄[1;30m▄▄▄▄▄▄▄[0m▄[1;30m▄▄[0m▄[1;30m▄[0m▄▄[1m▄▄█[0m

[1m    █▀▀[0m▀▀[1;30m▀[0m▀[1;30m▀▀[0m▀▀[1;30m▀▀[0m▀▀[1;30m▀[0m▀[1;30m▀▀▀▀▀[0m▀[1;30m▀▀ ▀[0m▀ [1;30m▀[0m▀[1;30m▀ ▀▀ ▀▀▀▀▀ ▀▀▀▀▀ ▀▀  ▀▀ ▀    ▀[0m
[1;30m    [0;1;37;47m▀[0m
[1;37;40m    [0;1;30;47m▄[0m  [1;37;40mA[0mf[1;30mter Dark Club . [0;1;37mU[0mS[1;30mR 14.4 . [0;1;37m9[0m1[1;30m6·863·0919 . [0;1;37mT[0mo[1;30mns Of Disk Space![0m
[1;30m    [0;1;30;47m▄[0m      [1;37;40mS[0my[1;30mstem Staff · [0;1;37mG[0ml[1;30menn Danzig [0;1;37m<A[0mC[1;30miD/SPREADPOiNT/CSi>[0m
[1;30m    [0;1;30;47m▀[0m                   [1;30;40m· [0;1;37;40mC[0mr[1;30mewl Blade [0;1;37m<A[0mC[1;30miD/CSi/LUCiD>[0m
[1;30m    ▓[0m                   [1;30m· [0;1;37mJ[0ma[1;30mmes Bomb [0;1;37m<S[0mP[1;30mREADPOiNT/CSi>[0m                  [1;30m░[0m
[1;30m    ▒[0m                                                                   [1;30m░[0m
[1;30m    ░  [0;1;37mA[0mC[1;30miD Productions Member Board[0m           [1;37mA[0mL[1;30miVE Distribution Site  ▒[0m
       [1;37mC[0mi[1;30mA Distribution Site[0m              [1;37mC[0mo[1;30mrruption Distribution Site  ▄[0m
       [1;37mC[0mS[1;30mi World HQ[0m                                  [1;37mE[0mM[1;30mPiRE Western HQ  ░[0m
       [1;37mG[0mR[1;30miP/AD Distribution Site[0m                 [1;37mi[0mC[1;30mE Distribution Site  ▒[0m
       [1;37mI[0mr[1;30midium Distribution Site[0m           [1;37mP[0ms[1;30mychosis Distribution Site  ▓[0m
       [1;37mF[0me[1;30mderation Network Node[0m                 [1;37mS[0mt[1;30mormWatch Art Net Node  [0;1;30;47m▄[0m
       [1;37;40mA[0mc[1;30mcepting Artists Of All Speeds[0m                   [1;37mR[0mu[1;30mnning OBV/2  [0;1;30;47m▀[0m
       [1;37;40mN[0mo[1;30mw Supporting SNES Console[0m                  [1;37mN[0mo [1;30mNUP . No Ratios  [0;1;30;47m▀[0m
                                                                        [1;37;47m▄[0m
                   [1;30;40m▄[0m     [1;30;40m▄   ▄▄  ▄ ▄▄▄ ▄▄ ▄▄[0m▄[1;30m▄▄ [0m▄▄[1;30m▄▄▄▄▄[0m▄[1;30m▄▄[0m▄▄[1;30m▄▄▄[0m▄[1;30m▄▄[0m▄[1;30m▄[0m▄▄[1m▄▄█[0m

[1m   H[0mi [1;30mho, completed 2.16.94 [0;1;37m-[0m- [1mD[0mo[1;30mn''t puke, hez s''posed to look messed up[0m..[1m.[0m
[1m    G[0mr[1;30meets to Glenn, Kallizad, Quazar, and multiple others [0;1;37m-[0m- [1mi[0mC[1;30mE Studi[0mo[1ms.[0m'
