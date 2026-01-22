Map = Class{}

function Map:init()
   self.size = { x = 0, y = 0 }
   self.player_spawn = nil
   self.level_gate = {}
   self.tiles = {} -- 2D array of tiles
   self.tile_images = {} -- key = int_id, val = Image
   self.events = {}
end

function Map:load(filename)
   local map_lines = {}
   for line in fs.lines(filename) do
      table.insert(map_lines, line)
   end
   
   local parse_mode = "" -- "items", "events" or "map"
   local map_line_counter = 1 -- line counter (data after 'MAP' in file)
   
   print("###############################################")
   print("############## PARSING MAP FILE ###############")
   print("###############################################")
   print("file: " .. filename)
      
   for i=1, #map_lines do
      local line = map_lines[i]
      print(line)
      if line == "MAP_SIZE" then
	 parse_mode = "map_size"
      elseif line == "PLAYER_STARTING_LOCATION" then
	 parse_mode = "player"
      elseif line == "LEVEL_GATE_LOCATION" then
	 parse_mode = "gate"
      elseif line == "ITEMS_LIST" then
	 parse_mode = "items"
      elseif line == "EVENT_LIST" then
	 parse_mode = "events"
      elseif line == "MAP" then
	 parse_mode = "map"
	 map_line_counter = 1
      elseif parse_mode == "map_size" then
	 -- match digits
	 local line_digits = utils.match(line, "%d+")
	 local x = tonumber(line_digits[1])
	 local y = tonumber(line_digits[2])
	 self.size.x = x
	 self.size.y = y
	 print("--------<map size set!>")
	 -- generate "blank" tiles for entire map
	 self.tiles = {}
	 for y=1, self.size.y do
	    self.tiles[y] = {}
	    for x=1, self.size.x do
	       self.tiles[y][x] = Tile(x,y,0)
	    end
	 end
	 print("--------<map empty tiles generated!>")
      
      elseif parse_mode == "player" then
	 -- match digits & set player location
	 local line_digits = utils.match(line, "%d+")
	 local x = tonumber(line_digits[1])
	 local y = tonumber(line_digits[2])
	 player.grid_x = x
	 player.grid_y = y
	 print("--------<player position set>")

      elseif parse_mode == "gate" then
	 -- match digits & set goal
	 local line_digits = utils.match(line, "%d+")
	 local x = tonumber(line_digits[1])
	 local y = tonumber(line_digits[2])
	 table.insert(self.level_gate, Item(x, y, 1011))
	 print("--------<goal created!>")

      elseif parse_mode == "items" then
	 -- match digits
	 local line_digits = utils.match(line, "%d+")
	 local x = tonumber(line_digits[1])
	 local y = tonumber(line_digits[2])
	 local item_id = tonumber(line_digits[3])
	 local item = Item(x, y, item_id)
	 print("--------<created item: "..x..","..y..","..item_id..">")
	 table.insert(self.tiles[y][x].items, item)
	 print("--------<item added to maps tile.items!>")

      elseif parse_mode == "events" then
	 -- split on ';' (pattern = "one or more symbols that are not ';'")
	 local line_array = utils.match(line, "[^;]+")
	 local x = tonumber(line_array[1])
	 local y = tonumber(line_array[2])
	 
	 -- create map event & insert into self.events
	 local event = { x = y,
			 y = y,
			 text = line_array[3] }
	 table.insert(self.events, event)
	 
      elseif parse_mode == "map" then
	 -- loop string length & set tiles
	 for i=1, string.len(line) do
	    local i_char = string.char(string.byte(line, i))
	    if i_char == 'S' then
	       self.tiles[map_line_counter][i].type = 2
	    elseif i_char == '.' then
	       self.tiles[map_line_counter][i].type = 1
	    end
	    self.tiles[map_line_counter][i]:terraform()
	 end
	 -- increase the counter
	 map_line_counter = map_line_counter + 1
      end
   end
   print("###############################################")
   print("############## PARSING COMPLETE ###############")
   print("###############################################")
end

function Map:draw()
   for y=1, self.size.y do
      for x=1, self.size.x do
	 self.tiles[y][x]:draw()
      end
   end
end

function Map:update(dt)
   -- actual location draw! (smooth motion map move!) 
   -- camera viewport stuff...
end

function Map:clear_tiles()
   if not player.remember then
      for y=1, self.size.y do
	 for x=1, self.size.x do
	    self.tiles[y][x].visible = false
	 end
      end
   end
   if player.always_looking > 0 then
      player:calculate_vision()
   end
end