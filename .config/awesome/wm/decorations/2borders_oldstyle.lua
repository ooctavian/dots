local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local rectangle = require('drawing.rectangle')
local beautiful = require("beautiful")
local client = client

local createRect = function(wid,col,func)
    local r = rectangle:new({color = '#00000000'})
    r.buttons = gears.table.join(
        awful.button({},1,nil,function()
                func()
    end))
    r.forced_width = wid
    r = wibox.widget(r)
    r:connect_signal('mouse::enter', function()
                         r.bg = col
    end)
    r:connect_signal('mouse::leave', function()
                         r.bg = '#00000000'
    end)
    return r
end

local buttons = gears.table.join(
    awful.button({ }, 1, function()
            client.focus:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(client.focus)
    end),
    awful.button({ }, 3, function()
            client.focus:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(client.focus)
    end)
)
local buttons_resize = gears.table.join(
    awful.button({ }, 1, function()
            client.focus:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(client.focus)
    end),
    awful.button({ }, 3, function()
            client.focus:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(client.focus)
    end)
)
-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)

                          awful.titlebar(c, {
                                             position = 'bottom',
                                             size = beautiful.innerBorder,
                                             bg_normal = beautiful.innerBorderNormal,
                                             bg_focus = beautiful.innerBorderFocus
                          }) :setup { buttons = buttons_resize, layout = wibox.layout.fixed.horizontal }
                          awful.titlebar(c, {
                                             position = 'left',
                                             size = beautiful.innerBorder,
                                             bg_normal = beautiful.innerBorderNormal,
                                             bg_focus = beautiful.innerBorderFocus
                          }) :setup { buttons = buttons_resize, layout = wibox.layout.fixed.horizontal }
                          awful.titlebar(c, {
                                             position = 'right',
                                             size = beautiful.innerBorder,
                                             bg_normal = beautiful.innerBorderNormal,
                                             bg_focus = beautiful.innerBorderFocus
                          }) :setup { buttons = buttons_resize, layout = wibox.layout.fixed.horizontal }

                          awful.titlebar(c, {
                                             position = 'top',
                                             size = beautiful.innerBorder,
                                             bg_normal = beautiful.innerBorderNormal,
                                             bg_focus = beautiful.innerBorderFocus
                          }) : setup {
                              { -- Left
                                  buttons = buttons,
                                  layout  = wibox.layout.fixed.horizontal
                              },
                              { -- Middle
                                  buttons = buttons,
                                  layout  = wibox.layout.flex.horizontal
                              },

                              { -- Right
                                  createRect(beautiful.titlebar_button_size,beautiful.sticky_color,function() c.sticky = not c.sticky  end),
                                  createRect(beautiful.titlebar_button_size,beautiful.minimize_color,function() c.minimized = not c.minimized  end),
                                  createRect(beautiful.titlebar_button_size,beautiful.maximize_color,function() c.maximized = not c.maximized end),
                                  createRect(beautiful.titlebar_button_size,beautiful.close_color,function() c:kill() end),
                                  layout = wibox.layout.fixed.horizontal()
                              },
                              layout = wibox.layout.align.horizontal
                            }

                          c.border_width = beautiful.outerBorder
                          c.border_color = beautiful.outerBorderColor
end)
