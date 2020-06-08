local widget = {}

function widget.dimFenetre(c, args)
   local chaine = tostring(c.width) .. "x" .. tostring(c.height)
   local dimFenetre = wibox.widget(
      {
         text = chaine,
         widget = wibox.widget.textbox,
         forced_width = 150,
         align = "center"
      }
   )
   c:connect_signal("property::size",
                    function()
                       rapport = tonumber(string.format("%.2f", c.width/c.height))
                       dimFenetre.text = tostring(c.width) .. "x"
                          .. tostring(c.height) .. " " .. rapport 
                    end
   )
   return dimFenetre
end


return setmetatable(widget, {__call=function(t, args)
                                return widget.dimFenetre(args)
                   end})
