local beautiful = require("beautiful")
local wibox     = require("wibox")
--
local widget = {}

function widget.separateur(args)
    args = args or {}
    -- args.bg = args.bg or beautiful.bg_normal
    args.width = args.width or 5
    --
    local separateur = wibox.widget({
            {
                forced_width = args.width,
                widget = wibox.widget.separator
            },
            widget = wibox.container.background
    })
    return separateur
end

return setmetatable(widget, {__call=function(_, args)
                                 return widget.separateur(args)
                   end})
