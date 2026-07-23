# Converted from: wa-ansilove.ans
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/lgcy-001/raw/wa-ansilove.ans
# Source Revision: archive-sha256:589c804657c8d15ba617f7c0fd80723e4505d519989b80eba9584665be49eb54
# Source SHA-256: 5c5d75b205680a1098517ef36432ce36161415c2dd2f9552b9ede7cdc2330ce3
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: wa-ansilove.ans by warpus (Legacy Krew); released in lgcy-001 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: ansi love
# SAUCE Author: warpus
# SAUCE Group: Legacy Krew
# SAUCE Date: 20191228
# SAUCE Dimensions: 80x157
# SAUCE Font: IBM VGA
# SAUCE Comments: none of this would have been possible without some of that sweet |  ansi love
# Lines: 1-40
# Columns: 1-80

Write-Host '


[37;40m #include <ansilove.h>[0m


[1;30;40m static void[0m
[1;30;40m synopsis(void)[0m
[31m [0;1;30m{[0m
[31m   [0;1;30mfprintf(stdout, "SYNOPSIS\n"[0m
     [1;30m"[0m     [1;30mansilove [-dhiqrsv] [-b bits] [-c columns] [-f font]"[0m
     [1;30m" [-m mode] [-o file]\n"[0m
     [1;30m"[0m              [1;30m[-R factor] file\n");[0m
[1;30m }[0m

[31m static void[0m
[31m version(void)[0m
[31m {[0m
[31m   fprintf(stdout, "AnsiLove/C %s - ANSI / ASCII art to PNG converter\n"[0m
     [31m"Copyright (c) 2011-2019 Stefan Vogt, Brian Cassidy, and "[0m
     [31m"Frederic Cambus.\n", VERSION);[0m
[30;41m }  [0;31;40m▄▄▄▄▄▄[0m
[31;40m████████████████▄▄▄▄▄▄▄▄[0m
[30;41m int               [0;31;40m███████████████▄▄▄▄▄▄▄▄░░░░░░░░░[0m                   [30;40m██████████[0m
[30;41m main(int argc, char *argv[]) [0;31;40m████████████▓▓▓▓▓▓▓▓▓▄▄▄▄▄▄▄▄▄[0m     [30;40m███████████████[0m
[30;41m {                                 [0;31;40m█████████████████████████████████▄▄▄▄▄▄▄░░░░░[0m
[30;41m   FILE *messages = NULL;          [0;37;41m         [0;31;40m███████████████████████████████▓▓▓▓▓[0m
[30;41m                                   [0;37;41m                    [0;31;40m█████████████████████████[0m
[37;41m [0;30;41m  /* SAUCE record related bool types */        [0;37;41m                 [0;31;40m████[0;37;41m  [0;31;40m█████████[0m
[37;41m [0;30;41m  bool justDisplaySAUCE = false;               [0;37;41m                 [0;31;40m█████[0;37;41m     [0;31;40m█████[0m
[37;41m [0;30;41m  bool fileHasSAUCE = false;                   [0;37;41m [0;30;41m       [0;37;41m          [0;31;40m████[0;37;41m       [0;31;40m███[0m
[37;41m  [0;30;41m                                                      [0;37;41m          [0;31;40m█████[0;37;41m         [0m
[37;41m  [0;30;41m /* analyze options and do what has to be done */[0;33;41m     [0;37;41m           [0;31;40m█████[0;37;41m        [0m
[37;41m  [0;30;41m bool fileIsBinary = false;                      [0;33;41m     [0;37;41m           [0;31;40m██████[0;37;41m       [0m
[37;41m   [0;30;41mbool fileIsANSi = false;       [0;37;41m                 [0;33;41m     [0;37;41m            [0;31;40m██████[0;37;41m      [0m
[37;41m   [0;30;41mbool fileIsPCBoard = false;    [0;37;41m                                [0;31;40m██████████████[0m
[37;41m   [0;30;41mbool fileIsTundra = false;     [0;37;41m                                [0;31;40m██████████████[0m
[30;41m  [0;31;40m██████████████[0;33;41m  [0;37;41m           [0;31;40m████████[0;30;41m     [0;33;41m     [0;37;41m    [0;30;41m             [0;33;41m     [0;37;41m           [0m
[37;41m  [0;31;40m█░░░▒█▒▒▒▓███▓▓▓███████████████████[0;37;41m     [0;33;41m     [0;37;41m                 [0;33;41m     [0;37;41m           [0m
[37;41m  [0;31;40m███████████████████████████████████[0;37;41m                                          [0;31;40m█[0m'
