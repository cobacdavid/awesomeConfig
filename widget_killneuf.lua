function killneufw(c)
   local killneuf = wibox.widget {
      layout = wibox.layout.stack,
      {
         widget = wibox.widget.textbox,
         align = "center",
         markup   = "<span font='" .. beautiful.widget_killneuf_font_neuf .. "'  foreground='" .. beautiful.widget_killneuf_neuf .. "'>9</span>"
      },
      {
         widget = wibox.widget.textbox,
         align  = "center",
         markup = "<span font='" .. beautiful.widget_killneuf_font_kill .. "'  foreground='" .. beautiful.widget_killneuf_kill .. "'>kill</span>"
      },
   }
   --
   -- 
   killneuf:connect_signal("button::press", function()
                              if c.pid == nil then return 1 end
                              local commande = "kill -9 " .. c.pid
                              awful.spawn( commande )
   end)
   
   return killneuf
end

