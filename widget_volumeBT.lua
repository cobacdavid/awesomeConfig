-- appareils
-- ess b eris
local ess="FC_58_FA_5B_DB_38"
-- philips dhb9100rd
local philips="00_22_37_22_BA_76"
-- sony srs-xb2
local sony="FC_A8_9A_3A_F6_3C"
--
local choix=sony
--
--
--
local MAX = 100
local MIN = 0
-- le widget slider
volumeBTControle = wibox.widget {
   forced_width        = 100,
   bar_shape           = gears.shape.rounded_rect,
   bar_height          = 1,
   bar_color           = beautiful.border_color,
   --handle_color        = beautiful.bg_normal,
   handle_color        = "#FFFFFF",
   handle_shape        = gears.shape.circle,
   --handle_border_color = beautiful.border_color,
   handle_border_color = "#4471AB",
   handle_border_width = 4,
   minimum             = MIN,
   maximum             = MAX,
   value               = MIN,
   widget              = wibox.widget.slider,
}
-- le widget text
volumeBTTexte = wibox.widget {
   align="center",
   text = "bluetooth",
   widget = wibox.widget.textbox
}
-- le widget à afficher
volumeBT = wibox.widget {
   volumeBTTexte,
   volumeBTControle,
   vertical_offset=5,
   layout=wibox.layout.stack
}
--
volumeBTControle:connect_signal("property::value", function()
    local v=volumeBTControle.value
    local command = "pactl set-sink-volume bluez_sink." .. choix .. ".a2dp_sink " .. v .. "%"
    awful.spawn(command)
    volumeBTControle.handle_color = couleurBarre( theme.widget_volumeBT_handle_color_type, v, MIN, MAX)
end)
