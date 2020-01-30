-- Declaring stuff 

local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")
local appruner =require("custom.appruner.apprunner")
modkey = "Mod4"
altkey = "Mod1"
local scratch = require("custom.scratch")
local treetile = require("treetile")
local switcher = require("custom.awesome-switcher")
local naughty =require("naughty")
local launcher =require("custom.launcher")
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

terminal = "urxvt"
editor = "vim"
editor_cmd = terminal .. "-e" .. editor
browser="tabbed -c surf -e "

globalkeys = gears.table.join(
    awful.key({}, "F1",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
   awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
--awful.key({modkey}, "d", function () awful.spawn("rofi  -modi drun -show drun") end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "Terminal apps"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
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
-------------Aplication apps
    awful.key({ altkey, }, "m", function () awful.spawn("urxvt -T \"Music Terminal\"-e ncmpcpp") end,
              {description = "ncmpcpp", group = "Terminal apps"}),
    awful.key({ altkey, }, "n", function () awful.spawn("urxvt -T \"News Terminal \" -e newsboat") end,
              {description = "newsboat", group = "Terminal apps"}),
awful.key({ modkey }, "s", function () scratch.toggle("urxvt -name scratch", { instance = "scratch" }) end),
--------------Gui Apps
    awful.key({ modkey, }, "w", function () awful.spawn("tabbed -c surf -e") end,
              {description = "SURF", group = "GUI APPS"}),
-------------{{Volume
   awful.key({ }, "XF86AudioRaiseVolume", function () os.execute("amixer set Master 3%+") end,
              {description = "Volume increase ", group = "Volume"}),
   awful.key({ }, "XF86AudioMute", function () os.execute("amixer set Master toggle") end,
              {description = "Mute", group = "Volume"}),
   awful.key({ }, "XF86AudioLowerVolume", function () os.execute("amixer set Master 3%-") end,
              {description = "Volume decrease ", group = "Volume"}),
----------MPD CONTROL
  -- MPD control
    awful.key({ }, "XF86AudioPlay",
        function ()
            os.execute("mpc toggle")
        end,
        {description = "mpc toggle", group = "mpd"}),
    awful.key({ }, "XF86AudioMute",
        function ()
            os.execute("mpc stop")
        end,
        {description = "mpc stop", group = "mpd"}),
    awful.key({ }, "XF86AudioPrev",
        function ()
            os.execute("mpc prev")
        end,
        {description = "mpc prev", group = "mpd"}),
    awful.key({ }, "XF86AudioNext",
        function ()
            os.execute("mpc next")
        end,
        {description = "mpc next", group = "mpd"}),
--Movement

awful.key({ modkey }, "j", function () awful.client.focus.bydirection("down")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "k", function () awful.client.focus.bydirection("up")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "h", function () awful.client.focus.bydirection("left")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "l", function () awful.client.focus.bydirection("right")
        if client.focus then client.focus:raise() end
    end),
---Moving clients arround
awful.key({ modkey,"Shift" }, "j", function () awful.client.swap.bydirection("down")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey,"Shift" }, "k", function () awful.client.swap.bydirection("up")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey ,"Shift"}, "h", function () awful.client.swap.bydirection("left")
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey ,"Shift"}, "l", function () awful.client.swap.bydirection("right")
        if client.focus then client.focus:raise() end
    end),

----tile layout 
awful.key({ modkey}, "e",     function ()         local c = client.focus  naughty.notify({ title = "Achtung!", text = awful.layout.get(c.screen).name , timeout = 0 })   end),

----tile layout 
awful.key({ modkey}, "p",     function () local c = client.focus
        if awful.layout.get(c.screen).name == "tile" then
	awful.tag.incmwfact( 0.03) end 
end),
awful.key({ modkey}, "u",     function () local c = client.focus
        if awful.layout.get(c.screen).name == "tile"
			then awful.tag.incmwfact(-0.03)  end  end),
awful.key({ modkey}, "i",     function () local c = client.focus
        if awful.layout.get(c.screen).name == "tile" then 
			awful.client.incwfact( 0.03)  end  end),
awful.key({ modkey}, "o",     function () local c = client.focus
	        if awful.layout.get(c.screen).name == "tile" then
	awful.client.incwfact(-0.03) end  end),

----tileleft layout 
awful.key({ modkey}, "u",     function () local c = client.focus
        if awful.layout.get(c.screen).name == "tileleft" then
	awful.tag.incmwfact( 0.03) end 
end),
awful.key({ modkey}, "p",     function () local c = client.focus
        if awful.layout.get(c.screen).name == "tileleft"
			then awful.tag.incmwfact(-0.03)  end  end),
awful.key({ modkey}, "i",     function () local c = client.focus
        if awful.layout.get(c.screen).name == "tileleft" then 
			awful.client.incwfact( 0.03)  end  end),
awful.key({ modkey}, "o",     function () local c = client.focus
	        if awful.layout.get(c.screen).name == "tileleft" then
	awful.client.incwfact(-0.03) end  end),


-- Prompt
--awful.key({modkey}, "r", function () run_shell.launch() end),
    -- Menubar
    awful.key({ modkey }, "d", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
-----ALT.TAB 
    awful.key({ altkey, }, "Tab",
      function ()
          switcher.switch( 1, altkey, "Alt_L", "Shift", "Tab")
      end),
    
    awful.key({ altkey, "Shift"   }, "Tab",
      function ()
          switcher.switch(-1, "Mod1", "Alt_L", "Shift", "Tab")
      end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,    }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
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
        {description = "(un)maximize", group = "client"}) 
		)

---}}}
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
return keys 
