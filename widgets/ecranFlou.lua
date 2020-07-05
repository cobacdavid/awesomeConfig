local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local os    = require("os")
--
local ecranFlou = {}
ecranFlou.isActivated = false
ecranFlou.encours = false
--
function ecranFlou.create(s, args)
   local a = s.actif and "ACTIF" or "INACTIF"
   -- fu.montre(s.index .. " " .. a)
   if not ecranFlou.encours and s.actif then
      ecranFlou.encours = true
      local w = nil
      -- local file = "/tmp/" .. os.date("%Y%m%d-%H%M%S") .. ".png"
      local file = "/tmp/screen" .. s.index .. ".png"
      local x = s.geometry.x
      local y = s.geometry.y
      local w = s.geometry.width
      local h = s.geometry.height
      local arguments = file .. " " .. x .. " " .. y .. " " .. w .. " " .. h
      awful.spawn.easy_async_with_shell(
         "sh /home/david/.config/awesome/widgets/floutage.sh " .. arguments ,
         function()
            w = wibox({
                  x = x,
                  y = y,
                  width = w,
                  height = h,
                  border_width = 0,
                  screen = s,
                  bgimage = gears.surface.load_uncached(file),
                  ontop = true,
                  visible = true
            })
            --
            w:connect_signal("mouse::enter",
                             function()
                                w.visible = false
                                w = nil
                                -- 
                                -- get mouse focus the client below
                                local enDessous = mouse.object_under_pointer()
                                if type(enDessous) == 'client' then
                                   client.focus = enDessous
                                   enDessous:emit_signal("focus")
                                end
                             end
            )
         end
      )
      --
      s.actif = false
      ecranFlou.encours = false
      --
      return w
   end
end
--
client.connect_signal("mouse::enter",
                      function(c)
                         -- fu.montre("ok")
                         for i, s in ipairs(screen) do
                            if s.actif and s ~= mouse.screen then
                               -- fu.montre("floutage " .. s.index)
                               ecranFlou.create(s)
                               s.actif = false
                            end
                         end
                         mouse.screen.actif = true
                      end
)
--
for i, s in ipairs(screen) do
   s.actif = true
end
--
return ecranFlou
--
