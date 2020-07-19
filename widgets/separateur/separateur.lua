local beautiful = require("beautiful")
local wibox = require("wibox")
--
local widget = {}

function widget.separateur(args)
    args = args or {}
    --
    local color = args.color or beautiful.widget_bg
    local separateur = wibox.widget({
            {
                forced_width = args.width or 5,
                color = color,
                widget = wibox.widget.separator
            },
            -- bg = color,
            widget = wibox.container.background
    })
    return separateur
end

return setmetatable(widget, {__call=function(_, args)
                                 return widget.separateur(args)
                   end})
