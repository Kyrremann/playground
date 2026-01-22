world = {}

-- put all this grid stuff in a single file! :DD
local grid_size = 50
local grid_count = 10
local grid_offset = { 50, 100 }
grid = {}

entity = nil  -- player ID

function love.load( arg )
   require("setup")
   require("network_stuff")
   require("square")

   entity = tostring(math.random(9999999))

   network.load(arg)

   -- more grid stuff to put in its own grid.lua
   grid.data = {}
   for i=1, grid_count do
      grid.data[i] = {}
      for i2=1, grid_count do
	 local x = i * grid_size + grid_offset[1]
	 local y = i2 * grid_size + grid_offset[2]
	 grid.data[i][i2] = Square.new(
	    {i, i2},
	    x+(i*2),
	    y+(i2*2),
	    grid_size,
	    grid_size
	 )
      end
   end
   
   title_font = gra.newFont(40)
   font_large = gra.newFont(30)
   font_normal = gra.newFont(20)
   font_normal = gra.newFont(20)
   font_small = gra.newFont(15)
   font_tiny = gra.newFont(10)
   font_vtiny = gra.newFont(8)
end

function love.update(dt)
   network.update(dt) -- get world / data from server
   grid.update(dt)
end

function love.draw()
   -- draw the world
   -- for k, v in pairs(world) do 
   --    love.graphics.print(k, v.x, v.y)
   -- end

   -- draw important title
   gra.setFont(title_font)
   gra.setColor(100,100,100)
   gra.rectangle("fill", 100, 10, 600, 50)
   gra.setColor(0,0,0)
   gra.print("Don't abandon the game", 100, 10)

   gra.setFont(font_large)
   gra.setColor(100,100,100)
   gra.print("Player ID:", 20, 70)
   gra.setColor(150,200,150)
   gra.print(entity, 250, 70)

   gra.setFont(font_normal)
   gra.setColor(150,150,150)
   gra.print("the game grid:", 100, 130)

   gra.setFont(font_normal)
   gra.setColor(150,150,150)
   gra.print("best non-abandoners:", 700, 100)

   grid.draw()
end

function grid.draw()
   for k, v in ipairs(grid.data) do
      for k, v2 in ipairs(v) do
	 v2:draw()
      end
   end

   if grid.hover then
      grid.hover:draw()
   end

   if grid.select then
      grid.select:draw()
   end
end

function grid.update(dt)
   for k, v in ipairs(grid.data) do
      for k, v2 in ipairs(v) do
	 v2:update(dt)
      end
   end

   if grid.hover then
      grid.hover:setColor({200, 200, 200, 255})
   end

   if grid.select then
      grid.select:setColor({255, 255, 255, 255})
   end
end

function love.keypressed(key, isrepeat)
   if key == 'escape' then
      eve.push('quit')
   end
end
