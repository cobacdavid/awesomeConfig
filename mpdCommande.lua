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
local socket  = require("socket")
local naughty = require("naughty")
local os      = require("os")
--
local myhome = os.getenv("HOME") .. "/"
--
local function strip(chaine)
   while (chaine:sub(1, 1) == " ") do
      chaine = chaine:sub(2)
   end
   while (chaine:sub(-1, -1) == " ") do
      chaine = chaine:sub(1, -2)
   end
   return chaine
end
--
local function notifie(t)
   naughty.notify({
         title = "♬ mpd",
         text =  tostring(t)
   })
end
--
mpd = {}

mpd.cartist = nil
mpd.ctrack = nil
mpd.statusList = nil
mpd._socket = nil
mpd.socketNotifies = false
--
function mpd.run()
   -- mpd est lancé via play
   -- pas de démarrage auto avec apponlogin...
   commande = "/usr/bin/mpd " .. myhome .. ".config/mpd/mpd.conf"
   awful.spawn.easy_async_with_shell(commande,
                                     function(stdout, stderr, reason, exit_code)
                                        notifie("lancement")
   end)
end
--
function mpd.connect()
   local host = "localhost"
   local port = 6600
   mpd._socket = socket.connect(host, port)
   if not mpd._socket then
      mpd.run()
      mpd._socket = socket.connect(host, port)
   end
   local r = mpd._socket:receive()
   -- ajouter un test de bon déroulement !!
   return mpd._socket
end
--
function mpd.close()
   mpd._socket:close()
end
--
function mpd.com(ordre)
   mpd.connect()
   local t = {"play", "stop", "pause", "next", "previous"}
   mpd._socket:send(ordre .. "\n")
   local reponse = mpd._socket:receive()
   if reponse == "OK" and mpd.socketNotifies then
      notifie("Serveur MPD : OK")
   elseif reponse:sub(1, 3) == "ACK" and mpd.socketNotifies then
      notifie("Erreur serveur MPD : " .. reponse)
   elseif reponse ~= "OK" and reponse:sub(1, 3) ~= "ACK" then
      local fin = false
      while (not fin) and t<1000 do
         local r = mpd._socket:receive()
         notifie(r)
         reponse = reponse .. "\n" .. r
         fin = r == "OK"
      end
      if mpd.socketNotifies then
         notifie("Serveur MPD : " .. reponse)
      end
      t = t + 1
   end
   mpd.close()
end
--
function mpd.status()
   mpd.connect()
   local tableauReponse = {}
   mpd._socket:send("status\n")
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
--
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
--
function mpd.artistAndTrack()
   local t = mpd.currentsong()
   mpd.cartist = t['Artist']
   mpd.ctrack  = t['Title']
end
--
function mpd.previous()
   mpd.statusListe = mpd.status()
   if mpd.statusListe['state'] == "play" then
      mpd.com("previous")
      mpd.artistAndTrack()
      notifie(mpd.cartist .. "\n" .. mpd.ctrack)
   end
end
--
function mpd.next()
   mpd.statusListe = mpd.status()
   if mpd.statusListe['state'] == "play" then
      mpd.com("next")
      mpd.artistAndTrack()
      notifie(mpd.cartist .. "\n" .. mpd.ctrack)
   end
end
--
function mpd.runorplayorpause()
   mpd.statusListe = mpd.status()
   local etat = nil
   if mpd.statusListe['state'] == "stop" then
      mpd.com("play")
      etat = "play"
   else
      if mpd.statusListe['state'] == "pause" then
         etat = "play"
      else
         etat = "pause"
      end
      mpd.com("pause")
   end
   --
   if mpd.socketNotifies then
      notifie("Serveur MPD : " .. etat)
   end
   --
   if etat == "play" then
      mpd.artistAndTrack()
      notifie(mpd.cartist .. "\n" .. mpd.ctrack)
   end
end
--
function mpd.stopmusic()
   mpd.com("stop")
end
--
return mpd
