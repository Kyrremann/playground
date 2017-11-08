-- deprecated
function update_bullets(dt)
   for i, v in ipairs(BULLETS) do
      v.x = v.x + (v.dx * dt)
      v.y = v.y + (v.dy * dt)

      if v.x > v.targetX
      and v.y > v.targetY then
	 -- only works if target greater then cannon
	 table.remove(BULLETS, i)
	 if it_hit_tower(v.x, v.y) then
	    explode_wall(v.x, v.y)
	 end
      end
   end
end

-- deprecated
function it_hit_tower(x, y)
   x = math.floor(x / SIZE) + 1
   y = math.floor(y / SIZE) + 1

   return is_wall(map[y][x].type)
end

-- deprecated
function explode_wall(x, y)
   x = math.floor(x / SIZE) + 1
   y = math.floor(y / SIZE) + 1
   
   map[y][x].type = "grass"
end
