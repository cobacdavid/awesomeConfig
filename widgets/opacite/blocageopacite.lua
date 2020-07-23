-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
--
local widget = {}

function widget.blocage_opacite(c, args)
    args = args or {}
    args.bg = args.bg or beautiful.bg_normal
    --
    local w = wibox.widget({
            {
                id = "bouton",
                widget = wibox.widget.textbox,
                align = "center",
                text = "O"
            },
            bg = color,
            widget = wibox.container.background
    })
    --
    local tt = awful.tooltip({})
    tt:add_to_object(bouton)
    w:connect_signal("mouse::enter", function()
                         tt.text = "(un)block opacity"
    end)
    --
    c.blocage = false
    --
    w:connect_signal("button::press",
                          function()
                              c.blocage = not c.blocage
                              if c.blocage then
                                  w.bouton.text = "B"
                              else
                                  w.bouton.text = "O"
                              end
                          end
    )
    return w
end

return setmetatable(widget, {__call=function(_, args)
                                 return widget.blocage_opacite(args)
                   end})
