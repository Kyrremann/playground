local class = require "middleclass"

local Gametimer = class('Gametimer')

function Gametimer:initialize(gs)
   self.gs = gs
   self.BUILD_WALLS = 0
   self.BUILD_CANNONS = 0
   self.FIGHT = 0
   
   self.BUILD_WALLS_MAX = 1
   self.BUILD_CANNONS_MAX = 3
   self.FIGHT_MAX = 10
end

function Gametimer:update(dt)
   if self.gs:isGame() then
      if self.gs:isBuildWallsTurn() then
	 self.BUILD_WALLS = self.BUILD_WALLS + dt
	 if self.BUILD_WALLS > self.BUILD_WALLS_MAX then
	    self.BUILD_WALLS = 0
	    self.gs:nextTurn()
	 end

      elseif self.gs:isPlaceCannonsTurn() then
	 self.BUILD_CANNONS = self.BUILD_CANNONS + dt
	 if self.BUILD_CANNONS > self.BUILD_CANNONS_MAX then
	    self.BUILD_CANNONS = 0
	    self.gs:nextTurn()
	 end

      elseif self.gs:isFightTurn() then
	 self.FIGHT = self.FIGHT + dt
	 if self.FIGHT > self.FIGHT_MAX then
	    self.FIGHT = 0
	    self.gs:nextTurn()
	 end

      end
   end
end

function Gametimer:draw()
   gr.setColor(255, 255, 255)
   if self.gs:isGame() then
      if self.gs:isBuildWallsTurn() then
	 gr.print("BUILD:\n" .. math.floor(self.BUILD_WALLS) .. " s", 
		  33 * SIZE, 10)

      elseif self.gs:isPlaceCannonsTurn() then
	 gr.print("CANNONS:\n" .. math.floor(self.BUILD_CANNONS) .. " s", 
		  33 * SIZE, 10)

      elseif self.gs:isFightTurn() then
	 gr.print("FIGHT:\n" .. math.floor(self.FIGHT) .. " s", 
		  33 * SIZE, 10)

      end
   end
end

return Gametimer
