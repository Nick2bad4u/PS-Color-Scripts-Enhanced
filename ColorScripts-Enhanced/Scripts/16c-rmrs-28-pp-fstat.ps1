# Converted from: pp-fstat.ans
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/rmrs-28/raw/pp-fstat.ans
# Source Revision: archive-sha256:fa3f82a196e5c2ecb3ed92667c34cdee414fe625eadfdfa3e663da86367e360c
# Source SHA-256: 141c7ad0a817513f8cdb2ab7beb705062aaa49c47cd12734053bf9585d733c86
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: pp-fstat.ans by Pixel Pusher (Remorse Ascii); released in rmrs-28 and preserved by 16colors.
# Source Modification: Decoded from the attributed archive source and serialized from the rendered terminal cell matrix; project curation removes trailing rendered-blank rows, blank rows introduced by redaction, and standalone written-text, contact, or policy-ineligible display cells when present, while preserving retained ANSI controls, terminal-art glyphs, colored spaces, and source coordinates.
# SAUCE Title: BBS Stat Screen
# SAUCE Author: Pixel Pusher
# SAUCE Group: Remorse Ascii
# SAUCE Date: 19981107
# SAUCE Dimensions: 80x32
# Lines: 1-32
# Columns: 1-80

Write-Host '
[31m . ░[0m    [31m ,'' . [0m
   [31m [0m   [31m░$''  .[0m   [31m░  .[0m                       [1;31m, [0m     [1;30m    [0m
[31m '',░   ."$, :[0m   [31m░[0m     [1;30m                     [0;1;31m`,[0;1;30m   <+  [0;1;37mP I X E L  P U S H E R[0m [1;30m +>[0m
[31m  `▒░  . [0;1;31m°$[0;31ms: ░░▒s''[0m                       [37m [0;1;31m,)░[0;1;30m [0m
[31m   ▓[0;1;31m░[0;31m    [0;1;33m [0;1;31m  [0;31m   ░    [0;37m  [0;1;30m [0;1;37m                                             [0;1;30m [0m
[31m ♫[0;1;31m♫"[0;31m ",|░[0;1;31m░$[0;31m$$;  ░$s:[0;1;33m [0m                    [31m s[0;1;31mS,s[0;31m,[0;37m [0m
[31m░[0;1;31m$|[0;31m ,s[0;1;31m$'',$[0;31m♫$''░░░░░$[0;1;31m;[0;1;33m [0m  [1;31m,[0m          [31m   [0;1;30m  [0;31m░,s[0;1;31;41m$[0;1;31;40m$[0;31m""[0;37m..[0m
[31m√[0;1;31m|$[0;31m $▓[0;1;31m♫s[0;1;31;41m$[0;31m♫¶▌  ,sS[0;1;31m$''[0;31m [0;37m  [0;1;31m;[0;31m, [0m    [37m     [0;31m  ░░░▒$$"[0;1;37m,[0m,$:[1;30m░[0m
[31m$[0;1;31;41m♫[0;1;31;40m$,[0;31m`ⁿ$♫♫¶$♫s,$♫[0;1;31m$s,,s☼[0;31mS''[0;37m  [0;1;30m   [0;31m [0;1;31m,,ss[0;31m#$$"""[0;37m,s[0;1;37m$[0mS"[31m,|ⁿ[0;37m  [0;1;37m   [0m
[31m$$[0;1;31m/↑S#s,,[0;31m`ⁿ$$S¶¶♫[0;1;31m$[0;1;31;41m$[0;1;31;40m$[0;31m$''░,s[0;1;31ms[0;31m#[0;1;31mπⁿⁿ°''[0;31m"[0;1;37m,sss$Sⁿ"[0;31m,s$"[0;1;37m┌[0m$
[31m  [0;1;30m ▲[0;31m   [0;34m ┌[0;1;34m   [0;31m   [0;34m [0;31m   [0;34m  [0;31m    [0;37m  [0;1;37m  [0m [1m   [0;31m         [0;1;37m  ░░░[0;31m [0;37m   [0;1;30m [0m
[31m`$[0;1;30m:S[0;34m┌░"$$$[0;1;34mSS♫▓█♫♫$[0;34m$S|[0;37ms√ⁿ"[0;31m,sssssⁿ""^[0;1;37m,s%@Sⁿⁿ"[0;31m,s"[0;37m,┌''[0;1;30m [0;1;37m   [0m
[31m s[0;1;30mS♫[0;1;34m|s[0;34m, °ⁿ$$[0;1;34m☼♫♫[0;1;34;44m$[0;34m$$ⁿ"[0;37m [0;31m,ⁿⁿ""[0;1;37m,s%$SSⁿ""[0;31m,ssss"""[0;1;37m,s[0mS"[31m,''[0;37m [0m
[37m [0;31m`[0;1;30m♫$[0;1;34m|$♫♫$s[0;34m,░`"ⁿ'' ,s[0;1;34m$$,[0m░[1mⁿⁿ""[0;31m,ssss$""^[0;1;37m,s%S#"[0m"[31m,s$"░[0;37m,/ [0m
[37m [0;31m`[0;1;30m$|[0;1;34m:$S[0;1;34;44mSS[0;1;34;40m$$""[0;34m  "ⁿ$[0;1;34m$[0;1;34;44mS[0;1;34;40mS$[0m [31m$S""^[0;1;37m,*s#$S""[0;31m,sss$S"""[0;1;37m,[0m$"[31m,░░[0m
[37m  [0;1;30m|:[0;34m`$$ⁿ"'',s$SS$s\`ⁿ$[0;1;34m$S[0;1;37m,s$"""[0;31m,ss%@S$""''[0;1;37m,ss$""[0;31m,s$ⁿ[0;1;37m░+[0;1;30m:[0m
  [1;30m;. [0;34m` ss♫[0;1;34;44m♫[0;1;34;40m$S♫♫♫[0;1;34;44m░[0;34m$$s "[0;31m,ss#$$ⁿ"[0;1;37m ,ssss$""[0;31m,ssS"ⁿ"[0;1;37m,sS"''[0m
  [1;30m   [0;34m░  [0;1;34m   ┘  [0;31m           [0;1;37m      [0;31m          [0;1;37m      [0m
  [1;30m|S$[0;34m`SS"[0;31m,sS$$S"''[0;1;37m,sss$"""[0;31m,sS$$ⁿ"[0;1;37m,sss$S"""[0m
  [1;30m;$$[0m [31m,`"''[0;37m,ss[0;1;37mss$""[0m [31m,s$ⁿⁿ""[0;1;37m,s$$"""''[0m      [1m   [0m   [1m-/-  [0;1;30mStats[0;1;37m  -/-[0m
  [1;30m    [0m░  [31m           [0;1;37m        [0m
[1;30m[0;31m[0;1;37m[0m[1m[0m[1;30m[0;1;37m[0m   [1;30m|$S; [0m`[1m"[0m                [1m  [0m   [1;30m     Date[0;1;37m:[0m
   [1;30m:$$'' [0m                   [1m  [0;1;30m       Time[0;1;37m:[0m
   [1;30m.$|  [0m                   [1m  [0m   [1;30m Top D/L[0;1;37m:[0m
[1;30m[0m[1m[0m[1m[0m[1;30m[0;1;37m[0m[1;30m[0m[1m[0m[1;30m[0;1;37m[0m    [1;30m|:  [0m
    [1;30m:.  [0m
    [1;30m.[0m [1;30m [0m

     [1;30m.[0m'
