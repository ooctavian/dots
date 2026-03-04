local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local widget = wibox {
	width = dpi(300),
	height = dpi(390),
	visible = false,
	ontop = true,
	bg = beautiful.run_bg
}

local M = {}

local function create_active_item(text)
	return	wibox.widget{
		{
			{
				markup = text,
				id     = 'text',
				align  = 'center',
				valign = 'center',
				widget = wibox.widget.textbox
			},
			bottom          = dpi(3),
			color           = beautiful.active_underline_color,
			widget			= wibox.container.margin
		},
		bg				= beautiful.active_bg,
		forced_height	= dpi(25),
		widget			= wibox.container.background
	}
end


local function create_normal_item(text)
	return	wibox.widget{
		{
			{
				markup = text,
				id     = 'text',
				align  = 'center',
				valign = 'center',
				widget = wibox.widget.textbox
			},
			bottom          = dpi(3),
			widget			= wibox.container.margin
		},
		bg				= beautiful.run_bg,
		forced_height	= dpi(25),
		widget			= wibox.container.background
	}
end

local items = {}

-- not the fastest option but it doesn't require extra dependencies
awful.spawn.with_line_callback([[
    sh -c "IFS=':';for i in $PATH; do test -d "$i" && find "$i" -maxdepth 1 -executable -type f -exec basename {} \;; done"
]], {
    stdout = function(line)
        table.insert(items, line)
    end,
    stderr = function(line)
        -- Handle errors if necessary
        print("Error:", line)
    end,
})

local current_item = 1
local nr_lines = 13
local current_page = {
	s = 1,
	e = nr_lines
}
local items_layout = wibox.widget {
	layout = wibox.layout.fixed.vertical,
}
local function populate_list(list)
	items_layout:reset()
	if #list == 0 then
		return
	end
	local e = math.min(current_page.e,#list)
	local s = current_page.s

	if s > e then
		s = 1
		current_item = e
	end
	if current_item < s or current_item > e then
		current_item = s
	end
	for i=s,e do
		if i == current_item then
			items_layout:add(create_active_item(list[i]))
		else
			items_layout:add(create_normal_item(list[i]))
		end
	end
end

local amp = '&amp'..string.char(0x3B)
local quot = '&quot'..string.char(0x3B)
local matched_entries = {}
local prompt = awful.widget.prompt {
	-- prompt = '<span weight="bold">Run:</span> ',
	prompt = '',
	font = 'IBM Plex 10',
	-- bg = require('drawing.color').lighten(beautiful.colors.background,10),
	fg = beautiful.run_fg,
	fg_cursor = beautiful.run_fg_active,
	exe_callback = function(input)
		if matched_entries[current_item] ~= nil then
			awful.spawn.with_shell(matched_entries[current_item])
		else
			awful.spawn.with_shell(input)
		end
	end,
	done_callback = function()
		widget.visible = false
		current_page = {
			s = 1,
			e = nr_lines
		}
		current_item = 1
		populate_list(items)
	end,
	completion_callback = nil,
	changed_callback = function(command)
		matched_entries = {}
		for _,v in pairs(items) do
			if string.find(v, gears.string.query_to_pattern(command)) ~= nil  then
				table.insert(matched_entries,v)
			end
		end
		populate_list(matched_entries)
	end,

	-- Spawn method to spawn in the current tag
	keypressed_callback  = function(_,key, _) --luacheck: no unused args
		-- naughty.notify({text = tostring(current_item)})
		-- if key == 'Return' then
		-- 	awful.spawn(matched_entries[current_item])
		-- 	return
		-- end
		if key == "Up" then
			if current_item > 1 then
				current_item = current_item - 1
			end
			if current_item == current_page.s and current_page.s > 1 then
				current_page.s = current_page.s - 1
				current_page.e = current_page.e - 1
			end
			return true
		end
		if key == "Down" then
			if current_item < #items then
				current_item = current_item + 1
			end
			if current_item == current_page.e and current_page.e < #items then
				current_page.s = current_page.s + 1
				current_page.e = current_page.e + 1
			end
			return true
		end
	end,
	highlighter  = function(b, a)
		-- Add a random marker to delimitate the cursor
		local cmd = b..'ZZZCURSORZZZ'..a
		-- Find shell variables
		local sub = "<span foreground='#CFBA5D'>%1</span>"
		cmd = cmd:gsub('($[A-Za-z][a-zA-Z0-9]*)', sub)
		-- Highlight ' && '
		sub = "<span foreground='#159040'>%1</span>"
		cmd = cmd:gsub('( '..amp..amp..')', sub)
		-- Highlight double quotes
		local quote_pos = cmd:find('[^\\]'..quot)
		while quote_pos do
			local old_pos = quote_pos
			quote_pos = cmd:find('[^\\]'..quot, old_pos+2)
			if quote_pos then
				local content = cmd:sub(old_pos+1, quote_pos+6)
				cmd = table.concat({
						cmd:sub(1, old_pos),
						"<span foreground='#2977CF'>",
						content,
						'</span>',
						cmd:sub(quote_pos+7, #cmd)
								   }, '')
				quote_pos = cmd:find('[^\\]'..quot, old_pos+38)
			end
		end
		-- Split the string back to the original content
		-- (ignore the recursive and escaped ones)
		local pos = cmd:find('ZZZCURSORZZZ')
		b,a = cmd:sub(1, pos-1), cmd:sub(pos+12, #cmd)
		return b,a
	end
}
prompt.forced_height = dpi(30)

widget : setup {
	{
		{
			{
				layout = wibox.layout.fixed.vertical,
				prompt,
				items_layout,
			},
			color = beautiful.run_bg,
			margins = beautiful.innerBorder,
			widget = wibox.container.margin,
		},
		color = beautiful.active_inner_border_color,
		margins = beautiful.innerBorder,
		widget = wibox.container.margin,
	},
	color = beautiful.run_bg,
	margins = beautiful.outerBorder,
	widget = wibox.container.margin,
}


function M.run_prompt()
	populate_list(items)
	widget.screen =  awful.screen.focused()
	awful.placement.centered(widget)
	widget.visible = true
	prompt:run()
end

return M
