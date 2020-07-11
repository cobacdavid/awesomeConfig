-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-------------------------------------------------
-- some parts from awesome wm 
-- distribution
-- copyright ??
-------------------------------------------------
--
local wibox = require("wibox")
local awful = require("awful")
local cairo = require("lgi").cairo
--
local secretFenetre = {}
secretFenetre.wiboxList = {}
secretFenetre.nb        = false
secretFenetre.px        = 30
secretFenetre.minNuance = 0
secretFenetre.maxNuance = 255
secretFenetre.challenge = function() return true end
--
local function contient(T, e)
   local trouve = false
   local i = 1
   while (not trouve) and (i <= #T) do
      trouve = T[i] == e
      i = i + 1
   end
   return trouve
end
--
-- couleur aléatoire
local function couleurAlea()
   local ecart = secretFenetre.maxNuance - secretFenetre.minNuance + 1
   --
   if secretFenetre.nb then
      local nuance = math.floor(math.random() * ecart) + secretFenetre.minNuance
      return string.format("#%02X%02X%02X", nuance, nuance, nuance)
   else
      local R = math.floor(math.random() * ecart) + minNuance
      local G = math.floor(math.random() * ecart) + minNuance
      local B = math.floor(math.random() * ecart) + minNuance
      return string.format("#%02X%02X%02X", R, G, B)
   end
end
--
local function imageAlea(c, mN, MN)
   --
   local w = c.width
   local h = c.height
   local pixel = secretFenetre.px
   -- Create a surface
   -- PNG
   local img = cairo.ImageSurface.create(cairo.Format.RGB24, w, h)
   -- Create a context
   local cr  = cairo.Context(img)
   --
   for i=0, w//pixel do
      for j=0, h//pixel  do
         cr:set_source(gears.color(couleurAlea()))
         cr:rectangle(i*pixel, j*pixel, (i+1)*pixel, (j+1)*pixel)
         cr:fill()
      end
   end
   --
   return img
end
--
--
function secretFenetre.create(c, args)
   local args = args or {}
   --
   local fond  =  imageAlea(c, mN, MN)
   --
   local w = wibox({
         x       = c.x,
         y       = c.y,
         width   = c.width,
         height  = c.height,
         bg      = args.bg or beautiful.bg_urgent,
         bgimage = fond or {},
         visible = true,
         ontop   = true
   })
   table.insert(secretFenetre.wiboxList, c)
   --
   w:buttons(gears.table.join(
                awful.button({}, 1,
                   function()
                      if secretFenetre.challenge() then
                         w.visible = false
                         w = nil
                         table.remove(secretFenetre.wiboxList,
                                      fu.tableFind(secretFenetre.wiboxList, c))
                         -- 
                         -- get mouse focus the client below
                         local enDessous = mouse.object_under_pointer()
                         if type(enDessous) == 'client' then
                            client.focus = enDessous
                            enDessous:emit_signal("focus")
                         end
                      end
                   end
                )
   ))
   return w
end
--
function secretFenetre.createButton(c, args)
   local args = args or {}
   secretFenetre.nb        = args.nb        or secretFenetre.nb
   secretFenetre.px        = args.px        or secretFenetre.px
   secretFenetre.challenge = args.challenge or secretFenetre.challenge
   secretFenetre.minNuance = args.minNuance or secretFenetre.minNuance
   secretFenetre.maxNuance = args.maxNuance or secretFenetre.maxNuance
   --
   c.estSecret = false
   --
   local w = wibox.widget({
         widget =  wibox.widget.textbox,
         text = "🔓"
   })
   --  
   local tt = awful.tooltip({})
   tt:add_to_object(w)
   w:connect_signal("mouse::enter", function()
                              tt.text = "secret"
   end)
   --
   w:buttons(gears.table.join(
                awful.button({}, 1,
                   function()
                      c.estSecret = not c.estSecret
                      if c.estSecret then
                         w:set_text("🔒")
                      else
                         w:set_text("🔓")
                      end
                   end
                )
   ))
   return w
end
--
--
tag.connect_signal("property::selected",
                   function(t)
                      --
                      for i, c in ipairs(secretFenetre.wiboxList) do
                         if contient(t:clients(), c) or c:isvisible() then
                            c.secretWidget.visible = true
                         else
                            c.secretWidget.visible = false
                         end
                      end
                      --
                   end
)

client.connect_signal("unfocus",
                      function(c)
                         -- unless these conditions... it is created multiple times...
                         if c.estSecret and (not c.secretWidget or not c.secretWidget.visible) then
                            c.secretWidget = secretFenetre.create(c)
                         end
                      end
)

client.connect_signal("unmanage",
                      function(c)
                         if c.estSecret then
                            c.secretWidget.visible = false
                            c.secretWidget = nil
                            table.remove(secretFenetre.wiboxList,
                                         fu.tableFind(secretFenetre.wiboxList, c))
                         end
                      end
)

client.connect_signal("property::size",
                      function(c)
                         if c.estSecret and c.secretWidget.visible then
                            -- to improve 
                            c.secretWidget.x      = c.x
                            c.secretWidget.y      = c.y
                            c.secretWidget.width  = c.width
                            c.secretWidget.height = c.height
                         end
                      end
)
--
return setmetatable(secretFenetre, {__call=function(t, client, args)
                                       return secretFenetre.createButton(client, args)
                   end})
