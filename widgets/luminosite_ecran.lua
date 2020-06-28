-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
--
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")
--
local fu = require("fonctionsUtiles")
--
local widget = {}
--
widget.interfaces = {}
widget.activeIndex = 1
widget.levels = {}
widget.limits = {MAX = 100, maxi = 2,
                 MIN = 0, mini = .5}
--
local function listAllInterfaces()
   local ifaces = "xrandr |grep ' connected'|cut -d' ' -f 1"
   local fh = io.popen(ifaces)
   local resultat = fh:read("*a")
   fh:close()
   widget.interfaces = fu.splitString(resultat, "\n")
end
--
local function modifieTexte(w, iface)
   w:set_markup("<span foreground='white'>" .. iface .. "</span>")
end
--
local function valeurDepartSlider(w)
   local vDepart = widget.levels[widget.interfaces[widget.activeIndex]]
   w.value = math.floor((vDepart - widget.limits.mini) *100
         / (widget.limits.maxi - widget.limits.mini))
end
--
function widget.sliderBrightnessWidget(args)
   --
   local args = args or {}
   --
   -- local MAX      = 100
   -- local maxi     = 2
   -- local MIN      = 0
   -- local mini     = .5
   --
   --
   -- le widget complet
   local widgetComplet = wibox.widget(
      {
         {
            {
               id     = "texte",
               align  = "center",
               widget = wibox.widget.textbox
            },
            {
               id           = "slider",
               bar_shape    = gears.shape.rounded_rect,
               bar_height   = 1,
               bar_color    = beautiful.border_color,
               handle_shape = gears.shape.circle,
               handle_color = fu.couleurBarre(beautiful.widget_sliderBrightness_handle_color_type,
                                              100, widget.limits.MIN, widget.limits.MAX),
               minimum      = widget.limits.MIN,
               maximum      = widget.limits.MAX,
               widget       = wibox.widget.slider,
            },
            id              = "stack",
            vertical_offset = 0,
            layout          = wibox.layout.stack
         },
         forced_width = 150,
         bg           = beautiful.noir,
         widget       = wibox.container.background
      }
   )
   --
   -- callback changement de la barre
   widgetComplet.stack.slider:connect_signal("property::value", function()
                                                local iface = widget.interfaces[widget.activeIndex]
                                                local v = tostring(widget.limits.mini + (widgetComplet.stack.slider.value * (widget.limits.maxi - widget.limits.mini) / widget.limits.MAX))
                                                v = v:gsub(",",".")
                                                widget.levels[iface] = v
                                                local command="xrandr --output " .. iface .." --brightness " .. v
                                                fu.commandeExecute(command)
                                                widgetComplet.stack.slider.handle_color = fu.couleurBarre(beautiful.widget_sliderBrightness_handle_color_type, v, widget.limits.mini, widget.limits.maxi)
   end)
   -- callbak changement de widget
   widgetComplet:buttons(
      gears.table.join(
         awful.button({}, 3,
            function()
               widget.activeIndex = 1 + widget.activeIndex%#widget.interfaces
               modifieTexte(widgetComplet.stack.texte, widget.interfaces[widget.activeIndex])
               valeurDepartSlider(widgetComplet.stack.slider)
            end
         )
      )
   )
   --
   for i, iface in ipairs(widget.interfaces) do
      widget.levels[iface] = args.startLevel and args.startLevel[iface] or 1
   end
   --
   modifieTexte(widgetComplet.stack.texte, widget.interfaces[widget.activeIndex])
   valeurDepartSlider(widgetComplet.stack.slider)
   --
   return widgetComplet
end

listAllInterfaces()

return setmetatable(widget, {__call=function(t, args)
                                return widget.sliderBrightnessWidget(args)
                   end})
