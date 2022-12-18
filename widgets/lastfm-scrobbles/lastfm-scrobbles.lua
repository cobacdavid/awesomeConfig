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
local awful     = require("awful")
local wibox     = require("wibox")
local gears     = require("gears")
local widget_themes = require("widgets.themes_matrice.themes")
--
--
local HOME_DIR = os.getenv('HOME')
local ICONS_DIR = HOME_DIR .. '/.config/awesome/icons/'
local WIDGET_DIR = HOME_DIR .. '/.config/awesome/widgets/lastfm-scrobbles/'
--
-- retrieve data from local save
COMMAND = [[ bash -c "cat ]] .. WIDGET_DIR ..
    [[donnees/%s.json | jq  -r '.[].date.uts'"]]
COMMAND_MAJ = [[ bash -c "]] .. WIDGET_DIR ..
    "mise_a_jour_annee.sh " .. tostring(os.date("%Y")) .. [["]]
--
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

local function show_warning(message)
    naughty.notify{
        preset = naughty.config.presets.critical,
        title = 'LastFM Widget',
        text = message}
end
--
local widget = {}
--
widget.ecoute_widget = wibox.widget{
    reflection = {
        horizontal = true,
        vertical = true,
    },
    widget = wibox.container.mirror
}

widget.lastfm_textwidget = wibox.widget {
    align  = 'right',
    valign = 'bottom',
    opacity = .4,
    font = "Arial 10",
    widget = wibox.widget.textbox
}

widget.lastfm_imagewidget = wibox.widget {
    image   = ICONS_DIR .. "logo-lastfm-rouge.png",
    resize  = true,
    opacity = .15,
    halign  = "center",
    widget  = wibox.widget.imagebox
}

widget.lastfm_widget = wibox.widget {
    widget.ecoute_widget,
    widget.lastfm_imagewidget,
    widget.lastfm_textwidget,
    layout = wibox.layout.stack
}

function widget.leWidget(args)

    if args == nil then
        return widget.lastfm_widget
    end

    args = args or {}
    widget.year               = args.year
    -- args.from_date            = args.from_date   or ilyaunan()
    args.square_size          = args.square_size or 4
    args.color_of_empty_cells = args.color_of_empty_cells
    args.with_border          = args.with_border
    args.margin_top           = args.margin_top  or 1
    args.theme                = args.theme       or 'standard'
    args.n_colors             = args.n_colors    or 4
    args.from_color           = args.from_color  or "#0000ff55"
    args.to_color             = args.to_color    or "#88ff00"
    args.fg                   = args.fg          or "#fff"

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
            local year, month, day = tostring(date):match("(%d%d%d%d)(%d%d)(%d%d)")
            date = os.date("%a %d %b %Y",
                           os.time({year=year, month=month, day=day}))
            awful.tooltip {
                text = string.format("%s : %s", tostring(date), tostring(count)),
                mode = "mouse"
            }:add_to_object(square)
        end
        return square
    end

    local update_widget = function(_, sortie, _, _, _)
        if args.year ~= nil then
            args.from_date = tostring(widget.year) .. "0101"
            args.to_date   = tostring(widget.year) .. "1231"
        end
         
        local tab = {}
        local max = tonumber(args.to_date)
        local min = tonumber(args.from_date)
        local effectifMax = 0

        for ecoute in sortie:gmatch("[^\r\n]+") do
            -- on supprime la potentielle chanson en cours d'écoute
            -- et le nombre de pages à télécharger qui est resté
            -- en tête des résultats
            if ecoute ~= "null" and tonumber(ecoute) > 1000000 then
                local date = tonumber(os.date("%Y%m%d", ecoute))
                -- if date < min then
                --    min = date
                -- end
                tab[date] = tab[date] == nil and 1 or tab[date] + 1
                if tab[date] > effectifMax then
                    effectifMax = tab[date]
                end
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
        local total = 0
        local jour = max
        while jour >= min do
            tab[jour] = tab[jour] == nil and 0 or tab[jour]
            total = total + tab[jour]
            if day_idx %7 == 0 then
                table.insert(row, col)
                col = {layout = wibox.layout.fixed.vertical}
            end
            --
            local couleur = tabTheme[niveau(tab[jour], limits)]
            table.insert(col, get_square(jour, tab[jour], couleur))
            day_idx = day_idx + 1
            jour = tonumber(hier(jour))
        end
        table.insert(row, col)
        
        widget.ecoute_widget:setup({
                row,
                top = args.margin_top,
                layout = wibox.container.margin
        })
        --
        local texte = "<span font_weight='ultrabold' foreground='" .. args.fg .. "'>"
        texte = args.year == nil and texte or texte .. tostring(widget.year) .. " : "
        texte = texte .. tostring(total) .. " scrobbles</span>"
        widget.lastfm_textwidget:set_markup(texte)
    end
    --
    -- commande affichage annee demandée
    awful.spawn.easy_async(COMMAND_MAJ,
                           function(stdout)
                               -- le script renvoie le nom d'utilisateur
                               -- ce qui peut servir pour élaborer des liens
                               -- vers le site (voir tagWibar.lua)
                               widget.username = stdout
                               local commande = string.format(COMMAND, widget.year)
                               awful.spawn.easy_async(commande,
                                                      function(stdout)
                                                          local resultats = stdout
                                                          update_widget(widget.lastfm_widget, resultats)
                                                      end
                               )
                           end
    )
    widget.lastfm_widget:buttons({
            awful.button({}, 3,
                function()
                    -- année suivante si elle existe
                    widget.year = math.floor(widget.year + 1)
                    if not gears.filesystem.file_readable(WIDGET_DIR .. "donnees/" .. widget.year .. ".json") then
                        -- retour à 2002 (année creation de last.fm)
                        widget.year = 2002
                        while not gears.filesystem.file_readable(WIDGET_DIR .. "donnees/" .. widget.year .. ".json") do
                            widget.year = widget.year + 1
                        end
                    end
                    local commande = string.format(COMMAND, widget.year)
                    awful.spawn.easy_async(commande,
                                           function(stdout)
                                               local resultats = stdout
                                               update_widget(widget.lastfm_widget, resultats)
                                           end
                    )
                end
            ),
            awful.button({}, 1,
                function()
                    -- année précédente si elle existe
                    widget.year = math.floor(widget.year - 1)
                    if not gears.filesystem.file_readable(WIDGET_DIR .. "donnees/" .. widget.year .. ".json") then
                        -- retour à cette année
                        widget.year = os.date("%Y")
                        while not gears.filesystem.file_readable(WIDGET_DIR .. "donnees/" .. widget.year .. ".json") do
                            widget.year = widget.year - 1
                        end
                    end
                    local commande = string.format(COMMAND, widget.year)
                    awful.spawn.easy_async(commande,
                                           function(stdout)
                                               local resultats = stdout
                                               update_widget(widget.lastfm_widget, resultats)
                                           end
                    )
                end
            )
    })

    --
    return widget.lastfm_widget
end

return setmetatable(widget, {__call=function(_, args)
                                 return widget.leWidget(args)
                   end})
