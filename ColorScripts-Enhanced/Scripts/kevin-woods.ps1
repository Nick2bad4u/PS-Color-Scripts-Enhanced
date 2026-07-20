# Kevin Woods ASCII
$esc = [char]27

# Keep the renderer declarative: changing process-wide console modes here used to leak state into
# the caller and the uncolored artwork was printed a second time before the colored copy.
Write-Host @"
$esc[31mKevin Woods:
                                 ,        ,
                                /(        )``
                                \ \___   / |
                                /- _  ``-/  '
                               (/\/ \ \   /\
                               / /   | ``    \
                               $esc[97mO$esc[31m $esc[97mO$esc[31m   ) /    |
                               ``-^--'``<     '
                   $esc[33mTM$esc[31m         (_.)  _  )   /
|  | |\  | ~|~ \ /             ``.___/``    /
|  | | \ |  |   X                ``-----' /
``__| |  \| _|_ / \  <----.     __ / __   \
                    <----|====$esc[97mO$esc[31m)))==) \) /====
                    <----'    ``--' ``.__,' \
                                 |        |
                                  \       /
                             ______( (_  / \______
                           ,'  ,-----'   |        \
                           ``--{__________)        \/$esc[0m
"@
