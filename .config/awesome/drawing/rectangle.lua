local wibox = require('wibox')
local rectangle = {mt = {}}

function rectangle:new(args)
  return {
    wibox.widget.base.make_widget(),
    bg     = args.color,
    id     = args.id,
    forced_width = args.width or nil,
    forced_height = args.height or nil,
    widget = wibox.container.background,
  }
end

return setmetatable(rectangle, rectangle.mt)
