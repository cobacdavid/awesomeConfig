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
local beautiful = require("beautiful")
local os = require("os")
os.setlocale("fr_FR.UTF-8")
--
local fu = require ("fonctionsUtiles")
--
local widget = {}

local function decorate(widget, flag, date)
   local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
   local weekday = tonumber(os.date('%w', os.time(d)))
   local default_bg = (flag=="normal" and (weekday==0  or weekday ==6) ) and '#232323' or '#383838'
   if (d.month == 6 and d.day == 25) then
       default_bg = beautiful.widget_bg
   end

   local ret = wibox.widget {
        {
            widget,
            margins = 2,
            widget  = wibox.container.margin
        },
        -- border_color = '#b9214f',
        -- border_width =  10,
        fg           = '#999999',
        bg           = default_bg,
        widget       = wibox.container.background
    }
    return ret
end

local cal = wibox.widget({
      date = os.date('*t'),
      fn_embed = decorate,
      font="Inconsolata",
      long_weekdays = true,
      widget = wibox.widget.calendar.year
})

function widget.createWidget(args)
   local args = args or {}
   local widget_calendrier = wibox({
         width=1170,
         height=670,
         ontop = true,
         screen = mouse.screen,
         visible=true,
         fg = beautiful.widget_fg_pri,
         bg = beautiful.widget_bg,
         -- border_width = 30,
         -- border_color = beautiful.rouge,
         shape = function(cr, width, height)
             gears.shape.rounded_rect(cr, width, height, 3)
         end,
   })
   --
   widget_calendrier:setup({
         cal,
         layout = wibox.layout.fixed.horizontal
   })
   --
   return widget_calendrier
end

function widget.afficheCalendrier(w)
   w.visible = true
   w:buttons(
      awful.util.table.join(
         awful.button({}, 1,
            function()
               w.visible = false
            end
         )
      )
   )
   --
end
--
return setmetatable(widget, {__call=function(args)
                                return widget.createWidget(args)
                   end})



