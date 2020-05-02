function dimension_button(c)
   local chaine = tostring(c.width) .. "x" .. tostring(c.height)
   local texte = wibox.widget(
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
                       texte.text = tostring(c.width) .. "x"
                          .. tostring(c.height) .. " " .. rapport 
                    end
   )
   return texte
end
