#!/bin/bash
nbFichiers=`wc -l /tmp/listePhotothequeMod |cut -f 1 -d " "`
choix=$(( ( RANDOM % $nbFichiers )  + 1 ))
img=`sed -n "$choix p" /tmp/listePhotothequeMod`
img_reduite=/tmp/photo3_`date +"%Y%m%d"`_60.png
convert $img -resize 1000x60 -auto-orient \
          \( +clone -shave 5x5 -fill gray50 -colorize 100% \
            -mattecolor gray50 -frame 5x5+2+2 -blur 0x2 \
          \) -compose HardLight -composite  $img_reduite
echo $img
