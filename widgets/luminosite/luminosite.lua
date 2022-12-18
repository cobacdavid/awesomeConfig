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
local gears     = require("gears")
local beautiful = require("beautiful")
local wibox     = require("wibox")
local awful     = require("awful")
--
local widget_themes = require("widgets.themes_matrice.themes")
--
local function niveau(effectif, limites)
    local i = 1
    while i <= #limites and limites[i] < effectif do
        i = i + 1
    end
    return i-1
end
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
    --
    if t == "gradient" then
        -- couleur du vert au rouge
        local r = niveau
        local g = 255 - r
        resultat  = string.format("#%02X%02X00", r, g)
    else
        resultat = string.format("#%02X%02X%02X", niveau, niveau, niveau)
    end
    return resultat .. "DD"
end
--
local widget = {}

-- sur asus ux305 : MAX = 937 et MIN = 30
-- sur asus ux370 : MAX = 7500 et MIN = 500
local MAX = 7500
local MIN = 500
local FIC = "/sys/class/backlight/intel_backlight/brightness"


function widget.createWidget(args)
    args = args or {}
    --
    local width      = args.width         or 150
    local bshape     = args.barshape      or gears.shape.rounded_rect
    local bheight    = args.barheight     or 10
    local hradius    = args.handradius    or 5
    local hcolortype = args.handcolortype or "gradient"
    local from_color = args.from_color    or "#f0f"
    local to_color   = args.to_color      or "#f00"
    local n_colors   = args.n_colors      or 100
    --
    local tabTheme
    if hcolortype == "gradient" then
        tabTheme = widget_themes.gradtheme(n_colors,
                                           from_color,
                                           to_color)
    else
        tabTheme = widget_themes.gtheme(100)
    end
    local k = 100 / (n_colors - 2)
    local limits = {0}
    for i = 1, n_colors-2 do
        table.insert(limits, math.floor(i * k))
    end
    -- le widget slider
    local luminositeControle = wibox.widget({
            forced_width        = width,
            bar_height          = bheight,
            bar_shape           = bshape,
            bar_color           = "#fff2", -- beautiful.widget_luminosite_bar_color,
            handle_shape        = function(cr, w, h)
                gears.shape.circle (cr, w, h, hradius)
            end,
            handle_color        = beautiful.widget_luminosite_handle_color,
            -- handle_border_color = beautiful.widget_luminosite_handle_border_color,
            -- handle_border_width = 1,
            minimum             = MIN,
            maximum             = MAX,
            --   value               = valeurLue,
            widget              = wibox.widget.slider,
    })
    -- le widget text
    local luminositeTexte = wibox.widget({
            text                = "lum.",
            align               = "center",
            widget              = wibox.widget.textbox,
    })
    -- le widget à afficher
    local luminosite = wibox.widget({
            luminositeControle,
            luminositeTexte,
            vertical_offset=5,
            layout=wibox.layout.stack
    })
    -- actualisation
    luminositeControle:connect_signal(
        "property::value",
        function()
            local v = luminositeControle.value
            local command = 'echo '.. v .. ' > '.. FIC
            awful.spawn.easy_async_with_shell(command, function(s,t,u,v)  end)
            local couleur = tabTheme[niveau(math.floor(100*v/MAX), limits)]-- couleurBarre(hcolortype, v, MIN, MAX)
            luminositeControle.handle_color = couleur
            luminositeControle.bar_active_color    = couleur
        end
    )
    --
    -- luminositeControle:connect_signal("property::value", function()
    --                                      local v = luminositeControle.value
    --                                      --
    --                                      local command = 'echo '.. v .. ' > '.. FIC
    --                                      --montre( command )
    --                                      awful.spawn.easy_async_with_shell(command, function(s,t,u,v)  end)
    --                                      --
    --                                      --local valeur=math.floor(v*255/MAX)
    --                                      --local nuance = string.format("#%x%x%x", valeur,valeur,valeur)
    --                                      --luminositeControle.handle_color=nuance
    --                                      luminositeControle.handle_color =
    --                                          couleurBarre(beautiful.widget_luminosite_handle_color_type, v, MIN, MAX)
    -- end)
    --
    local command = [[ bash -c "cat ]] .. FIC .. [["]]
    awful.spawn.easy_async_with_shell(command, function(s,t,u,v)
                                          luminositeControle.value = tonumber(s)
    end)
    --
    return luminosite
end


return setmetatable(widget, {__call=function(_, args)
                                 return widget.createWidget(args)
                   end})

