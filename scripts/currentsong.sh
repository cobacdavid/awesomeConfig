#!/bin/bash

eper() {
    sed 's/[&]/and/g' <<< "$*"
}



while true
do
    state=$(echo 'status' |nc localhost 6600 |grep state|cut -d " " -f 2)
    if [ "$state" = "play" ]
    then
	color="white"
	ART=$(mpc -f "<span foreground='$color' font='abeatbyKai' font_weight='bold' size='12000'> %title% </span>  <span font='abeatbyKai' font_weight='bold' size='10000'> %artist% </span>  <span font='abeatbyKai' font_weight='bold' size='8000'> %album% </span>" |head -1)
    elif [ "$state" = "pause" ]
    then
	color="gray"
	ART=$(mpc -f "<span foreground='$color' font='abeatbyKai' font_weight='bold' size='12000'> %title% </span>  <span font='abeatbyKai' font_weight='bold' size='10000'> %artist% </span>  <span font='abeatbyKai' font_weight='bold' size='8000'> %album% </span>" |head -1)
    else
	ART="▇ ▅ █ ▅ ▇ ▂ ▃ ▁ ▁ ▅ ▃ ▅ ▅ ▄ ▅ ▇ MPD ▇ ▅ █ ▅ ▇ ▂ ▃ ▁ ▁ ▅ ▃ ▅ ▅ ▄ ▅ ▇"
    fi

    
    ART=$(eper "$ART")
    #echo $ART
    echo "simpletextw:set_markup(\"$ART\")" | awesome-client
    sleep .5
done
