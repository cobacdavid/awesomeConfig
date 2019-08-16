#!/bin/bash

MAX=937
MIN=30
STEP=15
FIC=/sys/class/backlight/intel_backlight/brightness

a=$(cat $FIC)

if [ $1 = '+' ]
then
    a=$( expr $a + $STEP )
    if [ $a -lt $MAX ]
    then
	echo $a > $FIC
    fi
fi

if [ $1 = '-' ]
then
    a=$( expr $a - $STEP )
    if [ $a -gt $MIN ]
    then
	echo $a > $FIC
    fi
fi

echo $a
