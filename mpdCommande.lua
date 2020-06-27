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
local socket = require("socket")
local fu = require("fonctionsUtiles")

--
mpd = {}

mpd.cartist = nil
mpd.ctrack = nil
mpd.statusList = nil
mpd._socket = nil

local function strip(chaine)
   while (chaine:sub(1, 1) == " ") do
      chaine = chaine:sub(2)
   end
   while (chaine:sub(-1, -1) == " ") do
      chaine = chaine:sub(1, -2)
   end
   return chaine
end

function mpd.run()
   -- mpd est lancé via play
   -- pas de démarrage auto avec apponlogin...
   fu.commande_execute("/usr/bin/mpd ~/.config/mpd/mpd.conf")
end

function mpd.connect()
   local host = "localhost"
   local port = 6600
   mpd._socket = socket.connect(host, port)
   if mpd._socket == nil then
      mpd.run()
      return nil
   else 
      local r = mpd._socket:receive()
      return 1
   end
   -- ajouter un test de bon déroulement !!
end

function mpd.close()
   mpd._socket:close()
end

function mpd.com(ordre)
   mpd.connect()
   local t = {"play", "stop", "pause", "next", "previous"}
   mpd._socket:send(ordre .. "\n")
   local reponse = mpd._socket:receive()
   if reponse == "OK" then
      fu.montre("Serveur MPD : OK")
   elseif reponse:sub(1, 3) == "ACK" then
      fu.montre("Erreur serveur MPD : " .. reponse)
   else
      local fin = false
      while (not fin) do
         local r = mpd._socket:receive()
         reponse = reponse .. "\n" .. r
         fin = r == "OK"
      end
      fu.montre("Serveur MPD : " .. reponse)      
   end
   mpd.close()
end

function mpd.status()
   mpd.connect()
   local tableauReponse = {}
   mpd._socket:send("status" .. "\n")
   local fin = false
   local r = mpd._socket:receive()
   while (not fin) do
      local indiceSep = r:find(":")
      local cle = r:sub(1, indiceSep - 1)
      local valeur = r:sub(indiceSep + 1)
      tableauReponse[cle] = strip(valeur)
      r = mpd._socket:receive()
      fin = r == "OK"
   end
   mpd.close()
   return tableauReponse
end

function mpd.currentsong()
   mpd.connect()
   local tableauReponse = {}
   mpd._socket:send("currentsong\n")
   local fin = false
   local r = mpd._socket:receive()
   while (not fin) do
      local indiceSep = r:find(":")
      local cle = r:sub(1, indiceSep - 1)
      local valeur = r:sub(indiceSep + 1)
      tableauReponse[cle] = strip(valeur)
      r = mpd._socket:receive()
      fin = r == "OK"
   end
   mpd.close()
   return tableauReponse
end

function mpd.artistAndTrack()
   local t = mpd.currentsong()
   mpd.cartist = t['Artist']
   mpd.ctrack  = t['Title']
end

function mpd.previous()
   mpd.statusListe = mpd.status()
   if mpd.statusListe['state'] == "play" then
      mpd.com("previous")
   end
end

function mpd.next()
   mpd.statusListe = mpd.status()
   if mpd.statusListe['state'] == "play" then
      mpd.com("next")
   end
end

function mpd.playorpause()
   if not mpd.connect() then
      fu.montre("Serveur MPD : lancement")
      return nil
   end
   mpd.statusListe = mpd.status()
   local etat = ""
   if mpd.statusListe['state'] == "stop" then
      mpd.com("play")
   else
      if mpd.statusListe['state'] == "pause" then
         etat = "play"
      else
         etat = "pause"
      end
      mpd.com("pause")
   end
    fu.montre("Serveur MPD : " .. etat)
end

function mpd.stopmusic()
   mpd.com("stop")
end


return mpd
