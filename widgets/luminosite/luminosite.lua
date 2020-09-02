-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-------------------------------------------------
-- some parts from awesome wm
-- distribution
-- copyright ??
-------------------------------------------------
local gears     = require("gears")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local awful     = require("awful")
--
-- renvoie une couleur nuance ou gradient (vert au rouge)
-- t : theme beautiful
-- v : valeur à colorer
-- m : minimum
-- M : Maximum
-- attention : pour l'instant m n'est pas utilisé...
-- ni coulDebut ni coulFin
local function couleurBarre (t, v , m , M , coulDebut, coulFin)
    local resultat
    if v == nil then return end
    -- if coulDebut == nil or coulFin == nil then
    local niveau = math.floor(255*v/M)
    --
    if t == "gradient" then
        -- couleur du vert au rouge
        local r = niveau
        local g = 255 - r
        resultat  = string.format("#%02X%02X00", r, g)
    else
        resultat = string.format("#%02X%02X%02X", niveau, niveau, niveau)
    end
    return resultat .. "DD"
end
--
local widget = {}

local MAX = 937
local MIN = 30
local FIC = "/sys/class/backlight/intel_backlight/brightness"


function widget.createWidget(args)
   args = args or {}
   --
   -- le widget slider
   local luminositeControle = wibox.widget({
      forced_width        = 100,
      bar_height          = 1,
      bar_shape           = gears.shape.rounded_rect,
      bar_color           = beautiful.widget_luminosite_bar_color,
      handle_shape        = gears.shape.circle,
      handle_color        = beautiful.widget_luminosite_handle_color,
      handle_border_color = beautiful.widget_luminosite_handle_border_color,
      handle_border_width = 1,
      minimum             = MIN,
      maximum             = MAX,
      --   value               = valeurLue,
      widget              = wibox.widget.slider,
   })
   -- le widget text
   local luminositeTexte = wibox.widget({
      text                = "luminosite",
      align               = "center",
      widget              = wibox.widget.textbox,
   })
   -- le widget à afficher
   local luminosite = wibox.widget({
      luminositeTexte,
      luminositeControle,
      vertical_offset=5,
      layout=wibox.layout.stack
   })
   -- actualisation
   luminositeControle:connect_signal("property::value", function()
                                        local v = luminositeControle.value
                                        --
                                        local command = 'echo '.. v .. ' > '.. FIC
                                        --montre( command )
                                        awful.spawn.easy_async_with_shell(command, function(s,t,u,v)  end)
                                        --
                                        --local valeur=math.floor(v*255/MAX)
                                        --local nuance = string.format("#%x%x%x", valeur,valeur,valeur)
                                        --luminositeControle.handle_color=nuance
                                        luminositeControle.handle_color =
                                            couleurBarre(beautiful.widget_luminosite_handle_color_type, v, MIN, MAX)
   end)
--
   if ordinateur == "laptop" then
      local f = io.open( FIC )
      local valeurLue = tonumber(f:read "*a")
      luminositeControle.value = valeurLue
      f.close()
   end
   --
   return luminosite
end


return setmetatable(widget, {__call=function(_, args)
                                return widget.createWidget(args)
                   end})

