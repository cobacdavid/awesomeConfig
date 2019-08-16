--  raccourci pour naughty.notify
--
function montre ( t )
   naughty.notify({ text = tostring(t) })
end

-- de la doc officielle
-- wallpapers
function set_wallpaper(s)
   if beautiful.wallpaper then
      local wallpaper = beautiful.wallpaper
      -- If wallpaper is a function, call it with the screen
      if type(wallpaper) == "function" then
	 --montre ( "OK" )
         -- la fonction wallpaper (dans le thème
         -- beautiful) doit renvoie un objet utilisable par
         -- gears.wallpaper
	 wallpaper = wallpaper(s)
      end
      gears.wallpaper.fit(wallpaper, s, false)
   end
end
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)


-- gestion volume bluetooth
--
function getBtVolume ()
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
   awful.spawn.esay_async( vol_actuel_hexa, function(stdout,stderr,reason,exit_code)
		vol_actuel_hexa = stdout	      
   end)
   --vol_actuel_hexa = execute_command ( vol_actuel_hexa )
   local sortie = tonumber( vol_actuel_hexa ) * 100 / 65535
   return sortie
end

function incBtVolume( inc )
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
function execute_command(command)
   local fh = io.popen(command)
   local str = ""
   for i in fh:lines() do
      str = str .. i
   end
   io.close(fh)
   return str
end
--

--Existence d'un fichier
-- 
-- http://stackoverflow.com/questions/4990990/lua-check-if-a-file-exists
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end
--

-- Gestion couleur 
--
-- renvoie une couleur nuance ou gradient (vert au rouge) 
-- t : theme beautiful
-- v : valeur à colorer
-- m : minimum
-- M : Maximum
-- attention : pour l'instant m n'est pas utilisé...
-- ni coulDebut ni coulFin
function couleurBarre ( t, v , m , M , coulDebut, coulFin)
   local resultat
   if v == nil then return end
   -- if coulDebut == nil or coulFin == nil then
   local niveau = math.floor(255*v/M)
   -- montre( t .. " " .. tostring(v) .. " " .. tostring(M) .. " " .. tostring(niveau) )
   if t == "gradient" then
      -- couleur du vert au rouge
      local r = niveau
      local g = 255 - r
      resultat  = string.format("#%02X%02X00",r,g)
   elseif t == "nuance" then 
      resultat = string.format("#%02X%02X%02X",niveau,niveau,niveau)
   end
   -- montre ( t )
   -- montre( resultat )
   return resultat
end

--
-- forme
--
arrondiGros = function(cr, width, height)
   gears.shape.rounded_rect(cr, width, height, 25)
end
arrondiMoyen = function(cr, width, height)
   gears.shape.rounded_rect(cr, width, height, 15)
end
arrondiPetit =  function(cr, width, height)
   gears.shape.rounded_rect(cr, width, height, 4)
end

octogoneGros = function(cr, width, height)
   gears.shape.octogon(cr, width, height, 25)
end
octogoneMoyen = function(cr, width, height)
   gears.shape.octogon(cr, width, height, 15)
end
octogonePetit = function(cr, width, height)
   gears.shape.octogon(cr, width, height, 4)
end
pArrondiGros  = function(cr, width, height)
   gears.shape.partially_rounded_rect(cr,width,height,true,true,false,true,25)
end
--
--
--
--
function sortir_awesome()
   -- awful.spawn.with_shell(mouseCmd .. scrollNoir)
    awful.spawn.easy_async_with_shell(
       scrollNoir,
       function (stdout,stderr,reason,exit_code)
          
    end)
    awful.spawn.easy_async_with_shell(
       "rivalcfg -c '#000000'",
       function (stdout,stderr,reason,exit_code)
          
    end)
    awesome.quit()
end
