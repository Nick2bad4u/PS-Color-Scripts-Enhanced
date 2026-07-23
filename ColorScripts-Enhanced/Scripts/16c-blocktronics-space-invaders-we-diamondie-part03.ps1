# Converted from: we-diamondie.ans
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/blocktronics_space_invaders/raw/we-diamondie.ans
# Source Revision: archive-sha256:c8f02d48521b213dd146adf31869fd604c2af314eab4dd9a1f4528b39146b7a9
# Source SHA-256: c1809e6d410828dee369e8c029e4276e496f5de558115cd17f384a3ba5bd7b27
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: we-diamondie.ans by Avenging Angel + Delicious + Enzo (blocktronics_space_invaders); released in blocktronics_space_invaders and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# Lines: 73-108
# Columns: 1-80

Write-Host '
  [35m ▀▄[0;36m▀▀▀[0;35m▄[0;1;35;45m▒▀[0;35m▄▄▀[0;1;35;45m [0;35m█[0;1;35;45m▄▄[0;1;35;40m▄[0;35m▄[0;37m [0;1;34m▀[0m▀[1;34;47m▄[0m███[46m ▄[0;40m████████[0;1;36;47m▀▀[0;36;47m▀[0;37;46m▀ [0;36;47m██[0;1;36;46m■[0;36;47m█[0;1;37;46m▄[0;1;37;47m███[0;1;37;46m▄[0;1;33;43m████[0;1;34;47m▄[0;1;34;40m▀[0m [35m▄█[0;1;35;45m  [0;35m▄ [0;36m▄▄▄[0;35m▀[0;1;35;47m██[0;1;35;45m▀[0m   [1;30m▄█[0m
  [1;34m█▄[0m [35m▀████▀[0;36m▄▄▄[0;35m ▄[0;1;35;45m▀▀[0;1;35;47m  ▀[0;1;35;45m▄[0;1;35;40m▄[0;35m▄[0;37m [0;1;34m▀[0m▀[1;34;47m▄[0m█[46m  ▀▀█[0;40m██[0;36;47m▀█[0;37;46m▀ [0;36;47m██[0;1;32;46m▄▀[0;36;47m█[0;1;37;46m▒[0;1;37;47m██████[0;1;33;47m█[0;1;33;43m▀[0m▀ [35m▄[0;1;35;45m▄[0;1;35;47m  [0;35m█[0;1;35;45m  [0;35m▄[0;36m▀▀▀[0;35m▄[0;1;35;45m█▀[0m       [1;30m▄[0m
    [1;34m ▄[0m [35m▀[0;33;45m  [0;35;40m▄[0;36;40m▀▀▀[0;35;40m▄[0;35;47m█[0;35;40m█▄▄▀[0;1;35;45m▀█[0;1;35;47m▄▄[0;1;35;45m█▄[0;35m▄▄[0;37m [0;1;34m▀[0;36m▀[0;1;34;46m▄[0;46m     [0;1;32;46m▄▄[0;1;36;46m [0;1;32;46m▀▀ [0;36;47m████[0;1;37;46m▀[0;1;37;47m███▀[0m▀ [35m▄[0;1;35;45m▄[0;1;35;47m▀[0;1;35;45m█▀[0;35m▀▄▄█[0;1;35;45m▄▄▄[0;1;36;45m  [0;35m█[0;37m  [0;1;30m▄█[0m   [1;30m▀▀[0m
  [1;34m▄  ▀▀[0m  [35m▀[0;1;35;45m▀[0;1;35;47m  ░░[0;1;35;45m█[0;35m▀[0;36m▄▄▄[0;35m ▄[0;1;35;45m▄▄ [0;35m▄▄▀██▄▄[0;37m [0;1;34m▀[0;36m▀[0;1;34;46m▄[0;1;36;46m [0;1;34;46m  [0;1;36;46m [0;36;47m██[0;1;36;46m▄▄ ▀[0;1;34;46m▄[0;1;37;46m▄[0;1;37;47m█▀[0m▀ [35m▄████▄ [0;36m▄▄▄[0;35m▀[0;1;35;45m▀[0;1;35;47m  [0;1;35;45m█▀[0m      [1;30m▄[0m   [1;30m▄█[0m
  [1;34m▀▀   [0m [1;34m█▄[0m [35m▀[0;1;35;45m▀███[0;35m▄[0;36m▀▀▀[0;35m▄[0;1;35;47m ▄[0;1;35;45m▀[0;35m▀[0;36m▄▄▄[0;35m ▄[0;1;35;45m▄██▄[0;35m▄ [0;37m [0;1;34m▀[0;36m▀[0;1;34;46m▄▄▄▄████[0;1;34;40m▀[0m▀ [35m ██▀ ███▄[0;36m▀▀▀[0;35m▄[0;1;35;45m█[0;1;35;47m▓▓[0;1;35;45m▀[0m [1;30m▄█[0m   [1;30m▀▀[0m
  [1;34m [0m  [1;34m█▄[0m       [35m██[0m     [35m▀███[0;37m    [0;35m▀▀[0;37m  [0;35m▀▀[0;37m [0;35m▄[0;37m  [0;1;34m░░░░░[0m     [35m█▄[0;37m  [0;35m▄ [0;37m    [0;35m██[0m          [1;30m▄[0m   [1;30m▄█[0m
  [1;34m█▄[0m        [35m██[0;37m  [0;35m██[0m       [35m▄█[0m        [35m▀▀[0m                [35m▀▀ [0;37m [0;35m██[0;37m  [0;35m██[0m       [1;30m▀▀[0m
              [35m▓▓[0m                                           [35m▓▓[0m
            [35m░░[0;37m  [0;35m██[0m                                       [35m██[0;37m  [0;35m░░[0m
              [35m░░[0m                                           [35m░░[0m

              [35m░░[0m                                           [35m░░[0m


                   [1;33mD1AMONDA L1SA - jamie martin[0;1;36mdel![0m
                                 [1;33m-[0m [1;33mluciano ayres[0;1;36mzo[0m
                                 [1;33m- ivan segaric[0;1;36mavg[0m




[1;32mreviews from the nazi i mean anzi queen herself.[0m

[1;32m"i can''t help thinking the highlights on the cheeks look really odd"[0m
[1;32m"the background looks abit odd to me and i dont like the logo much"[0m
[1;32m"just the trees seem a bit out of place"[0m
[1;32m"i think the the chick appears a bit plan and two dimensional compared to it"[0m
[1;32m"she looks like a geekied teacher version of lara croft to me, ansi could[0m
[1;32mperhaps be more "busy"[0m
[1;32m"just the logo at the bottom isn''t my very favourite"[0m
[1;32m"the only thing that i feel like could possibly be better is the sky"[0m
[1;32m"perhaps even a bit too messy for my tastes"[0m
[1;32m"though somehow i feel like they could have blended better with the logo"[0m
[1;32m"some parts feel a but too solid while others are bordering messy and there are[0m
[1;32ma few places that i feel are missing antialiasing, the nose of the chick looks[0m
[1;32mslightly too sharp to me."[0m'
