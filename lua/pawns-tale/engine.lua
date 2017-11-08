function init_pieces(game_type)
   if game_type == 'normal' then
      -- pawns
      for i=1, 8 do
	 white_pieces[i] = Piece(2, i, 'pawn', 'w')
	 black_pieces[i] = Piece(7, i, 'pawn', 'b')
      end
      -- bishop
      for i=3, 7, 3 do
	 white_pieces[#white_pieces + 1] = Piece(1, i, 'bishop', 'w')
	 black_pieces[#black_pieces + 1] = Piece(8, i, 'bishop', 'b')
      end
      -- knight
      for i=2, 8, 5 do
	 white_pieces[#white_pieces + 1] = Piece(1, i, 'knight', 'w')
	 black_pieces[#black_pieces + 1] = Piece(8, i, 'knight', 'b')
      end
      -- rook
      for i=1, 9, 7 do
	 white_pieces[#white_pieces + 1] = Piece(1, i, 'rook', 'w')
	 black_pieces[#black_pieces + 1] = Piece(8, i, 'rook', 'b')
      end
      -- queen
      white_pieces[#white_pieces + 1] = Piece(1, 4, 'queen', 'w')
      black_pieces[#black_pieces + 1] = Piece(8, 4, 'queen', 'b')
      -- king				
      white_pieces[#white_pieces + 1] = Piece(1, 5, 'king', 'w')
      black_pieces[#black_pieces + 1] = Piece(8, 5, 'king', 'b')
   end
end

function init_tileset()   
   tileQuads[1] = gr.newQuad(0 * tileSizeX, 0, tileSizeX, tileSizeY, chessTileset:getWidth(), chessTileset:getHeight())
   tileQuads[2] = gr.newQuad(1 * tileSizeX, 0, tileSizeX, tileSizeY, chessTileset:getWidth(), chessTileset:getHeight())
   tileQuads[3] = gr.newQuad(2 * tileSizeX, 0, tileSizeX, tileSizeY, chessTileset:getWidth(), chessTileset:getHeight())
   tileQuads[4] = gr.newQuad(3 * tileSizeX, 0, tileSizeX, tileSizeY, chessTileset:getWidth(), chessTileset:getHeight())
   tileQuads[5] = gr.newQuad(4 * tileSizeX, 0, tileSizeX, tileSizeY, chessTileset:getWidth(), chessTileset:getHeight())
   tileQuads[6] = gr.newQuad(5 * tileSizeX, 0, tileSizeX, tileSizeY, chessTileset:getWidth(), chessTileset:getHeight())

   tileQuads[7] = gr.newQuad(0 * tileSizeX, 97, tileSizeX, tileSizeY, chessTileset:getWidth(), chessTileset:getHeight())
   tileQuads[8] = gr.newQuad(1 * tileSizeX, 97, tileSizeX, tileSizeY, chessTileset:getWidth(), chessTileset:getHeight())
   tileQuads[9] = gr.newQuad(2 * tileSizeX, 97, tileSizeX, tileSizeY, chessTileset:getWidth(), chessTileset:getHeight())
   tileQuads[10] = gr.newQuad(3 * tileSizeX, 97, tileSizeX, tileSizeY, chessTileset:getWidth(), chessTileset:getHeight())
   tileQuads[11] = gr.newQuad(4 * tileSizeX, 97, tileSizeX, tileSizeY, chessTileset:getWidth(), chessTileset:getHeight())
   tileQuads[12] = gr.newQuad(5 * tileSizeX, 97, tileSizeX, tileSizeY, chessTileset:getWidth(), chessTileset:getHeight())

   spriteChesspieces = gr.newSpriteBatch(chessTileset, tileSizeX * tileSizeY, 'static')
end

function init_boardset()
   boardQuads[1] = gr.newQuad(0, 0, 
			      boardTileX, boardTileY, 
			      boardTileset:getWidth(), boardTileset:getHeight())
   boardQuads[2] = gr.newQuad(boardTileX - 1, 0, 
			      boardTileX, boardTileY, 
			      boardTileset:getWidth(), boardTileset:getHeight())

   spriteBoard = gr.newSpriteBatch(boardTileset, boardTileX * boardTileY, 'static')
end


function print_board_to_console()
   board = {}
   for y=1, 8 do
      board[y] = {}
      for x=1, 8 do
	 board[y][x] = ''
      end
   end

   for i=1, #white_pieces do
      local x = white_pieces[i].grid_x
      local y = white_pieces[i].grid_y
      board[y][x] = white_pieces[i]
   end
   
   for i=1, #black_pieces do
      local x = black_pieces[i].grid_x
      local y = black_pieces[i].grid_y
      board[y][x] = black_pieces[i]
   end

   bs = ''
   for y=1, 8 do
      for x=1, 8 do
	 if board[y][x] == '' then
	    io.write(' ', ' ')
	 else
	    local p = board[y][x]
	    io.write(tostring(p), ' ')
	 end
      end
      print('')
   end
end
