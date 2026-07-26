# Converted from: SPH_CRAC.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/soda05/raw/SPH_CRAC.ANS
# Source Revision: archive-sha256:edcd8c09880ef83cd065aedbbbd49213c8a0498be75fefb823526ab25fd48e6f
# Source SHA-256: 2682fcb72e5e240c8f002b5be9d6a236ac758b2c4cb41039af2eabc8e73de96f
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: SPH_CRAC.ANS by sephiroth (s0d4p0p); released in soda05 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: crack
# SAUCE Author: sephiroth
# SAUCE Group: s0d4p0p
# SAUCE Date: 19991113
# SAUCE Dimensions: 80x72
# Lines: 41-71
# Columns: 1-80

Write-Host '
[32m▐[0;1;32m▓[0;1;37;42m▒[0;1;32;42m█[0;32m▌░[0;37m  [0;32m██[0m      [32m [0;37m  [0;1;32;42m▒░[0;32m█[0m     [32m▐[0;1;32;42m▓▓[0;32m▌░[0;37m  [0;32m▀█  [0;37m [0;32m░[0m      [32m [0;1;32;42m░░▒[0;30;42m▓[0;32;40m▐██[0;1;32;42m░[0m   [32m██[0;37m  [0;32m▀▓[0;1;32;42m▀[0;32m▌▐[0;1;32;42m▒▓▒[0;32m ░▄▄[0;1;32;42m▄█▀[0;32m▀[0m
[32m▐[0;1;37m▒[0;1;32;42m▄▀[0;32m▌[0;37m   [0;1;32;42m░[0;32m█[0;37m+o Wkz  [0;32m [0;1;32;42m▓░[0;32m▌[0;37m [0;32m░▄▄[0;1;32;42m▄[0;32m█[0;1;32;42m▀▀░[0;32m▓█[0;1;32;42m░[0;32m▄[0m     [32m░[0;30;42m▓[0m    [32;40m▄[0;1;32;42m▒▒▓[0;32m▌█[0;1;32;42m░░[0;32m▌[0;37m   [0;1;32;42m░[0;32m█[0;37m   [0;32m░[0;37m  [0;32m█[0;1;32;42m▓█▓[0;32m▄[0;1;32m▓[0;1;32;42m▄▀[0;32m▀▀[0m
[32m▐[0;1;37;42m▒[0;1;32;42m▀▌[0;32m█░[0;37m  [0;1;32;42m▒[0;32m█[0;37m  [0;32m░[0;30;42m▓[0;32;40m░[0;37;40m   [0;32;40m ▄ [0;1;32;42m░[0;32m█▓██▀[0;37m   [0;32m▀▀[0;1;32;42m░▒▒▒[0m [1;32;42m░▓▓[0;30;42m░[0;32;40m▓[0;1;32;42m▄▄▄██▓▓█[0;32m▌█[0;1;32;42m▒▒[0;32m█[0;37m [0;32m░[0;37m [0;1;32;42m▒░[0m [32m░░[0;37m   [0;32m█[0;1;32;42m▀[0;32m▀▀[0;1;32;42m▀▀██▄[0;32m▄▄[0;37m [0;32m░[0;30;42m▓[0m
[37;40m [0;32;40m█[0;1;32;42m██[0;32m█▓▄ [0;1;32;42m▓[0;32m▓░[0;37m [0;32m  ▄▄[0;1;32;42m▄[0;32m█▀ ▄[0;1;32;42m▒[0;32m█▀[0m        [32m▐[0;1;32;42m▓▓▓[0m          [32m▐[0;1;37;42m▒[0;1;32;40m▓[0;1;32;42m▌[0m [32m▐[0;1;32;42m▓▓▄[0;32m▄[0;37m  [0;1;32;42m▓▒[0;32m [0m     [32m▄▄▀▄ [0;37m [0;32m▀▀▓[0;1;32;42m▀[0;1;37;42m▒[0;32m█[0m
[37m  [0;32m▀[0;1;32;42m▀▀▄▄[0;32m█[0;1;32;42m█[0;32m█▄▄[0;1;32;42m▄▄▀▀[0;32m▀[0;37m  [0;32m█[0;1;32;42m░▓[0m           [32m▓[0;1;32;42m▀█▄[0;32m▄▄[0m       [32m█[0;1;32;42m█▀[0;32m▀[0;37m  [0;32m▀[0;1;32;42m▀[0;1;32;40m▓[0;1;32;42m█▄[0;32m▄[0;1;32m▓[0;1;32;42m▓[0;32m ░▄▄[0;1;32;42m▄▀[0;32m▀[0;37m [0;32m▄█ [0;37m   [0;32m░█[0;1;32m▓[0;1;32;42m█▌[0m
[30;43m▓[0m    [32;40m▀▀[0;30;42m░[0;32;40m█[0;1;32;42m▀▀▀[0;32m▀▀[0;37m   [0;30;43m▓[0;37;40m [0;32;40m█[0;1;32;42m▓█[0m     [30;43m▓[0;37;40m [0;30;43m▓[0;37;40m   [0;32;40m░[0;37;40m [0;32;40m▀▀▀▀▀▄[0;37;40m   [0;32;40m▄[0;1;32;42m▄▀[0;32m▀[0;30;43m▓[0;37;40m [0;30;43m▓▓[0;37;40m  [0;32;40m▀▀[0;1;32;42m▀▀█[0;1;37;42m▒[0;32m█▓█▀▀[0;37m [0;32m██[0;1;32;42m▀[0;32m▓ [0;37m [0;30;43m▓▓[0;37;40m [0;32;40m █[0;1;32;42m█▄[0;32m▄[0m
[32m░[0m      [30;42m▒[0m           [30;42m░[0;1;32;42m▀[0;30;42m░[0;37;40m   100 % Original[0m    [32;40m█▓▀[0m            [32;40m▀▀▓░[0m       [32;40m░[0m      [32;40m ▀▓▀[0m
       [30;42m▓[0;37;40m  [0;32;40m░[0m        [30;42m▓[0;37;40m [0;30;42m▓[0;37;40m  ansi by sephiroth [0;32;40m▀[0;37;40m [0;32;40m░[0m               [32;40m░[0m                 [32;40m░[0m
                                                                     [32;40m░[0m
[1;30;40m--[0m
[1;30;40mIn this forest[0m
[1;30;40mWhere wolves cry their agony unto the moon[0m
[1;30;40mMy spirit is hidden[0m
[1;30;40mIn the form of wisdom[0m
[1;30;40mcarved on a black stone[0m

[1;30;40mThe only way to follow[0m

[1;30;40mOpen your soul[0m
[1;30;40mRedeem, I am immortal[0m

[1;30;40mBlinded by a light[0m
[1;30;40mMy soul is held up in glory[0m
[1;30;40mI engulf the skies[0m
[1;30;40mThe apostle in triumph[0m

[1;30;40mThrough the eternal flame I travel[0m
[1;30;40mAs the rain keeps falling....[0m

[1;30;40m(Quote from Opeth''s The apostle in triumph)[0m
[1;30;40m-[0m'
