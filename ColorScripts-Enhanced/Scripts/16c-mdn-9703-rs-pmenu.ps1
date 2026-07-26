# Converted from: RS-PMENU.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/mdn-9703/raw/RS-PMENU.ANS
# Source Revision: archive-sha256:9e514042cc5e389aeb3f9323e41f842849e88d4294fdd727215463cf9566281b
# Source SHA-256: 98db818ae8556963ad4be09ea805384f55e6c0fd2861fc487f622b3c0ba2e5a6
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: RS-PMENU.ANS by rorshack (Maiden Brazil); released in mdn-9703 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: paranQia rnenu
# SAUCE Author: rorshack
# SAUCE Group: Maiden Brazil
# SAUCE Date: 19970221
# SAUCE Dimensions: 80x28
# Lines: 1-28
# Columns: 1-80

Write-Host '
          [35m  [0;1;35m▄▄▄▄[0m   [35m ▄▄▄   ▄[0;1;35m▄[0;35m▄▄[0;1;35m▄[0m   [35m [0;1;35m▄▄[0m          [35m▄▄    ▄▄[0;1;35m▄[0;35m▄[0m   [35m▄▄▄  ▄▄[0m
        [35m [0;1;35m▐[0;1;37m██[0;1;35m▀▀▀▀[0;1;35;45m▓▓[0;1;35;40m▄[0;35m▐███▌ ▐[0;1;35;45m░░[0;35m▀[0;1;35m▀▀[0;1;35;45m▓▓[0;1;35;40m▄▐[0;1;37;40m██[0;1;35;47m▒[0m    [1;35;45m░░[0;35m▌  [0;1;35;45m░░[0;35m▌[0;1;35m▄[0;1;35;45m▒▒[0;1;35;40m▀[0;35m▀▀██▄ ▄▄▄ [0;1;35;45m░░░[0;35m█[0m
          [1;35;47m▓[0;1;35;40m█▌[0m    [1;35;45m▒▒░[0;35m█▐█[0;1;35;45m░[0;35m ██▌[0m   [1;35m▐█[0;1;35;47m▓▓[0;1;35;40m███[0;1;35;47m▓[0m   [1;35;45m░▒▓[0;1;35;40m▄[0;35m [0;1;35m▐[0;1;35;45m▓▓▓▓[0m     [35m██▌[0;1;35;45m░░[0;35m▌▐[0;1;35;45m▒▒[0;35m██▌[0m
          [1;35m▐[0;1;35;45m▓▓[0;35m▄▄█[0;1;35;45m░░░[0;35m█▌ [0;1;35;45m░▒░░░[0;35m▄▄[0;1;35;45m░▒▓[0;1;35;40m▀[0;35m [0;1;35;45m▓▓[0;1;35;40m▌▐[0;1;35;45m▓▓[0;35m ▐[0;1;35;45m░░[0;1;35;40m▀[0;1;35;45m▓[0;1;35;40m█▄███▌[0m     [35m▐█[0;1;35;45m░▓▓[0;1;35;40m▌[0;1;35;45m▓▓[0;1;35;40m▌[0;35m▐██[0m
           [1;35;45m▒▒[0;35m▌   ▐██▀▀[0;1;35;45m▒▒▒▒[0;35m▌▀██▄  ▐[0;1;35;45m▒▒[0;35m ▄[0;1;35;45m░░░[0;35m▐██  [0;1;35m▀[0;1;35;47m▓[0;1;37;40m██[0;1;35;47m▓[0;1;35;40m▌[0;35m [0m    [35m▐█▌[0;1;35m▐[0;1;35;47m▓[0;1;35;40m████▄[0;1;35;45m░[0;35m█▌[0m
           [35m▐[0;1;35;45m░░[0m   [35m██▌  [0;1;35m▐[0;1;35;45m▓▓▓[0m   [35m▀██▄▐[0;1;35;45m░░[0;35m█▀ ▐███▌[0m    [1;35m▀[0;1;35;45m█▓▓[0;1;35;40m▄[0m   [35m▄██ [0;1;35m▐[0;1;35;47m▒[0;1;37;40m██[0;1;35;40m▌[0;35m [0;1;35m▀[0;1;35;45m▓▒░[0m
  [31m░░▐[0;1;37;41mr[0;1;37;40ms[0;1;30;40m.[0mmaid[1;45men[0;35m▌[0m     [1;35m▄▄▄[0;1;35;45m███[0;1;35;40m▄▄▄[0;35m  ▀▀██▌[0m    [35m▀[0;1;35;45m░░[0;35m▌[0m     [35m▀[0;1;35m▀▀▀[0;1;35;45m▓▒░[0;35m▀▀   [0;1;35m▀▀▀[0m    [1;35;45m░[0;35m█▌[0m
               [1;37m░░[0m    [1;35m▀███[0;1;35;47m▓▒[0;1;35;40m▀[0m             [35m░[0;30;45m▓[0;35;40m░[0m       [1;33;40m░░[0m      [1m░░[0m
[1;30m░[0m [33m░[0;30;43m▓[0;33;40m ▌▐▌██[0;1;33;43m░▓██[0;1;37;40m██[0;1;33;43m█▓░[0;33m█▐░[0;37m [0;1;35m▀[0;1;37m█▀[0;33m░[0;30;43m▓[0;33;40m▐▌[0;1;37;43m p a r  a n[0;35;43m░░[0;1;37;43m o i  a  [0;1;33;43m░[0;1;37;43m [0;1;33;43m░▓[0;1;33;40m███[0;1;37;40m██[0;1;33;40m██▌█▌▐▌[0m  [1;33m▌[0m  [1;30m░[0;33m░[0;1;33m░[0;1;30m░[0m [1;30m░[0m
               [1m░[0m        [35m [0m                [35m░░[0m                [1;37m░░[0m

     [1;30m[[0;1;37mx[0;1;30m][0m [1ms[0;1;32muper[0;32m metro[0;1;30mid[0m       [1;30m[[0;1;37mx[0;1;30m][0m [1mr[0;1;32mock''[0;32mn roll[0;1;30m racing[0m  [1;30m[[0;1;37mx[0;1;30m][0m [1mf[0;1;32m-zer[0;32mo[0m
     [1;30m[[0;1;37mx[0;1;30m][0m [1mt[0;1;32metri[0;32ms+bomb[0;1;30mlis [0m     [1;30m[[0;1;37mx[0;1;30m][0m [1ms[0;1;32muper[0;32m contr[0;1;30ma[0m        [1;30m[[0;1;37mx[0;1;30m][0m [1mu[0;1;32mltim[0;32ma[0m
     [1;30m[[0;1;37mx[0;1;30m][0m [1md[0;1;32moubl[0;32me drag[0;1;30mon[0m       [1;30m[[0;1;37mx[0;1;30m][0m [1mc[0;1;32mastl[0;32mevania[0m         [1;30m[[0;1;37mx[0;1;30m][0m [1mb[0;1;32mla b[0;32mla[0m
     [1;30m[[0;1;37mx[0;1;30m][0m [1mc[0;1;32montr[0;32ma[0m              [1;30m[[0;1;37mx[0;1;30m][0m [1mf[0;1;32matal[0;32m fury[0m          [1;30m[[0;1;37mx[0;1;30m][0m [1md[0;1;32muh, [0;32mfill h[0;1;30mere[0m
     [1;30m[[0;1;37mx[0;1;30m][0m [1mb[0;1;32mattl[0;32metoads[0m         [1;30m[[0;1;37mx[0;1;30m][0m [1ms[0;1;32muper[0;32m mario[0;1;30m 4[0m       [1;30m[[0;1;37mx[0;1;30m][0m [1mf[0;1;32morge[0;32mt this[0m
     [1;30m[[0;1;37mx[0;1;30m][0m [1ms[0;1;32mtree[0;32mt figh[0;1;30mter[0m      [1;30m[[0;1;37mx[0;1;30m][0m [1ma[0;1;32mctra[0;32miser i[0;1;30mi[0m        [1;30m[[0;1;37mx[0;1;30m][0m [1mo[0;1;32mne m[0;32more, h[0;1;30mum[0m
     [1;30m[[0;1;37mx[0;1;30m][0m [1mb[0;1;32mombe[0;32mrman i[0;1;30m ii iii [0m [1;30m[[0;1;37mx[0;1;30m][0m [1mg[0;1;32mhoul[0;32ms''n gh[0;1;30mosts[0m     [1;30m[[0;1;37mx[0;1;30m][0m [1mi[0;1;32m rea[0;32mlly du[0;1;30mnno[0m
     [1;30m[[0;1;37mx[0;1;30m][0m [1ma[0;1;32mdven[0;32mtures [0;1;30mof lolo [0m [1;30m[[0;1;37mx[0;1;30m][0m [1mb[0;1;32meavi[0;32ms & bu[0;1;30mtthead[0m   [1;30m[[0;1;37mx[0;1;30m][0m [1mo[0;1;32mk, t[0;32mhe end[0m

[1;30m------>8---cut cut cut cut ctu ctu tcu cctutcut ctunct cutn cunt cunt cunt------[0m

  [36mle comentés[0m
[37m  [0;36m-> this menuset is done for [0;1;36mhexadecimal[0;36m, sysop of [0;1;36mparanoia[0m
  [36m-> requested ''alive'' on the meganet meeting (feb/1996)[0m
     [36mhere it is, dude! i haven''t forget it :)[0m
[37m  [0;36m-> really cute, isn''t it? :)[0m
[37m  [0;36m-> to request an ansi, teach me agressive inline sk8ing[0m'
