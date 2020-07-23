-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA + SO question
-------------------------------------------------
--
local wibox     = require("wibox")
local beautiful = require("beautiful")
local gears     = require("gears")
local awful     = require("awful")
--
-- Some useful functions
--
-- https://stackoverflow.com/questions/1426954/split-string-in-lua
local function splitString (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end
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
    elseif t == "nuance" then
        resultat = string.format("#%02X%02X%02X", niveau, niveau, niveau)
    end
    return resultat .. "DD"
end
--
--
local widget = {}
--
widget.interfaces = {}
widget.activeIndex = 1
widget.levels = {}
widget.limits = {MAX = 100, maxi = 2,
                 MIN = 0, mini = .5}
--
local function slider2Value(s)
    return tostring(widget.limits.mini +
                        (s * (widget.limits.maxi - widget.limits.mini)
                             / widget.limits.MAX))
end

local function value2Slider(v)
    return math.floor((v - widget.limits.mini) *100
            / (widget.limits.maxi - widget.limits.mini))
end
--
local function listAllInterfaces()
    -- uneasy to make this with async execution of this command
    -- needed to have all interafces knowledge
    local ifaces = "xrandr |grep ' connected'|cut -d' ' -f 1"
    local fh = io.popen(ifaces)
    local resultat = fh:read("*a")
    fh:close()
    widget.interfaces = splitString(resultat, "\n")
end
--
-- todo: should add some custom args values...
local function modifieTexte(w, iface, args)
    args = args or {}
    args.fg = args.fg or beautiful.fg_normal
    --
    w:set_markup("<span foreground='" .. args.fg .. "'>" .. iface .. "</span>")
end
--
-- update display of slider value at start or when changing
-- active interface
local function valeurDepartSlider(w, index)
    local vDepart = widget.levels[widget.interfaces[index]]
    w.value = value2Slider(vDepart)
end
--
function widget.applyCommand(iface, stringValue)
    local value = stringValue:gsub(",",".")
    local command="xrandr --output " .. iface .." --brightness " .. value
    awful.spawn.easy_async_with_shell(command,
                                      function(stdout, stderr, reason, exit_code)
                                          -- should handle possible error...
                                     end
    )
end
--
function widget.sliderBrightnessWidget(args)
    --
    args                    = args                   or {}
    local width             = args.width             or 150
    local handle_color_type = args.handle_color_type or "nuance"
    local bar_height        = args.bar_height        or 1
    --
    -- complete widget
    local widgetComplet = wibox.widget(
        {
            {
                {
                    id     = "texte",
                    align  = "center",
                    widget = wibox.widget.textbox
                },
                {
                    id           = "slider",
                    bar_shape    = gears.shape.rounded_rect,
                    bar_height   = bar_height,
                    -- bar_color    = beautiful.border_color,
                    handle_shape = gears.shape.circle,
                    minimum      = widget.limits.MIN,
                    maximum      = widget.limits.MAX,
                    widget       = wibox.widget.slider,
                },
                id              = "stack",
                vertical_offset = 0,
                layout          = wibox.layout.stack
            },
            forced_width = width,
            -- bg           = beautiful.bg_normal,
            widget       = wibox.container.background
        }
    )
    --
    -- change slider value callback
    widgetComplet.stack.slider:connect_signal("property::value",
                                              function()
                                                  local iface = widget.interfaces[widget.activeIndex]
                                                  local v = slider2Value(widgetComplet.stack.slider.value)
                                                  v = v:gsub(",",".")
                                                  widget.levels[iface] = v
                                                  widget.applyCommand(iface, v)
                                                  widgetComplet.stack.slider.handle_color =
                                                      couleurBarre(handle_color_type,
                                                                   v,
                                                                   widget.limits.mini,
                                                                   widget.limits.maxi)
                                                  widgetComplet.stack.slider.bar_color =
                                                      widgetComplet.stack.slider.handle_color
                                              end
    )
    --
    -- change interface callback
    widgetComplet:buttons(
        gears.table.join(
            awful.button({}, 3,
                function()
                    widget.activeIndex = 1 + widget.activeIndex%#widget.interfaces
                    modifieTexte(widgetComplet.stack.texte, widget.interfaces[widget.activeIndex])
                    valeurDepartSlider(widgetComplet.stack.slider, widget.activeIndex)
                end
            )
        )
    )
    --
    -- applying custom startLevel
    for _, iface in ipairs(widget.interfaces) do
        widget.levels[iface] = args.startLevel and args.startLevel[iface] or 1
        widget.applyCommand(iface, tostring(widget.levels[iface]))
    end
    -- --
    -- -- update widget at start up
    modifieTexte(widgetComplet.stack.texte, widget.interfaces[widget.activeIndex])
    valeurDepartSlider(widgetComplet.stack.slider, widget.activeIndex)
    --
    return widgetComplet
end

-- list all interfaces when lib is called...why not?
listAllInterfaces()

return setmetatable(widget, {__call=function(_, args)
                                 return widget.sliderBrightnessWidget(args)
                   end})
