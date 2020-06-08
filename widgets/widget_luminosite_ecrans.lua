-- local commande = "amixer get" .. sortie .. "|grep Left:|cut -d ' ' -f6"
-- local volumeactuel
-- awful.spawn.easy_async( commande ,
--      function(stdout,stderr,reason,exit_code)
-- 	volumeactuel = stdout
--      end
-- )
--

function sliderBrightnessWidget(ecran)
   local MAX      = 100
   local maxi     = 2
   local MIN      = 0
   local mini     = .5
   --
   -- valeur de départ
   local vDepart  = 1
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
         markup = "<span foreground='white'>" .. ecran .. "</span>",
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
         local command="xrandr --output " .. ecran .." --brightness " .. v
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
