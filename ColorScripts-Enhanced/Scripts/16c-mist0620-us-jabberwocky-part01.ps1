# Converted from: US-JABBERWOCKY.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/mist0620/raw/US-JABBERWOCKY.ANS
# Source Revision: archive-sha256:7ee88774d07aa7bf9773f823f6d0b751342570148302f09cda1c046c6d496e0a
# Source SHA-256: 77c2c20b736119473bfa62e238a7ba4121c5010cc206fd90b3f638220cc775a5
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: US-JABBERWOCKY.ANS by Oddfirefox + LDA + Ldb + Polyducks + Cthulu (Mistigris); released in mist0620 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: Jabberwocky
# SAUCE Author: a bunch of cards
# SAUCE Group: Mistigris
# SAUCE Date: 20200616
# SAUCE Dimensions: 80x400
# SAUCE Font: IBM VGA
# Lines: 1-43
# Columns: 1-80

Write-Host '
           ▄▄▄▄▄▄▄[1;30m▄▄▄[0m
       ▄▀▀▀  1 2  ▀▀▀█▓▒[1;30m▌[0m
     ▄▀ 11▐█▌ [1;36m│[0m  ██ 1 ▀█▓[1;30m▌[0m       █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▄
   ▄▀ ▐█▌ ░░ [1;30m░[0;1;36m│[0;1;30m░[0m ░░ ▐█▌ ▀▓▒[1;30m▌[0m     █[1m↓Twas brillig, and the slithy toves    [0m█
  █ 10░░ [1;30m▄▄[0m   █   [1;30m▄▄[0m ░░ 2 ▓▒[1;30m▌[0m    █      [1mDid gyre and gimble in the wabe: [0m█
 ▄▀ ██ [1;30m/[0m      [31;47m░[0;37;40m      [0;1;30;40m\[0m ██ ▀█▓[1;30m▌[0m   ▀▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█
 █   ░░ [1;30m▒▒░[0m   [31;47m▒[0;37;40m   [0;1;30;40m░▒▒[0m ░░   █▓[1;30m▌[0m
 █ 9 ░░ [1;30m▒▒░[0m   [31;47m▓[0;31;40m▌[0;37;40m  [0;1;30;40m░▒▒[0m ░░ 3 █▓[1;30m▌[0m                 ▓[1;30m▌[0m
 █  ██ [1;30m\[0m      [31m▀█▓▄▄[0;37m  [0;1;30m/[0m ██  █▓[1;30m▌[0m                ▐█[1;30m▌[0m
  █   ░░[1;30m ▀▀[0m     [31m▀▀▓▒[0;1;30m [0m░░   ▄█▓[1;30m▌[0m                ▓▓[1;30m▌[0m
  ▀▄ 8 ▄▄ ░░ [1;30m░░░[0m ░░ ▄▄ 4 ▄▓▒[1;30m▌[0m                ▓█▓[1;30m▌[0m
    ▀▄ ▀▀  ▄▄   ▄▄  ▀▀ ▄▓▒[1;30m▀[0m                 ▐██▓[1;30m▌[0m
      ▀▄ 7 ▀▀ 6 ▀▀ 5 ▄▓▒[1;30m▀[0m                   ▓█▓▒[1;30m▌[0m
        ▀▀▀▄▄▄▄▄▄▄▄▓▒[1;30m▀▀[0m                    ▐██▓▒[1;30m▌[0m
                                           ▓██▓▒
                                          ▐███▓▒
                                ▄▄▄▄▄██▓▓ ▓██▓▒[1;30m█[0m ░░░[1;30m█▄▄▄▄[0m▄▄
                             ▄███████▓▓▓ ████▓▒[1;30m█[0m ▒▒▒▒▒▒▒▒▓▓▓▓▄
                         [32m▄▄█▌[0;37m████████████▄▀▀▀▀▀▄▓▓▓▓▓▓▓▓▓▓████[0;32m▐█▄▄[0m
[37m                       [0;1;32;42m▓[0;32m██[0;1;32;42m▒[0;32m██▄[0;37m▀▀███████████████████████████▀▀[0;32m▄█████▄[0m
[37m                      [0;32m▄[0;1;32;42m▒░[0;32m██[0;1;32;42m░[0;32m████▄▄▄▄▄▄[0;37m▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀[0;32m▄▄▄▄▄▄████[0;1;32;42m░[0;32m████▄[0m
[37m                     [0;32m▄██[0;1;32;42m▒░[0;32m█████[0;1;32;42m░[0;32m██████████████████████████████[0;1;32;42m░[0;32m████[0;1;32;42m░[0;32m█▄[0m
[37m                     [0;32m████████████▀▀▀▀▀███[0;1;32;42m░[0;32m███[0;1;32;42m▒[0;32m█████████[0;1;32;42m▒[0;32m██████████████[0m
[37m                      [0;32m▀█████[0;1;32;42m░[0;32m██▀[0;1;30m▄[0;30;47m■[0;1;30;40m▒▒░░[0;32m▐▀▀▀███[0;1;32;42m░▒[0;32m██████[0;1;32;42m░▒[0;32m████[0;1;32;42m░░[0;32m███████▀[0m
[37m                         [0;32m▀▀▀██▌[0;1;30m▒[0m█[1;30;47m░▓[0;30;47m■[0;1;30;40m▒▒[0;32m ▒[0;1;30m▀[0m▒[32m ████████████████████▀▀▀[0m
[37m                                [0;32m░░[0;1;30m▓▒▄[0;32mU▐[0;1;30m▀[0m▒ ▓[32m███████████▀▀▀▀▀[0m
[37m                                  [0;32m▄[0;1;30m▀[0m▒[32m░[0;37m [0;32m░[0;37m ▓                  [0;1;30m░░▒▒[0;30;47m■[0;1;30;40m▄[0m
                               [1;32;42m░[0;32m▄[0;1;32;42m▒▓[0;32m▀[0;37m [0;1;30m▒▓[0m ▀               ▒[1;30m▀  [0;32m░[0;1;30m▒[0;30;47m■[0;1;30;47m▓░[0m█[1;30m▒[0m
                                [32m▀▀[0;37m   [0;32mU[0;1;30m▀[0;32m░[0;37m               ▓ ▒[0;1;30m▀[0m  [32mU[0;1;30m▒▓[0;32m░░U[0m
[37m                                                        ▓   [0;32m░[0;37m▒[0;1;30m▀[0;32m▄[0m
[37m                                                         ▀ [0;32m░[0;1;30m▒[0m [32m▀[0;1;32;42m▓▒[0;32m▄[0;1;32;42m░[0m
      █▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▄              [1;30m█▀[0m    [32m▀▀[0m
[37m      █ [0;1;37mAll mimsy were the borogoves,[0m      █
      █       [1mAnd the mome raths outgrabe.[0m █
      ▀▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█

                                  [1m⌐-----------------------------------------¬[0m
                                  [1m|"Beware the Jabberwock, my son![0m          [1m|[0m
                                  [1m|The jaws that bite, the claws that catch!|[0m
                                  [1m└-----------------------------------------┘[0m

'
