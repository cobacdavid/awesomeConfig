local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
--
local widget = {}

local function heurew_text(w, args)
   local args = args or {}
   --
   local font = args.font or beautiful.widget_font_pri
   local size = args.size or 20
   local fg = args.fg or beautiful.widget_fg_pri
   local bg = args.bg or beautiful.widget_bg
   local format = args.format or "%H:%M.%S"
   --
   local heure = os.date(format)
   local couleur = fg
   if tonumber(os.date("%H")) >= 19 then
      couleur = fg
   end
   local hm = "<span foreground='" .. couleur .. "' font_weight='normal' font='" 
      .. font .. " " .. size .. "' >" .. heure .. "</span>"
   w:set_markup(hm)
end

function widget.heure(args)
   local args    = args         or {}
   local delay   = args.delay   or 1
   --
   local width   = args.width   or 150
   local justify = args.justify or "center"
   local action  = args.action  or function() end
   --
   local heurew = wibox.widget {
      forced_width = width,
      align = justify,
      widget = wibox.widget.textbox
   }
   --
   heurew:buttons(gears.table.join(awful.button({ }, 1, action)))
   --
   gears.timer ({
         timeout = delay,
         call_now = true,
         autostart = true,
         callback = function()
            heurew_text(heurew, args)
         end
   })
   return heurew
end

return setmetatable(widget, {__call=function(t, args)
                                return widget.heure(args)
                   end})
