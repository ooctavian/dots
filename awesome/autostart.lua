local awful = require("awful")

local function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(' ')
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.with_shell(string.format('pgrep -u $USER -x %s > /dev/null || (%s)', findme, cmd), false)
end

  run_once("xcompmgr")
  run_once("nm-applet")
  run_once("setxkbmap -option caps:escape")
return autostart
