local widget = {}

function widget.separateur(args)
      local separateur = wibox.widget({
            --shape  = gears.shape.circle,
            color="#0000000",
            forced_width=5,
            widget = wibox.widget.separator
      })
      return separateur
end

return setmetatable(widget, {__call=function(t, args)
                                return widget.separateur(args)
                   end})
