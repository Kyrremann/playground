game = {
   selected = {x = -1, y = -1},
   tileSize = 128,
   keymap = {q={1,1},w={2,1},e={3,1},r={4,1},
	     a={1,2},s={2,2},d={3,2},f={4,2},
	     y={1,3},u={2,3},i={3,3},o={4,3},
	     h={1,4},j={2,4},k={3,4},l={4,4}},
}

fonts = {}
score = require('score')
levels = require('levels')
matcher = require('matcher')

function love.load()
   love.window.setMode(1440, 900, {fullscreen=true})

   fonts.new('Kenney Thick.ttf', 'thick', 24)
   levels:setup(4)

   animalsImage = love.graphics.newImage('square_nodetails.png')
   animals = {
      batch = love.graphics.newSpriteBatch(animalsImage, 30),
      quads = {}
   }
   local sw = animalsImage:getWidth()
   local sh = animalsImage:getHeight()
   local tileSize = game.tileSize
   for i=1,5 do
      animals.quads[i] = love.graphics.newQuad(1 + (tileSize * (i - 1)), 0, tileSize, tileSize, sw, sh)
      animals.quads[i + 5] = love.graphics.newQuad(1 + (tileSize * (i - 1)), tileSize * 1, tileSize, tileSize, sw, sh)
      animals.quads[i + 10] = love.graphics.newQuad(1 + (tileSize * (i - 1)), tileSize * 2, tileSize, tileSize, sw, sh)
      animals.quads[i + 15] = love.graphics.newQuad(1 + (tileSize * (i - 1)), tileSize * 3, tileSize, tileSize, sw, sh)
      animals.quads[i + 20] = love.graphics.newQuad(1 + (tileSize * (i - 1)), tileSize * 4, tileSize, tileSize, sw, sh)
      animals.quads[i + 25] = love.graphics.newQuad(1 + (tileSize * (i - 1)), tileSize * 5, tileSize, tileSize, sw, sh)
   end

   game.level = levels:newLevel(game.randomAnimal)
   score:setup(fonts.thick[24], tileSize * 4 + tileSize/2, tileSize - fonts.thick[24]:getWidth("a"))
end

function love.update(dt)
   matches = matcher:checkForMatchingTiles(game.level)
   if #matches > 0 then
      switchTiles(matches)
      score:awardPoints(#matches)
   end
end

function switchTiles(tiles)
   for i,t in ipairs(tiles) do
      game.level[t.x][t.y] = game.randomAnimal(t.tile)
   end
end

function love.draw()
   local level = game.level
   local selected = game.selected
   for tx,row in pairs(level) do
      for ty,tile in pairs(row) do
	 local x, y = game.tileCoordinates(tx, ty)
	 if selected.x == tx and selected.y == ty then
	    love.graphics.setColor(0, 1, 0)
	    love.graphics.draw(animals.batch:getTexture(), animals.quads[tile], x, y)
	 else
	    love.graphics.setColor(1, 1, 1)
	    love.graphics.draw(animals.batch:getTexture(), animals.quads[tile], x, y)
	 end
      end
   end

   score:draw()
end


function love.keyreleased(key)
   if key == 'escape' then
      love.event.quit()
   end

   if game.keymap[key] ~= nil then
      local x, y = unpack(game.keymap[key])
      if x and y then
	 game.select(x, y)
      end
   end
end

function love.mousepressed(x, y)
   local x = math.ceil(x / game.tileSize)
   local y = math.ceil(y / game.tileSize)
   game.select(x, y)
end

function game.randomAnimal(tile)
   local t = math.random(1, 5)
   while t == tile do
      t = math.random(1, 5)
   end

   return t
end

function game.select(x, y)
   local selected = game.selected
   if selected.x == -1 or selected.y == -1 then
      selected.x = x
      selected.y = y
   else
      local level = game.level
      local tmpTile = level[x][y]
      level[x][y] = level[selected.x][selected.y]
      level[selected.x][selected.y] = tmpTile

      selected.x = -1
      selected.y = -1
   end
end

function game.tileCoordinates(x, y)
   return (x - 1) * game.tileSize, (y - 1) * game.tileSize
end

function fonts.new(file, name, size)
   if not fonts[name] then
      fonts[name] = {}
   end
   fonts[name][size] = love.graphics.newFont(file, size)
end

function printBoard()
   print("")
   local p = ""
   for i=1,#game.level do p = p .. game.level[i][1] end
   print(p)
   p = ""
   for i=1,#game.level do p = p .. game.level[i][2] end
   print(p)
   p = ""
   for i=1,#game.level do p = p .. game.level[i][3] end
   print(p)
   p = ""
   for i=1,#game.level do p = p .. game.level[i][4] end
   print(p)
end
