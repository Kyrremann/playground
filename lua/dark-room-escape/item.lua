--[[
   an item is something in the game world that can be interacted with
   such as grabbing it
]]
-- superclass requires
require "movable"
require "visible"

Item = Class{ __includes = { Movable, Visible } }

function Item:init(x, y, item_id)
   Movable.init(self, x, y)
   Visible.init(self)

   self.item_id = item_id
   
   -- common item definitions
   self.obstructs_vision = false
   self.static = false
   self.massive = false
   self.visible = true
   self.active = false
   
   -- default item
   self.info = "An item. It looks extraordinary."
   self.use_string = "you can't figure out how it works!"
   self.activate_string = "you picked up an item."
   self.state = "none"
   self.image = love.graphics.newImage( "items/magic_loaf_slice.png" )

   -- 1000 flashlight
   if item_id == 1000 then
      self.info = "A flashlight. It's ok"
      self.use_string = "you keep pointing it forward."
      self.activate_string = "you can now see better!"
      self.deactivate_string = "your vision fades!"
      self.image = love.graphics.newImage( "items/flashlight.png" )
   end
   
   -- 1001 lantern
   if item_id == 1001 then
      self.info = "A lantern. It seems ok."
      self.use_string = "you keep holding it up."
      self.activate_string = "you can now see all around yourself!"
      self.deactivate_string = "your vision fades!"
      self.image = love.graphics.newImage( "items/lantern.png" )
   end

   -- 1002 backpack  
   if item_id == 1002 then
      self.info = "A bagpack. It's good."
      self.use_string = "stuff goes here"
      self.activate_string = "you feel more adventurous!"
      self.deactivate_string = "you feel less adventurous."
      self.image = love.graphics.newImage( "items/bagpack.png" )
   end

   -- 1003 arrow_north
   if item_id == 1003 then
      self.info = "An arrow. It points mysteriously to the north."
      self.use_string = "This arrow holds magic powers."
      self.activate_string = "Arrow GET!"
      self.deactivate_string = "You reluctantly let go of the arrow."
      self.image = love.graphics.newImage( "items/arrow_north.png" )
   end

   -- 1004 arrow_east
   if item_id == 1004 then
      self.info = "An arrow. It points mysteriously to the east."
      self.use_string = "This arrow holds magic powers."
      self.activate_string = "Arrow GET!"
      self.deactivate_string = "You reluctantly let go of the arrow."
      self.image = love.graphics.newImage( "items/arrow_east.png" )
   end

   -- 1005 arrow_sourth
   if item_id == 1005 then
      self.info = "An arrow. It points mysteriously to the south."
      self.use_string = "This arrow holds magic powers."
      self.activate_string = "Arrow GET!"
      self.deactivate_string = "You reluctantly let go of the arrow."
      self.image = love.graphics.newImage( "items/arrow_south.png" )
   end

   -- 1006 arrow_west
   if item_id == 1006 then
      self.info = "An arrow. It points mysteriously to the west."
      self.use_string = "This arrow holds magic powers."
      self.activate_string = "Arrow GET!"
      self.deactivate_string = "You reluctantly let go of the arrow."
      self.image = love.graphics.newImage( "items/arrow_west.png" )
   end

   -- 1007 map
   if item_id == 1007 then
      self.info = "It's actually just a blank paper, but you can make it a map!"
      self.use_string = "you scribble on the map a bit, oops got to remake it now!"
      self.activate_string = "An empty map! hooray!"
      self.deactivate_string = "you really dislike paper, so you put the map on the ground"
      self.image = love.graphics.newImage( "items/map.png" )
   end

   -- 1008 wizard hat
   if item_id == 1008 then
      self.info = "A magical hat. Fact: hats can be worn the head."
      self.use_string = "The hat sparkles with all the colors of the rainbow."
      self.activate_string = "A hat!"
      self.deactivate_string = "you put the hat on the ground."
      self.image = love.graphics.newImage( "items/wizard_hat.png" )
   end

   -- 1009 wizard staff
   if item_id == 1009 then
      self.info = "A potentially magical staff. It looks convincing."
      self.use_string = "The staff sparkles and you 'blink' with a dazzling display of colors."
      self.activate_string = "A REAL wizards staff!"
      self.deactivate_string = "you plant the staff firmly in the ground."
      self.image = love.graphics.newImage( "items/wizard_staff.png" )
   end

   -- 1010 spellbook
   if item_id == 1010 then
      self.info = "A spellbook full of fun spells."
      self.use_string = "You flip the pages furiously, whilst chanting randomly."
      self.activate_string = "A book!"
      self.deactivate_string = "you put the book on the ground."
      self.image = love.graphics.newImage( "items/spellbook.png" )
   end

   -- 1011 goal
   if item_id == 1011 then
      self.info = "A gate to the next level"
      self.use_string = "You open the door"
      self.activate_string = "It's just a door"
      self.deactivate_string = "How did you do that?"
      self.image = love.graphics.newImage( "tiles/gate_1.png" )
      self.static = false
      self.obstructs_vision = true
      self.massive = true
   end

   -- 1012 stick
   if item_id == 1012 then
      self.info = "A useless stick. You picked it up somewhere."
      self.use_string = "You wave the stick around... uselessly"
      self.activate_string = "You found a stick!"
      self.deactivate_string = "You decide to drop the stick."
      self.image = love.graphics.newImage( "items/stick.png" )
   end

   -- 1013 magnet
   if item_id == 1013 then
      self.info = "This is a magnet, will attract things if used."
      self.use_string = "You shake the magnet."
      self.activate_string = "You found a magnet!"
      self.deactivate_string = "You drop the magnet."
      self.image = love.graphics.newImage( "items/magnet.png" )
   end

end

-- called by command 'use <item_name>'
function Item:use()
   log_display = self.use_string
   
   if self.item_id == 1013 then
      if self.magnet_on == false then
	 log_display = "you turn the magnet on!"
	 player.magnet_on = true
      else
	 log_display = "you turn the magnet off!"
	 player.magnet_on = false
      end
   end
end

-- called when picked up
function Item:activate()
   log_display = self.activate_string
   
   if self.item_id == 1000 then
      player.vision_range = player.vision_range + 3
      player.always_looking = player.always_looking + 1
   end

   if self.item_id == 1001 then
      player.vision_range = player.vision_range - 2
      player.always_looking = player.always_looking + 1
      player.omnilook = true
   end
   
   if self.item_id == 1002 then
      player.inventory.max_space = 20
   end

   if self.item_id == 1003 then
      player.north_arrow = true
   end

   if self.item_id == 1004 then
      player.east_arrow = true
   end
   
   if self.item_id == 1005 then
      player.south_arrow = true
   end

   if self.item_id == 1006 then
      player.west_arrow = true
   end

   if self.item_id == 1007 then
      player.remember = true
   end

end

function Item:deactivate()
   if self.deactivate_string then
      log_display = self.deactivate_string
   end
   
   if self.item_id == 1000 then
      player.vision_range = player.vision_range - 3
      player.always_looking = player.always_looking - 1
      map:clear_tiles()
   end

   if self.item_id == 1001 then
      player.vision_range = player.vision_range + 2
      player.always_looking = player.always_looking - 1
      player.omnilook = false
      map:clear_tiles()
   end
   
   if self.item_id == 1002 then
      for i=1, player.inventory.counter do
	 commands.drop({1})
      end
      player.inventory.max_space = 1

      sounds:play("negative")
   end

   if self.item_id == 1003 then
      player.north_arrow = false
   end

   if self.item_id == 1004 then
      player.east_arrow = false
   end
   
   if self.item_id == 1005 then
      player.south_arrow = false
   end

   if self.item_id == 1006 then
      player.west_arrow = false
   end

   if self.item_id == 1007 then
      player.remember = false
   end

end

function Item:use()
   if self.use_string then
      log_display = self.use_string
   end
   
   if self.item_id == 1007 then
      player.remember = false
      map:clear_tiles()
      player.remember = true
      
      sounds:play("negative")
   end
end

function Item:look()
   log_display = self.info
end

function Item:draw( draw_x, draw_y )
   if self.visible then
      gr.setColor( 255,255,255 )
      gr.draw( self.image, draw_x, draw_y)
   end
end
