local class = require "middleclass"

local Ball = class('Ball')

function Ball:initialize(x, y, a, imagePath)
   self.image = gr.newImage(imagePath)
   self.velocity = { x = -100, y = 0 }
   self.shape = Collider:addCircle(400,300, 10)
end

function Ball:update(dt)
   self.shape:move(self.velocity.x * dt, self.velocity.y * dt)
end

function Ball:draw()
   local x, y = self.shape:center()
   gr.draw(self.image, 
	   x, y,
	   self.shape:rotation(),
	   1,
	   1,
	   self.image:getWidth() / 2, self.image:getHeight() / 2)


   self.shape:draw('line')
end
 
return Ball
