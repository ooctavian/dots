local gears = require('gears')
local M = {}

-- Rounds to whole number
local function round(num)
    return math.floor(num + 0.5)
end
-- Rounds to hundredths
local function roundH(num)
    return math.floor((num * 100) +0.5) / 100
end

local function Dec2Hex(nValue) -- http://www.indigorose.com/forums/threads/10192-Convert-Hexadecimal-to-Decimal
    if type(nValue) == "string" then
        nValue = String.ToNumber(nValue);
    end
    nHexVal = string.format("%X", nValue);  -- %X returns uppercase hex, %x gives lowercase letters
    sHexVal = nHexVal.."";
    if nValue < 16 then
        return "0"..tostring(sHexVal)
    else
        return sHexVal
    end
end

M.fade_RGB = function(color1, color2, percentage)
    r1, g1, b1 = gears.color.parse_color(color1)
    r2, g2, b2 = gears.color.parse_color(color2)
	local r3 = tonumber(r1, 16)*(100-percentage)/100.0 + tonumber(r2, 16)*(percentage)/100.0
	local g3 = tonumber(g1, 16)*(100-percentage)/100.0 + tonumber(g2, 16)*(percentage)/100.0
	local b3 = tonumber(b1, 16)*(100-percentage)/100.0 + tonumber(b2, 16)*(percentage)/100.0
    return "#"..Dec2Hex(r3).. Dec2Hex(g3)..Dec2Hex(b3)
end


function M.lighten(hex_color, amt)
    local r, g, b, a
    local hex = hex_color:gsub("#", "")
    if #hex < 6 then
        local t = {}
        for i = 1, #hex do
            local char = hex:sub(i, i)
            t[i] = char..char
        end
        hex = table.concat(t)
    end
    r = tonumber(hex:sub(1,2), 16)/255
    g = tonumber(hex:sub(3,4), 16)/255
    b = tonumber(hex:sub(5,6), 16)/255
    if #hex ~= 6 then
        a = roundH(tonumber(hex:sub(7,8), 16)/255)
    end

    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local c = max - min
    -----------------------------
    -- Hue
    local h
    if c == 0 then
        h = 0
    elseif max == r then
        h = ((g - b) / c)%6
    elseif max == g then
        h = ((b - r) / c)+2
    elseif max == b then
        h = ((r - g) / c)+4
    end
    h = h*60
    -----------------------------
    -- Luminance
    local l = (max + min) * 0.5
    -----------------------------
    -- Saturation
    local s
    if l <= 0.5 then
        s = c / (l*2)
    elseif l > 0.5 then
        s = c / (2 - (l*2))
    end
    -----------------------------
    local H, S, L, A
    H = round(h)/360
    S = round(s*100)/100
    L = round(l*100)/100

    amt = amt/100
    if L + amt > 1 then
        L = 1
    elseif L + amt < 0 then
        L = 0
    else
        L = L + amt
    end

    local R, G, B
    if S == 0 then
        R, G, B = round(L*255), round(L*255), round(L*255)
    else
        local function hue2rgb(p, q, t)
            if t < 0 then t = t + 1 end
            if t > 1 then t = t - 1 end
            if t < 1/6 then
                return p + (q - p) * (6 * t) end
            if t < 1/2 then
                return q end
            if t < 2/3 then
                return p + (q - p) * (2/3 - t) * 6 end
            return p
        end
        local q
        if L < 0.5 then
            q = L * (1 + S)
        else
            q = L + S - (L*S)
        end
        local p = 2 * L - q
        R = round(hue2rgb(p, q, (H + 1/3))*255)
        G = round(hue2rgb(p, q, H)*255)
        B = round(hue2rgb(p, q, (H - 1/3))*255)
    end

    if a ~= nil then
        A = round(a*255)
        return string.format("#"..'%.2x%.2x%.2x%.2x', R, G, B, A)
    else
        return string.format("#"..'%.2x%.2x%.2x', R, G, B)
    end
end

M.darken = function(hex_color, amt)
  return M.lighten(hex_color, -amt)
end

M.is_hex_light = function(hex_color)
    local r, g, b = gears.color.parse_color(hex_color)
    local brightness = ((r * 299) + (g * 587) + (b * 114)) / 1000
    return brightness > 155
end

return M
