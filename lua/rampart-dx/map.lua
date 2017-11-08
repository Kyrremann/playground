function load_map(map_string)
-- declare map table and counters
   local map, gx, gy = {}
   local owners = 1

   -- for each level
   for gz in ipairs(map_string) do
      -- reinit counter, fill map table
      gy = 1
      -- for each line (exclude tab and return)
      for this_line in map_string[1]:gmatch("[^\t\n]+") do
	 -- reinit counter, fill map table
	 gx = 1 ; map[gy] = {}
	 -- for each character
	 for this_char in this_line:gmatch(".") do
	    -- converse from char to number
	    square = {
	       x = gx,
	       y = gy,
	       type = map_converse(this_char),
	       owner = "",
	       safe = false
	    }

	    if is_tower(square.type) then
	       square.owner = "p" .. owners
	       owners = owners + 1
	    end
	    
	    map[gy][gx] = square
	    -- go to next colomn
	    gx = gx + 1
	 end
	 -- go to next row
	 gy = gy + 1
      end
   end
   return map
end

function map_converse(char)
   return
      char == "g" and "grass" or
      char == "w" and "water" or
      char == "t" and "tower" or
      "unknown"
end

function draw_map()
   for y, vy in ipairs(map) do
      for x, vx in ipairs(vy) do
	 local square = vx;
	 if is_grass(square.type) then
	    gr.setColor(0, 255, 0)
	 elseif is_water(square.type) then
	    gr.setColor(0, 0, 255)
	 elseif is_tower(square.type) then
	    gr.setColor(100, 100, 100)
	 elseif is_wall(square.type) then
	    gr.setColor(60, 60, 60)
	 elseif is_cannon(square.type) then
	    gr.setColor(200, 200, 0)
	 end
	 
	 gr.rectangle("fill", (x - 1) * SIZE, (y - 1) * SIZE, SIZE, SIZE)
	 gr.setColor(0, 0, 0)
	 gr.rectangle("line", (x - 1) * SIZE, (y - 1) * SIZE, SIZE, SIZE)

	 if is_grass(square.type) then
	    draw_player_areas(square)
	 end
	 
	 if is_cannon(square.type) then -- need to be drawn last
	    draw_cannons(square)
	 end
      end
   end
end

function draw_player_areas(square)
   for index, player in ipairs(PLAYERS) do
      if square.owner == player.name then
	 gr.setColor(player.color[1], player.color[2], player.color[3], 100)
	 gr.rectangle("fill", 
		      (square.x - 1) * SIZE, (square.y - 1) * SIZE, 
		      SIZE, SIZE)
      end
   end
end

function draw_cannons(square)
   local startX = ((square.x - 1) * SIZE) + SIZE / 2
   local startY = ((square.y - 1) * SIZE) + SIZE / 2
   local angle = math.atan2(
      startY - mo.getY(),
      startX - mo.getX())
   
   gr.setColor(140, 140, 140)
   gr.push()
   gr.translate(startX, startY)
   gr.rotate(angle)
   gr.rectangle("fill",
		0, -SIZE / 8,
		   -SIZE / 2, SIZE / 4)
   gr.pop()
end

function is_grass(type)
   return type == "grass"
end

function is_water(type)
   return type == "water"
end

function is_tower(type)
   return type == "tower"
end

function is_wall(type)
   return type == "wall"
end

function is_cannon(type)
   return type == "cannon"
end

function init_towers()
   for y, vy in ipairs(map) do
      for x, tower in ipairs(vy) do
	 if is_tower(tower.type) then
	    initWall(tower, -2, -2)
	    initWall(tower, -1, -2)
	    initWall(tower, 0, -2)
	    initWall(tower, 1, -2)
	    initWall(tower, 2, -2)

	    initWall(tower, -2, -1)
	    initWall(tower, 2, -1)

	    initWall(tower, -2, 0)
	    initWall(tower, 2, 0)

	    initWall(tower, -2, 1)
	    initWall(tower, 2, 1)

	    initWall(tower, -2, 2)
	    initWall(tower, -1, 2)
	    initWall(tower, 0, 2)
	    initWall(tower, 1, 2)
	    initWall(tower, 2, 2)
	 end
      end
   end
end

function initWall(tower, x, y)
   x = tower.x + x
   y = tower.y + y
   map[y][x].type = "wall"
   map[y][x].owner = tower.owner
end

function paint_players_areas()
   reset_map_owners()
   for y in ipairs(map) do
      for x in ipairs(map[y]) do
	 if is_tower(map[y][x].type) then
	    local tower = map[y][x]
	    if is_tower_safe(tower) then
	       tower.safe = true
	    end
	 end
      end
   end
end

function is_tower_safe(tower)
   local checklist = {}
   local completelist = {}

   table.insert(checklist, tower)
   --table.insert(completelist, tower)

   while #checklist ~= 0 do
      pos = checklist[1]

      if we_are_going_out_of_bounce(pos) then
	 return false
      end
      
      insert_if_not_clear(map[pos.y + 1][pos.x - 1],
			  completelist, checklist)
      insert_if_not_clear(map[pos.y + 1][pos.x],
			  completelist, checklist)
      insert_if_not_clear(map[pos.y + 1][pos.x + 1], 
			  completelist, checklist)
      
      insert_if_not_clear(map[pos.y][pos.x + 1], 
			  completelist, checklist)
      insert_if_not_clear(map[pos.y][pos.x + 1], 
			  completelist, checklist)

      insert_if_not_clear(map[pos.y - 1][pos.x - 1], 
			  completelist, checklist)
      insert_if_not_clear(map[pos.y - 1][pos.x], 
			  completelist, checklist)
      insert_if_not_clear(map[pos.y - 1][pos.x + 1], 
			  completelist, checklist)

      remove_from_list(checklist, pos)
      table.insert(completelist, pos)
   end

   for index in ipairs(completelist) do
      local item = completelist[index]
      item.owner = tower.owner
   end
   
   return true
end

function insert_if_not_clear(item, completelist, checklist)
   if not is_wall_or_in_completelist(item, completelist) then
      table.insert(checklist, item)
   end
end

function is_wall_or_in_completelist(item, completelist)
   return is_wall(item.type) or
      is_tower(item.type) or
      is_in_list(completelist, item)
end

function is_in_list(list, item)
   for index in ipairs(list) do
      local x = list[index]
      if item.x == x.x and item.y == x.y then
	 return true
      end
   end
   
   return false
end

function remove_from_list(list, item)
   for index in ipairs(list) do
      local x = list[index]
      if item.x == x.x and item.y == x.y then
	 table.remove(list, index)
      end
   end
end

function we_are_going_out_of_bounce(item)
   return 
      item.x - 1 < 1 or
      item.y - 1 < 1 or
      item.x + 1 > 32 or
      item.y + 1 > 24
end

function reset_map_owners()
   for y in ipairs(map) do
      for x in ipairs(map[y]) do
	 local item = map[y][x]
	 
	 if is_grass(item.type) then
	    item.owner = ""
	    item.safe = false
	 end
      end
   end
end

function towers_are_safe()
   for y in ipairs(map) do
      for x in ipairs(map[y]) do
	 local tower = map[y][x]

	 if is_tower(tower.type) 
	    and not tower.safe 
	    and tower.owner == "p1"
	 then
	    return false
	 end
      end
   end
   
   return true
end
