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
local os = require("os")
local string = require("string")
local gears = require("gears")
--
widget               = {}
widget._timer        = nil
widget._timerStatus  = false
widget._etime        = 0
widget._laptime      = 0
widget._start        = 0
widget._boolClignote = false
--
local function normaliseDuree(t)
   local h, m, s = 0, 0, 0
   local t = t
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
   --
   if h == "00" and m == "00" then
      return  s .. "s"
   elseif h == "00" then
       return m .. "min " .. s .. "s"
   else
      return h .. "h " .. m .. "min " .. s .. "s"
   end
end
--
local function actualise(w, duree)
   local duree = normaliseDuree(math.floor(duree))
   w.texte:set_text(duree)
end
--
function widget.createWidget(args)
   local args = args or {}
   --
   local w = wibox.widget({
            {
               id     = "texte",
               align  = "center",
               fg     = beautiful.fg_normal,
               text   = "⏱",
               widget = wibox.widget.textbox
            },
            bg = beautiful.bg_normal,
            widget = wibox.container.background
   })

   --
   widget._timer = gears.timer({
         autostart = false,
         timeout   = 1,
         callback  = function()
            widget._laptime = os.difftime(os.time(), widget._start)
            actualise(w, widget._laptime + widget._etime)
         end
   })
   --
   widget._clignote = gears.timer({
         autostart = false,
         timeout   = .2,
         callback  = function()
            widget._boolClignote = not widget._boolClignote
            w.bg = widget._boolClignote and  beautiful.bg_focus or beautiful.bg_normal
            --            w:emit_signal("widget::redraw_needed")
         end
   })
   --
   w:buttons(gears.table.join(
                awful.button({ }, 1, function()
                      widget._timerStatus = not widget._timerStatus
                      if widget._timerStatus then
                         w.bg = beautiful.bg_normal
                         widget._timer:start()
                         widget._start = os.time()
                         widget._etime = widget._etime + widget._laptime
                         widget._clignote:stop()
                      else
                         widget._timer:stop()
                         widget._clignote:start()
                      end
                end),
                awful.button({ }, 2, function()
                      widget._timerStatus = false
                      widget._clignote:stop()
                      widget._timer:stop()
                      widget._etime = 0
                      widget._laptime = 0
                      w.bg = beautiful.bg_normal
                      w.texte:set_text("⏱")
                end),
                awful.button({ }, 3, function()
                      w.bg = beautiful.bg_normal
                      widget._start = os.time()
                      widget._etime = 0
                      widget._laptime = 0
                      w.bg = beautiful.bg_normal
                      actualise(w, 0)
                end)
   ))
   --
   return w
end
--
return setmetatable(widget, {__call=function(t, args)
                                return widget.createWidget(args)
                   end})
