local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local menu = require("widgets.menu")
local client = client
local batterybar = require('widgets.battery')
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local drawing = require('drawing')
local run = require('widgets.run')

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
	{ "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{ "quit", function() awesome.quit() end },
}

local mymainmenu = menu.build({
	before = {
		{ "Awesome", myawesomemenu, beautiful.awesome_icon },
	},
	after = {
		{ "Open terminal", terminal },
	},
	sub_menu = "applications"
})

local mypowermenu = awful.menu {
	{ "Log out", function() awesome.quit() end },
	{ "Hibernate", function() awful.spawn('systemctl Hibernate') end },
	{ "Suspend", function() awful.spawn('systemctl suspend') end },
	{ "Reboot", function() awful.spawn('systemctl reboot') end },
	{ "Power off", function() awful.spawn('systemctl poweroff') end },
}

beautiful.taglist_fg_focus = beautiful.fg_normal
beautiful.taglist_bg_focus = beautiful.bg_normal

local function createButton(args)
	local button =  wibox.widget{
		{
			{
				drawing.rectangle:new {color = args.color, width = dpi(10), height = dpi(10),id='rectangle'},
				valign = 'center',
				halign = 'center',
				widget = wibox.container.place
			},
			top = dpi(8), bottom = dpi(8), left = dpi(10), right = dpi(10),
			widget = wibox.container.margin
		},
		widget = wibox.container.background
	}

	button:connect_signal("mouse::enter", function()
		button.bg = args.color .. '30'
	end)

	button:connect_signal("mouse::leave", function()
		button.bg = nil
	end)

	local buttons = {}
	if type(args.func1) == 'function' then
		table.insert(buttons,(awful.button({}, 1, function ()
			args.func1()
		end)))
	end

	if type(args.func2) == 'function' then
		table.insert(buttons,awful.button({}, 3, function ()
			args.func2()
		end))
	end

	button:buttons(gears.table.join(table.unpack(buttons)))
	if args.tooltip_text then
		awful.tooltip {
			text = args.tooltip_text ,
			objects = {button},
		}
	end
	return button
end

local button1 = createButton({
	color = beautiful.button1_color,
	func1 = function() mymainmenu:toggle() end,
	func2 = run.run_prompt,
	tooltip_text = 'menu/command search',
})

local button2 = createButton({
	color = beautiful.button2_color,
	func1 = function() awful.spawn('flameshot gui') end,
	tooltip_text = 'screenshot',
})

local button3 = createButton({
	color = beautiful.button3_color,
	func1 = function() awful.spawn(terminal) end,
	func2 = function() awful.spawn(editor_cmd) end,
	tooltip_text = 'terminal/editor',
})


local button4 = createButton({
	color = beautiful.button4_color,
	func1 = function() awful.spawn(browser) end,
	func2 = function() awful.spawn.with_shell('Discord || discord') end,
	tooltip_text = 'browser/chat app',
})

local button5 = createButton({
	color = beautiful.button5_color,
	func1 = function() mypowermenu:toggle() end,
	func2 = function() awful.spawn('systemctl poweroff') end,
	tooltip_text = 'power menu/power off',
})

-- local button6 = createButton({
	-- 		color = beautiful.button6_color,
	-- 		func1 = function() awful.util.spawn("amixer set Capture toggle", false) end,
	-- 		func2 = function() awful.util.spawn("amixer set Capture toggle", false) end,
	-- 		tooltip_text = 'microphone',
	-- })
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
		-- button6:get_children_by_id('rectangle')[1].shape = gears.shape.circle

		-- awesome.connect_signal("microphone", function(muted)
			-- 						   if muted then
			-- 							   button6:get_children_by_id('rectangle')[1].bg = beautiful.button6_color .. '00'
			-- 						   else
			-- 							   button6:get_children_by_id('rectangle')[1].bg = beautiful.button6_color
			-- 						   end
			-- end)

			return function(s)
				-- Create an imagebox widget which will contain an icon indicating which layout we're using.
				-- We need one layoutbox per screen.
				s.mylayoutbox = awful.widget.layoutbox(s)
				s.mylayoutbox:buttons(gears.table.join(
					awful.button({ }, 1, function () awful.layout.inc( 1) end),
					awful.button({ }, 3, function () awful.layout.inc(-1) end),
					awful.button({ }, 4, function () awful.layout.inc( 1) end),
					awful.button({ }, 5, function () awful.layout.inc(-1) end)))

					local clock = wibox.widget.textclock()

					local myclock_t = awful.tooltip { }

					myclock_t:add_to_object(clock)
					clock:connect_signal('mouse::enter', function()
						myclock_t.text = os.date('%A %B %d %Y\n%T')
					end)
					s.mytaglist = awful.widget.taglist {
						screen  = s,
						filter  = awful.widget.taglist.filter.selected,
					}
					-- Create a tasklist widget
					s.mytasklist = awful.widget.tasklist {
						screen  = s,
						filter  = awful.widget.tasklist.filter.currenttags,
						buttons = tasklist_buttons,
						style = {
							align = 'center',
							bg_normal = beautiful.tasklist_underline_normal,
							bg_focus = beautiful.tasklist_underline_focus,
						},
						layout   = {
							max_widget_size = dpi(200),
							layout  = wibox.layout.flex.horizontal
						},
						widget_template =
						{
							nil,
							{
								{
									{
										{
											id     = 'text_role',
											widget = wibox.widget.textbox,
										},
										height = dpi(2),
										strategy = "max",
										widget = wibox.container.constraint,
									},
									left  = dpi(5),
									right = dpi(5),
									widget = wibox.container.margin,
								},
								id = 'background',
								widget        = wibox.container.background,
							},
							{
								wibox.widget.base.make_widget(),
								forced_height = dpi(4),
								id            = 'background_role',
								widget        = wibox.container.background,
							},
							create_callback = function(self, c, index, objects) --luacheck: no unused args
								local color
								if c == client.focus then
									color = beautiful.tasklist_bg_focus
								else
									color =  beautiful.tasklist_bg_normal
								end
								self:get_children_by_id('background')[1].bg = color
							end,
							update_callback = function(self, c, index, objects) --luacheck: no unused args
								local color
								if c == client.focus then
									color = beautiful.tasklist_bg_focus
								elseif c.minimized == true then
									color =  beautiful.tasklist_bg_minimized
								else
									color =  beautiful.tasklist_bg_normal
								end
								self:get_children_by_id('background')[1].bg = color
							end,
							layout = wibox.layout.align.vertical,
						},

					}
					local systray = wibox.widget.systray()
					systray:set_base_size(dpi(15))
					-- Create the wibox
					s.mywibox = awful.wibar({ position = "bottom", screen = s, height = dpi(32), visible = true })
					-- Add widgets to the wibox
					s.mywibox:setup {
						layout = wibox.layout.align.horizontal,
						expand = 'inside',
						{ -- Left widgets
							button1,
							button2,
							button3,
							button4,
							button5,
							s.mytaglist,
							layout = wibox.layout.fixed.horizontal,
						},
						s.mytasklist,
						{ -- Right widgets
							layout = wibox.layout.fixed.horizontal,
							{
								wibox.container.place(systray),
								right = dpi(20),
								widget = wibox.container.margin,
							},
							-- button6,
							-- {
								-- 	volumebar,
								-- 	top = dpi(2),
								-- 	bottom = dpi(2),
								-- 	widget = wibox.container.margin,
								-- },

								{

									batterybar,
									top = dpi(2),
									bottom = dpi(2),
									widget = wibox.container.margin,
								},
								clock,
								{
									{
										s.mylayoutbox,
										left=dpi(7),
										right=dpi(7),
										top=dpi(7),
										bottom=dpi(7),
										widget = wibox.container.margin
									},
									bg = beautiful.fg_normal .. '10',
									widget = wibox.container.background
								}
							},
						}

					end
