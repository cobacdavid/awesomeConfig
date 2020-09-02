-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-- some parts from awesome wm
-- ditribution
-- copyright ??
-------------------------------------------------
--
local cairo     = require("lgi").cairo
local beautiful = require("beautiful")
local gears     = require("gears")
--
local ppeintTag = {}
--
-- local function darkerColor(color, coef)
--     local r, g, b, a = gears.color.parse_color(color)
--     local R = math.floor(r * coef * 255)
--     local G = math.floor(g * coef * 255)
--     local B = math.floor(b * coef * 255)
--     local A = math.floor(a * coef * 255)
--     return string.format("#%02X%02X%02X%02X", R, G, B, A)
-- end
--
-- https://awesomewm.org/doc/api/documentation/16-using-cairo.md.html
function ppeintTag.fondEcran(t, args)
    args             = args or {}
    args.font        = args.font        or beautiful.font
    args.font_size   = args.font_size   or 180
    args.strip_color = args.strip_color or beautiful.bg_focus  or "#BFBFBF"
    args.bg          = args.bg          or beautiful.bg_normal or "#000000"
    --
    -- rang du tag courant
    local j = 0
    for i=1, #t.screen.tags do
        if (t == t.screen.tags[i]) then
            j = i
        end
    end
    --
    local w = t.screen.geometry.width
    local h = t.screen.geometry.height
    -- Create a surface
    -- PNG
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, w, h)
    -- local img = cairo.ImageSurface.create(cairo.Format.RGB24, w, h)
    -- Create a context
    local cr  = cairo.Context(img)
    --
    cr:select_font_face(args.font, --"Comfortaa",
                        "CAIRO_FONT_SLANT_NORMAL",
                        "CAIRO_FONT_WEIGHT_NORMAL")
    --
    -- fond
    -- cr:set_source(gears.color(args.bg))
    -- cr:paint()
    --
    -- nombre
    cr:set_font_size(0.75 * t.screen.geometry.height)
    cr:set_source(gears.color(args.strip_color))
    local monTexte = tostring(j)
    local T = cr:text_extents(monTexte)
    cr:move_to((w - T['width']) // 2 - 50, (h + T['height']) // 2)
    cr:show_text(monTexte)
    --
    -- calculs
    cr:set_font_size(args.font_size)
    local texteH = 0
    for i=1, #t.screen.tags do
        T = cr:text_extents(t.screen.tags[i].name)
        texteH = math.max(texteH, T['height'])
    end
    monTexte = t.name
    T = cr:text_extents(monTexte)
    local texteW = T['width']
    --
    -- bandeau
    cr:set_source(gears.color(args.strip_color))
    cr:rectangle(0, (h - texteH) / 2, w, texteH + 3)
    cr:fill()
    --
    -- texte
    cr:set_source(gears.color(args.bg))
    cr:move_to(w/2 - texteW/2, (h + texteH) / 2)
    cr:show_text(monTexte)
    --
    -- les tags adjacents
    -- en lua les tableaux commencent à 1 !
    local hoffset = args.font_size // 4
    cr:set_source(gears.color(args.bg))
    cr:set_font_size(.5 * args.font_size)
    monTexte = t.screen.tags[((j-1)-1) % #t.screen.tags + 1].name
    T = cr:text_extents(monTexte)
    cr:move_to(w/2 - texteW/2 - T['width'] - hoffset, (h + T['height']) / 2)
    cr:show_text(monTexte)
    monTexte = t.screen.tags[((j-1)+1) % #t.screen.tags + 1].name
    T = cr:text_extents(monTexte)
    cr:move_to(w/2 + texteW/2 + hoffset, (h + T['height']) / 2)
    cr:show_text(monTexte)
    --
    cr:stroke()
    --
    --
    return img
end


function ppeintTag.fondDev(t, args)
    args             = args or {}
    args.font        = args.font        or beautiful.font
    args.font_size   = args.font_size   or 180
    args.strip_color = args.strip_color or beautiful.bg_focus  or "#BFBFBF"
    args.bg          = args.bg          or beautiful.bg_normal or "#000000"
    local w = t.screen.geometry.width
    local h = t.screen.geometry.height
    -- Create a surface
    -- PNG
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, w, h)
    -- local img = cairo.ImageSurface.create(cairo.Format.RGB24, w, h)
    -- Create a context
    local cr  = cairo.Context(img)
    --
    cr:select_font_face(args.font, --"Comfortaa",
                        "CAIRO_FONT_SLANT_NORMAL",
                        "CAIRO_FONT_WEIGHT_NORMAL")
    --
    --
    return img
end

function ppeintTag.imagesFonds(args)
    local rep = "/tmp/"
    local s = screen[1]
    local surface
    for _, t in ipairs(s.tags) do
        if t.name == "dev" then
            surface = ppeintTag.fondDev(t, args)
            surface:write_to_png(rep .. t.name .. ".png")
        else
            surface = ppeintTag.fondEcran(t, args)
            surface:write_to_png(rep .. t.name .. ".png")
        end
    end
end

return ppeintTag
