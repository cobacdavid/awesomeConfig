-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-- some parts from awesome wm 
-- distribution
-- copyright ??
-------------------------------------------------
-- Menubar configuration
menubar.utils.terminal = terminal
menubar.menu_gen.all_menu_dirs = {
   "/usr/share/applications",
   "/usr/local/share/applications",
   myhome .. "/.local/share/applications"
}
menubar.cache_entries = true
menubar.app_folders = {
   "/usr/share/applications/"
}
menubar.show_categories = true 
-- 
myawesomemenu = {
   {"config", editor_cmd .. " " .. awesome.conffile },
   {"sauv. config",
    function()
       awful.spawn.with_shell(configSvg)
    end
   },
   --   {"hotkeys", function() return false, hotkeys_popup.show_help end},
   {"redémarrer", function()
       fu.restartAwesome()
                  end
   },
   {"quitter", 
    function()
       fu.sortirAwesome()
    end
   }
}
myrcfilesmenu = {
   {"prof dir",  editor_cmd .. " " .. latexRcFile},
   {"mp dir",    editor_cmd .. " " .. metapostRcFile},
   {"emacs dir", editor_cmd .. " " .. emacsRcFile},
   {"elisp dir", editor_cmd .. " " .. emacsElispRcFile}
}

mymainmenu = awful.menu(
   {
      items = {
         {"awesome", myawesomemenu, beautiful.awesome_icone},
         {"rcfiles", myrcfilesmenu},
         {"editeur",     editor_cmd},
         {"fichiers", fileMgr},
      },
      theme = {
         width = 130,
      }
   }
)

-- }}}

