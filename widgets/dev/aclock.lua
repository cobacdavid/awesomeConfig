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
function aclock.fit(self, _, width, height)
    local m = math.min(width, height)
    return m, m
end
--
function aclock.draw(self, _, cr, width, height)
    cr:set_source(gears.color("#FFFFFF"))
    local rmin         = self._rmin         or (math.min(width, height) // 3)
    local rmax         = self._rmax         or (math.min(width, height) // 2 - 2)
    local arcDebutDeg  = self._arcDebutDeg  or -90
    local angleIncr    = self._angleIncr    or 30
    local angleDeg     = self._angleDeg     or (.9*angleIncr)
    local angleRondDeg = self._angleRondDeg or (angleDeg // 3)
    local offsetRayon  = self._offsetRayon  or .5*(rmax - rmin) - 2
    local epaisseur    = self._epaisseur    or 2
    --
    local pct          = self._pct          or 0
    --
    local angle        = math.rad(arcDebutDeg)
    --
    local nb_secteurs  = math.floor(360 / angleIncr)
    cr:translate(width // 2 + 1, height // 2 + 1)
    for i = 0, nb_secteurs - 1 do
        angle = math.rad(arcDebutDeg + i * angleIncr)
        cr:rotate(angle)
        cr:save()
        secteur_angulaire_arrondi(cr, rmin, rmax, offsetRayon, angleDeg, angleRondDeg)
        cr:set_line_width(epaisseur)
        if pct >= (i + 1)/nb_secteurs  then
            cr:fill()
        else
            cr:stroke()
        end
        cr:restore()
        cr:rotate(-angle)
    end
    cr:translate(-rmax, -rmax)
end

function aclock.set_value(self, val)
    if not val then self._pct = 0; return end

    if val > self._max_value then
        val = self._max_value
    elseif val < self._min_value then
        val = self._min_value
    end

    local delta = self._max_value - self._min_value

    self._pct = val / delta
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
    ak._rmax         = args.outer_radius
    ak._rmin         = args.inner_radius
    ak._angleDeg     = args.sector_angle
    ak._angleRondDeg = args.angle_offset
    ak._arcDebutDeg  = args.start_angle
    ak._angleIncr    = args.step_angle
    ak._offsetRayon  = args.inter_radius
    ak._epaisseur    = args.line_width
    --
    ak._max_value = 1
    ak._min_value = 0
    ak._pct          = args.value
    --
    gears.table.crush(ak, aclock)
    --
    return ak
end

return setmetatable(aclock, {__call=function(_, args)
                                 return aclock.new(args)
                   end})
