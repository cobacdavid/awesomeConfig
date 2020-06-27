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
-- 
os.setlocale(malocale)
--
local fu = require ("fonctionsUtiles")
--
local widget = {}

local styles = {}
styles.month   = {
   padding      = 5,
   bg_color     = beautiful.widget_bg,
   shape        = fu.parrondiGros
}

styles.normal  = {
   bg_color = beautiful.widget_bg,
   shape    = fu.arrondiPetit
}

styles.header  = {
   fg_color     = beautiful.widget_fg_pri,
}

styles.weekday = {
   fg_color = beautiful.widget_fg_sec,
   markup   = function(t) return '<b>' .. t .. '</b>' end,
   --shape    = fu.arrondiMoyen
}

local function decorate(widget, flag, date)
   -- if flag == 'monthheader' then
   --    flag = "header"
   -- end
   -- référence à la variable contenant les styles
   local style = styles[flag] or {}
   -- week-end en couleur différente
   -- attention weekday désigne aussi un flag (les textes des jours)
   local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
   local weekday = tonumber(os.date('%w', os.time(d)))
   local default_bg = (flag == "normal" and (weekday == 0  or weekday == 6) ) and '#232323' or beautiful.noir
   -- application du texte
   if style['markup'] and widget.get_text and widget.set_markup then
      widget:set_markup(style['markup'](widget:get_text()))
   end
   local ret = wibox.widget {
        {
            widget,
            margins = style['padding'] or 2,
            widget  = wibox.container.margin
        },
        -- border_color = '#b9214f',
        -- border_width =  10,
        shape        = style['shape'],
        border_width = style['border_width'] or 0,
        border_color = style['border_color'] or beautiful.widget_bg,
        fg           = (date.month == tonumber(os.date("%m")) and date.day == tonumber(os.date("%d"))
                           and flag == "focus") and '#ff0000'
                           or style['fg_color'] or '#999999',
        bg           = style['bg_color'] or default_bg,
        widget       = wibox.container.background
    }
    return ret
end

local cal = wibox.widget({
      date = os.date('*t'),
      fn_embed = decorate,
      font="Inconsolata",
      -- long_weekdays = true,
      widget = wibox.widget.calendar.year
})

function widget.createWidget(args)
   local args = args or {}
   local widget_calendrier = wibox({
         width=760,
         height=670,
         ontop = true,
         screen = mouse.screen,
         visible=true,
         fg = beautiful.widget_fg_pri,
         bg = "#000000EE", --beautiful.widget_bg,
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
   -- w.visible = true
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



