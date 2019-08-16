#!/bin/bash

while true 
do
    #get mouse position
    mdata=`xdotool getmouselocation`

    #extract x/y coordinates
    mx=`echo "$mdata"|cut -f1 -d' '|cut -d: -f2`
    my=`echo "$mdata"|cut -f2 -d' '|cut -d: -f2`

    #check for position and if at either left or right edge, move the mouse
    if [ $mx == 2879 ]; then
        xdotool mousemove 1 $my 
    elif [ $mx == 0 ]; then
        xdotool mousemove 2879 $my
    fi

done
