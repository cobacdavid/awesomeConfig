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
--

--
local function darkerColor(color, coef)
    local r, g, b, a = gears.color.parse_color(color)
    local R = math.floor(r * coef * 255)
    local G = math.floor(g * coef * 255)
    local B = math.floor(b * coef * 255)
    local A = math.floor(a * coef * 255)
    return string.format("#%02X%02X%02X%02X", R, G, B, A)
end
--
local function fondHuit(w, args)
    local huitMkup = "<span foreground='" .. darkerColor(args.fg, args.seg_dark)
        .. "' font_weight='normal' font='" .. args.font .. " " .. args.size .. "' >"
        .. "88:88" .. "</span>"
    w:set_markup(huitMkup)
end
--
local function heureText(w, args)
    args._hour     = args.fn_format(args.hr_format)
    --
    local heureMkup = "<span foreground='" .. args.fg
        .. "' font_weight='normal' font='" .. args.font .. " " .. args.size .. "' >"
        .. args._hour .. "</span>"
    --
    w:set_markup(heureMkup)
end
--
local function progressBar(w)
    local h = os.date("%H")
    local m = os.date("%M")
    local s = os.date("%S")
    -- w.value = (h + m/60 + s/3600) / 24
    w.value = s/60
end
--
function widget.bigClock(args)
    args              = args              or {}
    local delay       = args.delay        or .1
    args.fg           = args.fg           or beautiful.fg_normal
    args.bg           = args.bg           or beautiful.bg_normal
    args.border_width = args.border_width or beautiful.border_width or 5
    args.screen       = args.screen       or screen[2] or screen[1]
    args.width        = args.width        or args.screen.geometry.width
    args.height       = args.height       or args.screen.geometry.height
    args.radius       = args.radius       or 200
    --args.x            = args.x            or 0
    --args.y            = args.y            or 0
    --
    args.align     = args.align           or "center"
    args.seg       = args.seg             or false
    args.seg_dark  = args.seg_dark        or .5
    --
    args.font      = args.font            or beautiful.font
    args.size      = args.size            or 350
    --
    args.hr_format = args.hr_format       or "%H:%M"
    args.fn_format = args.fn_format       or os.date
    --
    --
    --
    local huit = wibox.widget({
            forced_width  = args.width,
            forced_height = args.height,
            align         = args.align,
            valign        = "center",
            widget        = wibox.widget.textbox
    })
    local disp =  wibox.widget({
            forced_width  = args.width,
            forced_height = args.height,
            align         = args.align,
            valign        = "center",
            widget        = wibox.widget.textbox
    })
    local stack = wibox.widget({
            huit,
            disp,
            layout = wibox.layout.stack
    })
    local rp = wibox.widget({
            stack,
            forced_width  = args.width,
            forced_height = args.height,
            border_width  = args.border_width,
            border_color  = args.bg,
            color         = args.fg,
            min_value     = 0,
            max_value     = 1,
            radius        = args.radius,
            widget        = wibox.container.radialprogressbar
    })
    --
    -- local w = wibox({
    --         screen  = args.screen,
    --         width   = args.width,
    --         height  = args.height,
    --         x       = args.x,
    --         y       = args.y,
    --         ontop   = true,
    --         visible = true,
    --         fg      = args.fg,
    --         bg      = args.bg
    -- })
    --
    --
    -- w:buttons(gears.table.join(
    --                    awful.button({ }, 1, function()
    --                            widget.timer:stop()
    --                            w.visible = false
    --                            w = nil
    --                    end)
    -- ))
    --
    --
    widget.timer = gears.timer ({
            timeout = delay,
            call_now = true,
            autostart = true,
            callback = function()
                if args.seg then
                    fondHuit(huit, args)
                end
                heureText(disp, args)
                progressBar(rp)
            end
    })
    return rp
end
--
return setmetatable(widget, {__call=function(t, args)
                                 return widget.bigClock(args)
                   end})
