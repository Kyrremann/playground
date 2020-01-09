local Levels = {}

function Levels:setup(size)
   self.size = size
end

function Levels:newLevel(randomAnimal)
   local level = self:cleanLevel()
   for x=1,self.size do
      for y=1,self.size do
	 -- there are 30 different animals
	 level[x][y] = randomAnimal()
      end
   end

   return level
end

function Levels:cleanLevel()
   return {{}, {}, {}, {}}
end


return Levels
