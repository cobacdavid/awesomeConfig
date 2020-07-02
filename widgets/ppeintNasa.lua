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
widget.wallpaperRepImagesEspace = "/home/david/.config/awesome/fondEspace"
widget.wallpaperTheme = ""
widget.themeFond = ""
--
local function ppeintTelechargement(themeDuFond)
   local rep = widget.wallpaperRepImagesEspace
   fu.commande_execute( rep .. "/image_hasard_nasa.py" .. " " .. themeDuFond)
end
--

local function ppeintApplication()
   local rep = widget.wallpaperRepImagesEspace
   if screen.count() >= 2 and ordinateur == "maison" then
      -- local listeFichiers = scandir(rep, "jpg")
      -- local fichier = aleaTableau(listeFichiers)
      local fichier = rep .. "/" .. "fond" 
      -- gears.wallpaper.maximized(fichier, screen[2])
      gears.wallpaper.fit(fichier, screen[2], beautiful.wallpaper_color)
   end
end
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
--
gears.timer ({
      timeout = 120,
      call_now = true,
      autostart = true,
      callback = function()
         -- on récupère le fond sur internet
         ppeintTelechargement(widget.themeFond)
         -- on l'applique 5 secondes plus tard
         -- (le temps qu'il soit téléchargé !)
         gears.timer({
               timeout = 5,
               autostart = true,
               callback =  function()
                  ppeintApplication()
               end,
               single_shot = true
         })
      end
})
--
return setmetatable(widget, {__call=function(t, args)
                                return widget.ppeintDesc(args)
                   end})


