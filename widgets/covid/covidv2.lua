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
--
local awful         = require("awful")
local naughty       = require("naughty")
local wibox         = require("wibox")
local gears         = require("gears")
local widget_themes = require("widgets.themes_matrice.themes")

local HOME_DIR   = os.getenv("HOME")
local WIDGET_DIR = HOME_DIR .. '/.config/awesome/widgets/covid/'
local ICONS_DIR  = HOME_DIR .. '/.config/awesome/icons/'
--
--
-- local function indexInTable(element, t)
--     for i, v in ipairs(t) do
--         if v == element then
--             return i
--         end
--         -- return nil si pas trouvé
--         return nil
--     end
-- end

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

local function show_warning(message)
    naughty.notify{
        preset = naughty.config.presets.critical,
        title = 'Covid Widget',
        text = message}
end
--
--
widget = {}
widget.indicateurs = {
    hosp         = "total hospitalisés", -- OK
    incid_hosp   = "nouveaux hospitalisés", -- OK
    rea          = "total réanimation", -- OK
    incid_rea    = "nouveaux réanimation", -- OK
    rad          = "total guéris", -- OK
    incid_rad    = "nouveaux guéris", -- OK
    dchosp       = "total décès hôpital", -- OK
    incid_dchosp = "nouveaux décès hôpital", -- OK
    pos          = "cas positifis -1", -- OK
    pos_7j       = "cas positifs -7", -- OK
    tx_pos       = "taux + test", -- OK
    tx_incid     = "taux incidence", -- OK
    TO           = "taux occupation", -- OK
    R            = "évolution du R0" -- OK
}

widget.keysIndicateurs = gears.table.keys(widget.indicateurs)
widget.indexIndicateur = 4
widget.commande = [[bash -c ]]


function widget.worker(args)
    -- show_warning(args)
    local miroir = wibox.widget{
        reflection = {
            horizontal = true,
            vertical = true,
        },
        widget = wibox.container.mirror
    }

    local covid_textwidget = wibox.widget {
        align   = 'right',
        valign  = 'bottom',
        opacity = .3,
        font    = "Arial 8",
        widget  = wibox.widget.textbox
    }
    
    local covid_imagewidget = wibox.widget {
        image   = ICONS_DIR .. "logo-covid.png",
        resize  = true,
        opacity = .15,
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

    if args == nil then
        return widget.covid_widget
    end
    
    args = args or {}
    args.departement          = args.departement or "Maine-et-Loire"
    args.from_date            = args.from_date   or "20200318"
    args.square_size          = args.square_size or 4
    args.fg                   = args.fg          or "#ffffff"
    args.color_of_empty_cells = args.color_of_empty_cells
    args.with_border          = args.with_border
    args.margin_top           = args.margin_top  or 1
    -- two themes : grey or gradient
    args.theme                = args.theme       or 'gradient'
    args.n_colors             = args.n_colors    or 15
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
    --
    local tau = 2 * math.pi
    local moitieDim = args.square_size / 2
    local rayon = args.with_border and  moitieDim - 1
        or moitieDim
    --
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
                -- cr:rectangle(
                --     0,
                --     0,
                --     args.with_border and args.square_size-1 or args.square_size,
                --     args.with_border and args.square_size-1 or args.square_size
                -- )
                cr:arc(moitieDim, moitieDim, rayon, 0, tau)
                cr:fill()
            end,
            layout = wibox.widget.base.make_widget
        }

        if date ~= nil then
            local year, month, day = tostring(date):match("(%d%d%d%d)(%d%d)(%d%d)")
            date = os.date("%a %d %b %Y",
                           os.time({year=year, month=month, day=day}))
            awful.tooltip {
                text = string.format("%s %s : %s",
                                     widget.indicateurs[widget.keysIndicateurs[widget.indexIndicateur]],
                                     date,
                                     math.floor(count)),
                mode = "mouse"
            }:add_to_object(square)
        end

        return square
    end

    local update_widget = function(_, sortie, _, _, _)
        --
        local tab = {}
        local max = tonumber(os.date("%Y%m%d"))
        local min = max
        local effectifMax = 0

        local col = {layout = wibox.layout.fixed.vertical}
        local row = {layout = wibox.layout.fixed.horizontal}
        -- début le lundi
        local day_idx = 6 - (os.date('%w') - 1)%7
        for _ = 1, day_idx do
            table.insert(col, get_square(nil, 0, args.color_of_empty_cells))
        end

        -- parcours date par date, détermination des dates limites
        -- et de l'effectif maximal -> blanc sur la grille
        for resultatDuJour in sortie:gmatch("[^\r\n]+") do
            local date, effectif = resultatDuJour:match("(.*)%s+(.*)")
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

        -- show_warning(tostring(min) .. " " .. tostring(max))
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
        local couleur
        while jour >= min do
            tab[jour] = tab[jour] == nil and 0 or tab[jour]
            if tab[jour] == -1 then
                tab[jour] = 0
                couleur = "#f00"
            else
                couleur = tabTheme[niveau(tab[jour], limits)]
            end

            if day_idx %7 == 0 then
                table.insert(row, col)
                col = {layout = wibox.layout.fixed.vertical}
            end
            --
            table.insert(col, get_square(jour, tab[jour], couleur))
            day_idx = day_idx + 1
            jour = tonumber(hier(jour))
        end

        miroir:setup({
                row,
                top = args.margin_top,
                layout = wibox.container.margin
        })
    end
    
    covid_textwidget:set_markup("<b><span foreground='" .. args.fg .. "'>Covid-19 "
                                .. args.departement .. "</span></b>")
    --
    awful.spawn.easy_async([[ bash -c "python3 ]] .. WIDGET_DIR .. [[recup_gouv.py" ]],
                           function(stdout,stderr,reason,exit_code)
                               -- 
                           end
    )
    local indicateur = widget.keysIndicateurs[widget.indexIndicateur]
    local commande = [[ bash -c "cat ]] .. WIDGET_DIR .. [[donnees/%s"]]
    awful.spawn.easy_async(string.format(commande, indicateur),
                           function(stdout,stderr,reason,exit_code)
                               -- show_warning(stdout)
                               update_widget(covid_widget, stdout)
                           end
    )
    covid_widget:buttons({
            awful.button({}, 3,
                         function()
                             widget.indexIndicateur = 1 + widget.indexIndicateur  % #widget.keysIndicateurs
                             indicateur = widget.keysIndicateurs[widget.indexIndicateur]
                             commande = [[ bash -c "cat ]] .. WIDGET_DIR .. [[donnees/%s" ]]
                             awful.spawn.easy_async(string.format(commande, indicateur),
                                                    function(stdout,stderr,reason,exit_code)
                                                        update_widget(covid_widget, stdout)
                                                    end
                             )
                         end
            )
    })

    return covid_widget
end


return widget
