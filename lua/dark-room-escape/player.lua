-- superclass requires
require "movable"

Player = Class{ __includes = Movable }

function Player:init(loc_x, loc_y)
   Movable.init(self, loc_x, loc_y)
   
   -- variables
   self.dir = 'N'
   
   -- draw
   self.draw_mode = "textured"
   
   -- vision
   self.vision_range = 3
   self.always_looking = 0
   self.omnilook = false
   self.vision_type = "crude" -- xray, crude, normal
   
   -- magnet
   self.magnet_on = false
   self.magnet_particles = {}
   
   -- animation
   self.image_walking = gr.newImage("characters/player_composite.png")
   self.anim_walking = newAnimation(self.image_walking, GRID_SIZE, GRID_SIZE, 0.5, 0)
   
   -- arrow keys default
   self.north_arrow = false
   self.east_arrow = false
   self.south_arrow = false
   self.west_arrow = false

   -- inventory
   self.inventory = Inventory(1)

   self.player_state_action = {
      default = function ()
      end,
      jump = function () -- jump
	 if music_jump:isStopped() then
	    music_jump:play()
	 end

	 local x = self.actual_x - self.jump_height
	 local y = self.actual_y - self.jump_height

	 if player.draw_mode == "reality" then
	    gr.rectangle("fill",
			 x,
			 y,
			 self.size_x * GRID_SIZE + self.jump_height * 2,
			 self.size_y * GRID_SIZE + self.jump_height * 2)
	    gr.setColor(0, 0, 0)
	    gr.rectangle("line",
			 x,
			 y,
			 player.size_x * GRID_SIZE + self.jump_height * 2,
			 player.size_y * GRID_SIZE + self.jump_height * 2)
	 elseif player.draw_mode == "wireframe" then
	    gr.rectangle("line",
			 x,
			 y,
			 player.size_x * GRID_SIZE + self.jump_height * 2,
			 player.size_y * GRID_SIZE + self.jump_height * 2) 
	 elseif player.draw_mode == "matrix" then
	    gr.setColor(0x26, 0xAA, 0x2E)
	    gr.print("P",
		     x,
		     y) 
	 elseif player.draw_mode == "angel dust" then
	    gr.print("P",
		     x,
		     y)
	 elseif player.draw_mode == "textured" then
	    if self.dir == 'S' then
	       self.anim_walking:draw(self.actual_x, self.actual_y,0,1,1,
				0, 0)
	    elseif self.dir == 'W' then
	       self.anim_walking:draw(self.actual_x, self.actual_y, 
				      math.rad(90), 1, 1, 0, GRID_SIZE)
	    elseif self.dir == 'N' then
	       self.anim_walking:draw(self.actual_x, self.actual_y,
				      math.rad(180), 1, 1, GRID_SIZE, GRID_SIZE)
	    elseif self.dir == 'E' then
	       self.anim_walking:draw(self.actual_x, self.actual_y,
				      math.rad(270), 1, 1, GRID_SIZE, 0)
	    end
	 end

	 self.jump_height = self.jump_height + self.jump_speed
	 if self.jump_height > 7.6 then
	    self.jump_speed = -self.jump_speed
	 elseif self.jump_height < 1 then
	    self.state = "default"
	    self.jump_speed = self.jump_speed * -1
	    music_jump:stop()
	 end
      end,
      disappear = function() -- disappear
	 
      end,
      ["endless falling"] = function() end,
      duck = function() 
	 -- TODO
      end
   }
end

function Player:leap()
   player:set_state("jump")
   if self.dir == 'N' then
      self:move(0, -2)
   elseif self.dir == 'E' then
      self:move(2, 0)
   elseif self.dir == 'S' then
      self:move(0, 2)
   elseif self.dir == 'W' then
      self:move(-2, 0)
   end
end

function Player:move_one()
   if self.dir == 'N' then
      self:move(0, -1)
   elseif self.dir == 'E' then
      self:move(1, 0)
   elseif self.dir == 'S' then
      self:move(0, 1)
   elseif self.dir == 'W' then
      self:move(-1, 0)
   end
end

function Player:set_state(state)
   self.state = state
end

function Player:sneak()
   PLAYER_MOTION_SPEED = 1
end

function Player:walk()
   PLAYER_MOTION_SPEED = 10
end

function Player:trot()
   PLAYER_MOTION_SPEED = 11
end

function Player:power_walk()
   PLAYER_MOTION_SPEED = 13
end

function Player:skip()
   -- TODO make the player jump too
   PLAYER_MOTION_SPEED = 14
end

function Player:jog()
   PLAYER_MOTION_SPEED = 15
end

function Player:run()
   PLAYER_MOTION_SPEED = 20
end

function Player:calculate_vision()
   -- conical 'tile-based' vision from player coordinates in player direction
   if self.vision_type == "xray" or self.vision_type == "crude" then
      if self.omnilook then
	 map.tiles[self.grid_y][self.grid_x]:conical_vision('N', self.vision_range)
	 map.tiles[self.grid_y][self.grid_x]:conical_vision('S', self.vision_range)
	 map.tiles[self.grid_y][self.grid_x]:conical_vision('E', self.vision_range)
	 map.tiles[self.grid_y][self.grid_x]:conical_vision('W', self.vision_range)
      else
	 map.tiles[self.grid_y][self.grid_x]:conical_vision(self.dir, self.vision_range)
      end
   elseif self.vision == "normal" then
      --[[for i=0, 100 do
	 gr.setColor(255,255,255)
	 love.graphics.line(self.grid_x, self.grid_y,
	 self.grid_x + self.vision_range/2,
	 self.grid_y - self.vision_range)
	 end
      ]]
   end
end

function Player:set_draw_mode(draw_mode)
   self.draw_mode = draw_mode
end

function Player:moonwalk()
   if self.dir == 'N' then
      self:move(0, 1)
   elseif self.dir == 'E' then
      self:move(-1, 0)
   elseif self.dir == 'S' then
      self:move(0, -1)
   elseif self.dir == 'W' then
      self:move(1, 0)
   end
end

function Player:push()
   local p, y, x, i = pushable(self.dir, self.grid_x, self.grid_y)
   if p then
      map.tiles[p.grid_y][p.grid_x]:remove_object(i)
      p:move(x, y)
      player:move(x, y)
      map.tiles[p.grid_y][p.grid_x]:insert_object(p)
   end
end

function Player:shove()
   local p, y, x, i = pushable(self.dir, self.grid_x, self.grid_y)
   if p then
      map.tiles[p.grid_y][p.grid_x]:remove_object(i)
      p:move(x, y)
      map.tiles[p.grid_y][p.grid_x]:insert_object(p)
   end
end

function Player:drag()
   log_display = "You no drag!"
   sound_nope:stop()
   sound_nope:play()
end

function Player:escape_level()
   if self.dir == 'N' then
      if map.tiles[self.grid_y - 1][self.grid_x]:is_goal() then
	 self.grid_y = self.grid_y - 1
	 return true
      end
   elseif self.dir == 'E' then
      if map.tiles[self.grid_y][self.grid_x + 1]:is_goal() then
	 self.grid_x = self.grid_x + 1
	 return true
      end
   elseif self.dir == 'S' then
      if map.tiles[self.grid_y + 1][self.grid_x]:is_goal() then
	 self.grid_y = self.grid_y + 1
	 return true
      end
   elseif self.dir == 'W' then
      if map.tiles[self.grid_y][self.grid_x - 1]:is_goal() then
	 self.grid_x = self.grid_x - 1
	 return true
      end
   end
   return false
end

function Player:suicide()
   -- music_suicide:stop()
   -- music_suicide:play()
   -- TODO need to be level specific
   -- parse_map("story/map_" .. player.map)
   -- log_display = "It's a hard life, maybe the next one will be better"
   -- TODO Drop items belonging to this level
end

function Player:grab()
   if not self.inventory:is_full() then
      local item = table.remove(map.tiles[self.grid_y][self.grid_x].items)
      if item then
	 sounds:play("grab")
      else
	 sounds:play("nope")
      end
      self.inventory:add(item)
   else
      log_display = "inventory is full!"
   end
end

function Player:blind()
   BLIND = true
   gr.clear()
   gr.setColor(255, 255, 255, 200)
   gr.setFont(medium_font)
   gr.print("Suddenly everything went black", GRID_SIZE, GRID_SIZE)
end

function Player:blink()
   if self.inventory:contains(1009) then
      local x = math.random(6)
      local y = math.random(6)
      repeat
	 x = math.random(6)
	 y = math.random(6)
	 y = self.grid_y + y - 3
	 x = self.grid_x + x - 3
	 print(x .. "-" .. y)
      until (x > 0 and y > 0) and
	 (y < #map.tiles and x < #map.tiles[1]) and
	 not map.tiles[y][x]:is_massive()
      self:teleport(x, y)
   end
end

function Player:kill()
   table.insert(log_history, 1, "Somehow you managed to die")
   self:suicide()
end

function Player:magnet_update(dt)
   if player.magnet_on then
      -- local vars for calculation
      local x = self.actual_x
      local y = self.actual_y
      local rand_length = 3*GRID_SIZE
      local shift_back = rand_length / 2
      -- if empty (first time), generate 10 particles
      if #self.magnet_particles == 0 then
	 for i=1, 10 do
	    particle = {}
	    particle.x = x + math.random(rand_length) - shift_back
	    particle.y = y + math.random(rand_length) - shift_back
	    table.insert(self.magnet_particles, particle)
	 end
      end
      -- update particles towards player, remove + generate new if close enough
      for i=1, #self.magnet_particles do
	 local m_p = player.magnet_particles[i]
	 m_p.x = (m_p.x - ((m_p.x - player.actual_x)*dt))
      end
   end
end

function Player:update(dt)
   -- update animations
   self.anim_walking:update(dt)

   --[[
   -- update actual drawn coordinates
   self.actual_y = 
      self.actual_y - ((self.actual_y - 
			   (self.grid_y * GRID_SIZE + MAP_OFFSET_Y))
			  * PLAYER_MOTION_SPEED * dt)
   self.actual_x = 
      self.actual_x - ((self.actual_x - 
			   (self.grid_x * GRID_SIZE + MAP_OFFSET_X))
			  * PLAYER_MOTION_SPEED * dt)
   ]]
end

function Player:draw( draw_x, draw_y )
   gr.setColor(255, 255, 255)
   if player.draw_mode == "textured" then
      if self.dir == 'S' then
	 self.anim_walking:draw(draw_x, draw_y,0,1,1,
				0, 0)
      elseif self.dir == 'W' then
	 self.anim_walking:draw(draw_x, draw_y, math.rad(90), 
				1, 1, 0, GRID_SIZE)
      elseif self.dir == 'N' then
	 self.anim_walking:draw(draw_x, draw_y, math.rad(180),
				1, 1, GRID_SIZE, GRID_SIZE)
      elseif self.dir == 'E' then
	 self.anim_walking:draw(draw_x, draw_y, math.rad(270), 
				1, 1, GRID_SIZE, 0)
      end
   elseif player.draw_mode == "reality" then
      gr.rectangle("fill", 
		   player.actual_x,
		   player.actual_y,
		   player.size_x * GRID_SIZE,
		   player.size_y * GRID_SIZE)

      gr.setColor(0, 0, 0)
      gr.rectangle("line", 
		   player.actual_x,
		   player.actual_y,
		   player.size_x * GRID_SIZE,
		   player.size_y * GRID_SIZE)
   elseif player.draw_mode == "wireframe" then
      gr.rectangle("line", 
		   player.actual_x,
		   player.actual_y,
		   player.size_x * GRID_SIZE,
		   player.size_y * GRID_SIZE) 
   elseif player.draw_mode == "matrix" then
      gr.setColor(0x26, 0xAA, 0x2E)
      gr.print("P", 
	       player.actual_x,
	       player.actual_y) 
   elseif player.draw_mode == "angel dust" then
      gr.print("P", 
	       player.actual_x,
	       player.actual_y)
   end
end

