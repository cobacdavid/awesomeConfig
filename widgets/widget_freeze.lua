-- suppose que ecranAux est une variable globale définie
function freeze ()
   local f = "/home/david/" .. os.date("%Y%m%d-%H%M%S") .. "-ecranAux.png"
   --
   local geometrieCmd  = "xrandr |grep" .. ecranAux .. "|cut -d ' ' -f3"
   local fh = io.popen ( geometrieCmd )
   local geometrie = fh:read("*a")
   geometrie = string.sub( geometrie, 0, string.len( geometrie ) - 1 )
   io.close( fh )
   -- montre( geometrie )
   local copieEcran = "import -window root -crop " .. geometrie .. " " .. f
   --
   local commande = copieEcran
   awful.spawn( commande )
   commande = "/usr/bin/phototonic " .. f
   awful.spawn( commande )
end
--
freezeWidget = wibox.widget {
   widget = wibox.widget.textbox,
   text   = "freeze Aux",
}
--
freezeWidget:connect_signal("button::press", function()
                                freeze()
                            end)
