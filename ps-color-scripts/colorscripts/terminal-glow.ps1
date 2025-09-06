$esc = [char]27

$redfg = "$esc[38;2;255;0;0m"
$redbg = "$esc[48;2;50;0;0m"
$greenfg = "$esc[38;2;0;255;0m"
$greenbg = "$esc[48;2;0;50;0m"
$yellowfg = "$esc[38;2;255;255;0m"
$yellowbg = "$esc[48;2;50;50;0m"
$bluefg = "$esc[38;2;0;0;255m"
$bluebg = "$esc[48;2;0;0;50m"
$purplefg = "$esc[38;2;128;0;128m"
$purplebg = "$esc[48;2;25;0;25m"
$cyanfg = "$esc[38;2;0;255;255m"
$cyanbg = "$esc[48;2;0;50;50m"

$boldon = "$esc[1m"
$reset = "$esc[0m"

Write-Host @"
$reset$boldon
$reset$redbg$redfg████████╗$reset  $greenbg$greenfg███████╗$reset  $yellowbg$yellowfg██████╗░$reset  $bluebg$bluefg███╗░░░███╗$reset  $purplebg$purplefg██╗$reset  $cyanbg$cyanfg███╗░░██╗$reset  $redbg$redfg░█████╗░$reset  $greenbg$greenfg██╗░░░░░$reset
$reset$redbg$redfg╚══██╔══╝$reset  $greenbg$greenfg██╔════╝$reset  $yellowbg$yellowfg██╔══██╗$reset  $bluebg$bluefg████╗░████║$reset  $purplebg$purplefg██║$reset  $cyanbg$cyanfg████╗░██║$reset  $redbg$redfg██╔══██╗$reset  $greenbg$greenfg██║░░░░░$reset
$reset$redbg$redfg░░░██║░░░$reset  $greenbg$greenfg█████╗░░$reset  $yellowbg$yellowfg██████╔╝$reset  $bluebg$bluefg██╔████╔██║$reset  $purplebg$purplefg██║$reset  $cyanbg$cyanfg██╔██╗██║$reset  $redbg$redfg███████║$reset  $greenbg$greenfg██║░░░░░$reset
$reset$redbg$redfg░░░██║░░░$reset  $greenbg$greenfg██╔══╝░░$reset  $yellowbg$yellowfg██╔══██╗$reset  $bluebg$bluefg██║╚██╔╝██║$reset  $purplebg$purplefg██║$reset  $cyanbg$cyanfg██║╚████║$reset  $redbg$redfg██╔══██║$reset  $greenbg$greenfg██║░░░░░$reset
$reset$redbg$redfg░░░██║░░░$reset  $greenbg$greenfg███████╗$reset  $yellowbg$yellowfg██║░░██║$reset  $bluebg$bluefg██║░╚═╝░██║$reset  $purplebg$purplefg██║$reset  $cyanbg$cyanfg██║░╚███║$reset  $redbg$redfg██║░░██║$reset  $greenbg$greenfg███████╗$reset
$reset$redbg$redfg░░░╚═╝░░░$reset  $greenbg$greenfg╚══════╝$reset  $yellowbg$yellowfg╚═╝░░╚═╝$reset  $bluebg$bluefg╚═╝░░░░░╚═╝$reset  $purplebg$purplefg╚═╝$reset  $cyanbg$cyanfg╚═╝░░╚══╝$reset  $redbg$redfg╚═╝░░╚═╝$reset  $greenbg$greenfg╚══════╝$reset

"@
