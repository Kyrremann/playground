function love.load()
   require "setup"

   -- players

   -- pieces
   white_pieces = {}
   black_pieces = {}
   init_pieces('normal')
   init_tileset()
   init_boardset()
   gr.setBackgroundColor(255, 255, 255)
end

function love.update(dt)
   for i=1, #white_pieces do
      white_pieces[i]:update(dt)
   end
   for i=1, #black_pieces do
      black_pieces[i]:update(dt)
   end
end

function love.draw()
   local start_x = boardTileX
   local start_y = boardTileY
   
   gr.setColor(255, 255, 255)
   for y=1, 8 do
      for x=1, 8 do
	 if (math.mod(x, 2) == math.mod(y, 2)) then
	    gr.draw(boardTileset, boardQuads[1], 
		     start_x * x, start_y * y)
	 else
	    gr.draw(boardTileset, boardQuads[2], 
		     start_x * x, start_y * y)
	 end
      end
   end
   
   local drawLast = nil
   for i=1, #white_pieces do
      if white_pieces[i].dragging then
	 drawLast = white_pieces[i]
      else
	 white_pieces[i]:draw()
      end
   end
   for i=1, #black_pieces do
      if black_pieces[i].dragging then
	 drawLast = black_pieces[i]
      else
	 black_pieces[i]:draw()
      end
   end

   if drawLast then
      drawLast:draw();
      portrait_draw(drawLast)
   end
end

function love.keypressed(key, scancode, isrepeat)
   if key == 'space' then
      print_board_to_console()
   else
      love.event.push('quit')
   end
end

function love.mousepressed(x, y, button, istouch)
   if button == 1 and not active_drag then
      for i=1, #white_pieces do
	 local w = white_pieces[i]
	 if w.grid_x == math.floor(x / boardTileX)
	 and w.grid_y == math.floor(y / boardTileY) then
	    active_drag = true
	    w:mousepressed(x, y, button)
	 end
      end
      for i=1, #black_pieces do
	 local b = black_pieces[i]
	 if b.grid_x == math.floor(x / boardTileX)
	 and b.grid_y == math.floor(y / boardTileY) then
	    active_drag = true
	    b:mousepressed(x, y, button)
	 end
      end
   end
end

function love.mousereleased(x, y, button, istouch)
   if button == 1 and active_drag then
      active_drag = false
      for i=1, #white_pieces do
	 if white_pieces[i].dragging then
	    return white_pieces[i]:mousereleased(x, y, button)
	 end
      end
      for i=1, #black_pieces do
	 if black_pieces[i].dragging then
	    return black_pieces[i]:mousereleased(x, y, button)
	 end
      end
   end
end

function occupied(grid_x, grid_y)
   for i=1, #white_pieces do
      if grid_x == white_pieces[i].grid_x
	 and grid_y == white_pieces[i].grid_y
      then
	 return true
      end
   end
   
   for i=1, #black_pieces do
      if grid_x == black_pieces[i].grid_x
	 and grid_y == black_pieces[i].grid_y
      then
	 return true
      end
   end
   
   return false
end

function isOpponent(grid_x, grid_y, color)
   if color == 'b' then
      for i=1, #white_pieces do
	 if grid_x == white_pieces[i].grid_x
	    and grid_y == white_pieces[i].grid_y
	 then
	    return true
	 end
      end
   else
      for i=1, #black_pieces do
	 if grid_x == black_pieces[i].grid_x
	    and grid_y == black_pieces[i].grid_y
	 then
	    return true
	 end
      end
   end
   
   return false
end

function isInsideBoard(x, y)
   return math.floor(x / boardTileX) < 9
      and math.floor(x / boardTileX) > 0
      and math.floor(y / boardTileY) < 9
      and math.floor(y / boardTileY) > 0 
end

function captureOpponent(grid_x, grid_y)
   for i=1, #white_pieces do
      if grid_x == white_pieces[i].grid_x
	 and grid_y == white_pieces[i].grid_y
      then
	 return table.remove(white_pieces, i)
      end
   end
   for i=1, #black_pieces do
      if grid_x == black_pieces[i].grid_x
	 and grid_y == black_pieces[i].grid_y
      then
	 return table.remove(black_pieces, i)
      end
   end
end
