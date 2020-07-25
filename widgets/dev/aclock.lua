local wibox = require("wibox")
local gears = require("gears")
--
local aclock = {}
--
local function secteur_angulaire_arrondi(cr, rmin, rmax, offsetRayon, angleDeg, angleRondDeg)
    if angleRondDeg > angleDeg / 2  then return end
    if offsetRayon > (rmax - rmin) /2 then return end
    local trapeze = {}
    local cosinus = math.cos( math.rad ( angleDeg / 2 ) )
    local sinus   = math.sin( math.rad ( angleDeg / 2 ) )
    local pAngle  = math.rad( (angleDeg / 2 - angleRondDeg) )
    local cpAngle = math.cos( pAngle )
    local spAngle = math.sin( pAngle )
    --
    trapeze.x0 = rmin * cosinus
    trapeze.y0 = rmin * sinus
    trapeze.x1 = trapeze.x0
    trapeze.y1 = - trapeze.y0
    trapeze.x2 = rmax * cosinus
    trapeze.y2 = rmax * sinus * (-1)
    trapeze.x3 = trapeze.x2
    trapeze.y3 = - trapeze.y2
    --
    --
    local p1 = {x = rmin * cpAngle , y = rmin * spAngle }
    --local p2 = {x = rmin * math.cos((angleDeg / 2 - angleRondDeg) * math.pi /180) , y = (-1) * rmin * math.sin ((angleDeg / 2 - angleRondDeg) * math.pi /180) }
    local p3 = {x = (rmin + offsetRayon) * cosinus , y = (rmin + offsetRayon) * sinus * (-1) }
    local p4 = {x = (rmax - offsetRayon) * cosinus , y = (rmax - offsetRayon) * sinus * (-1) }
    local p5 = {x = rmax * cpAngle , y = (-1) * rmax * spAngle }
    --local p6 = {x = rmax * math.cos((angleDeg / 2 - angleRondDeg) * math.pi /180) , y = rmax * math.sin ((angleDeg / 2 - angleRondDeg) * math.pi /180) }
    local p7 = {x = p4.x , y = -p4.y }
    local p8 = {x = p3.x , y = -p3.y }
    --
    cr:arc_negative(0 , 0 , rmin , pAngle  , -pAngle )
    cr:curve_to(trapeze.x1 , trapeze.y1 , trapeze.x1 , trapeze.y1 , p3.x , p3.y )
    cr:line_to(p4.x , p4.y )
    cr:curve_to(trapeze.x2 , trapeze.y2 , trapeze.x2 , trapeze.y2 , p5.x , p5.y )
    cr:arc(0 , 0 , rmax , - pAngle , pAngle )
    cr:curve_to(trapeze.x3 , trapeze.y3 , trapeze.x3 , trapeze.y3 , p7.x , p7.y )
    cr:line_to(p8.x , p8.y )
    cr:curve_to(trapeze.x0 , trapeze.y0 , trapeze.x0 , trapeze.y0 , p1.x , p1.y )
    --
end
--
local function nuance_couleur(color, coef, coefDesat)
    local R, G, B, A = gears.color.parse_color(color)
    R = math.floor(R * 255 * coef)
    G = math.floor(G * 255 * coef)
    B = math.floor(B * 255 * coef)
    A = A or 255
    A = coefDesat and math.floor(A * 255 * coefDesat) or A
    return string.format("#%02X%02X%02X%02X", R, G, B, A)
end
--
function aclock.fit(self, _, width, height)
    local m = math.min(width, height)
    return m, m
end
--
function aclock.draw(self, _, cr, width, height)
    local inner_radius = self._inner_radius  or (math.min(width, height) // 3)
    local outer_radius = self._outer_radius  or (math.min(width, height) // 2 - 2)
    local start_angle  = self._start_angle   or -90
    local inter_radius = self._inter_radius  or .5*(outer_radius - inner_radius) - 2
    local line_width   = self._line_width    or 2
    local color        = self._color         or beautiful.fg_normal
    --
    local value        = self._value         or 0
    local text         = self._text          or function(v)
        return (string.format("%02d", math.floor(v * 100)) .. "%")
                                                end
    local font         = self._font          or beautiful.font or "Helvetica"
    local font_slant   = self._font_slant    or "CAIRO_FONT_SLANT_NORMAL"
    local font_weight  = self._font_weight   or "CAIRO_FONT_WEIGHT_NORMAL"
    local font_size    = self._font_size     or .9 * inner_radius
    local fg           = self._fg            or beautiful.fg_normal
    --
    local sectors      = self._sectors       or 12
    local clockwise    = self._clockwise     or false
    local angleIncr    = clockwise and (360/sectors) or (-360/sectors)
    local sector_angle = self._sector_angle  or (.9 * math.abs(angleIncr))
    local angle_offset = self._angle_offset  or (sector_angle // 3)
    --
    local angle        = math.rad(start_angle)
    --
    cr:translate(width // 2 + 1, height // 2 + 1)
    --
    local colors = {nuance_couleur(color, .2),
                    color,
                    nuance_couleur(color, .5)}
    local colorsDesat = {nuance_couleur(color, .2, .1),
                         nuance_couleur(color, 1, .1),
                         nuance_couleur(color, .5, .1)}
    --
    for i = 0, sectors - 1 do
        angle = math.rad(start_angle + i * angleIncr)
        cr:rotate(angle)
        cr:save()
        secteur_angulaire_arrondi(cr, inner_radius, outer_radius, inter_radius,
                                  sector_angle, angle_offset)
        cr:set_line_width(line_width)
        if value >= (i + 1)/sectors  then
            cr:set_source(gears.color(
                              {
                                  type = "radial",
                                  from = { 0, 0, inner_radius},
                                  to = { 0, 0, outer_radius },
                                  stops = { { 0, colors[1] },
                                      { 0.65, colors[2] },
                                      { 1, colors[3] } }
                              } 
            ))
            cr:fill()
        else
            cr:set_source(gears.color(
                              {
                                  type = "radial",
                                  from = { 0, 0, inner_radius},
                                  to = { 0, 0, outer_radius },
                                  stops = { { 0, colorsDesat[1] },
                                      { 0.65, colorsDesat[2] },
                                      { 1, colorsDesat[3] } }
                              } 
            ))
            cr:fill()
        end
        cr:set_source(gears.color("#ffffff"))
        cr:stroke()
        cr:restore()
        cr:rotate(-angle)
    end
    --
    cr:translate(-(width // 2 + 1), -(height // 2 + 1))
    --
    cr:set_source(gears.color(fg))
    cr:select_font_face(font, font_slant, font_weight)
    cr:set_font_size(font_size)
    local myText  = text(value)
    local dimText = cr:text_extents(myText)
    cr:move_to((width - dimText.width) / 2, height - (height - dimText.height) / 2)
    cr:show_text(myText)
    --
end

function aclock.set_value(self, val)
    if not val then self._value = 0; return end

    if val > self._max_value then
        val = self._max_value
    elseif val < self._min_value then
        val = self._min_value
    end

    local delta = self._max_value - self._min_value

    self._value = val / delta
    self:emit_signal("widget::redraw_needed")
    self:emit_signal("property::value", val)
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

function aclock.new(args)
    args = args or {}
    --
    local ak = wibox.widget.base.make_widget()
    --
    ak._outer_radius = args.outer_radius
    ak._inner_radius = args.inner_radius
    ak._inter_radius = args.inter_radius
    ak._sectors      = args.sectors
    ak._sector_angle = args.sector_angle
    ak._angle_offset = args.angle_offset
    ak._start_angle  = args.start_angle
    ak._line_width   = args.line_width
    ak._clockwise    = args.clockwise
    ak._color        = args.color
    --
    ak._max_value    = 1
    ak._min_value    = 0
    ak._value        = args.value
    --
    ak._text         = args.text
    ak._fg           = args.fg
    ak._font         = args.font
    ak._font_slant   = args.font_slant
    ak._font_weight  = args.font_weight
    ak._font_size    = args.font_size
    --
    gears.table.crush(ak, aclock)
    --
    return ak
end

return setmetatable(aclock, {__call=function(_, args)
                                 return aclock.new(args)
                   end})
