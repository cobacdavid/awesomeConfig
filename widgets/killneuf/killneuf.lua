-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
--
-------------------------------------------------
-- some parts from awesome wm
-- distribution
-- copyright ??
-------------------------------------------------
local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
--
local widget = {}
--
function widget.killneuf(c, args)
    
    local killneuf = wibox.widget({
            layout = wibox.layout.stack,
            {
                widget = wibox.widget.textbox,
                align  = "center",
                markup = "<span font='" .. beautiful.font
                    .. "'  foreground='" .. beautiful.bg_urgent
                    .. "'>9</span>"
            },
            {
                widget = wibox.widget.textbox,
                align  = "center",
                markup = "<span font='" .. beautiful.font 
                    .. "'  foreground='" .. beautiful.fg_normal
                    .. "'>kill</span>"
            },
    })
    --
    local tt = awful.tooltip({})
    tt:add_to_object(killneuf)
    killneuf:connect_signal("mouse::enter", function()
                                tt.text = "kill"
    end)
    --
    killneuf:connect_signal("button::press", function()
                                if not c.pid  then return 1 end
                                local commande = "kill -9 " .. c.pid
                                awful.spawn.easy_async_with_shell(commande,
                                                                  function(stdout,stderr,reason,exit_code)
                                                                  end
                                )
                                
                                             end
    )
    return killneuf
end

return setmetatable(widget, {__call=function(_, args)
                                 return widget.killneuf(args)
                   end})

