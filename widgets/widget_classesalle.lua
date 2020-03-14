classesalle = wibox.widget {
   widget = wibox.widget.textbox
}

gears.timer ( {
      timeout   = 420,
      autostrat = true,
      callback   = function ()
	 classesalle:set_text( EDT_classeCourante .. " " .. EDT_salleCourante )
      end
})
