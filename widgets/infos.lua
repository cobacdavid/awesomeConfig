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
--
local wibox = require("wibox")
--
local fu = require("fonctionsUtiles")
--
local widget = {}

widget.commandes = {
   "xrandr |egrep -o 'current [0-9]+ x [0-9]+'|cut -d ' ' -f 2-4", -- configEcrans
   "hostname -I|cut -d ' ' -f1", -- monIP
   "wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\\< -f 1", -- monIPInternet
   "echo $(uname -v |cut -d ' ' -f4)", -- versionLinux
   "cat /etc/debian_version", -- versionDistrib
   "ansiweather -l angers,fr|cut -d ' ' -f 6-7", -- température ext.
   "sensors |grep Package|cut -d ' ' -f 5-6" --température proc
}
--
widget.indiceInfos = -1

local function appliqueCommande(t)
   setmetatable(t, {__index={sameCmd=false}})
   --
   local w, sameCmd = t[1], t[2] or t.sameCmd 
   --
   if not sameCmd then
      widget.indiceInfos = (widget.indiceInfos+1) % #widget.commandes
   end 
   local c = widget.commandes[1+widget.indiceInfos]
   awful.spawn.easy_async_with_shell(c, function(stdout, stderr, reason, exit_code)
                                        local lt = string.len(stdout)
                                        texte = stdout:sub(1, lt-1)
                                        w.markup = "<span foreground='"
                                           .. beautiful.widget_fg_sec
                                           .. "' size='large'>"
                                           .. texte ..
                                           "</span>"
                                        end)
end

function widget.infos(args)
   local args = args or {}
   --
   local infos = wibox.widget(
      {
         -- text = "Infos",
         widget = wibox.widget.textbox,
         visible = true,
         align = "center",
         forced_width = 150
      }
   )

   infos:buttons(
      gears.table.join(
         awful.button({}, 1,
            function()
               appliqueCommande({infos})
            end
         ),
         awful.button({}, 3,
            function()
               appliqueCommande({infos, true})
            end
         )
      )
   )
   --
   appliqueCommande({infos})
   return infos
end


return setmetatable(widget, {__call=function(t, args)
                                return widget.infos(args)
                   end})
