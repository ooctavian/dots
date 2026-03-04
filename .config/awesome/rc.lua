pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Theme handling library
local beautiful = require("beautiful")
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")
-- Notification library
local naughty = require("naughty")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
local scratch = require('wm.scratch')
require('signals')

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
					 title = "Oops, there were errors during startup!",
					 text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
							   -- Make sure we don't go into an endless error loop
							   if in_error then return end
							   in_error = true

							   naughty.notify({ preset = naughty.config.presets.critical,
												title = "Oops, an error happened!",
												text = tostring(err) })
							   in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.

require('wm')
-- This is used later as the default terminal and editor to run.
terminal = "alacritty"
editor = os.getenv("EDITOR") or "emacs"
editor_cmd = "emacs"
browser = 'chromium-browser'
file_manager = "nautilus"

local bar = require("widgets.bar.bar1")
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

local layouts = require('layouts')
local machi = require('layouts.layout-machi')
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.max,
	layouts.machi,
	awful.layout.suit.floating,
}

local directional_layouts = {
	layouts.treetile,
	layouts.machi,
}

local function check_if_directional(layout)
	for _,v in pairs(directional_layouts) do
		if layout == v then
			return true
		end
	end
	return false
end
-- }}}

-- Menubar configuration
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar

-- Create a wibox for each screen and add it
local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
		-- Wallpaper
		set_wallpaper(s)

		-- Each screen has its own tag table.
		awful.tag({"1", "2", "3", "4", "5"},
			s,
			{
				awful.layout.layouts[1],
				awful.layout.layouts[2],
				awful.layout.layouts[1],
				awful.layout.layouts[1],
				awful.layout.layouts[1],
		})

		bar(s)
		-- require("widgets.bar.bar2")(s)
end)
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
	awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
		{description="show help", group="awesome"}),
	awful.key({ modkey,           }, "Left",   function()
			awful.tag.viewprev()
	end,
		{description = "view previous", group = "tag"}),
	awful.key({ modkey,           }, "Right",  function()
			awful.tag.viewnext()
	end,
		{description = "view next", group = "tag"}),
	awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
		{description = "go back", group = "tag"}),

	awful.key({ modkey,           }, "j",
		function ()
			if check_if_directional(awful.layout.get(client.focus.screen)) then
				awful.client.focus.bydirection("down")
			else
				awful.client.focus.byidx( 1)
			end
		end,
		{description = "focus next by index", group = "client"}
	),
	awful.key({ modkey,           }, "k",
		function ()
			if check_if_directional(awful.layout.get(client.focus.screen)) then
				awful.client.focus.bydirection("up")
			else
				awful.client.focus.byidx( -1)
			end
		end,
		{description = "focus previous by index", group = "client"}
	),
	-- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j", function ()
			if check_if_directional(awful.layout.get(client.focus.screen)) then
				awful.client.swap.bydirection("down")
			else
				awful.client.swap.byidx(  1)
			end
	end,
		{description = "swap with next client by index", group = "client"}),
	awful.key({ modkey, "Shift"   }, "k", function ()
			if check_if_directional(awful.layout.get(client.focus.screen)) then
				awful.client.swap.bydirection("up")
			else
				awful.client.swap.byidx(-1)
			end
	end,
		{description = "swap with previous client by index", group = "client"}),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
		{description = "focus the next screen", group = "screen"}),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
		{description = "focus the previous screen", group = "screen"}),
	awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
		{description = "jump to urgent client", group = "client"}),
	awful.key({ 'Mod1',           }, "Tab", function ()
			awful.client.focus.byidx(1)
			if client.focus then
				client.focus:raise()
			end
	end,
		{description = "go next", group = "client"}),
	awful.key({ 'Mod1', 'Shift'   }, "Tab", function ()
			awful.client.focus.byidx(-1)
			if client.focus then
				client.focus:raise()
			end
	end,
		{description = "go back", group = "client"}),

	awful.key({ modkey  }, "Return",
		function ()
			awful.spawn(terminal)
		end,
		{description = "open a terminal", group = "launcher"}),

	awful.key({ modkey }, "d",
		function ()
			scratch.toggle("alacritty --class scratch", { instance = "scratch" })
		end,
		{description = "open a termianl scratchpad", group = "launcher"}),

	awful.key({ modkey }, "w", function ()
			awful.spawn(browser)
	end,
		{description = "open browser", group = "launcher"}),

	awful.key({ modkey, "Shift"}, "f", function ()
			awful.spawn(file_manager)
	end,
		{description = "open file manager", group = "launcher"}),

	awful.key({ modkey }, "e",
		function ()
			awful.spawn.raise_or_spawn('emacsclient -c'
									   ,nil
									   ,function(c)
										   return awful.rules.match(c,{class = 'emacs'})
									   end
									   ,nil)
		end,
		{description = "open emacs", group = "applications"}),

	awful.key({ modkey, "Control" }, "r", awesome.restart,
		{description = "reload awesome", group = "awesome"}),
	awful.key({ modkey, "Shift"   }, "q", awesome.quit,
		{description = "quit awesome", group = "awesome"}),

	awful.key({ modkey,           }, "l", function()
			if check_if_directional(awful.layout.get(client.focus.screen)) then
				awful.client.focus.bydirection("right")
			else
				awful.tag.incmwfact(0.05)
			end
	end,
		{description = "increase master width factor", group = "layout"}),
	awful.key({ modkey }, "h",
		function ()
			if check_if_directional(awful.layout.get(client.focus.screen)) then
				awful.client.focus.bydirection("left")
			else
				awful.tag.incmwfact(-0.05)
			end
		end,
		{description = "decrease master width factor", group = "layout"}),
	awful.key({ modkey, "Shift" }, "h",     function ()
			if check_if_directional(awful.layout.get(client.focus.screen)) then
				awful.client.swap.bydirection("left")
			else
				awful.tag.incnmaster( 1, nil, true)
			end
	end,
		{description = "increase the number of master clients", group = "layout"}),
	awful.key({ modkey, "Shift" }, "l",     function ()
			if check_if_directional(awful.layout.get(client.focus.screen)) then
				awful.client.swap.bydirection("right")
			else
				awful.tag.incnmaster(-1, nil, true)
			end
	end,
		{description = "decrease the number of master clients", group = "layout"}),
	awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
		{description = "increase the number of columns", group = "layout"}),
	awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
		{description = "decrease the number of columns", group = "layout"}),
	awful.key({ modkey,           }, "space", function ()
			awful.layout.inc( 1)
	end,
		{description = "select next", group = "layout"}),
	awful.key({ modkey, "Shift"   }, "space", function ()
			awful.layout.inc(-1)
	end,
		{description = "select previous", group = "layout"}),

	awful.key({ modkey, "Control" }, "n",
		function ()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal(
					"request::activate", "key.unminimize", {raise = true}
				)
			end
		end,
		{description = "restore minimized", group = "client"}),

	-- Prompt
	awful.key({ modkey },            "r", function() awful.spawn.with_shell("rofi -show drun") end,
		{description = "run prompt", group = "launcher"}),

	-- Menubar
	-- awful.key({ modkey }, "p", function() menubar.show() end,
	-- 	{description = "show the menubar", group = "launcher"}),
	--
	awful.key({ modkey }, "p",
		function () scratch.toggle("pavucontrol", { instance = "pavucontrol" }) end,
		{description = "open pavucontrol", group = "media"}),
	awful.key({ }, "XF86AudioRaiseVolume", function () awful.spawn("pactl set-sink-volume 0 +5%") end,
		{description = "Increase volume", group = "media"}),
	awful.key({ }, "XF86AudioLowerVolume", function () awful.spawn("pactl set-sink-volume 0 -5%") end,
		{description = "Lower volume", group = "media"}),
	awful.key({ }, "XF86AudioMute", function () awful.spawn("pactl set-sink-mute 0 toggle") end,
		{description = "Mute volume", group = "media"}),
	awful.key({ }, "XF86AudioPlay", function () awful.spawn("playerctl play-pause") end,
		{description = "Play media", group = "media"}),
	awful.key({ }, "XF86AudioPause", function () awful.spawn("playerctl play-pause") end,
		{description = "Pause media", group = "media"}),
	awful.key({ }, "XF86AudioStop", function () awful.spawn("playerctl stop") end,
		{description = "Stop media", group = "media"}),
	awful.key({ }, "XF86AudioNext", function () awful.spawn("playerctl next") end,
		{description = "Next item", group = "media"}),
	awful.key({ }, "XF86AudioPrev", function () awful.spawn("playerctl previous") end,
		{description = "Previous item", group = "media"}),
	awful.key({ }, "XF86AudioMicMute", function () awful.spawn("amixer set Capture toggle") end,
		{description = "Mute microphone", group = "media"}),
	awful.key({ }, "Print", function () awful.spawn("flameshot gui") end,
		{description = "Increase volume", group = "media"}),
	awful.key({ modkey }, "b", function()
			local s = awful.screen.focused()
			s.mywibox.visible = not s.mywibox.visible
	end,
		{description = "toggle bar visibility", group = "awesome"}),
	awful.key({ modkey,           }, ".",    function () machi.default_editor.start_interactive() end,
		{description = "edit the current layout if it is a machi layout", group = "layout"}),
	awful.key({ modkey,           }, "/",    function () machi.switcher.start(client.focus) end,
		{description = "switch between windows for a machi layout", group = "layout"})
)

clientkeys = gears.table.join(
	awful.key({ modkey,           }, "f",
		function (c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
		{description = "toggle fullscreen", group = "client"}),
	awful.key({ modkey, }, "q",      function (c) c:kill()                         end,
		{description = "close", group = "client"}),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
		{description = "toggle floating", group = "client"}),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
		{description = "move to master", group = "client"}),
	awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
		{description = "move to screen", group = "client"}),
	awful.key({ modkey,           }, "a",      function (c) c.sticky = not c.sticky            end,
		{description = "toggle sticky", group = "client"}),
	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
		{description = "toggle keep on top", group = "client"}),
	awful.key({ modkey,           }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end ,
		{description = "minimize", group = "client"}),
	awful.key({ modkey,           }, "m",
		function (c)
			c.maximized = not c.maximized
			c:raise()
		end ,
		{description = "(un)maximize", group = "client"}),
	awful.key({ modkey, "Control" }, "m",
		function (c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end ,
		{description = "(un)maximize vertically", group = "client"}),
	awful.key({ modkey, "Shift"   }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end ,
		{description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
								  -- View tag only.
								  awful.key({ modkey }, "#" .. i + 9,
									  function ()
										  local screen = awful.screen.focused()
										  local tag = screen.tags[i]
										  if tag then
											  tag:view_only()
										  end
									  end,
									  {description = "view tag #"..i, group = "tag"}),
								  -- Toggle tag display.
								  awful.key({ modkey, "Control" }, "#" .. i + 9,
									  function ()
										  local screen = awful.screen.focused()
										  local tag = screen.tags[i]
										  if tag then
											  awful.tag.viewtoggle(tag)
										  end
									  end,
									  {description = "toggle tag #" .. i, group = "tag"}),
								  -- Move client to tag.
								  awful.key({ modkey, "Shift" }, "#" .. i + 9,
									  function ()
										  if client.focus then
											  local tag = client.focus.screen.tags[i]
											  if tag then
												  client.focus:move_to_tag(tag)
											  end
										  end
									  end,
									  {description = "move focused client to tag #"..i, group = "tag"}),
								  -- Toggle tag on focused client.
								  awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
									  function ()
										  if client.focus then
											  local tag = client.focus.screen.tags[i]
											  if tag then
												  client.focus:toggle_tag(tag)
											  end
										  end
									  end,
									  {description = "toggle focused client on tag #" .. i, group = "tag"})
	)
end

clientbuttons = gears.table.join(
	awful.button({ }, 1, function (c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
	end),
	awful.button({ modkey }, 1, function (c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
			awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function (c)
			c:emit_signal("request::activate", "mouse_click", {raise = true})
			awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
	  properties = { border_width = beautiful.border_width,
					 border_color = beautiful.border_normal,
					 focus = awful.client.focus.filter,
					 raise = true,
					 keys = clientkeys,
					 buttons = clientbuttons,
					 screen = awful.screen.preferred,
					 placement = awful.placement.centered + awful.placement.no_overlap+awful.placement.no_offscreen,
					 size_hints_honor = false
	  }
	},

	-- Floating clients.
	{ rule_any = {
		  instance = {
			  "DTA",  -- Firefox addon DownThemAll.
			  "copyq",  -- Includes session name in class.
			  "pinentry",
		  },
		  class = {
			  -- "Arandr",
			  "Blueman-manager",
			  "Gpick",
			  "Kruler",
			  "MessageWin",  -- kalarm.
			  "Sxiv",
			  "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
			  "Wpa_gui",
			  "veromix",
			  "xtightvncviewer"},

		  -- Note that the name property shown in xprop might be set slightly after creation of the client
		  -- and the name shown there might not match defined rules here.
		  name = {
			  "Event Tester",  -- xev.
		  },
		  role = {
			  "AlarmWindow",  -- Thunderbird's calendar.
			  "ConfigManager",  -- Thunderbird's about:config.
			  "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
		  }
	}, properties = { floating = true }},
	{
	    rule_any = {
	        class = {
	            "URxvt",
	            "discord"
	        },
	    },
	    properties = {size_hints_honor = false}
	},
	-- Add titlebars to normal clients and dialogs
	{ rule_any = {type = { "normal", "dialog" }
				 }, properties = { titlebars_enabled = true }
	},

	{ rule = { instance = "scratch" },
	  properties = {
		  floating = true,
		  ontop = true,
		  minimized = true,
		  -- sticky = true,
		  skip_taskbar = true,
		  width = screen_width * 0.35,
		  height = screen_height * 0.4,
		  placement = awful.placement.centered
	  },
	  callback = function (c)
		  gears.timer.delayed_call(function() c.urgent = false end)
	  end
	},

	-- { rule = { instance = "MusicPlayer" },
	--   properties = {
	-- 	  floating = true,
	-- 	  ontop = true,
	-- 	  minimized = true,
	-- 	  -- sticky = true,
	-- 	  skip_taskbar = true,
	-- 	  width = screen_width * 0.35,
	-- 	  height = screen_height * 0.4
	--   },
	--   callback = function (c)
	-- 	  awful.placement.top_right(c,{honor_padding = true, honor_workarea=true, offset = {x = -30, y = 10}})
	-- 	  gears.timer.delayed_call(function() c.urgent = false end)
	--   end
	-- },

	{ rule = { instance = "pavucontrol" },
	  properties = {
		  floating = true,
		  ontop = true,
		  minimized = true,
		  -- sticky = true,
		  skip_taskbar = true,
		  width = screen_width * 0.35,
		  height = screen_height * 0.4
	  },
	  callback = function (c)
		  awful.placement.top_left(c,{honor_padding = true, honor_workarea=true, offset = {x = 30, y = 10}})
		  gears.timer.delayed_call(function() c.urgent = false end)
	  end
    },

    { rule = { class = "Toolkit" },
	  properties = {
		  floating = true,
		  ontop = true,
		  sticky = true,
		  width = screen_width * 0.25,
		  height = screen_height * 0.3,
		  titlebars_enabled = false,
	  },
	  callback = function (c)
		  awful.placement.bottom_right(c,{honor_padding = true, honor_workarea=true, offset = {x = -30, y = -10}})
		  gears.timer.delayed_call(function() c.urgent = false end)
	  end
    },

    -- { rule = { instance = "GLava" },
	--   properties = {
	-- 	  floating = true, below = true, sticky = true, skip_taskbar = true,
	-- 	  requests_no_titlebar = false
	--   },
	--   callback = function(c) awful.client.setslave(c) end },
	{
		rule = { class = "Emacs"},
		properties = {tag = awful.screen.focused().tags[1]}
	},
	{
		rule_any = { class = {"firefox", "Chromium-browser"}},
		properties = {tag = awful.screen.focused().tags[2]}
	},
	{
		rule = { class = "discord"},
		properties = {tag = awful.screen.focused().tags[3]}
	},
}
-- }}}

-- {{ Autorun apps
local autorun = true

local run_once = function(name)
	awful.spawn.with_shell('pgrep -x ' .. name .. ' || '.. name)
end

local autorunApps = {
		'xfce4-power-manager',
		'flameshot',
		'picom',
		'xfconf-query --create -c xfce4-session -p /general/LockCommand -t string -s "dm-tool lock"',
		'xinput set-prop 10 353 0.4',
		'blueman-applet',
		'nm-applet',
		'volumeicon'
	}

if autorun then
	for i=1, #autorunApps do
		run_once(autorunApps[i])
	end
end
-- }}
-- 
collectgarbage()
collectgarbage('setpause', 110)
collectgarbage('setstepmul', 1000)
