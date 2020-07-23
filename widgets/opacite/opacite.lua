local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

-- Gestion couleur
--
-- renvoie une couleur nuance ou gradient (vert au rouge)
-- t : theme beautiful
-- v : valeur à colorer
-- m : minimum
-- M : Maximum
-- attention : pour l'instant m n'est pas utilisé...
-- ni coulDebut ni coulFin
local function couleurBarre (t, v , m , M , coulDebut, coulFin)
    local resultat
    if v == nil then return end
    -- if coulDebut == nil or coulFin == nil then
    local niveau = math.floor(255*v/M)
    -- montre( t .. " " .. tostring(v) .. " " .. tostring(M) .. " " .. tostring(niveau) )
    if t == "gradient" then
        -- couleur du vert au rouge
        local r = niveau
        local g = 255 - r
        resultat  = string.format("#%02X%02X00", r, g)
    elseif t == "nuance" then
        resultat = string.format("#%02X%02X%02X", niveau, niveau, niveau)
    end
    return resultat .. "DD"
end

local widget = {}

function widget.opacite(c, args)
    args                     = args                     or {}
    -- args.bg                  = args.bg                  or beautiful.bg_normal
    args.bar_shape           = args.bar_shape           or gears.shape.rounded_rect
    args.bar_color           = args.bar_color           or beautiful.border_color_normal
    args.bar_height          = args.bar_height          or 1
    args.handle_color        = args.handle_color        or beautiful.fg_normal
    args.handle_shape        = args.handle_shape        or gears.shape.circle
    args.handle_border_color = args.handle_border_color or beautiful.border_color_normal
    args.handle_border_width = args.handle_border_width or 1
    --
    --
    local MIN = 0
    local mini = 0.2
    local MAX = 100
    local maxi = 1
    --
    local w = wibox.widget({
                -- forced_width        = 100,
                bar_shape           = args.bar_shape,
                bar_height          = 1,
                bar_color           = args.bar_color,
                -- handle_color        = beautiful.bg_normal,
                handle_color        = args.handle_color,
                handle_shape        = args.handle_shape,
                handle_border_color = args.handle_border_color,
                handle_border_width = args.handle_border_width,
                minimum             = MIN,
                maximum             = MAX,
                value               = (c.opacity - mini) / ((maxi-mini) / MAX),
                widget              = wibox.widget.slider
    })
    --
    c:connect_signal("property::opacity",
                     function()
                         w.value = (c.opacity - mini) / ((maxi-mini)/ MAX)
                         w.handle_color = couleurBarre("nuance", w.value, MIN, MAX)
                     end
    )
    w:connect_signal("property::value",
                          function()
                              c.opacity = mini + (w.value * (maxi-mini)/ MAX)
                              w.handle_color = couleurBarre("nuance", w.value, MIN, MAX)
                          end
    )
    --
    return w
end

return setmetatable(widget, {__call=function(_, client, args)
                                 return widget.opacite(client, args)
                   end})
