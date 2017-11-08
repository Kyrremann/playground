Class = require "class"

Piece = Class {
   init = function(self, loc_y, loc_x, piece, color)
      self.grid_x = loc_x
      self.grid_y = loc_y
      self.pos = { x = loc_x,
		   y = loc_y }
      self.act_x = self.grid_x * boardTileX
      self.act_y = self.grid_y * boardTileY
      self.speed = 5
      self.type = piece
      self.color = color
      self.value = -1
      self.dragging = false
   end;
   __tostring = function(self)
      if self.type == 'pawn' then
	 return self.color == 'w' and "♙" or '♟'
      elseif self.type == 'bishop' then
	 return self.color == 'w' and "♗" or '♝'
      elseif self.type == 'knight' then
	 return self.color == 'w' and "♘" or '♞'
      elseif self.type == 'rook' then
	 return self.color == 'w' and "♖" or '♜'
      elseif self.type == 'queen' then
	 return self.color == 'w' and "♕" or '♛'
      elseif self.type == 'king' then
	 return self.color == 'w' and "♔" or '♚'
      end
      
      return 'x'
   end
}

function Piece:draw()
   if self.type == 'pawn' then
      if self.color == 'w'
      then gr.draw(chessTileset, tileQuads[12], self.act_x + 7, self.act_y + 8)
      else gr.draw(chessTileset, tileQuads[6], self.act_x + 7, self.act_y + 8) end
      
   elseif self.type == 'bishop' then
      if self.color == 'w' 
      then gr.draw(chessTileset, tileQuads[10], self.act_x + 7, self.act_y + 8)
      else gr.draw(chessTileset, tileQuads[4], self.act_x + 7, self.act_y + 8) end
      
   elseif self.type == 'knight' then
      if self.color == 'w'
      then gr.draw(chessTileset, tileQuads[9], self.act_x + 7, self.act_y + 8) 
      else gr.draw(chessTileset, tileQuads[3], self.act_x + 7, self.act_y + 8) end
      
   elseif self.type == 'rook' then
      if self.color == 'w'
      then gr.draw(chessTileset, tileQuads[11], self.act_x + 7, self.act_y + 8) 
      else gr.draw(chessTileset, tileQuads[5], self.act_x + 7, self.act_y + 8) end
      
   elseif self.type == 'queen' then
      if self.color == 'w'
      then gr.draw(chessTileset, tileQuads[8], self.act_x + 7, self.act_y + 8) 
      else gr.draw(chessTileset, tileQuads[2], self.act_x + 7, self.act_y + 8) end

   elseif self.type == 'king' then
      if self.color == 'w'
      then gr.draw(chessTileset, tileQuads[7], self.act_x + 7, self.act_y + 8) 
      else gr.draw(chessTileset, tileQuads[1], self.act_x + 7, self.act_y + 8) end
   end
end

function Piece:update(dt)
   if not self.dragging then
      self.act_y = self.act_y - ((self.act_y - (self.grid_y * boardTileY)) * self.speed * dt)
      self.act_x = self.act_x - ((self.act_x - (self.grid_x * boardTileX)) * self.speed * dt)
   else
      self.act_y = mo.getY() - boardTileY / 2
      self.act_x = mo.getX() - boardTileX / 2
   end
end

function Piece:mousepressed(x, y, button)
   self.dragging = true
   self.act_x = x
   self.act_y = y
end

function Piece:mousereleased(x, y, button)
   self.dragging = false
   local grid_x = math.floor(x / boardTileX)
   local grid_y = math.floor(y / boardTileY)
   if not occupied(grid_x, grid_y) then
      if isInsideBoard(x, y) then
	 self:move(x, y)
      end
   elseif isOpponent(grid_x, grid_y, self.color) then
      captureOpponent(grid_x, grid_y)
      self:move(x, y)
   end
end

function Piece:move(x, y)
   self.grid_x = math.floor(x / boardTileX)
   self.grid_y = math.floor(y / boardTileY)
end
