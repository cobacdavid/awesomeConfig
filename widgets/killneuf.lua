local widget = {}


function widget.killneuf(c, args)
   local killneuf = wibox.widget({
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
   })
   --
   -- 
   killneuf:connect_signal("button::press", function()
                              if c.pid == nil then return 1 end
                              local commande = "kill -9 " .. c.pid
                              fu.commande_execute(commande)
                                            end
   )
   return killneuf
end

return setmetatable(widget, {__call=function(t, args)
                                return widget.killneuf(args)
                   end})

