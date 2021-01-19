{ config, pkgs, ... }:
{
services.dunst = {
  enable = true;
  settings = {
    global = {
    format = "%s\\n%b";
    geometry = "250x50-10+40";
    font = "FantasqueSansMono Nerd Font 10";
    allow_markup = "yes";
    plain_text = "no";
    sort = "no";                   
    indicate_hidden = "yes";       
    alignment = "center" ;         
    bounce_freq = 1 ;            
    show_age_threshold = -1 ;    
    word_wrap = "yes" ;            
    ignore_newline = "no" ;        
    shrink = "no" ;                
    monitor = 0 ;              
    follow = "none";        
    show_indicators = "yes" ;
    line_height = 4;     
    separator_height = 0;
    padding = 20;             
    horizontal_padding = 20;
    separator_color = "foreground";
    icon_position = "left";      
    max_icon_size = 48;
    hide_duplicate_count = "yes";
    idle_threshold = 10;
    sticky_history = "no";     
    history_length = 5;    
    startup_notification = false;
    dmenu = "dmenu -p dunst";
#    browser = /usr/bin/firefox;
    close = "ctrl+space";
    close_all = "ctrl+shift+space";
    history = "mod1+grave";
  };
    frame = {
      width = 2;
    };
    urgency_low = {
	 background = "#2E3440";
         foreground = "#d8dee9";
         frame_color = "#81a1c1";
         timeout = 2;
       };
    urgency_normal = { 
       background = "#2E3440";
       foreground = "#d8dee9";
       frame_color = "#81a1c1";
       timeout = 2;
     };
    urgency_critical={
	background = "#2E34406";
        foreground = "#BF616A";
 	frame_color = "#BF616A";
        timeout = 0;
      };
    };
};
}
