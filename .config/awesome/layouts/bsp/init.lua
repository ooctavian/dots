local awful      = require('awful')
local beautiful  = require('beautiful')
local gears      = require('gears')
local gcolor     = gears.color
local naughty    = require('naughty')
local capi       = {
    client       = client,
    tag          = tag,
    mouse        = mouse,
    screen       = screen,
    mousegrabber = mousegrabber
}
local bsp        = {}

bsp.name = "bsp"

local Bintree = require(... .. ".bintree")

local function debuginfo(message)
    if type(message) == "table" then
        for k,v in pairs(message) do
            naughty.notify({ text = "key: "..k.." value: "..tostring(v), timeout = 10 })
        end
    elseif type(message) == 'string' then
        nid = naughty.notify({ text = message, timeout = 10 })
    else
        nid = naughty.notify({ text = tostring(message), timeout = 10 })
    end
end

local trees = {}

local function hash(client)
    if client then
        return client.window
    else
        return nil
    end
end

function bsp.arrange(p)
    local area= p.workarea
    local i = 0
    local n = #p.clients
    for _, c in pairs(p.clients) do
            local g = {
                    x = i * (area.width / n),
                    y = area.y,
                    width = area.width / n,
                    height = area.height
            }
            p.geometries[c] = g
            i = i + 1
    end

    local tag = tostring(p.tag or capi.screen[p.screen].selected_tag
                        or awful.tag.selected(capi.mouse.screen))

    if not trees[tag] then
        trees[tag] = {
            t = nil,
            lastFocus = nil,
            clients = nil,
            geo_t = nil,
            geo = nil,
            n = 0
        }
    end
end

local icon_raw = gears.filesystem.get_configuration_dir() .. "/layouts/icons/bsp.png"

function bsp.get_icon()
        return gcolor.recolor_image(icon_raw, beautiful.fg_focus)
end


return bsp
