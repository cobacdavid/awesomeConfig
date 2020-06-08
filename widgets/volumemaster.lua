local fu = require("fonctionsUtiles")
--
local widget = {}

local sortie = " Master "
local commande = "amixer get" .. sortie .. "|grep Left:|cut -d ' ' -f6"
-- local commande = "amixer get" .. sortie .. "|grep Mono:|cut -d ' ' -f5"
local commandeMax = "amixer get" .. sortie .. "|grep Limits|cut -d ' ' -f7"

local function readVolume(com)
   local fh = io.popen(com)
   volume = fh:read("*a")
   fh:close()
   return tonumber(volume)
end

function widget.createWidget(args)
   local args = args or {}
   --
   local volumeactuel
   local MIN = 0
   local MAX = readVolume(commandeMax)
   -- slider
   local volumemasterControle = wibox.widget({
      forced_width        = args.width or 150,
      bar_shape           = gears.shape.rounded_rect,
      bar_height          = args.barheight or 1,
      bar_color           = args.barcolor or fu.couleurBarre(beautiful.widget_volumemaster_handle_color_type, volumeactuel, MIN, MAX),
      -- handle_shape        = gears.shape.circle,
      handle_shape        = function(cr, w, h)
         gears.shape.circle (cr, w, h, 5)
      end,
      handle_color        = args.handlecolor or fu.couleurBarre(beautiful.widget_volumemaster_handle_color_type, volumeactuel, MIN, MAX),
      minimum             = MIN,
      maximum             = MAX,
      widget              = wibox.widget.slider,
   })
   -- texte
   local volumemasterTexte = wibox.widget({
      text = args.text or "master",
      align = "center", 
      widget =wibox.widget.textbox
   })
   -- à afficher
   local volumemaster = wibox.widget({
      volumemasterTexte,
      volumemasterControle,
      vertical_offset=5,
      layout=wibox.layout.stack
   })
   --
   volumemasterControle:connect_signal("property::value",
                                       function()
                                          local v=volumemasterControle.value
                                          local command='amixer set' .. sortie  .. v
                                          fu.commande_execute(command)
                                          volumemasterControle.handle_color = fu.couleurBarre(beautiful.widget_volumemaster_handle_color_type, v, MIN, MAX)
                                       end
   )
   --
   volumemasterTexte:connect_signal("button::press",
                                    function()
                                       volumemasterControle.value = 0
                                    end
   )
   --
   volumemasterControle.value = readVolume(commande)
   return volumemaster
end


return setmetatable(widget, {__call=function(t, args)
                        return widget.createWidget(args)
                             end}
                   )

--
-- bien que conseillée, la procédure asynchrone ne donne pas un résultat immédiat...
-- awful.spawn.easy_async( commande ,
--      function(stdout,stderr,reason,exit_code)
-- 	volumeactuel = stdout
--         volumemasterControle.value = volumeactuel
--      end
-- ) 

