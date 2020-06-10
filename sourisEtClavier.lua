-- désactivation de ces deux nouvelles fonctionnalités
awful.mouse.snap.edge_enabled = false
awful.mouse.snap.client_enabled = false

-- {{{ Mouse bindings
-- table_menu = {}
root.buttons(
   gears.table.join(
      awful.button({modkey}, 1,
         function()
            awful.menu.clients(--
               {width = 800},
               nil,
               function(c)
                  if c.screen == awful.screen.focused() then
                     return true
                  else
                     return false
                  end
               end
            )
         end
      ),
      awful.button({ }, 3,
         function ()
            mymainmenu:toggle()
         end
      ),
      awful.button({}, 2,
         function()
         end
      ),
      awful.button({modkey}, 4,
         function ()
            awful.tag.viewprev(1)
         end
      ),
      awful.button({modkey}, 5,
         function()
            awful.tag.viewnext(1)
         end
      )
   )
)

-- {{{ Key bindings
globalkeys = gears.table.join(
   awful.key({modkey}, "p",
      function()
         menubar.show()
      end
   ),
   awful.key({modkey}, "F1",
      function()
         awful.tag.incmwfact(.05)
      end
   ),
   awful.key({modkey}, "F2",
      function()
         awful.tag.incmwfact(-.05)
      end
   ),
   awful.key({modkey}, "F3",
      function()
         awful.spawn(browser)
      end
   ),
   awful.key({modkey}, "F4",
      function()
         awful.spawn(editor_cmd)
      end
   ),
   awful.key({modkey}, "F5",
      function()
   	 affichageAide = not affichageAide
	 if affichageAide then
	    gears.wallpaper.centered("/home/david/.config/awesome/raccourcis/controles-1.png",
                                     1,
                                     gears.color("#000000")
            )
	 else
	    gears.wallpaper.set(gears.color("#000000"))
	 end
      end
   ),
   awful.key({modkey}, "F6",
      function()
         awful.prompt.run(
            {
               prompt = "Couleur : ",
               textbox = screen.primary.mypromptbox.widget,
               exe_callback = function(couleur)
                  if couleur == "blanc" then
                     couleur = "#ffffff"
                  elseif couleur == "noir" then
                     couleur = "#000000"
                  end
                  gears.wallpaper.set(couleur)
               end
            }
         )
      end
   ),
   awful.key({modkey}, "F7",
      function()
         -- ppeintDesc est l'instance de wibox créé dans applogin45
         ppeint.afficheDescription(ppeintDesc, "/home/david/.config/awesome/fondEspace/fondDescription")
      end
   ),
   awful.key({modkey}, "F8",           function()  end),
   awful.key({modkey}, "F9",           function()  end),
   awful.key({modkey}, "F10",          function()  end),
   awful.key({modkey}, "F11",          function()  end),
   awful.key({modkey}, "F12",
      function()
         awful.spawn( "i3lock" )
      end
   ),
   --
   awful.key({modkey, "Shift"}, "F5",
      function()
         mpdCom.stopmusic()
   end),
   awful.key({modkey, "Shift"}, "F6",
      function()
         mpdCom.previous()
   end),
   awful.key({modkey, "Shift"}, "F7",
      function()
         mpdCom.playorpause()
   end),
   awful.key({modkey, "Shift"}, "F8",
      function()
         mpdCom.next()
   end),
   --
   awful.key({modkey}, "XF86PowerOff",
      function()
         awesome.quit()
      end
   ),
   awful.key({  }, "XF86Back",
      function()
 	 for _, c in ipairs(client.get()) do
	    c.opacity = .5 * c.opacity 

	 end
   end),
   awful.key({  }, "XF86Forward",
      function()
   	 for c in awful.client.iterate(function() return true end) do
	    c.opacity = 1
	 end
      end
   ),
   awful.key({  }, "XF86Reload",
      function()
	 -- local i = 0
	 -- for _, c in ipairs(client.get()) do
	 --    -- do something
	 --    --end
	 -- --for c in awful.client.iterate(function() return true end)
	 --    --do
	 --    local f = c.name
	 --    gears.surface(c.content):write_to_png( "/home/david/" .. string.format('%02i',i) .."-" .. f  ..  ".png")
	 --    i=i+1
	 -- end
      end
   ),
   awful.key({  }, "XF86HomePage", function()   end),
   awful.key({  }, "XF86Search", function()  end),
   awful.key({  }, "XF86Mail", function()  end),
   --
   --
   awful.key({modkey, "Mod1"}, "Down",
      function()
         awful.spawn(lumimoins)
      end
   ),
   awful.key({modkey, "Mod1"}, "Up",
      function()
	 awful.spawn(lumiplus)
      end
   ),
   awful.key({modkey}, "Left",
      function()
         awful.tag.viewprev(1)
      end
   ),
   awful.key({modkey}, "Right",
      function()
         awful.tag.viewnext(1)
      end
   ),
   awful.key({modkey}, "k",
      function ()
         awful.client.focus.byidx(-1)
         if client.focus then
            client.focus:raise()
         end
      end
   ),
   -- -- Layout manipulation
   awful.key({modkey}, "Tab",
      function ()
         awful.client.focus.history.previous()
         if client.focus then
            client.focus:raise()
         end
      end
   ),
   -- Standard program
   awful.key({modkey}, "Return",
      function ()
         awful.spawn(terminal)
      end
   ),
   awful.key({modkey, "Control"}, "r",
      awesome.restart
   ),
   awful.key({modkey, "Control"}, "q",
      function()
         --  awesome.quit()
         sortir_awesome()
      end
   ),
   awful.key({modkey, "Control"}, "n",
      function ()
         local c = awful.client.restore()
         -- Focus restored client
         if c then
            client.focus = c
            c:raise()
         end
      end,
      {description = "restore minimized", group = "client"}
   ),
   awful.key({modkey}, "r",
      function ()
         local s = screen.primary
         s.mypromptbox:run()
      end,
      {description = "run prompt", group = "launcher"}
   ),
   awful.key({modkey}, "x",
      function ()
         local s = screen.primary
	 awful.prompt.run(
            {
               prompt = "Run Lua code : ",
               textbox = s.mypromptbox.widget,
               exe_callback = awful.util.eval,
               history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
         )
      end,
      {description = "lua execute prompt", group = "awesome"}
   ),
   awful.key({ modkey }, "g",
      function ()
         local s = screen.primary
   	 awful.prompt.run {
   	    prompt  = "Recherche Web Google : " ,
   	    textbox = s.mypromptbox.widget,
   	    exe_callback = function (recherche)
   	       if recherche:len() == 0 then
   		  url = " '" .. urlGoogle .. "'"
   	       else
   		  recherche = string.gsub( recherche , " " , "+" )
   		  url = " '" .. urlGoogle .. metaGoogle .. "q=" .. recherche .. "'"
   	       end
   	       awful.spawn( browser .. url )
   	       --awful.tag.viewonly(tags[ecranGauche][1])
   	    end,
   	    history_path = "/home/david/.config/awesome/google_search_history"
   	 }
   end),
   
   awful.key({modkey}, "q",
      function ()
         local s = screen.primary
   	 awful.prompt.run {
            prompt = "Recherche Web Qwant : ",
   	    textbox = s.mypromptbox.widget,
   	    exe_callback = function (recherche)
   	       if recherche:len() == 0 then
   		  url = " '" .. urlQwant .. "'"
   	       else
   		  recherche = string.gsub( recherche , " " , "+" )
   		  url = " '" .. urlQwant .. metaQwant .. "q=" .. recherche .. "'"
   	       end
   	       awful.spawn( browser .. url )
   	    end,
            history_path = "/home/david/.config/awesome/google_search_history"
         }
      end
   ),
   
   awful.key({modkey}, "t",
      function ()
         local s = screen.primary
	 awful.prompt.run({
               prompt = "Thème fond : ",
               textbox = s.mypromptbox.widget,
               exe_callback = function(t)
                  themeFond = t
               end
         })
   end)
   

   -- awful.key({ modkey }, "d", function ()
   -- 	 awful.prompt.run({ prompt = "Recherche Web DuckDuckGo : " },
   -- 	    mypromptbox[ecranGauche].widget,
   -- 	    function (recherche)
   -- 	       if recherche:len() == 0 then
   -- 		  url = " '" .. urlDDGo .. "'"
   -- 	       else
   -- 		  recherche = string.gsub( recherche , " " , "+" )
   -- 		  url = " '" .. urlDDGo .. metaDDGo .. "q=" .. recherche .. "&ia=web'"
   -- 	       end
   -- 	       awful.spawn( browser .. url )
   -- 	       awful.tag.viewonly(tags[ecranGauche][1])
   -- 	    end,
   -- 	    nil,
   -- 	    "/home/david/.config/awesome/google_search_history"
   -- 	 )
   -- end)
)
--
--
-- GESTION DES CLIENTS
-- 
clientbuttons = gears.table.join(
   awful.button({}, 1,
      function (c)
         client.focus = c
         c:raise()
      end
   ),
   awful.button({modkey}, 1, awful.mouse.client.move),
   awful.button({modkey}, 3, awful.mouse.client.resize),
   awful.button({modkey, "Control"}, 1,
      function(c)
         montre(c.floating)
         c.floating = true
         c.height = 1
      end
   )
)
--
clientkeys = gears.table.join(
   awful.key({modkey}, "b",
      function(c)
	 awful.titlebar.toggle(c, beautiful.titlebar_premiere)
	 -- awful.titlebar.toggle(c, beautiful.titlebar_seconde)
      end
   ),
   awful.key({modkey}, "f",
      function (c)
         c.fullscreen = not c.fullscreen
      end
   ),
   awful.key({modkey, "Shift"}, "c",
      function (c)
         c:kill()
      end
   ),
--   awful.key({ modkey,           }, "o",      function (c) awful.client.movetoscreen(c,c.screen-1) end ),
   --   awful.key({ modkey,           }, "p",      function (c) awful.client.movetoscreen(c,c.screen+1) end ),
   awful.key({modkey}, "o",
      function (c)
         c:move_to_screen()
      end
   ),
   awful.key({modkey}, "n",
      function (c)
         c.minimized = true
      end
   ),
   awful.key({modkey, "Shift"}, "n",
      function (c)
         local g = c:geometry()
         g.height = 300
         c:geometry(g)
      end
   ),
   awful.key({modkey}, "m",
      function (c)
         -- c.maximized_horizontal = not c.maximized_horizontal
         -- c.maximized_vertical   = not c.maximized_vertical
         c.maximized   = not c.maximized
      end
   )
)
--
-- FIN GESTION DES CLIENTS
--

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
	-- Move client to tag.                                               
        awful.key({ modkey, "Shift" }, "#" .. i + 9,                                                                              
	   function ()
              if client.focus then
                 local tag = client.focus.screen.tags[i]
                 if tag then
                    client.focus:move_to_tag(tag)
                 end
              end
           end,
           {description = "move focused client to tag #"..i, group = "tag"}), 
	--        awful.key({ modkey, "Shift" }, "#" .. i + 9,
	--                  function ()
	--                      if client.focus and tags[client.focus.screen][i] then
	--                          awful.client.movetotag(tags[client.focus.screen][i])
	--                      end
	--                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end


-- Set keys
root.keys(globalkeys)
-- }}}
