local sortie = " Master "
-- commande qui fonctionnait avec Left : Right (amixer <=1.1.6)
local commande = "amixer get" .. sortie .. "|grep Left:|cut -d ' ' -f6"
-- local commande = "amixer get" .. sortie .. "|grep Mono:|cut -d ' ' -f5"
local volumeactuel
-- amixer <=1.1.6
-- local MAX = 65536
local commandeMax = "amixer get" .. sortie .. "|grep Limits|cut -d ' ' -f7"
local MIN = 0
--
local fh = io.popen( commandeMax )
local MAX = fh:read( "*a" )
MAX = tonumber( MAX )
fh:close()
-- 
-- le widget slider
volumemasterControle = wibox.widget {
   forced_width        = 100,
   bar_shape           = gears.shape.rounded_rect,
   bar_height          = 0,
   bar_color           = beautiful.border_color,
   -- handle_shape        = gears.shape.circle,
   handle_shape        = function(cr, w, h)
         gears.shape.circle (cr, w, h, 5)
   end,
   handle_color        = couleurBarre(beautiful.widget_volumemaster_handle_color_type, volumeactuel, MIN, MAX),
   minimum             = MIN,
   maximum             = MAX,
   widget              = wibox.widget.slider,
--   value               = volumeactuel,
}
-- le widget texte
volumemasterTexte = wibox.widget {
   text = "master",
   align = "center", 
   widget =wibox.widget.textbox
}
-- le widget à afficher
volumemaster=wibox.widget {
   volumemasterTexte,
   volumemasterControle,
   vertical_offset=5,
   layout=wibox.layout.stack
}

--
volumemasterControle:connect_signal("property::value", function()
      local v=volumemasterControle.value
      local command='amixer set' .. sortie  .. v
      awful.spawn(command)
      volumemasterControle.handle_color = couleurBarre( beautiful.widget_volumemaster_handle_color_type, v, MIN, MAX )
end)
--
volumemasterTexte:connect_signal("button::press", function()
      volumemasterControle.value = 0
end)
--
-- bien que conseillée, la procédure asynchrone ne donne pas un résultat immédiat...
-- awful.spawn.easy_async( commande ,
--      function(stdout,stderr,reason,exit_code)
-- 	volumeactuel = stdout
--         volumemasterControle.value = volumeactuel
--      end
-- ) 
local fh = io.popen( commande )
volumeactuel = fh:read( "*a" )
volumemasterControle.value = tonumber( volumeactuel )
fh:close()

