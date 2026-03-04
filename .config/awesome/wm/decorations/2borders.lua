local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local rectangle = require('drawing.rectangle')
local beautiful = require("beautiful")
local client = client

local function createRect(args)
    local r = rectangle:new({color = args.color})
    r.buttons = gears.table.join(
        awful.button({},1,nil,function()
                args.client:emit_signal("request::activate", "titlebar", {raise = true})
                awful.mouse.client.resize(args.client)
    end))
    r.forced_height = args.height or nil
    r.forced_width = args.width or nil
    r.id = 'border'
    return r
end

local createButton = function(wid,col,func)
    local r = rectangle:new({color = beautiful.outerBorderColor})
    r.buttons = gears.table.join(
        awful.button({},1,nil,function() func() end)
    )
    r = wibox.widget(r)
    r.forced_width = wid
    r:connect_signal('mouse::enter', function()
                         r.bg = col
    end)

    r:connect_signal('mouse::leave', function()
                         r.bg = nil
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


local horizontalInnerBorder = createRect({client = c,height = beautiful.innerBorder,color = beautiful.innerBorderFocus, id = 'inner'})
-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("request::titlebars", function (c)
                          awful.titlebar(c, {
                                             position = 'bottom',
                                             size = beautiful.totalBorder,
                                             bg = beautiful.outerBorderColor
                          }) :setup {
                              createRect({client = c, width = beautiful.outerBorder,color = beautiful.outerBorderColor}),
                              {
                                  horizontalInnerBorder,
                                  nil,
                                  nil,
                                  buttons = buttons_resize,
                                  layout = wibox.layout.align.vertical
                              },
                              createRect({client = c, width = beautiful.outerBorder,color = beautiful.outerBorderColor, id = 'inner'}),
                              layout = wibox.layout.align.horizontal
                                    }
                          awful.titlebar(c, {
                                             position = 'left',
                                             size = beautiful.totalBorder,
                                             bg = beautiful.outerBorderColor
                          }) :setup {
                              nil,
                              nil,
                              createRect({client = c,width = beautiful.innerBorder,color = beautiful.innerBorderFocus, id = 'inner'}),
                              buttons = buttons_resize,
                              layout = wibox.layout.align.horizontal
                                    }
                          awful.titlebar(c, {
                                             position = 'right',
                                             size = beautiful.totalBorder,
                                             bg = beautiful.outerBorderColor
                          }) :setup {
                              createRect({client = c,width = beautiful.innerBorder,color = beautiful.innerBorderFocus, id = 'inner'}),
                              nil,
                              nil,
                              buttons = buttons_resize,
                              layout = wibox.layout.align.horizontal
                                    }

                          awful.titlebar(c, {
                                             position = 'top',
                                             size = beautiful.totalBorder,
                                             bg = beautiful.outerBorderColor
                          }) : setup {
                              createRect({client = c, width = beautiful.outerBorder,color = beautiful.outerBorderColor}),
                              {
                                  nil,
                                  {
                                      { -- Left
                                          buttons = buttons,
                                          layout  = wibox.layout.fixed.horizontal
                                      },
                                      { -- Middle
                                          buttons = buttons,
                                          layout  = wibox.layout.flex.horizontal
                                      },

                                      { -- Right
                                          createButton(beautiful.titlebar_button_size,beautiful.sticky_color,function() c.sticky = not c.sticky  end),
                                          createButton(beautiful.titlebar_button_size,beautiful.minimize_color,function() c.minimized = not c.minimized  end),
                                          createButton(beautiful.titlebar_button_size,beautiful.maximize_color,function() c.maximized = not c.maximized end),
                                          createButton(beautiful.titlebar_button_size,beautiful.close_color,function() c:kill() end),
                                          createButton(beautiful.titlebar_size,beautiful.outerBorderColor,function()
                                                           client.focus:emit_signal("request::activate", "titlebar", {raise = true})
                                                           awful.mouse.client.move(client.focus)
                                          end),
                                          layout = wibox.layout.fixed.horizontal
                                      },
                                      layout = wibox.layout.align.horizontal
                                  },
                                  horizontalInnerBorder,
                                  layout = wibox.layout.align.vertical,
                              },
                              createRect({client = c, width = beautiful.outerBorder,color = beautiful.outerBorderColor}),
                              layout = wibox.layout.align.horizontal,
                                     }

end)


-- }}}
