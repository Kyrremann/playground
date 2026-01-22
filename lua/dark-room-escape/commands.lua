commands = {}

commands.table = {
   up = function(arg_array) player:move(0,-1, "N") map:clear_tiles() end,
   down = function(arg_array) player:move(0,1, "S") map:clear_tiles() end,
   left = function(arg_array) player:move(-1,0, "W") map:clear_tiles() end,
   right = function(arg_array) player:move(1,0, "E") map:clear_tiles() end,
   move = function(arg_array) player:move_one() map:clear_tiles() end,
   jump = function(arg_array) player:set_state("jump") map:clear_tiles() end,
   leap = function(arg_array) player:leap() map:clear_tiles() end,
   escape = function(arg_array) commands.escape(arg_array) end,
   sneak = function(arg_array) player:sneak() end,
   jog = function(arg_array) player:jog() end,
   run = function(arg_array) player:run() end,
   skip = function(arg_array) player:skip() end,
   trot = function(arg_array) player:trot() end,
   power_walk = function(arg_array) player:power_walk() end,
   walk = function(arg_array) player:walk() end,
   duck = function(arg_array) player:set_state("duck") end,
   matrix = function(arg_array) player:set_draw_mode("matrix")
      log_display = "matrix style" end,
   reality = function(arg_array) player:set_draw_mode("reality")
      log_display = "back to reality" end,
   wireframe = function(arg_array) player:set_draw_mode("wireframe")
      log_display = "wireframes are always cool"end,
   angel = function(arg_array) commands.angel(arg_array) end,
   textured = function(arg_array) player:set_draw_mode("textured") end,
   look = function(arg_array) commands.look(arg_array) end,
   moonwalk = function(arg_array) player:moonwalk() end,
   push = function(arg_array) commands.push(arg_array) map:clear_tiles() end,
   shove = function(arg_array) commands.shove(arg_array) map:clear_tiles() end,
   turn = function(arg_array) commands.turn(arg_array) map:clear_tiles() end,
   drag = function() player:drag() map:clear_tiles() end,
   suicide = function() player:suicide() map:clear_tiles() end,
   grab = function() player:grab() map:clear_tiles() end,
   select = function(arg_array) commands.select(arg_array) end,
   help = function(arg_array) commands.help(arg_array) end,
   term = function(arg_array) commands.term(arg_array) end,
   terminal = function(arg_array) commands.term(arg_array) end,
   drop = function(arg_array) commands.drop(arg_array) end,
   use = function(arg_array) commands.use(arg_array) end,
   blind = function() player:blind() end,
   volume = function(arg_array) commands.volume(arg_array) end,
   blink = function(arg_array) player:blink() end,
   teleport = function(arg_array) commands.teleport(arg_array) end, 
   music = function(arg_array) commands.music(arg_array) end,
   level = function(arg_array) commands.level(arg_array) end
}

function commands.escape(string_array)
   if #string_array == 1 then
      if player:escape_level() then
	 music_goal:stop()
	 music_goal:play()
	 if player.map == 5 then
	    gr.clear()
	 else
	    table.insert(log_history, 1, "you escaped this level")
	    player.map = player.map + 1
	    parse_map("story/map_" .. player.map)
	 end
      end
   elseif string_array[2] == "dream" then
      player.world = "reality"
      unclear_tiles()
      log_display = "you are now awake!"
   elseif string_array[2] == "reality" then
      player.world = "dream"
      map:clear_tiles()
      log_display = "you are now asleep!"
   elseif string_array[2] == "game" then
      love.event.push('quit')
   elseif string_array[2] == "menu" then
      -- init = true
      game_mode = "menu"
   end
end

function commands.angel(string_array)
   if string_array[2] == "dust" then
      player.matrix = "angel dust"
   end
end

function commands.look(string_array)
   if string_array then
      if #string_array == 1 then
	 -- just 'look'
      elseif #string_array == 2 then
	 if string_array[2] == "inventory" then
	    player.inventory:info()
	    return
	 else
	    commands.turn(string_array)
	    map:clear_tiles()
	 end
      end
   end
   -- look forward
   player:calculate_vision()
end

function commands.turn(string_array)
   if string_array[2] == "north" or string_array[2] == "up" then
      player.dir = "N"
   elseif string_array[2] == "south" or string_array[2] == "down" then
      player.dir = "S"
   elseif string_array[2] == "west" or string_array[2] == "left" then
      player.dir = "W"
   elseif string_array[2] == "east" or string_array[2] == "right" then
      player.dir = "E"
   end
end

function commands.push(string_array)
   if string_array[2] == "north" or string_array[2] == "up" then
      player.dir = "N"
   elseif string_array[2] == "south" or string_array[2] == "down" then
      player.dir = "S"
   elseif string_array[2] == "west" or string_array[2] == "left" then
      player.dir = "W"
   elseif string_array[2] == "east" or string_array[2] == "right" then
      player.dir = "E"
   end
   player:push()
end

function commands.shove(string_array)
   if string_array[2] == "north" or string_array[2] == "up" then
      player.dir = "N"
   elseif string_array[2] == "south" or string_array[2] == "down" then
      player.dir = "S"
   elseif string_array[2] == "west" or string_array[2] == "left" then
      player.dir = "W"
   elseif string_array[2] == "east" or string_array[2] == "right" then
      player.dir = "E"
   end
   player:shove()
end

function commands.select(string_array)
   if string_array then
      if #string_array == 2 then
	 local number = tonumber(string_array[2])
	 if number > 0 and number <= player.inventory.max_space then
	    player.inventory.selector = number
	 else
	    log_display = "nope!"
	 end
      end
   end
end

function commands.drop(string_array)
   if string_array then
      local number = 1
      if #string_array == 1 then
	 number = player.inventory.selector
      elseif #string_array == 2 then
	 number = tonumber(string_array[2])
      end
      local item = player.inventory:remove(number)
      if not item then
	 log_display = "nope!"
	 return
      end
      item.grid_x = player.grid_x
      item.grid_y = player.grid_y
      table.insert(map.tiles[player.grid_y][player.grid_x].items, item)
      player.inventory.selector = 1
      
      sounds:play("drop")
   end
end

function commands.help(string_array)
   if #string_array > 1 then
      if string_array[2] == "help" then
	 log_display = "Shows this help menu"
      elseif string_array[2] == "up" then
	 log_display = "walk one square up"
      elseif string_array[2] == "down" then
	 log_display = "walk one square down"
      elseif string_array[2] == "right" then
	 log_display = "walk one square right"
      elseif string_array[2] == "jump" then
	 log_display = "let you jump, what did you think?"
      elseif string_array[2] == "sneak" then
	 log_display = "makes you walk super slow"
      elseif string_array[2] == "run" then
	 log_display = "makes you run really fast"
      elseif string_array[2] == "skip" then
	 log_display = "every one likes a skiper"
      elseif string_array[2] == "walk" then
	 log_display = "can't always run"
      elseif string_array[2] == "jog" then
	 log_display = "if you can't run, jog"
      elseif string_array[2] == "power_walk" then
	 log_display = "didn't think you would find this one"
      elseif string_array[2] == "trot" then
	 log_display = "fancy pants!"
      elseif string_array[2] == "matrix" then
	 table.insert(log_history, 1, "You take the blue pill, the story ends,")
	 table.insert(log_history, 1, 
		      "you wake up in your bed and believe whatever you want to believe.")
	 table.insert(log_history, 1, "You take the red pill, you stay in Wonderland,")
	 table.insert(log_history, 1, "and I show you how deep the rabbit hole goes.")
	 --[[
      elseif string_array[2] == "" then
	 log_display = "" 
	 ]]
end
else
   local ch = 0
   local ct = 0
   for _ in pairs(command_history) do ch = ch + 1 end
   for _ in pairs(command_table) do ct = ct + 1 end
   table.insert(log_history, 1, "Help menu - used " .. ch .. "/" .. ct)
   table.insert(log_history, 1, "term up/down/top/bottom to scroll")
   table.insert(log_history, 1, "write 'help name' to find more about 'name'")
   end
end

function commands.term(string_array)
   if string_array[2] == "up" then
      log_index = log_index + 1
   elseif string_array[2] == "down" then
      log_index = log_index - 1
      if log_index < 1 then log_index = 1 end
   elseif string_array[2] == "top" then
      log_index = 1
   elseif string_array[2] == "bottom" then
      if #log_history > 7 then
	 log_index = #log_history - 7
      end
   end
end

function commands.use(string_array)
   if string_array then
      if #string_array == 1 then
	 local item = player.inventory.content[player.inventory.selector]
	 if item then
	    item:use()
	 else
	    log_display = "your hands fumble as they try to use each other."
	 end
      elseif #string_array == 2 then
	 local number = tonumber(string_array[2])
	 if type(number) == "number" then
	    local item = player.inventory.content[player.inventory.selector]
	    if item then
	       item:use()
	    else
	       log_display = "your hands fumble as they try to use each other."
	    end
	 else
	    log_display = "Use something from the inventory"
	 end
      end
   end
end

function commands.music(string_array)
   if string_array then
      if #string_array == 1 then
	 -- soundtrack
	 music.table["music1"]:setLooping( true )
	 music:play("music1")
      end
      if #string_array == 2 then
	 local number = tonumber(string_array[2])
	 if number == 1 then
	    -- soundtrack
	    music.table["music1"]:setLooping( true )
	    music:play("music1")
	 elseif string_array[2] == "off" then
	    music:stop("music1")
	 end
      end
   end
end

function commands.volume(string_array)
   if #string_array == 2 then
      if type(tonumber(string_array[2])) == "number" then
	 au.setVolume(tonumber(string_array[2]))
	 log_display = "Volume set to " .. string_array[2]
      else
	 log_display = "volume expects a number"
      end
   end
end

function commands.teleport(string_array)
   if player.inventory:contains(1010) then
      if #string_array == 3 then
	 local x = tonumber(string_array[2])
	 local y = tonumber(string_array[3])
	 if x and y then
	    player:teleport(x, y)
	 end
      end
   end
end

function commands.level(string_array)
   if #string_array == 2 then
      local lvl = tonumber(string_array[2])
      if lvl then
	 -- parse_map("customs/" .. lvl)
	 parse_map("story/map_" .. lvl)
      end
   end
end
