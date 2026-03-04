local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require('gears')
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local theme = {}

local colors = xresources.get_current_theme()

local c = {
  bg = colors.background,
  fg = colors.foreground,
  red = colors.color1,
  green = colors.color2,
  yellow = colors.color3,
  blue = colors.color4,
  violet = colors.color5,
  cyan = colors.color6,
}

theme.colors = c

c.accent = c.violet

theme.font          = "IBM Plex Mono 8"

theme.bg_normal     = c.bg
theme.bg_focus      = c.accent
theme.bg_urgent     = c.red
theme.bg_minimize   = c.fg ..'20'
theme.bg_systray    = theme.bg_normal
theme.systray_icon_spacing = dpi(5)

theme.fg_normal     = c.fg
theme.fg_focus      = c.fg
theme.fg_urgent     = c.fg
theme.fg_minimize   = c.fg

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(0)
theme.border_normal = c.bg
theme.border_focus  = c.accent
theme.border_marked = c.red

theme.tasklist_bg_focus = c.fg .. '10'
theme.tasklist_bg_minimized = c.fg .. '03'
theme.tasklist_bg_normal = c.bg
theme.tasklist_underline_focus = c.accent
theme.tasklist_underline_normal = c.fg .. '03'
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
local submenu_icon
do
  local size = 40
  local cairo = require('lgi').cairo
  submenu_icon = cairo.ImageSurface(cairo.Format.ARGB32, size, size )
  local cr = cairo.Context(submenu_icon)
  cr:set_source(gears.color('#0000000'))
  cr:paint()
  cr:set_source(gears.color(c.violet))
  -- cr:rectangle(size/4,size/4,size/2,size/2)
  cr:arc(size/2, size/2, size/5, 0, 2 * math.pi);
  cr:fill()
end

theme.menu_submenu_icon = submenu_icon
theme.menu_height = dpi(15)
theme.menu_width  = dpi(100)

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
  theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

theme.titlebar_size = dpi(8)
theme.titlebar_button_size = dpi(25)
theme.close_color = c.red
theme.maximize_color = c.green
theme.minimize_color = c.yellow
theme.sticky_color = c.violet
theme.titlebar_color = c.bg
theme.mstab_bar_padding = dpi(0)
-- theme.colors = colors

-- Tooltip
theme.tooltip_bg = c.bg
theme.tooltip_fg = c.accent

-- battery bar
theme.battery_bar_gradient_1 = c.green
theme.battery_bar_gradient_2 = c.yellow
theme.battery_bar_bg = c.fg .. '10'

theme.volume_bar_gradient_1 = c.blue
theme.volume_bar_gradient_2 = c.cyan
theme.volume_bar_bg = c.fg ..'10'
theme.volume_bar_muted = c.blue ..'80'

-- 2 borders
theme.innerBorder = dpi(0.5)
theme.outerBorder = dpi(8)
theme.totalBorder = theme.innerBorder + theme.outerBorder
theme.innerBorderFocus = c.accent
theme.innerBorderNormal = c.bg
theme.outerBorderColor = c.bg

-- taglist popup
theme.taglist_popup_border = c.accent
theme.taglist_popup_focused = c.accent
theme.taglist_popup_occupied = c.fg .. '20'
theme.taglist_popup_widget_border = c.bg

theme.show_desktop_color = c.fg .. '05'

-- menu
theme.menu_width = dpi(175)
theme.menu_height = dpi(25)

--Run launcher
theme.run_bg = c.bg
theme.run_fg = c.fg
theme.run_fg_active = c.fg
theme.active_bg = c.fg .. '10'
theme.active_underline_color = c.accent
theme.active_inner_border_color = c.accent

local length = 10
local col1 = "#5F819D"
local col2 = colors.color12

-- buttons
theme.button1_color = c.blue
theme.button2_color = c.violet
theme.button3_color = c.yellow
theme.button4_color = c.green
theme.button5_color = c.red
theme.button6_color = c.red

theme.wallpaper = gears.filesystem.get_configuration_dir() .. "/wall.jpg"

-- theme.wallpaper = function(s)
--   local image = require('drawing.wallpaper').createHorizontalStripes(s,length,col1,col2)
--   gears.wallpaper.maximized(image, s, true)
--   -- gears.wallpaper.set(c.bg)
-- end

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth
