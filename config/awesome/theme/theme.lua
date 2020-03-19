local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

-- Inherit default theme
local theme = dofile(themes_path.."default/theme.lua")
-- Titlebar icon path
local tip = "~/.config/awesome/theme/icons/titlebar/"
theme.wallpaper = gears.filesystem.get_configuration_dir() .. "theme/wall.png"
-- Load ~/.Xresources colors and set fallback colors
theme.xbackground = "#2f343f" or xrdb.background 
theme.xforeground = "#d8dee8" or  xrdb.foreground 
theme.xcolor0 =	    "#4b5262" or xrdb.color0 
theme.xcolor1 =     "#bf616a" or  xrdb.color1 
theme.xcolor2 =     "#a3be8c" or xrdb.color2 
theme.xcolor3 =     "#ebcb8b" or  xrdb.color3 
theme.xcolor4 =     "#81a1c1" or xrdb.color4 
theme.xcolor5 =     "#b48ead" or  xrdb.color5 
theme.xcolor6 =     "#89d0bA" or xrdb.color6 
theme.xcolor7 =     "#e5e9f0" or xrdb.color7 
theme.xcolor8 =     "#434a5a" or xrdb.color8 
theme.xcolor9 =     "#b3555e" or  xrdb.color9 
theme.xcolor10 =    "#93ae7c" or xrdb.color10 
theme.xcolor11 =    "#dbbb7b" or xrdb.color11 
theme.xcolor12 =    "#7191b1" or  xrdb.color12 
theme.xcolor13 =    "#a6809f" or xrdb.color13 
theme.xcolor14 =    "#7dbba8" or xrdb.color14 
theme.xcolor15 =    "#d1d5dc" or xrdb.color15 
theme.font          = "Iosevka Nerd Font 9"
theme.font1 	    =  "Font Awesome 5 Free 9"
theme.bg_dark       = theme.xcolor0
theme.bg_normal     = theme.xbackground
theme.bg_focus      = theme.xcolor8
theme.bg_urgent     = theme.xcolor8
theme.bg_minimize   = theme.xcolor8
theme.bg_systray    = theme.xcolor8

theme.fg_normal     = theme.xcolor8
theme.fg_focus      = theme.xcolor4
theme.fg_urgent     = theme.xcolor3
theme.fg_minimize   = theme.xcolor8

-- Borders
theme.border_width  = dpi(5)
-- theme.border_color = theme.xcolor0
theme.border_normal = theme.xbackground
theme.border_focus  = theme.xbackground
-- Rounded corners
theme.border_radius = dpi(6)

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

-- Generate taglist squares:
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

-- Taglist
theme.taglist_font = theme.font1
theme.taglist_bg = theme.xcolor0
--theme.taglist_shape = gears.shape.triagle
theme.taglist_bg_focus = theme.xcolor4
theme.taglist_fg_focus = theme.xcolor0
theme.taglist_bg_urgent = theme.xcolor1
theme.taglist_fg_urgent = theme.xforeground
theme.taglist_bg_occupied = transparent
theme.taglist_fg_occupied = theme.xcolor4
theme.taglist_bg_empty = transparent
theme.taglist_fg_empty = theme.xforeground
theme.taglist_bg_volatile = transparent
theme.taglist_fg_volatile = theme.xcolor11
 --Tasklist
theme.tasklist_font = theme.font
theme.tasklist_disable_icon = true
theme.tasklist_plain_task_name = true
theme.tasklist_bg_focus = theme.xcolor0
theme.tasklist_fg_focus = theme.xforeground
theme.tasklist_bg_minimize = theme.xcolor0 .. "77"
theme.tasklist_fg_minimize = theme.xforeground .."77"
theme.tasklist_bg_normal = theme.xcolor0 
theme.tasklist_fg_normal = theme.xforeground .."77"
theme.tasklist_disable_task_name = false
theme.tasklist_disable_icon = true 
-- theme.tasklist_font_minimized = "sans italic 8"
theme.tasklist_bg_urgent = theme.xbackground
theme.tasklist_fg_urgent = theme.xcolor3
theme.tasklist_spacing = dpi(0)
theme.tasklist_align = "center"


-- Titlebars
theme.titlebar_size = dpi(0)
theme.titlebar2_size = dpi(2)
theme.titlebar_bg_focus = theme.xcolor12
theme.titlebar_bg_normal = theme.xcolor5
theme.titlebar_fg_focus = theme.xcolor12
theme.titlebar_fg_normal = theme.xcolor5


-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"
-- Notifications
-- Position: bottom_left, bottom_right, bottom_middle,
--         top_left, top_right, top_middle
-- BUG: some notifications (e.g. by notify-send) appear at top_right regardless of this setting
theme.notification_position = "top_right" 
theme.notification_border_width = dpi(0)
theme.notification_border_radius = theme.border_radius
theme.notification_border_color = theme.xcolor10
theme.notification_bg = theme.xbackground
theme.notification_fg = theme.xcolor7
theme.notification_crit_bg = theme.xcolor9
theme.notification_crit_fg = theme.xcolor0
theme.notification_icon_size = dpi(60)
-- theme.notification_height = dpi(80)
-- theme.notification_width = dpi(300)
theme.notification_margin = dpi(15)
theme.notification_opacity = 1
theme.notification_font = theme.font
theme.notification_padding = dpi(20)
theme.notification_spacing = dpi(10)
-- Edge snap
theme.snap_bg = theme.xcolor4
theme.snap_shape = gears.shape.rectangle
-- Prompts
theme.prompt_bg = transparent
theme.prompt_fg = theme.xforeground

-- Tooltips
theme.tooltip_bg = theme.xcolor0
theme.tooltip_fg = theme.xforeground
theme.tooltip_font = theme.font
theme.tooltip_border_width = dpi(0)
theme.tooltip_border_color = theme.xcolor0
theme.tooltip_opacity = 1
theme.tooltip_align = "left"

-- Menu
theme.menu_font = "Iosevka 8"
theme.menu_bg_focus = theme.xcolor4
theme.menu_fg_focus = theme.xcolor7
theme.menu_bg_normal = theme.xbackground
theme.menu_fg_normal = theme.xcolor7
theme.menu_submenu_icon = "~/.config/awesome/theme/icons/submenu.png"
theme.menu_height = dpi(20)
theme.menu_width  = dpi(130)
theme.menu_border_color  = "#0000000"
--theme.menu_border_color  = theme.xbackground
theme.menu_border_width  = dpi(0)
-- pop up
theme.hotkeys_font = "Iosevka 8"
-- Recolor Layout icons:
theme = theme_assets.recolor_layout(theme, theme.xforeground)
-- Titlebar buttons: Define the images to load
--theme.titlebar_close_button_normal = tip .. empty
--theme.titlebar_close_button_focus  = tip .. empty
--theme.titlebar_minimize_button_normal = tip .. empty
--theme.titlebar_minimize_button_focus  = tip .. empty
--theme.titlebar_maximized_button_normal_inactive = tip .. empty
--theme.titlebar_maximized_button_focus_inactive  = tip .. empty
--theme.titlebar_maximized_button_normal_active = tip .. empty
--theme.titlebar_maximized_button_focus_active  = tip .. empty
--- (hover)
--theme.titlebar_close_button_normal_hover = tip .. "close_normal.svg"
--theme.titlebar_close_button_focus_hover  = tip .. "close_focus.svg"
--theme.titlebar_minimize_button_normal_hover = tip .. "minimize_normal_hover.svg"
--theme.titlebar_minimize_button_focus_hover  = tip .. "minimize_focus_hover.svg"
--theme.titlebar_sticky_button_normal_inactive_hover = tip .. "sticky_normal_inactive_hover.svg"
--theme.titlebar_floating_button_normal_inactive_hover = tip .. "floating_normal_inactive_hover.svg"
--theme.titlebar_maximized_button_normal_inactive_hover = tip .. "maximized_normal_inactive_hover.svg"
--theme.titlebar_maximized_button_focus_inactive_hover  = tip .. "maximized_focus_inactive_hover.svg"
--theme.titlebar_maximized_button_normal_active_hover = tip .. "maximized_normal_active_hover.svg"
--theme.titlebar_maximized_button_focus_active_hover  = tip .. "maximized_focus_active_hover.svg"
-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
--theme.icon_theme = "/usr/share/icons/Numix"
-- Generate Awesome icon:
--theme.awesome_icon = theme_assets.awesome_icon(
--    theme.menu_height, theme.bg_focus, theme.fg_focus
--)
-- layout list 
-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
-- Useless gaps
theme.useless_gap = 5
theme.sidebar_position = "left"
theme.exit_screen_fg = theme.xforeground
return theme
