-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------

local wibox = require("wibox")
local gears = require("gears")
local cairo = require("lgi").cairo
--
local fpbar = {}
fpbar.__index = fpbar
--
function fpbar.secteur_angulaire_arrondi(cr, rmin, rmax, offsetRayon, angleDeg, angleRondDeg)
   if angleRondDeg > angleDeg / 2  then return end
   if offsetRayon > (rmax - rmin) /2 then return end
   --
   local cosinus = math.cos(math.rad(angleDeg / 2))
   local sinus   = math.sin(math.rad(angleDeg / 2))
   local pAngle  = math.rad((angleDeg/2 - angleRondDeg))
   local cpAngle = math.cos(pAngle)
   local spAngle = math.sin(pAngle)
   --
   local p1 = {x = rmin * cpAngle,
               y = rmin * spAngle}
   local p2 = {x = (rmin + offsetRayon) * cosinus,
               y = (rmin + offsetRayon) * sinus}
   local p3 = {x = (rmax - offsetRayon) * cosinus,
               y = (rmax - offsetRayon) * sinus}
   local p4 = {x = rmax * cpAngle,
               y = rmax * spAngle}
   --
   local tan = sinus / cosinus
   local den = math.sqrt(1 + tan^2)
   local pcmin = {}
   pcmin.x = rmin / den
   pcmin.y = pcmin.x * tan
   local pcmax = {}
   pcmax.x = rmax / den
   pcmax.y = pcmax.x * tan
   --
   local alpha = 1
   local beta  = 1 - alpha
   local barymin = {x = alpha*p2.x + beta*pcmin.x, y = alpha*p2.y + beta*pcmin.y}
   local barymax = {x = alpha*p3.x + beta*pcmax.x, y = alpha*p3.y + beta*pcmax.y}
   --
   cr:arc(0, 0, rmin, -pAngle, pAngle)
   cr:curve_to(pcmin.x, pcmin.y, barymin.x, barymin.y, p2.x, p2.y)
   cr:line_to(p3.x, p3.y)
   cr:curve_to(barymax.x, barymax.y,  pcmax.x, pcmax.y, p4.x , p4.y)
   cr:arc_negative(0, 0, rmax, pAngle, -pAngle)
   cr:curve_to(pcmax.x, -pcmax.y, barymax.x, -barymax.y, p3.x , -p3.y)
   cr:line_to(p2.x, -p2.y)
   cr:curve_to(barymin.x, -barymin.y, pcmin.x, -pcmin.y, p1.x, -p1.y)
   --
end
--
function fpbar.nuance_couleur(color, coef, coefDesat)
   local R, G, B, A = gears.color.parse_color(color)
   R = math.floor(R * 255 * coef)
   G = math.floor(G * 255 * coef)
   B = math.floor(B * 255 * coef)
   A = A or 255
   A = coefDesat and math.floor(A * 255 * coefDesat) or A
   return string.format("#%02X%02X%02X%02X", R, G, B, A)
end
--
function fpbar:assemblage()
   self.ak = wibox.widget {
      --
      fit = function(ce_widget, ctx_oo, width, height)
         local m = math.min(width, height)
         return m, m
      end,
      --
      draw = function(ce_widget, ctx_oo, cr, width, height)
         self.inner_radius = self.inner_radius  or (math.min(width, height) // 3)
         self.outer_radius = self.outer_radius  or (math.min(width, height) // 2 - 2)
         self.inter_radius = self.inter_radius  or .5*(self.outer_radius - self.inner_radius)
         --
         cr:translate(width // 2 + 1, height // 2 + 1)
         --
         local colors, colorsDesat
         if self.color_type == "gradient" then
            colors = {fpbar.nuance_couleur(self.color, .2),
                      self.color,
                      fpbar.nuance_couleur(self.color, .5)}
            colorsDesat = {fpbar.nuance_couleur(self.color, .2, .1),
                           fpbar.nuance_couleur(self.color, 1, .1),
                           fpbar.nuance_couleur(self.color, .5, .1)}
         end
         --
         -- local masque = cairo.ImageSurface.create_from_png("/home/david/.config/awesome/widgets/dev/grunge.png")
         --
         local angle
         for i = 0, self.sectors - 1 do
            --
            -- fond
            --
            cr:save()
            angle = math.rad(self.start_angle + i * self.angleIncr)
            cr:rotate(angle)
            fpbar.secteur_angulaire_arrondi(cr, self.inner_radius, self.outer_radius, self.inter_radius,
                                            self.sector_angle, self.angle_offset)
            local pat
            if self.color_type == "gradient" then
               pat = gears.color(
                  {
                     type  = "radial",
                     from  = {0, 0, self.inner_radius},
                     to    = {0, 0, self.outer_radius},
                     stops = { {0, colorsDesat[1]},
                        {0.65, colorsDesat[2]},
                        {1, colorsDesat[3]} }
                  } 
               )
            else
               pat = gears.color(fpbar.nuance_couleur(self.color, 1, .1))
            end
            cr:set_source(pat)
            -- cr:mask_surface(masque, 0, 0)
            cr:fill()
            cr:restore()
            --
            -- fin fond
            --
            if self.value >=  (i + 1) * self.valueIncr  then
               angle = math.rad(self.start_angle + i * self.angleIncr)
               cr:rotate(angle)
               cr:save()
               fpbar.secteur_angulaire_arrondi(cr, self.inner_radius, self.outer_radius, self.inter_radius,
                                               self.sector_angle, self.angle_offset)
               cr:set_line_width(self.line_width)
               if self.color_type == "gradient" then
                  pat = gears.color(
                     {
                        type  = "radial",
                        from  = {0, 0, self.inner_radius},
                        to    = {0, 0, self.outer_radius },
                        stops = { {0, colors[1]},
                           {0.65, colors[2]},
                           {1, colors[3]} }
                     } 
                  )
               else
                  pat = gears.color(self.color)
               end
               cr:set_source(pat)
               -- cr:mask_surface(masque, 0, 0)
               cr:fill()
            elseif self.value > i * self.valueIncr then
               angle = math.rad(self.start_angle + i * self.angleIncr)
               cr:rotate(angle)
               cr:save()
               local ecart_relatif    = (self.value - i*self.valueIncr)/self.valueIncr
               local new_sector_angle = ecart_relatif * self.sector_angle
               local new_angle_offset = ecart_relatif * self.angle_offset
               --
               fpbar.secteur_angulaire_arrondi(cr, self.inner_radius, self.outer_radius, self.inter_radius,
                                               new_sector_angle, new_angle_offset)
               --
               if self.color_type == "gradient" then
                  pat = gears.color(
                     {
                        type  = "radial",
                        from  = {0, 0, self.inner_radius},
                        to    = {0, 0, self.outer_radius},
                        stops = { {0, colors[1]},
                           {0.65, colors[2]},
                           {1, colors[3]} }
                     } 
                  )
               else
                  pat = gears.color(self.color)
               end
               cr:set_source(pat)
               -- cr:mask_surface(masque, 0, 0)
               cr:fill()
               --
            else
               angle = math.rad(self.start_angle + i * self.angleIncr)
               cr:rotate(angle)
               cr:save()
            end
            -- cr:set_source(gears.color("#ffffff"))
            -- cr:stroke()
            cr:restore()
            cr:rotate(-angle)
         end
         --
         cr:translate(-(width // 2 + 1), -(height // 2 + 1))
         --
         -- text
         cr:set_source(gears.color(self.fg))
         cr:select_font_face(self.font, self.font_slant, self.font_weight)
         cr:set_font_size(self.font_size)
         local myText  = text(self.value, self.min_value, self.max_value)
         local dimText = cr:text_extents(myText)
         cr:move_to((width - dimText.width) / 2, height - (height - dimText.height) / 2)
         cr:show_text(myText)
         --
      end,
      layout = wibox.widget.base.make_widget
   }

   local w = wibox.container.background()
   w:set_bg(beautiful.bg)

   local lwidget = wibox.layout.fixed.horizontal()
   lwidget:add(self.ak)

   w:set_widget(lwidget)

   self.widget = w

end

function fpbar:set_value(val)
   if not val or val == 0 then self.value = 0; return end


   val = math.max(self.min_value, math.min(self.max_value, val))

   local delta = self.max_value - self.min_value

   self.value = val / delta
   -- self.ak:emit_signal("widget::layout_changed")
   self.widget:emit_signal("widget::redraw_needed")
   self.ak:emit_signal("property::value", self.value)
end

-- for _, prop in ipairs {"max_value", "min_value"} do
--     radialprogressbar["set_"..prop] = function(self, value)
--         self["_"..prop] = value
--         self:emit_signal("property::"..prop, value)
--         self:emit_signal("widget::redraw_needed")
--     end
--     radialprogressbar["get_"..prop] = function(self)
--         return self["_"..prop]
--     end
-- end

function fpbar.new(args)
   args = args or {}
   --
   args.inner_radius = args.inner_radius  -- or (math.min(width, height) // 3)
   args.outer_radius = args.outer_radius  -- or (math.min(width, height) // 2 - 2)
   args.start_angle  = args.start_angle   or -90
   args.inter_radius = args.inter_radius  --  or .5*(args.outer_radius - args.inner_radius)
   args.line_width   = args.line_width    or 2
   args.color        = args.color         or beautiful.fg_normal
   args.color_type   = args.color_type    or "gradient"
   --
   -- args.value        = args.value         or 0
   args.max_value    = args.max_value     or 1
   args.min_value    = args.min_value     or 0
   args.text         = args.text          or function(v, m, M)
      v = (v - m) / (M - m)  
      return (string.format("%02d", math.floor(v * 100)) .. "%")
   end
   args.font         = args.font          or beautiful.font or "Helvetica"
   args.font_slant   = args.font_slant    or "CAIRO_FONT_SLANT_NORMAL"
   args.font_weight  = args.font_weight   or "CAIRO_FONT_WEIGHT_NORMAL"
   args.font_size    = args.font_size     or .9 * args.inner_radius
   args.fg           = args.fg            or beautiful.fg_normal
   --
   args.sectors      = args.sectors       or 12
   args.clockwise    = args.clockwise     or false
   args.angleIncr    = clockwise and (360/args.sectors) or (-360/args.sectors)
   args.valueIncr    = (args.max_value - args.min_value) / args.sectors
   args.sector_angle = args.sector_angle  or (.9 * math.abs(args.angleIncr))
   args.angle_offset = args.angle_offset  or (.1 * args.sector_angle)
   --
   -- args.angle        = math.rad(args.start_angle)
   setmetatable(args, fpbar)
   args:assemblage()
   return args
end

return setmetatable(fpbar, {__call=function(t, args)
                               return t.new(args)
end})
