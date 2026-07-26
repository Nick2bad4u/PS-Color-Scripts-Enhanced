# Converted from: TV-NODES.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/cnc-0495/raw/TV-NODES.ANS
# Source Revision: archive-sha256:2750c3eb91102177ac7827a0c78cc6d205a04fd117977e6d1bb08e695e1ab2b4
# Source SHA-256: fe6316ea4b73eaa73bb734120da2cb801518332d284a61c8776999ef78046616
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: TV-NODES.ANS by The Venom (Cancer); released in cnc-0495 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: The Limp Nodes
# SAUCE Author: The Venom
# SAUCE Group: Cancer
# SAUCE Date: 19950317
# SAUCE Dimensions: 80x136
# Lines: 92-136
# Columns: 1-80

Write-Host '
           █[1;47m░░▒▒▒▒▓▓██▓▓[0m [1;47m░ [0m [1;47m  ░▒▒[0m
           █[1m▀[0m [1m [0;1;47m▒▒[0m    [1;40m▐[0;1;47m▓▓[0m [1;47m▒▒[0m [1;47m ░[0m
               [1;47m▒▓[0m    [1;40m▐[0;1;47m▓▓▒▒░[0m [1;47m░▒▒▓[0m
               [1;47m▓▓[0m    [1;40m▐[0;1;47m▓▒▒░░[0m [1;47m▒▓▓█[0m
               [1;47m▓█[0m    [1;40m▐[0;1;47m▓▓[0m [1;47m░ [0;1;40m [0;1;47m▓█[0m
               [1;47m██[0m    [1;40m▐[0;1;47m▓▒[0m [1;47m  [0;1;40m [0;1;47m█████[0m


               [1;40m██[0;1;47m▓▓▓[0;1;40m▄[0m     [1;40m▄▄▄[0m
              [1;40m█[0;1;47m▓▓▓▓▒▒[0m    [1;40m▐█[0;1;47m▓▓[0;1;40m▌[0m
             [1;40m█[0;1;47m▓▓▓▒▒░[0m      [1;40m▀▀▀[0m
            [1;40m▐[0;1;47m▓▓▓▒▒░[0m      [1;40m██[0;1;47m▓[0;1;40m▄[0m  [1;40m ▄██▄[0;1;47m█[0;1;40m▄ [0m  ▄[1;47m░░[0m▄  [1m▄██▄██▄[0m
            [1;47m▓▓▓▓▒░[0m      [1;40m██[0;1;47m▓▓▓[0m [1;40m ▐▀[0m [1;40m█[0;1;47m▓▒▒▒[0m▄[1;47m░░[0m███▌[1m▐█▀█[0;1;47m▓[0;1;40m█▀[0;1;47m▓▓[0m
           [1;47m▓▓▓▓▒░[0m      [1;40m▐[0;1;47m▓▓▓▒[0m▌ [1m [0m  [1;47m▓▓▒▒[0m▀[1;47m▒░░[0m▀▐██▌[1m▐[0m  [1;47m▓▒[0;1;40m▌[0m [1;40m▄[0;1;47m▒[0m
          [1;47m▓▓▓▒▒░[0m▄      [1;47m▓▓▒▒░[0m     [1;47m▓▒▒[0m▌  [1;47m░[0m   ██▌   [1;47m▒░▒▒▒[0m▀
          [1;47m▓▓▒▒░░░░[0m███▄ [1;47m▓▒░░[0m█▌   ▐[1;47m▓▒▒[0m      ▐██    [1;47m░░▒[0m
          [1;40m▀[0;1;47m▒░░░░░░░  [0m▀ [1m▀[0;1;47m▒░░[0m██▄ ▄█[1;47m░░[0m▀     ▄██▀    █[1;47m░░[0m
             ▀▀▀▀▀▀                           ▄ ███
                                               ▀▀▀
                                               [1m▄[0;1;47m▓▓[0;1;40m▄[0m
             [1;40m▄▄▄[0m        ▄▄▄                   [1m▐[0;1;47m▓▓[0;1;40m▀█ [0m
            [1;40m███[0;1;47m▓▓[0m      █████                  [1;47m▓▓[0;1;40m▌[0m
           [1;40m██[0;1;47m▓▓▓▓▒[0m     ▐███▌                 ▐[1;47m▒▓[0m
           [1;47m█▓▓▓▓▒▒▒[0m    ███▌   [1m▄▄▄▄[0m      [1m▄▄▄▄[0m [1;47m▒▒[0m▌
          [1m▐[0;1;47m▓▓▓▓▒▒▒▒[0m▌  ▐[1;47m░[0m██   [1m██[0;1;47m▓▓▒▒[0m    [1;40m██[0;1;47m▓▓▒▒▒▒[0m    [1;40m▄█[0;1;47m▓▓▓▒[0;1;40m█▄[0m   [1;40m▄██[0;1;47m▓▓▓[0;1;40m▄[0m
          [1;40m▐[0;1;47m▓▓▓▓[0m [1;47m▒▒▒▒[0m  █[1;47m░░[0m▌  [1m██[0;1;47m▓▒[0m [1;47m▒▒▒[0m  [1;40m██[0;1;47m▓▒[0m [1;47m▒▒▒░[0m   [1;40m▐█[0;1;47m▓▓[0;1;40m▀[0m  [1;47m▒▒[0m  [1;40m██[0;1;47m▓[0;1;40m▀[0m  [1;47m▓▓[0m
          [1;47m▓▓▓▓[0;1;40m▌[0m  [1;47m▒▒▒[0m▄▐█[1;47m░░[0m  [1;40m▐[0;1;47m▓▓▒[0m   [1;47m▒░[0m [1;40m▐[0;1;47m▓▓▒[0m   [1;47m▒░[0m    [1;47m▓▓▓▒[0m▄  [1m▄[0;1;47m▒[0m  [1;40m█[0;1;47m▓▒[0;1;40m▄[0m   [1;40m▐[0m
         [1;40m▐[0;1;47m▓▓▓▓[0m   ▐[1;47m▒▒▒[0m█[1;47m░░[0m▌  [1m▐[0;1;47m▓▒[0m   ▐[1;47m░[0m█ [1m▐[0;1;47m▓▒[0m   ▐[1;47m░ [0m   ▐[1;47m▓▓▒▒▒▒[0;1;40m▓▀[0m    ▀[1;47m▒▒▒░[0m▄
         [1m█[0;1;47m▓▓▓▒[0m    [1;47m▒▒░░░░[0m   [1;47m▒▒░[0m▌  [1;47m░[0m█▌ [1;47m▒▒░[0m▌  [1;47m░ [0m    [1;47m░▒░░[0m▀   ▄█  █   ▀[1;47m░░[0m▄
        [1m▐█[0;1;47m▓▒▒[0;1;40m▌[0m    ▀[1;47m░░░░[0m▀   ▐[1;47m░[0m██▄██▌  ▐[1;47m░  [0m▄[1;47m  [0m██▄▌ ▐[1;47m░░░░[0m▄▄██▌  ██▄ ▄█[1;47m░░[0m
        [1;40m ▀▀▀[0m       ▀▀▀▀     ▀▀▀▀▀     ▀▀▀▀▀  ▀▀ [1m   [0m▀▀▀▀▀▀[1m   [0m  ▀▀▀▀▀▀


        [1m    [0m            [1m [0m───══[1m THe LiMP NoDES [0m══───
                   [1m [0m  [1mPCBoard 15[0m.[1m2[0m [1mModded[0m [1mFor Your Needs[0m
            [1m    [0m           [1mBlazing Under 28800 bps![0m
                        [1mInt[0m''[1ml Cracking Order W0RLD Hq[0m
              [1m    [0m         [1mNode 0NE[0m ►[1m 7i3[0m.[1mxXx[0m.[1mXxXx  [0m
                   [1m [0m          [1mLAMεRz ReSTRiCTeD[0m

                             [1mSySOP[0m:[1m LiMPY[0m/[1mSKeTCH[0m

[1;30m─────────────────────────────────────────────────────────────────────────────[0m
   ANSi/Logo by The Venom of [1mCANCER[0m Productions  [1;30m■ [0m [1m136[0m Lines  [1;30m■  [0mO3.13.95[0m'
