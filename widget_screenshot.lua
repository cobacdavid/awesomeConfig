function screenshotW (c)
   local f = c.class
   screenshot = wibox.widget{
      image = beautiful.flash_icon,
      widget       = wibox.widget.imagebox
   }
   
   screenshot:connect_signal("button::press", function()
	local filename = os.date("%Y%m%d-%H%M%S") .. "-" ..  f  ..  ".png"
        -- solution interne à awesome -> opacité non gérée
        -- gears.surface(c.content):write_to_png( "/home/david/" .. filename )
        local largeur = c.width  - beautiful.titlebar_epaisseur_premiere
        local hauteur = c.height - beautiful.titlebar_epaisseur_seconde
        local posx    = c.x + beautiful.titlebar_epaisseur_premiere        local posy    = c.y
        local geometrie = largeur .. "x" .. hauteur .. "+" .. posx .. "+" .. posy 
        local commande = "import -window root -crop " .. geometrie .. " " .. filename
        montre( commande )
        awful.spawn( commande )
   end)
   return screenshot
end
