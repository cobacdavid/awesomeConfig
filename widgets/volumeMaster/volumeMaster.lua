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
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
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
local widget = {}

widget.sortie   = " Master "
widget.com_get  = "amixer get" .. widget.sortie .. "|grep Left:|cut -d ' ' -f6"
widget.com_getM = "amixer get" .. widget.sortie .. "|grep Limits|cut -d ' ' -f7"

-- Gestion couleur
--
-- renvoie une couleur nuance ou gradient (vert au rouge)
-- t : theme beautiful
-- v : valeur à colorer
-- m : minimum
-- M : Maximum
-- attention : pour l'instant m n'est pas utilisé...
-- ni coulDebut ni coulFin
local function couleurBarre (t, v, m, M, coulDebut, coulFin)
    local resultat
    if v == nil then return end
    -- if coulDebut == nil or coulFin == nil then
    local niveau = math.floor(255*v/M)
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

local function readResult(cmd)
    local fh = io.popen(cmd)
    local resultat = fh:read("*a")
    fh:close()
    return resultat
end
--
function widget.createWidget(args)
    args = args or {}
    --
    local volumeactuel = tonumber(readResult(widget.com_get))
    local MIN = 0
    local MAX = tonumber(readResult(widget.com_getM))
    --
    local width      = args.width         or 150
    local bshape     = args.barshape      or gears.shape.rounded_rect
    local bheight    = args.barheight     or 10
    local bcolortype = args.barcolortype  or "gradient"
    -- local bcolor     = args.barcolor      or couleurBarre(bcolortype, volumeactuel, MIN, MAX)
    local hcolortype = args.handcolortype or "gradient"
    local from_color = args.from_color  or "#f0f"
    local to_color   = args.to_color    or "#f00"
    local n_colors   = args.n_colors or 100
    -- local hcolor     = args.handcolor     or bcolor
    local hradius    = args.handradius    or 5
    local ttext      = args.text          or "master"
    local tjustify   = args.justify       or "center"
    local tvoffset   = args.textvoffset   or 5
    --
    local tabTheme
    if hcolortype == "gradient" then
        tabTheme = widget_themes.gradtheme(n_colors,
                                           from_color,
                                           to_color)
    else
        tabTheme = widget_themes.gtheme(100)
    end
    --
    local bar_color
    if string.len(from_color) == 7 then
        bar_color = from_color .. "22"
    else
        bar_color = from_color .. "2"
    end
    --
    local k = 100 / (n_colors - 2)
    local limits = {0}
    for i = 1, n_colors-2 do
        table.insert(limits, math.floor(i * k))
    end
    -- slider
    local volumemasterControle = wibox.widget({
            forced_width        = width,
            bar_shape           = bshape,
            bar_height          = bheight,
            bar_color           = bar_color,
            -- bar_active_color    = bcolor,
            -- handle_shape        = gears.shape.circle,
            handle_shape        = function(cr, w, h)
                gears.shape.circle (cr, w, h, hradius)
            end,
            -- handle_color        = hcolor,
            minimum             = MIN,
            maximum             = MAX,
            widget              = wibox.widget.slider,
    })
    -- texte
    local volumemasterTexte = wibox.widget({
            text = ttext,
            align = tjustify,
            widget = wibox.widget.textbox
    })
    -- à afficher
    local volumemaster = wibox.layout({
            volumemasterControle,
            volumemasterTexte,
            vertical_offset = tvoffset,
            layout = wibox.layout.stack
    })
    --
    volumemasterControle:connect_signal(
        "property::value",
        function()
            local v = volumemasterControle.value
            local command='amixer set' .. widget.sortie  .. v
            awful.spawn.with_shell(command)
            local couleur = tabTheme[niveau(math.floor(100*v/MAX), limits)]-- couleurBarre(hcolortype, v, MIN, MAX)
            volumemasterControle.handle_color = couleur
            volumemasterControle.bar_active_color    = couleur
        end
    )
    --
    volumemaster:buttons(
        gears.table.join(
            awful.button({}, 3,
                function()
                    volumemasterControle.value = 0
                end
            )
        )
    )
    --
    volumemasterControle.value = tonumber(readResult(widget.com_get))
    return volumemaster
end


return setmetatable(widget, {__call=function(_, args)
                                 return widget.createWidget(args)
                   end})


