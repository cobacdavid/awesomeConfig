-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
--
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
--
local fu = require("fonctionsUtiles")
--
local widget = {}

-- local commande = "amixer get" .. sortie .. "|grep Left:|cut -d ' ' -f6"
-- local volumeactuel
-- awful.spawn.easy_async( commande ,
--      function(stdout,stderr,reason,exit_code)
-- 	volumeactuel = stdout
--      end
-- )
--

function widget.sliderBrightnessWidget(args)
   local args = args or {iface="HDMI-0"}
   --
   local MAX      = 100
   local maxi     = 2
   local MIN      = 0
   local mini     = .5
   --
   -- valeur de départ
   local vDepart  = args.startLevel or 1
   -- le widget slider
   local sliderBrightnessControle = wibox.widget {
      forced_width        = 100,
      bar_shape           = gears.shape.rounded_rect,
      bar_height          = 1,
      bar_color           = beautiful.border_color,
      handle_shape        = gears.shape.circle,
      handle_color        = fu.couleurBarre(beautiful.widget_sliderBrightness_handle_color_type, 100, MIN, MAX),
      minimum             = MIN,
      maximum             = MAX,
      widget              = wibox.widget.slider,
   }
   -- le widget texte
   local sliderBrightnessTexte = wibox.widget(
      {
         markup = "<span foreground='white'>" .. args.iface .. "</span>",
         align = "center",
         widget = wibox.widget.textbox
      }
   )
   -- le widget à afficher
   local sliderBrightness=wibox.widget(
      {
         sliderBrightnessTexte,
         sliderBrightnessControle,
         vertical_offset = 0,
         layout = wibox.layout.stack
      }
   )
   -- la gestion de la commande
   sliderBrightnessControle:connect_signal("property::value", function()
         local v = tostring(mini + (sliderBrightnessControle.value * (maxi - mini) / MAX))
         v = v:gsub(",",".")                              
         local command="xrandr --output " .. args.iface .." --brightness " .. v
         -- fu.montre(command)
         fu.commande_execute(command)
         -- awful.spawn(command)
         sliderBrightnessControle.handle_color = fu.couleurBarre(beautiful.widget_sliderBrightness_handle_color_type, v, mini, maxi)
   end)
   sliderBrightnessTexte:connect_signal("button::press", function()
         sliderBrightnessControle.value = math.floor((1 - mini) *100 / (maxi - mini))
   end)
   --
   -- on applique la valeur de départ
   sliderBrightnessControle.value = math.floor((vDepart - mini) *100 / (maxi - mini))
   --
   --
   return sliderBrightness
end

return setmetatable(widget, {__call=function(t, args)
                                return widget.sliderBrightnessWidget(args)
                   end})
