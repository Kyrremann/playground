local class = require "middleclass"

local Player = class('Player')

function Player:initialize(name, x, y, a, imagePath)
   self.name = name
   self.x = x
   self.y = y
   self.image = gr.newImage(imagePath)
   self.shape = Collider:addRectangle(500, 500, 22, 31)
   self.kick = {
      shape = Collider:addRectangle(500, 500, 19, 12),
      image = gr.newImage("images/playerBlue_leg.png")
   }
   self.angle = a
   self.speed = 400
   self.rotation = 10
   self.kicking = false
end

function Player:update(dt)
   if love.keyboard.isDown("left") then
      self.shape:setRotation(self.shape:rotation() - dt * self.rotation)
      self.kick.shape:setRotation(self.kick.shape:rotation() - dt * self.rotation)
   end
   if love.keyboard.isDown("right") then
      self.shape:setRotation(self.shape:rotation() + dt * self.rotation)
      self.kick.shape:setRotation(self.kick.shape:rotation() + dt * self.rotation)
   end
   if love.keyboard.isDown("up") then
      self.shape:move(
         (math.cos(self.shape:rotation()) * dt * self.speed),
         (math.sin(self.shape:rotation()) * dt * self.speed))
      self.kick.shape:move(
         (math.cos(self.kick.shape:rotation()) * dt * self.speed),
         (math.sin(self.kick.shape:rotation()) * dt * self.speed))
   end
   if love.keyboard.isDown("down") then
      self.shape:move(
            -(math.cos(self.shape:rotation()) * dt * self.speed),
            -(math.sin(self.shape:rotation()) * dt * self.speed))
      self.kick.shape:move(
            -(math.cos(self.kick.shape:rotation()) * dt * self.speed),
            -(math.sin(self.kick.shape:rotation()) * dt * self.speed))
   end
   if love.keyboard.isDown("space") then
      self.kicking = true
   end
   if not love.keyboard.isDown("space") then
      self.kicking = false
   end
end

function Player:draw()
   local x, y = self.shape:center()
   gr.draw(self.kick.image,
	   x, y,
	   self.shape:rotation(),
	   1, 1,
	   -6, 10)
   gr.draw(self.image,
	   x, y,
	   self.shape:rotation(),
	   1,
	   1,
	   self.image:getWidth() / 2, self.image:getHeight() / 2)
   
   self.kick.shape:draw("line")
   self.shape:draw('line')
end

return Player
