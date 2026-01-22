--[[
   an inventory is just a table of items
]]
Inventory = Class{}

function Inventory:init(amount)
   self.max_space = amount
   self.counter = 0
   self.content = {}
   self.x = gr.getWidth() - 180
   self.y = 100
   self.column_width = 5
   self.selector = 1
   
   self.font = gr.setNewFont("fonts/LilGrotesk-Bold.otf", 16)
   --self.font = gr.setNewFont(16)
end

function Inventory:add(item)
   if not item then
      log_display = "that is not the item you are looking for."
      return
   end
   if self.counter < self.max_space then
      table.insert(self.content, item)
      self.counter = self.counter + 1
      item:activate()
   else
      log_display = "inventory full!"
   end
end

function Inventory:is_full()
   if self.counter == self.max_space then
      return true
   end
   return false
end

function Inventory:remove(selected)
   if not selected then
      log_display = "select val was nil!"
      return
   end
   if self.counter == 0 then
      log_display = "you have no items!"
   elseif selected > self.counter or selected < 1 then
      log_display = "nope!"
   else
      local item = table.remove(self.content, selected)
      self.counter = self.counter - 1
      item:deactivate()
      return item
   end
end

function Inventory:draw()
   -- inventory bg
   gr.setColor(40,40,40)
   gr.rectangle("fill",
		self.x - 10, self.y -30,
		GRID_SIZE*self.column_width + 20,
		GRID_SIZE*math.ceil(self.max_space/self.column_width)+50)
   -- text "inventory"
   gr.setFont(self.font)
   gr.setColor(255,255,255)
   gr.print("Inventory",self.x + 50, self.y - 25)
   -- draw content of inventory
   for i=1, #self.content do
      gr.setColor( 255,255,255 )
      gr.draw( self.content[i].image,
	       self.x + (((i-1) % self.column_width)*GRID_SIZE), 
	       self.y + (math.floor((i -1) / self.column_width))*GRID_SIZE)
   end
   -- draw borders of inventory
   for i=1, self.max_space do
      gr.setColor( 255,255,255 )
      gr.rectangle("line",
		   self.x + (((i-1) % self.column_width)*GRID_SIZE), 
		   self.y + (math.floor((i -1) / self.column_width)*GRID_SIZE),
		   GRID_SIZE, GRID_SIZE)
   end
   
   -- draw selected box
   gr.setColor( 255,0,0 )
   gr.rectangle("line",
		self.x + (((self.selector -1) % self.column_width)*GRID_SIZE), 
		self.y + ((math.floor((self.selector-1) / self.column_width))*GRID_SIZE ),
		GRID_SIZE, GRID_SIZE)
end

function Inventory:info()
   if not (self.selector > self.counter) then
      log_display = self.content[self.selector].info
   else
      log_display = "Wow! absolutely nothing!"
   end
end

function Inventory:contains(id)
   for i=1, #self.content do
      if self.content[i].item_id == id then
	 return true
      end
   end
   return false
end
