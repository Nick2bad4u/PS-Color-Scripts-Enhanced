# Converted from: WA-BUNK1.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/yak9601a/raw/WA-BUNK1.ANS
# Source Revision: archive-sha256:0ef47e6c5957fc02130eec9688203a874e59abb766f403c5192fe56bd23b5e1f
# Source SHA-256: 915d62f322dd36f19bebc6ad157efd79ad31ebac575d7acb9286830a20a9cfae
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: WA-BUNK1.ANS by warpus (yak); released in yak9601a and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: bunk
# SAUCE Author: warpus
# SAUCE Group: yak
# SAUCE Date: 19951226
# SAUCE Dimensions: 80x25
# Lines: 1-41
# Columns: 1-80

Write-Host '
                                [36m▄▄▄▄▄[0;1;36m▄[0;1;36;46m▓[0;1;36;40m▄▄▄▄[0;1;36;47m▓[0;1;36;40m▄[0m
                             [36m▄███[0;36;46m▀[0;36;40m████████[0;1;36;46m▀▀█[0;1;36;47m▓▓[0;1;36;40m▄[0m        [1;36;40m▄[0m
                          [36m▄▄▀████████████████[0;1;36;46m▓[0;1;36;40m▌[0;1;36;47m▒[0;1;36;40m▌[0m      [1;36;40m▀[0;1;36;47m▓[0;1;36;40m▀[0m
            [36m▄[0m            [36m████ ████▀▓▀███[0;36;46m   [0;36;40m█[0;36;46m  [0;1;36;47m▓[0;1;36;40m▀[0;1;36;47m▓[0m      [1;36;40m▄[0m
           [36m▀█▀[0m            [36m▀▀▄██████▄████[0;36;46m   [0;1;36;46m▄  ▐[0;1;36;47m▓▓[0;1;36;40m▀ ■ ▀[0m
      [1;37;40m▄  ▄[0m       [36m■  ▄ ■ ▀ ▀■▄▀███████████[0;36;46m [0;1;36;46m▀█▀ ▐[0;1;36;47m▓▒[0m         [1;36;40m▄ ■ ▄[0m
[1;36;40m    [0;1;37;40m▄[0m     [1;37;40m■[0m                 [36m▐▌▐█████████████▀▀[0;1;36m▀[0;1;36;47m▓[0;1;36;40m▀[0m        [1;36;40m■[0m     [1;36;40m■[0m
     [1;37;40m▄   █▀[0;1;37;46m$[0;1;37;40m▄▄[0m      [1;37;40m▄ ■▄▄   [0;36m▀ ▀▀▀  [0;1;37m▄ [0;36m▀▀▀ [0;1;37m▄ ■ ▀   ▀  ■▄   [0;1;36m▀  [0;1;37m▄▄▄[0;1;37;47m▓[0;1;37;46m#[0;1;37;40m■ ▀ ■[0m
       [1;37;40m▀ [0;1;37;47m ▄ ▀▓[0;1;30;40mwarpy[0;1;37;40m■   ▐[0;1;37;47m▓█▀▀[0m [1;37;40m▄[0;1;37;47m▓[0;1;37;40m▄[0;1;37;47m█▀▓▀[0m  [1;37;47m█▓[0;1;37;46m@[0;1;37;40m▄▄▄▄▄ [0;36m▀■    [0;1;37m█▄[0;1;37;47m▓▀▓[0m [1;37;40m▀[0;1;37;47m▓  ▒ [0m▌    [1m▀[0m
         [1;47m▀▓▀ ▒[0;1;40m▀[0;1;47m▀▀▓[0;1;40m█▄   [0m▐[1;47m▒   [0m ▐[1;47m▒  [0m█[1;47m▒[0m▌[36m▄ [0;37m█[0;1;37;47m▒ ▀▒[0m [1;37;40m▐[0;1;37;47m█▓[0;1;37;46m█[0;1;37;40m▄    [0;1;37;47m  ▒[0m█[47m [0m  [40m▐██[0;47m [0;40m▀▌▀■[0m
         [40m██[0;47m [0;40m█▀  █[0;1;47m▒  [0m▀▄ ▐▀▓▀[47m [0m  [40m██[0;47m [0;40m██ [0;36;40m■[0;37;40m▐▌█[0;37;47m [0;37;40m█[0;1;37;47m░[0m  [1;37;47m ▒  [0m▌   ▓▀███▄▄█▀▀ ▀   ▀
         [1;34;47m░  [0m▄▓  ▐██▀[47m [0;40m▌▀█[0;47m [0;40m▄██  █[0;1;34;47m▒[0m██▌▄■▀▄████  ██▀▓▀   ▄[1;34;47m▄▓▄■[0m ▐█[47m [0;40m██▄▀ ■▀[0m
         [1;34;47m▒▄ ▒ [0m  █[1;34;47m▒[0m▄▓▄▀■█[1;34;47m▒ ▄▄[0m [1;34;40m▐[0;1;34;44m█[0;1;34;47m▓▄[0m▀    [1;34;47m▒[0m████ ▐[47m  [0;1;34;47m▒[0m▄[47m [0;40m▌  [0;1;34;47m▒ ▀  [0m  █[1;34;47m▒   [0m▌
    [1;34m▀    ▐[0;1;34;44m@[0;1;34;40m█[0;1;34;47m▓█[0;1;34;40m▄[0;1;34;44m&[0;1;34;40m█[0;1;34;47m▓[0;1;34;40m▀▀   ▐[0;1;34;47m▓[0;1;34;40m█[0;1;34;44m?[0;1;34;40m▄▀▀▀[0m      [1;34;40m▐[0;1;34;47m▓[0;1;34;44m#[0;1;34;47m▄▓▄[0m [1;34;40m▀▀▀[0;1;34;47m▓[0;1;34;40m▀██  [0;1;34;47m▓█[0;1;34;40m█[0;1;34;47m▓▄[0m  [1;34;47m▄▓[0;1;34;44m$[0;1;34;40m▀▀▀[0m
     [1;34;40m■ ▄ ■▀    [0;36m▄▄▄[0;1;32m▄[0;1;32;41m███[0;1;32;40m▄▄▄▄   [0;1;34;40m■  ▄ ▄ ■▀▀[0m       [1;34;40m▄    ▀■[0m       [1;32;40m▄■ ▄[0m
                [1;32;46m  ▒[0;1;32;40m█[0;1;32;46m█[0;1;32;40m█[0;1;32;47m██[0;1;32;40m▄▌ ▀■[0m             [1;32;40m■ ▀    ▀ ■ [0;1;34;40m▄[0m          [1;32;40m▄[0m
                  [36m▀▀▀[0;1;32m▀▀▄[0m     [1;32m▀[0m           [1;32m▀[0m     [1;34m▀ ▄  ■   [0;1;32m■ ▄ ▄  ■[0m
                        [1;32m■ ▄ ■[0m             [1;32m▀ ■▀[0m

[1;30m[cut.here.but.not.with.scissors.because.that.would.really.fuck.up.your.monitor][0m

[1;30mhaven''t done this in a long time, will be fun (and long):[0m

[1;30magent77 - you''re not getting my shirt[0m
[1;30mpism - indian jesus moses!  indian jesus moses![0m
[1;30mchastity - call eating?  thank you[0m
[1;30msilver dagger - nice bellybutton[0m
[1;30mpunchbowl - i want my cd''s.  and your pepsi shirt so i can set it on fire.[0m
[1;30mbucket - i want my fucking hotdog[0m
[1;30mnitris - i need bricks, and i need them now.  how''s cuba?[0m
[1;30mchoir boy - write a screenplay about sleepy bart.[0m
[1;30mwYvern - learn how to spell my handle you uhu stick fucker[0m
[1;30mike - see you next year.  will buy your cd when it comes out.[0m
[1;30mhennifer p - your dog pisses with 2 streams[0m
[1;30mepoxy - somebody tell this person that he is perfectly normal[0m
[1;30mmahey - write me.  email.  write.  write.  email.  now.[0m
[1;30mfirefox - show us big anma sign by airport.[0m

[1;30mwell not that long.  and in no particular order.[0m

[1;30mwarpus.yak[0m'
