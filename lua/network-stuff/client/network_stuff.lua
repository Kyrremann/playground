network = {}

local updaterate = 0.2 -- how spammy am I?
local t

function network.load(arg)
   local socket = require("socket")

   port = "55555"

   if #arg > 1 then
      domain_ip = socket.dns.toip(arg[2])
   else
      print("\nassuming server = top.duckdns.org\n"..
	       "(this is likely to become abandoned in the future!)\n"..
	       "run command with <servername> as argument to change!")
      domain_ip = socket.dns.toip("top.duckdns.org")
   end
   print("connecting to:", domain_ip ..":"..port)

   udp = socket.udp()
   udp:settimeout(0)
   udp:setpeername(domain_ip, port)

   local dg = string.format("%s %s %d %d", entity, 'at',
			    math.random()*900, math.random()*600)
   udp:send(dg)

   t = 0
end

function network.update(dt)
   t = t + dt

   if t > updaterate then
      local x, y = 0, 0
      
      -- local dg = string.format("%s %s %f %f", entity, 'move', x, y)
      -- udp:send(dg)

      -- send select for square
      if grid.select then
	 local s = grid.select
	 local dg = string.format("%s %s %d %d", entity, 'select',
				  s.idx[1],
				  s.idx[2] )
	 udp:send(dg)
      end

      -- request world data update (bad)
      local dg = string.format("%s %s $", entity, 'update')
      udp:send(dg) 

      t = 0
   end

   repeat
      data, msg = udp:receive()
      
      if data then
	 if math.random() > 0.99 then
	    print("recv_data (random): ", data)
	 end
	 
	 ent, cmd, parms = data:match("^(%S*) (%S*) (.*)")
	 if cmd == 'at' then
	    local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
	    assert(x and y)

	    x, y = tonumber(x), tonumber(y)
	    world[ent] = {x=x, y=y}
	 elseif cmd == 'progress' then
	    local idx_x, idx_y, amount = parms:match("^(%-?[%d.e]*)"
							.." (%-?[%d.e]*)"
							.." (%-?[%d.e]*)$")
	    assert(idx_x and idx_y and amount)

	    idx_x, idx_y = tonumber(idx_x), tonumber(idx_y)
	    amount = tonumber(amount)

	    -- read and overwrite clientside data erytim
	    grid.data[idx_x][idx_y].owner = ent
	    grid.data[idx_x][idx_y].progress = amount
	 else
	    print("unrecognised command:", cmd)
	 end
      elseif msg ~= 'timeout' then 
	 error("Network error (not a timeout): "..tostring(msg))
      end
   until not data
end
