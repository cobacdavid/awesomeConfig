listeWidgetFiles = {--
   "widget_separateur.lua",
   "widget_heure.lua",
   -- "widget_volumeBT.lua",

   "widget_xgamma.lua",
   -- "widget_screenshot.lua",
   "widget_couverture.lua",
   "widget_infos.lua",
   "widget_killneuf.lua",
   "widget_dimension_fenetre.lua",
   -- "widget_testclient.lua",
   -- "widget_testclient2.lua",
   -- "widget_freeze.lua",
   "widget_compte_rebours.lua",
   "widget_ppeint.lua"
}

for i, f in ipairs(listeWidgetFiles) do
    dofile ( config ..  "/widgets/" .. f)
end

volumemaster = require("widgets.volumemaster")
luminosite = require("widgets.luminosite")
luminosite_ecran = require("widgets.luminosite_ecran")
--
-- fenêtres
blocageopacite = require("widgets.blocageopacite")
opacite = require("widgets.opacite")
screenshot = require("widgets.screenshot")
