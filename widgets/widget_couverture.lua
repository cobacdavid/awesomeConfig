function couvertureW (c)
   local couverture = wibox.widget({
         text = "texte du widget",
         widget = wibox.widget.textbox,
   })
   
   couverture:connect_signal("mouse::enter",
                             function()
                                if c.mawibox then
                                   c.mawibox.visible = false
                                end
                                client.focus = c
                             end
   )

   return couverture
end
