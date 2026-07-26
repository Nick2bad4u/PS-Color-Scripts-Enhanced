# Converted from: AK-CRYPT.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/fire-39/raw/AK-CRYPT.ANS
# Source Revision: archive-sha256:5e57507ce34170a4afb707b1587800d0885fae4776f1271b7b7cee7f71264d9d
# Source SHA-256: 0280e4e927a3ab0ae778fc5c8af5cc88bfff5bed56bfc3c121416379f9dc199a
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: AK-CRYPT.ANS by Abstrakt (Fire); released in fire-39 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: The Crypt
# SAUCE Author: Abstrakt
# SAUCE Group: Fire
# SAUCE Date: 20240303
# SAUCE Dimensions: 80x104
# SAUCE Font: IBM VGA
# Lines: 34-68
# Columns: 1-80

Write-Host '
                    [37mj$$$.[0m     [37m. / ,$$$l  .[0m       [37m`²*%↕┘.  `$$l ;[0m       [37m.''j[0;1;30m┘ [0;31mj$$$[0m
                   [37m,$$$$$$s┐┌s$P ,$$$$$; l    [0;1;30m`┐,[0m      [1;30m.''[0m  Y$i          /[1;30m'' [0;31m/└$$$[0m
                   [1;30m└[0m`d$$$$$$$$P.d└$$$$$l S      [1;30m`└*%%*┘''   [0m;$;          .,.  [31m`4$[0m
                   [37m.j$$$$$$$$┘,$┘ `└`²$$$$    [0;1;30m`.[0m         [1;30m,[0m j$           `''4b`[1;30m.[0m [31m$[0m
                   [1;30m`4[0m$jS┘$''$''d$┘      └$$$L    [1;30m`$/┐,.`.┌P''[0mj$''\             Y;  [31m$[0m
                   [1;30m/[0ms┐,.┌ j$$P''        Y$$$b  .  [1;30m`''²²²''`[0m.\$$$;    .⌐       l  [31mj$[0m
                   [1;30m`[0mY$$l  $$P          l$$$$b┐.└s┐,.,┐d$$$$$P    j┘`       '' [31m,$$[0m
                     [37m$$$b l$$.   j[0m     [37m:$l`└4$$$$$$$$$$$$$$P    [0;1;30mj[0m''        ` [31m.$$$[0m
                     [37mY $`b$$$$$S$$L    ,$7 j\Y$$$$$$$$┘d$$┘[0m                [31m.$$$$[0m
                     [1;30ml[0m.l $''j/$$P$$$b,,┌$7 ,$jP┘''^^$$P j$P''                [31m,$$$$$[0m
                     [1;30m`[0m$$$jj$ $''l$P$$$$$$p┘$P .┌\$P┘` jP''        ,[1;30m┌+[0m`     [31m/$$$$$$[0m
                      [37mj┘''  `4$┐$P Y$''dP$ d$bj$P$'',┘` `[0m     [37m; .┌[0m     [31m,┐,d$$$$$$$$[0m
                      [1;30ml[0m┌'' l, `4$L $'':$ $\Y$b` d''j`         lj''    [31m.d$$$$$$$$$$$$[0m
                      [37m$''  :$ ┐ `└4$p┐$s$$$$┐,.` l[0m          [37mI$    [0;31m.$$$$$$$$$$$$$$[0m
                      [37m$./  ` $ $ ┐ .,  . ,  `''4/$,[0m      [1;30mj[0m  Q''    [31m$$$$$$$$$$$$$$$[0m
                      [37m$`.b  .` T $ $$ ;$ $l b .`┘''[0m     [1;30m;$[0m ;$    [31mj$$$$$$$$$$$$$$$[0m
                      [37mT┐`┐ j$ ┌. ` └7 [$ $: $ [0;1;30mP[0m        [1;30ml[0m$ ll    [31m$$$$$$$$$$$$$$$$[0m
                      [37ml`b  `└ P'' $l  _. , , ''[0m          [1;30mI[0m$b$;   [31mj$$$$$$$$$$$$$$$$[0m
                      [37m$ `$b┐,,. `└4  l7 $ 7'' .┌`  .,   $$4$ [0;1;30m;  [0;31m$$$$$$$$$$$$$$$$$[0m
                     [37m;$b.`└*S$j$Ss┐,.''__`.┌j┘''`,\┘'' , jP'' $ [0;1;30ml  [0;31m`$$$$$$$$$$$$$$$$[0m
                     [37ml$7└$S%s┐.`└4$$$$$$$┘` .┌$$bs%P dP  ,$ [0;1;30m$;[0m  [31m$$$$$$$$$$$$$$$$[0m
                     [37m$$,.`┘$$$b.   `"''''`  . `.┘''j$P''dP  ,$'' [0;1;30m$[0m  [31mj$$$$$$$$$$$$$$$$[0m
                    [37m:$$`└$%$$$$$$b.  _.,⌐''.dP .dP'',d$,.┌P''  [0;1;30m`[0m [31m:$$$$$$$$$$$$$$$$$[0m
                     [37m4$$$$$$$7`└$$,..,,┌s$$$bjP'',$  \┘`  [0;1;30m,`[0m    [31m$$$$$$$$$$$$$$$$$[0m
                      [37m`4$$4$$$┐.$$$$$$$$$jS┘''.j$┘`[0m     [1;30m,d[0m   [1;30mj[0m'' [31m$$$$$$$$$$$$$$$$$[0m
                        [37m`'' `4j$$$$'',d$$┘` .┌┘`[0m     [1;30m;   `[0mY[1;30mk[0m  Y  [31m``''└*Q$$$$$$$$$$$[0m
                          [37mj/. `''└*↕SS⌐''  `[0m       [1;30m, l   [0m,P[1;30m''[0m  `\[1m [0mj$[1m/[0ms. [31m`└Q$$$$$$$$[0m
                          [37m$[0;1;37m$[0m$$[1m  [0m,               [1;30m,[0m;[1;30m [0m$   `       `└j[1m$$$[0mb. [31m└$$$$$$$[0m
                          [37ml[0;1;37m$ $[0m l$$┐ .,         ,j ,P        .$S[1ms.[0m `└[1mj$$[0m\[1m [0;31m`$$$$$$[0m
                          [37m:$[0;1;37m $ ;$$[0ml $[1m$[0m$.  .┐\'' Y'',    ┐[1m.   [0mdb.`└[1m$$┐[0m. [1m└$$k[0m [31m`$$$$$[0m
                           [1;37m`[0m [1mlb$$$l [0m$[1m$$$[0ml T[1m$[0m'' .` $$#'' `$b.  4[1m$b[0m.`[1m4$$[0mb[1m `$$: [0;31ml$$$$[0m
                          [1;30m`[0m  [1m:$$`$$,`$$$l l$b[0m \[1m┐,$$l[0m [1m└b`$$[0m$b 4[1m$$b[0m [1mYb[0m┐,[1md$$l [0;31m:$$$$[0m
[31m∙[0m                         [1;30m;,[0m  [1mYl l$$$$$$$ :$$b[0m [1m`$$$$b.$b`$$$[0mb [1m/b$b[0m [1mY$$$4$W  [0;31m$$$$[0m
[31m:[0m                         [1;30mj$\[0m  [1m''[0m :[1m$$.`┘$$; $$$$b$$$$$$$$$$$$$[0mb [1m`4$$s$$$7`$  [0;31m$$$$[0m
[31m:∙[0m                       [37m.[0;1;30m$$$b.[0m   $[1m$$ [0mj[1m$$$ :$$$$$$$$$[0m$[1m$$$$$$$$[0m`[1m4$$$$$$T j[0mP [31mj$$$$[0m'
