local widget = {}

local function choisisCommande (indice)
   return {#commandes, commandes[1+indice]}
end


function widget.infos(args)
   local args = args or {}
   --
   local infos = wibox.widget(
      {
         text = "Infos",
         widget = wibox.widget.textbox,
         visible = true,
         align = "center",
         forced_width = 150
      }
   )

   local indiceInfos = -1
   
   infos:connect_signal(
      "button::press",
      function()
         local commandes = {
            monIP,
            monIPInternet,
            configEcrans,
            versionLinux,
            versionDistrib,
            laTempExt,
            temperatureCore,
            batterie
            -- "sensors"
         }
         --
         indiceInfos = (indiceInfos+1) % #commandes
         local c = commandes[1+indiceInfos]
         -- montre( c )
         awful.spawn.easy_async_with_shell(c,
                                           function(stdout, stderr, reason ,exit_code)
                                              local t = string.len(stdout)
                                              -- on enlève le passage à la ligne
                                              local texte = stdout:sub(1, t-1)
                                              infos.markup = "<span foreground='gray' size='large'>"
                                                 .. texte ..
                                                 "</span>"
                                           end
         ) 
      end
   )
   return infos
end


return setmetatable(widget, {__call=function(t, args)
                                return widget.infos(args)
                   end})
