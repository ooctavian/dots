-- Provides:
-- lemon::packages
local awful = require("awful")

local update_interval = 60
local pkg_script = [[
  sh -c "
pacman -Q | wc -l 
  "]]

-- Periodically get temperature info
awful.widget.watch(pkg_script, update_interval, function(widget, stdout)
    awesome.emit_signal("lemon::packages", tonumber(stdout))
end)
