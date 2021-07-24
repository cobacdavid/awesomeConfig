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
local gears     = require("gears")
local beautiful = require("beautiful")
--
local myhome = os.getenv("HOME") .. "/"
--
local function aleaTableau(T)
    return T[math.random(#T)]
end
--
local function readFile(fichier)
    local fh = io.open(fichier)
    local contenu = fh:read("*a")
    fh:close()
    return contenu
end
--
local widget = {}
--
widget.wallpaperRepImagesEspace = myhome .. ".config/awesome/widgets/ppeintNasa"
widget.wallpaperTheme = ""
widget.themeFond = ""
--
local function ppeintTelechargement(themeDuFond)
    local rep = widget.wallpaperRepImagesEspace
    local commande = rep .. "/image_hasard_nasa.py" .. " " .. themeDuFond
    awful.spawn.easy_async_with_shell(commande,
                                      function(stdout, stderr, reason, exit_code)
                                      end
    )
end
--
local function ppeintApplication()
    local rep = widget.wallpaperRepImagesEspace
    if screen.count() >= 2 and ordinateur == "desktop2" then
        local fichier = rep .. "/fond"
        gears.wallpaper.fit(fichier, screen[2], beautiful.bg_normal)
    end
end
--
function widget.ppeintDesc(args)
   args = args or {}
   local widget_description = wibox({
         width           = 400,
         height          = 200,
         ontop           = true,
         screen          = mouse.screen,
         expand          = true,
         bg              = beautiful.bg_normal,
         max_widget_size = 500,
         border_width    = 3,
         border_color    = beautiful.border_color_normal,
         shape           = args.shape or function(cr, width, height)
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
   local contenu = readFile(fichierDescription)
   --
   w.conteneur.text.desc:set_text(contenu)
   w.visible = true
   w:buttons(gears.table.join(
                awful.button({}, 1,
                   function()
                      w.visible = false
                   end
                )
   ))
   --
end
--
--
gears.timer ({
      timeout   = 120,
      call_now  = true,
      autostart = true,
      callback  = function()
         -- on récupère le fond sur internet
         ppeintTelechargement(widget.themeFond)
         -- on l'applique 5 secondes plus tard
         -- (le temps qu'il soit téléchargé !)
         gears.timer({
               timeout     = 5,
               autostart   = true,
               callback    =  function()
                  ppeintApplication()
               end,
               single_shot = true
         })
      end
})
--
return setmetatable(widget, {__call=function(_, args)
                                 return widget.ppeintDesc(args)
                   end})


