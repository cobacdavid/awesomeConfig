-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-------------------------------------------------
-- some parts from awesome wm
-- ditribution
-- copyright ??
-------------------------------------------------
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
--
local ecranFlou = {}
ecranFlou.isActivated = false
ecranFlou.encours = false
--
local myhome = os.getenv("HOME") .. "/"
--
function ecranFlou.create(s, args)
    if not ecranFlou.encours and s.actif then
        ecranFlou.encours = true
        local file = "/tmp/screen" .. s.index .. ".jpg"
        local x = s.geometry.x
        local y = s.geometry.y
        local w = s.geometry.width
        local h = s.geometry.height
        local arguments = file .. " " .. x .. " " .. y .. " " .. w .. " " .. h
        awful.spawn.easy_async_with_shell(
            "sh " .. myhome .. ".config/awesome/widgets/ecranFlou/floutage.sh " .. arguments ,
            function()
                local w = wibox({
                        x            = x,
                        y            = y,
                        width        = w,
                        height       = h,
                        border_width = 0,
                        screen       = s,
                        bgimage      = gears.surface.load_uncached(file),
                        ontop        = true,
                        visible      = true
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
                          if not ecranFlou.isActivated then
                              return nil
                          end
                          -- fu.montre("ok")
                          for _, s in ipairs(screen) do
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
for _, s in ipairs(screen) do
    s.actif = true
end
--
return ecranFlou
--
