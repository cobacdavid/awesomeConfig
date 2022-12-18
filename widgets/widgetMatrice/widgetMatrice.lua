local awful         = require("awful")
local naughty       = require("naughty")
local wibox         = require("wibox")
local gears         = require("gears")
local beautiful     = require("beautiful")
local widget_themes = require("widgets.themes_matrice.themes")

local HOME_DIR = os.getenv("HOME")
local ICONS_DIR = HOME_DIR .. '/.config/awesome/icons/'
-- local WIDGET_DIR = HOME_DIR .. '/.config/awesome/widgets/batterieMatrice/'

local tabwidget = {}
-- 

local function niveau(effectif)
    local i = 1
    while i <= #limites and limites[i] < effectif do
        i = i + 1
    end
    return i-1
end

local function show_warning(message)
    naughty.notify{
        preset = naughty.config.presets.critical,
        title = 'Widget Matrice',
        text = message}
end

function tabwidget.worker(args)

    if args == nil then
        return widget
    end

    -- show_warning("OK")
    args = args or {}
    args.title                = args.title       or "widget"
    args.text                 = args.text        or "value"
    args.rect_width           = args.rect_width  or 2
    args.rect_height          = args.rect_height or 6
    args.fg                   = args.fg          or "#fff"
    args.color_of_empty_cells = args.color_of_empty_cells or "#000"
    args.with_border          = args.with_border
    args.margin_top           = args.margin_top  or 1
    -- two themes : grey or gradient
    args.theme                = args.theme       or 'gradient'
    args.n_colors             = args.n_colors    or 101
    args.from_color           = args.from_color  or "#0f0"
    args.to_color             = args.to_color    or "#f00"
    args.COMMANDE             = args.COMMANDE    or ""
    args.fun                  = args.fun         or function(s) return s  end
    
    local tabTheme
    if args.theme == "gradient" then
        tabTheme = widget_themes.gradtheme(args.n_colors,
                                           args.from_color,
                                           args.to_color)
    else
        tabTheme = widget_themes.gtheme(args.n_colors)
    end

    if args.with_border == nil then args.with_border = true end


    local ttextwidget = wibox.widget {
        -- markup = '<b>CPU</b>',
        align   = 'center',
        valign  = 'center',
        -- opacity = .75,
        font    = beautiful.font .. " 6",
        widget  = wibox.widget.textbox
    }

    local titlewidget = wibox.container {
        ttextwidget,
        direction = "east",
        widget  = wibox.container.rotate
    }

    local miroir = wibox.widget{
        reflection = {
            horizontal = false,
            vertical = true,
        },
        widget = wibox.container.mirror
    }

    local intextwidget = wibox.widget {
        align   = 'center',
        valign  = 'center',
        opacity = .75,
        font    = beautiful.font .. " 20",
        widget  = wibox.widget.textbox
    }

    local inimagewidget = wibox.widget {
        -- image   = ICONS_DIR .. "logo-covid.png",
        resize  = true,
        opacity = .75,
        halign  = "center",
        valign  = "center",
        widget  = wibox.widget.imagebox
    }

    local gwidget = wibox.widget {
        miroir,
        inimagewidget,
        intextwidget,
        layout = wibox.layout.stack
    }

    local widget = wibox.widget {
        titlewidget,
        gwidget,
        layout = wibox.layout.fixed.horizontal
    }

    ttextwidget:set_markup(args.title)

    local function get_square(count, color)
        if args.color_of_empty_cells ~= nil and
            color == tabTheme[0] then
            color = args.color_of_empty_cells
        end

        local square = wibox.widget{
            fit = function()
                return args.rect_width, args.rect_height
            end,
            draw = function(_, _, cr, _, _)
                cr:set_source(gears.color(color))
                cr:rectangle(
                    0,
                    0,
                    args.with_border and args.rect_width-1 or args.rect_width,
                    args.with_border and args.rect_height-1 or args.rect_height
                )
                cr:fill()
            end,
            layout = wibox.widget.base.make_widget
        }

        return square
    end

    local update_widget = function(_, sortie, _, _, _)
        local row = {layout = wibox.layout.fixed.horizontal}
        local col = {layout = wibox.layout.fixed.vertical}
        --
        local couleurSortie
        --
        -- local couleurOff = args.color_of_empty_cells
        for i = 0, 99 do
            if i % 20 == 0 then
                table.insert(col, row)
                row = {layout = wibox.layout.fixed.horizontal}
            end
            couleur = i < sortie and tabTheme[i+1] or tabTheme[i+1]:sub(1, 7) .. "50"
            if i == sortie then
                couleurSortie = tabTheme[i+1]:sub(1, 7) .. "ee"
            end
            table.insert(row, get_square(sortie, couleur))
        end
        table.insert(col, row)
        
        miroir:setup({
                col,
                top = args.margin_top,
                layout = wibox.container.margin
        })

        return couleurSortie
    end

    gears.timer({
            timeout = 60,
            call_now = true,
            autostart = true,
            callback = function()
                awful.spawn.easy_async(args.COMMANDE,
                                       function(stdout)
                                           local valeur = args.fun(stdout)
                                           local coul = update_widget(widget, tonumber(valeur))
                                           if args.text == 'value' then
                                               intextwidget:set_markup("<b><span foreground='" .. coul .. "'>" .. valeur .. "</span></b>")
                                           end
                                       end
                )
            end
    })

    return widget
end

return setmetatable(widget, {
                        __call = function(_, args)
                            return tabwidget.worker(args)
                        end
})
