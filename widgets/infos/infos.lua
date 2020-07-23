-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
--
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")
--
--
local widget = {}
--
-- add or comment commands below
widget.commands = {
    "xrandr |egrep -o 'current [0-9]+ x [0-9]+'|cut -d ' ' -f 2-4", -- config Ecrans
    "hostname -I|cut -d ' ' -f1", -- mon IP réseau
    "wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\\< -f 1", -- mon IP Internet
    "echo $(uname -v |cut -d ' ' -f4)", -- version Linux
    "cat /etc/debian_version", -- version Distrib
    "ansiweather -l angers,fr|cut -d ' ' -f 6-7", -- température ext.
    "sensors |grep Package|cut -d ' ' -f 5-6" --température proc
}
--
--
widget.indiceInfos = 0
--
local function appliqueCommande(w, args)
    args         = args         or {}
    args.sameCmd = args.sameCmd or false
    args.markup  = args.markup or function(t) return t end
    -- args.fg      = args.fg      or beautiful.fg_normal
    --
    if not args.sameCmd then
        widget.indiceInfos =  1 + widget.indiceInfos % #widget.commands
    end
    --
    local c = widget.commands[widget.indiceInfos]
    awful.spawn.easy_async_with_shell(c, function(stdout, stderr, reason, exit_code)
                                          local lt = string.len(stdout)
                                          local texte = stdout:sub(1, lt-1)
                                          w.texte:set_markup(args.markup(texte))
    end)
end
--
function widget.infos(args)
    args        = args       or {}
    args.width = args.width or 150
    args.font  = args.font  or beautiful.font
    --
    local infos = wibox.widget({
            {
                id           = "texte",
                widget       = wibox.widget.textbox,
                visible      = true,
                align        = "center",
                font         = args.font,
                forced_width = args.width
            },
            widget = wibox.container.background
    })
    --
    infos:buttons(
        gears.table.join(
            awful.button({}, 1,
                function()
                    appliqueCommande(infos)
                end
            ),
            awful.button({}, 3,
                function()
                    appliqueCommande(infos, {sameCmd = true})
                end
            )
        )
    )
    --
    appliqueCommande(infos)
    return infos
end

return setmetatable(widget, {__call=function(_, args)
                                 return widget.infos(args)
                   end})
