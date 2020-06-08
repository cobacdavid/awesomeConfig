-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage",
                      function (c)
                         -- Set the windows at the slave, i.e. put
                         -- it at the end of others instead of
                         -- setting it master.  if not
                         -- awesome.startup then
                         -- awful.client.setslave(c) end

                         if awesome.startup and
                            not c.size_hints.user_position
                         and not c.size_hints.program_position then
                            -- Prevent clients from being
                            -- unreachable after screen count
                            -- changes.
                            awful.placement.no_offscreen(c)
                         end
                         --
                         fu.surTermOuPas(c)
                         --
                         -- c.shape = arrondiMoyen
                         -- c.shape = octogonePetit
                         c.shape = fu.pArrondiGros
                         -- c.shape = gears.shape.rounded_rect
                         --
                         --
                         -- WIDGET sur-contenu
                         -- local posx = c.x
                         -- local posy = c.y
                         -- local w = wibox({
                         --       x = posx,
                         --       y = posy,
                         --       width = c.width,
                         --       height = c.height,
                         --       visible = false,
                         --       ontop = true,
                         --       widget = couvertureW(c)
                         -- })
                         -- c.mawibox = w
                      end
)

client.connect_signal("tagged",
                      function (c)
                         fu.surTermOuPas(c)
                         --
                         -- bloque à 1 l'opacité des PDF sur
                         -- l'écran auxiliaire
                         if (c.class == "Evince" and c.screen.index == 2) then
                            c.opacity = 1
                            c.bo.text = "B"
                            c.blocage = true
                         end
                      end
)

client.connect_signal("unmanage",
                      function (c)
                         -- WIDGET sur-contenu
                         -- montre("OK")
                         -- c.mawibox = nil
                      end
)

client.connect_signal("property::size",
                      function(c)
                         -- WIDGET sur-contenu
                         -- if c.mawibox then
                         --    c.mawibox.width = c.width
                         --    c.mawibox.height = c.height
                         -- end
                      end
)

client.connect_signal("property::position",
                      function(c)
                         -- WIDGET sur-contenu
                         -- if c.mawibox then
                         --    c.mawibox.x = c.x
                         --    c.mawibox.y = c.y
                         -- end
                      end
)

client.connect_signal("request::titlebars",
                      function(c)
                         -- pour régler les clients PDF sur l'écran
                         -- auxiliaire
                         c.bo = blocageopacite(c)
                         c.tb = awful.titlebar.widget.titlewidget(c)
                         -- buttons for the titlebar
                         local buttons = gears.table.join(
                            awful.button({}, 1,
                               function()
                                  client.focus = c
                                  c:raise()
                                  awful.mouse.client.move(c)
                               end
                            ),
                            awful.button({}, 3,
                               function()
                                  client.focus = c
                                  c:raise()
                                  awful.mouse.client.resize(c)
                               end
                            )
                         )
                         
                         barreBas = awful.titlebar(
                            c,
                            {
                               size = beautiful.titlebar_epaisseur_premiere,
                               position = beautiful.titlebar_premiere
                            }
                         )
                         barreBas:setup(
                            {
                               { 
                                  {
                                     text = "    ",
                                     widget = wibox.widget.textbox,
                                  },
                                  wibox.widget({
                                        {
                                           image  = beautiful.grip,
                                           resize = true,
                                           widget = wibox.widget.imagebox,
                                        },
                                        awful.titlebar.widget.titlewidget(c),
                                        --c.tb,
                                        layout  = wibox.layout.stack,
                                  }),
                                  buttons = buttons,
                                  layout  = wibox.layout.fixed.horizontal
                               },
                               { 
                                   { -- Barre d'opacité
                                     align  = "center",
                                     widget = opacite(c),
                                   },
                                  layout  = wibox.layout.flex.horizontal
                               },
                               { 
                                  separateur(),
                                  c.bo,
                                  separateur(),
                                  wibox.widget {
                                     {
                                        image  = beautiful.grip,
                                        resize = true,
                                        widget = wibox.widget.imagebox
                                     },
                                     dimFenetre(c),
                                     layout  = wibox.layout.stack,
                                  },
                                  separateur(),
                                  screenshot(c),
                                  separateur(),
                                  awful.titlebar.widget.stickybutton(c),
                                  awful.titlebar.widget.ontopbutton(c),
                                  awful.titlebar.widget.maximizedbutton(c),
                                  killneuf(c),
                                  awful.titlebar.widget.closebutton(c),
                                  layout = wibox.layout.fixed.horizontal()
                               },
                               layout = wibox.layout.align.horizontal
                            }
                         )
                      end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter",
                      function(c)
                         if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                         and awful.client.focus.filter(c) then
                            client.focus = c
                         end
                         c:emit_signal("focus")
                         --
                         if ordinateur == "maison" and c.class == editorClass then
                            fu.commande_execute(clavierCmd .. " " .. configEmacs)
                         end
                         if ordinateur == "maison" and c.class == terminalClass then
                            fu.commande_execute(clavierCmd .. " " .. configUrxvt)
                         end
                      end
)

client.connect_signal("mouse::leave",
                      function(c)
                         c:emit_signal("unfocus")
                         if ordinateur == "maison" and (c.class == editorClass or c.class == terminalClass) then
                            fu.commande_execute(clavierCmd .. " " .. configAwesome)
                         end
                      end
)

client.connect_signal("property::sticky",
                      function(c)
                         -- montre(screen[2].tags[1].name)
                         -- montre(c.sticky)
                         
                         -- clientsAux = screen[2].tags[1]:clients()
                         -- if not c.sticky then
                         --    table.insert(clientsAux, c)
                         -- elseif contains(clientsAux, c) then
                         --       for i=1, #clientsAux do
                         --          if clientsAux[i] == c then 
                         --             table.remove(clientsAux, i)
                         --          end
                         --       end
                         -- end
                         -- screen[2].tags[1]:clients(clientsAux)
                         
                         -- table_tag = {} 
                         -- for _, s in ipairs(screen) do
                         --    for _, t in ipairs(s.tags) do
                         --       table.insert(table_tag, t)
                         --    end
                         -- end
                         -- c:tags(table_tag)
                      end
)

client.connect_signal("focus",
                      function(c)
			 c.border_color = beautiful.border_focus
                         -- WIDGET sur-contenu
                         -- if c.mawibox then
                         --    c.mawibox.visible = false
                         -- end
                         if not c.blocage then
                            c.opacity = 1
                         end
                         -- client.focus.first_tag:emit_signal("property::selected")
                      end
)

client.connect_signal("unfocus",
                      function(c)
			 c.border_color = beautiful.border_normal
                         -- WIDGET sur-contenu
                         -- if c.mawibox then
                         --    if c:isvisible() then
                         --       c.mawibox.visible = true
                         --    else
                         --       c.mawibox.visible = false
                         --    end
                         -- end
                         if not c.blocage then
                            c.opacity = 0.5
                         end
                      end
)

tag.connect_signal("property::selected",
                   function(t)
                      -- montre(t)
                      if #listeChgTag == 0
                      or t ~= listeChgTag[#listeChgTag] then
                         chgTag = chgTag + 1
                         table.insert(listeChgTag, t)
                      end
                      local cr = fu.fondEcran(t)
                      gears.wallpaper.maximized(cr, t.screen)
                   end
)


                      --
                      -- WIDGET sur-contenu
                      -- for i, c in ipairs(client.get()) do
                      --    if c.mawibox then
                      --       if c:isvisible() and contains(c:tags(), t) then
                      --          c.mawibox.visible = true
                      --       else
                      --          c.mawibox.visible = false
                      --       end
                      --    end
                      -- end
-- }}}
-- 			 -- Enable sloppy focus
-- 			 c:connect_signal("mouse::enter", function(c)
-- 					     if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
-- 					     and awful.client.focus.filter(c) then
-- 						client.focus = c
-- 					     end
-- 							  end)
-- 			 -- if not startup then
-- 			 --    -- Set the windows at the slave,
-- 			 --    -- i.e. put it at the end of others instead of setting it master.
-- 			 --    -- awful.client.setslave(c)
			    
-- 			 --    -- Put windows in a smart way, only if they does not set an initial position.
-- 			 --    if not c.size_hints.user_position and not c.size_hints.program_position then
-- 			 --       awful.placement.no_overlap(c)
-- 			 --       awful.placement.no_offscreen(c)
-- 			 --    end
-- 			 -- end
-- 			 if awesome.startup and
-- 			    not c.size_hints.user_position
-- 			 and not c.size_hints.program_position then
-- 			    -- Prevent clients from being unreachable after screen count changes.
-- 			    awful.placement.no_offscreen(c)
-- 			 end
			 
-- 			 --if barreFenetre and (c.type == "normal" or c.type == "dialog") then
-- 			    -- buttons for the titlebar
-- 			    local buttons = awful.util.table.join(
-- 			       awful.button({ }, 1, function()
-- 					       client.focus = c
-- 					       c:raise()
-- 					       awful.mouse.client.move(c)
-- 						    end),
-- 			       awful.button({ }, 3, function()
-- 					       client.focus = c
-- 					       c:raise()
-- 					       awful.mouse.client.resize(c)
-- 						    end)
-- 			    )
			    
-- 			    -- Widgets that are aligned to the left
-- 			    local left_layout = wibox.layout.fixed.horizontal()
-- 			    local title = awful.titlebar.widget.titlewidget(c)
-- 			    title:set_align("center")
-- 			    --title:set_markup("<span fgcolor='white' >" .. c.class .. "  " .. c.name .."</span>")
-- 			    left_layout:add( title )
-- 			    left_layout:buttons(buttons)
			    
-- 			    -- Widgets that are aligned to the right
-- 			    local right_layout = wibox.layout.fixed.horizontal()
-- 			    right_layout:add(awful.titlebar.widget.maximize(c))
-- 			    right_layout:add(awful.titlebar.widget.ontopbutton(c))
-- 			    right_layout:add(awful.titlebar.widget.closebutton(c))
			    
-- 			    -- The title goes in the middle
-- 			    --local middle_layout = wibox.layout.flex.horizontal()
-- 			    --local title = awful.titlebar.widget.titlewidget(c)
-- 			    --middle_layout:add(title)
-- 			    --middle_layout:buttons(buttons)
			    
-- 			    -- Now bring it all together
-- 			    local layout = wibox.layout.align.horizontal()
-- 			    layout:set_left(left_layout)
-- 			    layout:set_right(right_layout)
-- 			    --layout:set_middle(middle_layout)
-- 			    awful.titlebar(c):set_widget(layout)
-- 			    awful.titlebar.hide(c)
-- 			 --end
-- 				end)

-- -- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
-- 			 if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
-- 			 and awful.client.focus.filter(c) then
-- 			    client.focus = c
-- 			 end
-- end)

-- client.connect_signal("focus", function(c)
-- 			      c.border_color = beautiful.border_focus
-- 			      -- c.border_width = "10"
-- 			   end)
-- --client.connect_signal("property::geometry", function(c)
-- --			       local gx = c:geometry()["x"]
-- --			       local gy = c:geometry()["y"]
-- --			       local gh = c:geometry()["height"]
-- --			       if not mywibox[c] then
-- --				  mywibox[c] = awful.wibox({screen = c.screen, width = 20, height = gh, bg ="#FF00FF" })
-- --			       end
-- --			       mywibox[c]:geometry({ x = gx - 20, y = gy })
-- --			    end)

-- client.connect_signal("unfocus", function(c)
-- 				c.border_color = beautiful.border_normal
-- 				-- c.border_width = "1"
-- 			     end)
-- -- }}}
