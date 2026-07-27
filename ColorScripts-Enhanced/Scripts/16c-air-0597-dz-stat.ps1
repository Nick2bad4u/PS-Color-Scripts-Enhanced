# Converted from: DZ-STAT.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/air_0597/raw/DZ-STAT.ANS
# Source Revision: archive-sha256:6fe653cdae1d1be3a85ad8606d04a6519ed3da6d9d33e501c49ef3bdd23379d9
# Source SHA-256: b6dd77c0cc22297d1f846954168b791e920c6a20f21f20b8814bfab0e58f8d70
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: DZ-STAT.ANS by daz (air); released in air_0597 and preserved by 16colors.
# Source Modification: Decoded from the attributed archive source and serialized from the rendered terminal cell matrix; project curation removes trailing rendered-blank rows plus standalone written-text and policy-ineligible display cells when present, while preserving retained ANSI controls, terminal-art glyphs, row geometry, and source coordinates.
# SAUCE Title: stat screen
# SAUCE Author: daz
# SAUCE Group: air
# SAUCE Date: 19970501
# SAUCE Dimensions: 80x24
# Lines: 1-24
# Columns: 1-80

Write-Host '
[32m       [0;34m   [0;35m   [0m        [35m [0m   [31m               [0m                                 [36m [0;32m      [0m
[32m   [0m      [35m        [0m         [31m               [0m                                    [32m   [0m
[32mQ[0;37m [0;1;30m.[0m    [35m.s$$$$$$$S.[0;37m   [0;36m [0m                  [34m.,s[0;37m   [0m                  [34m.,s[0;37m [0m
[32mS[0;37m [0;1;30m;''[0m   [33mQs[0;35m`ⁿS$S$$$$[0;37m   [0;36m [0;37m [0;34m .,s[0m         [34m.,s[0;1;34mSQ$''[0m     [34m.,s[0m         [34m.,s[0;1;34mSQ$''[0m
  [1;30m  [0m   [33m       [0;35m   [0;36m     [0;31m [0;34m       [0;1;34m [0;34m [0;1;34m [0;31m [0;34m  [0;1;34m   [0;34m    [0;37m     [0;34m      [0;1;34m [0;34m [0;1;34m [0;31m [0;34m  [0;1;34m   [0;34m    [0;37m [0m
         [33m       [0;1;31m  [0;36m  [0;37m  [0;31m [0;34m      [0;1;34m   [0;34m [0;31m [0;34m  [0;1;34m  [0;34m     [0;37m [0m    [34m     [0;1;34m   [0;34m [0;31m [0;34m  [0;1;34m  [0;34m     [0;37m [0m
        [36m.,s[0;33m`S$s''[0;36m,Ss,[0;37m  [0;31m [0;34m .SSG$$[0;1;34m$[0;34m$$[0;37m [0;34m `[0;1;34m$$[0;34mⁿQS,[0m      [34m.SSG$$[0;1;34m$[0;34m$$[0;37m [0;34m `[0;1;34m$$[0;34mⁿQS,[0m
      [36m                [0;31m [0;34m          [0;31m [0;34m  [0;37m  [0;31m [0;34m   [0m      [34m         [0;31m [0;34m  [0;37m  [0;31m [0;34m   [0m
     [36mSQ$$$$$$$$$s"$$$$[0;31m  [0m   [31m [0;37m [0;34m $$Q[0;31m [0;34mS$s,.[0m     [34mT[0;37m [0;34mA[0m    [31m [0;37m [0;34m $$Q[0;31m [0;34mS$s,.[0m
     [36m      [0;32m   [0;36m        [0;37m [0;34m    [0m   [34m   [0;31m [0;34m    [0;1;34m [0;34m [0;1;34m [0;34m [0;1;34m [0m     [34m   [0m   [34m   [0;31m [0;34m    [0;1;34m [0;34m [0;1;34m [0;34m [0;1;34m [0m
     [36m`S$s$$$$$$$$'',$$$[0m   [34mS$$[0;1;34mSs$[0;31m   [0;34mQ$$[0;1;34m$$$$Q[0;34m''[0m      [34mS$$[0;1;34mSs$[0;31m   [0;34mQ$$[0;1;34m$$$$Q[0;34m''[0m
      [36m`SQ$$$$$$$'',$$$''[0m   [34m`G$$[0;1;34m$[0;34m$SQ[0;31m [0;34m$QD$$[0;1;34m$Q[0;34m''[0;31m [0;37m [0m     [34m`G$$[0;1;34m$[0;34m$SQ[0;31m [0;34m$QD$$[0;1;34m$Q[0;34m''[0;31m [0;37m [0m
       [36m               [0;37m [0;34m      [0;1;34m [0;34m   [0;37m [0;34m         [0m     [34m     [0;1;34m [0;34m   [0;37m [0;34m         [0m
        [36m [0;34m          [0;36m   [0;37m [0;34m      [0;31m  [0m         [34m   [0;37m [0m    [34m     [0;31m  [0m         [34m   [0;37m [0m
         [34m            [0m               [1;36m [0;36m [0;1;30m            [0;31m    [0m
        [34m.QS$$$s$$$$$$[0m   [36m [0m           [1;36mn[0;1;30mEW MAIL :::: [0;31m [0m     [1;30m    [0;36m      [0;34m  [0m
       [34m.l$$$$$''$$$$$Sa[0m              [1;36mn[0;1;30mEW fILES ::: [0;31m [0m
      [34maS$$$$$$ $$$$$$$[0m              [1;36my[0;36m0[0;1;30mUR rATI[0;36m0[0;1;30m u/d ::: [0;31m     [0m
      [34m$$$$$$$$,$$$$$$$a,[0m            [1;36my[0;36m0[0;1;30mUR p[0;36m0[0;1;30mSTS :: [0;31m [0m
[37m       [0;34m            [0;37m      [0m           [1;36m [0;36m [0;1;30m            [0;31m       [0m
[37ms$$$$$$Qs[0;34m"S$$$$$""[0;37maS$$$$$s[0m
[37m                             [0;36m       [0m   [36m                   [0m
[32mQ[0m                                                                            [32m s$[0m
[32mSs,._[0m                                                                     [32m_.,s%Q[0m'
