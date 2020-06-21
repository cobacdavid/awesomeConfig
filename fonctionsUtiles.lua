-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-- some parts from awesome wm 
-- ditribution
-- copyright ??
-------------------------------------------------
--
local string = require("string")
local io = require("io")
local os = require("os")
local gears = require("gears")
local naughty = require("naughty")
local awful = require("awful")
local beautiful = require("beautiful")
local cairo = require("lgi").cairo
--
local fonctionsUtiles = {}
--
-- couleur aléatoire
function fonctionsUtiles.couleurAlea()
   local R = math.floor(math.random() * 256)
   local G = math.floor(math.random() * 256)
   local B = math.floor(math.random() * 256)
   return string.format("#%02X%02X%02X", R, G, B)
end

--
-- choix alétoire dans un tableau
function fonctionsUtiles.aleaTableau(T)
   return T[math.random(#T)]
end

--
-- https://stackoverflow.com/questions/5303174/how-to-get-list-of-directories-in-lua#11130774
-- Lua implementation of PHP scandir function
function fonctionsUtiles.scandir(directory, ext)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "' .. directory .. '" *.' .. ext)
    for filename in pfile:lines() do
        i = i + 1
        t[i] = directory .. "/" .. filename
    end
    pfile:close()
    return t
end

--  
-- raccourci pour naughty.notify
function fonctionsUtiles.montre(t)
   naughty.notify({text = tostring(t)})
end

--
function fonctionsUtiles.contains(tab, val)
   local trouve = false
   local i = 1
   while (not trouve) and (i <= #tab) do
      trouve = tab[i] == val
      i = i + 1
   end
   return trouve
end

--
-- enlève les barres de fenêtres si on est dans le tag "term", à
-- modifier pour généraliser à tous les tags gérée avec du tiling
function fonctionsUtiles.surTermOuPas(c)
   awful.titlebar.show(c, beautiful.titlebar_premiere)
   -- awful.titlebar.show(c, beautiful.titlebar_seconde)
   for i, t in pairs(c:tags()) do
      if t.name == "term" then
         c.floating = false
         awful.titlebar.hide(c, beautiful.titlebar_premiere)
         -- awful.titlebar.hide(c, beautiful.titlebar_seconde)
         break
      end
   end
end


-- de la doc officielle
-- wallpapers
-- function fonctionsUtiles.set_wallpaper(s)
--    if beautiful.wallpaper then
--       local wallpaper = beautiful.wallpaper
--       -- If wallpaper is a function, call it with the screen
--       if type(wallpaper) == "function" then
-- 	 --montre ( "OK" )
--          -- la fonction wallpaper (dans le thème
--          -- beautiful) doit renvoie un objet utilisable par
--          -- gears.wallpaper
-- 	 -- wallpaper = wallpaper(s)
--       end
--       -- gears.wallpaper.fit(wallpaper, s, false)
--    end
-- end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)


--
--  gestion volume bluetooth
function fonctionsUtiles.getBtVolume ()
   -- ess b eris
   local ess="FC_58_FA_5B_DB_38"
   -- philips dhb9100rd
   local philips="00_22_37_22_BA_76"
   -- sony srs-xb2
   local sony="FC_A8_9A_3A_F6_3C"
   --
   local choix=sony
   --
   local vol_actuel_hexa = "pacmd dump | egrep 'set-sink-volume bluez_sink." ..  choix ..".a2dp_sink '| cut -d ' ' -f 3"
   awful.spawn.esay_async(vol_actuel_hexa,
                          function(stdout,stderr,reason,exit_code)
                             vol_actuel_hexa = stdout	      
                          end
   )
   --vol_actuel_hexa = execute_command ( vol_actuel_hexa )
   local sortie = tonumber(vol_actuel_hexa) * 100 / 65535
   return sortie
end

function fonctionsUtiles.incBtVolume( inc )
   -- ess b eris
   local ess="FC_58_FA_5B_DB_38"
   -- philips dhb9100rd
   local philips="00_22_37_22_BA_76"
   -- sony srs-xb2
   local sony="FC_A8_9A_3A_F6_3C"
   --
   local choix=sony
   --
   local v = getBtVolume()
   local i = math.floor(v + inc)
   if i > 100 then
      i = 100
   elseif i < 0 then
      i = 0
   end
   local c = "pactl set-sink-volume bluez_sink." .. choix .. ".a2dp_sink " .. i .. "%"
   --naughty.notify( {text=i,timeout=1})
   awful.spawn( c )
end

-- Gestion des commandes externes
--
-- http://awesome.naquadah.org/wiki/Awesome_3_configuration/fr
-- Exécute « command » et renvoie sa sortie. On ne va sans doute pas
-- exécuter seulement des commandes avec une seule ligne de sortie.
-- hautement déconseillé
-- à supprimer 
function fonctionsUtiles.execute_command(command)
   local fh = io.popen(command)
   local str = ""
   for i in fh:lines() do
      str = str .. i
   end
   io.close(fh)
   return str
end

--
function fonctionsUtiles.commande_execute(commande)
   return fonctionsUtiles.commandeExecute(commande)
end

function fonctionsUtiles.commandeExecute(commande)
   local resultat = nil
   awful.spawn.easy_async_with_shell(commande,
                                     function(stdout, stderr, reason, exit_code)
                                        resultat = exit_code
                                     end
   )
   return tostring(resultat)
end

--
function fonctionsUtiles.executeUneFois(cmd)
   local findme = "ps x U david |grep '" .. cmd .. "' |wc -l"
   awful.spawn.easy_async_with_shell(findme,
                                     function(stdout,stderr,reason,exit_code)
                                        if tonumber(stdout) <= 2 then
                                           awful.spawn( cmd )
                                        end
   end)
end

-- resultat d'une commande bash
function fonctionsUtiles.readResult(commande)
   local fh = io.popen(commande)
   local resultat = fh:read("*a")
   fh:close()
   return resultat
end

-- lecture complète d'un fichier
function fonctionsUtiles.readFile(fichier)
   local fh = io.open(fichier)
   local contenu = fh:read("*a")
   fh:close()
   return contenu
end

--
-- Existence d'un fichier 
-- http://stackoverflow.com/questions/4990990/lua-check-if-a-file-exists
function fonctionsUtiles.fileExists(name)
   local f = io.open(name,"r")
   if f ~= nil then
      io.close(f)
      return true
   else
      return false
   end
end
--

function fonctionsUtiles.appendFile(name, lines)
   local fH= io.open(name, "a")
   fH:write(lines)
   fH:close()
end


-- Gestion couleur 
--
-- renvoie une couleur nuance ou gradient (vert au rouge) 
-- t : theme beautiful
-- v : valeur à colorer
-- m : minimum
-- M : Maximum
-- attention : pour l'instant m n'est pas utilisé...
-- ni coulDebut ni coulFin
function fonctionsUtiles.couleurBarre ( t, v , m , M , coulDebut, coulFin)
   local resultat
   if v == nil then return end
   -- if coulDebut == nil or coulFin == nil then
   local niveau = math.floor(255*v/M)
   -- montre( t .. " " .. tostring(v) .. " " .. tostring(M) .. " " .. tostring(niveau) )
   if t == "gradient" then
      -- couleur du vert au rouge
      local r = niveau
      local g = 255 - r
      resultat  = string.format("#%02X%02X00", r, g)
   elseif t == "nuance" then 
      resultat = string.format("#%02X%02X%02X", niveau, niveau, niveau)
   end
   -- montre ( t )
   -- montre(resultat)
   return resultat .. "DD"
end

--
-- 
-- définitions des formes
fonctionsUtiles.arrondiGros = function(cr, width, height)
   gears.shape.rounded_rect(cr, width, height, 25)
end
fonctionsUtiles.arrondiMoyen = function(cr, width, height)
   gears.shape.rounded_rect(cr, width, height, 15)
end
fonctionsUtiles.arrondiPetit =  function(cr, width, height)
   gears.shape.rounded_rect(cr, width, height, 4)
end

fonctionsUtiles.octogoneGros = function(cr, width, height)
   gears.shape.octogon(cr, width, height, 25)
end
fonctionsUtiles.octogoneMoyen = function(cr, width, height)
   gears.shape.octogon(cr, width, height, 15)
end
fonctionsUtiles.octogonePetit = function(cr, width, height)
   gears.shape.octogon(cr, width, height, 4)
end
fonctionsUtiles.pArrondiGros  = function(cr, width, height)
   gears.shape.partially_rounded_rect(cr, width, height,
                                      true,
                                      true,
                                      false,
                                      false,
                                      25
   )
end
--

--
-- sortie d'awesome
function fonctionsUtiles.sortir_awesome()
   -- les statistiques
   local fichierStat = "statsTag.dat"
   local lignes = "\n" .. os.date("%Y%m%d-%H%M%S") .. " " .. tostring(chgTag) .. "\n"
   for _, t in ipairs(listeChgTag) do
      lignes = lignes .. t.name .. " "
   end
   fonctionsUtiles.appendFile(fichierStat, lignes)
   -- 
   --
   -- sortie propre d'emacs
   awful.spawn.easy_async_with_shell(
      "emacsclient -e '(kill-emacs)'",
      function (stdout,stderr,reason,exit_code)
      end
   )
   for _, c in ipairs(client.get()) do
      c:emit_signal("unmanage")
   end
   awesome.quit()
end

-- https://awesomewm.org/doc/api/documentation/16-using-cairo.md.html
function fonctionsUtiles.fondEcran(t)
   local j = 0
   for i=1, #t.screen.tags do
      if (t == t.screen.tags[i]) then
         j = i
      end
   end
   local w = t.screen.geometry.width
   local h = t.screen.geometry.height
   -- Create a surface
   local img = cairo.ImageSurface.create(cairo.Format.ARGB32, w, h)
   
   -- Create a context
   local cr  = cairo.Context(img)
   --
   cr:set_font_size(200)
   local monTexte = t.name
   local T = cr:text_extents(monTexte)
   texteW = T['width']
   texteH = T['height']
   -- bandeau
   cr:set_source(gears.color(beautiful.wallpaperBandeau))
   cr:rectangle(0, (h - texteH) / 2, w, texteH + 3)
   cr:fill()
   -- texte
   cr:select_font_face("Comfortaa",
                       "CAIRO_FONT_SLANT_NORMAL",
                       "CAIRO_FONT_WEIGHT_NORMAL")
   cr:set_source(gears.color(beautiful.wallpaper_color))
   cr:move_to(w/2 - texteW/2, (h + texteH) / 2)
   cr:show_text(monTexte)
   -- les tags adjacents
   -- en lua les tableaux commencent à 1 !
   local hoffset = 50
   cr:set_source(gears.color(beautiful.wallpaper_color))
   cr:set_font_size(150)
   monTexte = t.screen.tags[((j-1)-1) % #t.screen.tags + 1].name
   T = cr:text_extents(monTexte)
   cr:move_to(w/2 - texteW/2 - T['width'] - hoffset, (h + T['height']) / 2)
   cr:show_text(monTexte)
   monTexte = t.screen.tags[((j-1)+1) % #t.screen.tags + 1].name
   T = cr:text_extents(monTexte)
   cr:move_to(w/2 + texteW/2 + hoffset, (h + T['height']) / 2)
   cr:show_text(monTexte)
   -- 
   cr:stroke()
   return img
end

function fonctionsUtiles.imagesFonds()
   local rep = "/tmp/"
   local s = screen[1]
   local surface = nil
   for i, t in ipairs(s.tags) do
      surface = fonctionsUtiles.fondEcran(t)
      surface:write_to_png(rep .. t.name .. ".png")
   end
end


return fonctionsUtiles
