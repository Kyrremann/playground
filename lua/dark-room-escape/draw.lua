function drawMap()
   --map:draw()
   for y=1, #map do
      for x=1, #map[y] do
	 map[y][x]:draw()
	 for i, objs in ipairs(map[y][x].objects) do
	    objs:draw()
	 end
      end
   end
end

function drawPlayer()
   --player:draw()
   gr.setColor(255, 255, 255)
   player.player_state_action[player.state]()
end

function drawCmd()
   --command_box:draw()
   love.graphics.setColor(255, 255, 255, 200)
   gr.setFont(medium_font)
   love.graphics.print(command, GRID_SIZE, love.graphics.getHeight() - GRID_SIZE)

   love.graphics.setColor(255, 255, 255, 100)
   gr.rectangle("fill", GRID_SIZE, gr.getHeight() - GRID_SIZE * 1.01, 14 * GRID_SIZE, 2)

   if string.len(log_display) ~= 0 then
      table.insert(log_history, 1, log_display)
      log_display = ""
   end
   
   -- log:draw()
   love.graphics.setColor(255, 255, 255, 200)
   love.graphics.setFont(small_font)
   local count = 0
   for i=log_index, math.min(#log_history, 7 + log_index) do
      gr.print(log_history[i], GRID_SIZE,
	       gr.getHeight() - GRID_SIZE * 1.01 - 20 - count * small_font:getHeight())
      count = count + 1
   end
   -- TODO create history, or multiline log
   -- Story part: 
end

function draw_inventory()
   player.inventory:draw()
end

function draw_magnet_particles()
   if player.magnet_on then
      gr.setColor(100,100,255)
      for i=1, #player.magnet_particles do
	 local magnet_particle = player.magnet_particles[i]
	 gr.point(magnet_particle.x,
		  magnet_particle.y)
      end
   end
end