command_history = {}
command = ""

function input_handler(key, isrepeat)
   catch_keys = {escape=1, right=1, left=1, up=1, down=1, lgui=1, lalt=1, lctrl=1, lshift=1}
   
   -- TBD keybuffer   
   if key == "backspace" then
      command = string.sub(command, 1, #command-1)
      c_input_tb:add_line(command)
   elseif key == "return" then
      command_array = utils.match(command, "%S+")
      if commands.table[command_array[1]] then
	 command_history[command_array[1]] = 1
	 commands.table[command_array[1]](command_array)
      end
      c_log_tb:add_line(command)
      command = ""
      c_input_tb:add_line(command)
   elseif catch_keys[key] ~= nil then
      -- key buttons
      if key == "up" then
	 if player.north_arrow then
	    player:move(0,-1, "N")
	    map:clear_tiles()
	 end
      elseif key == "down" then
	 if player.south_arrow then
	    player:move(0,1, "S")
	    map:clear_tiles()
	 end
      elseif key == "left" then
	 if player.west_arrow then
	    player:move(-1,0, "W")
	    map:clear_tiles()
	 end
      elseif key == "right" then
	 if player.east_arrow then
	    player:move(1,0, "E")
	    map:clear_tiles()
	 end
      elseif key == "escape" then
	 log_display = "use 'escape game' to quit!"
      end
   elseif (string.byte(key) > 31 and string.byte(key) < 127) then
      command = command .. key
      c_input_tb:add_line(command)
   end
end
