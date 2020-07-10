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
-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
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
                         c.shape = fu.pArrondiGros
end)

client.connect_signal("tagged", function (c)
                         fu.surTermOuPas(c)
                         --
                         -- bloque à 1 l'opacité des PDF sur
                         -- l'écran auxiliaire
                         if (c.class == "Evince" and c.screen.index == 2) then
                            c.opacity = 1
                            c.bo.text = "B"
                            c.blocage = true
                         end
end)
--
client.connect_signal("unmanage", function(c)
                         local n = mouse.object_under_pointer()
                         if n and n ~= client.focus and type(n) == "client" then
                            client.focus = n
                         end
end)
--
client.connect_signal("request::titlebars",function(c)
                         if not c.titre then
                            c.titre = titreClient(c, {
                                                     limit = 30,
                                                     callback = function(titre)
                                                        if titre then
                                                           if string.match(titre, "emacs") then
                                                              titre = "emacs, what else?"
                                                           elseif string.match(titre, "david@") then
                                                              titre = "Home sweet home"
                                                           else
                                                              titre = titreClient.raccourcirTitre(titre)
                                                           end
                                                           return titre
                                                        end
                                                     end
                            })
                         end
                         -- pour régler les clients PDF sur l'écran
                         -- auxiliaire
                         c.bo = blocageopacite(c)
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
                               -- { 
                               --    {
                               --       text = "    ",
                               --       widget = wibox.widget.textbox,
                               --    },
                               --    wibox.widget({
                               --          {
                               --             image  = beautiful.grip,
                               --             resize = true,
                               --             widget = wibox.widget.imagebox,
                               --          },
                               --          awful.titlebar.widget.titlewidget(c),
                               --          --c.tb,
                               --          layout  = wibox.layout.stack,
                               --    }),
                               --    buttons = buttons,
                               --    layout  = wibox.layout.fixed.horizontal
                               -- }
                               -- ,
                               {
                                  c.titre,
                                  --buttons = buttons,
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
                                  secretFenetre(c, {px = 50, nb = true}),
                                  separateur(),
                                  -- wibox.widget {
                                  --    {
                                  --       image  = beautiful.grip,
                                  --       resize = true,
                                  --       widget = wibox.widget.imagebox
                                  --    },
                                     dimFenetre(c, {
                                                   font = "Inconsolata"
                                     }),
                                  --    layout  = wibox.layout.stack,
                                  -- },
                                  separateur(),
                                  tempsPasse(c, {
                                                font="Inconsolata"
                                  }),
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
                         --
                         c:emit_signal("focus")
                         --
                         if ordinateur == "desktop" and c.class == editorClass then
                            fu.commande_execute(clavierCmd .. " " .. configEmacs)
                         end
                         if ordinateur == "desktop" and c.class == terminalClass then
                            fu.commande_execute(clavierCmd .. " " .. configUrxvt)
                         end
                         --
                          c.border_color = beautiful.border_focus
                         --
                         --
                      end
)

client.connect_signal("mouse::leave",
                      function(c)
                         c:emit_signal("unfocus")
                         if ordinateur == "desktop" and (c.class == editorClass or c.class == terminalClass) then
                            fu.commande_execute(clavierCmd .. " " .. configAwesome)
                         end
                      end
)

client.connect_signal("focus",
                      function(c)
			if not c.blocage then
                            c.opacity = 1
                         end
                      end
)

client.connect_signal("button::press",
                      function(c)
                         c:emit_signal("focus")
                      end
)

client.connect_signal("request::activate",
                      function(c)
			if not c.blocage then
                            c.opacity = 1
                         end
                      end
)

client.connect_signal("unfocus",
                      function(c)
			 c.border_color = beautiful.border_normal
                         --
                         if not c.blocage then
                            c.opacity = 0.5
                         end
                      end
)

tag.connect_signal("property::selected",
                   function(t)
                      if #listeChgTag == 0
                      or t ~= listeChgTag[#listeChgTag] then
                         chgTag = chgTag + 1
                         table.insert(listeChgTag, t)
                      end
                      --
                      -- change screen1 wallpaper according to
                      -- tag.name, one unique tag on screen2 so no
                      -- change on screen2
                      -- if tag.viewprev|next event -> screen1 change
                      local rep = "/tmp/"
                      gears.wallpaper.maximized(rep .. t.name .. ".png", t.screen)
                   end
)

