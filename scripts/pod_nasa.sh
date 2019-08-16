#!/bin/bash
rss=`wget -q -O - http://www.nasa.gov/rss/lg_image_of_the_day.rss`
img_url=`echo $rss | grep -o '<enclosure [^>]*>' | grep -m 1 -o 'http://[^\"]*'`
img=/tmp/nasa_`date +"%Y%m%d"`.jpg
img_reduite=/tmp/nasa_`date +"%Y%m%d"`_60.png
wget -q -O $img $img_url
# convert -resize 1000x60 $img $img_reduite
# montage $img -auto-orient -thumbnail 1000x60 +polaroid -background black $img_reduite
convert $img -resize 1000x60 \
          \( +clone -shave 5x5 -fill gray50 -colorize 100% \
            -mattecolor gray50 -frame 5x5+2+2 -blur 0x2 \
          \) -compose HardLight -composite  $img_reduite
# convert $img  -gravity center -extent 90x90 \
#     /home/david/.config/awesome/badge3.png -composite -background black  $img_reduite
