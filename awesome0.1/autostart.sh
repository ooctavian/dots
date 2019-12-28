#!/bin/sh

    numlockx on
	wal -R &
    compton --config ~/.config/compton/compton.conf &
	setxkbmap -option caps:escape 
