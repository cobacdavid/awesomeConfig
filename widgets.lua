-- listeWidgetFiles = {--
--    -- "widget_volumeBT.lua",
--    -- "widget_xgamma.lua",
--    -- "widget_couverture.lua",
--    -- "widget_testclient.lua",
--    -- "widget_testclient2.lua",
--    -- "widget_freeze.lua",
--    -- "widget_compte_rebours.lua",
-- }

-- for i, f in ipairs(listeWidgetFiles) do
--     dofile ( config ..  "/widgets/" .. f)
-- end

separateur = require("widgets.separateur")
heure = require("widgets.heure")
volumemaster = require("widgets.volumemaster")
luminosite = require("widgets.luminosite")
luminosite_ecran = require("widgets.luminosite_ecran")
killneuf = require("widgets.killneuf")
ppeint = require("widgets.ppeintDesc")
--
-- fenêtres
blocageopacite = require("widgets.blocageopacite")
opacite = require("widgets.opacite")
screenshot = require("widgets.screenshot")
infos = require("widgets.infos")
dimFenetre = require("widgets.dimFenetre")
