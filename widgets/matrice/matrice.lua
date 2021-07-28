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
local widget_themes = require("widgets.matrice.themes")
--
--
local HOME_DIR = os.getenv('HOME')
local ICONS_DIR = HOME_DIR .. '/.config/awesome/icons/'
--
local COMMAND = [[ bash -c "shuf -i 1-%s -n 50 | sort -n" ]]
--
-- 
-- local function niveau(effectif, limites)
--     local i = 1
--     while i <= #limites and limites[i] < effectif do
--         i = i + 1
--     end
--     return i-1
-- end

local miroir = wibox.widget{
    reflection = {
        horizontal = true,
        vertical = true,
    },
    widget = wibox.container.mirror
}

-- local matrice_textwidget = wibox.widget {
--     align  = 'right',
--     valign = 'bottom',
--     opacity = .75,
--     font = "Arial 10",
--     widget = wibox.widget.textbox
-- }

-- local matrice_imagewidget = wibox.widget {
--     -- image   = ICONS_DIR .. "logo-lastfm.png",
--     resize  = true,
--     opacity = .5,
--     halign  = "center",
--     widget  = wibox.widget.imagebox
-- }

local matrice_widget = wibox.widget {
    miroir,
    --matrice_imagewidget,
    --matrice_textwidget,
    layout = wibox.layout.stack
}

local function create_square(args, count, color)
    -- if args.color_of_empty_cells ~= nil and
    --     color == tabTheme[0] then
    --     color = args.color_of_empty_cells
    -- end

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

    -- awful.tooltip {
    --     text = string.format("%s", tostring(count)),
    --     mode = "mouse"
    -- }
    
    return square
end


local function leWidget(args, tableau)

    if args == nil then
        return miroir
    end
    
    args = args or {}
    args.width                = args.width       or 7
    args.height               = args.height      or 7
    args.square_size          = args.square_size or 4
    args.color_of_empty_cells = args.color_of_empty_cells
    args.with_border          = args.with_border
    args.margin_top           = args.margin_top  or 0
    args.theme                = args.theme       or 'gradient'
    args.n_colors             = args.n_colors    or 4
    args.from_color           = args.from_color  or "#0000ff55"
    args.to_color             = args.to_color    or "#88ff00"

    -- local tabTheme
    -- if args.theme == "gradient" then
    --     tabTheme = widget_themes.gradtheme(args.n_colors,
    --                                        args.from_color,
    --                                        args.to_color)
    -- else
    --     tabTheme = widget_themes.gtheme(args.n_colors)
    -- end
    
    if args.with_border == nil then args.with_border = true end


    
    local col = {layout = wibox.layout.fixed.vertical}
    local row = {layout = wibox.layout.fixed.horizontal}
    local cell = 0
    local j = 1
    local color

    
    while cell < args.width * args.height do

        if cell % args.height == 0 then
            table.insert(row, col)
            col = {layout = wibox.layout.fixed.vertical}
        end
        --
        if j <= #tableau and tableau[j] == cell + 1 then
            j = j + 1
            color = "#ffffff"
        else
            color = args.color_of_empty_cells
        end
        local s = create_square(args, 0, color)
        -- table.insert(squares, s)
        table.insert(col, s)
        cell = cell + 1
    end
    
    miroir:setup({
            row,
            top = args.margin_top,
            layout = wibox.container.margin
    })


    awful.spawn.easy_async(string.format(COMMAND, args.width * args.height),
                           function(stdout)
                               -- naughty.notify({ text=tostring(stdout)})
                               local t = {}
                               for n in stdout:gmatch("[^\r\n]+") do
                                   table.insert(t, tonumber(n))
                               end
                               leWidget(args, t)
                           end
    )
    
    -- local timer = gears.timer({
    --         timeout = 2,
    --         call_now = true,
    --         autostart = true,
    --         callback = function()
               
    --             )
    --         end
    -- })


    return matrice_widget
end

-- local update_widget = function(_, sortie, _, _, _)

--     -- local tab = {}
--     -- local maxi = 1

--     -- -- par crroissance exponentielle en k valeurs (variables user)
--     -- -- 0 1 k k² ... k^(n-2)=effectifMax
--     -- local k = effectifMax ^ (1 / (args.n_colors - 2))
--     -- local limits = {0, 1}
--     -- for i = 1, args.n_colors-2 do
--     --     table.insert(limits, math.floor(k ^ i))
--     -- end

--     local N = args.width * args.height
--     awful.spawn.easy_async(string.format(COMMAND, N),
--                            function(stdout)
--                                for i = 1, N do
--                                    squares[i]:set_
--                                end
--                            end
--     )
-- end



-- local function requetes(user, apikey, from_date)
--     local commande = string.format(COMMAND, user, apikey, from_date)
--     awful.spawn.easy_async(commande,
--                            function(stdout)
                               
--                            end
--     )
-- end


return setmetatable(matrice_widget, {__call=function(_, args)
                                         return leWidget(args, {})
                   end})
