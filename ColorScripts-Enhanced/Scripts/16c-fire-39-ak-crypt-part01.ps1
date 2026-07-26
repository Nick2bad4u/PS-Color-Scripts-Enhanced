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
# Lines: 1-33
# Columns: 1-80

Write-Host '
                       [1;37;40m;$l l$$$$$$P d$$[0m7
 [31md$$$$$''j d$$$$b d$$$b[0;37m  [0;1;37m$; └4$j$$$; $j7 [0;31m,$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$b[0m
[37m [0;31mQ$$$7''j$ Q$ j$''j$7$$$[0;37m  [0;1;37m'',$$b┐.`''┘  ` _[0m`[31m└4$$$$$$$$$$$$$$$$$§§§§$$§§§§§$$$§§§§$$$[0m
[37m [0;31m`$$   `'' Q$j$'' `$b.[0m     [1;37m$$$`''└/.`4$$$$[0m$;[31m `$$$$$$$$$$$$$$$§§$$§§$§§$$§§$§§$$$$$$[0m
[37m  [0;31mQ$$$ $$ Q$$b   `$$b    [0;37m$[0;1;37m$$$jSs.  4┘''`,[0m┌[31m ,$$$$$$$$$$$$$$$§§$$§§$§§$$§§$§§$$$$$$[0m
[37m  [0;31mQ$P'' Q$ $`4$b  j$7''    [0;37m`└[0;1;37m4$.,┐, ,┌s7 $: [0;31m$$$$$$$$$$$$$$$$§§§§§§$§§§§§$$$§§§§$$$[0m
[37m  [0;31mQ$   Q$ $  `$b Q$[0m      [1;37mg┐. `└4$$$$P dP [0;31m`4$$$$$$$$$$$$$$$§§$$§§$§§$$§§$$$$$§§$$[0m
[37m [0;31mQ$$$ Q$$ Q$ $$$ Q$$$$  [0;1;37m:$$$$$/.`└Q[0m$$[1mP'',┐. [0;31m''$$$$$$$$$$$$$$§§$$§§$§§$$§§$§§$$§§$$[0m
[37m [0;31mQ$$$ Q$$ Q$ $$$ Q$$$$  [0;1;37ml$$$$$j$S[0mb,`''[1m.d$$$; [0;31ml$$$$$$$$$$$$$§§$$§§$§§§§§$$$§§§§$$$[0m
[37m [0;31mQQQQ QQQ QQ QQQ QQQQQ;[0;37m :$[0;1;37mP┘''`.[0m [1m,┌[0m⌐┐d[1m$↕┘''"[0ml[1m [0;31m/┘²²²²²²²└*↕Sj$$$$$$$$$$$$$$$$$$$$$$[0m
[37m  [0;31m$ $  $  $  $[0;37m [0;31m$  $ $    [0;37m.[0;1;37m,┌s$''d$$$$$┌p┘`[0m.┌s%#SSSSS&#ss┐. [31m`''└↕j$$$$$$$$$$$$$$$$$[0m
[31myy$y$yy$yy$yy$y$yy$y$yg [0;37ml$[0;1;37m$$$$j$$$$⌐`[0m.⌐\$$$$$$$²"""²└*Q$$$#s┐. [31m`└j$$$$$$$$$$$$$$[0m
[31m$$$$$$$$$$$$$$$$$$$$$$T [0;37ml[0;1;37m$$$7└4$P`[0m.┌$$$$j$S↕↕S$│$$S#s┐/[1;30m$[0m$$$$$$$$┐.[31m`└j$$$$$$$$$$$[0m
[31m$$$$$$$$$$$$IIIIIIIIIII[0;37m [0;1;37m:$$$$b[0m [1m''.[0md$7''dP''.┌⌐##¬a.`└$$$$$$$$$$$$$$$$Ss.[31m`└j$$$$$$$$[0m
[31m$$$$$$$IIIIIIIlllllliii:[0;37m [0;1;37ml$$P''[0m.d$$''┌$$ j$$$$$$$$$.j$$$$$$P,$$$$$$$$└$S┐ [31m`4$$$$$$[0m
[31m$$$$IIIIIIIIllliiiiiiiii [0;37m:[0;1;37m$┘[0m.d$$$$$$$$$$$$$j7'',$$$$$$$jP'',$$$$$$$[1;30m$[0m$┐.$$$┐ [31m└$$$$$[0m
[31m$$IIIIIlIliii:::::::::::: [0;37m`.$$$$$P$$$''j$''d$,┌d$j$$P*┘`.┌$$$$$$P`d$$$$$$$$b [0;31m`$$$$[0m
[31m$IIIlllii::::::::∙∙∙∙::::;[0;37m $$$$$$ l$$ $$j$$$P┘`.,┌s#S$$$$$$$$P d$P''4b`\`└b` [0;31m`$$$[0m
[31mIIllii::::::∙∙[0m          [31m∙∙[0;37m:$$$P''j :$$:$$$$$''.j$$$S┘''`$┘j$$''$P :$'',j┘`  ` `4L [0;31m:$$[0m
[31mIlii::::∙∙∙[0m               [37m$$$$l $$$$$$$$$$$7'' .,┌s#$$''j$$''j$  l''jP  .┌⌐┐.  4; [0;31ml$[0m
[31mlii:::∙∙[0m                 [37m:$$''$b `$$$7`4$$$$┌\┘''` .,$$d$$7 $l  ''j''   `   `k  / [0;31m;$[0m
[31mii::∙∙[0m                   [37ml$L $$$$4$` q┐`ss$b┌┐sS$$$$$$$$$ W;   ''[0m         [37m`l.` [0;31m;$[0m
[31mi:∙∙[0m                     [37m$$$.`$$$b` q┐.`$$j$SSQ$$$$`└4$7$\$;[0m          [37m`[0;1;30m''[0m  '';   [31m$[0m
[31m;∙∙[0m                      [37m`²²²└└↕Qj$j┐.`$$`.┌s%sd$$$$s┐$ Y$$l[0m              [37m,l   [0;31m$[0m
[31m:∙[0m                     [37m.⌐S$$$$Ss┐.`.`4$$$$$$$$$$└└/Q$$$b Y$L[0m       [37m`└,[0;1;30m [0m`/,`$;  [31ml[0m
[31m∙[0m                     [37md$$$$j$j$$$$$.┘ $j[0;1;30m↕┘[0m$┘²²┘4Qs.`└S$$b └$         `b[1;30m `4[0mbdI  [31mI[0m
[31m∙[0m                    [37md$$$P`   `└Q$$$.''[0;1;30m` [0m,\$.┌j\*┘²²²└¬.`$$┐`┘.        $[1;30m   Y[0m$$  [31m$[0m
                    [37m:$$$''[0m        [37m''$$l  J$$$P'' .,▬┌┬┐▬.  ''$$$┐.[0m        [37m'' :[0;1;30m :$[0m$  [31m$[0m
                    [37ml$$;  ,┌ss┐,  `$''; Y$$$.,d$$$$$$$$$S¬.`4$$\[0m         [1;30m''[0m  [1;30m$[0m$ [31m;$[0m
                    [37m`$`  `q┐,.,┌''  '' l :$$$$$$jS↕↕↕SQ$$$$$b.`$$;[0m           [37m$l [0;31m;$[0m
                     [37m$: [0;1;30m/.[0m `"''`     .$. `$$$P`       `4$$$$$\`$l           $[1;30m;[0m [31ml$[0m
                     [37mIl [0;1;30m`4b.┐┌\┘''[0m   l$ '' `└`    .,,.   `47 `$;`$          :$[1;30m  [0;31m$$[0m
                     [37m$$.  [0;1;30m`└↕↕┘''[0m   [1;30mj[0m$$:        `.┘`''└b.  `b.l$ l          $[1;30m┘ [0;31mj$$[0m'
