local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local pad = helpers.pad
sidebar_hide_on_mouse_leave = true
sidebar_show_on_mouse_screen_edge = true
sidebar = wibox ({visible = false , ontop = true , type = "dock" })
sidebar.bg = beautiful.sidebar_bg or beautiful.xbackground  or "#FFFFFFF"
sidebar.fg = beautiful.sidebar_fg or beautiful.xforeground or "#1111111"
sidebar.opacity = 1
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

local clock = wibox.widget.textclock('%H:%M')
clock.font = "Iosevka 25"
local day = wibox.widget.textclock('%A %d')
day.font="Iosevka 25"
sidebar:setup {
    layout = wibox.layout.align.vertical,
   clock,
}


return sidebar
