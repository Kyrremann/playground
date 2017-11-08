local class = require "middleclass"

local Bullet = class('Bullet')

Bullet.static.SPEED = 7.8

function Bullet:initialize(startX, startY, mouseX, mouseY, owner)
   -- check if one of the pointers are for the grid, and not the screen
   self.x = startX
   self.y = startY
   local angle = math.atan2((mouseY - startY), 
			    (mouseX - startX))
   self.dx = Bullet.SPEED * math.cos(angle)
   self.dy = Bullet.SPEED * math.sin(angle)
   self.owner = owner      
end

function Bullet:update(dt)
   self.x = self.x + (self.dx * dt)
   self.y = self.y + (self.dy * dt)
end

function Bullet:draw()
   gr.setColor(40, 40, 40)
   gr.circle("fill", self.x * SIZE, self.y * SIZE, 5)
end

return Bullet
