local awful         = require("awful")
local naughty       = require("naughty")
local wibox         = require("wibox")
local gears         = require("gears")
local widget_themes = require("widgets.covid.themes")

local HOME_DIR = os.getenv("HOME")
local ICONS_DIR = HOME_DIR .. '/.config/awesome/icons/'
local WIDGET_DIR = HOME_DIR .. '/.config/awesome/widgets/fichiers/'

local COMMANDE = 'bash -c "' .. WIDGET_DIR .. 'fichiers.sh %s %s"'

local function hier(date)
    -- date est de la forme YYYYMMDD
    local y, m, d = string.match(date, "(%d%d%d%d)(%d%d)(%d%d)")
    d = d - 1
    local j = os.time({year=y, month=m, day=d})
    return os.date("%Y%m%d", j)
end

local function niveau(effectif, limites)
    local i = 1
    while i <= #limites and limites[i] < effectif do
        i = i + 1
    end
    return i-1
end

local miroir = wibox.widget{
    reflection = {
        horizontal = true,
        vertical = true,
    },
    widget = wibox.container.mirror
}

local fichiers_textwidget = wibox.widget {
    align   = 'center',
    valign  = 'center',
    opacity = .75,
    font    = "Arial 18",
    widget  = wibox.widget.textbox
}

local fichiers_imagewidget = wibox.widget {
    -- image   = ICONS_DIR .. "logo-covid.png",
    resize  = true,
    opacity = .75,
    halign  = "center",
    valign  = "center",
    widget  = wibox.widget.imagebox
}

local fichiers_widget = wibox.widget {
    miroir,
    -- fichiers_imagewidget,
    fichiers_textwidget,
    layout = wibox.layout.stack
}

local function show_warning(message)
    naughty.notify{
        preset = naughty.config.presets.critical,
        title = 'Fichiers Widget',
        text = message}
end

local function worker(args)

    if args == nil then
        return fichiers_widget
    end

    -- show_warning("OK")
    args = args or {}

    args.from_date            = args.from_date   or "20210101"
    args.square_size          = args.square_size or 4
    args.fg                   = args.fg          or "#ffffff"
    args.color_of_empty_cells = args.color_of_empty_cells
    args.with_border          = args.with_border
    args.margin_top           = args.margin_top  or 1
    -- two themes : grey or gradient
    args.theme                = args.theme       or 'gradient'
    args.n_colors             = args.n_colors    or 4
    args.from_color           = args.from_color  or "#ffff00"
    args.to_color             = args.to_color    or "#ff0000"

    local tabTheme
    if args.theme == "gradient" then
        tabTheme = widget_themes.gradtheme(args.n_colors,
                                                 args.from_color,
                                                 args.to_color)
    else
        tabTheme = widget_themes.gtheme(args.n_colors)
    end
    
    if widget_themes[args.theme] == nil then
        -- show_warning('Theme ' .. args.theme .. ' does not exist')
        -- args.theme = 'standard'
    end

    local y, m, d = string.match(args.from_date, "(%d%d%d%d)(%d%d)(%d%d)")
    args.from_date = os.time({year=y, month=m, day=d})

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
            local year, month, day = tostring(date):match("(%d%d%d%d)(%d%d)(%d%d)")
            date = os.date("%a %d %b %Y",
                           os.time({year=year, month=month, day=day}))
            awful.tooltip {
                text = string.format("%s : %s", date, count),
                mode = "mouse"
            }:add_to_object(square)
        end

        return square
    end

    local col = {layout = wibox.layout.fixed.vertical}
    local row = {layout = wibox.layout.fixed.horizontal}
    local day_idx = math.floor(6 - os.date('%w'))
    for _ = 1, day_idx do
        table.insert(col, get_square(nil, 0, args.color_of_empty_cells))
    end

    local update_widget = function(_, sortie, _, _, _)

        local tab = {}
        local max = tonumber(os.date("%Y%m%d"))
        local min = max
        local effectifMax = 0

        -- parcours date par date, détermination des dates limites
        -- et de l'effectif maximal -> blanc sur la grille
        for resultats in sortie:gmatch("[^\r\n]+") do
            local date, effectif = resultats:match("(.*),(.*)")
            -- show_warning(tostring(date) .. tostring(effectif))
            if effectif ~= nil then
                effectif = tonumber(effectif)
                local y, m, d = date:match("(%d%d%d%d)-(%d%d)-(%d%d)")
                date = tonumber(y .. m .. d)
                if date < min then
                    min = date
                end
                if effectifMax < effectif then
                    effectifMax = effectif
                end
                tab[date] = effectif -- tab[date] == nil and 1 or tab[date] + 1
            end
        end
        
        -- 
        local k = math.min(effectifMax, 100) / (args.n_colors - 2)
        local limits = {0}
        for i = 1, args.n_colors-2 do
            table.insert(limits, math.floor(i * k))
        end
        -- show_warning(tostring(limits[10]))

        -- show_warning(tostring(effectifMax))
        local jour = max
        while jour >= min do
            -- show_warning(tostring(jour))
            tab[jour] = tab[jour] == nil and 0 or tab[jour]

            if day_idx %7 == 0 then
                table.insert(row, col)
                col = {layout = wibox.layout.fixed.vertical}
            end
            --
            local couleur = tabTheme[niveau(tab[jour], limits)]
            table.insert(col, get_square(jour, tab[jour], couleur))
            day_idx = day_idx + 1
            -- show_warning(tostring(day_idx))
            jour = tonumber(hier(jour))
            -- nb = nb + 1
        end

        miroir:setup({
                row,
                top = args.margin_top,
                layout = wibox.container.margin
        })
    end

    local d = os.date("%Y-%m-%d", args.from_date)
    local CMD1 = string.format(COMMANDE, d, "2021-07-29")
    awful.spawn.easy_async(CMD1,
                           function(stdout,stderr,reason,exit_code)
                               local CMD2 = 'bash -c "cat ' .. WIDGET_DIR .. 'sortie_commande.csv"'
                               awful.spawn.easy_async(CMD2,
                                                      function(stdout)
                                                          update_widget(fichiers_widget, stdout)
                                                      end
                               )
                           end
    )

    return fichiers_widget
end

return setmetatable(fichiers_widget, {
                        __call = function(_, args)
                            return worker(args)
                        end
})
