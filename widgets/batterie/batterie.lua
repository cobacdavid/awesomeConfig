-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
local wibox     = require("wibox")
local gears     = require("gears")
local beautiful = require("beautiful")
--
local fu = require("fonctionsUtiles")
--
local widget = {}
--
local home = os.getenv("HOME") .. "/"
--
widget.delai = 5 * 60
widget.fichier = "/sys/class/power_supply/BAT0/capacity"
widget.logFile = home .. ".logBatterie"

-- if ordinateur == "maison" then
--    widget.delai = 5
--    widget.logFile = home .. "tmp/logBatterie"
-- end

function widget.batterie(args)
   local w = wibox({})
   w:setup({
         {
            id="text",
            widget = wibox.widget.textbox
         },
         id="conteneur",
         bg=beautiful.widget_bg,
         widget=wibox.container.background
   })
   --
   gears.timer({
         timeout=widget.delai,
         call_now=true,
         autostart=true,
         callback=function()
            local niveau = fu.readFile(widget.fichier)
            -- enlèvement saut à la ligne
            niveau = niveau:sub(1, -2)
            --
            -- niveau aléatoire pour tests
            -- if ordinateur == "maison" then
            --    niveau = tostring(math.floor(math.random() * 101))
            -- end
            local ligne = os.date("%Y%m%d-%H%M%S") .. " " .. niveau .. "\n"
            fu.appendFile(widget.logFile, ligne)
            w.conteneur.text:set_text(niveau .. "%")
         end
   })
   --
   return w.conteneur
end


return setmetatable(widget, {__call=function(_, args)
       return widget.batterie(args)
end})
