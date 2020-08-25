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
local aclock = {}
--
local function secteur_angulaire_arrondi(cr, rmin, rmax, offsetRayon, angleDeg, angleRondDeg)
    if angleRondDeg > angleDeg / 2  then return end
    if offsetRayon > (rmax - rmin) /2 then return end
    --
    local cosinus = math.cos(math.rad(angleDeg / 2))
    local sinus   = math.sin(math.rad(angleDeg / 2))
    local pAngle  = math.rad((angleDeg/2 - angleRondDeg))
    local cpAngle = math.cos(pAngle)
    local spAngle = math.sin(pAngle)
    --
    -- local trapeze = {}
    -- trapeze.x0 = rmin * cosinus
    -- trapeze.y0 = rmin * sinus
    -- trapeze.x1 = trapeze.x0
    -- trapeze.y1 = - trapeze.y0
    -- trapeze.x2 = rmax * cosinus
    -- trapeze.y2 = rmax * sinus * (-1)
    -- trapeze.x3 = trapeze.x2
    -- trapeze.y3 = - trapeze.y2
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
    local inter_radius = self._inter_radius  or .5*(outer_radius - inner_radius)
    local line_width   = self._line_width    or 2
    local color        = self._color         or beautiful.fg_normal
    local color_type   = self._color_type    or "gradient"
    --
    local value        = self._value         or 0
    local max_value    = self._max_value     or 1
    local min_value    = self._min_value     or 0
    local text         = self._text          or function(v, m, M)
        v = (v - m) / (M - m)  
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
    local valueIncr    = (max_value - min_value) / sectors
    local sector_angle = self._sector_angle  or (.9 * math.abs(angleIncr))
    local angle_offset = self._angle_offset  or (.1 * sector_angle)
    --
    local angle        = math.rad(start_angle)
    --
    cr:translate(width // 2 + 1, height // 2 + 1)
    --
    local colors, colorsDesat
    if color_type == "gradient" then
        colors = {nuance_couleur(color, .2),
                        color,
                        nuance_couleur(color, .5)}
        colorsDesat = {nuance_couleur(color, .2, .1),
                             nuance_couleur(color, 1, .1),
                             nuance_couleur(color, .5, .1)}
    end
    --
    local masque = cairo.ImageSurface.create_from_png("/home/david/.config/awesome/widgets/dev/grunge.png")
    --
    for i = 0, sectors - 1 do
        -- fond
        cr:save()
        angle = math.rad(start_angle + i * angleIncr)
        cr:rotate(angle)
        secteur_angulaire_arrondi(cr, inner_radius, outer_radius, inter_radius,
                                  sector_angle, angle_offset)
        local pat
        if color_type == "gradient" then
            pat = gears.color(
                {
                    type  = "radial",
                    from  = {0, 0, inner_radius},
                    to    = {0, 0, outer_radius},
                    stops = { {0, colorsDesat[1]},
                        {0.65, colorsDesat[2]},
                        {1, colorsDesat[3]} }
                } 
            )
        else
            pat = gears.color(nuance_couleur(color, 1, .1))
        end
        cr:set_source(pat)
        -- cr:mask_surface(masque, 0, 0)
        cr:fill()
        cr:restore()
        -- fin fond
        if value >=  (i + 1) * valueIncr  then
            angle = math.rad(start_angle + i * angleIncr)
            cr:rotate(angle)
            cr:save()
            secteur_angulaire_arrondi(cr, inner_radius, outer_radius, inter_radius,
                                      sector_angle, angle_offset)
            cr:set_line_width(line_width)
            if color_type == "gradient" then
                pat = gears.color(
                    {
                        type  = "radial",
                        from  = {0, 0, inner_radius},
                        to    = {0, 0, outer_radius },
                        stops = { {0, colors[1]},
                            {0.65, colors[2]},
                            {1, colors[3]} }
                    } 
                )
            else
                pat = gears.color(color)
            end
            cr:set_source(pat)
            -- cr:mask_surface(masque, 0, 0)
            cr:fill()
        elseif value > i * valueIncr then
            angle = math.rad(start_angle + i * angleIncr)
            cr:rotate(angle)
            cr:save()
            local ecart_relatif    = (value - i*valueIncr)/valueIncr
            local new_sector_angle = ecart_relatif * sector_angle
            local new_angle_offset = ecart_relatif * angle_offset
            --
            secteur_angulaire_arrondi(cr, inner_radius, outer_radius, inter_radius,
                                      new_sector_angle, new_angle_offset)
            --
            if color_type == "gradient" then
                pat = gears.color(
                    {
                        type  = "radial",
                        from  = {0, 0, inner_radius},
                        to    = {0, 0, outer_radius },
                        stops = { {0, colors[1]},
                            {0.65, colors[2]},
                            {1, colors[3]} }
                    } 
                )
            else
                pat = gears.color(color)
            end
            cr:set_source(pat)
            -- cr:mask_surface(masque, 0, 0)
            cr:fill()
            --
        else
            angle = math.rad(start_angle + i * angleIncr)
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
    cr:set_source(gears.color(fg))
    cr:select_font_face(font, font_slant, font_weight)
    cr:set_font_size(font_size)
    local myText  = text(value, min_value, max_value)
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
    ak._color_type   = args.color_type
    --
    ak._max_value    = args.max_value or 1
    ak._min_value    = args.min_value or 0
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
