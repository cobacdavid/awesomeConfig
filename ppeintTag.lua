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
local cairo = require("lgi").cairo
--
local ppeintTag = {}
--
-- https://awesomewm.org/doc/api/documentation/16-using-cairo.md.html
function ppeintTag.fondEcran(t)
   local font_size = 180
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
   -- local img = cairo.ImageSurface.create(cairo.Format.ARGB32, w, h)
   local img = cairo.ImageSurface.create(cairo.Format.RGB24, w, h)
   -- Create a context
   local cr  = cairo.Context(img)
   --
   cr:set_font_size(font_size)
   local monTexte = t.name
   local T = cr:text_extents(monTexte)
   texteW = T['width']
   texteH = T['height']
   -- bandeau
   cr:set_source(gears.color(beautiful.wallpaperBandeau))
   cr:rectangle(0, (h - texteH) / 2, w, texteH + 3)
   cr:fill()
   -- texte
   cr:select_font_face("Comfortaa",
                       "CAIRO_FONT_SLANT_NORMAL",
                       "CAIRO_FONT_WEIGHT_NORMAL")
   cr:set_source(gears.color(beautiful.wallpaper_color))
   cr:move_to(w/2 - texteW/2, (h + texteH) / 2)
   cr:show_text(monTexte)
   -- les tags adjacents
   -- en lua les tableaux commencent à 1 !
   local hoffset = font_size // 4
   cr:set_source(gears.color(beautiful.wallpaper_color))
   cr:set_font_size(.5 * font_size)
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
   return img
end

function ppeintTag.imagesFonds()
   local rep = "/tmp/"
   local s = screen[1]
   local surface = nil
   for i, t in ipairs(s.tags) do
      surface = ppeintTag.fondEcran(t)
      surface:write_to_png(rep .. t.name .. ".png")
   end
end


return ppeintTag
