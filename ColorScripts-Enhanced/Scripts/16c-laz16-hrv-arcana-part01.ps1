# Converted from: HRV_Arcana.ans
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/laz16/raw/HRV_Arcana.ans
# Source Revision: archive-sha256:b093dd3cb06bf783d59a9df3724c51f9a41f686cd4fd545c920ada008d959f7a
# Source SHA-256: 591d43c8c2a15a664f5ccf6004c53f0ff29edb09295653d68eeba41cd6c4211b
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: HRV_Arcana.ans by harvest (Lazarus); released in laz16 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# SAUCE Title: Arcana
# SAUCE Author: harvest
# SAUCE Group: Lazarus
# SAUCE Date: 20221229
# SAUCE Dimensions: 80x200
# SAUCE Font: IBM VGA
# SAUCE Comments: Resquested on #16c Discord Server by RiS for Elfmaster
# Lines: 1-36
# Columns: 1-80

Write-Host '
            ▄▄■                                                   ■▄▄
          ▄▀██░     ▀██▀▀▄        ▄██▄      ▄█▀▀▄      █   ██     ░██▀▄
         ▐▌░██░░     ██░ ██      ██ ░▀     ░██ ░██    ░██ ░██    ░░██░▐▌
         █░ ██░ ░    ██░ ██░     ██ ░ ░   ░░██ ░██   ░░███░██   ░ ░██ ░█
   .    ▐█░▄██░░ ░   ██▄█▀░ ░    ██ ░░ ░ ░ ░██▄▌██  ░ ░██████  ░ ░░██▄░█▌ .
    •   ▐██▀██░ ░ ░  ██▀ █▄░ ░   ██  ▄░ ░ ░░██▀ ██ ░ ░░██ ▀██ ░ ░ ░██▀██▌ •.
   •.   ▐█░ ██░░ ░ ░ ██░ ██ ░ ░   ▀██▀      ▀▀ ░██░ ░ ░██ ░██░ ░ ░░██ ░█▌ •
    ■   ▐█░ ██░ ░ ░  ██░ ██░ ░   ▄▄▄▄▄█▓▓▓▓▓▓▓█▄▄▄    ░▀█ ░██ ░ ░ ░██ ░█▌■
     ░  ▐█  ██░░ ░ ░ █▀   ▄▄▄▄▓▓▓▓▓▓▓▓▓▀▀▀▀▀▀▀▓▓▓▓▓▓█▄▄▄   ▀█░ ░ ░░██  █▌░
      ░▒ ▀  ▀    ▄▄▄▄▄▄▄▓▓▓▓▓▓▀▀                  ░▒▓▓▓▓▓▓▓▄▄▄▄▄▄   ▀  ▀ ▓
        ░█▓▒▓▓▓▓█▓▓▓▓▓▓▓░      ░░▓▓██████████████▄▄    ░▒▒▓▓▓▓▓▓▓▓▓▒▒▒▒▓█▓
       ░   ▀▀▀▀▀▀▀       ░░▒▓▓█████▓▒░░░░░░░░░░░▓▓██▓▒░     ░░▒▓█▓▓▓▓▓██▒
        ░░░░░░░░░░░ ░▒▓▓█████▀▀▀ 0 ░░░▓▓█▓█▓█▓█▓░░░░ ░█▓▓▓▓▄▄▄
             ▄▄▄▓██████▀▀ 0 1 0 1 1 ▒▓██▓[30;47m0x7ELF[0;37;40m█▓▓▒░  1 0 1▀▀▀▓█████▓▓▒▒░■[0m
[37;40m        ▒▓████████▒░░  1 1 0 0 0 0 1▐▓▓▒▒▓▓██████▓▒▌ 0 1 1 0 ░▄██▓▀▀▀▀▀▒[0m
[37;40m        ▓▓▀▀   ▀░▓▓▓▄▄▄ 0 0 1 1 1 1 1▀▓▓▓▓▓▓▓██▓▒▒▀ 1 0 1 ▄▄█▀▀     ░░░░░[0m
[37;40m        ▓▒ ░░░░    ░▓▓▓██▄▄▄ 0 1 1 0 1 ▀▒▒▒▒▒▒▒▒▀  1 ▄▄████▓    ░░░░[0m
[37;40m        ░      ░░░░    ░░▒▓▓████▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓▓▓██▓███▓   ░░        ░░[0m
[37;40m        ░          ░░░░     ░░▒▓▓▓▓██▓██▓█▓█▓▓▓▒░▒███▓ ░██▌ ░░        ░[0m
[37;40m        ░              ░░░░                     ▄██▓░  ░██▓        ▒▓[0m
[37;40m        °                  ░░░░░░░░░░░░░░░░░░ ▄██▓░  ░░░███▓░    ░▓▓[0m
[37;40m        ■     ░░▒░░░░                       ▄██▓░      ░████▓▓▓▓▓█▀[0m
[37;40m            ░░▄▓▓▓▓▓▓█▄                   ▄██▓░        ░████████▀[0m
[37;40m           ░▄██▀     ▀█▌                ▄██▓░          ░██████▓[0m
[37;40m          ░▐█▓▌  ░▓▓█▄▓█              ▄██▓░            ░█████▒[0m
[37;40m           ██▓  ░▒▓▓▓▒█■            ▄██▓░              ░████░[0m
[37;40m           ▐█▓▌  ░░▒░▀            ▄██▓░                ░███░[0m
[37;40m            ██▓▄              ▄▄███▓░                  ░██░[0m
[37;40m             ▀█▓▓▄▄ HRV ▄▄▄████▓▓░░                    ░▓░[0m
[37;40m               ░░█▓▓███████▓▓▒░░                       ░▒[0m
[37;40m                 ░░▒▒▓█▓▒▒░░                           ░■[0m




'
