local awful     = require('awful')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local gears     = require('gears')
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local bar = wibox.widget {
  {
    id            = 'bar',
    max_value     = 100,
    value         = 0,
    forced_height = dpi(20),
    forced_width  = dpi(100),
    shape         = gears.shape.rounded_bar,
    bar_shape     = gears.shape.rounded_bar,
    border_color  = beautiful.border_color,
    background_color = beautiful.battery_bar_bg,
    color         = { type = "linear",
                      from = { 0, 0 },
                      to = { 200, 50 },
                      stops = { { 0, beautiful.battery_bar_gradient_1 }, { 0.75, beautiful.battery_bar_gradient_2  } }
    },
    widget        = wibox.widget.progressbar,
  },
  buttons =  gears.table.join(
    awful.button({ }, 1, function() awful.spawn('xfce4-power-manager-settings') end)
  ),
  margins = 3,
  widget = wibox.container.margin
}

local battery_tooltip = awful.tooltip {}
battery_tooltip:add_to_object(bar)

awesome.connect_signal('battery::percentage',function(percentage)
                     bar:get_children_by_id('bar')[1].value = percentage
                     battery_tooltip.text = 'BAT '.. percentage .. '%'
end)

return bar
