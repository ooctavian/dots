local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local rectangle = require('drawing.rectangle')
local beautiful = require("beautiful")
local client = client
local createRect = function(wid,col,func)
    local r = rectangle:new({color = col})
    r.buttons = gears.table.join(
        awful.button({},1,nil,function()
                func()
    end))
    r.forced_width = wid
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
                                             size = beautiful.titlebar_size,
                                             bg = beautiful.titlebar_color
                          }) :setup { buttons = buttons_resize, layout = wibox.layout.fixed.horizontal }
                          awful.titlebar(c, {
                                             position = 'left',
                                             size = beautiful.titlebar_size,
                                             bg = beautiful.titlebar_color
                          }) :setup { buttons = buttons_resize, layout = wibox.layout.fixed.horizontal }
                          awful.titlebar(c, {
                                             position = 'right',
                                             size = beautiful.titlebar_size,
                                             bg = beautiful.titlebar_color
                          }) :setup { buttons = buttons_resize, layout = wibox.layout.fixed.horizontal }

                          awful.titlebar(c, {
                                             position = 'top',
                                             size = beautiful.titlebar_size,
                                             bg = beautiful.titlebar_color
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
                                  createRect(beautiful.titlebar_size,beautiful.titlebar_color,function()
                                                 client.focus:emit_signal("request::activate", "titlebar", {raise = true})
                                                 awful.mouse.client.move(client.focus)
                                  end),
                                  layout = wibox.layout.fixed.horizontal()
                              },
                              layout = wibox.layout.align.horizontal
                            }

                          if awesome.startup
                              and not c.size_hints.user_position
                              and not c.size_hints.program_position then
                              -- Prevent clients from being unreachable after screen count changes.
                              awful.placement.no_offscreen(c)
                          end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
                          c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

--[[
    client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    end)

    client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    end)
]]--
-- }}}

--client.connect_signal("property::floating", function(c)

--end)
