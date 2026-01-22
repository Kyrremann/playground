--[[
   ABSTRACT CLASS
   a 'movable thing' has grid coordinates (from gridlocked), and can move()
]]
-- superclass requires
require "gridlocked"

Movable = Class{ __includes = Gridlocked }

function Movable:init(x, y)
   Gridlocked.init(self, x, y)
   self.actual_x = self.grid_x*GRID_SIZE
   self.actual_y = self.grid_y*GRID_SIZE
   self.speed = 1
end

function Movable:move(x, y, dir)
   if self.grid_x + x < 1 or self.grid_y + y < 1 then
      return
   elseif self.grid_x + x > #map.tiles[1] or self.grid_y + y > #map.tiles then
      return
   end 
   
   if not map.tiles[(self.grid_y) + y][(self.grid_x) + x]:is_massive() then
      self.grid_x = self.grid_x + (x)
      self.grid_y = self.grid_y + (y)
      self.dir = dir or self.dir
      --trigger_event()
   end
end

function Movable:teleport(x, y)
   log_display = "You suddently moved"
   self.grid_x = x
   self.grid_y = y
   --trigger_event()
end

