s = screen[3]


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
