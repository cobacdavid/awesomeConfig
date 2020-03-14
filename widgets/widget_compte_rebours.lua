function HMversM(s)
   local hh = tonumber(string.sub(s, 1, 2))
   local hm = tonumber(string.sub(s, 4, 5))
   return hh * 60 + hm
end


function compteRebours()
   local heuresJM = {
      "08:05",
      "09:02",
      "10:10",
      "11:07",
      "12:05",
      "13:00",
      "13:55",
      "14:52",
      "16:00",
      "16:57",
      "18:00"
   }

   local heuresJM_min = {}
   
   for _, h in ipairs(heuresJM) do
      table.insert(heuresJM_min, HMversM(h))
   end

   local heure = os.date("%H:%M")
   local heureM = HMversM(heure)

   local i = 1
   while (i<=#heuresJM_min and heureM > heuresJM_min[i]) do
      i = i + 1
   end
   local diff = heuresJM_min[i] - heureM
   local heu = diff // 60
   local min = diff % 60
   return tostring(heu) .. ":" .. string.format("%02d", tostring(min))
end

car = wibox.widget(
   {
      widget = wibox.widget.textbox,
      visible = true,
      align = "center",
      forced_width = 150
   }
)

gears.timer(
   {
      timeout   = 10,
      call_now  = true,
      autostart = true,
      callback  = function()
         local heure = os.date("%H")
         if (tonumber(heure) > 8 and tonumber(heure) < 18) then
            car.text =  compteRebours()
         end
      end
   }
)
