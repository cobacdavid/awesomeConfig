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
--
-- TAGS/TASK BUTTONS
--
local taglist_buttons = gears.table.join(
   awful.button({}, 1,
      function(t)
         t:view_only()
      end
   ),
   awful.button({modkey}, 1,
      function(t)
	 if client.focus then
	    client.focus:move_to_tag(t)
	 end
      end
   ),
   awful.button({}, 3, awful.tag.viewtoggle),
   -- awful.button({modkey}, 3,
   --    function(t)
   --       if client.focus then
   --          client.focus:toggle_tag(t)
   --       end
   --    end
   -- ),
   awful.button({}, 4,
      function(t)
         awful.tag.viewnext(t.screen)
      end
   ),
   awful.button({}, 5,
      function(t)
         awful.tag.viewprev(t.screen)
      end
   )
)

-- {{{ Wiboxes
-- Configuration de l'écran principal
--local s=screen.primary
awful.screen.connect_for_each_screen(
   function(s)
      -- attention xrandr dicte sa loi du screen.primary selon
      -- l'interface !!
      gears.wallpaper.set(beautiful.wallpaperTagPrincipal)
      if s.index == 1 then
         local layoutterm = ""
         if ordinateur == "maison" then
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
         -- awful.tag.add("STL-7",
         --               {
	 --        	  layout = awful.layout.suit.floating,
	 --        	  screen = s,
         --               }
         -- )
         -- awful.tag.add("ST2S-8",
         --               {
	 --        	  layout = awful.layout.suit.floating,
	 --        	  screen = s,
         --               }
         -- )
         -- awful.tag.add("NSI-9",
         --               {
	 --        	  layout = awful.layout.suit.floating,
	 --        	  screen = s,
         --               }
         -- )
         --
         --
	 s.mypromptbox = awful.widget.prompt()
         --
	 -- s.mytaglist = awful.widget.taglist(
         --    {
         --       screen = s,
         --       filter = awful.widget.taglist.filter.all,
         --       buttons = taglist_buttons
         --    }
         -- )
         --
         --
	 s.mywibar = awful.wibar(
            {
               position = "top",
               screen = s,
               height = 30           
            }
         )
	 --
	 local left_layout = wibox.layout.fixed.horizontal()
	 left_layout:add(heure({justify="left"}))
	 -- left_layout:add(s.mytaglist)
         --
	 if ordinateur == "asus" then
            left_layout:add(luminosite())
         else
            left_layout:add(luminosite_ecran({iface=ecranPcp}))
         end
         --
	 left_layout:add(separateur())
	 left_layout:add(volumemaster())
	 left_layout:add(separateur())
         left_layout:add(luminosite_ecran({iface=ecranAux}))
         left_layout:add(separateur())
         if ordinateur == "asus" then
            left_layout:add(batt())
            left_layout:add(separateur())
         end
         left_layout:add(infos())
	 left_layout:add(separateur())
	 left_layout:add(s.mypromptbox)
         if ordinateur == "asus" then
            -- left_layout:add(car)
         end
         --
	 local right_layout = wibox.layout.fixed.horizontal()
	 right_layout:add(wibox.widget.systray())
	 --
	 local layout = wibox.layout.align.horizontal()
	 layout:set_left(left_layout)
	 layout:set_right(right_layout)
	 s.mywibar:set_widget(layout)
	 -- s.mywibox:buttons(gears.table.join(
	 --        	      awful.button({}, 4,
         --                         function()
	 --        		    pcall( function() incBtVolume(2) end )
	 --        		    -- awful.util.spawn( amixerplus )
         --                         end
         --                      ),
	 --        	      awful.button({}, 5,
         --                         function()
	 --        		    pcall( function() incBtVolume(-2) end ) 
	 --        		    -- awful.util.spawn( amixermoins )
         --                         end
         --                      )
	 -- ))
         --
         -- configuration pour DVI ou VGA à gauche de HDMI à la
         -- maison
         -- et HDMI à droite de eDP avec le portable
         if screen:count() == 2 then
            -- HDMI ou edP
            largeurPremier = s.geometry.width
            hauteurPremier = s.geometry.height
            -- DVI ou HDMI
            largeurSecond = screen[2].geometry.width
            hauteurSecond = screen[2].geometry.height
            --
            if ordinateur == "asus" then
               s.gaucheAsus = awful.wibar(
                  {
                     position = "left",
                     screen = s,
                     width = 1,
                     opacity = 0,
                     ontop = true,
                     -- bg      = beautiful.noir,
                  }
               )
               s.gaucheAsus:connect_signal("mouse::enter",
                                           function(w)
                                             mouse.coords({
                                                   x = largeurPremier + largeurSecond - 2,
                                                   y = mouse.coords().y
                                             })
                                          end
               )
            elseif ordinateur == "maison" then
               s.myjumpbox = awful.wibar(
                  {
                     position = "left",
                     screen = s,
                     width = 1,
                     opacity = 0,
                     ontop = true,
                     -- bg      = beautiful.noir,
                  }
               )
               s.myjumpbox:connect_signal("mouse::enter",
                                          function(w)
                                             mouse.coords({
                                                   x = 1200 + 1800,
                                                   y = mouse.coords().y
                                             })
                                          end
               )
            end
         end
      end
      -- -- --
      -- configuration écran supplémentaire
      -- -- --
      if s.index == 2 then
         --
         function decorate(w, flag, date)
            local ret = wibox.widget(
               {
                  {
                     w,
                     widget  = wibox.container.margin
                  },
                  fg           = "#999999",
                  bg           = "#000000",
                  widget       = wibox.container.background
               }
            )
            return ret
         end
         calendrier = wibox.widget(
            {
               fn_embed = decorate,
               widget = wibox.widget.calendar.month
            }
         )
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
	 clo = wibox.widget {
            align = "center",
	    widget = wibox.widget.textclock("%A %d %B %Y")
         }
         -- calendrier:attach(clo, 'tc', {on_hover=false})
         s.mywibar = awful.wibar(
            {
               screen = s ,
               bg = beautiful.noir,
               widget = clo,
               position = "top",
               ontop = false,
               type = "dock",
               opacity = .75
            }
         )
         -- nouvel écran à droite du premier
         if ordinateur == "asus" then
            s.droiteAsus = awful.wibar(
               {
                  position = "right",
                  screen = s ,
                  width = 1,
                  -- bg       = beautiful.noir,
                  opacity = 0,
                  ontop = true
               }
            )
            s.droiteAsus:connect_signal("mouse::enter",
                                       function(w)
                                          if screen:count() == 2 then
                                             -- à adapter si au lycée
                                             -- à la résolution de l'écran 
                                             mouse.coords({
                                                   x = 2,
                                                   y = mouse.coords().y
                                             })
                                          else
                                             -- 3 écrans (le dernier est vertical)
                                             -- on agit proportionnellement
                                             --
                                             -- calcul de la distance au bord haut
                                             dbh = 300
                                             --
                                             -- à modifier !!!
                                             mouse.coords({
                                                   x = 1440 + 1920 + 900 - 2 ,
                                                   y =  ( mouse.coords().y - dbh ) * 1440 / 900
                                             })
                                          end
                                       end
            )
         -- nouvel écran à gauche du premier
         elseif ordinateur == "maison" then
            s.myjumpbox = awful.wibar(
               {
                  position = "right",
                  screen = s ,
                  width = 1,
                  -- bg       = beautiful.noir,
                  opacity = 0,
                  ontop = true
               }
            )
            s.myjumpbox:connect_signal("mouse::enter",
                                       function(w)
                                          if screen:count() == 2 then
                                             -- à adapter si au lycée
                                             -- à la résolution de l'écran 
                                             mouse.coords({
                                                   x = 2, -- largeurPremier + largeurSecond - 2,
                                                   y = mouse.coords().y
                                             })
                                          else
                                             -- 3 écrans (le dernier est vertical)
                                             -- on agit proportionnellement
                                             --
                                             -- calcul de la distance au bord haut
                                             dbh = 300
                                             --
                                             -- à modifier !!!
                                             mouse.coords({
                                                   x = 1440 + 1920 + 900 - 2 ,
                                                   y =  ( mouse.coords().y - dbh ) * 1440 / 900
                                             })
                                          end
                                       end
            )
         end
      end

      
      -- troisième écran
      -- Rappel de la commande dans ~/.Xsession
      -- xrandr --output HDMI-0 --primary --mode 1920x1200 --pos 1440x0
      -- >> --output DVI-0 --mode 1440x900 --pos 0x300 --rotate normal
      -- >> --output VGA-0  --mode 1440x900 --pos 3360x0 --rotate left
      -- if s.index == 3 then
      --    awful.tag.add("Auxiliaire", {
      --   		  layout             = awful.layout.suit.floating,
      --   		  screen             = s,
      --    })
      --    local clo=wibox.widget {
      --       align = "center",
      --       widget = wibox.widget.textclock(" %A %d %B %Y ")
      --    }
      --    s.mywibox = awful.wibar({
      --          screen = s ,
      --          bg = beautiful.noir,
      --          widget=clo,
      --          position = "top",
      --          ontop = false,
      --          type = "dock"
      --    })
      --    s.myjumpbox = awful.wibar({
      --          position = "right",
      --          screen   = s ,
      --          width    = 1,
      --          -- bg       = beautiful.noir,
      --          opacity  = 0,
      --          ontop    = true
      --    })
      --    s.myjumpbox:connect_signal("mouse::enter", function(w)
      --                                  if mouse.coords().y > 300 then
      --                                     mouse.coords {
      --                                        x = 2 ,
      --                                        y = mouse.coords().y
      --                                     }
      --                                  else
      --                                     mouse.coords {
      --                                        x = 2 ,
      --                                        y = 300
      --                                     }
      --                                  end
      --    end)
      -- end
   end
)


      -- for s in screen do
      -- 	 naught.notify({ text = s.index })
      -- end

      
