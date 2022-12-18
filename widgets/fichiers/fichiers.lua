-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2021
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-- most parts from awesome wm
-- distribution
-- copyright ??
-------------------------------------------------
--
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

local function hier(date)
    -- date est de la forme YYYYMMDD
    local y, m, d = string.match(date, "(%d%d%d%d)(%d%d)(%d%d)")
    d = d - 1
    local j = os.time({year=y, month=m, day=d})
    return os.date("%Y%m%d", j)
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

local fichiers_textwidget = wibox.widget {
    align   = 'right',
    valign  = 'bottom',
    opacity = .5,
    font    = "Arial 10",
    widget  = wibox.widget.textbox
}

local fichiers_fondwidget = wibox.widget {
    resize  = true,
    opacity = .3,
    align  = "center",
    valign  = "center",
    font    = "Arial 20",
    widget  = wibox.widget.textbox
}

local fichiers_widget = wibox.widget {
    miroir,
    fichiers_fondwidget,
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
    args.year                 = args.year
    args.from_date            = args.from_date
    args.to_date              = args.to_date
    args.square_size          = args.square_size or 4
    args.fg                   = args.fg          or "#ffffff"
    args.color_of_empty_cells = args.color_of_empty_cells
    args.with_border          = args.with_border
    args.margin_top           = args.margin_top  or 1
    args.text                 = args.text        or "fichiers"
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

    if args.with_border == nil then args.with_border = true end

    
    
    if args.year ~= nil then
        args.from_date = args.from_date or tostring(args.year) .. "0101"
        args.to_date   = args.to_date   or tostring(args.year) .. "1231"
    end
    
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

    local update_widget = function(_, sortie, _, _, _)
        local tab = {}
        local max = tonumber(args.to_date)
        local min = tonumber(args.from_date)
        --
        local k = 100 / (args.n_colors - 2)
        local limits = {0}
        for i = 1, args.n_colors-2 do
            table.insert(limits, math.floor(i * k))
        end
        --
        -- (voir script fichiers.sh)
        for resultats in sortie:gmatch("[^\r\n]+") do
            local date, effectif = resultats:match("(.*) (.*)")
            if date2timestamp(date) >= date2timestamp(args.from_date)  and
                date2timestamp(date) <= date2timestamp(args.to_date) then
                effectif = effectif == nil and 0 or tonumber(effectif)
                tab[tonumber(date)] = effectif
            end
        end
--
        local col = {layout = wibox.layout.fixed.vertical}
        local row = {layout = wibox.layout.fixed.horizontal}
        -- début le lundi
        local y, m, d = args.to_date:match("(%d%d%d%d)(%d%d)(%d%d)")
        local day_idx = 6 - (os.date('%w',
                                     os.time({year=y, month=m, day=d})
                                    ) - 1)%7
        for _ = 1, day_idx do
            table.insert(col, get_square(nil, 0, args.color_of_empty_cells))
        end
        --
        local jour = max
        while jour >= min do
            tab[jour] = tab[jour] == nil and 0 or tab[jour]
            if day_idx %7 == 0 then
                table.insert(row, col)
                col = {layout = wibox.layout.fixed.vertical}
            end
            local couleur = tabTheme[niveau(tab[jour], limits)]
            table.insert(col, get_square(jour, tab[jour], couleur))
            day_idx = day_idx + 1
            jour = tonumber(hier(jour))
        end
        table.insert(row, col)

        miroir:setup({
                row,
                top = args.margin_top,
                layout = wibox.container.margin
        })
        --
        local texte = "<span font_weight='bold' foreground='" .. args.fg .. "'>"
        texte = args.year == nil and texte or texte .. tostring(args.year)
        texte = texte .. " " .. args.text .. "</span>"
        fichiers_textwidget:set_markup(texte)
        local p = string.match(args.path, ".*/(.*)")
        fichiers_fondwidget:set_markup("<span foreground='" .. args.fg .. "'>" .. p .. "</span>")
    end

    local aujourdhui = os.date("%Y%m%d", os.time())
    local CMD1 = string.format(COMMANDE, args.from_date, aujourdhui, args.path)
    awful.spawn.easy_async(CMD1,
                           function(stdout, stderr, reason, exit_code)
                               local CMD2 = 'bash -c "tac ' .. stdout .. ' "'
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
