function love.load()
   require "setup"
   
   local fontUrl = "fonts/kenpixel_future_square.ttf"
   fontMini = gr.newFont(fontUrl, 11)
   fontSmall = gr.newFont(fontUrl, 22)
   fontBig = gr.newFont(fontUrl, 48)
   
   field = gr.newImage("images/grass.png")
   ball = {
      x = 250,
      y = 250,
      dx = 0,
      dy = 0,
      angle = 0,
      image = gr.newImage("images/ballSoccerAlt.png"),
      radius = 9.5
   }
   local playerImage = gr.newImage("images/playerBlue0.png")
   player = {
      x = 100,
      y = 100,
      angle = 0,
      image = {
	 player = playerImage,
	 kick = gr.newImage("images/playerBlue_leg.png")
      },
      kick = false,
      kickCircle = {
	 radius = 6,
	 x = playerImage:getWidth() / 1.5,
	 y = -(playerImage:getHeight() / 6),
	 
      }
   }
   

   math.randomseed(os.time())
end

function love.update(dt)
   updatePlayer(dt)
   updateBall(dt)
end

function love.draw()
   drawBackground()
   drawBall()
   drawPlayer()
end

function love.keypressed(key)
   if key == "escape" then
      love.event.push('quit')
      return
   elseif key == "return" then
      return
   elseif key == 'f9' then
      debug = not debug
      return
   end
end

function love.keyreleased(key)
end

function drawBackground()
   for y=0, gr.getHeight() / field:getHeight() do
      for x=0, gr.getWidth() / field:getWidth() do
	 gr.draw(field, x * field:getWidth(), y * field:getHeight())
      end
   end
end

function drawPlayer()
   gr.push()
   gr.translate(player.x, player.y)
   gr.rotate(player.angle)
   if player.kick then
      gr.draw(player.image.kick,
	      (player.image.player:getWidth() / 4),
		 -(player.image.player:getHeight() / 3))
   end
   gr.draw(player.image.player, 
	      -(player.image.player:getWidth() / 2),
	      -(player.image.player:getHeight() / 2))
   if debug then
      gr.rectangle("line",
		      -11, -15.5,
		   22, 31)
  --    if player.kick then
	 gr.rectangle("line",
		      player.image.player:getWidth() / 4,
			 -(player.image.player:getHeight() / 3),
		      19, 12)
--      end
	 gr.circle("line",
		   player.kickCircle.x, player.kickCircle.y,
		   player.kickCircle.radius)
   end
   gr.pop()
end

function updatePlayer(dt)
   local rotation = 10
   local speed = 200
   
   if ke.isDown(" ") then
      if ballIsClose() then
	 player.kick = true
	 ball.dx = (speed * 3) * math.cos(player.angle)
	 ball.dy = (speed * 3) * math.sin(player.angle)
      end
   else
      player.kick = false
      if love.keyboard.isDown("left") then
	 player.angle = player.angle - dt * rotation
      end
      if love.keyboard.isDown("right") then
	 player.angle = player.angle + dt * rotation
      end
      if ke.isDown("up") then
	 player.x = player.x + (math.cos(player.angle) * dt * speed)
	 player.y = player.y + (math.sin(player.angle) * dt * speed)
      end
      if ke.isDown("down") then
	 player.x = player.x - (math.cos(player.angle) * dt * speed)
	 player.y = player.y - (math.sin(player.angle) * dt * speed)
      end
   end
end

function drawBall()
   gr.push()
   gr.translate(ball.x, ball.y)
   gr.rotate(ball.angle)
   gr.draw(ball.image,
	      -(ball.image:getWidth() / 2),
	      -(ball.image:getHeight() / 2)
   )
   gr.pop()
   if debug then
      gr.circle("line", ball.x, ball.y, ball.radius)
      --gr.rectangle("line", ball.x - 9.5, ball.y - 9.5, 19, 19)
   end
end

function updateBall(dt)
   ball.dx = ball.dx - (ball.dx * .01)
   ball.dy = ball.dy - (ball.dy * .01)
   --[[
      if ball.dx < 10 and ball.dy < 10 then
      ball.dx = 0
      ball.dy = 0
      end
   ]]
   ball.x = ball.x + (ball.dx * dt)
   ball.y = ball.y + (ball.dy * dt)
   bounceWall()
end

function bounceWall()
   if ball.x > gr.getWidth() then
      ball.dx = -ball.dx
   end
   if ball.y > gr.getHeight() then
      ball.dy = -ball.dy
   end
   if ball.x < 0 then
      ball.dx = -ball.dx
   end
   if ball.y < 0 then
      ball.dy = -ball.dy
   end
end

function ballIsClose()
   return checkCollisionCircle(player.kickCircle, ball)
--[[
   return checkCollision(
      player.x + (player.image.player:getWidth() / 4),
      player.y - (player.image.player:getHeight() / 3)
      , 22, 31,
      ball.x - 9.5, ball.y - 9.5,
      19, 19
   )
]]
end

function checkCollisionCircle(circleA, circleB)
   print("CCC")
   print(circleA.x .. "," .. circleA.y)
   print(circleB.x .. "," .. circleB.y)
   local dist = (circleA.x - circleB.x)^2 + (circleA.y - circleB.y)^2
   print(dist .. " - " .. (circleA.radius + circleB.radius)^2)
   return dist <= (circleA.radius + circleB.radius)^2
end

function checkCollisionRectangle(x1, y1, w1, h1, x2, y2, w2, h2)
   return x1 < x2 + w2 and
      x2 < x1 + w1 and
      y1 < y2 + h2 and
      y2 < y1 + h1
end


function drawTitle()
   gr.setFont(fontBig)
   gr.printf("Kick The Ball", 
	     0, gr.getHeight() / 10, gr.getWidth(), "center")
end
