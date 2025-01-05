-- Include Simple Tiled Implementation into project
local sti = require "sti"
local love = require "love"

function love.load()
   -- Load map file
   MAP = sti("rts-medieval.lua")

   -- Create new dynamic data layer called "Sprites" as the 4th layer
   local layer = MAP:addCustomLayer("Sprites", 4)

   -- Get player spawn object
   local player, camera
   for _, object in pairs(MAP.objects) do
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
      if love.keyboard.isDown("w", "up") then
		 self.camera.y = math.min(0, self.camera.y + speed * dt)
      end

      -- Move camera down
      if love.keyboard.isDown("s", "down") then
		 -- TODO: -680 need to be calculated
		 self.camera.y = math.max(-680, self.camera.y - speed * dt)
      end

      -- Move camera left
      if love.keyboard.isDown("a", "left") then
		 self.camera.x = math.min(0, self.camera.x + speed * dt)
      end

      -- Move camera right
      if love.keyboard.isDown("d", "right") then
		 -- TODO: -480 need to be calculated
		 self.camera.x = math.max(-480, self.camera.x - speed * dt)
      end

      if self.player.dist ~= 0 then
		 local p = self.player
		 p.x = p.x + (p.dx * dt)
		 p.y = p.y + (p.dy * dt)

		 local dist = (p.sx - p.x)^2 + (p.sy - p.y)^2
		 if dist >= p.dist then
			if p.pathIndex <= #p.path then
			   setPlayerDestination(p)
			else
			   -- If overshot, ensure teleport to target.
			   p.x = p.tx
			   p.y = p.ty
			   p.dx = 0
			   p.dy = 0
			   p.dist = 0
			end
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

   MAP:removeLayer("Spawn Point")

   DIJKSTRA = require "dijkstra"
   DIJKSTRA:init(MAP.layers["ground"].data)
end

function love.update(dt)
   -- Update world
   MAP:update(dt)
end

function love.draw()
   -- Translate world so that camera is always centred
   local camera = MAP.layers["Sprites"].camera
   local tx = math.floor(camera.x)
   local ty = math.floor(camera.y)

   -- Draw world
   MAP:draw(tx, ty)

   draw_grid(tx, ty)
end

function draw_grid(tx, ty)
   love.graphics.setColor(255, 255, 255, 125)
   local grids = math.ceil(math.max(love.graphics.getHeight(),
									love.graphics.getWidth()) / 64)
   local startx = tx + nearest_tile(math.abs(tx))
   local starty = ty + nearest_tile(math.abs(ty))

   for x=0, grids do
      local lx = startx + (x * 64)
      love.graphics.line(lx, math.max(0, ty),
						 lx, love.graphics.getHeight())
   end

   for y=0, grids do
      local ly = starty + (y * 64)
      love.graphics.line(math.max(0, tx), ly,
						 love.graphics.getWidth(), ly)
   end

   love.graphics.setColor(255, 255, 255)
end

function love.mousereleased(x, y, button, istouch)
   local player = MAP.layers["Sprites"].player
   local camera = MAP.layers["Sprites"].camera

   local sx, sy = pixelToTile(player.x, player.y)
   local tx, ty = pixelToTile(x - camera.x, y - camera.y)
   local path, _ = DIJKSTRA:calculate({ x = sx, y = sy }, { x = tx, y = ty })

   player.path = path
   player.pathIndex = 1

   setPlayerDestination(player)
end

function setPlayerDestination(player)
   player.tx, player.ty = tileToPixel(player.path[player.pathIndex].x, player.path[player.pathIndex].y)

   player.sx = player.x
   player.sy = player.y

   local angle = math.atan2((player.ty - player.sy), (player.tx - player.sx))

   player.dx = 64 * math.cos(angle)
   player.dy = 64 * math.sin(angle)

   player.dist = (player.tx - player.sx) ^ 2 + (player.ty - player.sy) ^ 2

   player.pathIndex = player.pathIndex + 1
end

function pixelToTile(x, y)
   return math.floor(x / 64) + 1, math.floor(y / 64) + 1
end

function tileToPixel(x, y)
   return (x - 1) * 64 + 31, (y - 1) * 64 + 31
end

function nearest_tile(num)
   return math.floor(num/64) * 64
end

function love.keypressed(key, scancode, isrepeat)
   if key == "escape" then
	  love.event.push("quit")
   end
end
