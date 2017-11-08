HC = require 'HC'

-- array to hold collision messages
local text = {}

function love.load()
   poly_1 = HC.polygon(0, 336,
		     0, 800,
		     153, 800,
		     147, 704,
		     144, 649,
		     122, 568,
		     195, 438,
		     258, 356,
		     272, 269,
		     241, 224,
		     189, 178,
		     128, 132,
		     77, 0,
		     1, 0)
   poly_2 = HC.polygon(499, 142,
		       463, 239,
		       413, 309,
		       441, 437,
		       473, 657,
		       422, 800,
		       600, 800,
		       610, 260,
		       600, 0,
		       480, 0)
 
   -- add a circle to the scene
   mouse = HC.circle(300,0,20)
end

function love.update(dt)
   -- move circle to mouse position
   local x, y = mouse:center()
   if love.keyboard.isDown('left') then
      x = x - (dt * 40)
   elseif love.keyboard.isDown('right') then
      x = x + (dt * 40)
   end
   mouse:moveTo(x, y + (dt * 30))

   -- check for collisions
   for shape, delta in pairs(HC.collisions(mouse)) do
      text[#text+1] = string.format("Colliding. Separating vector = (%s,%s)",
				    delta.x, delta.y)
   end

   while #text > 40 do
      table.remove(text, 1)
   end
end

function love.draw()
   -- print messages
   for i = 1,#text do
      love.graphics.setColor(255,255,255, 255 - (i-1) * 6)
      love.graphics.print(text[#text - (i-1)], 10, i * 15)
   end

   -- shapes can be drawn to the screen
   love.graphics.setColor(255,255,255)
   poly_1:draw('fill')
   poly_2:draw('fill')
   love.graphics.setColor(205,25,255)
   mouse:draw('fill')
end
