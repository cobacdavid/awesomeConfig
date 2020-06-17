-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
--
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
--
local fu = require("fonctionsUtiles")
--
local widget = {}
--
function widget.ppeintDesc(args)
   local args = args or {}
   local widget_description = wibox({
         width = 400,
         height = 200,
         ontop = true,
         screen = mouse.screen,
         expand = true,
         bg = beautiful.noir,
         max_widget_size = 500,
         border_width = 3,
         border_color = theme.gris,
         shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 3)
         end
   })
   --
   widget_description:setup({
         {
            {
               id = 'desc',
               widget = wibox.widget.textbox
            },
            id = 'text',
            layout = wibox.layout.fixed.vertical,
         },
         id = "conteneur",
         layout  = wibox.layout.fixed.horizontal
   })
   --
   return widget_description
end
--
function widget.afficheDescription(w, fichierDescription)
   local contenu = fu.readFile(fichierDescription)
   --
   w.conteneur.text.desc:set_text(contenu)
   w.visible = true
   w:buttons(
      awful.util.table.join(
         awful.button({}, 1,
            function()
               w.visible = false
            end
         )
      )
   )
   --
end
--
return setmetatable(widget, {__call=function(t, args)
                                return widget.ppeintDesc(args)
                   end})


