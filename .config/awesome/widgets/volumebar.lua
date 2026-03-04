local awful     = require('awful')
local wibox     = require('wibox')
local beautiful = require('beautiful')
local gears     = require('gears')
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local muted_color = beautiful.volume_bar_muted
local nonmuted_color = { type = "linear",
                      from = { 0, 0 },
                      to = { 200, 50 },
                      stops = { { 0, beautiful.volume_bar_gradient_1 }, { 0.75, beautiful.volume_bar_gradient_2  } }}

local bar = wibox.widget {
  {
    id            = 'bar',
    max_value     = 200,
    value         = 0,
    forced_height = dpi(20),
    forced_width  = dpi(100),
    shape         = gears.shape.rounded_bar,
    bar_shape     = gears.shape.rounded_bar,
    border_color  = beautiful.border_color,
    background_color = beautiful.volume_bar_bg,
    color         = nonmuted_color;
    widget        = wibox.widget.progressbar,
  },
  buttons =  gears.table.join(
    awful.button({ }, 3, function() awful.spawn('pavucontrol') end),
    awful.button({ }, 1, function() awful.spawn('pactl set-sink-mute 0 toggle') end),
    awful.button({ }, 4, function() awful.spawn('pactl set-sink-volume 0 +2%') end),
    awful.button({ }, 5, function() awful.spawn('pactl set-sink-volume 0 -2%') end)
  ),
  margins = 3,
  widget = wibox.container.margin
}

awesome.connect_signal('volume', function(percentage,muted)
                     bar:get_children_by_id('bar')[1].value = percentage
                     if muted then
                        bar:get_children_by_id('bar')[1].color = muted_color
                     else
                        bar:get_children_by_id('bar')[1].color = nonmuted_color
                     end
end)

return bar
