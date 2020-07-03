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
local fu = require("fonctionsUtiles")
--
-- appsDemarrage dans variableDefinitions
for _, app in ipairs(appsDemarrage) do
   fu.executeUneFois(app)
end
--
-- fond des tags screen1
ppeintTag.imagesFonds()
--
-- mise en route ppeint nasa
ppeintDesc = ppeintNasa()
--
-- ce qui suit ne règle pas le problème du fond au démarrage
-- gears.wallpaper.maximized("/tmp/term.png", screen[1])
--
fu.montre( "Démarrage terminé")
