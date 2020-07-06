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
os.setlocale("fr_FR.UTF-8")
--
local arrondiMoyen = function(cr, width, height)
   gears.shape.rounded_rect(cr, width, height, 5)
end
--
--
local widget = {}
widget.year = os.date('%Y')
--
local styles = {}
styles.year = {
   bg_color = beautiful.bg_normal
}
styles.focus = {
   fg_color = beautiful.fg_focus
}
styles.header = {
   bg_color =  beautiful.bg_normal,
   }
styles.month = {
   padding  = 5,
   bg_color = beautiful.bg_normal
}
styles.normal = {
   shape    = arrondiMoyen
}
styles.header = {
   fg_color = beautiful.fg_normal
}
styles.weekday = {
   fg_color = beautiful.fg_normal,
   markup   = function(t) return '<b>' .. t .. '</b>' end
}


local function decorate(widget, flag, date)
   if flag:sub(-6) == "header" then
      flag = "header"
   end
    -- référence à la variable contenant les styles
   local style = styles[flag]
   -- week-end en couleur différente
   -- attention weekday désigne aussi un flag (les textes des jours)
   local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}

   local weekday = tonumber(os.date('%w', os.time(d)))
   local default_bg = (flag == "normal" and (weekday == 0 or weekday == 6)) and beautiful.bg_urgent
      or beautiful.bg_systray
   local default_fg = (flag == "normal" and (weekday == 0 or weekday == 6)) and beautiful.fg_urgent
      or (date.month == tonumber(os.date("%m")) and date.day == tonumber(os.date("%d"))
             and flag == "focus") and beautiful.fg_focus
      or beautiful.fg_normal
   --
   if style.markup and widget.get_text and widget.set_markup then
      widget:set_markup(style['markup'](widget:get_text()))
   end
   --
   local ret = wibox.widget({
        {
            widget,
            margins = style.padding or 2,
            widget  = wibox.container.margin
        },
        shape        = style['shape'],
        -- border_width = style['border_width'] or beautiful.border_width,
        -- border_color = style['border_color'] or beautiful.border_color_normal,
        fg           = style['fg_color'] or default_fg,
        bg           = style.bg_color or default_bg,
        widget       = wibox.container.background
   })
    return ret
end

local function cal(year)
   local ladate = os.date('*t')
   ladate.year = year
   local w = wibox.widget({
         date     = ladate,
         fn_embed = decorate,
         font     = beautiful.calendar_font,
         widget   = wibox.widget.calendar.year
   })
   return w
end

function widget.createWidget(args)
   local args = args or {}
   local annee = args.year or 2020
   local widgetCalendrier = wibox({
         width   = 760,
         height  = 670,
         ontop   = true,
         screen  = mouse.screen,
         visible = true,
         fg      = beautiful.fg_normal,
         bg      = beautiful.bg_normal,
         shape   = function(cr, width, height)
             gears.shape.rounded_rect(cr, width, height, 3)
         end,
   })
   --
   widgetCalendrier:setup({
         cal(widget.year),
         layout = wibox.layout.fixed.horizontal
   })
   --
   widgetCalendrier:buttons(gears.table.join(
                awful.button({}, 2,
                   function()
                      widgetCalendrier.visible = false
                      -- destroy object
                      widgetCalendrier = nil
                      widget.year = os.date('%Y')
                      local enDessous = mouse.object_under_pointer()
                      if type(enDessous) == 'client' then
                         client.focus = enDessous
                         enDessous:emit_signal("focus")
                      end
                   end
                ),
                awful.button({}, 1,
                   function()
                      widgetCalendrier.visible = false
                      widgetCalendrier = nil
                      widget.year = math.floor(widget.year - 1)
                      widget.createWidget()
                   end
                ),
                awful.button({}, 3,
                   function()
                      widgetCalendrier.visible = false
                      widgetCalendrier = nil
                      widget.year = math.floor(widget.year + 1)
                      widget.createWidget()
                   end
                )
   ))
   --
   return widget_calendrier
end


return setmetatable(widget, {__call=function(args)
                                return widget.createWidget(args)
                   end})



