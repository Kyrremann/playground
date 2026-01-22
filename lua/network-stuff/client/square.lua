Square = {}
Square.__index = Square

function Square.new(idx, x, y, w, h)
   local self = setmetatable({}, Square)

   self.idx = idx -- also server side idx {idx_x, idx_y}
   self.owner = "" -- owner id
   self.progress = 0

   self.x = x
   self.y = y
   self.w = w
   self.h = h

   self.color = {200, 100, 100, 255}

   return self
end

setmetatable(Square, {
                __call = function(clazz, ...)
                   return clazz.new(...)
                end,
})

function Square:isPointInside(x, y)
   if not (x < self.x
	   or x > (self.x + self.w)
	   or y < self.y
	   or y > (self.y + self.h) ) then
      return true
   else
      return false
   end
end

function Square:setColor(r,g,b,a)
   self.color = {r,g,b,a}
end

function Square:draw()
   gra.setColor(unpack(self.color))
   gra.rectangle("line", self.x, self.y, self.w, self.h)

   gra.setColor(255,255,255)
   gra.setFont(font_vtiny)
   gra.print(self.owner, self.x + 10, self.y + 10)
   --gra.print(self.progress, self.x + 10, self.y + 20)

   -- progress bar!
   gra.setColor(100,200,100)
   gra.rectangle("fill", self.x, self.y+ 20,
		 self.w * (math.min(self.progress, 1)),
		 self.h/4)
end

function Square:update(dt)
   -- set default color
   self:setColor({200, 100, 100, 255})
   
   if self:isPointInside(mou.getX(), mou.getY()) then
      grid.hover = self

      if mou.isDown("l") then
	 grid.select = self
      end
   end
end

function Square:network_request_progress()
   
end
