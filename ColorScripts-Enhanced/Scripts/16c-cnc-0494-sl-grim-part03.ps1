# Converted from: SL-GRIM.ANS
# Source encoding: CP437
# Source URL: https://16colo.rs/pack/cnc-0494/raw/SL-GRIM.ANS
# Source Revision: archive-sha256:a2860c6058bc20deb4b9fe584adc3143209a13f75027fe0542d8e0a5a0f55c58
# Source SHA-256: 40c7df662e23a5930562f83ab0e480ca0ecdf947a817741cc513d3d061e3f913
# Source License: LicenseRef-16colors-discord-permission
# Source Attribution: SL-GRIM.ANS by Sir Lancelot (cnc-0494); released in cnc-0494 and preserved by 16colors.
# Source Modification: Decoded as CP437 and serialized from the rendered terminal cell matrix without palette substitution, whitespace trimming, reflow, scaling, narrowing, or background-space stripping; tall works are split only into contiguous source-row ranges at reviewed blank or compositional transitions.
# Lines: 99-148
# Columns: 1-80

Write-Host '
      [31m·  ·▀ ▐ ■ [0;1;47m▒▒[0m   [31;47m▓▓▓[0;31m▄▄[0;31;47m▓▓▓[0m  [31;47m▓▓▓[0m  [31;47m▓▓▓[0m  [31;47m▓▓▓[0m  [31;47m▓▓▓[0m      [31;47m▓▓▓[0m   [1;47m▒▒[0m
          [31m▄▄  ▄ [0;1;47m▓▓[0m   [31m▀[0;31;47m██████[0;31m▀  [0;31;47m███[0m  [31;47m███[0m  [31;47m███[0m  [31;47m███[0m      [31;47m███[0m   [1;47m▓▓[0m
     [31m·    ·  ▀ [0m▄[1;47m██[0m                                           [1;47m██[0m▄
      ▄█[1;47m░░▒▒▓▓██[0m█▀                                           ▀█[1;47m██▓▓▒▒░░[0m█▄
      [1;47m░░[0m▀         [31m·[0m                                                   ▀[1;47m░░[0m
      [1;47m▒▒[0m  [1;33m██████▄   ▄███████   ▄████▄   ██████▄   ▄███████  ██████▄    [0;1;47m▒▒[0m
      [1;47m▓▓[0m  [1;33;43m▓▓▓[0m  [1;33m▀[0;1;33;43m▓▓[0m  [1;33;43m▓▓▓[0m       [1;33m▐[0;1;33;43m▓▓[0;1;33m▀▀[0;1;33;43m▓▓[0;1;33m▌  [0;1;33;43m▓▓▓[0m  [1;33m▀[0;1;33;43m▓▓[0m  [1;33;43m▓▓▓[0m       [1;33;43m▓▓▓[0m  [1;33m▀[0;1;33;43m▓▓[0m   [1;47m▓▓[0m
      [1;47m██[0m  [1;33;43m▒▒▒[0m  [1;33m▄[0;1;33;43m▒▒[0m  [1;33;43m▒▒▒[0m       [1;33;43m▒▒▒[0m  [1;33;43m▒▒▒[0m  [1;33;43m▒▒▒[0m  [1;33m▄[0;1;33;43m▒▒[0m  [1;33;43m▒▒▒[0m       [1;33;43m▒▒▒[0m  [1;33m▄[0;1;33;43m▒▒[0m   [1;47m██[0m
      █   [1;33;43m░░░░░░[0;33m▀   [0;1;33;43m░░░[0;33m▄▄▄    [0;1;33;43m░░░[0;33m▄▄[0;1;33;43m░░░[0m  [1;33;43m░░░░░░[0;33m▀   [0;1;33;43m░░░[0;33m▄▄▄    [0;1;33;43m░░░░░░[0;33m▀    [0m█
          [33m▀▀▀ ▀[0m     [33m▀▀▀▀▀▀    ▀▀▀▀▀▀▀▀  ▀▀▀[0m       [33m▀▀▀▀▀▀    ▀▀▀ ▀[0m
      █   [31;47m░░░[0m  [31;47m░░░[0m  [31;47m░░░[0m       [31;47m░░░[0m  [31;47m░░░[0m  [31;47m░░░[0m       [31;47m░░░[0m       [31;47m░░░[0m  [31;47m░░░[0m   █
      [1;47m░░[0m  [31;47m▒▒▒[0m  [31;47m▒▒▒[0m  [31;47m▒▒▒[0m       [31;47m▒▒▒[0m  [31;47m▒▒▒[0m  [31;47m▒▒▒[0m       [31;47m▒▒▒[0m       [31;47m▒▒▒[0m  [31;47m▒▒▒[0m  [1;47m░░[0m
      [1;47m▒▒[0m  [31;47m▓▓▓[0m  [31;47m▓▓▓[0m  [31;47m▓▓▓[0m       [31;47m▓▓▓[0m  [31;47m▓▓▓[0m  [31;47m▓▓▓[0m       [31;47m▓▓▓[0m       [31;47m▓▓▓[0m  [31;47m▓▓▓[0m  [1;47m▒▒[0m
      [1;47m▓▓[0m  [31;47m███[0m  [31;47m███[0m  [31m▀[0;31;47m███████[0m  [31m███  ███  ███[0m       [31m▀[0;31;47m███████[0m  [31;47m███[0m  [31;47m███[0m  [1;47m▓▓[0m
      [1;47m██[0m▄                                                            ▄[1;47m██[0m
      ▀█[1;47m██▓▓▒▒░░[0m▄▄                                          ▄▄[1;47m░░▒▒▓▓██[0m█▀


                               [1;34m■ [0;34mI[0;1;34mron [0;34mM[0;1;34maiden ■[0m
            [34m█[0;1;34;44m░░▒▒▒▓▓▓▓[0;1;34m█████[0m                                  [34m▀▀[0;1;34;44m░░[0m
                                                                [34m█[0m
               [36mI count the head[0;1;36ms of those unbor[0;1mn[0m
               [36mThe acursed ones [0;1;36mI''ll find them [0;1mal[0m
               [36mIf you die by yo[0;1;36mur own hand[0m
               [36mAs a suicide you [0;1;36mshall be damned[0m
               [36mAnd if you try t[0;1;36mo save your soul[0m
               [36mI will torment y[0;1;36mou -- you shall [0;1mno grow old[0m
               [36mWith every secon[0;1;36md and passing br[0;1meah[0m
               [36mYou''ll be so alo[0;1;36mne your soul wil[0;1ml leed to death[0m
            [1;34m█[0m
            [1;34;44m░░[0;1;34m▄▄[0m                                  [34m█████[0;1;34;44m░░░░▒▒▒▓▓█[0m


                                ∙ [1;36mG[0;1;34mrim [0;1;36mR[0;1;34meaper ∙[0m
                                [1;34m∙ [0;1;36m7[0;1;34m14.[0;1;36mP[0;1;34mRI.[0;1;36mV[0;1;34mATE ∙[0m
                            [1;34m∙ [0;1;36mS[0;1;34mys[0;1;36mO[0;1;34mp · [0;1;36mD[0;1;34mark [0;1;36mO[0;1;34mne [0;1;36m[[0;1;34mRN] ∙[0m
                             [1;34m∙ [0;1;36mC[0;1;34mo-[0;1;36mS[0;1;34mys[0;1;36mO[0;1;34mp · [0;1;36mE[0;1;34mar [0;1;36m[[0;1;34mRN] ∙[0m
                             [1;34m∙ [0;1;36mC[0;1;34mo-[0;1;36mS[0;1;34mys[0;1;36mO[0;1;34mp · [0;1;36mS[0;1;34muperman ∙[0m

                               [1;34m∙ [0;1;36mR[0;1;34munning [0;1;36mR[0;1;34mE[0;1;36mN[0;1;34mE[0;1;36mG[0;1;34mA[0;1;36mD[0;1;34mE ∙[0m
                                [1;34m∙ [0;1;36m0[0;1;34m-7 [0;1;36mD[0;1;34may [0;1;36mW[0;1;34marez ∙[0m
                               [1;34m∙ [0;1;36mW[0;1;34mHQ [0;1;36mR[0;1;34meaper [0;1;36mN[0;1;34met ∙[0m
                                [1;34m∙ [0;1;36mW[0;1;34mHA/[0;1;36mA[0;1;34m/[0;1;36mC[0;1;34mVr-[0;1;36mN[0;1;34met ∙[0m

                              [1;34m∙ [0;1;36mN[0;1;34mUV/[0;1;36mN[0;1;34mUP [0;1;36mR[0;1;34mequired ∙[0m

                      [1;34m∙ [0;1;36mS[0;1;34mister [0;1;36mB[0;1;34moard · [0;1;36mC[0;1;34mastle [0;1;36mo[0;1;34mf [0;1;36mD[0;1;34markness ∙[0m
                                        [1;34m∙ [0;1;36m7[0;1;34m14.[0;1;36mN[0;1;34mOT.[0;1;36mY[0;1;34mET! ∙[0m

                          [1;32mA[0;32mNSI [0;1;32mb[0;32my[0;1;32m: [0mS[1;32mir [0mL[1;32mancelot [0;32m[[0;1;32mCaNCeR[0;32m][0m'
