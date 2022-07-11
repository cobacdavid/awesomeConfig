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
for s in screen do
    gears.wallpaper.set(beautiful.bg_normal)
    -- attention xrandr dicte sa loi du screen.primary selon
    -- l'interface !!
    --
    -- ÉCRAN PRINCIPAL
    --
    local layoutterm
    if ordinateur ~= "laptop" then
        -- nouvel écran à droite du premier
        if s.index == 1 then
             s.versDroite = wibox({
                    -- écran n°2 vertical 
                    x       = largeurSecond + largeurPremier - 1,
                    y       = hauteurSecond - hauteurPremier,
                    height  = hauteurPremier,
                    screen  = s ,
                    width   = 1,
                    bg      = "#f0f",
                    opacity = 0,
                    ontop   = true,
                    visible = true
            })
            s.versDroite:connect_signal("mouse::enter",
                                        function(w)
                                            mouse.coords({
                                                    x = 1,
                                                    y = mouse.coords().y
                                            })
                                        end
            )
        end
        if s.index == 2 then
            s.versDroite = wibox({
                    -- écran n°2 vertical 
                    x       = largeurSecond - 1,
                    y       = 0,
                    height  = hauteurSecond - hauteurPremier,
                    screen  = s ,
                    width   = 1,
                    bg      = "#f0f",
                    opacity = 0,
                    ontop   = true,
                    visible = true
            })
            s.versDroite:connect_signal("mouse::enter",
                                        function(w)
                                            mouse.coords({
                                                    x = 1,
                                                    y = mouse.coords().y
                                            })
                                        end
            )
            s.versGauche = wibox({
                    x        = 0,
                    y        = 0,
                    screen   = s ,
                    width    = 1,
                    height   = hauteurSecond,
                    bg       = "#f0f",
                    opacity  = 0,
                    ontop    = true,
                    visible  = true
            })
            s.versGauche:connect_signal("mouse::enter",
                                        function(w)
                                            if mouse.coords().y < hauteurSecond - hauteurPremier then
                                                mouse.coords({
                                                        x = largeurSecond - 2,
                                                        y = mouse.coords().y
                                                })
                                            else
                                                mouse.coords({
                                                        x = largeurPremier + largeurSecond - 2,
                                                        y = mouse.coords().y
                                                })
                                            end
                                        end
            )
        end
    end
    --
    --
    if s.index == 1 then
        if ordinateur == "desktop" and ecrans ~= "configuration1" then
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
        awful.tag.add("net",
                      {
                          layout = awful.layout.suit.floating,
                          screen = s,
                      }
        )
        awful.tag.add("fichiers",
                      {
                          layout = awful.layout.suit.tile,
                          screen = s,
                          gap = 5,
                          gap_single_client = true
                      }
        )
        awful.tag.add("travail",
                      {
                          layout = awful.layout.suit.fair,
                          screen = s,
                      }
        )
        --
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
        --
        if screen.count() <= 2 then 
            local heureW = heure({
                    width = 80,
                    justify = "center",
                    hr_format = "%H:%M",
                    actionLeft = function()
                        calendrier.calendrier({
                                width = 1100,
                                height = 900
                        })
                    end
            })
            -- left_layout:add(heureW)
            local dateW = madate({
                    width = 35,
                    justify = "center",
                    actionLeft = function()
                        calendrier.calendrier({
                                width = 1100,
                                height = 900
                        })
                    end
            })
            left_layout:add(dateW)
        end
        --
        if ordinateur == "laptop" or ordinateur == "masterNSI" then
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
        left_layout:add(volumemaster({
                                text = "volume"
        }))
        left_layout:add(separateur())
        if ordinateur == "laptop" or ordinateur == "masterNSI" then
            if ordinateur == "masterNSI" then
                local bat_cmd = "cat /sys/class/power_supply/BAT1/capacity"
            else
                local bat_cmd = "cat /sys/class/power_supply/BAT0/capacity"
            end
            battwm = wmatrice({
                    -- la commande peut être avec BAT1
                    COMMANDE = 'bash -c "' .. bat_cmd .. '"',
                    title = '<b>batt</b>',
                    from_color = "#f00",
                    to_color = "#0f0"
                    --                    fun = function(s)
                    --                        return valeur
                    --                    end
            })
            left_layout:add(battwm)
            left_layout:add(separateur())
        end
        left_layout:add(separateur())
        local twm = wmatrice({
                -- la commande nécessite lm-sensors
                COMMANDE = [[ bash -c "sensors | grep Package | cut -d \" \" -f 5-6" ]],
                title = '<b>CPU °C</b>',
                fun = function(s)
                    local valeur = s:match("%d+")
                    return valeur
                end
        })
        left_layout:add(twm)
        left_layout:add(separateur())
        local rwm = wmatrice({
                COMMANDE = 'bash -c "free | grep Mem"',
                title = '<b>RAM %</b>',
                fun = function(s)
                    local total, used, free, shared, buff_cache, available
                        = s:match('Mem:%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*')
                    local valeur = math.floor(100 * (total - available)/total + .5)
                    return valeur
                end
        })
        left_layout:add(rwm)
        left_layout:add(separateur())
        --
        if ordinateur == "desktop" then
            local dtv2 = dtv2.worker({
                    square_size  = 3.6,
                    json_path    = "/home/david/travail/david/production/lycee/informatique/modules_perso/drevo/examples/dtv2reader",
            })
            left_layout:add(dtv2)
        end
        --
        local couleurFondVide = "#fff2"
        --
        if ordinateur ~= "masterNSI" then
            local mto = weather_widget({
                    api_key     = idMeteo.api_key,
                    coordinates = {47.4667, -0.55},
                    time_format_12h = false,
                    units = 'metric',
                    both_units_widget = false,
                    font_name = 'Carter One',
                    icons = 'VitalyGorbachev',
                    icons_extension = '.svg',
                    show_hourly_forecast = true,
                    show_daily_forecast = true,
            })
            left_layout:add(mto)
            --
            left_layout:add(separateur())
        end
        --
        left_layout:add(chrono())
        left_layout:add(separateur())
        local fichierPath = "/home/david/travail/david/production/lycee"
        local fic = fichiers({
                path                 = fichierPath,
                color_of_empty_cells = couleurFondVide,
                year                 = os.date("%Y"),
                n_colors             = 10,
                from_color           = "#00ff00",
                to_color             = "#0000ff",
                text                 = ""
        })
        left_layout:add(fic)
        if ordinateur ~= "masterNSI" then
            fic:add_button(
                awful.button({}, 1,
                    function()
                        awful.spawn(fileMgr .. " " .. fichierPath)
                    end
                )
            )
        end
        left_layout:add(separateur())
        --
        --
        if ordinateur == "desktop" then
            local lfm = lastfm({
                    year                 = os.date("%Y"),
                    theme                = "gradient",
                    square_size          = 4,
                    with_border          = true,
                    color_of_empty_cells = couleurFondVide,
                    n_colors             = 10,
                    from_color           = "#00ff00",
                    to_color             = "#0000ff"
            })

            lfm:add_button(
                awful.button({}, 2,
                    function()
                        awful.spawn(browser .. " " ..
                                    "https://last.fm/user/" ..  lastfm.username)
                    end
                )
            )
            left_layout:add(lfm)
            left_layout:add(separateur())
            -- local polar_id = require("widgets.polar.polar_id")
            -- local plr = polar({
            --         polar_id             = polar_id,
            --         color_of_empty_cells = couleurFondVide,
            --         from_color           = "#00ff00",
            --         to_color             = "#0000ff",
            --         -- from_date            = "20201014",
            --         year                 = os.date("%Y"),
            --         n_colors             = 5
            -- })
            -- plr:add_button(
            --     awful.button({}, 1,
            --         function()
            --             awful.spawn(fileMgr .. " " .. "/home/david/Polar/" .. polar_id .. "/U/0")
            --         end
            --     )
            -- )
            -- left_layout:add(plr)
            -- left_layout:add(separateur())
        end
        --
        --
        mypromptbox = awful.widget.prompt()
        if ordinateur ~= "masterNSI" then
            mypromptbox:add_button(
                awful.button({}, 2,
                    function()
                        mypromptbox.widget:set_text("OK")
                    end
                )
            )
        end
        left_layout:add(mypromptbox)
        left_layout:add(separateur())
        --
        --
        local right_layout = wibox.layout.fixed.horizontal()
        local gcw_id =  "cobacdavid"
        if ordinateur == "matserNSI" then
            gcw_theme = "standard"
        else
            gcw_theme = "standard2"
        end
        
        local gcw = github_contributions_widget({
                username             = gcw_id,
                theme                = gcw_theme,
                with_border          = true,
                square_size          = 4,
                color_of_empty_cells = couleurFondVide,
                days                 = 365
        })
        if ordinateur ~= "masterNSI" then
            gcw:add_button(
                awful.button({}, 1,
                    function()
                        awful.spawn(browser .. " " .. "https://github.com/" .. gcw_id)
                    end
                )
            )
        end
        right_layout:add(gcw)
        right_layout:add(separateur())
        --
        if ordinateur == "desktop" then
            -- local cvd = covid.worker({
            --          departement          = "Maine-et-Loire",
            --          theme                = "gradient",
            --          square_size          = 4,
            --          with_border          = true,
            --          color_of_empty_cells = "#fff2",
            --          n_colors             = 10,
            --          -- from_date            = os.date("%Y").. "0101"
            -- })
            -- cvd:add_button(
            --         awful.button({}, 1,
            --              function()
            --                  awful.spawn(browser .. " " .. "https://covidtracker.fr/")
            --              end
            --         )
            -- )
            -- right_layout:add(cvd)
            -- right_layout:add(separateur())
            --
            local cvdv2 = covidv2.worker({
                    departement          = "Maine-et-Loire",
                    theme                = "gradient",
                    square_size          = 4,
                    with_border          = true,
                    color_of_empty_cells = couleurFondVide,
                    n_colors             = 15,
                    from_date            = os.date("%Y").. "0101"
            })
            cvdv2:add_button(
                awful.button({}, 1,
                    function()
                        awful.spawn(browser .. " " .. "https://covidtracker.fr/")
                    end
                )
            )
            right_layout:add(cvdv2)
        end
        --
        --
        -- from https://pavelmakhov.com/2018/01/hide-systray-in-awesome/
        my_systray = wibox.widget.systray()
        my_systray.visible = false
        right_layout:add(my_systray)
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
        if (screen.count() >= 2) and (ecrans ~= "configuration1") then
            -- deux écrans sur le portable
            s.topGauche = wibox({
                    x = 0,
                    y = 0,
                    width = 1,
                    height = hauteurPremier - hauteurSecond,
                    screen = s,
                    opacity = 0,
                    ontop = true,
                    visible = true,
                    bg      = "#ff0"
            })
            s.topGauche:connect_signal("mouse::enter",
                                       function(w)
                                           mouse.coords({
                                                   x = largeurPremier - 2,
                                                   y = mouse.coords().y
                                           })
                                       end
            )
            s.topDroit = wibox({
                    x = largeurPremier - 1,
                    y = 0,
                    width = 1,
                    height = hauteurPremier - hauteurSecond,
                    screen = s,
                    opacity = 0,
                    ontop = true,
                    visible = true,
                    bg      = "#fff"
            })
            s.topDroit:connect_signal("mouse::enter",
                                      function(w)
                                          mouse.coords({
                                                  x = 2,
                                                  y = mouse.coords().y
                                          })
                                      end
            )
            s.bottomGauche = wibox({
                    x = 0,
                    y = hauteurPremier - hauteurSecond,
                    width = 1,
                    height = hauteurSecond,
                    screen = s,
                    opacity = 0,
                    ontop = true,
                    visible = true,
                    bg      = "#ff0"
            })
            s.bottomGauche:connect_signal("mouse::enter",
                                          function(w)
                                              mouse.coords({
                                                      x = largeurPremier + largeurSecond- 2,
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
        awful.tag.add("Auxiliaire",
                      {
                          -- layout = awful.layout.suit.floating,
                          layout = awful.layout.suit.tile.top,
                          screen = s,
                          selected = true,
                          gap = 5
                      }
        )
        if screen.count() == 2 then
            clo = wibox.widget {
                align = "center",
                widget = wibox.widget.textclock("%A %d %B %Y %H:%M")
            }
            s.mywibar = awful.wibar({
                    screen = s ,
                    bg = beautiful.bg_normal,
                    widget = clo,
                    position = "top",
                    ontop = true,
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
        end
        -- -- --
        -- ÉCRAN 3 (potentiellement sur le secondaire et virtuel)
        -- -- --
        if s.index == 3 then
            --
            gears.wallpaper.set(gears.color(beautiful.bg_normal))
            --
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
            --
            s.droiteLaptop = wibox({
                    x        = largeurPremier + largeurSecond + largeurTroism - 1,
                    y        = hauteurPremier - hauteurSecond,
                    width    = 1,
                    height   = hauteurTroism,
                    screen   = s,
                    bg       = beautiful.bg_normal, -- "#ffff00"
                    opacity  = 0,
                    visible  = true,
                    ontop    = true
            })
            --
            s.anaC = wibox({
                    x        = largeurPremier + largeurSecond,
                    y        = hauteurPremier - hauteurSecond,
                    width    = largeurTroism - 1,
                    height   = largeurTroism - 1,
                    visible  = true,
                    screen   = s ,
                    bg       = beautiful.bg_normal, --"#ff0000"
                    opacity  = 1
            })
            local layout = wibox.layout.fixed.vertical()
            --
            local anaC = semi_analog_clock({
                    font         = "Northwood High",
                    inner_radius = 80,
                    --angle_offset = 10,
                    sectors      = 59,
                    --color_type   = "solid"
            })
            -- layout:add(anaC)
            local aaC = almost_analog_clock({delay = 1})
            layout:add(aaC)
            s.anaC:set_widget(layout)
            --
            
            -- --
            -- local clock = bigC({
            --         font   = "Northwood High",--"HP15C Simulator Font",
            --         size         = 45,
            --         border_width = 2,
            --         height       = 80,
            --         -- width        = largeurTroism - 1
            -- })
            -- -- inhibit default behaviour
            -- clock:buttons(gears.table.join(
            --                   awful.button({ }, 1, function()
            --                   end)
            -- ))
            -- layout:add(clock)
            --
            --
            s.cal = wibox({
                    x        = largeurPremier + largeurSecond,
                    y        = hauteurPremier - hauteurSecond + largeurTroism - 1,
                    width    = largeurTroism - 1,
                    height   = largeurTroism - 1,
                    visible  = true,
                    screen   = s ,
                    bg       = beautiful.bg_normal, --"#ff0000"
                    opacity  = 1
            })
            local layout = wibox.layout.fixed.vertical()
            local cal = calendrierMois.cal({font_size = 8})
            layout:add(cal)
            --
            s.cal:set_widget(layout)
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
end


-- left_layout:add(infos())
-- left_layout:add(separateur())
-- local ak = flower_pbar({
--         sectors      = 5,
--         sector_angle = 68,
--         inner_radius = 7, 
--         line_width   = 1,
--         fg           = "#fff",
--         color        = "#fff",
--         color_type   = "solid",
--         font_weight  = "CAIRO_FONT_WEIGHT_BOLD",
--         font_size    = 9,
--         text         = function(v, m, M)
--             return tostring(math.floor(v *100))
--         end
-- })
-- gears.timer({
--         timeout   = 10,
--         call_now  = true,
--         autostart = true,
--         callback  = function()
--             local commande = "free |grep Mem"
--             awful.spawn.easy_async_with_shell(
--                 commande, function(stdout)
--                     local total, used, free, shared, buff_cache, available
--                         = stdout:match('Mem:%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*')
--                     -- fu.montre((total-free)/total)
--                     ak:set_value((total - available)/total)
--             end)
--         end
-- })
-- left_layout:add(ak)
--left_layout:add(ram({
--                        rect_width = 2,
--                        rect_height = 6
--}))
--left_layout:add(separateur())
--left_layout:add(tempM({
--                        rect_width = 2,
--                        rect_height = 6
--}))
