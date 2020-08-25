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
    args       = args       or {}
    args.delay = args.delay or .1   
    -- --
    local s = flower_pbar({
            sectors = 59,
            text    = function() return "" end,
            outer_radius = 90,
            inner_radius = 55,
            clockwise = true
    })
    
    local m = flower_pbar({
            sectors = 59,
            text    = function() return "" end,
            outer_radius = 60,
            inner_radius = 25,
            clockwise = true
    })

    local h = flower_pbar({
            sectors = 11,
            text    = function() return os.date("%H:%M") end,
            font   = "Northwood High",--"HP15C Simulator Font",
            font_size = 80,
            fg = "#fff9",
            outer_radius = 30,
            inner_radius = 0,
            clockwise = true
    })
    
    local w = wibox.widget({
            {
                s, m, h,
                layout = wibox.layout.stack
            },
            id = "lay",
            layout = wibox.layout.fixed.horizontal
    })

    widget.timer = gears.timer({
            timeout   = args.delay,
            call_now  = true,
            autostart = true,
            callback  = function()
                local heu = os.date("%H")
                local min = os.date("%M")
                local sec = os.date("%S")
                -- w.value = (h + m/60 + s/3600) / 24
                s:set_value(sec/59)
                m:set_value(min/59 + sec/(59*59))
                h:set_value(heu/23 + min/(59*23) + sec/(59*59*23))
            end
    })
    --
    return w
end

return setmetatable(widget, {__call=function(t, args)
                                 return widget.analog_clock(args)
                   end})
