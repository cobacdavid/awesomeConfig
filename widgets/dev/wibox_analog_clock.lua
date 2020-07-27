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
function widget.dev_analog_clock(args)
    args              = args              or {}
    -- local delay       = args.delay        or .1
    args.fg           = args.fg           or beautiful.fg_normal
    args.bg           = args.bg           or beautiful.bg_normal
    -- args.border_width = args.border_width or beautiful.border_width or 5
    args.screen       = args.screen       or screen[2] or screen[1]
    args.width        = args.width        or args.screen.geometry.width
    args.height       = args.height       or args.screen.geometry.height
    -- args.radius       = args.radius       or 200
    args.x            = args.x            or 0
    args.y            = args.y            or 0
    -- --
    -- args.align     = args.align           or "center"
    -- args.seg       = args.seg             or false
    -- args.seg_dark  = args.seg_dark        or .5
    -- --
    -- args.font      = args.font            or beautiful.font
    -- args.size      = args.size            or 350
    -- --
    -- args.hr_format = args.hr_format       or "%H:%M"
    -- args.fn_format = args.fn_format       or os.date
    --
    local w = wibox({
            screen  = args.screen,
            width   = args.width,
            height  = args.height,
            x       = args.x,
            y       = args.y,
            ontop   = true,
            visible = true,
            fg      = args.fg,
            bg      = args.bg
    })
    --
    local ac = analog_clock(args)
    w:setup({
            ac,
            id = "lay",
            layout = wibox.layout.align.horizontal
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
                  awful.button({ }, 2, function()
                          widget.timer:stop()
                          w.visible = false
                          w = nil
                  end),
                  awful.button({ }, 3, function()
                          widget.timer:stop()
                          widget.timerState = false
                          widget.value = 0
                          ac:set_value(0)
                  end)

    ))
    widget.timer = gears.timer({
            timeout   = .08,
            call_now  = true,
            autostart = true,
            callback  = function()
                local commande = "free |grep Mem"
                awful.spawn.easy_async_with_shell(commande, function(stdout)
                                                      local total, used, free, shared, buff_cache, available
                                                          = stdout:match('Mem:%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*')
                                                      -- fu.montre((total-free)/total)
                                                      -- ac:set_value((total - available)/total)
                                                      widget.value = (widget.value + 1) % 101
                                                      ac:set_value(widget.value / 100)
                end)
            end
    })
    --
    return w
end

return widget
