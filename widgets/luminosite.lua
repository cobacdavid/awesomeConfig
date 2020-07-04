local gears = require("gears")
local beautiful = require("beautiful")
local wibox = require("wibox")
local fu = require("fonctionsUtiles")
--
local widget = {}

local MAX = 937
local MIN = 30
local FIC = "/sys/class/backlight/intel_backlight/brightness"


function widget.createWidget(args)
   local args = args or {}
   --
   -- le widget slider
   luminositeControle = wibox.widget({
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
   luminositeTexte = wibox.widget({
      text                = "luminosite",
      align               = "center",
      widget              = wibox.widget.textbox,
   })
   -- le widget à afficher
   luminosite = wibox.widget({
      luminositeTexte,
      luminositeControle,
      vertical_offset=5,
      layout=wibox.layout.stack
   })
   -- actualisation
   luminositeControle:connect_signal("property::value", function()
                                        local v=luminositeControle.value
                                        --
                                        local command='echo '.. v .. ' > '.. FIC
                                        --montre( command )
                                        awful.spawn.easy_async_with_shell(command, function(s,t,u,v)  end)
                                        --
                                        --local valeur=math.floor(v*255/MAX)
                                        --local nuance = string.format("#%x%x%x", valeur,valeur,valeur)
                                        --luminositeControle.handle_color=nuance
                                        luminositeControle.handle_color = fu.couleurBarre(theme.widget_luminosite_handle_color_type, v, MIN, MAX)
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


return setmetatable(widget, {__call=function(t, args)
                                return widget.createWidget(args)
                   end})

