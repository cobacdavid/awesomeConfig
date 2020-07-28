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
local gears     = require("gears")
local awful     = require("awful")
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


local function decorate(w, flag, date)
    if flag:sub(-6) == "header" then
        flag = "header"
    end
    -- référence à la variable contenant les styles
    local style = styles[flag] or {}
    -- week-end en couleur différente
    -- attention weekday désigne aussi un flag (les textes des jours)
    local d = {year=date.year, month=(date.month or 1), day=(date.day or 1)}
    local weekday = tonumber(os.date('%w', os.time(d)))
    local shape
    --
    local bg = style.bg_color or beautiful.bg_systray
    local fg = style.fg_color or beautiful.fg_systray
    if flag == "normal" and (weekday == 0 or weekday == 6) then
        bg    = beautiful.bg_focus
        fg    = beautiful.fg_focus
        shape = arrondiMoyen
    end
    -- styles.focus ne semble pas fonctionner à l'affichage par
    -- défaut donc on le fait ici:
    if d.month == tonumber(os.date("%m"))
        and d.day == tonumber(os.date("%d"))
        and d.year == tonumber(os.date("%Y"))
    and (flag == "normal" or flag == "focus") then
        bg = beautiful.bg_urgent
        fg = beautiful.fg_urgent
        style.markup   = function(t) return '<b>' .. t .. '</b>' end
    end
    --
    style.markup = style.markup or function(t) return t end
    --
    if w.markup then
        w:set_markup(
            "<span font='" .. widget.font .. " " .. widget.font_size .. "'>"
                .. style.markup(w:get_text())
                .. "</span>"
        )
    end
    --
    local ret = wibox.widget({
            {
                w,
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

function widget.cal(args)
    args = args or {}
    widget.font      = args.font or beautiful.calendar_font or beautiful.font
    widget.font_size = args.font_size or beautiful.font_size
    local w = wibox.widget({
            date     = os.date("*t"),
            fn_embed = decorate,
            font     = widget.font,
            widget   = wibox.widget.calendar.month
    })
    return w
end

function widget.createWidget(args)
    args = args or {}
    local widgetCalendrier = wibox({
            width   = args.width,
            height  = args.height,
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
    local w = widget.cal()
    --
    widgetCalendrier:setup({
            w,
            layout = wibox.layout.fixed.horizontal
    })
    --
    -- widgetCalendrier:buttons(gears.table.join(
    --                              awful.button({}, 2,
    --                                  function()
    --                                      widgetCalendrier.visible = false
    --                                      -- destroy object
    --                                      widgetCalendrier = nil
    --                                      widget.year = os.date('%Y')
    --                                      local enDessous = mouse.object_under_pointer()
    --                                      if type(enDessous) == 'client' then
    --                                          client.focus = enDessous
    --                                          enDessous:emit_signal("focus")
    --                                      end
    --                                  end
    --                              ),
    --                              awful.button({}, 1,
    --                                  function()
    --                                      widgetCalendrier.visible = false
    --                                      widgetCalendrier = nil
    --                                      widget.year = math.floor(widget.year - 1)
    --                                      widget.createWidget()
    --                                  end
    --                              ),
    --                              awful.button({}, 3,
    --                                  function()
    --                                      widgetCalendrier.visible = false
    --                                      widgetCalendrier = nil
    --                                      widget.year = math.floor(widget.year + 1)
    --                                      widget.createWidget()
    --                                  end
    --                              )
    -- ))
    --
    return widgetCalendrier
end
--
return widget
-- return setmetatable(widget, {__call=function(args)
--                                 return widget.createWidget(args)
--                   end})



