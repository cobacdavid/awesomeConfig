-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
--
local wibox = require("wibox")
--local fu = require("fonctionsUtiles")
--
local widget = {}
widget.limit = nil
--
function widget.raccourcirTitre(titre)
   --
   local lenTitre = string.len(titre)
   if (lenTitre > titreClient.limit) then
      if titreClient.limit <= 3 then
         titre = "..."
      elseif titreClient.limit == 4 then
            titre = string.sub(titre, 1, 1) .. "..."
      else
         local lenPartage1 = (titreClient.limit - 3) // 2
         local lenPartage2 = titreClient.limit - 3 - lenPartage1
         local gauche = math.max(lenPartage1, lenPartage2)
         local droite = math.min(lenPartage1, lenPartage2)
         local pref = gauche ~= 0 and string.sub(titre, 1, gauche)
            or titreClient.limit > 3 and string.sub(titre, 1, 1)
         local suff = droite > 0 and string.sub(titre, -droite) or ""
         titre = pref .. "..." .. suff
      end
   end
   return titre
end
--
function widget.createWidget(c, args)
   --
   local args = args or {}
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
   -- c:connect_signal("manage", function(c)
   --                     if not c.titre then
   --                        c.titre =  widget.createWidget(c, args)
   --                     end
   -- end)
   --
   c:connect_signal("property::name",
                      function(c)
                         local n = c.name
                         local t = callback(n)
                         -- sometimes crashes due to c.titre does
                         -- not exist
                         if c.titre then
                            c.titre.texte:set_markup(t)
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
return setmetatable(widget, {__call=function(t, client, args)
                                return widget.createWidget(client, args)
                   end})
