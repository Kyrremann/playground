local levels = {}

function levels.setup(size)
   levels.size = size
end

function levels.newLevel(randomAnimal)
   local level = levels.cleanLevel()
   for x=1,levels.size do
      for y=1,levels.size do
	 -- there are 30 different animals
	 level[x][y] = randomAnimal()
      end
   end

   return level
end

function levels.cleanLevel()
   return {{}, {}, {}, {}}
end


return levels
