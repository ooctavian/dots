local awful = require('awful')
local beautiful = require('beautiful') 
awful.mouse.snap.edge_enabled = false
awful.mouse.snap.client_enabled = false
awful.mouse.drag_to_tag.enabled = true
local client = client

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
                          c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("manage", function (c)
if awesome.startup
                              and not c.size_hints.user_position
                              and not c.size_hints.program_position then
                              awful.placement.no_offscreen(c)
                          end
end)

client.connect_signal("property::urgent", function(c)
    c.minimized = false
    c:jump_to()
end)

require('wm.savefloats')

-- require('wm.decorations.nest')
-- require('wm.decorations.default')
-- require('wm.decorations.2borders_oldstyle')
-- require('wm.decorations.2borders')
--
-- Don't show border if there is only one client
if beautiful.border_width and beautiful.border_width > 0 then
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
end
