-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
--
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
--
local widget = {}
widget.limit = nil
--
function widget.raccourcirTitre(titre)
   --
   local lenTitre = string.len(titre)
   if (lenTitre > widget.limit) then
      if widget.limit <= 3 then
         titre = "..."
      elseif widget.limit == 4 then
            titre = string.sub(titre, 1, 1) .. "..."
      else
         local lenPartage1 = (widget.limit - 3) // 2
         local lenPartage2 = widget.limit - 3 - lenPartage1
         local gauche = math.max(lenPartage1, lenPartage2)
         local droite = math.min(lenPartage1, lenPartage2)
         local pref = gauche ~= 0 and string.sub(titre, 1, gauche)
            or widget.limit > 3 and string.sub(titre, 1, 1)
         local suff = droite > 0 and string.sub(titre, -droite) or ""
         titre = pref .. "..." .. suff
      end
   end
   return titre
end
--
function widget.createWidget(c, args)
   --
   args = args or {}
   widget.limit = args.limit or 30
   local color = args.color or beautiful.bg_normal
   local callback = args.callback or widget.raccourcirTitre
   --
   local titre = wibox.widget({
         {
            id = "texte",
            widget = wibox.widget.textbox,
            align = "center"
         },
         bg = color,
         widget = wibox.container.background
   })
   --
   local tt = awful.tooltip({})
   tt:add_to_object(titre)
   titre:connect_signal("mouse::enter", function()
                           tt.text = c.name
   end)
   --
   -- c:connect_signal("manage", function(c)
   --                     if not c.titre then
   --                        c.titre =  widget.createWidget(c, args)
   --                     end
   -- end)
   --
   c:connect_signal("property::name",
                      function(cli)
                         local n = cli.name
                         local t = callback(n)
                         -- sometimes crashes due to c.titre does
                         -- not exist
                         if cli.titre then
                            cli.titre.texte:set_markup(t)
                         end
                      end
   )
   --
   -- initialisation
   local n = c.name
   local t = callback(n)
   titre.texte:set_markup(t)
   --
   return titre
end
--
return setmetatable(widget, {__call=function(_, client, args)
                                return widget.createWidget(client, args)
                   end})
