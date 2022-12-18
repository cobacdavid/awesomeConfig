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
-- default string output
local function outFormat(args, aAfficher)
    return "<span foreground='" .. args.fg
        .. "' font_weight='normal' font='" .. args.font .. " " .. args.size .. "' >"
        .. aAfficher .. "</span>"
end
--
local function datew_text(w, args)
    args           = args           or {}
    --
    args.font      = args.font      or beautiful.font
    args.size      = args.size      or 10
    args.fg        = args.fg        or beautiful.fg_normal
    args.bg        = args.bg        or beautiful.bg_normal
    --
    args._dated = os.date("%d")
    args._datem = os.date("%b")
    w.disp:set_markup(outFormat(args, args._dated))
    w.disp2:set_markup(outFormat(args, args._datem))
end

function widget.date(args)
    if args == nil then
        return wibox.container.background
    end
    
    args                = args              or {}
    local delay         = args.delay        or 1
    --
    local width         = args.width        or 150
    local justify       = args.justify      or "center"
    local bg            = args.bg           or beautiful.bg_normal
    local fg            = args.fg           or beautiful.fg_normal
    local actionLeft    = args.actionLeft   or function() end
    local actionMiddle  = args.actionMiddle or function() end
    local actionRight   = args.actionRight  or function() end
    --
    local datew = wibox.widget({
            {
                id = "disp",
                forced_width = width,
                align        = justify,
                widget       = wibox.widget.textbox
            },
            {
                id = "disp2",
                forced_width = width,
                align        = justify,
                widget       = wibox.widget.textbox
            },
            layout = wibox.layout.align.vertical,
            -- bg = bg,
            -- widget = wibox.container.background
    })
    --
    datew:buttons(gears.table.join(
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
                awful.spawn.easy_async(COMMAND,
                                       function(stdout)
                                           datew_text(datew, args)
                                       end
                )
            end
    })
    return datew
end
--
return setmetatable(widget, {__call=function(_, args)
                                 return widget.date(args)
                   end})
