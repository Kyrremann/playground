local class = require "middleclass"

local Gamestate = class('Gamestate')

Gamestate.static.MENU = 'menu'
Gamestate.static.GAME = 'game'
Gamestate.static.GAME_BUILD = 'game-build'
Gamestate.static.GAME_CANNONS = 'game-cannons'
Gamestate.static.GAME_FIGHT = 'game-fight'
Gamestate.static.END = 'end'

function Gamestate:initialize()
   self.mode = Gamestate.MENU
   self.turnCounter = 0
   self.turnType = -1
end

-- modes
function Gamestate:setMode(mode)
   self.mode = mode
end

function Gamestate:isMode(mode)
   return self.mode == mode
end

function Gamestate:isMenu()
   return self:isMode(Gamestate.MENU)
end

function Gamestate:isGame()
   return self:isMode(Gamestate.GAME)
end

function Gamestate:isEnd()
   return self:isMode(Gamestate.END)
end

function Gamestate:getMode()
   return self.mode
end

-- game turns
function Gamestate:setTurn(turn)
   self.turnType = turn
   self.turnCounter = self.turnCounter + 1
end

function Gamestate:nextTurn()
   if self:isGame() then
      if self:isBuildWallsTurn() then
	 self.turnType = Gamestate.GAME_CANNONS
	 
      elseif self:isPlaceCannonsTurn() then
	 self.turnType = Gamestate.GAME_FIGHT

      elseif self:isFightTurn() then
	 self:startBuildTurn()
	 
      end
   end
end

function Gamestate:startBuildTurn()
   self.turnType = Gamestate.GAME_BUILD
   paint_players_areas()
end

function Gamestate:isTurn(turn)
   return self.turnType == turn
end

function Gamestate:isBuildWallsTurn()
   return self:isTurn(Gamestate.GAME_BUILD)
end

function Gamestate:isPlaceCannonsTurn()
   return self:isTurn(Gamestate.GAME_CANNONS)
end

function Gamestate:isFightTurn()
   return self:isTurn(Gamestate.GAME_FIGHT)
end

return Gamestate
