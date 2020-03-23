-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
-- Theme handling library
local naughty = require("naughty")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
require("widgets.exitscreen")
require("lemons")
local pad = require("helpers").pad
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()
local tbg = beautiful.xcolor0
local tfg = beautiful.xforeground
local bfg = beautiful.xcolor0
local volumebg = beautiful.xcolor5
local marginsize = dpi(3)
-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock(" %H:%M ")
mytextclock.align = "center" 
mytextclock.forced_width = dpi(45)
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
local separator = wibox.widget.textbox(" ")
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = {  
	    { awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    },
    bg = tbg,
    widget = wibox.container.background 
    },
    	top = marginsize,
	bottom = marginsize,
	widget = wibox.container.margin 
}
local vtext = wibox.widget.textbox("")
vtext.align = "center" 
--vtext.forced_width = dpi(36)
local vicon = wibox.widget.textbox("")
vicon.font = beautiful.font1
vicon.align = "center" 
vicon.forced_width = dpi(24)
local function createbutton( text , colorfg , colorbg)
	local button = wibox.widget{
		{text,
		fg = colorfg,
		bg = colorbg,
		widget = wibox.container.background 
	},
	top = marginsize,
	bottom = marginsize,
	widget = wibox.container.margin 
}
	return button
end 
local btext = wibox.widget.textbox("-----")
local bicon = wibox.widget.textbox("=")
bicon.font = beautiful.font1
bicon.align = "center"
bicon.forced_width = dpi(25)
local clock = createbutton(mytextclock, tfg , tbg )
local clocki = wibox.widget.textbox("  ")
clocki.align = "center"
clocki.forced_width = dpi(25)
clocki.font = beautiful.font1
local clockicon = createbutton(clocki, bfg , beautiful.xcolor12 )
local volicon = createbutton(vicon,bfg,volumebg)
local vol= createbutton(vtext, tfg , tbg )
local bat= createbutton(btext, tfg , tbg )
local baticon = createbutton(bicon,bfg,beautiful.xcolor2)
local mtext = wibox.widget.textbox("")
local mptext = wibox.widget.textbox("  ")
mptext.align = "center"
mptext.forced_width = dpi(25)
mptext.font = beautiful.font1
local mpnext = wibox.widget.textbox("  ")
local ptext = wibox.widget.textbox("  ")
ptext.align = "center" 
ptext.forced_width = dpi(20)
ptext.font = beautiful.font1
local powericon = createbutton(ptext,bfg,beautiful.xcolor1)
local menutext = wibox.widget.textbox("  ")
menutext.align = "center" 
menutext.forced_width = dpi(20)
menutext.font = beautiful.font1
local menuicon = createbutton(menutext,bfg,beautiful.xcolor10)
local mnext = createbutton( mpnext, tfg , tbg )
local mpprevious = wibox.widget.textbox("")
local mprevious = createbutton(mpprevious, tfg , tbg )
local mname = createbutton( mtext, tfg , tbg )
local mplay = createbutton( mptext,bfg, beautiful.xcolor3)
awesome.connect_signal("lemon::mpd" , function(artist,title,paused)	
	if paused then 
		mptext.text = "  "
	else
		mptext.text = "  "
	end
	mtext.text =  " " .. artist .. " - " .. title  .. " " 
       mpnext.text = "  "
	mpprevious.text = "  "
end)
awesome.connect_signal("lemon::battery", function(percentage)
awesome.connect_signal("lemon::charger", function(plugged)
	btext.text = " " .. percentage .. "% "
--if plugged then 
		bicon.text = "  " 
--elseif percentage ==  100 then
--	bicon.text = "  "
--elseif percentage > 75 then 
--	bicon.text = "  " 
--elseif percentage > 40 then 
--	bicon.text = "  "
--elseif percentage > 15 then 
--	bicon.text = "  "
--elseif percentage > 0 then 
--	bicon.text = "  "
--end
end)
end)
awesome.connect_signal("lemon::volume", function(volume, muted)
	vtext.text =" " ..  volume  .. "% "  
	if muted   then
		vicon.text = "  "
		
	elseif volume > 75  then
		vicon.text = "  "
	elseif volume > 25 then
		vicon.text = "  "
	elseif volume > 0 then 
		vicon.text = "  "
	end 
	end
	)
mplay:buttons(gears.table.join(
   -- Left click - Mute / Unmute
   awful.button({ }, 1, function ()
       os.execute("mpc toggle")
   end)))
powericon:buttons(gears.table.join(
   -- Left click - Mute / Unmute
   awful.button({ }, 1, function() exit_screen_show() end)))

 mnext:buttons(gears.table.join(
   -- Left click - Mute / Unmute
   awful.button({ }, 1, function ()
       os.execute("mpc next")
   end)))
  mprevious:buttons(gears.table.join(
   -- Left click - Mute / Unmute
   awful.button({ }, 1, function ()
       os.execute("mpc previous")
   end)))
 			  
vol:buttons(gears.table.join(
   -- Left click - Mute / Unmute
   awful.button({ }, 1, function ()
       os.execute("amixer -q sset Master toggle")
   end),
   -- Right click - Run or raise pavucontrol
   awful.button({ }, 3, function()
   end
   ),
   -- Scroll - Increase / Decrease volume
   awful.button({ }, 4, function ()
       os.execute("amixer -q sset Master 3%+")
   end),
   awful.button({ }, 5, function ()
       os.execute("amixer -q sset Master 3%-")
   end)
))
volicon:buttons(gears.table.join(
   -- Left click - Mute / Unmute
   awful.button({ }, 1, function ()
       os.execute("amixer -q sset Master toggle")
   end),
   -- Right click - Run or raise pavucontrol
   awful.button({ }, 3, function()
   end
   ),
   -- Scroll - Increase / Decrease volume
   awful.button({ }, 4, function ()
       os.execute("amixer -q sset Master 3%+")
   end),
   awful.button({ }, 5, function ()
       os.execute("amixer -q sset Master 3%-")
   end)
))
s.mytasklist = awful.widget.tasklist {
    screen   = s,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = tasklist_buttons,
     layout          = {
            spacing = dpi(8),
            layout = wibox.layout.flex.horizontal,
        },
    widget_template = {
        {
            {
                {
                    {
                        id     = 'icon_role',
                        widget = wibox.widget.imagebox,
                    },
                    margins = 2,
                    widget  = wibox.container.margin,
                },
                {
                    id     = 'text_role',
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },

        id     = 'background_role',
        widget = wibox.container.background,
                 },
	   top  = marginsize,
            bottom = marginsize,
            widget = wibox.container.margin

    },
}
s.mytasklist:set_max_widget_size(dpi(180))
   -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })
-- Create the tray
tray = wibox.widget.systray()
tray.spacing = dpi(3)

trayitems= { tray,
	top = marginsize,
	bottom = marginsize, 
	widget = wibox.container.margin
}
--tray.shape = gears.shape.rounded_bar
-- tray.visible = false

-- Create a widget that toggles the tray when clicked
tray_icon = wibox.widget.textbox("")
tray_icon.font = "Font Awesome 5 Free 9"
tray_icon.align = "center"
tray_icon.valign = "center"

tray_container = wibox.container.background()

mytraywidget = wibox.widget{
	{
    tray_icon,
    forced_width = dpi(22),
    bg = beautiful.xcolor4,
    fg = beautiful.xcolor0,
    widget = tray_container},
    top = marginsize,
    bottom = marginsize,
    widget = wibox.container.margin
}

local function toggle_tray()
    tray.visible = not tray.visible
    if tray.visible then
        tray_container.bg = beautiful.xcolor4
	tray_container.fg = beautiful.xcolor0
    else
        tray_container.bg = beautiful.xcolor8
	tray_container.fg = beautiful.xcolor4
    end
end

mytraywidget:buttons(
  gears.table.join(
    awful.button({ }, 1, function ()
        toggle_tray()

    end)
))
    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
--	    separator,
--	    menuicon,
	    separator,
            s.mytaglist,
	    separator,
       	   mplay,
            mname,
	    separator
        },
	{
 	layout = wibox.layout.fixed.horizontal,
--        s.mytasklist -- Middle widget
},
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
--            mykeyboardlayout,
--            wibox.widget.systray(),	
       --   mprevious,
       --   mnext,
 --        trayitems,
--       mytraywidget,
--	    separator,
            separator,
            baticon,
	    bat,
	    separator, 
            volicon,
           vol, 
	    separator,
	    clockicon,
            clock,
	    separator,
	    powericon, 
	    separator,
--            s.mylayoutbox,
        },
    }
end)
-- }}}
return statusbar
