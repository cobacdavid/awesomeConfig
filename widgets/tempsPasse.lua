-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-------------------------------------------------
-- some parts from awesome wm 
-- ditribution
-- copyright ??
-------------------------------------------------
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local os = require("os")
local string = require("string")
--
local fu = require ("fonctionsUtiles")
--
local widget = {}

local function normaliseDuree(t)
   if t >= 3600 then
      h = t // 3600
      t = t % 3600
   else
      h = 0
   end
   --
   if t >= 60 then
      m = t // 60
      t = t % 60
   else
      m = 0
   end
   --
   s = t
   --
   h = string.format("%02d", h)
   m = string.format("%02d", m)
   s = string.format("%02d", s)
   return h .. "h " .. m .. "min " .. s .. "s"
end


local function actualiseTemps(w, t1, t2, args)
   local args = args or {}
   --   
   local font = args.font or beautiful.widget_font_pri
   local size = args.size or 8
   --
   t1 = normaliseDuree(math.floor(t1))
   t2 = normaliseDuree(math.floor(t2))
   w.texte:set_markup("<span font='" .. font .. " " .. size .. "'>".. tostring(t1) .. "\n" .. tostring(t2) .. "</span>")
end

function widget:createWidget(c, args)
   -- fu.montre(c)
   local args = args or {}
   local width = args.width or 100
   --
   local color = args.color or beautiful.widget_bg
   --
   local w = wibox.widget(
      {
         {
            id = 'texte',
            forced_width = width,
            align = "center",
            widget = wibox.widget.textbox
         },
         bg = color,
         widget =  wibox.container.background
      }
   )
   --
   c.heureFocus = nil
   c.tempsPasse = 0
   c.tempsDuFocus = 0
   c.timer = gears.timer(
      {
         timeout=1,
         autostart=false,
         call_now=false,
         callback=function()
            c.tempsDuFocus = os.difftime(os.time(), c.heureFocus)
            actualiseTemps(w,
                           c.tempsPasse + c.tempsDuFocus,
                           c.tempsDuFocus,
                           args)
         end,
         signe_shot=false
      }
   )
   --
   c:connect_signal("manage",
                    function()
                    end
   )
   c:connect_signal("focus",
                    function()
                       c.tempsPasse = c.tempsPasse + c.tempsDuFocus
                       c.heureFocus = os.time()
                       c.tempsDuFocus = 0
                       c.timer:start()
                    end
   )
   c:connect_signal("unfocus",
                    function()
                       c.timer:stop()
                    end
   )
   --
   return w
end

return setmetatable(widget, {
                       __call=function(c, client, args)
                          return widget:createWidget(client, args)
                       end}
)
