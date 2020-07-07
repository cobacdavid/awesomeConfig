-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2020
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-------------------------------------------------
-- some parts from awesome wm 
-- ditribution
-- copyright ??
-------------------------------------------------
--
local secretFenetre = {}
secretFenetre.wiboxList = {}
--
local function contient(T, e)
   local trouve = false
   local i = 1
   while (not trouve) and (i <= #tab) do
      trouve = tab[i] == val
      i = i + 1
   end
   return trouve
end
--
function secretFenetre.create(c, args)
   local args = args or {}
   local w = wibox({
         x       = c.x,
         y       = c.y,
         width   = c.width,
         height  = c.height,
         bg      = args.bg or beautiful.bg_urgent,
         visible = true,
         ontop   = true
   })
   table.insert(secretFenetre.wiboxList, c)
   --
   w:buttons(gears.table.join(
                awful.button({}, 1,
                   function()
                      w.visible = false
                      w = nil
                      table.remove(secretFenetre.wiboxList, fu.tableFind(secretFenetre.wiboxList, c))
                       -- 
                      -- get mouse focus the client below
                      local enDessous = mouse.object_under_pointer()
                      if type(enDessous) == 'client' then
                         client.focus = enDessous
                         enDessous:emit_signal("focus")
                      end
                   end
                )
   ))
   return w
end
--
function secretFenetre.createButton(c, args)
   c.estSecret = false
   --
   local w = wibox.widget({
         widget =  wibox.widget.textbox,
         text = "🔓"
   })
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
                         if contient(t:clients(), c) or c.visible then
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

return setmetatable(secretFenetre, {__call=function(t, args)
                                       return secretFenetre.createButton(args)
                   end})
