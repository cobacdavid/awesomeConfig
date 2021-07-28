-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2021
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-------------------------------------------------
-- some parts from awesome wm
-- distribution
-- copyright ??
-------------------------------------------------
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
--
local identifiants = require("widgets.meteo.private_openweather_api_key")
--
--
local HOME_DIR = os.getenv('HOME')
local ICONS_DIR = HOME_DIR .. '/.config/awesome/icons/'
--
--
local COMMAND1 = [[ bash -c "curl -s 'api.openweathermap.org/data/2.5/weather?q=%s,%s&units=metric&appid=%s' | jq -r '.main.temp, .weather[].icon'" ]]

local COMMAND2 = [[ bash -c "wget http://openweathermap.org/img/wn/%s@2x.png -O /tmp/meteo.png" ]]
--
local miroir = wibox.widget{
    reflection = {
        horizontal = true,
    },
    widget = wibox.container.mirror
}

local meteo_imagewidget = wibox.widget{
    resize  = true,
    halign  = "center",
    opacity = .5,
    widget = wibox.widget.imagebox
}


local widget_final = wibox.widget {
    miroir,
    meteo_imagewidget,
    layout = wibox.layout.stack
}
--

--
local function leWidget(args)

    -- pour éviter un double widget (pb écrans xrandr ?)
    --if args == nil then
    --    return miroir
    --end1
    
    args              = args              or {}
    args.location     = args.location     or "Angers"
    args.country_code = args.country_code or "FR"
    args.color        = args.color        or "#aaa"
    args.max_value    = args.max_value    or 35
    args.min_value    = args.min_value    or 0
    args.indicateur   = args.indicateur or "reanimation"

    local graph_widget = wibox.widget{
        forced_width = 48,
        -- opacity      = .5,
        color        = args.color,
        max_value    = args.max_value,
        min_value    = args.min_value,
        -- background_color = "#55555500",
        step_shape   = gears.shape.rounded_rect,
        -- step_spacing = 1,
        step_width   = 2,
        widget       = wibox.widget.graph
    }
    
    miroir:setup(
        {
            graph_widget,
            top = 1,
            layout = wibox.container.margin
        }
    )
    
    gears.timer ({
            timeout = 600,
            call_now = true,
            autostart = true,
            callback = function()
                awful.spawn.easy_async(string.format(COMMAND1, args.location, args.country_code, identifiants.api_key),
                                       function(stdout,stderr,reason,exit_code)
                                           local temp, weather_icon = stdout:match("(.*)\n(.*)\n")
                                           -- naughty.notify({
                                           --        preset = naughty.config.presets.critical,
                                           --        text = tostring(temp).." " .. weather
                                           -- })
                                           graph_widget:add_value(temp)
                                           awful.tooltip {
                                               text = string.format("%s : %s °C", args.location, tostring(math.floor(0.5 +temp))),
                                               mode = "mouse"
                                           }:add_to_object(widget_final)

                                           awful.spawn.easy_async(string.format(COMMAND2, weather_icon),
                                                                  function(_)
                                                                      meteo_imagewidget:set_image("/tmp/meteo.png")
                                                                  end
                                           )
                                       end
                )
            end
    })
    -- naughty.notify({
    --         preset = naughty.config.presets.critical,
    --         text = string.format(COMMAND, "Angers", "FR", "847323bc26f4c4ee255aae9d32d6a3cf")
    -- })
    
    return widget_final
end

return setmetatable(widget_final, {__call=function(_, args)
                                       return leWidget(args)
                   end})
