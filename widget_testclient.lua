testw = wibox.widget.base.make_widget()

function testw:fit(context, width, height)
   -- Find the maximum square available
   local m = math.min(width, height)
   return m, m
end

function testw:draw(context, cr, width, height)
   cr:move_to(0, 0)
   cr:line_to(width, height)
   cr:move_to(0, height)
   cr:line_to(width, 0)
   cr:stroke()
end

