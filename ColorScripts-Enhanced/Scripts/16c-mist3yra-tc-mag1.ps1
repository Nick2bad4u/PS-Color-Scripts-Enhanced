# Converted from: TC-MAG1.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/mist3yra/raw/TC-MAG1.ANS
# Source Revision: archive-sha256:2b1ec0b7cbe048c013d4fb5b84e23b783ff4f9f900b4e7c0cd1dcc3d31e02136
# Source SHA-256: 4f617ba3b51081108ab3e82937b441bb604b42ff82a3011a4ddbe80131abc2b3
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: TC-MAG1.ANS by Tincat (MiSTiGRiS); released in mist3yra and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: magnum interface
# SAUCE Author: Tincat
# SAUCE Group: MiSTiGRiS
# SAUCE Date: 19970918
# SAUCE Dimensions: 80x25
# Lines: 1-33
# Columns: 1-80

Write-Host '
       [33m▄[0;1;33m▄█▄▄[0m
 [33m░[0;30;43m▓[0;37;40m  [0;33;40m▄█[0;1;33;43m▐[0;1;33;40m███▀[0;1;37;40m█[0;1;33;40m▄[0m     [1mMAG[0mnum[1;30m release v.???[0m
   [1;33m  [0;33m▀█[0;1;33;43m▓[0;1;33;40m███▌█▀  [0m   [1;30mby the one and only [0msylphid[1;30m (aka goat)[0m
   [33m█▄▄[0;1;33m  ▀▀▀   ▄█[0m   [1;30ma [0mmistigris[1;30m coding division production[0m
   [33m▐[0;33;41m▓[0;1;30;43m [0;1;33;43m ▓[0;1;33;40m▄▄▄ █[0;1;37;40m██[0;1;33;40m▌[0m                  [34m  [0m
   [1;33m [0;31m▀[0;33m▀█[0;1;33;43m░[0;1;33;40m███▐█[0;1;37;40m█[0;1;33;40m█[0m  [34m     [0m         [34m▄▄█[0;1;34;44m░░[0m                 [34m ████[0m
[37m  [0;34m▄▄▄[0;37m  [0;33m█[0;1;33;43m▓[0;1;33;40m█████▌[0m   [34m █[0;1;34;44m▄▄▄[0;34m▌   ▄ ▀▀ ▐[0;1;34;44m███[0;34m▌[0m           [34m▄▄ ▀[0;37m [0;34m░█[0;1;34;44m██[0;34m█ [0m
[37m [0;1;34;44m░▓█[0;1;34;40m█[0;34m░[0;37m [0;33m▐[0;1;33;43m░█[0;1;33;40m████[0m [34m [0;37m  [0;34m▐[0;1;34;44m▐█[0;1;36;44m██[0;1;36;40m░[0m    [34m  [0m   [1;34;44m░█[0;1;36;44m██[0;1;36;40m░[0m  [33m [0;37m [0;34m░[0;30;44m▓[0;34;40m▄▄▀ [0;1;33;40m    [0m [34m▐[0;1;34;44m▐[0;1;36;44m█[0;1;34;44m▌[0;34m▌ [0m
[37m [0;34m▐[0;1;34m█[0;1;36m█[0;1;36;44m█[0;1;34;40m█[0;34m [0;37m [0;33m▀[0;1;33;43m▓[0;1;33;40m█▐[0;1;37;40m█[0;1;33;40m▌[0m [34m ░░█[0;1;34;44m████[0m   [34m▄▄▀▀ ▄[0;37m [0;34m▐[0;1;34;44m▐██[0;34m▌[0;33m [0;37m [0;34m▄▄[0;1;34;44m▄[0;34m█▀ [0;33m▄[0;1;33m▄█[0;1;33;43m▓[0;1;33;40m▌[0m  [34m▐[0;1;34;44m██▌[0;34m▌[0;33m▐█[0;1;33;43m░▓[0;1;33;40m██████████████████[0m
  [34m█[0;1;34m█[0;1;36m█[0;1;36;44m█[0;1;34;40m█▄[0m  [1;33m▀▐█[0;33m░[0;1;33m [0m [34m █▀▐[0;1;34;44m██[0;34m▌[0;37m [0;34m █▀[0;1;33m [0;33m▄[0;1;33;43m [0;1;33;40m▄[0m   [1;34;44m ▓[0;34m░ ▐█[0;1;34;44m██▓[0;34m▌[0;37m [0;33m█[0;1;33;43m▓[0;1;33;40m███ [0m  [34m█[0;1;34;44m██[0;34m█░[0;33m█[0;1;33;43m ▒[0;1;33;40m████████████[0;1;37;40m█████[0;1;33;40m██[0m
  [34m▐[0;1;34;44m░[0;1;34;40m██[0;34m▌[0;1;34m▀▀▄[0;34m [0;37m [0;1;33m▀▀ [0;34m ▀[0;37m [0;34m▐[0;1;34;44m ▓▓[0;34m▌░[0;30;44m▓[0;34;40m▌[0;37;40m [0;1;33;43m  ██[0;1;33;40m█ [0m [34m▐▌[0;37m [0;34m▄▄▄▐[0;1;34;44m▀[0;34m▀▀▄▄[0;37m [0;34m   [0;37m [0;34m▄▄▄[0;1;34;44m▓░[0;34m█░[0;33m█[0;1;33;43m ▒[0;1;33;40m████████[0;1;37;40m██[0;1;33;40m██[0;1;37;40m█████[0;1;33;40m█[0;34m█[0m
[1;34;44m░░[0;34m█[0m   [34m ▄ [0;37m [0;34m ▀[0;37m  [0;34m██[0;1;34;44m░░[0m [34m ▐ [0;33m▐[0;1;33;43m ░▓[0;1;33;40m██▌[0m  [34m▌[0;33m [0;34m [0;1;34;44m░▄▄▄[0;34m█[0;37m [0;34m [0;33m▄▄▄[0;1;33m▄▄[0m  [34m▐█[0;1;34;44m░[0;34m█▌[0;33m▐█[0;1;33;43m ░▒███[0;1;33;40m███████████████[0m   [34m▐[0m
[34m███▌[0;37m [0;1;37m▐▄[0m  [34m▄▌[0;37m [0;34m  ████[0;37m [0;34m ▐▌[0;37m [0;33m█▀▀[0;1;33m▀ [0;34m▄[0;37m [0;34m▀▀▌[0;1;33m [0;34m █[0;1;34;44m███[0;34m█ [0;33m▀[0;1;33;43m░▓[0;1;33;40m▀ [0;34m ▄████▌[0;33m▐█[0;1;33;43m  ░░▓▓████[0;1;33;40m███████████[0m   [34m█[0m
[35;44m░░[0;34;40m█[0;37;40m  [0;1;37;47m▓[0;1;37;40m [0m  [34m█▄[0;37m [0;34m ░▀[0m   [34m [0;1;34;44m▓░[0;34m▄[0;37m  [0;34m▀[0m   [1;30m   [0m   [34m [0;1;34;44m░███░[0;34m░ ▄[0;37m  [0;34m▀[0m                   [1;30m░░[0m  [1;30m░░░▓▓▓[0m    [34m▀[0m
[37m ▄[0;1;37m▄▌█ ▌[0m  [1;34;44m░█[0m       [34m  [0m   [1;33m [0m          [34m █[0;1;34;44m▓▀▀[0;34m▀[0;37m [0;34m [0m
       [37m▐[0;1;37;47m▓[0;1;37;40m▌█ ▌[0m                            [34m █▀ [0m
       [37m▐[0;1;37;47m▒[0;1;37;40m [0;1;37;47m▓[0;1;37;40m▌[0;1;37;47m▓[0m
       ▐[1;47m░[0;1;40m [0;1;47m▒[0;1;40m▌[0;1;47m░[0;1;40m [0m  hey sylphid!  i told you i was gonna do you an ansi didn''t i?!
      ░[30;47m▓[0;1;30;40m█[0m [1;47m░[0m█[1;30;47m▄[0;1;30;40m░[0m  well hey man, this could be used in so many places man.  like..
        [1;30m░[0m  [1;30m█░[0m   umm..  well.. i dunno..  oh!  you could use it as an info file
[1;30m---------------|[0mheader!  yeah!  or whatever you want.[1;30m|----------------[cut here [0m
[1;30m [0m                      [34m  [0m
      [1;30m [0;1;37m██[0m██[1;30m█[0m    anyways, i know MAGnum is gonna be hip as fuck man.  keep
      [1;30m [0m██[1;30;47m ▓[0;1;30;40m▌[0m    working the good work man.  i''m thinking of starting up an emag
      [1;30m [0;1;30;47m░░[0m█[1;30;47m█[0;1;30;40m▌[0m    of my own, what do you think of the name "sparkplug"?
       [1;30m█[0;1;30;47m▓▓█[0;1;30;40m▌[0m
       [1;30m█████[0m    anyways, i hope you like this ansi.  you can edit it and change
       [1;30m█▓██▓[0m    it and whack it up as much as you want man.
       [1;30m░▓██ [0m
       [1;30m ▓▓░[0m     oh and congrats on sfu and i hope you drink more beer than a
        [1;30m▒▒░[0m     russian street whore.
        [1;30m░░[0m'
