local widget = {}

local function heurew_text(w)
   local heure = os.date("%H:%M.%S")
   local couleur = beautiful.widget_heurew_fg_jour
   if tonumber(os.date("%H")) >= 19 then
      couleur = beautiful.widget_heurew_fg_soir
   end
   local size = beautiful.heurew_size
   local hm = "<span foreground='" .. couleur .. "' font_weight='normal' font='" .. beautiful.widget_heurew_font .. " " .. size .. "' >" .. string.sub(heure,1,5) .. "</span>"
   w:set_markup(hm)
end

function widget.heure(args)
   ----------------------------------------
   heurew = wibox.widget {
      forced_width = 100,
      align = "center",
      widget = wibox.widget.textbox
   }
   ----------------------------------------
   heurew:buttons(gears.table.join(
                     awful.button({ }, 1,
                        function ()
                           awful.util.spawn( calendrier )
                        end
                     )
   ))
   ---------------------------------------
   -- comme pas les secondes affichées, on actualise toutes les 5 secondes
   gears.timer ({
         timeout = 5,
         call_now = true,
         autostart = true,
         callback = function()
            heurew_text(heurew)
         end
   })
   return heurew
end

return setmetatable(widget, {__call=function(t, args)
                                return widget.heure(args)
                   end})
