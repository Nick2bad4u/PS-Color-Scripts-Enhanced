# Converted from: BZ-DOORS.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/riot597a/raw/BZ-DOORS.ANS
# Source Revision: archive-sha256:f07656877106ee0a7da9f62e6293f74b4fe05cabd2e4ce82e7596d9ee3038c18
# Source SHA-256: 046d19174f0f5c3dd124c4e06a45d91f064831c6320e6f5c245a27cdaf4d8179
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: BZ-DOORS.ANS by Blaze-Riot (riot597a); released in riot597a and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# Lines: 1-39
# Columns: 1-80

Write-Host '
[32m░▒▓█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█▓▒░[0m
[32m▒  .a%%a%%a%%a.[0m     [32m..aa%%aa..[0m     [32m..aa%%aa..    .a%aa%%aa%a%a.   .aa%%aa%%aa  ▒[0m
[32m▓ ''a%a%a%%a%a%a`   ..a%a%%a%a..   ..a%a%%a%a..   $%a%%aa%%a%a%$   $[0;1;30m$$$$$$$$$$  [0;32m▓[0m
[32m█ .$$$''[0;1;30m$$$$[0;32m`a%a.   $$$[0;1;30m$$$$$$[0;32m$$$   $$$[0;1;30m$$$$$$[0;32m$$$   $$[0;1;30m$$$$$$$$$$[0;32m$$   $[0;1;30m$$$$[0;32m$$$$$$  █[0m
[32m█ .$$$[0;1;30m$$$$$$[0;32ma%a.   $$$[0;1;30m$$$$$$[0;32m$$$   $$$[0;1;30m$$$$$$[0;32m$$$   $$[0;1;30m$$[0;32m$$$$$$[0;1;30m$$[0;32m$$   $[0;1;30m$$$$[0;32m$ -[0;1;37mB    [0;32m█[0m
[32m█ .$$$[0;1;30m$$$$$$[0;32ma%a.   $$[0;1;30m$$$$$$$[0;32m$$$   $$$[0;1;30m$$$$$$[0;32m$$$   $$[0;1;30m$$$$$$$$$[0;32m$$    $[0;1;30m$$$$[0;32m$$$$$$  █[0m
[32m█ .$$$[0;1;30m$$$$$$[0;32ma%a.   $$$[0;1;30m$$$$$$[0;32m$$$   $$$[0;1;30m$$$$$$[0;32m$$$   $$[0;1;30m$$$[0;32m$$$[0;1;30m$$[0;32m$$[0m     [32m$[0;1;30m$$$$$$$$$[0;32m$  █[0m
[32m█ .$$$.[0;1;30m$$$$[0;32ma%%a.   `.a%a%%a%a.''   `.a%a%%a%a.''   $$$$$$  $$$$$    $[0;1;30m$$$$$$$$$[0;32m$  █[0m
[32m█ .a%a%a%%%a%a''[0m     [32m`.aa%%aa.''[0m     [32m`.aa%%aa.''    `.aaa''  `aaa.''   $$$$$$[0;1;30m$$$$[0;32m$  █[0m
[32m▓ $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$[0;1;30m$$$$[0;32m$  ▓[0m
[32m▒ $[0;1;30m$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$[0;32m$  ▒[0m
[32m░▒▓█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█▓▒░[0m
[32m▒[0m                                                                              [32m▒[0m
[32m▓[0m      [32m([0;1;32mC[0;32m)[0;1;32mommand[0m                   [32m([0;1;32mC[0;32m)[0;1;32mommand[0m                     [32m([0;1;32mC[0;32m)[0;1;32mommand[0m     [32m▓[0m
[32m█[0m                                                                              [32m█[0m
[32m█[0m      [32m([0;1;32mC[0;32m)[0;1;32mommand[0m                   [32m([0;1;32mC[0;32m)[0;1;32mommand[0m                     [32m([0;1;32mC[0;32m)[0;1;32mommand[0m     [32m█[0m
[32m█[0m                                                                              [32m█[0m
[32m█[0m      [32m([0;1;32mC[0;32m)[0;1;32mommand[0m                   [32m([0;1;32mC[0;32m)[0;1;32mommand[0m                     [32m([0;1;32mC[0;32m)[0;1;32mommand[0m     [32m█[0m
[32m█[0m                                                                              [32m█[0m
[32m▓[0m      [32m([0;1;32mC[0;32m)[0;1;32mommand[0m                   [32m([0;1;32mC[0;32m)[0;1;32mommand[0m                     [32m([0;1;32mC[0;32m)[0;1;32mommand[0m     [32m█[0m
[32m▒[0m                                                                              [32m▓[0m
[32m░░▒[0m                                                                          [32m▒░▒[0m
[32m░▒▓█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄██▓▒░[0m


[1;30mWell this menu was a total fluke, its not the greatest, but i had nothing to do.[0m
[1;30mi was home sick, and i was waiting to get a phone call from a friend, so i[0m
[1;30mdrew this in like 5 minutes.  Its not bad, but not my best work either.[0m

                                           [1;30m-[0;31mBl[0;1;31mA[0;1;33mZ[0;1;37mE[0m


                             [1;30mGreetings to:[0m
[1;37mTo anyone in Riot, and especially to anyone that has to do with one of my[0m
[1;37mfavorite groups (besides Riot) FUEL.[0m


[1;30mTo place a *free* request, e-mail me at:   praise@cnx.net[0m       [1;30mPut the[0m
[1;30mtitle as: Ansi Request.[0m'
