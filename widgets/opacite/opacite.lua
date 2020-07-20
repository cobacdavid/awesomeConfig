local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- Gestion couleur
--
-- renvoie une couleur nuance ou gradient (vert au rouge)
-- t : theme beautiful
-- v : valeur à colorer
-- m : minimum
-- M : Maximum
-- attention : pour l'instant m n'est pas utilisé...
-- ni coulDebut ni coulFin
local function couleurBarre ( t, v , m , M , coulDebut, coulFin)
   local resultat
   if v == nil then return end
   -- if coulDebut == nil or coulFin == nil then
   local niveau = math.floor(255*v/M)
   -- montre( t .. " " .. tostring(v) .. " " .. tostring(M) .. " " .. tostring(niveau) )
   if t == "gradient" then
      -- couleur du vert au rouge
      local r = niveau
      local g = 255 - r
      resultat  = string.format("#%02X%02X00", r, g)
   elseif t == "nuance" then
      resultat = string.format("#%02X%02X%02X", niveau, niveau, niveau)
   end
   return resultat .. "DD"
end

local widget = {}

function widget.opacite(c, args)
   args = args or {}
   --
   local MIN = 0
   local mini = 0.2
   local MAX = 100
   local maxi = 1
   local slider = wibox.widget {
       --forced_width        = 100,
       bar_shape           = gears.shape.rounded_rect,
       bar_height          = 1,
       bar_color           = beautiful.border_color,
       --handle_color        = beautiful.bg_normal,
       handle_color        = "#FFFFFF",
       handle_shape        = gears.shape.circle,
       handle_border_color = beautiful.border_color,
       handle_border_width = 1,
       minimum             = MIN,
       maximum             = MAX,
       value               = (c.opacity - mini) / ((maxi-mini) / MAX),
       widget              = wibox.widget.slider,
   }

   c:connect_signal("property::opacity",
                    function()
                        slider.value = (c.opacity - mini) / ((maxi-mini)/ MAX)
                        slider.handle_color = couleurBarre(beautiful.widget_opacite_handle_color_type,
                                                           slider.value, MIN, MAX)
                    end
   )
   slider:connect_signal("property::value",
                         function()
                             c.opacity = mini + (slider.value * (maxi-mini)/ MAX)
                             slider.handle_color = couleurBarre(beautiful.widget_opacite_handle_color_type,
                                                                slider.value, MIN, MAX)
                         end
   )
   --
   return slider
end

return setmetatable(widget, {__call=function(_, args)
                                 return widget.opacite(args)
                            end}
)
