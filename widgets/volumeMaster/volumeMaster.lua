local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
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
    local bheight    = args.barheight     or 1
    local bcolortype = args.barcolortype  or "gradient"
    local bcolor     = args.barcolor      or couleurBarre(bcolortype, volumeactuel, MIN, MAX)
    local hcolortype = args.handcolortype or "gradient"
    local hcolor     = args.handcolor     or bcolor
    local hradius    = args.handradius    or 5
    local ttext      = args.texttext      or "master"
    local tjustify   = args.textjustify   or "center"
    local tvoffset   = args.textvoffset   or 5
    --
    -- slider
    local volumemasterControle = wibox.widget({
            forced_width        = width,
            bar_shape           = bshape,
            bar_height          = bheight,
            bar_color           = bcolor,
            -- handle_shape        = gears.shape.circle,
            handle_shape        = function(cr, w, h)
                gears.shape.circle (cr, w, h, hradius)
            end,
            handle_color        = hcolor,
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
            volumemasterTexte,
            volumemasterControle,
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
            volumemasterControle.handle_color = couleurBarre(hcolortype, v, MIN, MAX)
        end
    )
    --
    volumemasterTexte:connect_signal(
        "button::press",
        function()
            volumemasterControle.value = 0
        end
    )
    --
    volumemasterControle.value = tonumber(readResult(widget.com_get))
    return volumemaster
end


return setmetatable(widget, {__call=function(_, args)
                                 return widget.createWidget(args)
                   end})


