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
--
local widget = {}
widget.timer = nil
--

--
local function darkerColor(color)
   local r, g, b, a = gears.color.parse_color(color)
   local coef = .35
   local R = math.floor(r * coef * 255)
   local G = math.floor(g * coef * 255)
   local B = math.floor(b * coef * 255)
   local A = math.floor(a * coef * 255)
   return string.format("#%02X%02X%02X%02X", R, G, B, A)
end
--
local function fondHuit(w, args)
   local args = args or {}
    --
   args.font      = args.font      or beautiful.widget_font_pri
   args.size      = args.size      or 350
   args.fg        = args.fg        or beautiful.widget_fg_pri
   args.bg        = args.bg        or beautiful.widget_bg
   --
   local huitMkup = "<span foreground='" .. darkerColor(args.fg)
      .. "' font_weight='normal' font='" .. args.font .. " " .. args.size .. "' >"
      .. "88:88" .. "</span>"
   w:set_markup(huitMkup)
end
--
local function heureText(w, args)
   local args = args or {}
   --
   args.font      = args.font      or beautiful.widget_font_pri
   args.size      = args.size      or 350
   args.fg        = args.fg        or beautiful.widget_fg_pri
   args.bg        = args.bg        or beautiful.widget_bg
   args.hr_format = args.hr_format or "%H:%M"
   args.fn_format = args.fn_format or os.date
   --
   args._hour = args.fn_format(args.hr_format)
   --
   local heureMkup = "<span foreground='" .. args.fg
      .. "' font_weight='normal' font='" .. args.font .. " " .. args.size .. "' >"
      .. args._hour .. "</span>"
   w:set_markup(heureMkup)
end
--
local function progressBar(w)
   local h = os.date("%H")
   local m = os.date("%M")
   local s = os.date("%S")
   -- w.value = (h + m/60 + s/3600) / 24
   w.value = s/60
end
--
function widget.bigClock(args)
   local args   = args         or {}
   local delay  = args.delay   or .1
   args.fg        = args.fg        or beautiful.widget_fg_pri
   args.bg        = args.bg        or beautiful.widget_bg
   local s      = args.screen or screen[2]
   --
   --local width         = args.width        or 150
   local justify       = args.justify      or "center"
   local bg            = args.bg           or beautiful.widget_bg
   --
   local huit = wibox.widget({
          forced_width = s.geometry.width,
          align        = "center",
          widget       = wibox.widget.textbox
   })
   local disp =  wibox.widget({
         forced_width = s.geometry.width,
         align        = "center",
         widget       = wibox.widget.textbox
   })
   local stack = wibox.widget({
         huit,
         disp,
         layout = wibox.layout.stack
   })
   local rp = wibox.widget({
         stack,
         border_width = 30,
         border_color = args.bg,
         color = args.fg,
         min_value = 0,
         max_value = 1,
         -- radius = 200,
         widget = wibox.container.radialprogressbar 
   })
   --
   local widget = wibox({
         screen  = s,
         width   = s.geometry.width,
         height  = s.geometry.height,
         x       = 0,
         y       = 0,
         ontop   = true,
         visible = true,
         fg      = beautiful.fg_normal,
         bg      = beautiful.bg_normal
   })
   --
   widget:setup({
         rp,
         id = "lay",
         layout = wibox.layout.align.horizontal
   })
   --
   widget:buttons(gears.table.join(
                     awful.button({ }, 1, function()
                           widget.timer:stop()
                           widget.visible = false
                           widget = nil
                     end)
   ))
   
   --
   widget.timer = gears.timer ({
         timeout = delay,
         call_now = true,
         autostart = true,
         callback = function()
            fondHuit(huit, args)
            heureText(disp, args)
            progressBar(rp)
         end
   })
   return widget
end
--
return widget
