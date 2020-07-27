-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-- most parts from awesome wm
-- distribution
-- copyright ??
-------------------------------------------------
--
-- {{{ Wiboxes
-- Configuration de l'écran principal
awful.screen.connect_for_each_screen(
    function(s)
        gears.wallpaper.set(beautiful.bg_normal)
        -- attention xrandr dicte sa loi du screen.primary selon
        -- l'interface !!
        --
        -- ÉCRAN PRINCIPAL
        --
        local layoutterm
        if s.index == 1 then
            if ordinateur == "desktop" then
                layoutterm = awful.layout.suit.tile.top
            else
                layoutterm = awful.layout.suit.tile.left
            end
            awful.tag.add("term",
                          {
                              layout = layoutterm,
                              screen = s,
                              selected = true,
                              gap = 5,
                              gap_single_client = true
                          }
            )
            awful.tag.add("www",
                          {
                              layout = awful.layout.suit.max,
                              screen = s,
                          }
            )
            awful.tag.add("divers",
                          {
                              layout = awful.layout.suit.tile,
                              screen = s,
                              gap = 5,
                              gap_single_client = true
                          }
            )
            awful.tag.add("travail",
                          {
                              layout = awful.layout.suit.floating,
                              screen = s,
                          }
            )
            awful.tag.add("Classe-1",
                          {
                              layout = awful.layout.suit.floating,
                              screen = s,
                          }
            )
            awful.tag.add("Classe-2",
                          {
                              layout = awful.layout.suit.floating,
                              screen = s,
                          }
            )
            awful.tag.add("dev",
                          {
                              layout = awful.layout.suit.floating,
                              screen = s,
                          }
            )
            --
            s.mypromptbox = awful.widget.prompt()
            --
            s.mywibar = awful.wibar(
                {
                    position = "top",
                    screen   = s,
                    height   = 30
                }
            )
            --
            local left_layout = wibox.layout.fixed.horizontal()
            if screen.count() <= 2 then 
                local heureW = heure({
                        width = 100,
                        justify = "center",
                        hr_format = "%H:%M",
                        actionLeft = function()
                            calendrier.calendrier({
                                    width = 1100,
                                    height = 900
                            })
                        end
                })
                left_layout:add(heureW)
            end
            --
            if ordinateur == "laptop" then
                left_layout:add(luminosite())
            else
                local sLevel = {}
                sLevel["HDMI-0"] = 1
                sLevel["VGA-0"]  = .85
                left_layout:add(luminositeEcran({
                                        startLevel = sLevel,
                }))
            end
            --
            left_layout:add(separateur())
            left_layout:add(volumemaster())
            left_layout:add(separateur())
            if ordinateur == "laptop" then
                left_layout:add(batt())
                left_layout:add(separateur())
            end
            left_layout:add(infos())
            left_layout:add(separateur())
            left_layout:add(chrono())
            left_layout:add(separateur())
            local ak = analog_clock({
                                    sectors      = 100,
                                    sector_angle = 1,
                                    inner_radius = 2, 
                                    line_width   = 1,
                                    -- fg           = "#ff0000",
                                    -- font_weight  = "CAIRO_FONT_WEIGHT_BOLD",
                                    -- font_size    = 28,
                                    text         = function(v, m, M)
                                        return " " --tostring(math.floor(v *100))
                                    end
            })
            gears.timer({
                    timeout   = 10,
                    call_now  = true,
                    autostart = true,
                    callback  = function()
                        local commande = "free |grep Mem"
                        awful.spawn.easy_async_with_shell(commande, function(stdout)
                                                              local total, used, free, shared, buff_cache, available
                                                                  = stdout:match('Mem:%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*')
                                                              -- fu.montre((total-free)/total)
                                                              ak:set_value((total - available)/total)
                        end)
                    end
            })
            left_layout:add(ak)
            left_layout:add(separateur())
            left_layout:add(s.mypromptbox)
            --
            local right_layout = wibox.layout.fixed.horizontal()
            right_layout:add(wibox.widget.systray())
            -- right_layout:add(wifi.new(s, "wlx7ca7b0bf524a", "Freebox-46CAFC_5Ghz"))
            --
            local layout = wibox.layout.align.horizontal()
            layout:set_left(left_layout)
            layout:set_right(right_layout)
            s.mywibar:set_widget(layout)
            --
            -- configuration pour DVI ou VGA à gauche de HDMI à la
            -- maison
            -- et HDMI à droite de eDP avec le portable
            --
            if screen.count() >= 2 and s.index == 1 then
                -- HDMI ou edP
                largeurPremier = s.geometry.width
                hauteurPremier = s.geometry.height
                -- DVI ou HDMI
                largeurSecond = screen[2].geometry.width
                hauteurSecond = screen[2].geometry.height
                --
                s.gauche = awful.wibar({
                        position = "left",
                        screen = s,
                        width = 1,
                        opacity = 0,
                        ontop = true,
                        -- bg      = beautiful.noir,
                })
                s.gauche:connect_signal("mouse::enter",
                                        function(w)
                                            mouse.coords({
                                                    x = largeurPremier + largeurSecond - 2,
                                                    y = mouse.coords().y
                                            })
                                        end
                )
            end
        end
        -- -- --
        -- ÉCRAN SECONDAIRE (potentiellement virtuel)
        -- -- --
        if s.index == 2 then
            --
            largeurPremier = screen[1].geometry.width
            hauteurPremier = screen[1].geometry.height
            largeurSecond = s.geometry.width
            hauteurSecond = s.geometry.height
            --
            awful.tag.add("Auxiliaire",
                          {
                              layout = awful.layout.suit.floating,
                              screen = s,
                              selected = true
                          }
            )
            if screen.count() == 2 then
                clo = wibox.widget {
                    align = "center",
                    widget = wibox.widget.textclock("%A %d %B %Y")
                }
                s.mywibar = awful.wibar({
                        screen = s ,
                        bg = beautiful.bg_normal,
                        widget = clo,
                        position = "top",
                        ontop = false,
                        type = "dock",
                        opacity = .75
                })
                --
                s.mywibar:buttons(gears.table.join(
                                      awful.button({}, 1,
                                          function()
                                              calendrier.calendrier({
                                                      width = 1100,
                                                      height = 900
                                              })
                                          end
                                      )
                ))
                -- nouvel écran à droite du premier
                s.droiteLaptop = awful.wibar({
                        position = "right",
                        screen = s ,
                        width = 1,
                        -- bg       = beautiful.noir,
                        opacity = 0,
                        ontop = true
                })
                s.droiteLaptop:connect_signal("mouse::enter",
                                              function(w)
                                                  mouse.coords({
                                                          x = 2,
                                                          y = mouse.coords().y
                                                  })
                                              end
                )
            end
        end
        -- -- --
        -- ÉCRAN 3 (potentiellement sur le secondaire et virtuel)
        -- -- --
        if s.index == 3 then
            --
            largeurPremier = screen[1].geometry.width
            hauteurPremier = screen[1].geometry.height
            largeurSecond  = screen[2].geometry.width
            hauteurSecond  = screen[2].geometry.height
            largeurTroism  = s.geometry.width
            hauteurTroism  = s.geometry.height
            --
            awful.tag.add("Auxiliaire",
                          {
                              layout = awful.layout.suit.floating,
                              screen = s,
                              selected = true
                          }
            )
            s.droiteLaptop = awful.wibar({
                    position = "right",
                    screen   = s,
                    width    = 1,
                    height   = hauteurTroism,
                    bg       = beautiful.bg_normal, -- "#ffff00"
                    opacity  = 1,
                    ontop    = true
            })
            --
            s.mywibar = awful.wibar({
                    screen   = s ,
                    position = "top",
                    width    = largeurTroism - 1,
                    bg       = beautiful.bg_normal, --"#ff0000"
                    height   = 270,
                    opacity = 1
            })
            s.droiteLaptop.y = 840
            --s.droiteLaptop.height = hauteurTroism
            local layout = wibox.layout.fixed.vertical()
            layout.spacing = 80
            --
            local clock = bigC.bigClock({
                    font   = "Northwood High",--"HP15C Simulator Font",
                    screen       = s,
                    size         = 45,
                    border_width = 2,
                    height       = 80,
                    width        = largeurTroism - 1
            })
            -- inhibit default behaviour
            clock:buttons(gears.table.join(
                              awful.button({ }, 1, function()
                              end)
            ))
            layout:add({
                    clock.rp,
                    layout =  wibox.layout.align.vertical
            })
            
            local cal = calendrierMois.cal({font_size =8})
            layout:add({
                    cal,
                    layout =  wibox.layout.align.vertical
            })
            
            s.mywibar:set_widget(layout)
            --
            s.droiteLaptop:connect_signal("mouse::enter",
                                          function(w)
                                              mouse.coords({
                                                      x = 2,
                                                      y = mouse.coords().y
                                              })
                                          end
            )
        end
    end
)

