--[[
   Tile class, map_load() will generate tiles for map
]]
-- superclass requires
require "gridlocked"
require "visible"

Tile = Class{ __includes = { Gridlocked, Visible } }

function Tile:init(loc_x, loc_y, t)
   Movable.init(self, loc_x, loc_y)
   Visible.init(self)
   self.type = t
   self.objects = {}
   self.items = {}
end

function Tile:is_static()
   if not self.static then
      return self
   end
   for i=1, #self.objects do
      if not self.objects[i].static then
	 return self.objects[i], i
      end
   end
   return nil
end

function Tile:is_massive()
   if self.massive then
      return self
   end
   for i=1, #self.objects do
      if self.objects[i].massive then
	 return self, i
      end
   end
   return nil
end

function Tile:update(dt)
   -- for i, v in ipairs(self.objects) do
   for i=1, #self.objects do
      local v = self.objects[i]
      v.actual_y = 
	 v.actual_y - ((v.actual_y - (v.grid_y * GRID_SIZE + MAP_OFFSET_Y))
			  * SMOOTH_MOTION_SPEED * dt)
      v.actual_x = 
	 v.actual_x - ((v.actual_x - (v.grid_x * GRID_SIZE + MAP_OFFSET_X))
			  * SMOOTH_MOTION_SPEED * dt)
   end

   if self:is_massive() or self.type == 5 then -- time to kill the player
      if self.grid_x == player.grid_x 
      and self.grid_y == player.grid_y then
	 player:kill()
      end
   end
end

function Tile:remove_object(index)
   table.remove(self.objects, index)
end

function Tile:insert_object(object)
   if self.type == 5 then
      return
   end
   table.insert(self.objects, object)
end

function Tile:set_objects_visibilty(v)
   for i=1, #self.objects do
      self.objects[i].visible = v
   end
end

function Tile:set_items_visibilty(v)
   for i=1, #self.objects do
      self.items[i].visible = v
   end
end

function Tile:draw( draw_x, draw_y )
   if self.visible then
      if player.draw_mode == "reality" then
	 gr.rectangle("fill", 
		      self.grid_x * GRID_SIZE + MAP_OFFSET_X, 
		      self.grid_y * GRID_SIZE + MAP_OFFSET_Y,
		      GRID_SIZE, GRID_SIZE)
	 gr.setColor(0, 0, 0)
	 gr.rectangle("line", 
		      self.grid_x * GRID_SIZE + MAP_OFFSET_X, 
		      self.grid_y * GRID_SIZE + MAP_OFFSET_Y,
		      GRID_SIZE, GRID_SIZE)
      elseif player.draw_mode == "wireframe" then
	 gr.rectangle("line", 
		      self.grid_x * GRID_SIZE + MAP_OFFSET_X,
		      self.grid_y * GRID_SIZE + MAP_OFFSET_Y,
		      GRID_SIZE, GRID_SIZE)   
      elseif player.draw_mode == "matrix" then
	 gr.setColor(0x26, 0x6A, 0x2E)
	 gr.print(self.type, 
		  self.grid_x * GRID_SIZE + MAP_OFFSET_X,
		  self.grid_y * GRID_SIZE + MAP_OFFSET_Y)
      elseif player.draw_mode == "angel dust" then
	 gr.print(":", 
		  self.grid_x * GRID_SIZE + MAP_OFFSET_X, 
		  self.grid_y * GRID_SIZE + MAP_OFFSET_Y
	 )
      elseif player.draw_mode == "textured" then
	 gr.setColor( 255,255,255 )
	 gr.draw( map.tile_images[self.type], draw_x, draw_y )
      end
      
      -- draw items on tile (if they are visible)
      for i=1, #self.items do
	 self.items[i]:draw( draw_x, draw_y )
      end
   end
end

function Tile:conical_vision(dir, range)
   if player.vision_type == "xray" then
      -- set current tile to visible
      self.visible = true
      
      if range > 0 and 
	 self.grid_y > 1 and self.grid_y < #map.tiles and
	 self.grid_x > 1 and self.grid_x < #map.tiles[1]
      then
	 if dir == 'N' then
	    map.tiles[self.grid_y -1][self.grid_x]:conical_vision(dir, (range - 1))
	    map.tiles[self.grid_y -1][self.grid_x +1]:conical_vision(dir, (range - 1))
	    map.tiles[self.grid_y -1][self.grid_x -1]:conical_vision(dir, (range - 1))
	 elseif dir == 'E' then
	    map.tiles[self.grid_y][self.grid_x +1]:conical_vision(dir, (range - 1))
	    map.tiles[self.grid_y +1][self.grid_x +1]:conical_vision(dir, (range - 1))
	    map.tiles[self.grid_y -1][self.grid_x +1]:conical_vision(dir, (range - 1))
	 elseif dir == 'S' then
	    map.tiles[self.grid_y +1][self.grid_x]:conical_vision(dir, (range - 1))
	    map.tiles[self.grid_y +1][self.grid_x +1]:conical_vision(dir, (range - 1))
	    map.tiles[self.grid_y +1][self.grid_x -1]:conical_vision(dir, (range - 1))
	 elseif dir == 'W' then
	    map.tiles[self.grid_y][self.grid_x -1]:conical_vision(dir, (range - 1))
	    map.tiles[self.grid_y +1][self.grid_x -1]:conical_vision(dir, (range - 1))
	    map.tiles[self.grid_y -1][self.grid_x -1]:conical_vision(dir, (range - 1))
	 end
      end
   elseif player.vision_type == "crude" then
      -- set current tile to visible
      self.visible = true
      
      if range > 0 and 
	 self.grid_y > 1 and self.grid_y < #map.tiles and
	 self.grid_x > 1 and self.grid_x < #map.tiles[1] and
	 not self.obstructs_vision and not self:object_obstructs_vision()
      then
	 if dir == 'N' then
	    if self.grid_x == player.grid_x then
	       map.tiles[self.grid_y -1][self.grid_x]:conical_vision(dir, (range - 1))
	       if range == player.vision_range then
		  if not (map.tiles[self.grid_y][self.grid_x -1].obstructs_vision 
			     and map.tiles[self.grid_y -1][self.grid_x].obstructs_vision)
		  then
		     map.tiles[self.grid_y -1][self.grid_x -1]:conical_vision(dir, (range - 1))
		  end
		  if not (map.tiles[self.grid_y][self.grid_x +1].obstructs_vision
			     and map.tiles[self.grid_y -1][self.grid_x].obstructs_vision)
		  then
		     map.tiles[self.grid_y -1][self.grid_x +1]:conical_vision(dir, (range - 1))
		  end
	       end
	    elseif self.grid_x < player.grid_x then
	       map.tiles[self.grid_y -1][self.grid_x]:conical_vision(dir, (range - 1))
	       if not (map.tiles[self.grid_y][self.grid_x -1].obstructs_vision 
			  and map.tiles[self.grid_y -1][self.grid_x].obstructs_vision)
	       then
		  map.tiles[self.grid_y -1][self.grid_x -1]:conical_vision(dir, (range - 1))
	       end
	    elseif self.grid_x > player.grid_x then
	       map.tiles[self.grid_y -1][self.grid_x]:conical_vision(dir, (range - 1))
	       if not (map.tiles[self.grid_y][self.grid_x +1].obstructs_vision 
			  and map.tiles[self.grid_y -1][self.grid_x].obstructs_vision)
	       then
		  map.tiles[self.grid_y -1][self.grid_x +1]:conical_vision(dir, (range - 1))
	       end
	    end
	 elseif dir == 'E' then
	    if self.grid_y == player.grid_y then
	       map.tiles[self.grid_y][self.grid_x +1]:conical_vision(dir, (range - 1))
	       if range == player.vision_range then
		  if not (map.tiles[self.grid_y -1][self.grid_x].obstructs_vision 
			     and map.tiles[self.grid_y][self.grid_x+1].obstructs_vision)
		  then
		     map.tiles[self.grid_y -1][self.grid_x +1]:conical_vision(dir, (range - 1))
		  end
		  if not (map.tiles[self.grid_y +1][self.grid_x].obstructs_vision
			     and map.tiles[self.grid_y][self.grid_x+1].obstructs_vision)
		  then
		     map.tiles[self.grid_y +1][self.grid_x +1]:conical_vision(dir, (range - 1))
		  end
	       end
	    elseif self.grid_y < player.grid_y then
	       map.tiles[self.grid_y][self.grid_x +1]:conical_vision(dir, (range - 1))
	       if not (map.tiles[self.grid_y -1][self.grid_x].obstructs_vision
			  and map.tiles[self.grid_y][self.grid_x+1].obstructs_vision)
	       then
		  map.tiles[self.grid_y -1][self.grid_x +1]:conical_vision(dir, (range - 1))
	       end
	    elseif self.grid_y > player.grid_y then
	       map.tiles[self.grid_y][self.grid_x +1]:conical_vision(dir, (range - 1))
	       if not (map.tiles[self.grid_y +1][self.grid_x].obstructs_vision
			  and map.tiles[self.grid_y][self.grid_x+1].obstructs_vision)
	       then
		  map.tiles[self.grid_y +1][self.grid_x +1]:conical_vision(dir, (range - 1))
	       end
	    end
	 elseif dir == 'S' then
	    if self.grid_x == player.grid_x then
	       map.tiles[self.grid_y +1][self.grid_x]:conical_vision(dir, (range - 1))
	       if range == player.vision_range then
		  if not (map.tiles[self.grid_y][self.grid_x -1].obstructs_vision 
			     and map.tiles[self.grid_y +1][self.grid_x].obstructs_vision)
		  then
		     map.tiles[self.grid_y +1][self.grid_x -1]:conical_vision(dir, (range - 1))
		  end
		  if not (map.tiles[self.grid_y][self.grid_x +1].obstructs_vision
			     and map.tiles[self.grid_y +1][self.grid_x].obstructs_vision)
		  then
		     map.tiles[self.grid_y +1][self.grid_x +1]:conical_vision(dir, (range - 1))
		  end
	       end
	    elseif self.grid_x < player.grid_x then
	       map.tiles[self.grid_y +1][self.grid_x]:conical_vision(dir, (range - 1))
	       if not (map.tiles[self.grid_y][self.grid_x -1].obstructs_vision
			  and map.tiles[self.grid_y +1][self.grid_x].obstructs_vision)
	       then
		  map.tiles[self.grid_y +1][self.grid_x -1]:conical_vision(dir, (range - 1))
	       end
	    elseif self.grid_x > player.grid_x then
	       map.tiles[self.grid_y +1][self.grid_x]:conical_vision(dir, (range - 1))
	       if not (map.tiles[self.grid_y][self.grid_x +1].obstructs_vision
			  and map.tiles[self.grid_y +1][self.grid_x].obstructs_vision)
	       then
		  map.tiles[self.grid_y +1][self.grid_x +1]:conical_vision(dir, (range - 1))
	       end
	    end
	 elseif dir == 'W' then
	    if self.grid_y == player.grid_y then
	       map.tiles[self.grid_y][self.grid_x -1]:conical_vision(dir, (range - 1))
	       if range == player.vision_range then
		  if not (map.tiles[self.grid_y -1][self.grid_x].obstructs_vision
			     and map.tiles[self.grid_y][self.grid_x -1].obstructs_vision)
		  then
		     map.tiles[self.grid_y -1][self.grid_x -1]:conical_vision(dir, (range - 1))
		  end
		  if not (map.tiles[self.grid_y +1][self.grid_x].obstructs_vision
			     and map.tiles[self.grid_y][self.grid_x -1].obstructs_vision)
		  then
		     map.tiles[self.grid_y +1][self.grid_x -1]:conical_vision(dir, (range - 1))
		  end
	       end
	    elseif self.grid_y < player.grid_y then
	       map.tiles[self.grid_y][self.grid_x -1]:conical_vision(dir, (range - 1))
	       if not (map.tiles[self.grid_y -1][self.grid_x].obstructs_vision
			  and map.tiles[self.grid_y][self.grid_x -1].obstructs_vision)
	       then
		  map.tiles[self.grid_y -1][self.grid_x -1]:conical_vision(dir, (range - 1))
	       end
	    elseif self.grid_y > player.grid_y then
	       map.tiles[self.grid_y][self.grid_x -1]:conical_vision(dir, (range - 1))
	       if not (map.tiles[self.grid_y +1][self.grid_x].obstructs_vision
			  and map.tiles[self.grid_y][self.grid_x -1].obstructs_vision)
	       then
		  map.tiles[self.grid_y +1][self.grid_x -1]:conical_vision(dir, (range - 1))
	       end
	    end
	 end
      end
   end
end

function Tile:get_center_point() 
   return self.grid_x + 0.5, self.grid_y + 0.5
end

function Tile:object_obstructs_vision()
   for i=1,#self.objects do
      if self.objects[i].obstructs_vision == true then
	 return true
      end
   end
   return false
end

function Tile:check_correct_box_locations()
   for i=1, #self.objects do
      if self.objects[i].type == 2 and self.type == 3 then
	 player.correct_box = player.correct_box + 1
      end
   end
end

function Tile:add_goal_if_not_exists()
   for i=1, #self.objects do
      if self.objects[i].type == 1011 then return end
   end
   table.insert(self.objects, 1, goal)
end

function Tile:remove_goal_if_exists()
   for i=1, #self.objects do
      if self.objects[i].type == 1011 then
	 table.remove(self.objects, i)
	 return
      end
   end
end

function Tile:is_goal()
   for i=1, #self.objects do
      if self.objects[i].type == 1011 then
	 return true
      end
   end
   return false
end

-- loads image from type, sets type properties etc...
function Tile:terraform()
   -- common tile type definitions
   self.obstructs_vision = true -- can't see through
   self.massive = true -- can't walk on

   -- 0 void (never visible & thus never drawn?)
   
   -- 1 grass
   if self.type == 1 then
      self.massive = false
      self.obstructs_vision = false
   end

   -- 2 rock
   if self.type == 2 then
      --
   end
   
   -- 3 lava
   if self.type == 3 then
      self.massive = false
      self.obstructs_vision = false
   end

end