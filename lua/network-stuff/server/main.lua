
local grid = {}
local grid_count = 10

local world = {}
local udp
local data, msg_or_ip, port_or_nil
local entity, cmd, params
local running = true

local activity = {}

function love.conf(t)
   t.window = false
end

function love.load( arg )
   require("setup")
   local socket = require("socket")

   math.randomseed( os.time() )

   --win.setMode(1000, 700, {})

   print("*** SERVER ***")

   ip = "127.0.0.1"
   port = "55555"

   udp = socket.udp()
   udp:settimeout(0)
   udp:setsockname('*', port)

   print("hosting:", ip..":"..port)

   grid.data = {}
   for i=1, grid_count do
      grid.data[i] = {}
      for i2=1, grid_count do
	 grid.data[i][i2] = {}
      end
   end
end

function love.update(dt)

   -- update activity + tag for removal
   for key, val in pairs(activity) do
      val = val - dt
      if val <= 0 then
	 -- removal
	 for k, v in pairs(grid.data) do
	    for k2, v2 in pairs(v) do
	       if v2[1] == val then
		  v2[1] = ""
		  v2[2] = 0
	       end
	    end
	 end
      end
   end

   -- removal
   
   
   if running then
      data, msg_or_ip, port_or_nil = udp:receivefrom()
      if data then
	 entity, cmd, parms = data:match("^(%S*) (%S*) (.*)")
	 if cmd == 'move' then
	    local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
	    assert(x and y) 

	    x, y = tonumber(x), tonumber(y)
	    local ent = world[entity] or {x=0, y=0}
	    world[entity] = {x=ent.x+x, y=ent.y+y}
	 elseif cmd == 'at' then
	    local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
	    assert(x and y)
	    x, y = tonumber(x), tonumber(y)
	    world[entity] = {x=x, y=y}
	 elseif cmd == 'update' then
	    for k, v in pairs(world) do
	       udp:sendto(string.format("%s %s %d %d", k, 'at', v.x, v.y),
			  msg_or_ip,
			  port_or_nil)
	    end

	    for k, v in pairs(grid.data) do
	       for k2, v2 in pairs(v) do
		  if (v2[1] and v2[2]) then
		     udp:sendto(string.format("%s %s %d %d %f",
					      v2[1], 'progress',
					      k, k2, v2[2]),
				msg_or_ip,
				port_or_nil)
		  end
	       end
	    end
	 elseif cmd == 'select' then
	    -- print(data)
	    local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
	    assert(x and y)
	    x, y = tonumber(x), tonumber(y)
	    local square_data = grid.data[x][y]
	    if not grid.data[x][y][1] then
	       grid.data[x][y][1] = entity
	       grid.data[x][y][2] = 0
	    elseif grid.data[x][y][1] == entity then
	       grid.data[x][y][2] = grid.data[x][y][2] + (0.1* dt)
	    end
	    -- print(grid.data[x][y][1],grid.data[x][y][2])
	 elseif cmd == 'quit' then
	    running = false;
	 else
	    print("unrecognised command:", cmd)
	 end

	 -- cleanup loop!
	 activity[entity] = 2

      elseif msg_or_ip ~= 'timeout' then
	 error("Unknown network error: "..tostring(msg))
      end
      socket.sleep(0.01)
   else
      eve.push('quit')
   end
end

function love.draw()
   
end

function love.keypressed(key, isrepeat)
   if key == 'escape' then
      eve.push('quit')
   end
end
