-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
--
-------------------------------------------------
-- some parts from awesome wm 
-- distribution
-- copyright ??
-------------------------------------------------
local beautiful = require("beautiful")
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local os        = require("os")
--
local widget = {}
widget.timer = nil
--
-- default string output
local function outFormat(args)
   return "<span foreground='" .. args.fg
      .. "' font_weight='normal' font='" .. args.font .. " " .. args.size .. "' >"
      .. args._hour .. "</span>"
end
--
local function heurew_text(w, args)
   local args = args or {}
   --
   args.font      = args.font      or beautiful.widget_font_pri
   args.size      = args.size      or 20
   args.fg        = args.fg        or beautiful.widget_fg_pri
   args.bg        = args.bg        or beautiful.widget_bg
   args.hr_format = args.hr_format or "%H:%M.%S"
   args.fn_format = args.fn_format or os.date
   args.fn_out    = args.fn_out    or outFormat
   --
   args._hour = args.fn_format(args.hr_format)
   local hm   = args.fn_out(args)
   w.disp:set_markup(hm)
end

function widget.heure(args)
   local args  = args         or {}
   local delay = args.delay   or 1
   --
   local width         = args.width        or 150
   local justify       = args.justify      or "center"
   local bg            = args.bg           or beautiful.widget_bg
   local actionLeft    = args.actionLeft   or function() end
   local actionMiddle  = args.actionMiddle or function() end
   local actionRight   = args.actionRight  or function() end
   --
   local heurew = wibox.widget({
         {
            id = "disp",
            forced_width = width,
            align        = justify,
            widget       = wibox.widget.textbox
         },
         bg = bg,
         widget = wibox.container.background
   })
   --
   heurew:buttons(gears.table.join(
                     awful.button({ }, 1, actionLeft),
                     awful.button({ }, 2, actionMiddle),
                     awful.button({ }, 3, actionRight)
   ))
   --
   widget.timer = gears.timer ({
         timeout = delay,
         call_now = true,
         autostart = true,
         callback = function()
            heurew_text(heurew, args)
         end
   })
   return heurew
end
--
return setmetatable(widget, {__call=function(t, args)
                                return widget.heure(args)
                   end})
