-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2022
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-- most parts from awesome wm
-- distribution
-- copyright ??
-------------------------------------------------
--
-- {{{ Wiboxes
-- Configuration de l'écran 2
s = screen[2]
--
-- ÉCRAN 2
--
awful.tag.add("Auxiliaire",
              {
                 layout = awful.layout.suit.tile.top,
                 screen = s,
                 selected = true,
                 gap = 5
              }
)

clo = wibox.widget {
   align = "center",
   format = "%A %d %B %Y %H:%M",
   widget = wibox.widget.textclock
}
s.mywibar = awful.wibar {
   screen = s ,
   bg = beautiful.bg_normal,
   widget = clo,
   position = "top",
   ontop = true,
   type = "dock",
   opacity = .75
}
--
s.mywibar:buttons(gears.table.join(
                     awful.button({}, 1,
                        function()
                           calendrier.calendrier {
                              width = 1100,
                              height = 900
                           }
                        end
                     )
))
--
s.versDroite = wibox {
   -- écran n°2 vertical 
   x       = largeurSecond - 1,
   y       = 0,
   height  = hauteurSecond - hauteurPremier,
   screen  = s ,
   width   = 1,
   bg      = couleurTheme,
   opacity = 0,
   ontop   = true,
   visible = true
}
s.versDroite:connect_signal("mouse::enter",
                            function(w)
                               mouse.coords {
                                  x = 1,
                                  y = mouse.coords().y
                               }
                            end
)
s.versGauche = wibox {
   x        = 0,
   y        = 0,
   screen   = s ,
   width    = 1,
   height   = hauteurSecond,
   bg       = couleurTheme,
   opacity  = 0,
   ontop    = true,
   visible  = true
}
s.versGauche:connect_signal("mouse::enter",
                            function(w)
                               if mouse.coords().y < hauteurSecond - hauteurPremier then
                                  mouse.coords {
                                     x = largeurSecond - 2,
                                     y = mouse.coords().y
                                  }
                               else
                                  mouse.coords {
                                     x = largeurPremier + largeurSecond - 2,
                                     y = mouse.coords().y
                                  }
                               end
                            end
)
--
--
dofile(config .. "/widgets/horlogeFormes/horlogeFormes.lua")
