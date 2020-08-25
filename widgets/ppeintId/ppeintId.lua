-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------

local cairo = require("lgi").cairo
local gears = require("gears")
--
--
local function dec2binhex(n)
    local monbin = ""
    local hex
    while n ~= 0 do
        hex = n%2 == 0 and "0" or "f"
        monbin = hex .. monbin
        n = n // 2
    end
    local len   = string.len(monbin)
    local zeros = 3 - len
    while zeros ~= 0 do
        monbin = "0" .. monbin
        zeros = zeros - 1
    end
    return "#" .. monbin
end


local function image_fond(w, h, index, bg, fg)
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, w, h)
    local cr  = cairo.Context(img)
    --
    cr:set_source(gears.color(bg))
    cr:paint()
    --
    cr:select_font_face("Helvetica",
                        "CAIRO_FONT_SLANT_NORMAL",
                        "CAIRO_FONT_WEIGHT_NORMAL")
    cr:set_font_size(h//3)
    local monTexte = tostring(index)
    local T = cr:text_extents(monTexte)
    cr:set_source(gears.color(fg))
    cr:move_to( (w - T['width']) // 2, (h + T['height']) // 2)
    cr:show_text(monTexte)
    return img
end

local ppeints = {}

function ppeints.change_fonds()
    local chaine = ""
    local rep = "/tmp/"
    local bg, fg
    for s in screen do
        bg = s.index
        fg = 7 - bg
        bg = dec2binhex(bg)
        fg = dec2binhex(fg)
        --
        local w = s.geometry.width
        local h = s.geometry.height
        --
        local image = image_fond(w, h, s.index, bg, fg)
        image:write_to_png(rep .. s.index .. ".png")
        --
        gears.wallpaper.maximized(image, s)
    end
end

return setmetatable(ppeints, {__call=function(t, args)
                                return ppeints.change_fonds(args)
                   end})
