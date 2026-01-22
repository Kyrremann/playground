--[[
   ABSTRACT CLASS
   a 'gridlocked thing' has grid coordinates
]]
Gridlocked = Class{}

function Gridlocked:init(x, y)
   self.grid_x = x
   self.grid_y = y
end
