local matcher = {}

function matcher.checkForMatchingTiles(level)
   local matching = {}
   for x,row in pairs(level) do
      for y,tile in pairs(row) do
	 local xTiles = matcher.checkColumn(level, x, y, tile)
	 if #xTiles >= 3 then
	    for k,v in pairs(xTiles) do matching[k] = v end
	 end
	 
	 local yTiles = matcher.checkRow(level, x, y, tile)
	 if #yTiles >= 3 then
	    for k,v in pairs(yTiles) do matching[k] = v end
	 end
      end
   end

   return matching
end

function matcher.checkColumn(level, x, y, master)
   local matches = {}
   for i=x,#level do
      if level[i][y] == master then
	 table.insert(matches, {x=i,y=y, tile=master})
      else
	 return matches
      end
   end

   return matches
end

function matcher.checkRow(level, x, y, master)
   local matches = {}
   for i=y,#level do
      if level[x][i] == master then
	 table.insert(matches, {x=x,y=i, tile=master})
      else
	 return matches
      end
   end

   return matches
end

return matcher
