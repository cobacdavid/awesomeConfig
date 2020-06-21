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
-- fond des tags screen1
fu.imagesFonds()
--
-- appsDemarrage dans variableDefinitions
for _, app in ipairs(appsDemarrage) do
   fu.executeUneFois(app)
end
--
-- mise en route ppeint nasa
ppeintDesc = ppeint()
-- 
fu.montre( "Démarrage terminé")
