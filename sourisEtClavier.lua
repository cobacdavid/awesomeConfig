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
-- désactivation de ces deux nouvelles fonctionnalités
awful.mouse.snap.edge_enabled = false
awful.mouse.snap.client_enabled = false

-- {{{ Mouse bindings
-- table_menu = {}
root.buttons(
    gears.table.join(
        awful.button({modkey}, 1,
            function()
                awful.menu.client_list(--
                    {},
                    nil,
                    function(c)
                        --if c.screen == awful.screen.focused() then
                        return true
                        --else
                        --return false
                        --end
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
            local w = bigC({
                    font         = "Northwood High", --"HP15C Simulator Font",
                    seg          = false,
                    seg_dark     = .35,
                    fg           = "#A0A0A0",
                    border_width = 20,
                    screen       = mouse.screen,
                    size         = 300,
                    radius       = 1
            })
            local s = mouse.screen
            local ww = wibox({
                    x       = 0,
                    y       = 0,
                    screen  = s,
                    width   = s.geometry.width,
                    height  = s.geometry.height,
                    visible = true,
                    ontop   = true 
            })
            ww:setup({
                    w,
                    layout = wibox.layout.fixed.horizontal
            })
            ww:connect_signal("button::press", function()
                                  ww.visible = false
                                  ww = nil
            end)
        end
    ),
    awful.key({modkey}, "F6", function() ppeintId() end),
    awful.key({modkey}, "F7",
        function()
            -- ppeintDesc est l'instance de wibox créé dans rc.lua
            ppeintNasa.afficheDescription(ppeintDesc,
                                          myhome .. ".config/awesome/widgets/ppeintNasa/fondDescription")
        end
    ),
    awful.key({modkey}, "F8",           function()  end),
    awful.key({modkey}, "F9",           function()  end),
    awful.key({modkey}, "F10",          function()  end),
    awful.key({modkey}, "F11",
        function()
            awful.spawn( "i3lock" )
        end
    ),
    awful.key({modkey}, "F12",
        function()
            my_systray.visible = not my_systray.visible
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
            mpdCom.runorplayorpause()
    end),
    awful.key({modkey, "Shift"}, "F8",
        function()
            mpdCom.next()
    end),
    --
    awful.key({modkey, "Shift"}, "F9",
        function()
            mpdCom.artistAndTrack()
            fu.montre(mpdCom.cartist .. "\n" .. mpdCom.ctrack)
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
    --
    awful.key({modkey, "Mod1"}, "Up",
        function()
            awful.spawn(lumiplus)
        end
    ),
    --
    awful.key({modkey}, "Left",
        function()
            awful.tag.incmwfact(.05)
        end
    ),
    awful.key({modkey}, "Right",
        function()
            awful.tag.incmwfact(-.05)
        end
    ),
    --
    awful.key({modkey, "Shift"}, "<",
        function()
            awful.tag.viewprev(1)
        end
    ),
    --
    awful.key({modkey}, "<",
        function()
            awful.tag.viewnext(1)
        end
    ),
    --
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
    --
    awful.key({modkey, "Control"}, "r",
        function()
            fu.restartAwesome()
        end
    ),
    --
    awful.key({modkey, "Control"}, "q",
        function()
            fu.sortirAwesome()
        end
    ),
    --
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
    --
    awful.key({modkey}, "r",
        function ()
            local s = screen.primary
            mypromptbox:run()
        end,
        {description = "run prompt", group = "launcher"}
    ),
    --
    awful.key({modkey}, "x",
        function ()
            local s = screen.primary
            awful.prompt.run(
                {
                    prompt = "Run Lua code : ",
                    textbox = mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                }
            )
        end,
        {description = "lua execute prompt", group = "awesome"}
    ),
    awful.key({modkey}, "c",
        function ()
            local s = screen.primary
            awful.prompt.run(
                {
                    prompt = "Expression Rpn : ",
                    textbox = mypromptbox.widget,
                    exe_callback = function(expression)
                        local commande = "python3 " .. myhome .. ".config/awesome/scripts/rpnEval.py '" .. expression .. "'"
                        awful.spawn.easy_async_with_shell(commande,
                                                          function(stdout, stderr, reason, exit_code)
                                                              promptbox.widget.font = "Inconsolata 20"
                                                              promptbox.widget:set_text(expression .. " " .. stdout)
                        end)
                    end,
                    history_path = awful.util.get_cache_dir() .. "/expression_eval"
                }
            )
        end,
        {description = "rpn prompt", group = "awesome"}
    ),
    --
    awful.key({ modkey }, "g",
        function ()
            local s = screen.primary
            awful.prompt.run {
                prompt  = "Recherche Web Google : " ,
                textbox = promptbox.widget,
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
                history_path = myhome .. ".config/awesome/google_search_history"
            }
    end),
    
    awful.key({modkey}, "s",
        function ()
            local s = screen.primary
            awful.prompt.run {
                prompt = "Secret : ",
                textbox = promptbox.widget,
                exe_callback = function (t)
                    local commande = "echo " .. t
                        .. " |md5sum |cut -d ' ' -f 1"
                    --
                    local fh = io.popen(commande)
                    local somme = fh:read("*a")
                    io.close(fh)
                    --
                    secretFenetre.challengeSuccess = somme:sub(1, -2) == "3259d9db947e5519c37b71c556bc618f"
                end,
            }
        end
    ),
    
    awful.key({modkey}, "t",
        function ()
            local s = screen.primary
            awful.prompt.run({
                    prompt = "Thème fond : ",
                    textbox = mypromptbox.widget,
                    exe_callback = function(t)
                        ppeintNasa.themeFond = t
                    end,
                    history_path = myhome .. ".config/awesome/widgets/ppeintNasa/themeHistory"
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
    awful.button({modkey}, 2, function(c)
            if ecrans == "configuration1" and not c.doubleEcran then
                c.geometrieAvant = c:geometry()
                c.blocageAvant = c.blocage
                c:move_to_screen(2)
                c.floating = true
                c:geometry({
                        x = 0,
                        y = 30,
                        width = largeurPremier,
                        height = hauteurPremier + hauteurSecond - 30
                })
                c.doubleEcran = true
                c.blocage = true
                c.opacity = 1
            elseif c.doubleEcran then
                c.doubleEcran = false
                c.blocage = c.blocageAvant
                c:geometry(c.geometrieAvant)
            end
    end),
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
            awful.titlebar.toggle(c, "bottom")
            -- awful.titlebar.toggle(c, "left")
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
    awful.key({modkey}, "Up",
        function(c)
            if c.screen.index == 2 then
                c:move_to_screen(screen[1])
            end
        end
    ),
    awful.key({modkey}, "Down",
        function(c)
            if c.screen.index == 1 then
                c:move_to_screen(screen[2])
            end
        end
    ),
    awful.key({modkey}, "o",
        function (c)
            if c.screen.index == 1 then
                c:move_to_screen(screen[2])
            else
                c:move_to_screen(screen[1])
            end
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
