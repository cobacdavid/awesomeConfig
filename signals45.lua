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
                         --
                         awful.titlebar.hide(c, beautiful.titlebar_premiere)
                         awful.titlebar.hide(c, beautiful.titlebar_seconde)
                         c.shape = arrondiMoyen
                         -- c.shape = octogonePetit
                         -- c.shape = pArrondiGros
                         -- c.shape = gears.shape.rounded_rect
                         local posx = c.x
                         local posy = c.y
                         local w = wibox({
                               x = posx,
                               y = posy,
                               width = c.width * .8,
                               height = c.height * .8,
                               visible = false,
                               ontop = true,
                               widget = couvertureW(c)
                                         }
                         )
                         c.mawibox = w
                      end
)

client.connect_signal("property::size",
                      function(c)
                         -- local geometrie = tostring(c.width) .. "x" .. tostring(c.height)
                         -- montre(geometrie)
                      end
)

client.connect_signal("request::titlebars",
                      function(c)
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
                         --
                         awful.titlebar(c,
                                        {size = beautiful.titlebar_epaisseur_premiere,
                                         position = beautiful.titlebar_seconde}
                         ):setup({
                               { -- Left
                                  awful.titlebar.widget.titlewidget(c),
                                  buttons = buttons,
                                  layout  = wibox.layout.fixed.horizontal
                               },
                               direction = "east",
                               layout =  wibox.container.rotate
                                })
                         awful.titlebar(c,
                                        {size = beautiful.titlebar_epaisseur_seconde,
                                         position = beautiful.titlebar_premiere}
                         ):setup({
                               { -- Left
                                  buttons = buttons,
                                  widget = screenshotW(c)
                                  --layout  = wibox.layout.fixed.horizontal
                               },
                               { -- Middle
                                  { -- Barre d'opacité
                                     align  = "center",
                                     widget = opacity_button(c),
                                     --widget = awful.titlebar.widget.titlewidget(c)
                                     --widget=separateur
                                  },
                                  layout  = wibox.layout.flex.horizontal
                               },
                               { -- Right
                                  --awful.titlebar.widget.floatingbutton (c),
                                  awful.titlebar.widget.maximizedbutton(c),
                                  --awful.titlebar.widget.stickybutton   (c),
                                  awful.titlebar.widget.ontopbutton    (c),
                                  killneufw(c),
                                  awful.titlebar.widget.closebutton    (c),
                                  dimension_button(c),
                                  --
                                  layout = wibox.layout.fixed.horizontal()
                               },
                               layout = wibox.layout.align.horizontal
                                })
                      end
)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter",
                      function(c)
                         if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                         and awful.client.focus.filter(c) then
                            client.focus = c
                         end
                         -- awful.spawn.easy_async_with_shell(
                         --    scrollBleu,
                         --    function (stdout,stderr,reason,exit_code)
                         
                         -- end)
                      end
)

client.connect_signal("mouse::leave",
                      function(c)
                         -- awful.spawn.easy_async_with_shell(
                         --    scrollBleu,
                         --    function (stdout,stderr,reason,exit_code)
                         
                         -- end)
                      end
)

client.connect_signal("focus",
                      function(c)
			 c.border_color = beautiful.border_focus
                         awful.titlebar.toggle(c, beautiful.titlebar_premiere)
                         awful.titlebar.toggle(c, beautiful.titlebar_seconde)

                         -- c.mawibox.visible = false
			 -- c.opacity=1
                      end
)

client.connect_signal("unfocus",
                      function(c)
			 c.border_color = beautiful.border_normal
                         awful.titlebar.hide(c, beautiful.titlebar_premiere)
                         awful.titlebar.hide(c, beautiful.titlebar_seconde)

			 -- c.opacity=0.3
			 -- c.mawibox.visible = true
                      end
)
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
