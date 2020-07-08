-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-------------------------------------------------
-- some parts from awesome wm 
-- distribution
-- copyright ??
-------------------------------------------------
--
local beautiful = require("beautiful")
local awful = require("awful")
local wibox = require("wibox")
local os = require("os")
--
local function notifie(t)
   naughty.notify({text = tostring(t)})
end
--
local widget = {}
--
function widget.screenshot(c, args)
   local args = args or {}
   local icon = args.icon or beautiful.screenshot_icon
   --
   local screenshot = wibox.widget{
      image  = icon,
      widget = wibox.widget.imagebox
   }
   --
   screenshot:connect_signal("button::press",
                             function()
                                local filename = os.date("%Y%m%d-%H%M%S")
                                   .. "-"
                                   ..  c.class
                                   ..  ".png"
                                -- solution interne à awesome ->
                                -- opacité non gérée
                                -- gears.surface(c.content):write_to_png(
                                -- "/home/david/" .. filename )
                                local largeur = c.width 
                                local hauteur = c.height
                                local posx = c.x
                                local posy = c.y
                                local geometrie = largeur
                                   .. "x" .. hauteur
                                   .. "+" .. posx
                                   .. "+" .. posy 
                                local commande = "import -window root -crop "
                                   .. geometrie .. " " .. filename
                                notifie(filename)
                                awful.spawn.easy_async_with_shell(commande,
                                     function(stdout, stderr, reason, exit_code)
                                        -- resultat = exit_code
                                     end
                                )
                             end
   )
   return screenshot
end
--
return setmetatable(widget, {__call=function(t, args)
                                return widget.screenshot(args)
                   end})
