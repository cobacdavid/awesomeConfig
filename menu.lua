-- {{{ Menu
-- Menubar configuration
-- Set the terminal for applications that require it
menubar.utils.terminal = terminal 
-- }}}
myawesomemenu = {
   {"config", editor_cmd .. " " .. awesome.conffile },
   {"sauv. config",
    function()
       awful.spawn.with_shell(configSvg)
    end
   },
   {"hotkeys", function() return false, hotkeys_popup.show_help end},
   {"redémarrer", awesome.restart },
   {"quitter", --function() awesome.quit() end
    function()
       sortir_awesome()
    end
   }
}
myrcfilesmenu = {
   {"prof dir", editor_cmd .. " " .. latexRcFile},
   {"mp dir", editor_cmd .. " " .. metapostRcFile},
   {"emacs dir", editor_cmd .. " " .. emacsRcFile},
   {"elisp dir", editor_cmd .. " " .. emacsElispRcFile}
}

mymainmenu = awful.menu(
   {
      items = {
         {"awesome", myawesomemenu, beautiful.awesome_icone},
         {"rcfiles", myrcfilesmenu},
         --{ "nav.",     browser }
         {"editeur",     editor_cmd},
         {"fichiers", fileMgr},
         --{ "menudeb",  debian.menu.Debian_menu.Debian },
         --{ "term",     terminal }
      }
   }
)

-- }}}
menubar.menu_gen.all_menu_dirs = {
   "/usr/share/applications",
   "/usr/local/share/applications",
   "/home/your_user/.local/share/applications"
}

menubar.cache_entries = true
menubar.app_folders = {
   "/usr/share/applications/"
}
menubar.show_categories = true 

-- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
-- 				     menu = mymainmenu })
-- mychromium = awful.widget.launcher({ image = beautiful.chromium_icon,
--                                      command = browser })
-- mygmail    = awful.widget.launcher({ image = beautiful.gmail_icon,
--                                      command = gmail })
-- mygithub   = awful.widget.launcher({ image = beautiful.github_icon,
--                                      command = github })
-- mymaps     = awful.widget.launcher({ image = beautiful.maps_icon,
--                                      command = maps })
-- mylastfm   = awful.widget.launcher({ image = beautiful.lastfm_icon,
--                                      command = lastfm })
-- myjdown    = awful.widget.launcher({ image = beautiful.jdownloader_icon,
--                                      command = jdownloader })
-- myHP15     = awful.widget.launcher({ image = beautiful.hp15_icon,
--                                      command = calculatrice })
-- mymode     = awful.widget.launcher({ image = beautiful.rotation_icon,
-- 				     command = alterneMode })
-- myurgence  = awful.widget.launcher({ image = beautiful.urgence_icon,
-- 				     command = urgenceCmd })
-- mymeteo    = awful.widget.launcher({ image = beautiful.meteo_icon,
-- 				     command = meteofrance })
-- myyoutube  = awful.widget.launcher({ image = beautiful.youtube_icon,
-- 				     command = youtube })
-- myrunning  = awful.widget.launcher({ image = beautiful.running_icon,
-- 				     command = running })
-- myrabelais = awful.widget.launcher({ image = beautiful.rabelais_icon,
-- 				     command = rabelais })
-- myvlc      = awful.widget.launcher({ image = beautiful.vlc_icon,
-- 				     command = freeboxtv })
-- myeuronews = awful.widget.launcher({ image = beautiful.euronews_icon,
-- 				     command = euronews })
-- mymusique  = awful.widget.launcher({ image = beautiful.musique_icon,
-- 				     command = ncMpdClient })
-- myspotify  = awful.widget.launcher({ image = beautiful.spotify_icon,
-- 				     command = spotify })
-- mydarktable = awful.widget.launcher({ image = beautiful.darktable_icon,
-- 				     command = rawEditor })
-- myflickr  =  awful.widget.launcher({ image = beautiful.flickr_icon,
-- 				     command = flickrAlt })
-- mykeepass  =  awful.widget.launcher({ image = beautiful.keepass_icon,
-- 				     command = keepass })
