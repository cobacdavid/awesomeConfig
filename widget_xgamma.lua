-- local commande = "amixer get" .. sortie .. "|grep Left:|cut -d ' ' -f6"
-- local volumeactuel
-- awful.spawn.easy_async( commande ,
--      function(stdout,stderr,reason,exit_code)
-- 	volumeactuel = stdout
--      end
-- )
local MAX      = 100
local maxi     = 1.5
local MIN      = 0
local mini     = .5
--
-- le widget slider
   xgammaControle = wibox.widget {
   forced_width        = 100,
   bar_shape           = gears.shape.rounded_rect,
   bar_height          = 1,
   bar_color           = beautiful.border_color,
   handle_shape        = gears.shape.circle,
   handle_color        = couleurBarre(beautiful.widget_xgamma_handle_color_type, 100, MIN, MAX),
   minimum             = MIN,
   maximum             = MAX,
   widget              = wibox.widget.slider,
   value               = 50,
}
-- le widget texte
xgammaTexte = wibox.widget {
   text = "xgamma",
   align = "center",
   widget =wibox.widget.textbox
}
-- le widget à afficher
xgamma=wibox.widget {
   xgammaTexte,
   xgammaControle,
   vertical_offset=5,
   layout=wibox.layout.stack
}
--
xgammaControle:connect_signal("property::value", function()
      local v=tostring( mini + (xgammaControle.value * (maxi - mini ) / MAX ) )
      v = v:gsub(",",".")                              
      local command='xgamma -g ' .. v
      -- montre( command )
      awful.spawn(command)
      xgammaControle.handle_color = couleurBarre( beautiful.widget_xgamma_handle_color_type, v, MIN, MAX )
end)

-- double click
-- xgammaControle:connect_signal(" ", function()
--                                  awful.spawn( "xgamma -g 1" )
--                                  xgammaControle.value = 50
-- end)
