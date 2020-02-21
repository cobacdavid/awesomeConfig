infos = wibox.widget {
      text = "   Infos   ",
      widget = wibox.widget.textbox,
      visible = true,
      align = "center",
      forced_width = 150
}

function choisisCommande (indice)
   return {#commandes, commandes[1+indice]}
end


indiceInfos = -1
infos:connect_signal(
   "button::press",
   function()
      local commandes = {
         monIP,
         monIPInternet,
         configEcrans,
         -- versionLinux,
         versionDistrib,
         laTempExt,
         batterie
         --"sensors"
      }
      --
      indiceInfos = (indiceInfos+1) % #commandes
      local c = commandes[1+indiceInfos]
      -- montre( c )
      awful.spawn.easy_async_with_shell(c,
                                        function(stdout, stderr, reason ,exit_code)
                                           -- montre(texte)
                                           infos.text = stdout
                                        end
      ) 
   end
)
