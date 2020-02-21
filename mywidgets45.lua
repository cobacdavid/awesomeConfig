listeWidgetFiles = {--
   "widget_separateur.lua",
   "widget_heure.lua",
   "widget_luminosite.lua",
   -- "widget_volumeBT.lua",
   "widget_volumemaster.lua",
   "widget_opacite.lua",
   "widget_xgamma.lua",
   "widget_luminosite_ecrans.lua",
   "widget_screenshot.lua",
   "widget_couverture.lua",
   "widget_infos.lua",
   "widget_killneuf.lua",
   "widget_dimension_fenetre.lua",
   -- "widget_testclient.lua",
   -- "widget_testclient2.lua",
   -- "widget_freeze.lua",
}

for i, f in ipairs(listeWidgetFiles) do
    dofile ( config ..  "/" .. f)
end
