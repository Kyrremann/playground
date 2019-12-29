function love.load()
   love.window.setMode(1440, 900, {fullscreen=true})

   animalsImage = love.graphics.newImage('square_nodetails.png')
   animals = {
      batch = love.graphics.newSpriteBatch(animalsImage, 30),
      quads = {}
   }
   local sw = animalsImage:getWidth()
   local sh = animalsImage:getHeight()
   for i=1,5 do
      animals.quads[i] = love.graphics.newQuad(1 + (128 * (i - 1)), 0, 128, 128, sw, sh)
      animals.quads[i + 5] = love.graphics.newQuad(1 + (128 * (i - 1)), 128 * 1, 128, 128, sw, sh)
      animals.quads[i + 10] = love.graphics.newQuad(1 + (128 * (i - 1)), 128 * 2, 128, 128, sw, sh)
      animals.quads[i + 15] = love.graphics.newQuad(1 + (128 * (i - 1)), 128 * 3, 128, 128, sw, sh)
      animals.quads[i + 20] = love.graphics.newQuad(1 + (128 * (i - 1)), 128 * 4, 128, 128, sw, sh)
      animals.quads[i + 25] = love.graphics.newQuad(1 + (128 * (i - 1)), 128 * 5, 128, 128, sw, sh)
   end

   game = {
      clean_level = function() return {{}, {}, {}, {}, {}, {}, {}, {}, {}} end,
      clicked = {x = -1, y = -1},
      tileSize = 128
   }

   game.tileCoordinates = function(x, y)
      return (x - 1) * game.tileSize, (y - 1) * game.tileSize
   end

   game.level = game.clean_level()
   for x=1,9 do
      for y=1,7 do
	 game.level[x][y] = math.random(1, 30)
      end
   end
end

function love.update(dt)
   checkForMatchingTiles()
end

function checkForMatchingTiles()
   local level = game.level
   for x,row in pairs(level) do
      for y,tile in pairs(row) do
	 findMatching(checkColumn(x, y, tile), x, y, tile)
	 findMatching(checkRow(x, y, tile), x, y, tile)
      end
   end
end

function findMatching(matches, x, y, tile)
   if matches >= 3 then
      local matching = game.clean_level()
      findAdjacents(matching, x, y, tile)
      switchTiles(matching)
      checkForMatchingTiles()
   end
end

function switchTiles(tiles)
   for x,row in pairs(tiles) do
      for y,tile in pairs(row) do
	 game.level[x][y] = math.random(1, 30)
      end
   end
end

function findAdjacents(matching, x, y, tile)
   if x < 1 or y < 1 then return end
   if x > #game.level or y > #game.level[x] then return end
   if matching[x][y] then return end

   if game.level[x][y] == tile then
      matching[x][y] = tile
      findAdjacents(matching, x, y + 1, tile)
      findAdjacents(matching, x, y - 1, tile)
      findAdjacents(matching, x + 1, y, tile)
      findAdjacents(matching, x - 1, y, tile)
   end
end

function checkRow(x, y, master)
   if x > #game.level then return 0 end
   tile = game.level[x][y]
   if tile == master then
      return 1 + checkRow(x + 1, y, master)
   end

   return 0
end

function checkColumn(x, y, master)
   if y > #game.level[x] then return 0 end

   tile = game.level[x][y]
   if tile == master then
      return 1 + checkColumn(x, y + 1, master)
   end

   return 0
end

function love.draw()
   local level = game.level
   local clicked = game.clicked
   for tx,row in pairs(level) do
      for ty,tile in pairs(row) do
	 local x, y = game.tileCoordinates(tx, ty)
	 if clicked.x == tx and clicked.y == ty then
	    love.graphics.setColor(0, 1, 0)
	    love.graphics.draw(animals.batch:getTexture(), animals.quads[tile], x, y)
	 else
	    love.graphics.setColor(1, 1, 1)
	    love.graphics.draw(animals.batch:getTexture(), animals.quads[tile], x, y)
	 end
      end
   end
end

function love.mousepressed(x, y)
   local clicked = game.clicked
   if clicked.x == -1 or clicked.y == -1 then
      clicked.x = math.ceil(x / 128)
      clicked.y = math.ceil(y / 128)
   else
      local x = math.ceil(x / 128)
      local y = math.ceil(y / 128)

      local level = game.level
      local tmpTile = level[x][y]
      level[x][y] = level[clicked.x][clicked.y]
      level[clicked.x][clicked.y] = tmpTile

      clicked.x = -1
      clicked.y = -1
   end
end
