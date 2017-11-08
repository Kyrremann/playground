function drawWall(player)
   local main_shape = SHAPES[player.build.wall][player.build.rotation]
   local x = player.mouse.x
   local y = player.mouse.y
   gr.setColor(60, 60, 60)
   for index, shape in ipairs(main_shape) do
      local cX = x + shape.x - 1
      local cY = y + shape.y - 1
      gr.rectangle("fill", 
		   cX * SIZE, cY * SIZE,
		   SIZE, SIZE)
   end
end

function isLegalWallSquare(player)
   local main_shape = SHAPES[player.build.wall][player.build.rotation]
   for index, shape in ipairs(main_shape) do
      local cX = player.mouse.x + shape.x
      local cY = player.mouse.y + shape.y
   
      if not (cX > 0 and
		 cX < 33 and
		 cY > 0 and
		 cY < 25 and
	      is_grass(map[cY][cX].type)) then
	 return false
      end
   end
   
   return true
end

function placeWall(player)
   local main_shape = SHAPES[player.build.wall][player.build.rotation]
   for index, shape in ipairs(main_shape) do
      local cX = player.mouse.x + shape.x
      local cY = player.mouse.y + shape.y
   
      map[cY][cX].type = shape.type
   end
end

-- CANNON TIME
function drawCannon(player)
   local x = player.mouse.x - 1
   local y = player.mouse.y - 1
   gr.setColor(200, 200, 0)
   gr.rectangle("fill", 
		x * SIZE, y * SIZE, 
		SIZE, SIZE)
end

function isLegalCannonSquare(player)
   local square = map[player.mouse.y][player.mouse.x]
   
   return is_grass(square.type)
      and square.owner == player.name
end

function placeCannon(player)   
   local y = player.mouse.y
   local x = player.mouse.x
   map[y][x].type = "cannon"
   player:addCannon(Cannon(x, y, player.name))
end
