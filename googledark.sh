
# Special
background='#1d1f21'
foreground='#c5c8c6'
cursor='#c5c8c6'

# Colors
color0='#1d1f21'
color1='#cc342b'
color2='#198844'
color3='#fba922'
color4='#3971ed'
color5='#a36ac7'
color6='#3971ed'
color7='#c5c8c6'
color8='#969896'
color9='#cc342b'
color10='#198844'
color11='#fba922'
color12='#3971ed'
color13='#a36ac7'
color14='#3971ed'
color15='#ffffff'

# FZF colors
export FZF_DEFAULT_OPTS="
    $FZF_DEFAULT_OPTS
    --color fg:7,bg:0,hl:1,fg+:232,bg+:1,hl+:255
    --color info:7,prompt:2,spinner:1,pointer:232,marker:1
"
# Fix LS_COLORS being unreadable.
export LS_COLORS="${LS_COLORS}:su=30;41:ow=30;42:st=30;44:"
