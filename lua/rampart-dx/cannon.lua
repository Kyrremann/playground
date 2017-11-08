local class = require "middleclass"

local Cannon = class('Cannon')

Cannon.static.TIMER_MAX = 1.5

function Cannon:initialize(x, y, owner)
   self.x = x
   self.y = y
   self.owner = owner
   self.bullets = {}
   self.ready = true
   self.timer = 0
end

function Cannon:update(dt)
   self.timer = self.timer + dt
   if self.timer > Cannon.TIMER_MAX then
      self.timer = 0
      self.ready = true
   end
   if gamestate:isGame() then
      if gamestate:isFightTurn() then
	 for i, bullet in ipairs(self.bullets) do
	    bullet:update(dt)
	 end
      end
   end
end

function Cannon:draw()
   if gamestate:isGame() then
      if gamestate:isFightTurn() then
	 for i, bullet in ipairs(self.bullets) do
	    bullet:draw()
	 end
      end
   end
end

function Cannon:isReady()
   return self.ready
end

function Cannon:fire(target)
   table.insert(self.bullets, Bullet(self.x, self.y, target.x, target.y, self.owner))
   self.ready = false
end

return Cannon
