-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2021
-- copyright: CC-BY-NC-SA
-------------------------------------------------
local awful         = require("awful")
local naughty       = require("naughty")
local wibox         = require("wibox")
local gears         = require("gears")
local json          = require("json")

local HOME_DIR   = os.getenv("HOME")
local WIDGET_DIR = HOME_DIR .. '/.config/awesome/widgets/covid/'
local ICONS_DIR  = HOME_DIR .. '/.config/awesome/icons/'
local COMMAND1   = [[ bash -c "dtv2reader -o %s |jq -c 'to_entries[]| [ .key, .value[] ]'" ]]
local COMMAND2   = [[ bash -c "cd %s && ls -1 *.json" ]]
--
local function show_warning(message)
    naughty.notify{
        preset = naughty.config.presets.critical,
        title = 'Drevo Tyrfing V2 Widget',
        text = message}
end
--
--
widget = {}

function widget.worker(args)
    widget.jsonFiles = {}
    widget.jsonDefaultIndex = 1
    -- show_warning(args)
    local conteneur = wibox.widget({
            bg= "#000",
            opacity = .5,
            widget = wibox.container.background
    })
    if args == nil then
        return conteneur
    end

    args = args or {}
    args.square_size          = args.square_size or 4
    args.json_path            = args.json_path   or HOME_DIR
    args.bg                   = args.bg          or "#0000"
    args.fg                   = args.fg          or "#ffffff"
    args.color_of_empty_cells = args.color_of_empty_cells
    args.with_border          = args.with_border or 0
    args.margin_top           = args.margin_top  or 1

    -- show_warning(tostring(args.square_size))
    if args.with_border == nil then args.with_border = true end
    --
    local taille0 = 1.3
    local taille1 = args.square_size -- 1.3 cm
    local taille2 = taille1 * 1.8 / taille0 -- ctrl - maj - win - alt ...
    local taille3 = taille1 * 2.2 / taille0 -- tab et entree (...
    local taille4 = taille1 * 2.7 / taille0 -- verrmaj
    local taille5 = taille1 * 3.15 / taille0 -- backspace
    local taille6 = taille1 * 4.6 / taille0 -- maj droit
    local taille7 = taille1 * 11.2 / taille0 -- espace
    --
    local taille_sep0 = taille1 / 2
    local taille_sep1 = taille1 * 2.5 / taille0 -- entre esc et f1
    local taille_sep2 = taille1 * 1.6 / taille0 -- entre les groupes de fn
    --
    local wpopup = wibox {
        ontop = true,
        visible = false,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 4)
        end,
        border_width = 1,
        border_color = beautiful.bg_focus,
        max_widget_size = 500,
        height = 500,
        width = 300,
    }
    --
    local function get_rectangle(w, color, h)
        h = h == nil and args.square_size or h
        local square = wibox.widget{
            fit = function()
                return w, h
            end,
            draw = function(_, _, cr, _, _)
                cr:set_source(gears.color(color))
                cr:rectangle(
                    0,
                    0,
                    w,
                    h
                )
                cr:fill()
            end,
            layout = wibox.widget.base.make_widget
        }
        return square
    end

    local function get_square(color)
        return get_rectangle(args.square_size, color)
    end
    --
    local sep0 = {
        id = "spacer",
        widget = get_rectangle(taille_sep0, "#0000")
    }
    local sep1 = {
        id = "spacer",
        widget = get_rectangle(taille_sep1, "#0000")
    }
    local sep2 = {
        id = "spacer",
        widget = get_rectangle(taille_sep2, "#0000")
    }
    --
    local vsep0 = {
        layout = wibox.layout.fixed.horizontal,
        get_rectangle(0, "#0000", taille1 * 0.75)
    }
    local vsep1 = {
        layout = wibox.layout.fixed.horizontal,
        get_rectangle(0, "#0000", taille1 / 4)
    }
    --
    local update_widget = function(couleurs)
        local couleursT = {}
        for keyColor in couleurs:gmatch("[^\r\n]+") do
            local key, r, g, b = keyColor:match("(.*),(%d+),(%d+),(%d+)]")
            key = key:sub(3, key:len() - 1)
            couleursT[key] = string.format("#%02x%02x%02x", r, g, b)
        end
        --        show_warning("OK")
        local col = {layout = wibox.layout.fixed.vertical,
                     {
                         layout = wibox.layout.fixed.horizontal,
                         {
                             id = "esc",
                             widget = get_square(couleursT['esc'])
                         },
                         sep1,
                         {
                             id = "f1",
                             widget = get_square(couleursT['f1'])
                         },
                         sep0,
                         {
                             id = "f2",
                             widget = get_square(couleursT['f2'])
                         },
                         sep0,
                         {
                             id = "f3",
                             widget = get_square(couleursT['f3'])
                         },
                         sep0,
                         {
                             id = "f4",
                             widget = get_square(couleursT['f4'])
                         },
                         sep2,
                         {
                             id = "f5",
                             widget = get_square(couleursT['f5'])
                         },
                         sep0,
                         {
                             id = "f6",
                             widget = get_square(couleursT['f6'])
                         },
                         sep0,
                         {
                             id = "f7",
                             widget = get_square(couleursT['f7'])
                         },
                         sep0,
                         {
                             id = "f8",
                             widget = get_square(couleursT['f8'])
                         },
                         sep2,
                         {
                             id = "f9",
                             widget = get_square(couleursT['f9'])
                         },
                         sep0,
                         {
                             id = "f10",
                             widget = get_square(couleursT['f10'])
                         },
                         sep0,
                         {
                             id = "f11",
                             widget = get_square(couleursT['f11'])
                         },
                         sep0,
                         {
                             id = "f12",
                             widget = get_square(couleursT['f12'])
                         },
                         
                     },
                     vsep0,
                     {
                         layout = wibox.layout.fixed.horizontal,
                         {
                             id = "²",
                             widget = get_square(couleursT['²'])
                         },
                         sep0,
                         {
                             id = "1",
                             widget = get_square(couleursT['1'])
                         },
                         sep0,
                         {
                             id = "2",
                             widget = get_square(couleursT['2'])
                         },
                         sep0,
                         {
                             id = "3",
                             widget = get_square(couleursT['3'])
                         },
                         sep0,
                         {
                             id = "4",
                             widget = get_square(couleursT['4'])
                         },
                         sep0,
                         {
                             id = "5",
                             widget = get_square(couleursT['5'])
                         },
                         sep0,
                         {
                             id = "6",
                             widget = get_square(couleursT['6'])
                         },
                         sep0,
                         {
                             id = "7",
                             widget = get_square(couleursT['7'])
                         },
                         sep0,
                         {
                             id = "8",
                             widget = get_square(couleursT['8'])
                         },
                         sep0,
                         {
                             id = "9",
                             widget = get_square(couleursT['9'])
                         },
                         sep0,
                         {
                             id = "0",
                             widget = get_square(couleursT['0'])
                         },
                         sep0,
                         {
                             id = ")",
                             widget = get_square(couleursT[')'])
                         },
                         sep0,
                         {
                             id = "=",
                             widget = get_square(couleursT['='])
                         },
                         sep0,
                         {
                             id = "BACKS",
                             widget = get_rectangle(taille5, couleursT['BACKS'])
                         }
                         
                     },
                     vsep1,
                     {
                         layout = wibox.layout.fixed.horizontal,
                         {
                             id = "tab",
                             widget = get_rectangle(taille3, couleursT['tab'])
                         },
                         sep0,
                         {
                             id = "a",
                             widget = get_square(couleursT['a'])
                         },
                         sep0,
                         {
                             id = "z",
                             widget = get_square(couleursT['z'])
                         },
                         sep0,
                         {
                             id = "e",
                             widget = get_square(couleursT['e'])
                         },
                         sep0,
                         {
                             id = "r",
                             widget = get_square(couleursT['r'])
                         },
                         sep0,
                         {
                             id = "t",
                             widget = get_square(couleursT['t'])
                         },
                         sep0,
                         {
                             id = "y",
                             widget = get_square(couleursT['y'])
                         },
                         sep0,
                         {
                             id = "u",
                             widget = get_square(couleursT['u'])
                         },
                         sep0,
                         {
                             id = "i",
                             widget = get_square(couleursT['i'])
                         },
                         sep0,
                         {
                             id = "o",
                             widget = get_square(couleursT['o'])
                         },
                         sep0,
                         {
                             id = "p",
                             widget = get_square(couleursT['p'])
                         },
                         sep0,
                         {
                             id = "^",
                             widget = get_square(couleursT['^'])
                         },
                         sep0,
                         {
                             id = "$",
                             widget = get_square(couleursT['$'])
                         },
                         sep0,
                         {
                             id = "enter",
                             widget = get_rectangle(taille3, couleursT['enter'])
                         }
                         
                     },
                     vsep1,
                     {
                         layout = wibox.layout.fixed.horizontal,
                         {
                             id = "caps",
                             widget = get_rectangle(taille4, couleursT['caps'])
                         },
                         sep0,
                         {
                             id = "q",
                             widget = get_square(couleursT['q'])
                         },
                         sep0,
                         {
                             id = "s",
                             widget = get_square(couleursT['s'])
                         },
                         sep0,
                         {
                             id = "d",
                             widget = get_square(couleursT['d'])
                         },
                         sep0,
                         {
                             id = "f",
                             widget = get_square(couleursT['f'])
                         },
                         sep0,
                         {
                             id = "g",
                             widget = get_square(couleursT['g'])
                         },
                         sep0,
                         {
                             id = "h",
                             widget = get_square(couleursT['h'])
                         },
                         sep0,
                         {
                             id = "j",
                             widget = get_square(couleursT['j'])
                         },
                         sep0,
                         {
                             id = "k",
                             widget = get_square(couleursT['k'])
                         },
                         sep0,
                         {
                             id = "l",
                             widget = get_square(couleursT['l'])
                         },
                         sep0,
                         {
                             id = "m",
                             widget = get_square(couleursT['m'])
                         },
                         sep0,
                         {
                             id = "ù",
                             widget = get_square(couleursT['ù'])
                         },
                         sep0,
                         {
                             id = "*",
                             widget = get_square(couleursT['*'])
                         }
                         
                     },
                     vsep1,
                     {
                         layout = wibox.layout.fixed.horizontal,
                         {
                             id = "lshift",
                             widget = get_rectangle(taille2, couleursT['lshift'])
                         },
                         sep0,
                         {
                             id = "<",
                             widget = get_square(couleursT['<'])
                         },
                         sep0,
                         {
                             id = "w",
                             widget = get_square(couleursT['w'])
                         },
                         sep0,
                         {
                             id = "x",
                             widget = get_square(couleursT['x'])
                         },
                         sep0,
                         {
                             id = "c",
                             widget = get_square(couleursT['c'])
                         },
                         sep0,
                         {
                             id = "v",
                             widget = get_square(couleursT['v'])
                         },
                         sep0,
                         {
                             id = "b",
                             widget = get_square(couleursT['b'])
                         },
                         sep0,
                         {
                             id = "n",
                             widget = get_square(couleursT['n'])
                         },
                         sep0,
                         {
                             id = ",",
                             widget = get_square(couleursT[','])
                         },
                         sep0,
                         {
                             id = ";",
                             widget = get_square(couleursT[';'])
                         },
                         sep0,
                         {
                             id = ":",
                             widget = get_square(couleursT[':'])
                         },
                         sep0,
                         {
                             id = "!",
                             widget = get_square(couleursT['!'])
                         },
                         sep0,
                         {
                             id = "rshift",
                             widget = get_rectangle(taille6, couleursT['rshift'])
                         }
                         
                     },
                     vsep1,
                     {
                         layout = wibox.layout.fixed.horizontal,
                         {
                             id = "lctrl",
                             widget = get_rectangle(taille2, couleursT['lctrl'])
                         },
                         sep0,
                         {
                             id = "win",
                             widget = get_rectangle(taille2, couleursT['win'])
                         },
                         sep0,
                         {
                             id = "lalt",
                             widget = get_rectangle(taille2, couleursT['lalt'])
                         },
                         sep0,
                         {
                             id = "space",
                             widget = get_rectangle(taille7, couleursT['space'])
                         },
                         sep0,
                         {
                             id = "ralt",
                             widget = get_rectangle(taille2, couleursT['ralt'])
                         },
                         sep0,
                         {
                             id = "FN",
                             widget = get_rectangle(taille2, couleursT['FN'])
                         },
                         sep0,
                         {
                             id = "compo",
                             widget = get_rectangle(taille2, couleursT['compo'])
                         },
                         sep0,
                         {
                             id = "rctrl",
                             widget = get_rectangle(taille2, couleursT['rctrl'])
                         }
                     }
        }
        conteneur:setup({
                col,
                bg = args.bg,
                layout = wibox.container.background
        })

    end

    local function apply_changes(json_file)
         awful.spawn.easy_async(string.format(COMMAND1, json_file),
                                function(stdout,stderr,reason,exit_code)
                                    update_widget(stdout)
                                end
         )
    end

    awful.spawn.easy_async(string.format(COMMAND2, args.json_path),
                           function(stdout,stderr,reason,exit_code)
                               for file in stdout:gmatch("[^\r\n]+") do
                                   table.insert(widget.jsonFiles, args.json_path .. "/" .. file)
                               end
                               --
                               apply_changes(widget.jsonFiles[widget.jsonDefaultIndex])
                           end
    )

    conteneur:buttons(
        awful.button({}, 1, function()
                widget.jsonDefaultIndex = 1 + widget.jsonDefaultIndex % #widget.jsonFiles
                apply_changes(widget.jsonFiles[widget.jsonDefaultIndex])
        end)
    )
    
    return conteneur
end


return widget
