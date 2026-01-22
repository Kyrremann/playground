menu = {}

function menu.init()
   init = false
   
   -- font used in menu
   menu.title_font = gr.newFont(80)
   menu.menu_font = gr.newFont(20)
   
   menu.selector = 1
   menu.level_selector = 1
   menu.column_width = 5
   menu.element_size = 64
   
   -- fading title
   menu.var = 255
   menu.pulse_speed = 0.5 -- pulses per second
   menu.fade_dir = -1
   
   -- map file handling
   menu.map_dir = "maps/customs"
   menu.level = fs.getDirectoryItems(menu.map_dir)
   
end

function menu.update(dt)
   local fade_amount = 255*(dt*menu.pulse_speed)
   fade_amount = fade_amount * menu.fade_dir
   menu.var = menu.var + fade_amount
   if menu.var <= 100 then
      menu.fade_dir = 1
      menu.var = 100
   elseif menu.var >= 255 then
      menu.fade_dir = -1
      menu.var = 255
   end
end

function menu.draw()
   -- gr.clear()
   gr.setFont(menu.title_font)
   gr.setColor( 255 - menu.var,menu.var - 50,255-menu.var )
   gr.printf("Dark Room Escape!", 100, 50, 600, "center")

   gr.setFont(menu.menu_font)
   gr.setColor(255,255,255, 225)
   if menu.selector == 1 then gr.setColor(255,255,255, 200 + menu.var) end
   gr.printf("Story mode", 100, 300, 600, "center")

   gr.setColor(255,255,255, 225)
   if menu.selector == 2 then gr.setColor(255,255,255, 200 + menu.var) end
   gr.printf("No saving yet", 100, 
	     300 + (menu.menu_font:getHeight() * 1.5), 600, "center")

   gr.setColor(255,255,255, 225)
   if menu.selector == 3 then gr.setColor(255,255,255, 200 + menu.var) end
   gr.printf("Select level", 100, 
	     300 + (menu.menu_font:getHeight() * 3), 600, "center")

   gr.setColor(255,255,255, 225)
   -- if menu.selector == 4 then gr.setColor(255,255,255, 200 + menu.var) end
   local mapname = string.gsub(menu.level[menu.level_selector], ".lua", "")
   gr.printf("< " .. mapname .. " >", 100, 
	     300 + (menu.menu_font:getHeight() * 4), 600, "center")

   gr.setColor(255,255,255, 225)
   if menu.selector == 4 then gr.setColor(255,255,255, 200 + menu.var) end
   gr.printf("Exit", 100, 
	     300 + (menu.menu_font:getHeight() * 5.5), 600, "center")
end

function menu.keypressed(key, unicode)
   if key == "up" then
      menu.selector = menu.selector - 1
      if menu.selector <= 0 then menu.selector = 4 end
   elseif key == "down" then
      menu.selector = menu.selector + 1
      if menu.selector >= 5 then menu.selector = 1 end
   elseif key == "left" then
      if menu.selector == 3 then
	 menu.level_selector = menu.level_selector - 1
	 if menu.level_selector < 1 then 
	    menu.level_selector = #menu.level 
	 end
      end
   elseif key == "right" then
      if menu.selector == 3 then
	 if menu.level_selector < #menu.level then
	    menu.level_selector = menu.level_selector + 1
	 else
	    menu.level_selector = 1
	 end
      end
   elseif key == "escape" then
      ev.push('quit')
   elseif key == "return" then
      if menu.selector == 1 then
	 -- load story maps 
	 local map_filename = "maps/story/map_1.lua"
	 
	 -- TODO restore from savefile here! (level #)
	 
	 -- load map
	 map:load(map_filename)

	 -- start game
	 init = true
	 game_mode = "game"
      elseif menu.selector == 2 then
	 print("TODO: Add saving and loading of progress")
      elseif menu.selector == 3 then
	 -- map filename
	 local map_filename = "maps/customs/" 
	    .. menu.level[menu.level_selector]
	 -- load map
	 map:load(map_filename)
	 
	 -- start game
	 init = true
	 game_mode = "game"
      elseif menu.selector == 4 then
	 ev.push('quit')
      end
   end
end
