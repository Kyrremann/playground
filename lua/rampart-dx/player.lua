local class = require "middleclass"

local Player = class('Player')

function Player:initialize(name, color, input, gamestate)
   self.name = name
   self.color = color
   -- Keyboard
   -- these need to be set
   self.keys = {
      left = "left",
      right = "right",
      up = "up",
      down = "down",
      confirm = "space",
      rotate = "b"
   }
   self.mouse = {
      x = 1,
      y = 1
   }
   self.input = input
   self.build = {
      wall = math.random(1, #SHAPES),
      rotation = math.random(1, 4)
   }
   self.cannons = {}
   self.gamestate = gamestate
end

-- UPDATE
function Player:update(dt)
   if self:isUsingMouse() then
      self.mouse.x = math.floor(mo.getX() / SIZE)
      self.mouse.y = math.floor(mo.getY() / SIZE)
   end
   if gamestate:isGame() then
      if gamestate:isFightTurn() then
	 self:updateBullets(dt)
      end
   end
end

function Player:updateBullets(dt)
   for i, cannon in ipairs(self.cannons) do
      cannon:update(dt)
   end
end

-- DRAW
function Player:draw()
   if gamestate:isGame() then
      if gamestate:isFightTurn() then
	 self:drawBullets()
      end
   end
   self:drawCrosshair()
end

function Player:drawCrosshair()
   local mouse = self.mouse
   local x = mouse.x * SIZE - SIZE * .5
   local y = mouse.y * SIZE - SIZE * .5

   gr.setColor(self.color)
   gr.circle("line", x, y, 10)
   gr.circle("line", x, y, 3)
end

function Player:drawBullets()
   for i, cannon in ipairs(self.cannons) do
      cannon:draw()
   end
end

-- INPUT
function Player:isUsingMouse()
   return self.input == "mouse"
end

function Player:isUsingKeyboard()
   return self.input == "keyboard"
end

function Player:keyreleased(key)
   if self:isUsingKeyboard() then
      local keys = self.keys
      local mouse = self.mouse
      local x = mouse.x
      local y = mouse.y
      
      if key == keys.left then
	 mouse.x = x - 1
	 return true
      elseif key == keys.right then
	 mouse.x = x + 1
	 return true
      elseif key == keys.up then
	 mouse.y = y - 1
	 return true
      elseif key == keys.down then
	 mouse.y = y + 1
	 return true
      elseif key == keys.confirm then
      elseif key == keys.rotate then
      end
   end
   return false
end

function Player:mousepressed(x, y, button)
   if button == "l" then
      if gamestate:isMenu() then
	 map[self.mouse.y][self.mouse.x].type = "wall"
      end
   elseif button == "r" then
      if gamestate:isGame() then
	 if gamestate:isBuildWallsTurn() then
	    local build = self.build
	    build.rotation = build.rotation + 1
	    if build.rotation > 4 then
	       build.rotation = 1
	    end
	 end
      end
   end
end

function Player:mousereleased(x, y, button)
   if button == "l" then      
      if gamestate:isBuildWallsTurn() then
	 if self:isUsingMouse() then
	    if isLegalWallSquare(self) then
	       placeWall(self)
	       self:newWall()
	    end
	 end
      elseif gamestate:isPlaceCannonsTurn() then
	 if isLegalCannonSquare(self) then
	    placeCannon(self)
	 end
      elseif gamestate:isFightTurn() then
	 self:fireFirstCannon(x, y)
      end
   elseif button == "r" then
   end
end

-- OTHER
function Player:newWall()
   self.build.wall = math.random(1, #SHAPES)
   self.build.rotation  = math.random(1, 4)
end

function Player:addCannon(cannon)
   table.insert(self.cannons, cannon)
end

function Player:fireFirstCannon(targetX, targetY)
   for i, cannon in ipairs(self.cannons) do
      if cannon:isReady() then
	 cannon:fire({ x = targetX, y = targetY })
	 return
      end
   end
end

return Player
