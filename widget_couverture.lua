function couvertureW (c)
   couverture = wibox.widget{
      image = beautiful.flash_icon,
      widget = wibox.widget.imagebox
   }
   
   couverture:connect_signal("button::press",
                             function()
                                c.mawibox.visible = false
                             end
   )
   return couverture
end
