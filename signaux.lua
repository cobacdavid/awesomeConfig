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
                          c.border_width = 3
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
                                  size = 30,
                                  position = "bottom"
                              }
                          )
                          barreBas:setup(
                              {
                                  {
                                      c.titre,
                                      separateur(),
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
                                      secretFenetre(c, {px        = 100,
                                                        nb        = true,
                                                        minNuance = 0,
                                                        maxNuance = 20}),
                                      separateur(),
                                      dimFenetre(c),
                                      separateur(),
                                      tempsPasse(c),
                                      separateur(),
                                      screenshot(c),
                                      awful.titlebar.widget.stickybutton(c),
                                      awful.titlebar.widget.ontopbutton(c),
                                      awful.titlebar.widget.maximizedbutton(c),
                                      awful.titlebar.widget.closebutton(c),
                                      killneuf(c),
                                      layout = wibox.layout.fixed.horizontal()
                                  },
                                  layout = wibox.layout.align.horizontal
                              }
                          )
                                           end
)


client.connect_signal("mouse::leave",
                      function(c)
                          c:emit_signal("unfocus")
                          -- if ordinateur == "desktop" and (c.class == editorClass or c.class == terminalClass) then
                          --     fu.commande_execute(clavierCmd .. " " .. configAwesome)
                          -- end
                          
                          -- ci-dessous ne fonctionne pas
                          c.border_color = beautiful.border_color_normal
                      end
)

client.connect_signal("focus",
                      function(c)
                          if not c.blocage then
                              c.opacity = 1
                          end
                          c.border_color = beautiful.border_color_active
                          c.border_width = 3
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

client.connect_signal("mouse::enter",
                      function(c)
                          c:emit_signal("request::activate", "mouse_enter", {raise = false})
                          --
                          --c:activate {
                          --    context = "mouse_enter",
                          --    raise = true
                          --}
                          --
                          c:emit_signal("focus")
                          --
                          -- if ordinateur == "desktop" and c.class == editorClass then
                          --     fu.commande_execute(clavierCmd .. " " .. configEmacs)
                          -- end
                          -- if ordinateur == "desktop" and c.class == terminalClass then
                          --     fu.commande_execute(clavierCmd .. " " .. configUrxvt)
                          -- end
                          --
                      end
)

client.connect_signal("unfocus",
                      function(c)
                          -- c.border_color = beautiful.border_color_normal
                          --
                          if not c.blocage then
                              -- c.timer_opacity = gears.timer({
                              --         timeout  = 10,
                              --         autostart = true,
                              --         single_shot = true,
                              --         callback = function()
                              --                 c.opacity = .3
                              --         end
                              -- })
                              c.opacity = 0.8
                          end
                          c.border_color = beautiful.border_color_normal
                          c.border_width = 1
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
                       -- local indicateur_clavier = "python3 /home/david/travail/david/production/lycee/algorithmique/python/drevo/examples/selectionTag/selectionTag.py " .. tostring(t.index)
                       -- fu.montre(indicateur_clavier)
                       -- awful.spawn.easy_async_with_shell()
                       -- fu.commandeExecute(indicateur_clavier)
                       --
                       -- change screen1 wallpaper according to
                       -- tag.name, one unique tag on screen2 so no
                       -- change on screen2
                       -- if tag.viewprev|next event -> screen1 change
                       local rep = "/tmp/"
                       gears.wallpaper.maximized(rep .. t.name .. ".png", t.screen)
                   end
)

