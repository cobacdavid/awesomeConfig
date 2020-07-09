-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-------------------------------------------------
-- some parts from awesome wm 
-- ditribution
-- copyright ??
-------------------------------------------------
local string = require("string")
local wibox = require("wibox")
--
local widget = {}


local function actualiseContenu(w, texte, args)
   local args = args or {}
   local font = args.font or beautiful.widget_font_pri
   local size = args.size or 15
   --
   w:set_markup("<span font='" .. font .. " " .. size .. "'>"
                   .. texte
                   .. "</span>")
end


function widget.dimFenetre(c, args)
   local args = args or {}
   --
   local color = args.color or beautiful.widget_fg
   local width = args.width or 150
   --
   local rapport = tonumber(string.format("%.2f", c.width/c.height))
   local chaine = tostring(c.width) .. "x" .. tostring(c.height) .. " " .. rapport
   local dimFenetre = wibox.widget(
      {
         {
            id = "texte",
            widget = wibox.widget.textbox,
            forced_width = width,
            align = "center"
         },
         bg = color,
         widget = wibox.container.background
      }
   )
   actualiseContenu(dimFenetre.texte, chaine, args)
   --
   local tt = awful.tooltip({})
   tt:add_to_object(dimFenetre)
   dimFenetre:connect_signal("mouse::enter", function()
                              tt.text = "width x height ratio"
   end)
   --
   --
   c:connect_signal("property::size",
                    function()
                       local rapport = tonumber(string.format("%.2f", c.width/c.height))
                       actualiseContenu(dimFenetre.texte, tostring(c.width) .. "x"
                                           .. tostring(c.height) .. " "
                                           .. rapport, args)
                    end
   )
   return dimFenetre
end


return setmetatable(widget, {__call=function(t, client, args)
                                return widget.dimFenetre(client, args)
                   end})
