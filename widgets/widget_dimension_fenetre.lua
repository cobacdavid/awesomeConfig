function dimension_button(c)
   local chaine = tostring(c.width) .. "x" .. tostring(c.height)
   local texte = wibox.widget({
         text = chaine,
         widget = wibox.widget.textbox,
         forced_width = 100,
         align = "center"
   })
   c:connect_signal("property::size",
      function()
         texte.text = tostring(c.width) .. "x" .. tostring(c.height)
      end
   )
    return texte
end
