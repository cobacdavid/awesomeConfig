function blocage_opacite(c)
   local bouton = wibox.widget({
         widget = wibox.widget.textbox,
         text = "O"
   })
   c.blocage = false
   bouton:connect_signal("button::press",
                         function()
                            c.blocage = not c.blocage
                            if c.blocage then
                               bouton.text = "B"
                            else
                               bouton.text = "O"
                            end
                         end
   )
   return bouton
end
