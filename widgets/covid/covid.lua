local awful         = require("awful")
local naughty       = require("naughty")
local wibox         = require("wibox")
local gears         = require("gears")
local widget_themes = require("widgets.covid.themes")

local HOME_DIR = os.getenv("HOME")
local ICONS_DIR = HOME_DIR .. '/.config/awesome/icons/'

local COMMAND = [[bash -c "curl -s ]]
    .. [[ https://coronavirusapi-france.vercel.app/AllDataByDepartement\?Departement\=%s ]]
    .. [[ | jq -r '.allDataByDepartement[] | .date + \" \" +(.%s|tostring)'" ]]

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

local covid_textwidget = wibox.widget {
    align   = 'center',
    valign  = 'center',
    opacity = .75,
    font    = "Arial 18",
    widget  = wibox.widget.textbox
}

local covid_imagewidget = wibox.widget {
    image   = ICONS_DIR .. "logo-covid.png",
    resize  = true,
    opacity = .75,
    halign  = "center",
    valign  = "center",
    widget  = wibox.widget.imagebox
}

local covid_widget = wibox.widget {
    miroir,
    -- covid_imagewidget,
    covid_textwidget,
    layout = wibox.layout.stack
}

local function show_warning(message)
    naughty.notify{
        preset = naughty.config.presets.critical,
        title = 'Covid Widget',
        text = message}
end

local function worker(args)

    if args == nil then
        return covid_widget
    end

    args = args or {}
    args.departement          = args.departement or "Maine-et-Loire"
    args.indicateur           = args.indicateur  or "reanimation"
    args.from_date            = args.from_date   or "20200228"
    args.square_size          = args.square_size or 4
    args.fg                   = args.fg          or "#ffffff"
    args.color_of_empty_cells = args.color_of_empty_cells
    args.with_border          = args.with_border
    args.margin_top           = args.margin_top  or 1
    -- two themes : grey or gradient
    args.theme                = args.theme       or 'gradient'
    args.n_colors             = args.n_colors    or 4
    args.from_color           = args.from_color  or "#0000ff55"
    args.to_color             = args.to_color    or "#88ff00"
    
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
        args.theme = 'standard'
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
                text = string.format("%s %s : %s", args.indicateur, date, count),
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
        for resultatDuJour in sortie:gmatch("[^\r\n]+") do
            local date, effectif = resultatDuJour:match("(.*)%s+(.*)")
            if effectif ~= "null" then
                effectif = tonumber(effectif)
                local y, m, d = date:match("(%d%d%d%d)-(%d%d)-(%d%d)")
                --date = os.time({year=y, month=m, day=d})
                --date = tonumber(os.date("%Y%m%d", ecoute))
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
        
        -- détermination des limites de valeurs : de 0 puis 1 à effectifMax
        -- par crroissance exponentielle en k valeurs (variables user)
        -- 0 1 k k² ... k^(n-2)=effectifMax
        local k = effectifMax ^ (1 / (args.n_colors - 2))
        local limits = {0, 1}
        for i = 1, args.n_colors-2 do
            table.insert(limits, math.floor(k ^ i))
        end
        
        -- local nb = 0        
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
    
    covid_textwidget:set_markup("<span foreground='" .. args.fg .. "'>Covid-19 "
                                .. args.departement .. "</span>")
    awful.spawn.easy_async(string.format(COMMAND, args.departement, args.indicateur),
                           function(stdout,stderr,reason,exit_code)
                               -- show_warning(stderr)
                               update_widget(covid_widget, stdout)
                           end
    )

    return covid_widget
end

return setmetatable(covid_widget, {
                        __call = function(_, args)
                            return worker(args)
                        end
})
