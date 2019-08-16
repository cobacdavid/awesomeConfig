-- {{{ Mes applis au démarrage
function run_once(cmd)
   local findme = "ps x U david |grep '" .. cmd .. "' |wc -l"
   awful.spawn.easy_async_with_shell(findme,
                                     function(stdout,stderr,reason,exit_code)
                                        if tonumber(stdout) <= 2 then
                                           awful.spawn( cmd )
                                        end
   end)
end
---
--- ALERTE BATTERIE ASUS
---
if ordinateur=="asus" then
   gears.timer {
      timeout   = 10,
      autostart = true,
      callback  = function()
	 awful.spawn.easy_async_with_shell(
	    "/home/david/travail/david/production/info/scripts/alerteBatterie.sh",
	    function (stdout,stderr,reason,exit_code)
	       
	 end)
      end
   }
end
--
-- APPLIS AU DÉMARRAGE
--
local appsDemarrage = {
   "wmname LG3D",
   compositeMgr,
   editorD,
   terminalD,
   cloudMusique,
   keepass,
   radio,
   mouseDegradeCmd,
   --mouseBleu,
   --scrollBleu,
   --cylindreEcrans,
}

for _, app in ipairs(appsDemarrage) do
   run_once( app )
end

-- Menubar configuration
-- menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- app a demarrer

-- ordinateur peut valoir "asus" ou "antec"

--if ordinateur != "antec" then
--    local appBureauMaison = {--
--       ["shell"] = {
-- 	 -- nasaBgCmd,
-- 	 -- phototheques,
-- 	 -- photothequesMod,
-- 	 --wallpaperCmd,
-- 	 editorD,
-- 	 terminalD,
-- 	 compositeMgr,
-- 	 --mpdScbCmd,
-- 	 -- "dropbox start -i",
-- 	 -- cloudTravail,
-- 	 cloudMusique,
-- 	 -- ncMpdClient,
-- 	 -- mpdCurrent,
-- 	 "wmname LG3D",
-- 	 keepass,
--       },
--       ["x"]    = {
-- 	 --mpdClient,
-- 	 -- browser,
-- 	 radio,
-- 	 -- BTapplet,
-- 	 -- WIFIapplet,
-- 	 -- hpsystray,
-- 	 -- rawEditor
--       }
--    }

-- --
--    for i , type in pairs( appBureauMaison ) do
--       print(type)
--    for j, app in ipairs( type ) do
--       run_once( app )
--       montre( tostring(j) )
--    end
-- end
--awful.spawn( editorD )
--
-- FIN app a demarrer
--
montre( "Démarrage terminé")
