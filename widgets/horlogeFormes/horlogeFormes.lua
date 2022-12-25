-------------------------------------------------
-- author: David Cobac
-- twitter: @david_cobac
-- github: https://github.com/cobacdavid
-- date: 2022
-- copyright: CC-BY-NC-SA
-------------------------------------------------
-- copyright ??
-------------------------------------------------
--
local cairo     = require("lgi").cairo
local beautiful = require("beautiful")
local gears     = require("gears")

-- vector 
local vector = {}
vector.__index = vector

function vector.new(args)
   args = args or {x=0, y=0}
   setmetatable(args, vector)
   return args
end
--
function vector.distance(vector1, vector2)
   return math.max(math.abs(vector1.x - vector2.x),
                   math.abs(vector1.y - vector2.y))
end
--
--
local square = {}
square.__index = square

function square.new(args)
   args = args or {center = vector.new(), halfSide = 1}
   return setmetatable(args, square)
end

function square:topleft()
   return {x = self.center.x - self.halfSide,
           y = self.center.y - self.halfSide}
end

function square:collisionInSquare(squaresTable)
   local ans = false
   local i = 1
   while not ans and i <= #squaresTable do
      local temp = vector.distance(self.center, squaresTable[i].center)
      ans = temp < squaresTable[i].halfSide
      i = i + 1
   end
   return ans
end

function square:maxDistOthers(squaresTable, margin, maxDim)
   local r = maxDim
   i = 1
   while i <= #squaresTable do
      local temp = vector.distance(self.center, squaresTable[i].center)
      r = math.min(r, temp - squaresTable[i].halfSide - margin)
      i = i + 1
   end
   return r
end

function square:maxDistEdges(margin, xy, wh)
   return math.min(self.center.x - xy.x - margin,
                   self.center.y - xy.y - margin,
                   xy.x + wh.width - self.center.x - margin,
                   xy.y + wh.height - self.center.y - margin)
end

--

local squares = {}
squares.__index = squares


function squares.new(args, cr)
   args = args or {}
   args.cr = cr
   args.n = 0
   args.marge    = args.marge    or 1
   args.fond     = args.fond     or gears.color(beautiful.bg)
   args.coul     = args.coul     or gears.color(beautiful.fg)
   args.fstyle   = args.fstyle   or function(ctx_oo) ctx_oo:stroke() end
   args.sTable   = {}
   --
   return setmetatable(args, squares)
end


function squares:set_dim(xy, wh)
   self.x = xy.x
   self.y = xy.y
   self.xy = xy
   self.width = wh.width
   self.height = wh.height
   self.wh = wh
   --
   self.maxAdmis = self.maxAdmis or self.width / 4
   self.minAdmis = self.minAdmis or 1
   -- self.maxAdmis = self.maxAdmis or self.width ~= 0 and self.width / 5 or 5
   -- self.minAdmis = self.minAdmis or self.width ~= 0 and self.width / 50 or 1
end   

function squares:trace(nb)
   local curNSquares = #self.sTable
   -- 
   -- self.cr:set_source(self.fond)
   -- self.cr:paint()
   --
   -- math.randomseed(os.time())
   local center
   local sq
   while #self.sTable < nb + curNSquares do
      center = vector.new {
         x = math.random(self.x, self.x + self.width - 1),
         y = math.random(self.y, self.y + self.height - 1)
      }
      sq = square.new {center = center, halfSide = 1}
      --
      if not sq:collisionInSquare(self.sTable) then
         sq.halfSide = math.min(sq:maxDistOthers(self.sTable,
                                                 self.marge,
                                                 math.min(self.width, self.height)),
                                sq:maxDistEdges(self.marge, self.xy, self.wh),
                                self.maxAdmis)
         if sq.halfSide >= self.minAdmis then
            table.insert(self.sTable, sq)
            --
            self.cr:set_source(self.coul)
            self.cr:rectangle(center.x - sq.halfSide, center.y - sq.halfSide,
                              2 * sq.halfSide, 2 * sq.halfSide)
            self.fstyle(self.cr)
         end
      end
   end
   -- on renvoie le dernier carré tracé
   return sq
end

function squares:update(n)
   local diff = n - self.n
   self.n = n
   self:trace(diff)
   return diff
end

function squares:poseProbleme(n)
   return n - self.n < 0
end

--
--

function init_carres(cr)
   local mesCarres = {}
   
   mesCarres.heures = squares.new(
      {marge    = 5,
       minAdmis = 30},
      cr)
   --
   mesCarres.heures:set_dim(
      {x = 0,
       y = 0 + 30},
      {width  = 1080,
       height = 1920 - 30})
   --
   local h = tonumber(os.date("%H"))
   dernier = mesCarres.heures:trace(h)
   mesCarres.heures.n = h
   --
   -- remplissage carrés des heures passées
   --
   local minutes
   local sq
   for i=1,#mesCarres.heures.sTable - 1 do
      minutes = squares.new(
         {marge    = 3,
          minAdmis = 2,
          fstyle = function(ctx) ctx:fill() end
         },
         cr
      )
      sq = mesCarres.heures.sTable[i]
      minutes:set_dim(
         sq:topleft(),
         {width = sq.halfSide * 2, height = sq.halfSide * 2}
      )
      minutes:trace(6)
   end
   --
   --
   --
   mesCarres.minutes = squares.new(
      {marge = 3,
       minAdmis = 2,
       fstyle = function(ctx) ctx:fill() end
      },
      cr
   )
   --
   mesCarres.minutes:set_dim(
      dernier:topleft(),
      {width  = dernier.halfSide * 2,
       height = dernier.halfSide * 2}
   )
   --
   local m = math.floor(tonumber(os.date("%M")) / 10)
   mesCarres.minutes:trace(m)
   mesCarres.minutes.n = m

   return mesCarres
end


function update()
   local nbNouveau = carresAux.heures:update(tonumber(os.date("%H")))
   --
   if nbNouveau ~= 0 then
      -- on finit le précédent
      carresAux.minutes:update(6)
      -- on réinit.
      carresAux.minutes.sTable = {}
      carresAux.minutes.n = 0
      local dernier =  carresAux.heures.sTable[#carres.heures.sTable]
      carresAux.minutes:set_dim(
         dernier:topleft(),
         {width  = dernier.halfSide * 2,
          height = dernier.halfSide * 2}
      )
   end
   carresAux.minutes:update(math.floor(tonumber(os.date("%M")) / 10))
end


monimg = cairo.ImageSurface.create(cairo.Format.ARGB32, 1080, 1920)
cr = cairo.Context(monimg)
carresAux = init_carres(cr)
gears.wallpaper.fit(monimg, screen[2])
-- monimg:write_to_png("test___.png")

gears.timer {
  timeout   = 60,
  call_now   = true,
  autostart = true,
  callback  = function()
      update()
      gears.wallpaper.fit(monimg, screen[2])   
  end
}


