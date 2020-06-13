local awful = require("awful")
local wibox = require("wibox")
local math = require("math")
local io = require("io")
local os = require("os")
local gears = require("gears")
local fu = require("fonctionsUtiles")
--
local widget = {}

widget.delai = 15 * 60
widget.fichier = "/sys/class/power_supply/BAT0/capacity"
widget.logFile = "/home/david/temp/logBatterie"

if ordinateur == "maison" then
   widget.delai = 5
   widget.logFile = "/home/david/tmp/logBatterie"
end

function widget.batterie(args)
   local w = wibox.widget.textbox()
   --
   gears.timer({
         timeout=widget.delai,
         call_now=true,
         autostart=true,
         callback=function()
            local niveau = fu.readResult(widget.fichier)
            if ordinateur == "maison" then
               niveau = tostring(math.floor(math.random() * 101))
            end
            local fH = io.open(widget.logFile, "a")
            fH:write(os.date("%Y%m%d-%H%M%S") .. " " .. niveau .. "\n")
            fH:close()
            w:set_text(niveau .. "%")
         end
   })

   return w
end



return setmetatable(widget, {__call=function(t, args)
       return widget.batterie(args)
end})
