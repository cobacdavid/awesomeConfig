local awful         = require("awful")
local naughty       = require("naughty")
local wibox         = require("wibox")
local gears         = require("gears")
local widget_themes = require("widgets.themes_matrice.themes")

local HOME_DIR = os.getenv("HOME")
local ICONS_DIR = HOME_DIR .. '/.config/awesome/icons/'
local WIDGET_DIR = HOME_DIR .. '/.config/awesome/widgets/polar/'

local COMMANDE = 'bash -c "' .. WIDGET_DIR .. 'polar.sh %s"'

local function niveau(effectif, limites)
    local i = 1
    while i <= #limites and limites[i] < effectif do
        i = i + 1
    end
    return i-1
end

local function date2timestamp(date)
    -- date au format YYYYMMDD
    local year, month, day = tostring(date):match("(%d%d%d%d)(%d%d)(%d%d)")
    return os.time({year=year, month=month, day=day})
end


local miroir = wibox.widget{
    reflection = {
        horizontal = true,
        vertical = true,
    },
    widget = wibox.container.mirror
}

local polar_textwidget = wibox.widget {
    align   = 'right',
    valign  = 'bottom',
    opacity = .75,
    font    = "Arial 8",
    widget  = wibox.widget.textbox
}

local polar_imagewidget = wibox.widget {
    -- image   = ICONS_DIR .. "logo-covid.png",
    resize  = true,
    opacity = .75,
    halign  = "center",
    valign  = "center",
    widget  = wibox.widget.imagebox
}

local polar_widget = wibox.widget {
    miroir,
    -- fichiers_imagewidget,
    polar_textwidget,
    layout = wibox.layout.stack
}

local function show_warning(message)
    naughty.notify{
        preset = naughty.config.presets.critical,
        title = 'Widget Polar',
        text = message}
end

local function worker(args)

    if args == nil or args.polar_id == nil then
        return polar_widget
    end

    -- show_warning("OK")
    args = args or {}
    args.polar_id             = args.polar_id
    args.path                 = args.path        or HOME_DIR
    args.from_date            = args.from_date   or "20210101"
    args.square_size          = args.square_size or 4
    args.fg                   = args.fg          or "#fff"
    args.color_of_empty_cells = args.color_of_empty_cells
    args.with_border          = args.with_border
    args.margin_top           = args.margin_top  or 1
    -- two themes : grey or gradient
    args.theme                = args.theme       or 'gradient'
    args.n_colors             = args.n_colors    or 4
    args.from_color           = args.from_color  or "#000"
    args.to_color             = args.to_color    or "#f00"

    -- local y, m, d = string.match(args.from_date, "(%d%d%d%d)(%d%d)(%d%d)")
    -- args.from_date = y .. "-" .. m .. "-" .. d
        
    local tabTheme
    if args.theme == "gradient" then
        tabTheme = widget_themes.gradtheme(args.n_colors,
                                                 args.from_color,
                                                 args.to_color)
    else
        tabTheme = widget_themes.gtheme(args.n_colors)
    end

    if args.with_border == nil then args.with_border = true end

    local function get_square(date, count, color)
        if args.color_of_empty_cells ~= nil and
            color == tabTheme[0] then
            color = args.color_of_empty_cells
        end

        local square = wibox.widget{
            fit = function()
                return args.square_size, args.square_size
            end,
            draw = function(_, _, cr, _, _)
                cr:set_source(gears.color(color))
                cr:rectangle(
                    0,
                    0,
                    args.with_border and args.square_size-1 or args.square_size,
                    args.with_border and args.square_size-1 or args.square_size
                )
                cr:fill()
            end,
            layout = wibox.widget.base.make_widget
        }

        if date ~= nil then
            date = os.date("%a %d %b %Y", date2timestamp(date))
            awful.tooltip {
                text = string.format("%s : %s", date, math.floor(count + 1723)),
                mode = "mouse"
            }:add_to_object(square)
        end

        return square
    end

    local col = {layout = wibox.layout.fixed.vertical}
    local row = {layout = wibox.layout.fixed.horizontal}
       -- début le lundi
    local day_idx = 6 - (os.date('%w') - 1)%7
    for _ = 1, day_idx do
        table.insert(col, get_square(nil, 0, args.color_of_empty_cells))
    end

    local update_widget = function(_, sortie, _, _, _)
        local tab = {}
        --
        local k = 5000 / (args.n_colors - 2)
        local limits = {0}
        for i = 1, args.n_colors-2 do
            table.insert(limits, math.floor(i * k))
        end
        --
        -- (voir script fichiers.sh)
        for resultats in sortie:gmatch("[^\r\n]+") do
            local date, effectif = resultats:match("(.*) (.*)")
            if date2timestamp(date) >= date2timestamp(args.from_date) then
                if effectif ~= nil then
                    effectif = tonumber(effectif)
                    effectif = (effectif < 1800) and 0 or (effectif - 1723)
                    tab[date] = effectif
                    --
                    if day_idx %7 == 0 then
                        table.insert(row, col)
                        col = {layout = wibox.layout.fixed.vertical}
                    end
                    local couleur = tabTheme[niveau(effectif, limits)]
                    table.insert(col, get_square(date, effectif, couleur))
                    day_idx = day_idx + 1
                end
            end
        end
        table.insert(row, col)

        miroir:setup({
                row,
                top = args.margin_top,
                layout = wibox.container.margin
        })

        polar_textwidget:set_markup("<b>" .. "m430" .. "</b>")
    end

    awful.spawn.easy_async(string.format(COMMANDE, args.polar_id),
                           function(stdout, stderr, reason, exit_code)
                               update_widget(polar_widget, stdout)
                           end
    )

    return polar_widget
end

return setmetatable(polar_widget, {
                        __call = function(_, args)
                            return worker(args)
                        end
})
