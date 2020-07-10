local fu = require("fonctionsUtiles")
local gears = require("gears")
local wibox = require("wibox")
--
local widget = {}

function widget.createWidget(args)
   local args = args or {}
   --
   local width = args.width or 150
   local bshape = args.barshape or gears.shape.rounded_rect
   local bheight = args.barheight or 1
   local bcolortype = args.barcolortype or "gradient"
   local bcolor = args.barcolor or fu.couleurBarre(bcolortype, volumeactuel, MIN, MAX)
   local hcolortype = args.handcolortype or "gradient"
   local hcolor = args.handcolor or bcolor
   local hradius = args.handradius or 5
   local ttext = args.texttext or "master"
   local tjustify = args.textjustify or "center"
   local tvoffset = args.textvoffset or 5
   --
   local sortie = " Master "
   local commande = "amixer get" .. sortie .. "|grep Left:|cut -d ' ' -f6"
   -- local commande = "amixer get" .. sortie .. "|grep Mono:|cut -d ' ' -f5"
   local commandeMax = "amixer get" .. sortie .. "|grep Limits|cut -d ' ' -f7"
   --
   local volumeactuel
   local MIN = 0
   local MAX = tonumber(fu.readResult(commandeMax))
   -- slider
   local volumemasterControle = wibox.widget({
      forced_width        = width,
      bar_shape           = shape,
      bar_height          = bheight,
      bar_color           = bcolor,
      -- handle_shape        = gears.shape.circle,
      handle_shape        = function(cr, w, h)
         gears.shape.circle (cr, w, h, hradius)
      end,
      handle_color        = hcolor,
      minimum             = MIN,
      maximum             = MAX,
      widget              = wibox.widget.slider,
   })
   -- texte
   local volumemasterTexte = wibox.widget({
      text = ttext,
      align = tjustify, 
      widget = wibox.widget.textbox
   })
   -- à afficher
   local volumemaster = wibox.widget({
      volumemasterTexte,
      volumemasterControle,
      vertical_offset = tvoffset,
      layout = wibox.layout.stack
   })
   --
   volumemasterControle:connect_signal(
      "property::value",
      function()
         local v=volumemasterControle.value
         local command='amixer set' .. sortie  .. v
         fu.commande_execute(command)
         volumemasterControle.handle_color = fu.couleurBarre(hcolortype, v, MIN, MAX)
      end
   )
   --
   volumemasterTexte:connect_signal(
      "button::press",
      function()
         volumemasterControle.value = 0
      end
   )
   --
   volumemasterControle.value = tonumber(fu.readResult(commande))
   return volumemaster
end


return setmetatable(widget, {__call=function(t, args)
                        return widget.createWidget(args)
                             end})


