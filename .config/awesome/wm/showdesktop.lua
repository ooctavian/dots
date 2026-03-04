local show_desktop = false
local function show_desktop_func()
        if show_desktop then
            for _, c in ipairs(client.get()) do
                c:emit_signal(
                    "request::activate", "key.unminimize", {raise = true}
                )
            end
            show_desktop = false
        else
            for _, c in ipairs(client.get()) do
                c.minimized = true
            end
            show_desktop = true
        end
end
return show_desktop_func
