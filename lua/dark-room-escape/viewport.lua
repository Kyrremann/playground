--[[
   Viewport (what's drawn of the map, the 'camera')
]]

-- superclass requires
require "gridlocked"

Viewport = Class{ __includes = Gridlocked }

function Viewport:init( grid_x, grid_y, width, height )
   Gridlocked.init(self, grid_x, grid_y)
   self.width = width
   self.height = height
   
   self.follow_player = true
end

function Viewport:update( dt )
   -- todo: smooth motion here... update viewport actual x&y values etc...
   -- look at player
   if self.follow_player then
      self.grid_x = player.grid_x - (math.floor(VIEWPORT_SIZE_X/2) +1)
      self.grid_y = player.grid_y - (math.floor(VIEWPORT_SIZE_Y/2) +1)
   end
end

function Viewport:draw()
   
   -- draw viewport bounding rectangle
   gr.setColor(100,100,100)
   gr.rectangle("line",
		VIEWPORT_X, VIEWPORT_Y,
		self.width*GRID_SIZE, self.height*GRID_SIZE)
   
   -- draw tiles
   for y=1, self.height do
      for x=1, self.width do
	 local tile_x = x + self.grid_x
	 local tile_y = y + self.grid_y
	 local draw_x = ((y-1) * GRID_SIZE) + VIEWPORT_X
	 local draw_y = ((x-1) * GRID_SIZE) + VIEWPORT_Y
	 
	 -- only draw tile if inside the map & viewport!
	 if tile_x >= 1 and tile_x <= map.size.x and
	    tile_y >= 1 and tile_y <= map.size.y 
	 then
	    map.tiles[tile_y][tile_x]:draw( draw_y, draw_x )
	 end
      end
   end
   
   -- draw player (always center of viewport)
   local draw_x = VIEWPORT_X + ((math.floor(VIEWPORT_SIZE_X/2))*GRID_SIZE)
   local draw_y = VIEWPORT_Y + ((math.floor(VIEWPORT_SIZE_Y/2))*GRID_SIZE)
   player:draw( draw_x, draw_y )
end