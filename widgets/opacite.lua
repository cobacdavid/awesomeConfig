local fu = require("fonctionsUtiles")

local widget = {}

function widget.opacite(c, args)
   local args = args or {}
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
	 slider.handle_color = fu.couleurBarre( theme.widget_opacite_handle_color_type, slider.value, MIN, MAX)
      end
   )
   slider:connect_signal("property::value",
      function()
	 c.opacity = mini + (slider.value * (maxi-mini)/ MAX)
	 slider.handle_color = fu.couleurBarre(theme.widget_opacite_handle_color_type, slider.value, MIN, MAX)
		 
      end
   )

    -- Wrap other widgets around slider here if you want,
    -- e.g. your stack widget and the textbox
    local result = slider
    return slider
end

return setmetatable(widget, {__call=function(t, args)
                                return widget.opacite(args)
                   end})
