contenuclient = wibox.widget {
   layout = wibox.container.scroll.horizontal,
   max_size = 100,
   step_function = wibox.container.scroll.step_functions
      .waiting_nonlinear_back_and_forth,
   speed = 100,
   {
      widget = wibox.widget.imagebox,
      image = "/home/david/20180321-181317-URxvt.png"
   },
}
