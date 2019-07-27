#!/bin/sh
# This bspwm helper takes an argument: 1-9, to place the current floating window
# according to the matrix: 7 8 9
#                          4 5 6
#                          1 2 3
# Requirements: xdotool.

# get the current screen presets
SCREEN=`xrandr | grep '*' | awk '{print $1}'`
SCREEN_X=${SCREEN%x*}
SCREEN_Y=${SCREEN#*x}
BORDER=`bspc config border_width`

# get the current window geometry
eval `xdotool getactivewindow getwindowgeometry --shell`

# calculate new coordinates
X1=0
X2=$((SCREEN_X/2-WIDTH/2-BORDER*2))
X3=$((SCREEN_X-WIDTH-BORDER*2))
Y1=$((SCREEN_Y-HEIGHT-BORDER*2))
Y2=$((SCREEN_Y/2-HEIGHT/2-BORDER*2))
Y3=0

# utility function to move the window
m() { xdotool windowmove $WINDOW $1 $2; }

# execute
case $1 in
	1) m $X1 $Y1 ;;
	2) m $X2 $Y1 ;;
	3) m $X3 $Y1 ;;
	4) m $X1 $Y2 ;;
	5) m $X2 $Y2 ;;
	6) m $X3 $Y2 ;;
	7) m $X1 $Y3 ;;
	8) m $X2 $Y3 ;;
	9) m $X3 $Y3 ;;
esac
