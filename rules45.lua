-- {{{ Rules
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { --border_width = beautiful.border_width,
	border_width = "0",
	border_color = beautiful.border_normal,
	raise = true,
	keys = clientkeys,
	buttons = clientbuttons,
	screen = awful.screen.preferred,
	placement = awful.placement.no_overlap+awful.placement.no_offscreen,
	opacity = 1} },
   -- Add titlebars to normal clients and dialogs
   { rule_any = {type = { "normal", "dialog" } },
     properties = {
        titlebars_enabled = true,
     }
   },
   { rule = { class = fileMgrClass },
     properties = {screen=1,
   		   floating = false,
   		   tag = "divers" } },
   { rule = { class = browserClass },
     properties = { screen =1,
   		    tag                  = "www",
   		    maximized_vertical   = true,
   		    maximized_horizontal = true} },
   { rule = { class = browser_altClass },
     properties = { screen=1,
   		    tag                  = "www",
   		    maximized_vertical   = true,
   		    maximized_horizontal = true} },
   { rule = { class = operaClass },
     properties = { screen=1,
   		    tag                  = "www",
   		    maximized_vertical   = true,
   		    maximized_horizontal = true} },
   { rule = { class = chromiumClass },
     properties = { screen=1,
   		    tag                  = "www",
   		    maximized_vertical   = true,
   		    maximized_horizontal = true} },
   -- -- Floating clients.
   --  { rule_any = {
   --      instance = {
   --        "DTA",  -- Firefox addon DownThemAll.
   --        "copyq",  -- Includes session name in class.
   --      },
   --      class = {
   --        "Arandr",
   --        "Gpick",
   --        "Kruler",
   --        "MessageWin",  -- kalarm.
   --        "Sxiv",
   --        "Wpa_gui",
   --        "pinentry",
   --        "veromix",
   --        "xtightvncviewer"},

   --      name = {
   --        "Event Tester",  -- xev.
   --      },
   --      role = {
   --        "AlarmWindow",  -- Thunderbird's calendar.
   --        "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
   --      }
   --    }, properties = { floating = true }},

   -- { rule = { class = "MPlayer" },
   --   properties = { floating = true } },
   -- { rule = { class = "pinentry" },
   --   properties = { floating = true } },
   -- { rule = { class = "gimp" },
   --   properties = { floating = true } },
   -- 
   { rule = { class = editorClass },
     properties = {screen=1,
   		   tag          = "term",
   		   opacity      = 1,
   		   border_width = 1 } },
   
   { rule = { class = "XTerm" },
     properties = {screen=1,
   		   tag          = "term",
   		   opacity      = 0.8,
   		   border_width = 1,
   		   type = "desktop"
   } },
   { rule = { class = terminalClass },
     properties = {screen=1,
   		   tag          = "term",
   		   opacity      = 1,
   		   border_width = 1 } },
   -- { rule = { class = "Tickr" },
   --   properties = { sticky = true } },
   -- --{ rule = { class = "Conky" },
   -- --  tag = tags[1][1], properties = { buttons  = conkybuttons } },
   { rule = { class = ftpMgrClass },
     properties = {screen=1,
   		   tag = "divers" } },
   { rule = { class = "libreoffice" },
     properties = {screen=1,
   		   tag = "divers" } },
   -- { rule = { class = "JDownloader" },
   --   properties = {screen=1,
   -- 		   tag = "divers" } },
   -- { rule = { class = "KeePass2" },
   --   properties = {screen=1,
   -- 		   tag = "term" } },
   -- { rule = { class = "KeePass" },
   --   properties = {screen=1,
   -- 		   tag = "term" } },
   -- { rule = { class = "Vlc" },
   --   properties = {screen=1,
   -- 		   tag = "travail",
   -- 	floating = true
   --   } },
   -- { rule = { class = "mplayer2" },
   --   properties = { --
   -- 	--tag = tags[ecranDroit][1],
   -- 	floating = true
   --   } },
   { rule = { class = "Evince" },
     properties = {screen=1,
   		   tag                  = "travail",
		   width                = 800,
		   height               = 600
     } },
   { rule = { class = "MuPDF" },
     properties = {screen=1,
   		   tag                  = "travail",
		   width                = 800,
		   height               = 600
     } },

   { rule = { class = "Darktable" },
     properties = {screen=1,
   		   tag                  = "divers",
   } },
   { rule = { name = ".*Aux.png.*" },
     properties ={screen = 2,
                   maximized_vertical   = true,
                  maximized_horizontal = true                  
     }
   }
}
-- }}}
