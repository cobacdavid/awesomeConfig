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

function fonctionsUtiles.ok()
   naughty.notify({text = "OK"})
end

-- date YYYYMMDD il y a un an
function fonctionsUtiles.ilyaunan()
    local aujourdhui = os.date("*t")
    local unanavant  = os.date("%Y%m%d",
                               os.time({
                                       year  = aujourdhui.year-1,
                                       month = aujourdhui.month,
                                       day   = aujourdhui.day
                               })
    )
    return unanavant
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
function fonctionsUtiles.tableFind(tab, val)
   for index, value in pairs(tab) do
      if value == val then
         return index
      end
   end
end
--
-- enlève les barres de fenêtres si on est dans le tag "term", à
-- modifier pour généraliser à tous les tags gérée avec du tiling
function fonctionsUtiles.surTermOuPas(c)
   awful.titlebar.show(c, "bottom")
   for i, t in pairs(c:tags()) do
      if t.name == "term" then
         c.floating = false
         awful.titlebar.hide(c, "bottom")
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
   local audio_tech="00_18_09_FD_8A_B6"
   --
   local choix=audio_tech
   --
   local vol_actuel_hexa = "pacmd dump | egrep 'set-sink-volume bluez_sink." ..  choix ..".a2dp_sink '| cut -d ' ' -f 3"
   awful.spawn.easy_async(vol_actuel_hexa,
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
   local audio_tech="00_18_09_FD_8A_B6"
   --
   local choix=audio_tech
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

fonctionsUtiles.resultat = nil
function fonctionsUtiles.commandeExecute(commande)
   awful.spawn.easy_async_with_shell(commande,
                                     function(stdout, stderr, reason, exit_code)
                                        -- resultat = exit_code
                                        fonctionsUtiles.resultat = stdout
                                     end
   )
   -- ça n'a pas de sens
   -- return tostring(fonctionsUtiles.resultat)
end

--
function fonctionsUtiles.executeUneFois(cmd)
   local findme = "ps x U david |grep '" .. cmd .. "' |wc -l"
   awful.spawn.easy_async_with_shell(findme,
                                     function(stdout,stderr,reason,exit_code)
                                        if tonumber(stdout) <= 2 then
                                           awful.spawn.easy_async(
                                              string.format([[ bash -c "%s"]], cmd),
                                              function(stdout,stderr,reason,exit_code)
                                                 fu.montre(cmd .. " démarré " .. stderr)
                                              end
                                           )
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

--
-- https://stackoverflow.com/questions/1426954/split-string-in-lua
function fonctionsUtiles.splitString (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
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
function fonctionsUtiles.sortirAwesome()
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

--
-- redémarrage d'awesome
function fonctionsUtiles.restartAwesome()
   -- les statistiques
   for _, c in ipairs(client.get()) do
      c:emit_signal("unmanage")
   end
   awesome.restart()
end
--
return fonctionsUtiles
