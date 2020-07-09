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
local wibox     = require("wibox")
local beautiful = require("beautiful")
local os        = require("os")
--
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
-- styles.focus = {
--    bg_color = beautiful.bg_focus,
--    fg_color = beautiful.fg_focus
-- }
styles.header = {
   bg_color =  beautiful.bg_normal,
   }
styles.month = {
   padding  = 5,
   bg_color = beautiful.bg_normal
}
-- styles.normal = {
--    shape    = arrondiMoyen
-- }
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
   local style = styles[flag] or {}
   -- week-end en couleur différente
   -- attention weekday désigne aussi un flag (les textes des jours)
   local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
   local weekday = tonumber(os.date('%w', os.time(d)))
   --
   local bg = style.bg_color or beautiful.bg_systray
   local fg = style.fg_color or beautiful.fg_systray
   if flag == "normal" and (weekday == 0 or weekday == 6) then
      bg    = beautiful.bg_urgent
      fg    = beautiful.fg_urgent
      shape = arrondiMoyen
   end
      -- styles.focus ne semble pas fonctionner à l'affichage par
      -- défaut donc on le fait ici:
   if d.month == tonumber(os.date("%m"))
      and d.day == tonumber(os.date("%d"))
      and d.year == tonumber(os.date("%Y"))
      and (flag == "normal" or flag == "focus") then
         bg = beautiful.bg_focus
         fg = beautiful.fg_focus
         style.markup   = function(t) return '<b>' .. t .. '</b>' end
   end
   --
   if style.markup and widget.get_text and widget.set_markup then
       widget:set_markup(style.markup(widget:get_text()))
   end
   --
   local ret = wibox.widget({
        {
            widget,
            margins = style.padding or 2,
            widget  = wibox.container.margin
        },
        shape        = style.shape or shape,
        fg           = fg,
        bg           = bg,
        widget       = wibox.container.background
   })
    return ret
end

local function cal()
   local w = wibox.widget({
         date     = {year=widget.year},
         fn_embed = decorate,
         font     = beautiful.calendar_font,
         widget   = wibox.widget.calendar.year
   })
   return w
end

function widget.createWidget(args)
   local args = args or {}
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
         cal(),
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
--
return setmetatable(widget, {__call=function(args)
                                return widget.createWidget(args)
                   end})



