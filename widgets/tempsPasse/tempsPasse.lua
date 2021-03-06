-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-------------------------------------------------
-- some parts from awesome wm
-- distribution
-- copyright ??
-------------------------------------------------
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
--
local ordinateur = ordinateur
local widget = {}
--
local myhome = os.getenv('HOME') .. "/"
if ordinateur == "desktop" or ordinateur == "desktop2" then
    widget.logFile = myhome .. ".config/awesome/widgets/logFenetreTempsPasse"
else
    widget.logFile = myhome .. "temp/logFenetreTempsPasse"
end
--
local function appendFile(fileName, line)
    local fH= io.open(fileName, "a")
    fH:write(line)
    fH:close()
end
--
local function normaliseDuree(t)
    local h, m = 0, 0
    --
    if t >= 3600 then
        h = t // 3600
        t = t % 3600
    else
        h = 0
    end
    --
    if t >= 60 then
        m = t // 60
        t = t % 60
    else
        m = 0
    end
    --
    h = string.format("%02d", h)
    m = string.format("%02d", m)
    local s = string.format("%02d", t)
    return h .. "h " .. m .. "min " .. s .. "s"
end


local function actualiseTemps(w, t1, t2, font, size)
    t1 = normaliseDuree(math.floor(t1))
    t2 = normaliseDuree(math.floor(t2))
    w:set_markup("<span font='" .. font .. " " .. size .. "'>"
                     .. tostring(t1) .. "\n" .. tostring(t2)
                     .. "</span>")
end

function widget.createWidget(c, args)
    --
    args = args or {}
    args.width   = args.width   or 100
    args.font    = args.font    or beautiful.font
    args.size    = args.size    or (beautiful.font_size // 2) or 6
    args.logFile = args.logFile or widget.logFile
    --
    -- args.bg = args.bg or beautiful.bg_normal
    -- args.fg = args.fg or beautiful.fg_normal
    --
    local w = wibox.widget({
            {
                id           = 'texte',
                forced_width = args.width,
                align        = "center",
                widget       = wibox.widget.textbox,
            },
            -- bg = args.bg,
            widget = wibox.container.background
    })
    --
    local tt = awful.tooltip({})
    tt:add_to_object(w)
    w:connect_signal("mouse::enter", function()
                         tt.text = "total/current"
    end)
    --
    --
    c.heureFocus = nil
    c.tempsPasse = 0
    c.tempsDuFocus = 0
    c.timer = gears.timer({
            timeout = 1,
            autostart = false,
            call_now = false,
            callback=function()
                c.tempsDuFocus = os.difftime(os.time(), c.heureFocus)
                actualiseTemps(w.texte,
                               c.tempsPasse + c.tempsDuFocus,
                               c.tempsDuFocus,
                               args.font,
                               args.size)
            end,
            signe_shot=false
    })
    --
    c:connect_signal("unmanage",
                     function(cli)
                         cli.timer:stop()
                         local classe = c.class or "Inconnu"
                         local t = math.floor(cli.tempsPasse + cli.tempsDuFocus)
                         local ligne = os.date("%Y%m%d-%H%M%S")
                             .. "," .. classe .. ","
                             .. tostring(t)
                             .. "\n"
                         appendFile(args.logFile, ligne)
                     end
    )
    c:connect_signal("focus",
                     function(cli)
                         cli.tempsPasse = cli.tempsPasse + cli.tempsDuFocus
                         cli.heureFocus = os.time()
                         cli.tempsDuFocus = 0
                         cli.timer:start()
                     end
    )
    c:connect_signal("unfocus",
                     function(cli)
                         cli.timer:stop()
                     end
    )
    --
    return w
end
--
return setmetatable(widget, {
                        __call=function(_, client, args)
                            return widget.createWidget(client, args)
                            end}
)
