HC = require 'HardonCollider'

function on_collide(dt, shape_a, shape_b)
   -- determine which shape is the ball and which is not
   local other
   if shape_a == ball.shape then
      other = shape_b
   elseif shape_b == ball.shape then
      other = shape_a
   else -- no shape is the ball. exit
      return
   end
   
   -- reset on goal
   if other == goalLeft then
      ball.velocity = {x = 100, y = 0}
      ball.shape:moveTo(400,300)
   elseif other == goalRight then
      ball.velocity = {x = -100, y = 0}
      ball.shape:moveTo(400,300)
   elseif other == borderTop or other == borderBottom then
      -- bounce off top and bottom
      ball.velocity.y = -ball.velocity.y
   elseif other == player.shape then
      -- TODO
   else
      --[[
      -- bounce of paddle
      local px,py = other:center()
      local bx,by = ball:center()
      local dy = by - py
      ball.velocity.x = -ball.velocity.x
      ball.velocity.y = dy

      -- keep the ball at the same speed
      local len = math.sqrt(ball.velocity.x^2 + ball.velocity.y^2)
      ball.velocity.x = ball.velocity.x / len * 100
      ball.velocity.y = ball.velocity.y / len * 100
      --
      ]]
   end
end

function love.load()
   gr = love.graphics
   Collider = HC(100, on_collide)

   BALL = require "ball"
   PLAYER = require "player"

   ball = BALL:new(0, 0, 0, "images/ballSoccerAlt.png")
   player = PLAYER:new("test", 0, 0, 0, "images/playerBlue0.png")

   borderTop    = Collider:addRectangle(0,-100, 800,100)
   borderBottom = Collider:addRectangle(0,600, 800,100)
   goalLeft     = Collider:addRectangle(-100,0, 100,600)
   goalRight    = Collider:addRectangle(800,0, 100,600)
end

function love.update(dt)
   player:update(dt)
   ball:update(dt)

   Collider:update(dt)
end

function love.draw()
   player:draw()
   ball:draw()
end
