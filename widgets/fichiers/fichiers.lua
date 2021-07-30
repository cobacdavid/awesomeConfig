local awful         = require("awful")
local naughty       = require("naughty")
local wibox         = require("wibox")
local gears         = require("gears")
local widget_themes = require("widgets.themes_matrice.themes")

local HOME_DIR = os.getenv("HOME")
local ICONS_DIR = HOME_DIR .. '/.config/awesome/icons/'
local WIDGET_DIR = HOME_DIR .. '/.config/awesome/widgets/fichiers/'

local COMMANDE = 'bash -c "' .. WIDGET_DIR .. 'fichiers.sh %s %s %s"'

local function niveau(effectif, limites)
    local i = 1
    while i <= #limites and limites[i] < effectif do
        i = i + 1
    end
    return i-1
end

local function date2timestamp(date)
    -- date au format YYYY-MM-DD
    local year, month, day = tostring(date):match("(%d%d%d%d)-(%d%d)-(%d%d)")
    return os.time({year=year, month=month, day=day})
end


local miroir = wibox.widget{
    reflection = {
        horizontal = false,
        vertical = false,
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

    args.path                 = args.path        or HOME_DIR
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

    local y, m, d = string.match(args.from_date, "(%d%d%d%d)(%d%d)(%d%d)")
    args.from_date = y .. "-" .. m .. "-" .. d
        
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
        --
        local k = 100 / (args.n_colors - 2)
        local limits = {0}
        for i = 1, args.n_colors-2 do
            table.insert(limits, math.floor(i * k))
        end
        --
        -- les dates arrivent dans l'ordre 
        -- (voir script fichiers.sh)
        for resultats in sortie:gmatch("[^\r\n]+") do
            local date, effectif = resultats:match("(.*),(.*)")
            if date2timestamp(date) >= date2timestamp(args.from_date) then
                -- show_warning(tostring(date) .. tostring(effectif))
                if effectif ~= nil then
                    effectif = tonumber(effectif)
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

        miroir:setup({
                row,
                top = args.margin_top,
                layout = wibox.container.margin
        })
    end

    local aujourdhui = os.date("%Y-%m-%d", os.time())
    local CMD1 = string.format(COMMANDE, args.from_date, aujourdhui, args.path)
    awful.spawn.easy_async(CMD1,
                           function(stdout, stderr, reason, exit_code)
                               local name_of_file = stdout
                               local CMD2 = 'bash -c "cat ' .. name_of_file .. '"'
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
