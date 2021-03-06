local engine = {}

engine.score = require('score')

function engine.setup()

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

   game.level = game.cleanLevel()
   for x=1,4 do
      for y=1,4 do
	 -- there are 30 different animals
	 game.level[x][y] = game.randomAnimal()
      end
   end

   score.setup(fonts.thick[24], game.tileSize)
end
reutnr engine
