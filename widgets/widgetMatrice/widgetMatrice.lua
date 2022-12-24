local awful         = require("awful")
local naughty       = require("naughty")
local wibox         = require("wibox")
local gears         = require("gears")
local beautiful     = require("beautiful")
local widget_themes = require("widgets.themes_matrice.themes")

local HOME_DIR = os.getenv("HOME")
local ICONS_DIR = HOME_DIR .. '/.config/awesome/icons/'
-- local WIDGET_DIR = HOME_DIR .. '/.config/awesome/widgets/batterieMatrice/'

local widget = {}
widget.__index = widget

function widget.show_warning(message)
   naughty.notify{
      preset = naughty.config.presets.critical,
      title = 'Widget Matrice',
      text = message}
end

function widget.new(args)

   if args == nil then
      return widget
   end

   -- show_warning("OK")
   args = args or {}
   args.title                = args.title       or "widget"
   args.text                 = args.text        or "value"
   args.rect_width           = args.rect_width  or 2
   args.rect_height          = args.rect_height or 6
   args.fg                   = args.fg          or "#fff"
   args.color_of_empty_cells = args.color_of_empty_cells or "#000"
   args.with_border          = args.with_border
   args.margin_top           = args.margin_top  or 1
   -- two themes : grey or gradient
   args.theme                = args.theme       or 'gradient'
   args.n_colors             = args.n_colors    or 101
   args.from_color           = args.from_color  or "#0f0"
   args.to_color             = args.to_color    or "#f00"
   args.COMMANDE             = args.COMMANDE    or ""
   args.fun                  = args.fun         or function(s) return s  end
   
   args.tabTheme = nil
   if args.theme == "gradient" then
      args.tabTheme = widget_themes.gradtheme(args.n_colors,
                                              args.from_color,
                                              args.to_color)
   else
      args.tabTheme = widget_themes.gtheme(args.n_colors)
   end

   if args.with_border == nil then args.with_border = true end

   setmetatable(args, widget)
   args:assemblage()
   args:update(0)
   args:timer()
   return args
end

function widget:assemblage()
   self.ttextwidget = wibox.widget {
      -- markup = '<b>CPU</b>',
      markup = self.title,
      align   = 'center',
      valign  = 'center',
      -- opacity = .75,
      font    = beautiful.font .. " 6",
      widget  = wibox.widget.textbox
   }

   self.titlewidget = wibox.container {
      self.ttextwidget,
      direction = "east",
      widget  = wibox.container.rotate
   }

   self.miroir = wibox.widget{
      reflection = {
         horizontal = false,
         vertical = true,
      },
      widget = wibox.container.mirror
   }

   self.intextwidget = wibox.widget {
      align   = 'center',
      valign  = 'center',
      opacity = .75,
      font    = beautiful.font .. " 20",
      widget  = wibox.widget.textbox
   }

   self.inimagewidget = wibox.widget {
      -- image   = ICONS_DIR .. "logo-covid.png",
      resize  = true,
      opacity = .75,
      halign  = "center",
      valign  = "center",
      widget  = wibox.widget.imagebox
   }

   self.gwidget = wibox.widget {
      self.miroir,
      self.inimagewidget,
      self.intextwidget,
      layout = wibox.layout.stack
   }

   self.widget = wibox.widget {
      self.titlewidget,
      self.gwidget,
      layout = wibox.layout.fixed.horizontal
   }
end


function widget:get_square(count, color)
   if self.color_of_empty_cells ~= nil and
      color == self.tabTheme[0] then
      color = self.color_of_empty_cells
   end

   local square = wibox.widget {
      fit = function()
         return self.rect_width, self.rect_height
      end,
      draw = function(_, _, cr, _, _)
         cr:set_source(gears.color(color))
         cr:rectangle(
            0,
            0,
            self.with_border and self.rect_width-1 or self.rect_width,
            self.with_border and self.rect_height-1 or self.rect_height
         )
         cr:fill()
      end,
      layout = wibox.widget.base.make_widget
   }

   return square
end

function widget:updateWidget(sortie)
   local row = {layout = wibox.layout.fixed.horizontal}
   local col = {layout = wibox.layout.fixed.vertical}
   --
   local couleurSortie
   --
   for i = 0, 99 do
      if i % 20 == 0 and i ~= 0 then
         table.insert(col, row)
         row = {layout = wibox.layout.fixed.horizontal}
      end
      couleur = i < sortie and self.tabTheme[i+1] or self.tabTheme[i+1]:sub(1, 7) .. "50"
      if i == sortie then
         couleurSortie = self.tabTheme[i+1]:sub(1, 7) .. "ee"
      end
      table.insert(row, self:get_square(sortie, couleur))
   end
   table.insert(col, row)
   
   self.miroir:setup({
         col,
         top = self.margin_top,
         layout = wibox.container.margin
   })

   return couleurSortie
end

function widget:update(valeur)
   local coul = self:updateWidget(valeur)
   if self.text == 'value' then
      self.intextwidget:set_markup("<b><span foreground='" .. coul .. "'>" .. valeur .. "</span></b>")
   end
end

function widget:timer()
   gears.timer({
         timeout = 60,
         call_now = true,
         autostart = true,
         callback = function()
            awful.spawn.easy_async(self.COMMANDE,
                           function(stdout)
                              local valeur = self.fun(stdout)
                              self:update(tonumber(valeur))
                           end
    )
         end
   })

end


return setmetatable(widget, {__call = function(t, args) return t.new(args) end})
