-- Include Simple Tiled Implementation into project
local sti = require "sti"

function love.load()
   -- Load map file
   map = sti("test_map.lua")

   -- Create new dynamic data layer called "Sprites" as the 4th layer
   local layer = map:addCustomLayer("Sprites", 4)

   -- Get player spawn object
   local player, camera
   for k, object in pairs(map.objects) do
      if object.name == "Player" then
	 player = object
      elseif object.name == "Camera" then
	 camera = object
	 break
      end
   end

   -- Create player object
   local sprite = love.graphics.newImage("medievalUnit_01.png")
   layer.player = {
      sprite = sprite,
      x      = player.x + 32,
      y      = player.y + 32,
      ox     = sprite:getWidth() / 2.2,
      oy     = sprite:getHeight() / 2,
      tx     = player.x,
      ty     = player.y,
      dx     = 0,
      dy     = 0,
      dist   = 0,
      sx     = 0,
      sy     = 0
   }

   layer.camera = {
      x = camera.x - 700,
      y = camera.y - 700
   }

   -- Add controls to camera
   layer.update = function(self, dt)
      -- 96 pixels per second
      local speed = 192--96

      -- Move camera up
      if love.keyboard.isDown("w") or love.keyboard.isDown("up") then
	 self.camera.y = math.min(0, self.camera.y + speed * dt)
      end

      -- Move camera down
      if love.keyboard.isDown("s") or love.keyboard.isDown("down") then
	 -- TODO: -680 need to be calculated
	 self.camera.y = math.max(-680, self.camera.y - speed * dt)
      end

      -- Move camera left
      if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
	 self.camera.x = math.min(0, self.camera.x + speed * dt)
      end

      -- Move camera right
      if love.keyboard.isDown("d") or love.keyboard.isDown("right") then
	 -- TODO: -680 need to be calculated
	 self.camera.x = math.max(-480, self.camera.x - speed * dt)
      end

      if self.player.dist ~= 0 then
	 local player = self.player
	 player.x = player.x + (player.dx * dt)
	 player.y = player.y + (player.dy * dt)

	 local dist = (player.sx - player.x)^2 + (player.sy - player.y)^2
	 if dist >= player.dist then
	    -- Overshot - teleport to target instead.
	    player.x = player.tx
	    player.y = player.ty
	    player.dx = 0
	    player.dy = 0
	 end
      end
   end
   
   -- Draw player
   layer.draw = function(self)
      love.graphics.draw(
	 self.player.sprite,
	 math.floor(self.player.x),
	 math.floor(self.player.y),
	 0,
	 1,
	 1,
	 self.player.ox,
	 self.player.oy
      )
   end

   map:removeLayer("Spawn Point")
end

function love.update(dt)
   -- Update world
   map:update(dt)
end

function love.draw()
   -- Translate world so that camera is always centred
   local camera = map.layers["Sprites"].camera
   local tx = math.floor(camera.x)
   local ty = math.floor(camera.y)
   
   -- Draw world
   map:draw(tx, ty)

   draw_grid(tx, ty)
end

function draw_grid(tx, ty)
   love.graphics.setColor(255, 255, 255, 125)
   local number = math.ceil(math.max(love.graphics.getHeight(),
				     love.graphics.getWidth()) / 64)
   startx = tx + (math.floor(math.abs(tx) / 64) * 64)
   starty = ty + (math.floor(math.abs(ty) / 64) * 64)
   for x=0, number do
      lx = startx + (x * 64)
      love.graphics.line(lx, math.max(0, ty),
			 lx, love.graphics.getHeight())
   end

   for y=0, number do
      ly = starty + (y * 64)
      love.graphics.line(math.max(0, tx), ly,
			 love.graphics.getWidth(), ly)
   end
   love.graphics.setColor(255, 255, 255)
end

function love.mousereleased(x, y, button, istouch)
   local player = map.layers["Sprites"].player
   local camera = map.layers["Sprites"].camera

   player.sx = player.x
   player.sy = player.y
   
   player.tx = nearest_tile(x - camera.x) + 31
   player.ty = nearest_tile(y - camera.y) + 31

   local angle = math.atan2((player.ty - player.sy), (player.tx - player.sx))

   player.dx = 64 * math.cos(angle)
   player.dy = 64 * math.sin(angle)

   
   player.dist = (player.tx - player.sx)^2 + (player.ty - player.sy)^2
end

function nearest_tile(num)
   return math.floor(num/64) * 64
end
