local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local pad = helpers.pad
local dpi = require("beautiful").xresources.apply_dpi
local icon_theme = "linebit"
local icons = require("icons")
require("lemons.pkgs")
require("lemons.temperature")
require("lemons.ram")
sidebar_hide_on_mouse_leave = true
sidebar_show_on_mouse_screen_edge = true
sidebar = wibox ({visible = false , ontop = true , type = "dock" })
sidebar.bg = beautiful.sidebar_bg or beautiful.xbackground  or "#FFFFFFF"
sidebar.fg = beautiful.sidebar_fg or beautiful.xforeground or "#1111111"
sidebar.opacity = 0.95
sidebar.height = beautiful.sidebar_height or awful.screen.focused().geometry.height
sidebar.width = beautiful.sidebar_width or 300
sidebar.y = beautiful.sidebar_y or 0
local radius = beautiful.sidebar_border_radius or 0
if beautiful.sidebar_position == "right" then
   awful.placement.right(sidebar)
   sidebar.shape = helpers.prect(radius, true , false , false , true)
else
   awful.placement.left(sidebar)
   sidebar.shape = helpers.prrect(radius, false , true , true , false)
end

 sidebar.shape = helpers.rrect(radius)
sidebar:buttons(gears.table.join(
    -- Middle click - Hide sidebar
    awful.button({ }, 2, function ()
        sidebar.visible = false
    end)
    -- Right click - Hide sidebar
    -- awful.button({ }, 3, function ()
    --     sidebar.visible = false
    --     -- mymainmenu:show()
    -- end)
))
    sidebar:connect_signal("mouse::leave", function ()
        sidebar.visible = false
    end)
-- Activate sidebar by moving the mouse at the edge of the screen
    local sidebar_activator = wibox({y = sidebar.y, width = 1, visible = true, ontop = false, opacity = 0, below = true})
    sidebar_activator.height = sidebar.height
    sidebar_activator:connect_signal("mouse::enter", function ()
        sidebar.visible = true
    end)

    if beautiful.sidebar_position == "right" then
        awful.placement.right(sidebar_activator)
    else
        awful.placement.left(sidebar_activator)
    end

    sidebar_activator:buttons(
        gears.table.join(
            awful.button({ }, 4, function ()
                awful.tag.viewprev()
            end),
            awful.button({ }, 5, function ()
                awful.tag.viewnext()
            end)
    ))
    -- volume text
--ocal volumetext  = wibox.widget{
--   text = " N/A ",
--   align  = 'center',
--   valign = 'center',
--   widget = wibox.widget.textbox
--
--ocal mpdtext  = wibox.widget{
--   text = "N/A",
--   align  = 'center',
--   valign = 'center',
--   widget = wibox.widget.textbox
--
--wesome.connect_signal("lemon::mpd", function(artist, title, paused)
--       if paused then
--        mpdtext.markup = title
--       else 
--       mpdtext.markup = "Mpd Playing"
--nd 
--nd
--
--wesome.connect_signal("lemon::volume" , function(volume,muted)
--   volumetext.markup = " VOL: " .. volume .. " % "
--nd )
--ocal packages = wibox.widget{
--   text = "N/A",
--   align  = 'center',
--   valign = 'center',
--   widget = wibox.widget.textbox
--
--wesome.connect_signal("lemon::packages" , function(value)
--  packages.markup = " Packages: " .. value 
--nd )
--ocal temp = wibox.widget{
--   text = "N/A",
--   align  = 'center',
--   valign = 'center',
--   widget = wibox.widget.textbox
--
--awesome.connect_signal("lemon::temperature" , function(value)
--   temp.markup = " temperature: " .. value .. "grades"
--end )
-- Item configuration
local exit_icon = wibox.widget.imagebox(icons.poweroff)
exit_icon.resize = true
exit_icon.forced_width = icon_size
exit_icon.forced_height = icon_size
local exit_text = wibox.widget.textbox("Exit")
exit_text.font = "sans 14"

local exit = wibox.widget{
    exit_icon,
    exit_text,
    layout = wibox.layout.fixed.horizontal
}
exit:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        exit_screen_show()
        sidebar.visible = false
    end)
))

-- Set colors
local clock = wibox.widget.textclock('%H:%M')
clock.font = "Iosevka 25"
local day = wibox.widget.textclock('%A %d')
day.font="Iosevka 25"
sidebar:setup {
  { ----------- TOP GROUP -----------
        helpers.vertical_pad(40),
        -- fancy_time,
        clock,
        day,
        helpers.vertical_pad(20),
        weather,
        helpers.vertical_pad(40),
        layout = wibox.layout.fixed.vertical
    },
    { ----------- MIDDLE GROUP -----------
        playerctl_buttons,
        {
            -- Put some margins at the left and right edge so that
            -- it looks better with extremely long titles/artists
            mpd_song,
            left = dpi(10),
            right = dpi(10),
            widget = wibox.container.margin
        },
        helpers.vertical_pad(40),
        volume_bar,
        cpu_bar,
        temperature_bar,
        ram,
        battery,
        helpers.vertical_pad(20),
        disk,
        helpers.vertical_pad(40),
        layout = wibox.layout.fixed.vertical
    },
    { ----------- BOTTOM GROUP -----------
        nil,
        {
            {
                searcht,
                exit,
                spacing = dpi(50),
                layout = wibox.layout.fixed.horizontal
            },
            left = dpi(20),
            right = dpi(20),
            bottom = dpi(20),
            widget = wibox.container.margin
        },
        nil,
        layout = wibox.layout.align.horizontal,
        expand = "none"
    },
    layout = wibox.layout.align.vertical,
    -- expand = "none"
}


return sidebar
