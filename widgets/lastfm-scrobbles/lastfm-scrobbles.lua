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
local widget_themes = require("widgets.lastfm-scrobbles.themes")
--
--
local HOME_DIR = os.getenv('HOME')
local ICONS_DIR = HOME_DIR .. '/.config/awesome/icons/'
--
--
local COMMAND1 = [[ bash -c "curl -s http://ws.audioscrobbler.com/2.0/\?method\=user.getrecenttracks\&user\=%s\&api_key\=%s\&page\=1\&from\=%s\&limit\=200\&format\=json | jq -r '.recenttracks.\"@attr\".totalPages, .recenttracks.track[].date.uts'" ]]
local COMMAND2 = [[ bash -c "i=2
while [ $i -le %s ]
do
    curl -s http://ws.audioscrobbler.com/2.0/\?method\=user.getrecenttracks\&user\=%s\&api_key\=%s\&page\=${i}\&from\=%s\&limit\=200\&format\=json | jq -r '.recenttracks.track[].date.uts'
    ((i++))
done"
]]
local number_of_max_downloaded_pages = 10

local function hier(date)
    -- date est de la forme YYYYMMDD
    local y, m, d = string.match(date, "(%d%d%d%d)(%d%d)(%d%d)")
    d = d - 1
    local j = os.time({year=y, month=m, day=d})
    return os.date("%Y%m%d", j)
end

local function ilyaunan()
    local aujourdhui = os.date("*t")
    local unanavant  = os.date("%Y%m%d",
                               os.time({
                                       year  = aujourdhui.year-1,
                                       month = aujourdhui.month,
                                       day   = aujourdhui.day
                               })
    )
    return unanavant
end

local function niveau(effectif)
    local limits = {0, 1, 8, 20}
    local i = 1
    while i <= 4 and limits[i] < effectif do
        i = i + 1
    end
    return i-1
end

local ecoute_widget = wibox.widget{
    reflection = {
        horizontal = true,
        vertical = true,
    },
    widget = wibox.container.mirror
}

local lastfm_textwidget = wibox.widget {
    align  = 'right',
    valign = 'bottom',
    opacity = .75,
    font = "Arial 10",
    widget = wibox.widget.textbox
}

local lastfm_imagewidget = wibox.widget {
    image   = ICONS_DIR .. "logo-lastfm.png",
    resize  = true,
    opacity = .5,
    halign  = "center",
    widget  = wibox.widget.imagebox
}

local lastfm_widget = wibox.widget {
    ecoute_widget,
    lastfm_imagewidget,
    lastfm_textwidget,
    layout = wibox.layout.stack
}

local function leWidget(args)

    args = args or {}
    args.username             = args.username
    args.api_key              = args.api_key
    args.from_date            = args.from_date   or ilyaunan()
    args.square_size          = args.square_size or 4
    args.color_of_empty_cells = args.color_of_empty_cells
    args.with_border          = args.with_border
    args.margin_top           = args.margin_top  or 1
    args.theme                = args.theme       or 'standard'

    if widget_themes[args.theme] == nil then
        show_warning('Theme ' .. args.theme .. ' does not exist')
        args.theme = 'standard'
    end

    local y, m, d = string.match(args.from_date, "(%d%d%d%d)(%d%d)(%d%d)")
    args.from_date = os.time({year=y, month=m, day=d})

    if args.with_border == nil then args.with_border = true end

    local function get_square(date, color)
        if args.color_of_empty_cells ~= nil and
            color == widget_themes[args.theme][0] then
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
            awful.tooltip {
                text = string.format("%s", tostring(date)),
                mode = "mouse"
            }:add_to_object(square)
        end
        return square
    end


    local col = {layout = wibox.layout.fixed.vertical}
    local row = {layout = wibox.layout.fixed.horizontal}
    local day_idx = 6 - os.date('%w')
    for _ = 1, day_idx do
        table.insert(col, get_square(nil, args.color_of_empty_cells))
    end

    local update_widget = function(_, sortie, _, _, _)

        local tab = {}
        local max = tonumber(os.date("%Y%m%d"))
        local min = max
        local total = 0

        for ecoute in sortie:gmatch("[^\r\n]+") do
            -- on supprime la potentielle chanson en cours d'écoute
            -- et le nombre de pages à téélcharger qui est resté
            -- en tête des résultats
            if ecoute ~= "null" and tonumber(ecoute) > 1000000 then
                local date = tonumber(os.date("%Y%m%d", ecoute))
                if date < min then
                    min = date
                end
                tab[date] = tab[date] == nil and 1 or tab[date] + 1
                total = total + 1
            end
        end

        local jour = max
        while jour >= min do
            tab[jour] = tab[jour] == nil and 0 or tab[jour]
            if day_idx %7 == 0 then
                table.insert(row, col)
                col = {layout = wibox.layout.fixed.vertical}
            end
            --
            local couleur = widget_themes[args.theme][niveau(tab[jour])]
            table.insert(col, get_square(jour, couleur))
            day_idx = day_idx + 1
            jour = tonumber(hier(jour))
        end
        
        ecoute_widget:setup({
                row,
                top = args.margin_top,
                layout = wibox.container.margin
        })

        lastfm_textwidget:set_markup("<b>" .. tostring(total) .. " scrobbles</b>")
    end

    local function requetes(user, apikey, from_date)
        -- attention la première valeur du tableau resultats
        -- n'est pas une date mais un effectif de pages ->
        -- à ne pas interpréter comme une date
        local resultats

        local commande = string.format(COMMAND1, user, apikey, from_date)
        awful.spawn.easy_async(commande,
                               function(stdout)
                                   resultats = stdout
                                   -- récupération du nombre de pages nécessaires
                                   local tP
                                   for totalPages in resultats:gmatch("[^\r\n]+") do
                                       tP = tonumber(totalPages)
                                       break
                                   end
                                   -- limite du nombre de téléchargements
                                   if tP <  number_of_max_downloaded_pages then
                                       commande = string.format(COMMAND2, tP, user, apikey, from_date)
                                       awful.spawn.easy_async(
                                           commande,
                                           function(stdout2, stderr, reason, exit_code)
                                               resultats = resultats .. stdout2
                                               update_widget(lastfm_widget, resultats)
                                           end
                                       )
                                   end
                               end
        )
    end

    if args.api_key ~= nil then
        requetes(args.username, args.api_key, args.from_date)
    end


    return lastfm_widget
end

return setmetatable(lastfm_widget, {__call=function(_, args)
                                        return leWidget(args)
                   end})
