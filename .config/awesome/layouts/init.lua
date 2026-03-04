local beautiful = require("beautiful")

local machi = require(... .. ".layout-machi")
local treetile = require(... .. ".treetile")
local bsp = require(... .. ".bsp")
beautiful.layout_machi = machi.get_icon()
beautiful.layout_bsp = bsp.get_icon()

require(... .. '.better-resize')
local layout = {
  machi = machi.default_layout,
  treetile = treetile,
  bsp = bsp,
}

return layout
