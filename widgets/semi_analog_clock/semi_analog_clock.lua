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
--
local beautiful = require("beautiful")
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
--
local widget = {}
widget.timer = nil
widget.timerState = true
widget.value = 0
--
function widget.analog_clock(args)
    args              = args              or {}
    -- 
    args.fg           = args.fg           or beautiful.fg_normal
    args.bg           = args.bg           or beautiful.bg_normal
    args.sectors      = args.sectors      or 12
    args.clockwise    = args.clockwise    or true
    -- --
    args.text = function(v, m , M)
        return os.date("%H:%M")
    end
    --
    local ac = flower_pbar(args)
    local w = wibox.widget({
            ac,
            id = "lay",
            layout = wibox.layout.fixed.horizontal
    })
    w:buttons(gears.table.join(
                  awful.button({ }, 1, function()
                          widget.timerState = not widget.timerState
                          if widget.timerState then
                              widget.timer:start()
                          else
                              widget.timer:stop()
                          end
                  end),
                  awful.button({ }, 3, function()
                          widget.timer:stop()
                          widget.timerState = false
                          widget.value = 0
                          ac:set_value(0)
                  end)
                  
    ))
    widget.timer = gears.timer({
            timeout   = .1,
            call_now  = true,
            autostart = true,
            callback  = function()
                -- local commande = "free |grep Mem"
                -- awful.spawn.easy_async_with_shell(commande, function(stdout)
                --                                       local total, used, free, shared, buff_cache, available
                --                                           = stdout:match('Mem:%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*')
                --                                       -- fu.montre((total-free)/total)
                --                                       -- ac:set_value((total - available)/total)
                --                                       widget.value = (widget.value + 1) % 101
                --                                       ac:set_value(widget.value / 100)
                -- local h = os.date("%H")
                -- local m = os.date("%M")
                local s = os.date("%S")
                -- w.value = (h + m/60 + s/3600) / 24
                ac:set_value(s/59)
            end
    })
    --
    return w
end

return setmetatable(widget, {__call=function(t, args)
                                 return widget.analog_clock(args)
                   end})
