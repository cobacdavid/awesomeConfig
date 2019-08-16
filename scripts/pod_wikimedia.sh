#!/bin/bash
html=`wget -q -O - http://commons.wikimedia.org/wiki/Main_Page`
img_url=`echo $html |grep -o 'mainpage-potd.*' |grep -o 'src="[^"]*jpg'|grep -o '//.*'`
##| grep -o "http://[^\"]*"`
#echo $img_url
img=/tmp/wikimedia_`date +"%Y%m%d"`.jpg
img_reduite=/tmp/wikimedia_`date +"%Y%m%d"`_60.png
wget -q -O $img http:$img_url
#convert -resize 1000x60 $img $img_reduite
convert $img -resize 1000x60 \
          \( +clone -shave 5x5 -fill gray50 -colorize 100% \
            -mattecolor gray50 -frame 5x5+2+2 -blur 0x2 \
          \) -compose HardLight -composite  $img_reduite
# convert $img  -gravity center -extent 90x90 \
#     /home/david/.config/awesome/badge3.png -composite -background black  $img_reduite
