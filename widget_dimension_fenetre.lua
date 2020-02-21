function dimension_button(c)
   local texte = wibox.widget({
         -- text = tostring(c.width) .. " x " .. tostring(c.height),
         widget = wibox.widget.textbox,
         forced_width = 100,
         align = "center"
   })
   c:connect_signal("property::size",
      function()
         texte.text = tostring(c.width) .. " x " .. tostring(c.height)
      end
   )
    return texte
end
