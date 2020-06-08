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
   gears.timer(
      {
         timeout   = 10,
         autostart = true,
         callback  = function()
            awful.spawn.easy_async_with_shell(
               "/home/david/travail/david/production/info/scripts/alerteBatterie.sh",
               function (stdout,stderr,reason,exit_code)
                  
            end)
         end
      }
   )
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
}

for _, app in ipairs(appsDemarrage) do
   run_once( app )
end

ppeintDesc = ppeint()
fu.montre( "Démarrage terminé")
