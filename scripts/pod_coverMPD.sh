#!/bin/bash
artist=$(mpc -f %artist% | head -1)
album=$(mpc -f %album% |head -1)
eval glyrc cover --artist \"$artist\" --album \"$album\"  -w '/tmp/cover' --cache /travail2/musique/pochettes --qsratio 1.0 -i 500

display /tmp/cover

#glyrc cover `mpc -f "#--artist \'%artist%\' --album \'%album%\'" |egrep -o \\\--.*` -w '/tmp/cover' --cache /travail2/musique/pochettes --qsratio 1.0 -i 500

# glyrc lyrics `mpc -f '#--artist %artist% --album %album% --title %title%' |egrep -o \\\--.*` -w /tmp/lyrics --cache /travail2/musique/pochettes  
