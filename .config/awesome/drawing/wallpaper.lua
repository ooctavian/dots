local cairo = require('lgi').cairo
local gears = require('gears')

local wallpaper = {}

wallpaper.createHorizontalStripes = function(s,length,col1,col2)
        local height = s.geometry.height
        local width = s.geometry.width

        local img = cairo.ImageSurface(cairo.Format.RGB24, width,height)
        local cr = cairo.Context(img)
        cr:set_source(gears.color(col1))
        cr:paint()

        cr:set_source(gears.color(col2))
        local x = 0
        while x < width do
            cr:rectangle(x,0,length,height)
            x = x + 2*length
        end
        cr:fill()
        return img
end

wallpaper.createHorizontalAndVerticalStripes = function(s,length,col1,col2)
        local height = s.geometry.height
        local width = s.geometry.width

        local img = cairo.ImageSurface(cairo.Format.RGB24, width,height)
        local cr = cairo.Context(img)
        cr:set_source(gears.color(col2))
        cr:paint()

        cr:set_source(gears.color(col1))
        local x = 0
        while x < width do
            cr:rectangle(x,0,length,height)
            x = x + 3*length
        end

        x = 0
        while x < height do
            cr:rectangle(0,x,width,length)
            x = x + 3*length
        end

        cr:fill()
        return img
end



return wallpaper
