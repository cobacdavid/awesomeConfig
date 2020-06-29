-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
local wibox = require("wibox")
--
local widget = {}

function widget.blocage_opacite(c)
   local bouton = wibox.widget({
         widget = wibox.widget.textbox,
         text = "O"
   })
   --
   c.blocage = false
   --
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

return setmetatable(widget, {__call=function(t, args)
                                return widget.blocage_opacite(args)
                   end})
