local beautiful = require("beautiful")
local awful = require("awful")
local client = client

-- {{{ Signals
-- Signal function to execute when a new client appears.
if beautiful.border_focus ~= nil then
	client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
end

if beautiful.border_normal ~= nil then
	client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
end

--
client.connect_signal("manage", function(c)
local t = awful.screen.focused().selected_tag
    if #t:clients() == 1 then
        c.border_width = 0
    else
        for _, c in ipairs(t:clients()) do
            c.border_width = beautiful.border_width
        end
    end
end)
